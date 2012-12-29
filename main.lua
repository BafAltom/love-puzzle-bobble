

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

	for i=1,5 do
		local _randX = math.random(world.leftWall, world.rightWall)
		local _randY = math.random(world.ceiling, hScr-playerRadius)
		table.insert(player.bullets, BubbleBulletClass.new(player, _randX, _randY, getRandomColor()))
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