--Grass Class
classes.BlockGrass = classes.Block:extends {}

function classes.BlockGrass:tick(x,y)
	if getBlock(x,y-1) ~= blocks.air:getBlockID() then
		setBlock(x,y,blocks.dirt:getBlockID())
	end
end