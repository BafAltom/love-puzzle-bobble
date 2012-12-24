-- sizes are in px
-- speeds are in px/s

wScr = love.graphics.getWidth()
hScr = love.graphics.getHeight()
DEBUG = false

bubbleRadius = 30
bubbleColors = {{255,0,0}, {0,255,0}, {0,0,255}, {255,255,255}}
bubbleColorNbr = #bubbleColors
bubbleSequenceSize = 3

function getRandomColor()
	return math.random(bubbleColorNbr)
end

playerRadius = 50

bbulletRadius = bubbleRadius
bbulletSpeed = 1000

uiSize = 20
ceilingDropTime = 0.1
ceilingDropSize = 1

function round(num) 
	if num >= 0 then return math.floor(num+.5) 
	else return math.ceil(num-.5) end
end