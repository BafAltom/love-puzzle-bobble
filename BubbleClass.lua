require "variables"
require "world"

BubbleClass = {}

-- STATIC ATTRIBUTES

BubbleClass.nextID = 0

-- STATIC METHODS

BubbleClass.getNextID = function()

	BubbleClass.nextID = BubbleClass.nextID + 1
	return BubbleClass.nextID

end

-- CLASS METHODS

BubbleClass.update = function(bubble, dt)
	if (bubble:numberOfSameColorChild() >= (bubbleSequenceSize - 1)) then
		bubble:recursiveRemove()
	end
end

BubbleClass.numberOfSameColorChild = function(bubble)
	cnt = 0
	for _,bubChild in ipairs(bubble.children) do
		if (bubChild:sameColorAs(bubble)) then
			cnt = cnt + 1 + bubChild:numberOfSameColorChild()
		end
	end
	return cnt
end

BubbleClass.draw = function(bubble)
	love.graphics.setColor(bubbleColors[bubble.color])
	love.graphics.circle("fill", bubble:getX(), bubble:getY(), bubble:size()) 
end

BubbleClass.isRoot = function(bubble)
	return (bubble.father == nil)
end

BubbleClass.size = function(bubble)
	return bubbleRadius
end

BubbleClass.sameColorAs = function(thisBubble, anotherBubble)
	return thisBubble.color == anotherBubble.color
end

BubbleClass.getX = function(bubble)
	if (bubble:isRoot()) then
		return bubble.x
	else
		-- trigonometry, deal with it
		return bubble.father:getX() + math.cos(bubble.angle)*(bubble:size() + bubble.father:size())
	end
end

BubbleClass.getY = function(bubble)
	if (bubble:isRoot()) then
		return bubble:size() + world.ceiling
	else
		-- trigonometry, deal with it
		return bubble.father:getY() + math.sin(bubble.angle)*(bubble:size() + bubble.father:size())
	end
end

BubbleClass.recursiveRemove = function(bubble)
	for _,b in ipairs(bubble.children) do
		b:recursiveRemove()
	end
	bubbles.removeID(bubble.id)
end

BubbleClass.asString = function(bubble, level)
	text = ""
	for i=1,level do
		text = text.."\t"
	end
	text = text..bubble.id..","..bubble.color.."\n"
	for _,bubChild in ipairs(bubble.children) do
		text = text..bubChild:asString(level+1)
	end
	return text
end
-------------------------------------------------------------------

BubbleClass.nearestAcceptedX = function(x)
	local _slot = round(x/(2*bubbleRadius))
	return bubbleRadius + (_slot*2*bubbleRadius)
end

BubbleClass.nearestAcceptedAngle = function(a)
	print ":-)"
end

BubbleClass.newRoot = function(x,c)
	return BubbleClass.new(nil, nil, x,c)
end

BubbleClass.newChild = function(f,a,c)
	child = BubbleClass.new(f,a,nil,c)
	table.insert(f.children, child)
	return child

end

BubbleClass.new = function(father, angle, x, color)
-- do not use directly, use one of the 2 constructors above (root/child)
-- angles are in radians
	assert ((father == nil and angle == nil and x ~= nil) or (father ~= nil and angle ~= nil and x == nil))
	local bubble = {}
	setmetatable(bubble, {__index = BubbleClass})

	bubble.id = BubbleClass.getNextID()
	bubble.father = nil
	bubble.x = nil
	bubble.angle = nil
	bubble.color = color

	if (father ~= nil) then
		bubble.father = father
		bubble.angle = angle
	elseif (x ~= nil) then
		bubble.x = x
	end

	bubble.children = {}
	return bubble
end

---------------------------------------------------------------

bubbles = {}

bubbles.getID = function(id)
	for _, b in ipairs(bubbles) do
		if (b.id == id) then
			return b
		end
	end
	error("bubbles.getID : id "..id.." not found")
	return nil
end

bubbles.removeID = function(id)
	for n,b in ipairs(bubbles) do
		if(b.id == id) then
			table.remove(bubbles, n)
			return
		end
	end
	error("bubbles.removeID : id "..id.." not found")
end

bubbles.printTree = function(bubbleList)
	for _,b in ipairs(bubbleList) do
		if (b:isRoot()) then
			print(b:asString(0))
		end
	end
	print "-----"
end
