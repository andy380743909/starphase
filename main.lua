--[[
 * Copyright (C) 2016 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 

assert(love.graphics.isSupported("canvas"), "Your graphics card does not support canvases, sorry!")

require("misc")
require("binds")
require("collision")
require("sound")
require("starfield")
require("screen/title")
require("screen/hud")
require("screen/fonts")
require("entities/pickups")
require("entities/enemies")
require("entities/explosions")
require("entities/player")
require("entities/projectiles")



function love.load(args)


	debug = false
	debugarcade = false
	cheats = {
		invincible = false,
	}
	
	--parse command line arguments to the game
	for _,arg in pairs(args) do
		if arg == "-debug" or arg == "-d" then debug = true end
		if arg == "-fullscreen" or arg == "-f" then love.window.setFullscreen(1) end
	end
	
	
	
	--initialize seed
	math.randomseed(os.time())

	game = {}
	game.width, game.height, game.flags = love.window.getMode( )

	game.max_fps = game.flags.refreshrate
	game.min_dt = 1/game.max_fps
	game.next_time = love.timer.getTime()
	
	game.scale = {}
	game.scale.x = love.graphics.getWidth()/1920
	game.scale.y = love.graphics.getHeight()/1080
	game.scale.w = 1920
	game.scale.h = 1080
	
	cursor = love.mouse.newCursor( "gfx/cursor.png", 0, 0 )
	love.mouse.setCursor(cursor)	

	title:init()
	
end


--test function
function initarcade(playersel)
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	paused = false
	debugarcade = false
	mode = "arcade"
	love.graphics.setBackgroundColor(0,0,0,255)
	
	starfield.offset = love.graphics.getHeight()/2-200
	starfield.nebulae.r = 0
	starfield.nebulae.g = 255
	starfield.nebulae.b = 255
	player:init(playersel)
	starfield.speed = 1.0
	starfield:populate()
	hud:init()

	
	sound:playbgm(math.random(3,#sound.music))
end

function initdebugarcade(playersel)
	initarcade(playersel)
	debugarcade = true
end


function love.update(dt)
	--cap fps

		dt = math.min(dt, game.min_dt)
		game.next_time = game.next_time + game.min_dt
	
	--process arcade game mode
	if mode == "arcade" then
		starfield:update(dt)
		projectiles:update(dt)
		enemies:update(dt)
		explosions:update(dt)
		player:update(dt)
		pickups:update(dt)
		hud:update(dt)
	end
	
	--process titlescreen
	if mode == "title" then
		title:update(dt)
	end
	
	--process the debug console
	hud:updateconsole(dt)

end



	
function love.draw()
	--investigate this......
	--love.graphics.scale(game.scale.x,game.scale.y)
	
	--draw arcade game
	if mode == "arcade" then
		starfield:draw(0,-player.y/4)
		
		hud:draw()
	end
	
	
	--draw title screen
	if mode == "title" then
		title:draw()
	end
	
	--draw the debug console
	hud:drawconsole()
	

	-- caps fps

	local cur_time = love.timer.getTime()
	if game.next_time <= cur_time then
		game.next_time = cur_time
		return
	end
	love.timer.sleep(game.next_time - cur_time)

end




function love.keypressed(key)
if key == "k" then pickups:add(200,200) end


	--global controls
	if key == binds.fullscreen then misc:togglefullscreen() end
	if key == binds.console then debug = not debug end
	
	--arcade mode controls
	if mode == "arcade" then
		if key == binds.pause then 
			misc:togglepaused()
		end
	
		if paused then
			if key == binds.pausequit then  title:init() end
		end
	end
	
	--title screen controls
	if mode == "title" then
		title:keypressed(key)
	end
	
	if key == "0" then
		love.window.setMode(1024,(game.scale.h/game.scale.w)*1024 )
	end
	
	if key == "9" then
		love.window.setMode(800,(game.scale.h/game.scale.w)*800 )
	end
	
	if key == "8" then
		love.window.setMode(1200,(game.scale.h/game.scale.w)*1200 )
	end
	
	


end

function love.mousepressed(x,y,button) 

end


function love.focus(f)
	if f then
		print("Window focused.")
	else
		print("Window lost focused.")
		if mode == "arcade" then
			misc:pause()
		end
	end
end


function love.resize(w,h)
	
end

