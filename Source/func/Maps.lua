function initMap()
	world = {}
	world.md = {}
	for y=1,24 do
		world[y] = {}
		world.md[y] = {}
		for x=1,40 do
			world[y][x] = 1
			world.md[y][x] = 0
		end
	end
end

function getBlock(x,y)
	if x > 0 and x < worldWidth()+1 and y > 0 and y < worldHeight()+1 then
		return world[y][x],world.md[y][x]
	else
		return nil
	end
end

function setBlock(x,y,blockid)
	world[y][x] = 	 blockid
	world.md[y][x] = 0
end

function setBlockWithMetadata(x,y,blockid,blockmd)
	world[y][x] =	 blockid
	world.md[y][x] = blockmd
end

function worldWidth()
	return width/scaleTileWidth
end

function worldHeight()
	return height/scaleTileHeight
end

function genMap()
	initMap()
	for x=1,worldWidth() do
		for y=worldHeight()/2+1,worldHeight() do
			setBlock(x,y,blocks.stone:getBlockID())
		end
	end
	for x=1,worldWidth() do
		setBlock(x,worldHeight()/2+1,blocks.grass:getBlockID())
		setBlock(x,worldHeight()/2+2,blocks.dirt:getBlockID())
	end
	for x=1,worldWidth() do
		local tmp = math.random(1,5)
		if tmp ~= 5 then
			setBlock(x,worldHeight()/2+3,blocks.dirt:getBlockID())
		end
	end
	for x=1,worldWidth() do
		tmp = math.random(1,3)
		if tmp == 1 and getBlock(x,worldHeight()/2+3) == blocks.dirt:getBlockID() then
			setBlock(x,worldHeight()/2+4,blocks.dirt:getBlockID())
		end
	end
	GenerateSurface()
end

function drawMap()
	for x=1,width/scaleTileWidth do
		local xpos = (x-1)*tileWidth
		for y=1,height/scaleTileHeight do
			if math.random(1,5000) == 2 then blockids[getBlock(x,y)].class:tick(x,y) end
			local ypos = (y-1)*tileHeight
			if getBlock(x,y) ~= blocks.air:getBlockID() then
				gfx.drawq(texFile,blockids[getBlock(x,y)].class:getBlockTexture(),xpos*(scaleTileWidth/tileWidth),ypos*(scaleTileHeight/tileHeight),0,scaleTileWidth/tileWidth,scaleTileHeight/tileHeight)
			end
		end
	end
end

function newWorld(seed)
	--Move The Cursor To Prevent Placing A Block
	mainPlayer:getCursor().cursorDown = true
	mainPlayer:getCursor():setCursorFromPixel(mse.getPosition())
	gfx.setColor(255,255,255)
	
	--Make A Map
	if seed ~= "" then math.randomseed(seed) else math.randomseed(os.time()) end
	genMap()
	
	--Put The Game In Motion
	start = true
	love.mouse.setVisible(false)
	menu.name = nil
end

function loadWorld(worldName)
	if fs.exists("saves/world"..worldName.."/worldFormat") and fs.exists("saves/world"..worldName.."/worldData") and fs.exists("saves/world"..worldName.."/worldName") then			
		local save = classes.File:new("saves/world"..worldName.."/worldFormat")
		
		if worldFormat ~= save:read() then
			return "format",buttons.singleplayer.list[menu.selectWorld]:getText()
		end
		
		save:changePath("saves/world"..worldName.."/worldName")		
		buttons.singleplayer.list[menu.selectWorld]:changeText(save:read())		
		initMap()		
		save:changePath("saves/world"..worldName.."/worldData")
		
		for y=1,#world do
			for x=1,#world[y] do
				local bid = save:read(3)
				local bmd = save:read(2)
				if bid ~= "" and bmd ~= "" then
					setBlockWithMetadata(x,y,tonumber(bid),tonumber(bmd))
				else
					save:close()
					return "failed",buttons.singleplayer.list[menu.selectWorld]:getText()
				end
			end
		end
		save:close()
		
		--Move The Cursor To Prevent Placing A Block
		mainPlayer:getCursor().cursorDown = true
		mainPlayer:getCursor():setCursorFromPixel(mse.getPosition())
		gfx.setColor(255,255,255)
		
		--Put The Game In Motion
		start = true
		love.mouse.setVisible(false)
		menu.name = nil
	else
		return "failed",worldName
	end
end

function saveWorld(saveFile)
	if not fs.exists("saves/world"..saveFile) then
		fs.mkdir("saves/world"..saveFile)
		
		local save = classes.File:new("saves/world"..saveFile.."/worldFormat")
		save:write(worldFormat)
		save:changePath("saves/world"..saveFile.."/worldName")
		save:write(menu.worldName)
		save:changePath("saves/world"..saveFile.."/worldData")
		
		for y=1,#world do
			for x=1,#world[y] do
				local bid,bmd = getBlock(x,y)
				bid,bmd = tostring(bid),tostring(bmd)
				while string.len(bid) < 3 do
					bid = string.reverse(bid)
					bid = bid.."0"
					bid = string.reverse(bid)
				end
				while string.len(bmd) < 2 do
					bmd = string.reverse(bmd)
					bmd = bmd.."0"
					bmd = string.reverse(bmd)
				end
				save:write(bid..bmd)
			end
		end
		save:close()
	else
		local save = classes.File:new("saves/world"..saveFile.."/worldFormat")
		save:clear()
		save:write(worldFormat)
		save:changePath("saves/world"..saveFile.."/worldData")
		save:clear()
		
		for y=1,#world do
			for x=1,#world[y] do
				local bid,bmd = getBlock(x,y)
				bid,bmd = tostring(bid),tostring(bmd)
				while string.len(bid) < 3 do
					bid = string.reverse(bid)
					bid = bid.."0"
					bid = string.reverse(bid)
				end
				while string.len(bmd) < 2 do
					bmd = string.reverse(bmd)
					bmd = bmd.."0"
					bmd = string.reverse(bmd)
				end
				save:write(bid..bmd)
			end
		end
		save:close()
	end
end

function deleteWorld(worldName)
	local world = classes.File:new("saves/world"..worldName.."/worldData")
	world:delete()
	world:changePath("saves/world"..worldName.."/worldFormat")
	world:delete()
	world:changePath("saves/world"..worldName.."/worldName")
	world:delete()
	world:changePath("saves/world"..worldName)
	world:delete("saves/world"..worldName)
end

function getWorldName(world)
	local world = classes.File:new("savse/"..world.."/worldName")
	return world:read()
end