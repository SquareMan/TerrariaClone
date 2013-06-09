--Make Variables To Be Used
selectX = 1
selectY = 1
prevX = 1
prevY = 1
selection = gfx.newImage("gfx/select.png")
blockBreaking = false
blockBreakStartTime = 0
blockBreakEndTime = 0
blockBreakCurTime = 0

function setCursorFromPixel(x,y) --Set The Cursor's Posistion From A Specific Pixel
	setCursorXFromPixel(x)
	setCursorYFromPixel(y)
end
function setCursorXFromPixel(x) --Set The Cursor's X Posistion From A Specific Pixel
	prevX = selectX
	selectX = math.ceil(x/24)
end
function setCursorYFromPixel(y) --Set The Cursor's Y Posistion From A Specific Pixel
	prevY = selectY
	selectY = math.ceil(y/24)
end

function setCursorFromTile(x,y) --Set The Cursor's Posistion From A World Coordinate
	setCursorXFromTile(x)
	setCursorYFromTile(y)
end
function setCursorXFromTile(x) --Set The Cursor's X Posistion From A World Coordinate
	prevX = selectX
	selectX = x
end
function setCursorYFromTile(y) --Set The Cursor's Y Posistion From A World Coordinate
	prevY = selectY
	selectY = y
end

function updateCursorPos() --Update The Cursor's posistion From The Mouse's Posistion
	if start and mainPlayer:canMove() then
		if love.mouse.getX() > 0 and love.mouse.getX() < width then
			setCursorXFromPixel(love.mouse.getX())
		end
		if love.mouse.getY() > 0 and love.mouse.getY() < height then
			setCursorYFromPixel(love.mouse.getY())
		end
	end
end

function overlayBlockDamage(x,y,curTime,breakTime) --Temporary Code For Block Breaking
	local increment = breakTime/8 --Get The Amount Of Time Between Each Damage Stage
	local stage = math.floor(curTime/increment) --Get What Stage Of Damage The Block Is On
	local overlay = gfx.newQuad(((379+stage)%(texFile:getWidth()/tileWidth))*tileWidth,math.floor((379+stage)/(texFile:getHeight()/tileHeight))*tileHeight,tileWidth,tileHeight,texFile:getWidth(),texFile:getHeight())
	
	gfx.drawq(texFile,overlay,((x-1)*tileWidth)*0.75,((y-1)*tileHeight)*0.75,0,0.75)
end

function updateBlocks() --Change Blocks That Have Been Clicked
	if start and mainPlayer:canMove() then
		if mouseDown and not love.mouse.isDown("l") then
			mouseDown = false
		end
		
		if love.mouse.isDown("l") then
			if getBlock(selectX,selectY) ~= blocks.stone:getBlockID() and mouseDown == false then
				setBlock(selectX,selectY,blocks.stone:getBlockID())
				mouseDown = true
				prevX = selectX
				prevY = selectY
			elseif getBlock(selectX,selectY) == blocks.stone:getBlockID() and mouseDown == false then
				setBlock(selectX,selectY,blocks.dirt:getBlockID())
				mouseDown = true
				prevX = selectX
				prevY = selectY
			elseif getBlock(selectX,selectY) == blocks.air:getBlockID() and mouseDown == false then
				setBlock(selectX,selectY,blocks.dirt:getBlockID())
				mouseDown = true
				prevX = selectX
				prevY = selectY
			end
			
			if mouseDown then
				if selectX ~= prevX or selectY ~= prevY then
					mouseDown = false
				end
			end
		end
		
		if love.mouse.isDown("r") then
			if blockBreaking == false then
				if getBlock(selectX,selectY) ~= blocks.air:getBlockID() then
					blockBreaking = true
					blockBreakStartTime = love.timer.getTime()
					blockBreakEndTime = blockBreakStartTime + blockids[getBlock(selectX,selectY)].class:getTimeToBreak()
					blockBreakCurTime = blockBreakStartTime
				end
			end
			if blockBreaking then
				if blockBreakCurTime >= blockBreakEndTime then
					blockBreaking = false
					blockBreakStartTime = 0
					blockBreakEndTime = 0
					blockBreakCurTime = 0
					setBlock(selectX,selectY,blocks.air:getBlockID())
				else
					blockBreakCurTime = love.timer.getTime()
					overlayBlockDamage(selectX,selectY,blockBreakCurTime-blockBreakStartTime,blockids[getBlock(selectX,selectY)].class:getTimeToBreak())
				end
			end
			if prevX ~= selectX or prevY ~= selectY then
				blockBreaking = false
				blockBreakStartTime = 0
				blockBreakEndTime = 0
				blockBreakCurTime = 0
			end
		else
			blockBreaking = false
			blockBreakStartTime = 0
			blockBreakEndTime = 0
			blockBreakCurTime = 0
		end
	end
end