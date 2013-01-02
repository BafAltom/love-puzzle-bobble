require "variables"
require "BubbleBulletClass"
require "BubbleClass"

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

	player.targetX, player.targetY = love.mouse.getPosition()

	for _, bb in ipairs(player.bullets) do
		bb:update(dt)
	end

	if (player.coolDown > 0) then
		player.coolDown = player.coolDown - dt
	end
end

PlayerClass.draw = function(player)
	local _pColor = bubbleColors[player.nextBulletColor]

	-- choose color
	local _alpha = 255
	if (player.coolDown > 0) then _alpha = 50 end
	love.graphics.setColor(_pColor[1], _pColor[2], _pColor[3], _alpha)

	-- Round thing
	love.graphics.circle("fill", player:getX(), player:getY(), player:size())
	local _o = player:getOrientation()
		-- visor
		love.graphics.line(player:getX(), player:getY(), player:getX()+math.cos(_o)*100, player:getY() + math.sin(_o)*100)
	if (player.coolDown <= 0) then
		-- aim line
		love.graphics.setColor(_pColor[1], _pColor[2], _pColor[3], 100)
		local _tx, _ty = player:getAimIntersection()
		drawDashedLine(player:getX(), player:getY(), _tx, _ty, 5, 5)
	end

	if (DEBUG) then
		love.graphics.setColor(0,0,0)
		love.graphics.print(player.coolDown, player:getX(), player:getY() - 20)
	end

	for _, bb in ipairs(player.bullets) do
		bb:draw()
	end
end

PlayerClass.getAimIntersection = function(player)
	-- TODO : when orientation is close to pi/2, compute intersection with ceiling instead
	-- (this work fine for now but is a bit ugly)
	local _c = (player.targetY - player:getY())/(player.targetX - player:getX()) -- angular coefficient
	if (_c < 0) then -- right wall intersection
		return world.rightWall, player:getY() +  _c*(world.rightWall - player:getX())
	else -- left wall inters
		return world.leftWall, player:getY() + _c*(world.leftWall - player:getX())
	end
end

PlayerClass.getOrientation = function(player)
	return bafaltomAngle(player:getX(), player:getY(), player.targetX, player.targetY) + player.orientation_offset
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

PlayerClass.shoot = function(player)
	local _tX = player:getX() + math.cos(player:getOrientation()) * 10
	local _tY = player:getY() + math.sin(player:getOrientation()) * 10
	if (player.coolDown > 0) then
		-- TODO : empty click sound
	else
		sound_shoot:play()
		table.insert(player.bullets, BubbleBulletClass.new(player, _tX,_tY,player.nextBulletColor))
		player.nextBulletColor = player:getNextBulletColor()
		player.coolDown = playerCoolDown
	end
end

PlayerClass.getNextBulletColor = function(player)
	if (#bubbles == 0) then
		return getRandomColor()
	end
	local _availableColors = {}
	local _alreadySeen = false
	for _, b in ipairs(bubbles) do
		-- check if this color has already been seen
		for _, c in ipairs(_availableColors) do
			if (c == b.color) then
				_alreadySeen = true
			end
		end
		-- if not, add it to the set of available ones
		if (not _alreadySeen) then
			table.insert(_availableColors, b.color)
		end
	end
	assert (#_availableColors <= bubbleColorNbr)
	local _chosenColor = math.random(#_availableColors)
	return _chosenColor
end

-------------------------------------------------------------------

PlayerClass.new = function()
	local player = {}
	setmetatable(player, {__index = PlayerClass})

	player.id = PlayerClass.getNextID()

	player.targetX = 0
	player.targetY = 0
	player.orientation_offset = 0 -- radians

	player.bullets = {}
	player.nextBulletColor = player:getNextBulletColor()
	player.coolDown = 0
	return player
end

---------------------------------------------------------------

player = PlayerClass.new()