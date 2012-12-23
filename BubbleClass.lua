require "variables"

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
end

BubbleClass.draw = function(bubble)
	love.graphics.circle("fill", bubble:getX(), bubble:getY(), bubble:size())
end

BubbleClass.isRoot = function(bubble)
	return (bubble.father == nil)
end

BubbleClass.size = function(bubble)
	return bubbleSize
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
		return bubble:size()/2.0
	else
		-- trigonometry, deal with it
		return bubble.father:getY() + math.sin(bubble.angle)*(bubble:size() + bubble.father:size())
	end
end

-------------------------------------------------------------------

BubbleClass.newRoot = function(x)
	return BubbleClass.new(nil, nil, x)
end

BubbleClass.newChild = function(f,a)
	return BubbleClass.new(f,a,nil)
end

BubbleClass.new = function(father, angle, x)
-- do not use directly, use one of the 2 constructors above (root/child)
-- angles are in radians
	assert ((father == nil and angle == nil and x ~= nil) or (father ~= nil and angle ~= nil and x == nil))
	local bubble = {}
	setmetatable(bubble, {__index = BubbleClass})

	bubble.id = BubbleClass.getNextID()
	bubble.father = nil
	bubble.x = nil
	bubble.angle = nil

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
	for n,c in ipairs(coins) do
		if(c.id == id) then
			table.remove(coins, n)
			return
		end
	end
	error("bubbles.removeID : id "..id.." not found")
end
