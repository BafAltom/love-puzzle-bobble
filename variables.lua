-- sizes are in px
-- speeds are in px/s
-- times are in s

wScr = love.graphics.getWidth()
hScr = love.graphics.getHeight()
DEBUG = false

bubbleRadius = 20
bubbleColors = {{255,0,0}, {0,255,0}, {0,0,255}, {255,255,255}}
bubbleColorNbr = #bubbleColors
bubbleSequenceSize = 3
bubbleDropInitialSpeed = -250
bubbleDropInitSpeedNoise = 150
bubbleDeadDropAcc = 750 -- (px/s)/s

function getRandomColor()
	return math.random(bubbleColorNbr)
end

playerRadius = 50
playerCoolDown = 1

bbulletRadius = bubbleRadius
bbulletSpeed = 1000

uiSize = 100
ceilingDropTime = 1
ceilingDropSize = 10

function round(num) 
	if num >= 0 then return math.floor(num+.5) 
	else return math.ceil(num-.5) end
end