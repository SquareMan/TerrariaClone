--File Access Class
classes.File = object {
	file = nil,
	filePath = "",
	mode = nil
}
function classes.File:__init(path)
	self.filePath = path
	self.file = fs.newFile(path)
end
function classes.File:changePath(path)
	self.file:close()
	self.mode = nil
	self.filePath = path
	self.file = fs.newFile(path)
end
function classes.File:close()
	self.filePath = nil
	self.file = nil
	self = nil
end
function classes.File:delete()
	fs.remove(self.filePath)
end

--Writing Functions
function classes.File:clear()
	self.file:close()
	self.file:open("w")
	self.file:close()
	self.mode = nil
end
function classes.File:newline()
	if self.mode ~= "a" then
		self.file:open("a")
		self.mode = "a"
	end
	self.file:write("\r\n")
end
function classes.File:write(data)
	if self.mode ~= "a" then
		self.file:open("a")
		self.mode = "a"
	end
	self.file:write(data)
end
function classes.File:writeln(data)
	if self.mode ~= "a" then
		self.file:open("a")
		self.mode = "a"
	end
	self.file:write(data.."\r\n")
end

--Reading Functions
function classes.File:read(bytes)
	if self.mode ~= "r" then
		self.file:open("r")
		self.mode = "r"
	end
	if bytes then
		return self.file:read(bytes)
	else
		return self.file:read()
	end
end
function classes.File:readln(line)
	local file = nil
	if love._os == "Windows" then
		file = io.open(string.gsub(fs.getSaveDirectory(),"/","\\").."\\"..string.gsub(self.filePath,"/","\\"))
	else
		file = io.open(fs.getSaveDirectory().."/"..self.filePath)
	end
	local fildata = nil
	for l=1,line do
		filedata = file:read("*l")
	end
	file:close()
	return filedata
end