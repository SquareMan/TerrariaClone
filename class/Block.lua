--Block Class
classes.Block = object {
	blockID = 0,
	texture = nil,
	name = "",
	mineReplace = false,
	caveReplace = false,
	metadata = 0,
	timeToBreak = .5
}
function classes.Block:__init(id,texnum,name,breakTime)
	self.blockID = id
	self.texture = gfx.newQuad((texnum%(texFile:getWidth()/tileWidth))*tileWidth,math.floor(texnum/(texFile:getHeight()/tileHeight))*tileHeight,tileWidth,tileHeight,texFile:getWidth(),texFile:getHeight())
	self.name = name
	if blockids[id] then error("Block ID "..id.." Is Already Taken By Block: \""..blockids[id].name.."\"") end
	blockids[id] = {}
	blockids[id].name = name
	blockids[id].class = self
	textures[id] = self.texture
	if breakTime ~= nil then self.timeToBreak = breakTime end
end
function classes.Block:getBlockID()
	return self.blockID
end
function classes.Block:getBlockMetadata()
	return self.metadata
end
function classes.Block:getBlockTexture()
	return self.texture
end
function classes.Block:getBlockName()
	return self.name
end
function classes.Block:setGenMinableReplaceable(flag)
	self.mineReplace = flag
end
function classes.Block:isGenMinableReplaceable()
	return self.mineReplace
end
function classes.Block:setCaveGenReplaceable(flag)
	self.caveReplace = flag
end
function classes.Block:isCaveGenReplaceable()
	return self.caveReplace
end
function classes.Block:setMetadata(m)
	self.metadata = m
end
function classes.Block:getTimeToBreak()
	return self.timeToBreak
end
function classes.Block:tick(x,y) end

--Load Extra Block Classes
local extraBlocks = fs.enumerate("class/Blocks")
for n=1,#extraBlocks do
	if string.sub(extraBlocks[n],string.len(extraBlocks[n])-3) == ".lua" then
		require("class/Blocks/"..string.gsub(extraBlocks[n], "%....", ""))
	end
end

--Blocks
texFile = love.graphics.newImage("gfx/blocks.png")
blocks.air = classes.Block:new(1,0,"air")
blocks.dirt = classes.BlockDirt:new(2,1,"dirt");blocks.dirt:setCaveGenReplaceable(true)
blocks.stone = classes.Block:new(3,2,"stone",1);blocks.stone:setGenMinableReplaceable(true);blocks.stone:setCaveGenReplaceable(true)
blocks.oreCoal = classes.Block:new(4,3,"oreCoal",1.5)
blocks.oreIron = classes.Block:new(5,4,"oreIron",1.5)
blocks.oreDiamond = classes.Block:new(6,5,"oreDiamond",1.5)
blocks.grass = classes.BlockGrass:new(7,0,"grass");blocks.grass:setCaveGenReplaceable(true)
blocks.oreEmerald = classes.Block:new(8,6,"oreEmerald",1.5)
blocks.oreSilver = classes.Block:new(9,7,"oreSilver",1.5)

function GenerateSurface() --Generate Ores On The Surface
	for r=1,3 do
		classes.GenCave:new():generate()
	end
	for r=1,5 do
		classes.GenMinable:new(blocks.oreCoal:getBlockID(),5):generate(math.random(1,40),math.random(17,24))
	end
	for r=1,3 do
		classes.GenMinable:new(blocks.oreIron:getBlockID(),3):generate(math.random(1,40),math.random(20,24))
	end
	for r=1,2 do
		classes.GenMinable:new(blocks.oreDiamond:getBlockID(),2):generate(math.random(1,40),math.random(22,24))
	end
	classes.GenMinable:new(blocks.oreEmerald:getBlockID(),3):generate(math.random(1,40),math.random(18,22))
	for r=1,5 do
		classes.GenMinable:new(blocks.oreSilver:getBlockID(),5):generate(math.random(1,40),math.random(20,24))
	end
	for r=1,math.random(1,3) do
		classes.GenMinable:new(blocks.dirt:getBlockID(),math.random(5,10)):generate(math.random(1,40),math.random(17,24))
	end
end