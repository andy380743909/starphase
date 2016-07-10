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
 
pickups = {}
--pickups.texture = love.graphics.newImage("gfx/pickups/template_small.png")
pickups.sound = love.audio.newSource("sfx/pickups/collect.ogg", "static")


pickups.type = {
	[1] = love.graphics.newImage("gfx/pickups/shield.png"),
	[2] = love.graphics.newImage("gfx/pickups/energy.png"),
	[3] = love.graphics.newImage("gfx/pickups/unimplemented.png"),
	[4] = love.graphics.newImage("gfx/pickups/blaster.png"),
	[5] = love.graphics.newImage("gfx/pickups/wave.png"),
	[6] = love.graphics.newImage("gfx/pickups/plasma.png"),
	[7] = love.graphics.newImage("gfx/pickups/beam.png"),
	[8] = love.graphics.newImage("gfx/pickups/rocket.png"),
	
}

pickups.items = {} --active pickups on the starfield


function pickups:draw()
	
	for _, p in ipairs(pickups.items) do
		
		love.graphics.push()
		--love.graphics.setColor(p.r,p.g,p.b)
		love.graphics.setColor(255,255,255,255)
		love.graphics.translate(p.x+p.w/2,p.y+p.h/2)
		love.graphics.rotate(p.rotation or 0)
		love.graphics.translate(-p.x-p.w/2,-p.y-p.h/2)
		
		 love.graphics.draw(pickups.type[p.type], p.x,p.y)
		
		love.graphics.pop()
		
		if debug then
			love.graphics.rectangle("line", p.x,p.y,p.w,p.h)
			love.graphics.print(p.xvel .. " " ..p.yvel,p.x-20,p.y-20)
		end
		
	end
end

function pickups:add(x,y)

	table.insert(pickups.items, {
		type = math.random(1,#pickups.type),
		x = x,
		y = y,
		w = 30,
		h = 30,
		xvel =  math.random(-70,70),
		yvel =  math.random(-70,70),
		r = math.random(100,255),
		g = math.random(100,255),
		b = math.random(100,255),
	})
end

function pickups:update(dt)
	if paused then return end
	
	for i, p in ipairs(pickups.items) do
		p.x = p.x + (p.xvel *dt)
		p.y = p.y + (p.yvel *dt)
		
		projectiles:rotate(p, 1, dt)
		
		if p.x+p.w > love.graphics.getWidth() then
			p.xvel = -p.xvel
		end
		if p.x < 0 then
			p.xvel = -p.xvel
		end
		if p.y > starfield.h then
			p.yvel = -p.yvel
		end
		if p.y < 0 then
			p.yvel = -p.yvel
		end


		if player.alive and collision:check(p.x,p.y,p.w,p.h,player.x,player.y,player.w,player.h) then
			sound:play(pickups.sound)
			
			if  p.type == 1 then 
					player.shield = player.shield + 20
					player.score = player.score + 150
				elseif p.type == 2 then 
					player.energy = player.energy + 20
					player.score = player.score + 150
					
				elseif p.type == 3 then 
					--unimplemented
					
				elseif p.type == 4 then 
					player.hasblaster = true
					player.score = player.score + 500
					
				elseif p.type == 5 then 
					player.haswave = true
					player.score = player.score + 500
					
				elseif p.type == 6 then 
					player.hasplasma = true
					player.score = player.score + 500
					
				elseif p.type == 7 then 
					player.hasbeam = true
					player.score = player.score + 500
					
				elseif p.type == 8 then 
					player.hasrocket = true
					player.score = player.score + 500
			end
		
			if player.shield > player.shieldmax then player.shield = player.shieldmax	end
			if player.energy > player.energymax then player.energy = player.energymax	end
			if player.speed > player.speedmax then player.speed = player.speedmax	end

				
			table.remove(pickups.items, i)
		end

	end
end
