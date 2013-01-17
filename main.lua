function love.load()

	require "variables"
	require "ressources"
	require "bafaltom2D"
	require "BubbleClass"
	require "PlayerClass"
	require "BubbleBulletClass"
	require "world"
	require "menu"

	xOffset = 0
	yOffset = 0
	PAUSE = false

	bubbles:initialize()
end

function love.update(dt)
	if (not menu.startScreen.gameStart) then
		menu.startScreen:update(dt)
	elseif (world.triggerWin) then
		menu.winScreen:update(dt)
	elseif(world.triggerLost) then
		menu.lostScreen:update(dt)
	else
		-- world (walls, ceiling & bubbles)
		world:update(dt)
		-- player
		player:update(dt)
	end
end

function love.draw()
	if (not menu.startScreen.gameStart) then
		menu.startScreen:draw()
	elseif (world.triggerWin) then
		menu.winScreen:draw()
	elseif(world.triggerLost) then
		menu.lostScreen:draw()
	else
		world:draw()
		player:draw()
	end
end

function love.mousereleased(x,y,b)
	if (menu.startScreen.gameStart) then
		if (b == "l") then
			player:shoot(x,y)
		elseif (b == "wu") then
			-- precision aiming (TODO)
		elseif (b == "wd") then
			player.nextBulletColor = getRandomColor()
		end
	end
end

function love.keyreleased(k)
	if (not menu.startScreen.gameStart) then
		menu.startScreen:keyreleased(k)
	elseif (world.triggerWin) then
		menu.winScreen:keyreleased(k)
	elseif(world.triggerLost) then
		menu.lostScreen.keyreleased(k)
	else
		if (k == "d") then
			bubbles:printTree()
		elseif (k == "p") then
			DEBUG = not DEBUG
		elseif (k == "k") then
			-- kill all bubbles
			for _,b in ipairs(bubbles) do
				b:triggerDead()
			end
		end
	end
end