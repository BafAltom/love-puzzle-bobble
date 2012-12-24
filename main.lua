

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

	table.insert(bubbles, BubbleClass.newRoot(wScr/2, getRandomColor()))
end

function love.update(dt)
	world:update(dt)
	player:update(dt)

	for _,b in ipairs(bubbles) do
		b:update(dt)
	end
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
	end
end