function love.conf(t)
	love.filesystem.setRelease(true)
	t.title  = "Terraria Clone"
	t.author = "Afterlife Games"

	t.identity = "afterlifegames/terrariaclone"
	t.release = false
	t.console = false 	
	t.version = "0.8.0"
	t.screen.fullscreen = false

	t.screen.width = 960 --40 Blocks Wide
	t.screen.height = 576 --24 Blocks High
end
