--Ore Gen Class
classes.GenMinable = object {
	id = nil,
	size = nil
}
function classes.GenMinable:__init(id,size)
	self.id = id
	self.size = size
end
function classes.GenMinable:generate(posX,posY)
	while self.size > 0 do
		local side = math.random(1,4)
		if side == 1 then
			posX = posX-1
		elseif side == 2 then
			posX = posX+1
		elseif side == 3 then
			posY = posY-1
		elseif side == 4 then
			posY = posY+1
		end
		
		if posX > 0 and posX < 41 and posY > 0 and posY < 25 then
			if blockids[getBlock(posX,posY)].class:isGenMinableReplaceable() then
				setBlock(posX,posY,self.id)
			end
		end
		self.size = self.size-1
	end
end

--Cave Gen Class
classes.GenCave = object {

}
function classes.GenCave:generate()
	local size = math.random(10,100)
	local x = math.random(1,40)
	local y = math.random(1,24)
	while size > 0 do
		local side = math.random(1,4)
		if side == 1 then
			x = x-1
		elseif side == 2 then
			x = x+1
		elseif side == 3 then
			y = y-1
		elseif side == 4 then
			y = y+1
		end
		
		if x > 0 and x < #world[#world] and y > 0 and y < #world then
			if blockids[getBlock(x,y)].class:isCaveGenReplaceable() then
				setBlock(x,y,blocks.air:getBlockID())
			end
		end
		
		size = size-1
	end
end