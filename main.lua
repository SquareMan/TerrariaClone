function love.load()
	love.graphics.setBackgroundColor(0,160,200) --Set A Background Color
	
	--Variables
	require("func/UsefulVars")
	
	--Load Libraies
	object = require("libs/30log")

	--Load Classes
	require("class/Animation")
	require("class/GenMinable")
	require("class/Block")
	require("class/Player")
	require("class/Box")
	require("class/File")

	--Load Functions
	require("func/Maps")
	require("func/Menu")
	--require("func/Character")
	
	--Load Mods
	mods = fs.enumerate("mods")
	for n=1,#mods do
		if string.sub(mods[n],string.len(mods[n])-3) == ".lua" then
			require("mods/"..string.gsub(mods[n], "%....", ""))
		end
	end
end

function love.update(dt)
	if menu.name == nil then
		mainPlayer:update()--Update The Player
	end
end

function love.keypressed(key,unicode)	
	titleKeyPress(key,unicode)
	if key == "f3" then
		debugon = not debugon
	end
	if key == "f2" then
		local screenshot = gfx.newScreenshot()
		local date = os.date("*t")
		if not fs.exists("screenshots") then
			fs.mkdir("screenshots")
		end
		local test = 5
		local test2 = 3
		screenshot:encode("screenshots/"..date.month.."-"..date.day.."-"..date.year.."-"..date.hour.."-"..date.min.."-"..date.sec..".bmp")
	end
end

function love.mousepressed(x,y,button)
	titleButtonPress(x,y,button) --Check If The Start Button Has Been Pushed
end

function love.draw()
	if start then
		--Render The Map
		gfx.setColor(255,255,255)
		drawMap()
		
		mainPlayer:draw() --Render The Character
		
		if debugon then 
			gfx.print("FPS: "..love.timer.getFPS(),5,15-12) --Show FPS
			gfx.print(love.filesystem.getSaveDirectory(),5,90-12) --Show Save Directory
		end
	end
	
	if not start or debugon then
		gfx.setColor(255,255,255)
		gfx.printf("Developer Version "..GameVer,-5,15-12,width,"right") --Show Version
		gfx.printf("Sticks: "..jst.getNumJoysticks(),-5,30-12,width,"right") --Show Number of Joysticks Connected
	end
	
	drawTitle() --Draw The Title Screeen
end

function love.quit()
	if menu.name == nil and menu.selectWorld then
		saveWorld(menu.selectWorld) --Save The World
	end
end