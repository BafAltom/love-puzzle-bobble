require "variables"

world = {}
world.leftWall = uiSize
world.rightWall = wScr - uiSize
world.ceiling = 0

world.timer = 0
world.update = function(world, dt)
	world.timer = world.timer + dt
	if (world.timer >= ceilingDropTime) then
		world.ceiling = world.ceiling + ceilingDropSize
		world.timer = 0
	end
end

world.draw = function(world)
	love.graphics.setColor(20,20,20)
	love.graphics.rectangle("fill", world.leftWall, 0, (world.rightWall - world.leftWall), world.ceiling)
	love.graphics.setColor(255,255,255)
	love.graphics.line(world.leftWall, 0, world.leftWall,hScr)
	love.graphics.line(world.rightWall, 0, world.rightWall,hScr)
end