--Dirt Class
classes.BlockDirt = classes.Block:extends {}

function classes.BlockDirt:tick(x,y)
	if  (getBlock(x-1,y) == blocks.grass:getBlockID() or
		getBlock(x+1,y) == blocks.grass:getBlockID() or
		getBlock(x-1,y-1) == blocks.grass:getBlockID() or
		getBlock(x-1,y+1) == blocks.grass:getBlockID() or
		getBlock(x+1,y-1) == blocks.grass:getBlockID() or
		getBlock(x+1,y+1) == blocks.grass:getBlockID()) and
		getBlock(x,y-1) == blocks.air:getBlockID()	then
	   
		setBlock(x,y,blocks.grass:getBlockID())
	end
end