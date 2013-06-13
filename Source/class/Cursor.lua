require("class/Player")

classes.Cursor = object {
	x = nil, --X Pixel Coordinate
	y = nil, --Y Pixel Coordinate
	
	worldX = 1, --X World Coordinate
	worldY = 1, --Y World Coordinate
	lastX  = 1, --Previous X World Coordinate
	lastY  = 1, --Previous Y World Coordinate
	
	outline = gfx.newImage("gfx/select.png"), --Block Outline Image
	blockBreaking   = false, --If A Block Is Being Broke
	blockBreakStartTime = 0, --Time Block Started Breaking
	blockBreakEndTime   = 0, --Time Block Will Break
	blockBreakCurTime   = 0  --Current Time
}
function classes.Cursor:__init() end

function classes.Cursor:update(x,y)
	self.x,self.y = x,y
	self:setCursorFromPixel(x,y)
end

function classes.Cursor:draw()
	gfx.draw(self.outline,(self.worldX-1)*scaleTileWidth,(self.worldY-1)*scaleTileHeight)
end

function classes.Cursor:setCursorFromPixel(x,y) --Set The Cursor's Position From A Specific Pixel
	self:setCursorXFromPixel(x)
	self:setCursorYFromPixel(y)
end
function classes.Cursor:setCursorXFromPixel(x) --Set The Cursor's X Posistion From A Specific Pixel
	self.lastX = self.worldX
	self.worldX = math.ceil(x/24)
end
function classes.Cursor:setCursorYFromPixel(y) --Set The Cursor's Y Posistion From A Specific Pixel
	self.lastY = self.worldY
	self.worldY = math.ceil(y/24)
end

function classes.Cursor:setCursorFromTile(x,y) --Set The Cursor's Posistion From A World Coordinate
	self:setCursorXFromTile(x)
	self:setCursorYFromTile(y)
end
function classes.Cursor:setCursorXFromTile(x) --Set The Cursor's X Posistion From A World Coordinate
	self.lastX = self.worldX
	self.worldX = x
end
function classes.Cursor:setCursorYFromTile(y) --Set The Cursor's Y Posistion From A World Coordinate
	self.lastY = self.worldY
	self.worldY = y
end