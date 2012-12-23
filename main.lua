

function love.load()

	require "variables"
	require "BubbleClass"
	require "PlayerClass"

	xOffset = 0
	yOffset = 0
	PAUSE = false

	table.insert(bubbles, BubbleClass.newRoot(wScr/2))
end

function love.draw()
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