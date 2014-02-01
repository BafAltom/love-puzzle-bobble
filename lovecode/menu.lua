require "world"
require "BubbleClass"
menu = {}

menuOptionClass = {}

menuOptionClass.new = function(text, action)
	option = {}
	setmetatable(option, {__index = menuOptionClass})

	option.text = text
	option.action = action

	return option
end

-----------------------------------------------------

menu.startScreen = {}

menu.startScreen.gameStart = false
menu.startScreen.displayText = false
menu.startScreen.text = ""

menu.startScreen.circles = {}
menu.startScreen.circles.radius = 50
for i=1,50 do
	local _r = menu.startScreen.circles.radius
	local _c = bubbleColors[getRandomColor()]
	table.insert(menu.startScreen.circles, {math.random(0,wScr), math.random(0, hScr), {_c[1], _c[2], _c[3], 100}})
end

menu.startScreen.launchGame = function(sS)
	music_menu:stop()
	if (not love.web) then music_game:play() end
	sS.gameStart = true
end

menu.startScreen.exit = function(sS)
	love.event.push("quit")
end

menu.startScreen.displayInstructions = function(sS)
	sS.text = "Goal :\nMatch bubbles of the same colors\n\nInstructions:\nUse mouse to aim\nLeft click to shoot"
	sS.displayText = true
end

menu.startScreen.displayCredits = function(sS)
	sS.text = "Made by Altom for the OGAM challenge\n\nMusic by Shawn Bayern\n(CC BY-NC-SA 3.0)\n\nFont by Felix Braden\nDedicated to a pretty Cookie"
	sS.displayText = true
end

menu.startScreen.draw = function(sS)
	love.graphics.setColor(100,100,255)
	love.graphics.rectangle("fill", 0,0,wScr,hScr)

	for i,c in ipairs(sS.circles) do
		love.graphics.setColor(c[3])
		love.graphics.circle("fill", c[1], c[2], sS.circles.radius, sS.circles.radius/2)
	end

	love.graphics.setColor(255,255,100)
	love.graphics.setFont(font_bigfish_large)
	love.graphics.printf("BubblePÖP", wScr*0.25, hScr/5, wScr*0.5, "center")
	love.graphics.setFont(font_bigfish_small)
	love.graphics.printf("A game with bubbles", 0, hScr/5 + 80, wScr, "center")

	if (sS.displayText) then
		love.graphics.setFont(font_bigfish_small)
		love.graphics.setColor(0,0,0)
		love.graphics.printf(sS.text, wScr/4, hScr/5 + 150, wScr/2, "center")
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(font_bigfish_medium)
		love.graphics.printf("RETURN", 0, hScr - 50, wScr, "center")
	else
		love.graphics.setFont(font_bigfish_medium)
		for i,o in ipairs(sS.options) do
			if (i == sS.options.selected) then
				love.graphics.setColor(255,255,255)
			else
				love.graphics.setColor(0,0,0)
			end
			love.graphics.printf(o.text, wScr*0.33, hScr/2 + i*40, wScr*0.33, "center")
		end
	end
end

menu.startScreen.update = function(sS, dt)
	for i,c in ipairs(sS.circles) do
		c[2] = c[2] - 50*dt
		if (c[2] < -sS.circles.radius) then
			local _r = sS.circles.radius
			c[1] = math.random(0,wScr)
			c[2] = hScr + math.random(_r, 2*_r)
		end
	end
end

menu.startScreen.keypressed = function(sS, k)
    if(k == "up") then
        sound_bounce:play()
        sS.options.selected = math.max(1, sS.options.selected - 1)
    elseif(k == "down") then
        sound_bounce:play()
        sS.options.selected = math.min(#sS.options, sS.options.selected + 1)
    end
end

menu.startScreen.keyreleased = function(sS, k)
	if (k == "return") then
		sound_shoot:play()
		if (sS.displayText) then
			sS.displayText = false
		else
			sS.options[sS.options.selected].action(sS)
		end
    elseif(k == "escape") then
        love.event.quit()
	end
end

menu.startScreen.options = {}
menu.startScreen.options.selected = 1
menu.startScreen.options[1] = menuOptionClass.new("Start Game", menu.startScreen.launchGame)
menu.startScreen.options[2] = menuOptionClass.new("Instructions", menu.startScreen.displayInstructions)
menu.startScreen.options[3] = menuOptionClass.new("Credits", menu.startScreen.displayCredits)
menu.startScreen.options[4] = menuOptionClass.new("Exit", menu.startScreen.exit)

-----------------------------------------------------

menu.winScreen = {}

menu.winScreen.timer = 3

menu.winScreen.draw = function()
	love.graphics.setColor(100,100,255)
	love.graphics.rectangle("fill", 0,0,wScr,hScr)

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(font_bigfish_large)
	love.graphics.printf("LEVEL CLEAR!", 0, hScr/4, wScr, "center")
	love.graphics.setFont(font_bigfish_medium)
	love.graphics.printf("New game in "..math.ceil(menu.winScreen.timer).. " s (or press SPACE)", 0, 3*hScr/4, wScr, "center")
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

menu.lostScreen.draw = function(lS)
	love.graphics.setColor(100,100,255)
	love.graphics.rectangle("fill", 0,0,wScr,hScr)

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(font_bigfish_large)
	love.graphics.printf("YOU LOST", 0, hScr/4, wScr, "center")
	love.graphics.setFont(font_bigfish_small)
	love.graphics.printf("Press SPACE to go back to the main menu", 0, 3*hScr/4, wScr, "center")
end

menu.lostScreen.update = function(lS, dt)
end

menu.lostScreen.keyreleased = function(lS, k)
	if (k == " ") then
		world.triggerLost = false
		menu.startScreen.gameStart = false
	end
end
