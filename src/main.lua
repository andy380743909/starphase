--[[
 * Copyright (C) 2016-2019 Ricky K. Thomson
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

function love.load(args)
	require("hud")
	require("loading")

	require("misc")
	require("camera")
	require("binds")
	require("joystick")
	require("collision")
	require("sound")
	require("textures")
	require("title")
	
	require("fonts")
	require("entities/pickups")
	require("entities/enemies")
	require("entities/explosions")
	require("entities/player")
	require("entities/projectiles")
	require("starfield")
	

	msgs = require("messagebox")
	
	msgs.callback = function() print("end of message test") end

	debug = false
	debugarcade = false
	
	cheats = {
		invincible = false,
	}
	
	--parse command line arguments to the game
	for _,arg in pairs(args) do
		if arg == "-debug" or arg == "-d" then debug = true end
		if arg == "-fullscreen" or arg == "-f" then love.window.setFullscreen(1) end
		if arg == "-mute" or arg == "-m" then sound.enabled = false end
	end
	
	game = {}
	
	game.width, game.height, game.flags = love.window.getMode( )
	game.seed = nil
	game.max_fps = game.flags.refreshrate
	--game.max_fps = 60
	game.min_dt = 1/game.max_fps
	game.next_time = love.timer.getTime()

	cursor = love.mouse.newCursor( "data/gfx/cursor.png", 0, 0 )
	love.mouse.setCursor(cursor)	

	sound:init()
	title:init()
	
end




--test function
function initarcade(playersel)
	-- arcade mode will use preset seeds determined on each level
	-- whereas infinite mode will use complete random eventually.
	starfield:setSeed()
	starfield:populate()
	starfield.minspeed = 30
	starfield.maxspeed = 1000
	
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	paused = false
	debugarcade = false
	mode = "arcade"
	love.graphics.setBackgroundColor(0,0,0,255)
		
	enemies.spawned = 0

	player:init(playersel)
	
	hud:init()

	local s = love.math.random(3,#sound.music)
	sound:playbgm(s)
end

function initdebugarcade(playersel)
	initarcade(playersel)
	debugarcade = true
	debug = true
	msgs.queue(
		{
			{		
				face = love.graphics.newImage("data/gfx/faces/1.png"),
				name = "Debug Mode",
				text = "Testing messagebox events...\n\nPress [M] to start dialog test\nPress [SPACE] to skip messages",
				duration = 60,
			}

	})
end


function love.update(dt)
	--cap fps

	--use this to slow down when setting < 60fps
	--dt = math.min(dt, game.min_dt)
		
	game.next_time = game.next_time + game.min_dt

	--process arcade game mode
	if mode == "arcade" then
		starfield:update(dt)
		projectiles:update(dt)
		enemies:update(dt)
		explosions:update(dt)
		pickups:update(dt)
		player:update(dt)
		hud:update(dt)
		msgs.update(dt)
	end
		
	--process titlescreen
	if mode == "title" then
		title:update(dt)
	end
		
	--process the debug console
	hud:updateconsole(dt)
end

function love.draw()
	--draw title screen
	if mode == "title" then
		title:draw()
	end

	if mode == "arcade" then
		--starfield:draw(0,-player.y/4)
		starfield:draw(0,0)
		hud:draw()
		msgs.draw()
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

	if debugarcade then 
		if key == "k" then 
			pickups:add(starfield.w/2,starfield.h/2) 
		end 
	end

	--global controls
	if key == binds.fullscreen then misc:togglefullscreen() end
	if key == binds.console then debug = not debug end
	
	--arcade mode controls
	if mode == "arcade" then
		if key == binds.pause then misc:togglepaused() end
	
		if paused then
			if key == binds.pausequit then  title:init() end
		end
	end
	
	--title screen controls
	if mode == "title" then
		title:keypressed(key)
	end
	
	msgs:keypressed(key)
	
	--debug enemy
	if debugarcade then
	if key == "1" then
		enemies:add_abomination()
	elseif key == "2" then
		enemies:add_asteroid()
	elseif key == "3" then
		enemies:add_crescent()
	elseif key == "4" then
		enemies:add_dart()
	elseif key == "5" then
		enemies:add_delta()
	elseif key == "6" then
		enemies:add_large()
	elseif key == "7" then
		enemies:add_train()
	elseif key == "8" then
		enemies:add_tri()
	elseif key == "9" then
		enemies:add_cruiser()
	elseif key == "tab" then
		
		starfield:setSeed()
		--starfield:populate()
		
		msgs.queue({
			{		
				face = love.graphics.newImage("data/gfx/faces/1.png"),
				name = "DEBUG: new seed",
				text = love.math.getRandomSeed(),
				duration = 1,
			}
		})
	
	elseif key == "m" then
		msgs.queue(
		{
			{		
				face = love.graphics.newImage("data/gfx/faces/face" .. love.math.random(1,10)..".png"),
				name = "Message Test",
				text = "Hello",
				duration = 2,
			},
			{		
				face = love.graphics.newImage("data/gfx/faces/face" .. love.math.random(1,10)..".png"),
				name = "Message Test",
				text = "I want to stop flying this ship!",
				duration = 3,
			},
			{		
				face = love.graphics.newImage("data/gfx/faces/face" .. love.math.random(1,10)..".png"),
				name = "Message Test",
				text = "PEW PEW PEW\n\n... *TRANSMISSION ERROR*",
				duration = 2,
			},
			{		
				face = love.graphics.newImage("data/gfx/faces/face" .. love.math.random(1,10)..".png"),
				name = "Message Test",
				text = "Trololololol lololol lololol...\nLolol lololololol",
				duration = 3,
			},
			{		
				face = love.graphics.newImage("data/gfx/faces/face" .. love.math.random(1,10)..".png"),
				name = "Message Test",
				text = "Random gibberish, that doesn't make sense.\nJust to pretend this is a real dialog\nI don't even know...",
				duration = 4,
			}
		})
		--[[
		msgs.queue(
		{
			
		})
		--]]
	end
	
	
	end
	--[[
	if key == "0" then
		love.window.setMode(1024,(game.scale.h/game.scale.w)*1024 )
	end
	
	if key == "9" then
		love.window.setMode(800,(game.scale.h/game.scale.w)*800 )
	end
	
	if key == "8" then
		love.window.setMode(1200,(game.scale.h/game.scale.w)*1200 )
	end
	
	--]]

	sound:keypressed(key)
end

function love.mousepressed(x,y,button) 

end


function love.wheelmoved(x, y)
	if y < 0 then 
		camera.scale = math.max(camera.scale +0.01,0.01)
	elseif y > 0 then
		camera.scale = camera.scale -0.01
	end
end

--[
function love.focus(f)
	if f then
		print("Window grabbed focused.")
	else
		print("Window lost focus.")
		if mode == "arcade" then
			misc:pause()
		end
	end
end


function love.resize(w,h)
	game.width = w
	game.height = h
end

