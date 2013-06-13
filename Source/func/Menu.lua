menu.maps,menu.corruptWorld,menu.oldWorld,menu.selectWorld,menu.worldName = {false,false,false,false,false},nil,nil,nil,nil
buttons = {}
	buttons.start = {}
		buttons.start.single  					  = classes.Button:new(width/2-123	,height/2-115,245,50,colors.defaultFore,colors.defaultBack,"SINGLEPLAYER")
		buttons.start.multi   					  = classes.Button:new(width/2-123	,height/2-55 ,245,50,colors.defaultFore,colors.defaultBack,"MULTIPLAYER")
		buttons.start.screen  					  = classes.Button:new(width/2-123	,height/2+5  ,245,50,colors.defaultFore,colors.defaultBack,"SCREENSHOTS")
		buttons.start.options 				 	  = classes.Button:new(width/2-123	,height/2+65 ,120,50,colors.defaultFore,colors.defaultBack,"OPTIONS")
		buttons.start.quit    					  = classes.Button:new(width/2+2  	,height/2+65 ,120,50,colors.defaultFore,colors.defaultBack,"QUIT")
	buttons.singleplayer 						  = {}
		buttons.singleplayer.list   			  = {}
		buttons.singleplayer.back   			  = classes.Button:new(5          	,5           ,100,50,colors.defaultFore,colors.defaultBack,"BACK")
		buttons.singleplayer.load   			  = classes.Button:new(width/2-160	,height/2+175,150,50,colors.defaultFore,colors.defaultBack,"LOAD WORLD")
		buttons.singleplayer.delete 			  = classes.Button:new(width/2+10 	,height/2+175,150,50,colors.defaultFore,colors.defaultBack,"DELETE WORLD")
		buttons.singleplayer.gen    			  = classes.Button:new(width/2-75 	,height/2+200,150,50,colors.defaultFore,colors.defaultBack,"GENERATE WORLD")
		
		buttons.singleplayer.corrupt = {}
			buttons.singleplayer.corrupt.yes 	  = classes.Button:new(width/2-75-85,height/2+175,150,80,colors.defaultFore,colors.defaultBack,"YES")
			buttons.singleplayer.corrupt.no  	  = classes.Button:new(width/2-75+85,height/2+175,150,80,colors.defaultFore,colors.defaultBack,"NO")
		buttons.singleplayer.format = {}
			buttons.singleplayer.format.yes 	  = classes.Button:new(width/2-75-85,height/2+175,150,80,colors.defaultFore,colors.defaultBack,"YES")
			buttons.singleplayer.format.no  	  = classes.Button:new(width/2-75+85,height/2+175,150,80,colors.defaultFore,colors.defaultBack,"NO")
		buttons.singleplayer.generate = {}
			buttons.singleplayer.generate.name   = classes.TextBox:new(width/2-50	,72 		 ,100,50,{255,255,255,30}  ,colors.defaultBack)
			buttons.singleplayer.generate.seed   = classes.TextBox:new(width/2-50	,162		 ,100,50,{255,255,255,30}  ,colors.defaultBack)
			buttons.singleplayer.generate.selectedbox = nil
			buttons.singleplayer.generate.gen     = classes.Button:new(width/2-160	,height/2+175,150,50,colors.defaultFore,colors.defaultBack,"GENERATE WORLD")
			buttons.singleplayer.generate.cancel  = classes.Button:new(width/2+10 	,height/2+175,150,50,colors.defaultFore,colors.defaultBack,"CANCEL")
	buttons.multiplayer 						  = {}
		buttons.multiplayer.back 	   			  = classes.Button:new(5			,5			 ,100,50,colors.defaultFore,colors.defaultBack,"BACK")
	buttons.options 							  = {}
		buttons.options.back     	   			  = classes.Button:new(5			,5			 ,100,50,colors.defaultFore,colors.defaultBack,"BACK")
		buttons.options.controls 	   			  = classes.Button:new(width/2-50	,height/2-55 ,100,50,colors.defaultFore,colors.defaultBack,"CONTROLS")
		buttons.options.help					  = classes.Button:new(width/2-50	,height/2+5  ,100,50,colors.defaultFore,colors.defaultBack,"HELP")
		
		buttons.options.ctrls 					  = {}
			buttons.options.ctrls.back 			  = classes.Button:new(5			,5			 ,100,50,colors.defaultFore,colors.defaultBack,"BACK")
			buttons.options.ctrls.controller	  = classes.Button:new(width/2-123  ,height/2-115,225,50,colors.defaultFore,colors.defaultBack,"KEYBOARD")
			buttons.options.ctrls.selectedbox	  = nil
			buttons.options.ctrls.left			  = classes.Button:new(width/2-123  ,height/2-55 ,100,50,colors.defaultFore,colors.defaultBack,"LEFT: "..string.upper(controls.left))
			buttons.options.ctrls.right			  = classes.Button:new(width/2+2	,height/2-55 ,100,50,colors.defaultFore,colors.defaultBack,"RIGHT: "..string.upper(controls.right))
			if controls.jump ~= " " then
				buttons.options.ctrls.jump		  = classes.Button:new(width/2-123	,height/2+5	 ,100,50,colors.defaultFore,colors.defaultBack,"JUMP: "..string.upper(controls.jump))
			else
				buttons.options.ctrls.jump		  = classes.Button:new(width/2-123	,height/2+5	 ,100,50,colors.defaultFore,colors.defaultBack,"JUMP: ".."SPACEBAR")
			end
		buttons.options.hlp						  = {}
			buttons.options.hlp.back			  = classes.Button:new(5			,5			 ,100,50,colors.defaultFore,colors.defaultBack,"BACK")
	buttons.quit 								  = {}
		buttons.quit.yes 						  = classes.Button:new(width/2-75-85,height/2+175,150,80,colors.defaultFore,colors.defaultBack,"YES")
		buttons.quit.no  						  = classes.Button:new(width/2-75+85,height/2+175,150,80,colors.defaultFore,colors.defaultBack,"NO")
	buttons.paused 								  = {}
		buttons.paused.resume 					  = classes.Button:new(5  			,height-55	 ,150,50,colors.defaultFore,colors.defaultBack,"RESUME")
		buttons.paused.title  					  = classes.Button:new(160			,height-55	 ,150,50,colors.defaultFore,colors.defaultBack,"QUIT TO TITLE")
menu.name = "start"
sounds.bgm:play()

function titleButtonPress(x,y,button) --Check For Button Clicks
	if menu.name then if button == "l" then
		--Check For Button Presses On The Main Menu
		if menu.name == "start" then
			if buttons.start.single:clicked(x,y) then
				sounds.select:stop()
				sounds.select:play()
				menu.name = "singleplayer"
			elseif buttons.start.multi:clicked(x,y) then
				sounds.select:stop()
				sounds.select:play()
				menu.name = "multiplayer"
			elseif buttons.start.screen:clicked(x,y) then
				sounds.select:stop()
				sounds.select:play()
				if not fs.exists("screenshots") then
					fs.mkdir("screenshots")
				end
				if love._os == "Windows" then
					os.execute("explorer "..string.gsub(fs.getSaveDirectory().."/screenshots","/","\\"))
				elseif love._os == "Linux" then
					os.execute("nautilus "..fs.getSaveDirectory().."/screenshots")
				elseif love._os == "OS X" then
					os.execute("open "..fs.getSaveDirectory().."/screenshots")
				end
			elseif buttons.start.options:clicked(x,y) then
				sounds.select:stop()
				sounds.select:play()
				menu.name = "options"
			elseif buttons.start.quit:clicked(x,y) then
				love.event.quit()
			end
			
			--Check For Buttons Presses In The Singleplayer Menu
			elseif menu.name == "singleplayer" then
				if buttons.singleplayer.back:clicked(x,y) then
					sounds.select:stop()
					sounds.select:play()
					menu.selectWorld = nil
					menu.name = "start"
				end
				
				for m=1,#menu.maps do
					if buttons.singleplayer.list[m]:clicked(x,y) then
						menu.selectWorld = m
					end
				end
				
				if menu.selectWorld then
					if menu.maps[menu.selectWorld] then
						if buttons.singleplayer.load:clicked(x,y) then
							sounds.select:stop()
							sounds.select:play()
							sounds.bgm:stop()
							local res,world = loadWorld(tostring(menu.selectWorld))
							if res == "failed" then
								menu.corruptWorld = world
								menu.name = "corrupt"
							elseif res == "format" then
								menu.oldWorld = world
								menu.name = "format"
							end
						elseif buttons.singleplayer.delete:clicked(x,y) then
							sounds.select:stop()
							sounds.select:play()
							deleteWorld(tostring(menu.selectWorld))
						end
					else
						if buttons.singleplayer.gen:clicked(x,y) then
							sounds.select:stop()
							sounds.select:play()
							sounds.bgm:stop()
							menu.name = "generate"
						end
					end
				end
				
				elseif menu.name == "generate" then
					if buttons.singleplayer.generate.name:clicked(x,y) then
						buttons.singleplayer.generate.selectedbox = buttons.singleplayer.generate.name
						buttons.singleplayer.generate.name.color = {255,255,255,100}
						buttons.singleplayer.generate.seed.color = {255,255,255,30}
					elseif buttons.singleplayer.generate.seed:clicked(x,y) then
						buttons.singleplayer.generate.selectedbox = buttons.singleplayer.generate.seed
						buttons.singleplayer.generate.seed.color = {255,255,255,100}
						buttons.singleplayer.generate.name.color = {255,255,255,30}
					elseif buttons.singleplayer.generate.gen:clicked(x,y) and buttons.singleplayer.generate.name:getText() ~= "" then
						sounds.select:stop()
						sounds.select:play()
						menu.worldName = buttons.singleplayer.generate.name:getText()
						if buttons.singleplayer.generate.seed:getText() ~= "" then newWorld(buttons.singleplayer.generate.seed:getText()) else newWorld("") end
					elseif buttons.singleplayer.generate.cancel:clicked(x,y) then
						sounds.select:stop()
						sounds.select:play()
						buttons.singleplayer.generate.name:changeText("")
						buttons.singleplayer.generate.name.color = {255,255,255,30}
						buttons.singleplayer.generate.seed:changeText("")
						buttons.singleplayer.generate.seed.color = {255,255,255,30}
						buttons.singleplayer.generate.selectedbox = nil
						menu.name = "singleplayer"
					end
				
				
				elseif menu.name == "paused" then
					if buttons.paused.resume:clicked(x,y) then
						sounds.select:stop()
						sounds.select:play()
						mainPlayer:setMove(true)
						love.mouse.setVisible(false)
						menu.name = nil
						mouseDown = true
						mainPlayer:setCursorFromPixel(mse.getPosition())
					elseif buttons.paused.title:clicked(x,y) then
						sounds.select:stop()
						sounds.select:play()
						sounds.bgm:play()
						mainPlayer:setMove(true)
						start = false
						saveWorld(tostring(menu.selectWorld))
						menu.name = "start"
					end
					
			--Check For Button Presses In The Multiplayer Menu
			elseif menu.name == "multiplayer" then
				if buttons.multiplayer.back:clicked(x,y) then
					sounds.select:stop()
					sounds.select:play()
					menu.name = "start"
				end
				
			--Check For Button Presses In The Options Menus
			elseif menu.name == "options" then
				if buttons.options.back:clicked(x,y) then
					sounds.select:stop()
					sounds.select:play()
					menu.name = "start"
				end
				if buttons.options.controls:clicked(x,y) then
					sounds.select:stop()
					sounds.select:play()
					menu.name = "controls"
				end
				if buttons.options.help:clicked(x,y) then
					sounds.select:stop()
					sounds.select:play()
					menu.name = "help"
				end

				elseif menu.name == "controls" then
					if buttons.options.ctrls.back:clicked(x,y) then
						sounds.select:stop()
						sounds.select:play()
						menu.name = "options"
						mainPlayer:updateControls(controls.left,controls.right,controls.jump,controls.gamepad)
					end
					if buttons.options.ctrls.controller:clicked(x,y) then
						sounds.select:stop()
						sounds.select:play()
						if not controls.gamepad then
							buttons.options.ctrls.controller:changeText("GAMEPAD")
							controls.gamepad = true
						else
							buttons.options.ctrls.controller:changeText("KEYBOARD")
							controls.gamepad = false
						end
					end
					if not controls.gamepad then
						if buttons.options.ctrls.left:clicked(x,y) then
							sounds.select:stop()
							sounds.select:play()
							buttons.options.ctrls.selectedbox = buttons.options.ctrls.left
						end
						if buttons.options.ctrls.right:clicked(x,y) then
							sounds.select:stop()
							sounds.select:play()
							buttons.options.ctrls.selectedbox = buttons.options.ctrls.right
						end
						if buttons.options.ctrls.jump:clicked(x,y) then
							sounds.select:stop()
							sounds.select:play()
							buttons.options.ctrls.selectedbox = buttons.options.ctrls.jump
						end
					end
				
				elseif menu.name == "help" then
					if buttons.options.hlp.back:clicked(x,y) then
						sounds.select:stop()
						sounds.select:play()
						menu.name = "options"
					end
					
			--Check For Button Presses On Error Screens
			elseif menu.name == "corrupt" then
				if buttons.singleplayer.corrupt.yes:clicked(x,y) then
					sounds.select:stop()
					sounds.select:play()
					deleteWorld(menu.corruptWorld)
					menu.corruptWorld = nil
					menu.name = "singleplayer"
				elseif buttons.singleplayer.corrupt.no:clicked(x,y) then
					sounds.select:stop()
					sounds.select:play()
					menu.name = "singleplayer"
				end
		end
	elseif button == "wu" and menu.selectWorld then
		if menu.selectWorld > 1 then menu.selectWorld = menu.selectWorld - 1 end
	elseif button == "wd" and menu.selectWorld then
		if menu.selectWorld < 5 then menu.selectWorld = menu.selectWorld + 1 end
	end
	end
end

function drawTitle() --Draw The Menu
	--Draw Buttons On The Main Menu
	if menu.name then if menu.name == "start" then
		buttons.start.single:draw()
		buttons.start.multi:draw()
		buttons.start.screen:draw()
		buttons.start.options:draw()
		buttons.start.quit:draw()
	elseif menu.name == "singleplayer" then
		buttons.singleplayer.back:draw()
		for m=1,#menu.maps do
			if fs.exists("saves/world"..tostring(m)) and fs.isDirectory("saves/world"..tostring(m)) and fs.exists("saves/world"..tostring(m).."/worldName") then
				menu.maps[m] = true
			else
				menu.maps[m] = false
			end
				
			if menu.maps[m] then
				local name = fs.newFile("/saves/world"..tostring(m).."/worldName")
				name:open("r")
				buttons.singleplayer.list[m] = classes.Button:new(width/2-50,height/2+((m%6)*60-230),100,50,colors.defaultFore,colors.defaultBack,name:read())
				name:close()
				buttons.singleplayer.list[m]:draw()
			else
				buttons.singleplayer.list[m] = classes.Button:new(width/2-50,height/2+((m%6)*60-230),100,50,colors.defaultFore,colors.defaultBack,"")
				buttons.singleplayer.list[m]:draw()
			end
		end
		
		if menu.selectWorld then
			gfx.setColor(250,100,100)
			gfx.triangle("line",width/2-60.5,height/2+(((menu.selectWorld%6))*60-205.5),width/2-75.5,height/2+(((menu.selectWorld%6))*60-205+5.5),width/2-75.5,height/2+(((menu.selectWorld%6))*60-205-5.5))
			gfx.setColor(200,100,100)
			gfx.triangle("fill",width/2-60.5,height/2+(((menu.selectWorld%6))*60-205.5),width/2-75.5,height/2+(((menu.selectWorld%6))*60-205+5.5),width/2-75.5,height/2+(((menu.selectWorld%6))*60-205-5.5))
			gfx.setColor(250,100,100)
			gfx.triangle("line",width/2+60.5,height/2+(((menu.selectWorld%6))*60-205.5),width/2+75.5,height/2+(((menu.selectWorld%6))*60-205+5.5),width/2+75.5,height/2+(((menu.selectWorld%6))*60-205-5.5))
			gfx.setColor(200,100,100)
			gfx.triangle("fill",width/2+60.5,height/2+(((menu.selectWorld%6))*60-205.5),width/2+75.5,height/2+(((menu.selectWorld%6))*60-205+5.5),width/2+75.5,height/2+(((menu.selectWorld%6))*60-205-5.5))
			
			if menu.maps[menu.selectWorld] then
				buttons.singleplayer.load:draw()
				buttons.singleplayer.delete:draw()
			else
				buttons.singleplayer.gen:draw()
			end
		end
	elseif menu.name == "multiplayer" then
		buttons.multiplayer.back:draw()
		gfx.setFont(bigFont)
		gfx.printf("Multiplayer is not yet implemented. This is a placeholdeder menu.",0,height/2-25,width,"center")
		gfx.setFont(regFont)
	elseif menu.name == "options" then
		buttons.options.back:draw()
		buttons.options.controls:draw()
		buttons.options.help:draw()
	elseif menu.name == "controls" then
		buttons.options.ctrls.back:draw()
		buttons.options.ctrls.controller:draw()
		if not controls.gamepad then
			buttons.options.ctrls.left:draw()
			buttons.options.ctrls.right:draw()
			buttons.options.ctrls.jump:draw()
		end
	elseif menu.name == "help" then
		buttons.options.hlp.back:draw()
	elseif menu.name == "corrupt" then
		gfx.setFont(bigFont)
		gfx.printf(menu.corruptWorld.."'s World Data Corrupt, Delete?",0,height/2-25,width,"center")
		buttons.singleplayer.corrupt.yes:draw()
		buttons.singleplayer.corrupt.no:draw()
		gfx.setFont(regFont)
	elseif menu.name == "paused" then
		buttons.paused.resume:draw()
		buttons.paused.title:draw()
	elseif menu.name == "format" then
		gfx.setFont(bigFont)
		gfx.printf(menu.oldWorld.."'s World Format Is Out Of Date, Convert?",0,height/2-25,width,"center")
		buttons.singleplayer.format.yes:draw()
		buttons.singleplayer.format.no:draw()
		gfx.setFont(regFont)
	elseif menu.name == "generate" then
		buttons.singleplayer.generate.name:draw()
			local x,y,width,height = buttons.singleplayer.generate.name:coords()
			gfx.setColor(100,120,0);gfx.setFont(medFont)
			gfx.print("Name:",x-gfx.getFont():getWidth("Name: "),y+gfx.getFont():getHeight()/2);gfx.setFont(regFont)
		buttons.singleplayer.generate.seed:draw()
			local x,y,width,height = buttons.singleplayer.generate.seed:coords()
			gfx.setColor(100,120,0);gfx.setFont(medFont)
			gfx.print("Seed:",x-gfx.getFont():getWidth("Seed: "),y+gfx.getFont():getHeight()/2);gfx.setFont(regFont)
		buttons.singleplayer.generate.gen:draw()
		buttons.singleplayer.generate.cancel:draw()
	end
	end
end

function titleKeyPress(button,unicode)
	if button == "up" and menu.selectWorld and menu.name == "singleplayer" then
		if menu.selectWorld > 1 then menu.selectWorld = menu.selectWorld - 1 end
	elseif button == "down" and menu.selectWorld and menu.name == "singleplayer" then
		if menu.selectWorld < 5 then menu.selectWorld = menu.selectWorld + 1 end
	elseif button == "return" and menu.selectWorld and menu.name == "singleplayer" then
		if menu.maps[menu.selectWorld] == true then
			local res,world = loadWorld(tostring(menu.selectWorld))
			if res == "failed" then
				menu.corruptWorld = world
				menu.name = "corrupt"
			elseif res == "format" then
				menu.oldWorld = world
				menu.name = "format"
			end
		else
			menu.name = "generate"
		end
	elseif menu.name == "generate" and buttons.singleplayer.generate.selectedbox then
		if unicode > 31 and unicode < 127 then
			buttons.singleplayer.generate.selectedbox:changeText(buttons.singleplayer.generate.selectedbox:getText()..string.char(unicode))
		elseif unicode == 8 then
			buttons.singleplayer.generate.selectedbox:changeText(string.sub(buttons.singleplayer.generate.selectedbox:getText(),1,-2))
		end
	elseif menu.name == "controls" and buttons.options.ctrls.selectedbox then
		local text = buttons.options.ctrls.selectedbox:getText()
		if button ~= " " then
			buttons.options.ctrls.selectedbox:changeText(string.sub(text,1,string.find(text," "))..string.upper(button))
		else
			buttons.options.ctrls.selectedbox:changeText(string.sub(text,1,string.find(text," ")).."SPACEBAR")
		end
		if string.sub(text,1,string.find(text,":")) == "LEFT:" then
			controls.left = button
		elseif string.sub(text,1,string.find(text,":")) == "RIGHT:" then
			controls.right = button
		elseif string.sub(text,1,string.find(text,":")) == "JUMP:" then
			controls.jump = button
		end
		buttons.options.ctrls.selectedbox = nil
	end
end