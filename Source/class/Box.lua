--Box Class
classes.Box = object {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	color = {0,0,0},
	outColor = {0,0,0}
}
function classes.Box:__init(x,y,width,height,color,outColor)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.color = color
	self.outColor = outColor
end
function classes.Box:draw()
	tmpr,tmpg,tmpb = gfx.getColor()
	gfx.setColor(self.color)
	gfx.rectangle("fill",self.x,self.y,self.width,self.height)
	gfx.setColor(self.outColor)
	gfx.rectangle("line",self.x,self.y,self.width,self.height)
	gfx.setColor(tmpr,tmpb,tmpg)
end
function classes.Box:coords()
	return self.x,self.y,self.width,self.height
end

--Text Box Class
classes.TextBox = classes.Box:extends {
	text = ""
}
function classes.TextBox:__init(x,y,width,height,color,outColor)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.color = color
	self.outColor = outColor
end
function classes.TextBox:draw()
	tmpr,tmpg,tmpb = gfx.getColor()
	gfx.setColor(self.color)
	gfx.rectangle("fill",self.x,self.y,self.width,self.height)
	gfx.setColor(self.outColor)
	gfx.rectangle("line",self.x,self.y,self.width,self.height)
	gfx.printf(self.text,self.x,(self.y+self.height/2)-gfx.getFont():getHeight()/2,self.width,"center")
	gfx.setColor(tmpr,tmpb,tmpg)
end
function classes.TextBox:getText()
	return self.text
end
function classes.TextBox:changeText(text)
	self.text = text
end
function classes.TextBox:clicked(mx,my)
	if mx > self.x and mx < self.x+self.width and my > self.y and my < self.y+self.height then
		return true
	end
	return false
end

--Button Class
classes.Button = classes.Box:extends {
	text = "",
	clickable = true,
	pressable = false
}
function classes.Button:__init(x,y,width,height,color,outColor,text)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.color = color
	self.outColor = outColor
	self.text = text
end
function classes.Button:draw()
	tmpr,tmpg,tmpb = gfx.getColor()
	gfx.setColor(self.color)
	gfx.rectangle("fill",self.x,self.y,self.width,self.height)
	gfx.setColor(self.outColor)
	gfx.rectangle("line",self.x,self.y,self.width,self.height)
	gfx.printf(self.text,self.x,(self.y+self.height/2)-gfx.getFont():getHeight()/2,self.width,"center")
	gfx.setColor(tmpr,tmpb,tmpg)
end
function classes.Button:getText()
	return self.text
end
function classes.Button:changeText(text)
	self.text = text
end
function classes.Button:clicked(mx,my)
	if mx > self.x and mx < self.x+self.width and my > self.y and my < self.y+self.height then
		return true
	end
	return false
end