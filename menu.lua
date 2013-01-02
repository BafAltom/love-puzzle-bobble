require "world"
require "BubbleClass"
menu = {}

-----------------------------------------------------

menu.startScreen = {}

menu.startScreen.gameStart = false

menu.startScreen.draw = function(sS)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0,0,wScr,hScr)

	love.graphics.setColor(255,255,255)
	love.graphics.print("BubblePÖP\nPress SPACE to begin", wScr/2, hScr/2)
end

menu.startScreen.update = function(sS, dt)

end

menu.startScreen.keyreleased = function(sS, k)
	if (k == " ") then
		sS.gameStart = true
	end
end

-----------------------------------------------------

menu.winScreen = {}

menu.winScreen.timer = 3

menu.winScreen.draw = function()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0,0,wScr,hScr)

	love.graphics.setColor(255,255,255)
	love.graphics.print("WIN\nNew game in "..math.ceil(menu.winScreen.timer).. " s (or press SPACE)", wScr/2, hScr/2)
end

menu.winScreen.update = function(wS, dt)
	if (wS.timer > 0) then
		wS.timer = wS.timer - dt
	else
		wS:launchNewGame()
	end
end

menu.winScreen.launchNewGame = function(wS, dt)
	wS.timer = 3
	world:initialize()
	world:levelUp()
	bubbles:initialize()
end

menu.winScreen.keyreleased = function(wS, k)
	if (k == " ") then
		wS:launchNewGame()
	end
end

-------------------------------------------------------

menu.lostScreen = {}

menu.lostScreen.draw = function()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0,0,wScr,hScr)

	love.graphics.setColor(255,255,255)
	love.graphics.print("LOST", wScr/2, hScr/2)
end