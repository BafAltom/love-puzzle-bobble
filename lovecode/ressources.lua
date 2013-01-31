sound_bounce = love.audio.newSource("res/sound/bounce.ogg", "static")
sound_shoot = love.audio.newSource("res/sound/shoot.ogg", "static")
sound_stick = love.audio.newSource("res/sound/stick.ogg", "static")
sound_death = love.audio.newSource("res/sound/death.ogg", "static")

music_menu = love.audio.newSource("res/music/Shawn_Bayern_-_One_Way.mp3", "stream")
music_menu:setLooping(true)
music_game = love.audio.newSource("res/music/Shawn_Bayern_-_The_Ice_Cream_Truck_Factory.mp3", "stream")
music_game:setLooping(true)

pic_bubble = love.graphics.newImage("res/bubble.png")
pic_player = love.graphics.newImage("res/player.png")
pic_player_cooldown = love.graphics.newImage("res/player_cooldown.png")

flippedfont = love.graphics.newImageFont("bluefont-2x-vflip-gradient.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")

if (love.web) then
	font_bigfish_small = flippedfont
	font_bigfish_medium = flippedfont
	font_bigfish_large = flippedfont
else
	font_bigfish_small = love.graphics.newFont("res/font/Bigfish.ttf", 18)
	font_bigfish_medium = love.graphics.newFont("res/font/Bigfish.ttf", 36)
	font_bigfish_large = love.graphics.newFont("res/font/Bigfish.ttf", 72)
end
