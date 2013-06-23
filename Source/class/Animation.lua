classes.Animation = object {
	on = false,
	startTime = 0,
	curTime = 0,
	endTime = 0,
	
	frameTime = 0
}
function classes.Animation:__init(ft)
	self.frameTime = ft
end

function classes.Animation:start()
	self.on = true
	self.startTime = love.timer.getTime()
	self.curTime = self.startTime
	self.endTime = self.startTime + self.frameTime
end
function classes.Animation:stop()
	self.on = false
	self.startTime = 0
	self.curTime = 0
	self.endTime = 0
end

function classes.Animation:setFrameTime(frame)
	self.frameTime = frame
end

function classes.Animation:running()
	return self.on
end
function classes.Animation:getTimes()
	return self.startTime, self.curTime, self.endTime, self.curTime >= self.endTime
end

function classes.Animation:update()
	if not self.on then
		return 0
	else
		if self.curTime >= self.endTime then
			local returnValue = (self.curTime-self.startTime)/(self.endTime-self.startTime)
		
			self.startTime = love.timer.getTime() + returnValue*self.frameTime
			self.curTime = love.timer.getTime()
			self.endTime = self.startTime + self.frameTime
			
			return returnValue
		else
			self.curTime = love.timer.getTime()
			return 0
		end
	end
end