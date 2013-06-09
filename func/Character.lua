--Variables For Movement
char = gfx.newImage("gfx/player.png")
still = gfx.newQuad(            	 0,           	   0,scaleTileWidth,scaleTileHeight*2,char:getWidth(),char:getHeight())
left1 = gfx.newQuad(           		 0,scaleTileHeight*2,scaleTileWidth,scaleTileHeight*2,char:getWidth(),char:getHeight())
left2 = gfx.newQuad(scaleTileWidth  -1,scaleTileHeight*2,scaleTileWidth,scaleTileHeight*2,char:getWidth(),char:getHeight())
left3 = gfx.newQuad(scaleTileWidth*2-1,scaleTileHeight*2,scaleTileWidth,scaleTileHeight*2,char:getWidth(),char:getHeight())
right1= gfx.newQuad(            	 0,scaleTileHeight*4,scaleTileWidth,scaleTileHeight*2,char:getWidth(),char:getHeight())
right2= gfx.newQuad(scaleTileWidth  -1,scaleTileHeight*4,scaleTileWidth,scaleTileHeight*2,char:getWidth(),char:getHeight())
right3= gfx.newQuad(scaleTileWidth*2-1,scaleTileHeight*4,scaleTileWidth,scaleTileHeight*2,char:getWidth(),char:getHeight())
frame = still
accel = 0
accelCool = 0
jump = nil
jumpAccel = 0
jumpWait = 0
timetest = 0
aniRunning = {}
aniRunning.status = false
aniRunning.startTime = 0
--aniCurTime = 0
aniRunning.framePos = 0
aniJumping = {}
aniJumping.status = false
charX = width/2
charY = height/2-scaleTileHeight*2
movePlayer = true

function updatePlayer()
	if start and movePlayer then
		local dir
		
		--[[New Character Code
		--Movement
		if kbd.isDown("a") and charX > 0 then
			dir = 0
		elseif kbd.isDown("d") and charX < width-scaleTileWidth then
			dir = 2
		else
			dir = 1
		end
		
		--Animation
		if animate then
			aniFrameRate = aniFrameRate+1
			if dir == 0 then --If Facing Left
				if aniFrameRate == 9 then
					aniFrameRate = 0
					if aniFramePos < 2 then aniFramePos = aniFramePos+1 else aniFramePos = 0 end
					if accel >= -2 then accel = accel-1 end
				end
				if aniFramePos == 0 then
					frame = left1
				elseif aniFramePos == 1 then
					frame = left2
				elseif aniFramePos == 2 then
					frame = left3
				end
				
				if getBlock(math.ceil((charX+accel)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+2) == air:getBlockID() and
				   getBlock(math.ceil((charX+accel)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+1) == air:getBlockID() then
					charX = charX+accel
				end
			elseif dir == 1 then --If Standing Still
				if aniFrameRate == 9 then
					aniFrameRate = 0
					if accel > 0 then accel = accel-1 end
					if accel < 0 then accel = accel+1 end
				end
				frame = still
			elseif dir == 2 then --If Facing Right
				if aniFrameRate == 9 then
					aniFrameRate = 0
					if aniFramePos < 2 then aniFramePos = aniFramePos+1 else aniFramePos = 0 end
					if accel <= 2 then accel = accel+1
				end
				if aniFramePos == 0 then
					frame = right1
				elseif aniFramePos == 1 then
					frame = right2
				elseif aniFramePos == 2 then
					frame = right3
				end
				
				if getBlock(math.ceil(((charX+accel)+scaleTileWidth)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+2) == air:getBlockID() and 
				   getBlock(math.ceil(((charX+accel)+scaleTileWidth)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+1) == air:getBlockID() then
					charX = charX+accel
				end
			end
		end]]
		
		if not aniRunning.status then aniRunning.startTime = love.timer.getTime();aniRunning.status = true end
		if not aniJumping.status then aniJumping.startTime = love.timer.getTime() end
		
		if accel == 0 then dir = 0 end
		if accel > 0 then dir = 1 end
		if accel < 0 then dir = 2 end
		if love.keyboard.isDown("a") and charX > 0 then
			if aniFramePos == 0 then
				frame = left1
			elseif aniFramePos == 1 then
				frame = left2
			elseif aniFramePos == 2 then
				frame = left3
			end
			if love.timer.getTime() > aniRunning.startTime + .5 then
				animationRunning = false
				if aniFramePos <= 2 then aniFramePos = aniFramePos+1 else aniFramePos = 0 end
				--if accel >= -2 then accel = accel-1 end
				accel = -1
			end
		elseif love.keyboard.isDown("d") and charX < love.graphics.getWidth()-scaleTileWidth then
			if aniFramePos == 0 then
				frame = right1
			elseif aniFramePos == 1 then
				frame = right2
			elseif aniFramePos == 2 then
				frame = right3
			end
			if love.timer.getTime() > aniRunning.startTime + .5 then
				animationRunning = false
				if aniFramePos <= 2 then aniFramePos = aniFramePos+1 else aniFramePos = 0 end
				--if accel <= 2 then accel = accel+1 end
				accel = 1
			end
		else
			if accel == 0 then frame = still end
			aniFrameRate = 0
			aniFramePos = 0
			if accel ~= 0 and accelCool == 0 then accelCool = 10 end
			if accelCool >= 1 then accelCool = accelCool-1 end
			if accelCool == 1 then
				accelCool = 0
				if accel > 0 then accel = accel-1 end
				if accel < 0 then accel = accel+1 end
			end
		end	
		if charY+scaleTileHeight*2 < height then
			charY = charY+jumpAccel
		end
		if charY+scaleTileHeight*2 < height and aniJumping.status == false then
			if world[math.ceil((charY+1)/scaleTileHeight)+2][math.ceil((charX+scaleTileWidth/2)/scaleTileWidth)] == blocks.air:getBlockID() then
				charY = charY+2
			end
		end
		--Right Collision Checking
		if dir == 1 then
			if getBlock(math.ceil(((charX+accel)+scaleTileWidth)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+2) == blocks.air:getBlockID() and 
			   getBlock(math.ceil(((charX+accel)+scaleTileWidth)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+1) == blocks.air:getBlockID() then
				charX = charX+accel
			end
		--Left Collision Checking
		elseif dir == 2 then
			if getBlock(math.ceil((charX+accel)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+2) == blocks.air:getBlockID() and
			   getBlock(math.ceil((charX+accel)/scaleTileWidth),math.ceil(charY/scaleTileHeight)+1) == blocks.air:getBlockID() then
				charX = charX+accel
			end
		end
		if jump == true then
			if jumpAccel <= 0 then jumpAccel = jumpAccel-1 end
			if jumpAccel == -7 then jump = false; jumpAccel = 0;jumpWait = 30 end
		end
		if aniJumping.status then
			if love.timer.getTime() > aniJumping.startTime + .25 then aniJumping.status = false end
		end
		timetest = love.timer.getTime()
	end
end
function keypressedPlayer(key)
	if start then
		if key == " " and aniJumping.status == false and charY-scaleTileHeight >= 0 and
		getBlock(math.ceil((charX+scaleTileWidth/2)/scaleTileWidth),math.ceil((charY+1)/scaleTileHeight)-1) == blocks.air:getBlockID() then
			charY = charY-scaleTileHeight
			aniJumping.startTime = love.timer.getTime()
			aniJumping.status = true
		end
		if key == "escape" then
			movePlayer = false
			love.mouse.setVisible(true)
			menu = "paused"
		end
	end
end
function drawPlayer()
	gfx.drawq(char,frame,charX,charY)
	if debugon then
		gfx.print("CharX: "..math.ceil((charX+scaleTileWidth/2)/scaleTileWidth),5,30-12)
		gfx.print("CharY: "..math.ceil(charY/scaleTileHeight),5,45-12)
		gfx.print("Acceleration: "..accel,5,60-12)
	end
end