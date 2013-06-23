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
		cursor = nil, --Cursor Linked With Player
		
		canPlayerMove = true, --Player Movement Ability
		onGround = true, --If Player Is On The Ground
		collidingLeft = false, --If Player Is Colliding With A Block On The Left
		collidingRight = false, --If Player Is Colliding With A Block On The Right
		
		--Controls
		leftButton = "a",
		rightButton = "d",
		upButton = " ",
		joystick = false
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
	self.cursor = classes.Cursor:new(mainPlayer)
	
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
				--self.cursorX,self.cursorY = mse.getPosition()
				self.cursor:setCursorFromPixel(mse.getPosition())
				self.cursor:update(mse.isDown("l"),mse.isDown("r"))
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
				local newX = self.cursor:getX() --New Coordinates For Cursor Position
				local newY = self.cursor:getY()
				if jst.getAxis(1,5) >=  0.5 and self.cursor:getX() < 959 then newX = newX+2 end
				if jst.getAxis(1,5) <= -0.5 and self.cursor:getX() > 1 then newX = newX-2 end
				if jst.getAxis(1,4) >=  0.5 and self.cursor:getY() < 575 then newY = newY+2 end
				if jst.getAxis(1,4) <= -0.5 and self.cursor:getY() > 1 then newY = newY-2 end
				
				self.cursor:setCursorFromPixel(newX,newY)
				self.cursor:update(jst.getAxis(1,3) >= 0.5,jst.getAxis(1,3) <= -0.5)
			end
		end
	end
end
function classes.Player:draw()
	gfx.drawq(self.picture,self.frame,self.x,self.y)
	self.cursor:draw()
	if debugon then
		gfx.print(tostring(self.moving),5,30-12)
		gfx.print(self.frameStartTime,5,45-12)
		gfx.print(self.frameCurTime.."/"..self.frameEndTime,5,60-12)
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

function classes.Player:getCursor()
	return self.cursor
end

mainPlayer = classes.Player:new(controls.left,controls.right,controls.jump,controls.gamepad)