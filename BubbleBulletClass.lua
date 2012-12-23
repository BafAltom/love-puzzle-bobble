require "variables"

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
end

BubbleBulletClass.draw = function(bbullet)
	love.graphics.circle("fill", bbullet:getX(), bbullet:getY(), bbullet:size())
end

BubbleBulletClass.size = function(bbullet)
	return bbulletSize
end

BubbleBulletClass.getX = function(bbullet)
	return bbullet.x
end

BubbleBulletClass.getY = function(bbullet)
	return bbullet.y
end

BubbleBulletClass:shoot(x,y)

	

end

-------------------------------------------------------------------

BubbleBulletClass.new = function()
	local bbullet = {}
	setmetatable(bbullet, {__index = BubbleBulletClass})

	bbullet.id = BubbleBulletClass.getNextID()
	return bbullet
end

---------------------------------------------------------------

bbullet = BubbleBulletClass.new()