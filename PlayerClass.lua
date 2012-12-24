require "variables"
require "BubbleBulletClass"

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

	local _mx, _my = love.mouse.getPosition()
	player.orientation = bafaltomAngle(player:getX(), player:getY(), _mx, _my)

	for _, bb in ipairs(player.bullets) do
		bb:update(dt)
	end
end

PlayerClass.draw = function(player)
	love.graphics.setColor(bubbleColors[player.nextBulletColor])
	love.graphics.circle("fill", player:getX(), player:getY(), player:size())
	love.graphics.line(player:getX(), player:getY(), player:getX()+math.cos(player.orientation)*100, player:getY() + math.sin(player.orientation)*100)

	for _, bb in ipairs(player.bullets) do
		bb:draw()
	end
end

PlayerClass.size = function(player)
	return playerRadius
end

PlayerClass.getX = function(player)
	return wScr/2
end

PlayerClass.getY = function(player)
	return hScr
end

PlayerClass.shoot = function(player, x,y)
	sound_shoot:play()
	table.insert(player.bullets, BubbleBulletClass.new(player, x,y,player.nextBulletColor))
	player.nextBulletColor = getRandomColor()
end

-------------------------------------------------------------------

PlayerClass.new = function()
	local player = {}
	setmetatable(player, {__index = PlayerClass})

	player.id = PlayerClass.getNextID()

	player.orientation = 0 -- radians
	player.orientation_offset = 0

	player.bullets = {}
	player.nextBulletColor = getRandomColor()
	return player
end

---------------------------------------------------------------

player = PlayerClass.new()