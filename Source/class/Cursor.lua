classes.Cursor = object {
	cursorX = 0, --X Pixel Coordinate
	cursorY = 0, --Y Pixel Coordinate
	
	cursorWorldX = 1, --X World Coordinate
	cursorWorldY = 1, --Y World Coordinate
	cursorLastX  = 1, --Previous X World Coordinate
	cursastY  = 1, --Previous Y World Coordinate
	
	cursorDown = false,
	
	cursorOutline = gfx.newImage("gfx/select.png"), --Block Outline Image
	breaking = nil,
	
	damageStage = 0,
	damageOverlay = nil,
	
	linkedPlayer = nil
}
function classes.Cursor:__init(player) 
	self.linkedPlayer = player
	self.breaking = classes.Animation:new(0)
end

function classes.Cursor:update(ld,rd)
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
		if not self.breaking:running() then
			if getBlock(self.cursorWorldX,self.cursorWorldY) ~= blocks.air:getBlockID() then
				self.breaking:setFrameTime(blockids[getBlock(self.cursorWorldX,self.cursorWorldY)].class:getTimeToBreak()/8)
				self.breaking:start()
			end
		end
		if self.breaking:running() then
			local updates = self.breaking:update()
			if updates > 0 then
				self.damageStage = self.damageStage + updates
				self.damageOverlay = gfx.newQuad(((379+self.damageStage)%(texFile:getWidth()/tileWidth))*tileWidth,math.floor((379+self.damageStage)/(texFile:getHeight()/tileHeight))*tileHeight,tileWidth,tileHeight,texFile:getWidth(),texFile:getHeight())
			end
			if self.damageStage >= 8 then
				self.damageStage = 0
				self.damageOverlay = nil
				self.breaking:stop()
				setBlock(self.cursorWorldX,self.cursorWorldY,blocks.air:getBlockID())
			end
		end
		if self.cursorLastX ~= self.cursorWorldX or self.cursorLastY ~= self.cursorWorldY then
			self.damageStage = 0
			self.damageOverlay = nil
			self.breaking:stop()
		end
	elseif self.breaking:running() then
		self.damageStage = 0
		self.damageOverlay = nil
		self.breaking:stop()
	end
end

function classes.Cursor:getX()
	return self.cursorX
end
function classes.Cursor:getY()
	return self.cursorY
end

function classes.Cursor:setCursorFromPixel(x,y) --Set The Cursor's Position From A Specific Pixel
	if x > 0 and y > 0 and x < 961 and y < 577 then
		self:setCursorXFromPixel(x)
		self:setCursorYFromPixel(y)
	end
end
function classes.Cursor:setCursorXFromPixel(x) --Set The Cursor's X Posistion From A Specific Pixel
	self.cursorX = x
	self.cursorLastX = self.cursorWorldX
	self.cursorWorldX = math.ceil(x/24)
end
function classes.Cursor:setCursorYFromPixel(y) --Set The Cursor's Y Posistion From A Specific Pixel
	self.cursorY = y
	self.cursorLastY = self.cursorWorldY
	self.cursorWorldY = math.ceil(y/24)
end

function classes.Cursor:setCursorFromTile(x,y) --Set The Cursor's Posistion From A World Coordinate
	self:setCursorXFromTile(x)
	self:setCursorYFromTile(y)
end
function classes.Cursor:setCursorXFromTile(x) --Set The Cursor's X Posistion From A World Coordinate
	self.cursrorLastX = self.cursorWorldX
	self.cursorWorldX = x
end
function classes.Cursor:setCursorYFromTile(y) --Set The Cursor's Y Posistion From A World Coordinate
	self.cursorLastY = self.cursorWorldY
	self.cursorWorldY = y
end

function classes.Cursor:draw()
	gfx.draw(self.cursorOutline,(self.cursorWorldX-1)*scaleTileWidth,(self.cursorWorldY-1)*scaleTileHeight)
	if self.damageOverlay then
		gfx.drawq(texFile,self.damageOverlay,((self.cursorWorldX-1)*tileWidth)*0.75,((self.cursorWorldY-1)*tileHeight)*0.75,0,0.75)
	end
	--if self.blockBreaking and not(self.blockBreakCurTime >= self.blockBreakEndTime) then
	--	self:overlayBlockDamage(self.cursorWorldX,self.cursorWorldY,self.blockBreakCurTime-self.blockBreakStartTime,blockids[getBlock(self.cursorWorldX,self.cursorWorldY)].class:getTimeToBreak())
	--end
end

function classes.Cursor:overlayBlockDamage(x,y,curTime,breakTime) --Temporary Code For Block Breaking
	local increment = breakTime/8 --Get The Amount Of Time Between Each Damage Stage
	local stage = math.floor(curTime/increment) --Get What Stage Of Damage The Block Is On
	local overlay = gfx.newQuad(((379+stage)%(texFile:getWidth()/tileWidth))*tileWidth,math.floor((379+stage)/(texFile:getHeight()/tileHeight))*tileHeight,tileWidth,tileHeight,texFile:getWidth(),texFile:getHeight())

	gfx.drawq(texFile,overlay,((x-1)*tileWidth)*0.75,((y-1)*tileHeight)*0.75,0,0.75)
end