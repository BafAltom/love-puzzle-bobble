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

PlayerClass.getPic = function(player)
	if (player.coolDown > 0) then
		return pic_player_cooldown
	else
		return pic_player
	end
end

PlayerClass.drawEyes = function(player)
	local _pColor = bubbleColors[player.nextBulletColor]
	-- eyes
	love.graphics.setColor(_pColor[1], _pColor[2], _pColor[3], _alpha)
	local _eyeRadius = playerRadius/4
	local _eyeY = player:getY() - playerRadius/2
	local _leftEyeX = player:getX() - playerRadius/2
	local _rightEyeX = player:getX() + playerRadius/2
	love.graphics.circle("fill", _leftEyeX, _eyeY, _eyeRadius)
	love.graphics.circle("fill", _rightEyeX, _eyeY, _eyeRadius)

	-- pupil
	local _mx, _my = love.mouse.getPosition()
	local _leftAngle = bafaltomAngle(_leftEyeX, _eyeY, _mx, _my)
	local _rightAngle = bafaltomAngle(_rightEyeX, _eyeY, _mx, _my)
	local _pupilDistance = _eyeRadius - playerPupilSize
	local _pLX = _leftEyeX + math.cos(_leftAngle)*_pupilDistance
	local _pLY = _eyeY + math.sin(_leftAngle)*_pupilDistance
	local _pRX = _rightEyeX + math.cos(_rightAngle)*_pupilDistance
	local _pRY = _eyeY + math.sin(_rightAngle)*_pupilDistance
	love.graphics.setColor(0,0,0)
	love.graphics.circle("fill", _pLX, _pLY, playerPupilSize)
	love.graphics.circle("fill", _pRX, _pRY, playerPupilSize)
end

PlayerClass.draw = function(player)
	local _pColor = bubbleColors[player.nextBulletColor]
	local _alpha = 255
	local _o = player:getOrientation()
	if (player.coolDown > 0) then _alpha = 50 end

	love.graphics.setColor(_pColor[1], _pColor[2], _pColor[3], _alpha)
	-- visor
	love.graphics.line(player:getX(), player:getY(), player:getX()+math.cos(_o)*100, player:getY() + math.sin(_o)*100)
	if (player.coolDown <= 0) then
		-- aim line
		love.graphics.setColor(_pColor[1], _pColor[2], _pColor[3], 100)
		local _tx, _ty = player:getAimIntersection()
		drawDashedLine(player:getX(), player:getY(), _tx, _ty, 5, 5)
	end

	-- Face
	love.graphics.setColorMode("replace")
	local _playerScale = (2*playerRadius)/pic_player:getWidth()
	local _pic = player:getPic()
	love.graphics.draw(_pic, player:getX() - playerRadius, player:getY() - playerRadius, 0, _playerScale, _playerScale)

	if (not (player.coolDown > 0)) then
		player:drawEyes()
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
		if ((not _alreadySeen) and (not b.dead)) then
			table.insert(_availableColors, b.color)
		end
		_alreadySeen = false
	end
	assert (#_availableColors <= bubbleColorNbr)
	local _chosenColor = math.random(#_availableColors)
	return _availableColors[_chosenColor]
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