require "variables"
require "ressources"
require "bafaltom2D"
require "world"

BubbleBulletClass = {}

-- STATIC ATTRIBUTES

BubbleBulletClass.nextID = 0

-- STATIC METHODS

BubbleBulletClass.getNextID = function()

	BubbleBulletClass.nextID = BubbleBulletClass.nextID + 1
	return BubbleBulletClass.nextID

end

-- CLASS METHODS

BubbleBulletClass.update = function(bbullet, dt)
	bbullet.x = bbullet.x + bbullet.sx*dt
	bbullet.y = bbullet.y + bbullet.sy*dt

	-- collision with wall
	if (bbullet.x < bbulletRadius + world.leftWall) then
		sound_bounce:play()
		bbullet.sx = math.abs(bbullet.sx)
	elseif (bbullet.x > world.rightWall-bbulletRadius) then
		sound_bounce:play()
		bbullet.sx = -1*math.abs(bbullet.sx)
	end
	-- collision with bubble
	for _,bubble in ipairs(bubbles) do
		if (not bubble.dead and distance2Entities(bbullet, bubble) <= (bubbleRadius + bbulletRadius)) then
			sound_stick:play()
			-- create new bubble
			local _angle = bafaltomAngle2Entities(bubble, bbullet)
			table.insert(bubbles, BubbleClass.newChild(bubble, _angle, bbullet.color))
			--erase this bullet
			bbullet:remove()
			break
		end
	end
	-- collision with ceiling
	if (bbullet.y < bbulletRadius + world.ceiling) then
		sound_stick:play()
		-- create new bubble
		table.insert(bubbles, BubbleClass.newRoot(bbullet.x, bbullet.color))
		bbullet:remove()
	end
end


BubbleBulletClass.draw = function(bbullet)
	love.graphics.setColor(bubbleColors[bbullet.color])
	love.graphics.circle("fill", bbullet:getX(), bbullet:getY(), bbullet:size())
end

BubbleBulletClass.remove = function(bbullet)
	bbullet.sx = 0
	bbullet.sy = 0
	for n,eachBb in ipairs(bbullet.player.bullets) do
		if(eachBb.id == bbullet.id) then
			table.remove(bbullet.player.bullets, n)
			return
		end
	end
end

BubbleBulletClass.size = function(bbullet)
	return bbulletRadius
end

BubbleBulletClass.getX = function(bbullet)
	return bbullet.x
end

BubbleBulletClass.getY = function(bbullet)
	return bbullet.y
end

-------------------------------------------------------------------

BubbleBulletClass.new = function(player, target_x, target_y, color)
	local bbullet = {}
	setmetatable(bbullet, {__index = BubbleBulletClass})
	bbullet.id = BubbleBulletClass.getNextID()

	bbullet.player = player
	bbullet.x = player:getX()
	bbullet.y = player:getY()
	bbullet.sx, bbullet.sy = bafaltomVector(bbullet.x, bbullet.y, target_x, target_y, bbulletSpeed)

	bbullet.color = color
	return bbullet
end