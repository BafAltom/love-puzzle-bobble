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
	if (bubble.colorMatchCount >= (bubbleSequenceSize - 1)) then
		bubble:triggerDead()
	end

	if (not bubble:isRoot() and not bubble.dead) then
		if (bubble.father.dead) then bubble.dead = true end
	end

	if (bubble.dead) then
		bubble.deadOffsetSpeed = bubble.deadOffsetSpeed + bubbleDeadDropAcc*dt
		bubble.deadOffset = bubble.deadOffset + bubble.deadOffsetSpeed*dt
		if (bubble:getY() > hScr + bubbleRadius) then
			table.insert(bubblesIdToRemove, bubble.id)
			if (not bubble:isRoot()) then
				bubble.father:removeChild(bubble.id)
			end
		end
	end
end

BubbleClass.isChildOf = function(bubble,candidateFatherBubble)
	for _,bubChild in ipairs(candidateFatherBubble.children) do
		if (bubble.id == bubChild.id) then return true end
	end
	return false
end

BubbleClass.removeChild = function(bubble, childID)
	for n,bubChild in ipairs(bubble.children) do
		if (bubChild.id == childID) then
			table.remove(bubble.children, n)
			break
		end
	end
end

BubbleClass.addMatch = function(bubble, matchedBubble)
	if (bubble.colorMatchDict[matchedBubble] == nil) then
		bubble.colorMatchDict[matchedBubble] = true
		bubble.colorMatchCount = bubble.colorMatchCount + 1
	end
end

BubbleClass.searchForColorMatch = function(bubble)
	for _,eachB in ipairs(bubbles) do
		if (distance2Entities(bubble, eachB) <= (2.5*bubbleRadius)
		and bubble:sameColorAs(eachB)) then
			-- match this bubble
			bubble:addMatch(eachB)
			-- match this bubble's matches
			for bubMatch in pairs(eachB.colorMatchDict) do
				bubble:addMatch(bubMatch)
			end
			-- match ourself for the other bubble
			eachB:addMatch(bubble)
		end
	end
end

BubbleClass.draw = function(bubble)
	local _col = bubbleColors[bubble.color]
	love.graphics.setColor(_col[1], _col[2], _col[3])
	love.graphics.circle("fill", bubble:getX(), bubble:getY(), bubble:size()) 

	if (DEBUG) then
		-- parent line
		for _,eachChild in ipairs(bubble.children) do
			love.graphics.setColor(0,0,0)
			love.graphics.line(bubble:getX(), bubble:getY(), eachChild:getX(), eachChild:getY())
		end
		-- internal status
		love.graphics.setColor(0,0,0)
		love.graphics.print(bubble.id.."\n"..bubble.colorMatchCount, bubble:getX(), bubble:getY() - 10)
	end
	if (bubble.dead) then
		love.graphics.setColor(255,255,255, 100)
		love.graphics.circle("line", bubble:getX(), bubble:getY(), bubble:size())
	end
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
		return bubble:size() + world.ceiling + bubble.deadOffset
	else
		-- trigonometry, deal with it
		return bubble.father:getY() + math.sin(bubble.angle)*(bubble:size() + bubble.father:size()) + bubble.deadOffset
	end
end

BubbleClass.triggerDead = function(bubble)
	if (bubble.dead == false) then
		bubble.dead = true

		-- initial speed
		bubble.deadOffsetSpeed = bubbleDropInitialSpeed + math.random(-bubbleDropInitSpeedNoise/2, bubbleDropInitSpeedNoise/2)

		-- make the near match die too
		for bubMatch in pairs(bubble.colorMatchDict) do
			bubMatch:triggerDead()
		end
	end
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
	local _maxSlot = (world.rightWall + bubbleRadius)/(2*bubbleRadius)
	local _minSlot = (world.leftWall + bubbleRadius)/(2*bubbleRadius)
	local _slot = round(x/(2*bubbleRadius))
	_slot = math.max(_minSlot, _slot)
	_slot = math.min(_maxSlot, _slot)
	return _slot*2*bubbleRadius
end

BubbleClass.nearestAcceptedAngle = function(a)
	local _slot = round(a/(math.pi/3))
	return (_slot*(math.pi/3))
end

BubbleClass.busySlot = function(x,y, bubbleCollections)
	for _, b in ipairs(bubbleCollections) do
		if (b:getX() == x and b:getY() == y) then
			return true
		end
	end
	return false
end

BubbleClass.newRoot = function(x,c)
	assert (not BubbleClass.busySlot(x,0, bubbles), "There is already a bubble here!")
	local _newX = BubbleClass.nearestAcceptedX(x)
	return BubbleClass.new(nil, nil, _newX,c)
end

BubbleClass.newChild = function(f,a,c)
	local _newA = BubbleClass.nearestAcceptedAngle(a)
	assert (not BubbleClass.busySlot(
		f:getX() + math.cos(_newA)*(bubbleRadius + f:size()),
		f:getY() + math.cos(_newA)*(bubbleRadius + f:size()),
		bubbles), "There is already a bubble here!")
	child = BubbleClass.new(f,_newA,nil,c)
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
	bubble.father = nil -- do not trust this too much, only contains one father
	bubble.x = nil
	bubble.angle = nil
	bubble.color = color
	bubble.dead = false
	bubble.deadOffset = 0
	bubble.deadOffsetSpeed = 0

	if (father ~= nil) then
		bubble.father = father
		bubble.angle = angle
	elseif (x ~= nil) then
		bubble.x = x
	end
	bubble.children = {}

	bubble.colorMatchDict = {} -- dictionary with bubble as key and true/nil as value
	bubble.colorMatchCount = 0
	bubble:searchForColorMatch()
	return bubble
end

---------------------------------------------------------------

bubbles = {}
bubblesIdToRemove = {}

bubbles.getID = function(id)
	for _, b in ipairs(bubbles) do
		if (b.id == id) then
			return b
		end
	end
	return nil
end

bubbles.removeID = function(id)
	for n,b in ipairs(bubbles) do
		if(b.id == id) then
			table.remove(bubbles, n)
			return
		end
	end
	print("id "..id.." not found")
end

bubbles.printTree = function(bubbleList)
	for _,b in ipairs(bubbleList) do
		if (b:isRoot()) then
			print(b:asString(0))
		end
	end
	print "-----"
end

bubbles.initialize = function()
	for i =1,math.floor(wWorld/(2*bubbleRadius) - 2) do
		local newBubble = BubbleClass.newRoot((world.leftWall+(1+2*(i-1))*bubbleRadius), getRandomColor())
		local bubChild, angle = nil, nil
		table.insert(bubbles, newBubble)
		while (math.random() < bubbleInit_ProbaChild[world.level]) do
			-- choose angle of the child
			angle = (math.random() < 0.5) and math.pi/3 or 2*(math.pi/3) -- basically : choose one of the two randomly
			if (newBubble:getX() < world.leftWall + 2*bubbleRadius) then
				angle = (math.pi/3)
			elseif (newBubble:getX() > world.rightWall - 2*bubbleRadius) then
				angle = 2*(math.pi/3)
			end
			-- generate child
			bubChild = BubbleClass.newChild(newBubble, angle, getRandomColor())
			table.insert(bubbles, bubChild)
			newBubble = bubChild
		end
	end
end