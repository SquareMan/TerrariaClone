--Player Class
classes.Player = object {
	--Player Related Variables
		--Player Frames
		picture = nil,
		still   = nil,
		left1 = nil,
		left2 = nil,
		left3 = nil,
		right1 = nil,
		right2 = nil,
		right3 = nil,
		frame = nil,
		
		x = 21*scaleTileWidth, --X Pixel
		y = 10*scaleTileHeight, --Y Pixel
		worldX = 21, --X World Coordinate
		worldY = 13, --Y World Coordinate
		
		frames = nil, --Player Frame Animation Class
		
		canPlayerMove = true, --Player Movement Ability
		onGround = true, --If Player Is On The Ground
		collidingLeft = false, --If Player Is Colliding With A Block On The Left
		collidingRight = false, --If Player Is Colliding With A Block On The Right
		
		--Controls
		leftButton = "a",
		rightButton = "d",
		upButton = " ",
		joystick = false,
		
	--Cursor Related Variables
		cursorDown = false, --If Block Has Been Placed
		
		cursorX = 1, --X Pixel Coordinate
		cursorY = 1, --Y Pixel Coordinate
		
		cursorWorldX = 1, --X World Coordinate
		cursorWorldY = 1, --Y World Coordinate
		cursorLastX  = 1, --Previous X World Coordinate
		cursorLastY  = 1, --Previous Y World Coordinate
		
		cursorOutline = gfx.newImage("gfx/select.png"), --Block Outline Image
		blockBreaking   = false, --If A Block Is Being Broke
		blockBreakStartTime = 0, --Time Block Started Breaking
		blockBreakEndTime   = 0, --Time Block Will Break
		blockBreakCurTime   = 0  --Current Time
}
function classes.Player:__init(lb,rb,ub,js)
	--Initialize Player Frames 
	self.picture = gfx.newImage("gfx/player.png")
	self.still = gfx.newQuad(				   0,				 0,scaleTileWidth,scaleTileHeight*2,self.picture:getWidth(),self.picture:getHeight())
	self.left1 = gfx.newQuad(				   0,scaleTileHeight*2,scaleTileWidth,scaleTileHeight*2,self.picture:getWidth(),self.picture:getHeight())
	self.left2 = gfx.newQuad(scaleTileWidth	  -1,scaleTileHeight*2,scaleTileWidth,scaleTileHeight*2,self.picture:getWidth(),self.picture:getHeight())
	self.left3 = gfx.newQuad(scaleTileWidth*2 -1,scaleTileHeight*2,scaleTileWidth,scaleTileHeight*2,self.picture:getWidth(),self.picture:getHeight())
	self.right1= gfx.newQuad(				   0,scaleTileHeight*4,scaleTileWidth,scaleTileHeight*2,self.picture:getWidth(),self.picture:getHeight())
	self.right2= gfx.newQuad(scaleTileWidth   -1,scaleTileHeight*4,scaleTileWidth,scaleTileHeight*2,self.picture:getWidth(),self.picture:getHeight())
	self.right3= gfx.newQuad(scaleTileWidth*2 -1,scaleTileHeight*4,scaleTileWidth,scaleTileHeight*2,self.picture:getWidth(),self.picture:getHeight())
	self.frame = self.still
	
	self.frames = classes.Animation:new(.075) --Initializes Player Frame Animation Class
	
	--Set Controls
	if lb then
		self.leftButton = lb
		self.rightButton = rb
		self.upButton = ub
	end
	if js then
		self.joystick = true
	end
end

--Basic Player Requirements
function classes.Player:update()
	if self.joystick == false then
		if (kbd.isDown(self.leftButton) and not kbd.isDown(self.rightButton)) or (not kbd.isDown(self.leftButton) and kbd.isDown(self.rightButton)) then
			if kbd.isDown(self.leftButton) then
				self:moveLeft()
			end
			if kbd.isDown(self.rightButton) then
				self:moveRight()
			end
		else
			self:stopMoving()
		end
		if kbd.isDown(self.upButton) and self.onGround == true then
			self:jump()
		end
		
		if self.canMove then
			if kbd.isDown("escape") then
				self:setMove(false)
				love.mouse.setVisible(true)
				menu.name = "paused"
			end
			
			--Cursor Update
			if not love.mouse.isVisible() then
				self.cursorX,self.cursorY = mse.getPosition()
				self:setCursorFromPixel(mse.getPosition())
				
				self:updateCursor(mse.isDown("l"),mse.isDown("r"))
			end
		end
	else
		if love.joystick.getAxis(1,1) <= -.5 then
			self:moveLeft()
		elseif love.joystick.getAxis(1,1) >= .5 then
			self:moveRight()
		else
			self:stopMoving()
		end
		if love.joystick.isDown(1,1) and self.onGround then
			self:jump()
		end
		if self.canMove then
			if jst.isDown(1,8) then
				self:setMove(false)
				love.mouse.setVisible(true)
				menu.name = "paused"
			end
			
			--Cursor Update
			if not love.mouse.isVisible() then
				if jst.getAxis(1,5) >=  0.5 and self.cursorX < 959 then self.cursorX = self.cursorX+2 end
				if jst.getAxis(1,5) <= -0.5 and self.cursorX > 1 then self.cursorX = self.cursorX-2 end
				if jst.getAxis(1,4) >=  0.5 and self.cursorY < 575 then self.cursorY = self.cursorY+2 end
				if jst.getAxis(1,4) <= -0.5 and self.cursorY > 1 then self.cursorY = self.cursorY-2 end
				self:setCursorFromPixel(self.cursorX,self.cursorY)
				
				self:updateCursor(jst.getAxis(1,3) >= 0.5,jst.getAxis(1,3) <= -0.5)
			end
		end
	end
end
function classes.Player:draw()
	gfx.drawq(self.picture,self.frame,self.x,self.y)
	gfx.draw(self.cursorOutline,(self.cursorWorldX-1)*scaleTileWidth,(self.cursorWorldY-1)*scaleTileHeight)
	if self.blockBreaking and not(self.blockBreakCurTime >= self.blockBreakEndTime) then
		self:overlayBlockDamage(self.cursorWorldX,self.cursorWorldY,self.blockBreakCurTime-self.blockBreakStartTime,blockids[getBlock(self.cursorWorldX,self.cursorWorldY)].class:getTimeToBreak())
	end
	if debugon then
		gfx.print(tostring(self.moving),5,30-12)
		gfx.print(self.frameStartTime,5,45-12)
		gfx.print(self.frameCurTime.."/"..self.frameEndTime,5,60-12)
		gfx.printf("Movement: "..self.move:getTimes()--[[("Block Breaking Progress - StartTime: "..self.blockBreakStartTime.." - CurrentTime/EndTime: "..self.blockBreakCurTime.."/"..self.blockBreakEndTime]],5,105-12,width,"left") --Show Progress Towards Breaking The Next Block
	end
end

--Player Movement
function classes.Player:stopMoving()
	self.frames:stop()
	self.frame = self.still
end
function classes.Player:moveLeft()
	if self.x > 0 then
		if not self.frames:running() then
			self.frames:start()
		end
		local frameUpdates = self.frames:update()
		
		if frameUpdates > 0 then
			if self.frame == self.left1 then self.frame = self.left2
			elseif self.frame == self.left2 then self.frame = self.left3
			elseif self.frame == self.left3 then self.frame = self.left1
			else self.frame = self.left1 end
		elseif self.frame == self.still then
			self.frame = self.left1
		end
		self.x = self.x-180/love.timer.getFPS()
	end
end
function classes.Player:moveRight()
	if self.x < width-scaleTileWidth then
		if not self.frames:running() then
			self.frames:start()
		end
		local frameUpdates = self.frames:update()
		
		if frameUpdates > 0 then
			if self.frame == self.right1 then self.frame = self.right2
			elseif self.frame == self.right2 then self.frame = self.right3
			elseif self.frame == self.right3 then self.frame = self.right1
			else self.frame = self.right1 end
		elseif self.frame == self.still then
			self.frame = self.right1
		end
		self.x = self.x+180/love.timer.getFPS()
	end
end
function classes.Player:jump()
	self.y = self.y-scaleTileHeight*1.5
	self.onGround = false
end
function classes.Player:canMove()
	return self.canPlayerMove
end
function classes.Player:setMove(boolean)
	if boolean ~= true or boolean ~= false then
		return
	else
		self.canPlayerMove = boolean
	end
end
function classes.Player:updateControls(lb,rb,ub,js)
	self.leftButton = lb
	self.rightButton = rb
	self.upButton = ub
	self.joystick = js
end

--Cursor Functions
function classes.Player:updateCursor(ld,rd)
	if self.cursorDown and not ld then
		self.cursorDown = false
	end
	
	if ld then
		if getBlock(self.cursorWorldX,self.cursorWorldY) ~= blocks.stone:getBlockID() and self.cursorDown == false then
			setBlock(self.cursorWorldX,self.cursorWorldY,blocks.stone:getBlockID())
			self.cursorDown = true
			self.cursorLastX = self.cursorWorldX
			self.cursorLastY = self.cursorWorldY
		elseif getBlock(self.cursorWorldX,self.cursorWorldY) == blocks.stone:getBlockID() and self.cursorDown == false then
			setBlock(self.cursorWorldX,self.cursorWorldY,blocks.dirt:getBlockID())
			self.cursorDown = true
			self.cursorLastX = self.cursorWorldX
			self.cursorLastY = self.cursorWorldY
		elseif getBlock(self.cursorWorldX,self.cursorWorldY) == blocks.air:getBlockID() and self.cursorDown == false then
			setBlock(self.cursorWorldX,self.cursorWorldY,blocks.dirt:getBlockID())
			self.cursorDown = true
			self.cursorLastX = self.cursorWorldX
			self.cursorLastY = self.cursorWorldY
		end
		
		if  self.cursorDown then
			if self.cursorWorldX ~= self.cursorLastX or self.cursorWorldY ~= self.cursorLastY then
				 self.cursorDown = false
			end
		end
	end
	
	if rd then
		if self.blockBreaking == false then
			if getBlock(self.cursorWorldX,self.cursorWorldY) ~= blocks.air:getBlockID() then
				self.blockBreaking = true
				self.blockBreakStartTime = love.timer.getTime()
				self.blockBreakEndTime = self.blockBreakStartTime + blockids[getBlock(self.cursorWorldX,self.cursorWorldY)].class:getTimeToBreak()
				self.blockBreakCurTime = self.blockBreakStartTime
			end
		end
		if self.blockBreaking then
			if self.blockBreakCurTime >= self.blockBreakEndTime then
				self.blockBreaking = false
				self.blockBreakStartTime = 0
				self.blockBreakEndTime = 0
				self.blockBreakCurTime = 0
				setBlock(self.cursorWorldX,self.cursorWorldY,blocks.air:getBlockID())
			else
				self.blockBreakCurTime = love.timer.getTime()
			end
		end
		if self.cursorLastX ~= self.cursorWorldX or self.cursorLastY ~= self.cursorWorldY then
			self.blockBreaking = false
			self.blockBreakStartTime = 0
			self.blockBreakEndTime = 0
			self.blockBreakCurTime = 0
		end
	else
		self.blockBreaking = false
		self.blockBreakStartTime = 0
		self.blockBreakEndTime = 0
		self.blockBreakCurTime = 0
	end
end

function classes.Player:setCursorFromPixel(x,y) --Set The Cursor's Position From A Specific Pixel
	if x > 0 and y > 0 and x < 961 and y < 577 then
		self:setCursorXFromPixel(x)
		self:setCursorYFromPixel(y)
	end
end
function classes.Player:setCursorXFromPixel(x) --Set The Cursor's X Posistion From A Specific Pixel
	self.cursorLastX = self.cursorWorldX
	self.cursorWorldX = math.ceil(x/24)
end
function classes.Player:setCursorYFromPixel(y) --Set The Cursor's Y Posistion From A Specific Pixel
	self.cursorLastY = self.cursorWorldY
	self.cursorWorldY = math.ceil(y/24)
end

function classes.Player:setCursorFromTile(x,y) --Set The Cursor's Posistion From A World Coordinate
	self:setCursorXFromTile(x)
	self:setCursorYFromTile(y)
end
function classes.Player:setCursorXFromTile(x) --Set The Cursor's X Posistion From A World Coordinate
	self.cursrorLastX = self.cursorWorldX
	self.cursorWorldX = x
end
function classes.Player:setCursorYFromTile(y) --Set The Cursor's Y Posistion From A World Coordinate
	self.cursorLastY = self.cursorWorldY
	self.cursorWorldY = y
end

function classes.Player:overlayBlockDamage(x,y,curTime,breakTime) --Temporary Code For Block Breaking
	local increment = breakTime/8 --Get The Amount Of Time Between Each Damage Stage
	local stage = math.floor(curTime/increment) --Get What Stage Of Damage The Block Is On
	local overlay = gfx.newQuad(((379+stage)%(texFile:getWidth()/tileWidth))*tileWidth,math.floor((379+stage)/(texFile:getHeight()/tileHeight))*tileHeight,tileWidth,tileHeight,texFile:getWidth(),texFile:getHeight())
	
	gfx.drawq(texFile,overlay,((x-1)*tileWidth)*0.75,((y-1)*tileHeight)*0.75,0,0.75)
end

mainPlayer = classes.Player:new(controls.left,controls.right,controls.jump,controls.gamepad)