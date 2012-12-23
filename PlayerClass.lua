require "variables"

PlayerClass = {}

-- STATIC ATTRIBUTES

PlayerClass.nextID = 0

-- STATIC METHODS

PlayerClass.getNextID = function()

	PlayerClass.nextID = PlayerClass.nextID + 1
	return PlayerClass.nextID

end

-- CLASS METHODS

PlayerClass.update = function(player, dt)
end

PlayerClass.draw = function(player)
	love.graphics.circle("fill", player:getX(), player:getY(), player:size())
	local _mouseX, _mouseY = love.mouse.getPosition()
	love.graphics.line(wScr/2, hScr, _mouseX, _mouseY)
end

PlayerClass.size = function(player)
	return playerSize
end

PlayerClass.getX = function(player)
	return wScr/2
end

PlayerClass.getY = function(player)
	return hScr
end

PlayerClass:shoot(x,y)

	

end

-------------------------------------------------------------------

PlayerClass.new = function()
	local player = {}
	setmetatable(player, {__index = PlayerClass})

	player.id = PlayerClass.getNextID()
	return player
end

---------------------------------------------------------------

player = PlayerClass.new()