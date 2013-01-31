require "variables"

world = {}

world.level = 1

world.initialize = function(world)
	world.leftWall = uiSize
	world.rightWall = wScr - uiSize

	world.ceiling = 0
	world.ceilTimer = 0

	world.triggerWin = false
	world.triggerLost = false
end

world.levelUp = function(world)
	if (world.level < maxLevel) then
		world.level = world.level + 1
	end
end

world:initialize()

world.update = function(world, dt)
	world.ceilTimer = world.ceilTimer + dt
	if (world.ceilTimer >= ceilingDropTime[world.level]) then
		world.ceiling = world.ceiling + ceilingDropSize[world.level]
		world.ceilTimer = 0
	end

	-- bubbles
	for k,b in ipairs(bubbles) do
		b:update(dt)
	end
	-- check for lost condition
	for k,b in ipairs(bubbles) do
		if (not b.dead and b:getY() > player:getY()) then
			world.triggerLost = true
		end
	end
	-- remove "lost" bubbles
	for _,bid in ipairs(bubblesIdToRemove) do
		bubbles.removeID(bid)
	end
	bubblesIdToRemove = {}

	if (#bubbles == 0) then
		world.triggerWin = true
	end
end

world.draw = function(world)
	-- background
	love.graphics.setColor(20,20,50)
	love.graphics.rectangle("fill",0,0,wScr, hScr)

	-- ceiling
	love.graphics.setColor(50,100,100)
	love.graphics.rectangle("fill", world.leftWall, 0, (world.rightWall - world.leftWall), world.ceiling)
	-- left wall
	love.graphics.setColor(50,100,100)
	love.graphics.rectangle("fill",0,0,world.leftWall,hScr)
	love.graphics.setColor(0,0,0)
	love.graphics.line(world.leftWall, 0, world.leftWall,hScr)
	-- right wall
	love.graphics.setColor(50,100,100)
	love.graphics.rectangle("fill",world.rightWall,0,uiSize,hScr)
	love.graphics.setColor(0,0,0)
	love.graphics.line(world.rightWall, 0, world.rightWall,hScr)

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(font_bigfish_small)
	love.graphics.print("Level : "..world.level, 10, 10)

	-- bubbles
	for _,b in ipairs(bubbles) do
		b:draw()
	end

	love.graphics.setColor(150, 100, 100)

	love.graphics.line(world.leftWall, hScr-bubbleYLimit, world.rightWall, hScr-bubbleYLimit)

end