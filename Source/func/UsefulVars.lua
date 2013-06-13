--Tables
blocks = {}
blockids = {}
classes = {}
menu = {}
textures = {}

--Screen Sizes
width = love.graphics.getWidth() --Set Width
height = love.graphics.getHeight() --Set Height

--Block Sizes
tileWidth = 32 --Set Tile Width
tileHeight = 32 --Set Tile Height
scaleTileWidth = 24 --Set The Scaled Tile Width
scaleTileHeight = 24 --Set The Scaled Til Height

--Game States
game = {}
mouseDown = false --Set Mouse Status
start = false --Set Game Status
debugon = false --Set Debugging Menu Status

--Game Info
worldFormat = "dev-meta" --Set The Current World Format
GameVer = "0.7" --Set Game Version

--Shortcuts
gfx = love.graphics --Set Graphics Things
snd = love.audio --Set Audio Things
fs  = love.filesystem --Set File System Things
kbd = love.keyboard --Set Keyboard Things
jst = love.joystick --Set Joystick Things
mse = love.mouse --Set Mouse Things

--Fonts
bigFont = gfx.newFont(30)
medFont = gfx.newFont(20)
regFont = gfx.setNewFont(12)

--Colors
colors = {}
colors.defaultFore = {100,120,0}
colors.defaultBack = {100,150,0}

--Sounds
sounds = {}
sounds.select = snd.newSource("snd/select.ogg","static")
sounds.bgm = snd.newSource("snd/bgm.ogg","dynamic")

--Controls
controls = {}
controls.gamepad = false --Set Gamepad Status
controls.left = "a" --Set Default Left Key
controls.right = "d" --Set Default Right Key
controls.jump = " " --Set Defualt Jump Key

function love.graphics.getColorTable()
	local r,g,b,a = gfx.getColor()
	return {r,g,b,a}
end

function love.graphics.getBackgroundColorTable()
	local r,g,b,a = gfx.getBackgroundColor()
	return {r,g,b,a}
end