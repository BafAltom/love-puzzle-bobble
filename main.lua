

function love.load()

	require "variables"
	require "ressources"
	require "bafaltom2D"
	require "BubbleClass"
	require "PlayerClass"
	require "BubbleBulletClass"
	require "world"

	xOffset = 0
	yOffset = 0
	PAUSE = false

	for i =1,math.floor(wWorld/(2*bubbleRadius) - 2) do
		local newBubble = BubbleClass.newRoot((world.leftWall+(1+2*(i-1))*bubbleRadius), getRandomColor())
		local bubChild = nil
		table.insert(bubbles, newBubble)
		while (math.random() < bubbleInit_ProbaChild) do
			bubChild = BubbleClass.newChild(newBubble, (math.pi/3), getRandomColor())
			table.insert(bubbles, bubChild)
			newBubble = bubChild
		end
	end
end

function love.update(dt)

	-- world (wall & ceiling)
	world:update(dt)

	-- bubbles
	for k,b in ipairs(bubbles) do
		b:update(dt)
	end
	for _,bid in ipairs(bubblesIdToRemove) do
		bubbles.removeID(bid)
	end
	bubblesIdToRemove = {}

	-- player
	player:update(dt)
end

function love.draw()
	world:draw()
	player:draw()

	for _,b in ipairs(bubbles) do
		b:draw()
	end
end

function love.mousereleased(x,y,b)
	if (b == "l") then
		player:shoot(x,y)
	elseif (b == "wu") then
		-- precision aiming (TODO)
	elseif (b == "wd") then
		-- precision aiming (TODO)
	end
end

function love.keyreleased(k)
	if (k == "d") then
		bubbles:printTree()
	elseif (k == "p") then
		DEBUG = not DEBUG
	end
end