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
 
enemies = {}

enemies.wave = {}
enemies.waveCycle = 0 -- delay until first wave start
enemies.waveDelay = 3

enemies.sound = {}
enemies.sound.hit = love.audio.newSource("sfx/projectiles/hit.wav", "static")
enemies.sound.hit:setVolume(1)
enemies.sound.explode = love.audio.newSource("sfx/projectiles/explode.wav", "static")
enemies.sound.explode:setVolume(0.7)


enemies.shield = love.graphics.newImage("gfx/shield_large.png")

function enemies:add_delta()

	local gfx = love.graphics.newImage("gfx/starship/6_small.png")
	
	local ny = math.random(0, starfield.h - gfx:getHeight()*4)
	local nx = starfield.w
	
	local xvel = 400
	local projectileOffset = 0.25
	for i=1, starfield.h, starfield.h/4 do
		xvel = xvel -10

		table.insert(self.wave, {
			w = gfx:getWidth(),
			h = gfx:getHeight(),
			x = nx,
			y = ny,
			yvel = 30,
			xvel = xvel,
			gfx = gfx or nil,
			score = 120,
			shield = 80,
			shieldmax = 80,
			shieldopacity = 0,
			shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.8,
			projectileCycle = projectileOffset,
			projectileDelay = 2,
		})
		ny = ny + gfx:getHeight()
		nx = nx + gfx:getWidth()
		projectileOffset = projectileOffset + 0.25
	end
end

function enemies:add_dart()

	local gfx = love.graphics.newImage("gfx/starship/7_small.png")
	
	
	table.insert(self.wave, {
		type = "dart",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = player.y+starfield.offset/2+math.random(-200,200),
		yvel = 0,
		xvel = math.random(500,600),
		gfx = gfx or nil,
		score = 120,
		shield = 40,
		shieldmax = 40,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5
	})


end


function enemies:add_train()

	local gfx = love.graphics.newImage("gfx/starship/7_small.png")
	
	local x = starfield.w
	local y = math.random(0,starfield.h)
	for i=1, 5 do
	table.insert(self.wave, {
		type = "train",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = x,
		y = y,
		yvel = math.random(-20,20),
		xvel = 600,
		gfx = gfx or nil,
		score = 120,
		shield = 40,
		shieldmax = 40,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5
	})
	x=x+gfx:getWidth()+30
	end

end

function enemies:add_tri()

	local gfx = love.graphics.newImage("gfx/starship/7_small.png")
	local rand = math.random(-200,200)
	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = player.y+starfield.offset/2+rand,
		yvel = math.random(-50,50),
		xvel = 340,
		gfx = gfx or nil,
		score = 150,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5
	})

	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w+gfx:getWidth(),
		y = player.y+starfield.offset/2-gfx:getHeight()/2+rand,
		yvel = math.random(0,50),
		xvel = 330,
		gfx = gfx or nil,
		score = 150,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5
	})
	table.insert(self.wave, {
		type = "tri",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w+gfx:getWidth(),
		y = player.y+starfield.offset/2+gfx:getHeight()/2+rand,
		yvel = math.random(-50,0),
		xvel = 330,
		gfx = gfx or nil,
		score = 150,
		shield = 80,
		shieldmax = 80,
		angle = 0,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.5
	})
end


function enemies:add_large()

	local gfx = love.graphics.newImage("gfx/starship/6_large.png")
	
	
	table.insert(self.wave, {
		type = "large",
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		x = starfield.w,
		y = player.y+starfield.offset/2+math.random(-200,200),
		yvel = 0,
		xvel = 150,
		gfx = gfx or nil,
		score = 630,
		shield = 500,
		shieldmax = 500,
		shieldopacity = 0,
		shieldscale = enemies.shield:getWidth()/gfx:getWidth()/1.2
	})


end


function enemies:update(dt)
	if paused then return end


	enemies.waveCycle = math.max(0, enemies.waveCycle - dt)
		
	if enemies.waveCycle <= 0 then
	
		local rand = math.random(0,4)
		if rand == 0 then
			self:add_dart()
		end
		if rand == 1 then
			self:add_delta()
		end
		if rand == 2 then
			self:add_tri()
		end
		if rand == 3 then
			self:add_large()
		end
		if rand == 4 then
			self:add_train()
		end
		enemies.waveCycle = math.random(0.5,2)
	end
	
	
	

	
	for i=#self.wave,1,-1 do
		local e = self.wave[i]
	
	
		if e.angle then
			e.angle = math.atan2(player.y+player.h/2-e.h/2 - e.y, player.x+player.w/2-e.w/2 - e.x)
		end
				
		if e.projectileCycle then
			e.projectileCycle = math.max(0, e.projectileCycle - dt)
			
			if e.projectileCycle <= 0 then
				table.insert(projectiles.missiles, {
					player = false,
					type = "cannon",
					gfx = projectiles.cannon.gfx,
					w = projectiles.cannon.gfx:getWidth(),
					h = projectiles.cannon.gfx:getHeight(),
					x = e.x + e.gfx:getWidth()/2,
					y = e.y + e.gfx:getHeight()/2-projectiles.cannon.gfx:getHeight()/2,
					xvel = 800,
					yvel = 0,
					damage = projectiles.cannon.damage,
					r = 255,
					g = 220,
					b = 150,
				})
				
				e.projectileCycle = e.projectileDelay
			end
		end
		
		
		

		if e.shieldopacity > 0 then
			e.shieldopacity = e.shieldopacity - 200 *dt
		else
			e.shieldopacity = 0
		end
		
		e.x = (e.x - e.xvel *dt)
		e.y = (e.y - e.yvel *dt)
	
		
		
		if collision:check(e.x,e.y,e.w,e.h, player.x,player.y,player.w,player.h) then
			if player.alive then
				table.remove(enemies.wave, i)
				
				if not cheats.invincible then
					player.shield = player.shield - 20
				end
				
				sound:play(enemies.sound.explode)
			end
		end
		
		if e.x < 0  - e.w then
				table.remove(self.wave, i)
		end
		
		for z,p in ipairs (projectiles.missiles) do
			if p.player then
				if collision:check(p.x,p.y,p.w,p.h, e.x,e.y,e.w,e.h) then

						e.shield = e.shield - p.damage
						e.shieldopacity = 100
						
						table.remove(projectiles.missiles, z)
				
						sound:play(enemies.sound.hit)
				
				end
			end
		end
		
		if e.shield <= 0 then
			table.remove(self.wave, i)
			local rand = math.random(0,10)
			--local rand = 9
			if rand > 8 then
				pickups:add(e.x+e.w/2,e.y+e.h/2)
			end
			
			sound:play(enemies.sound.explode)

			
			hud.score = hud.score + e.score
		end
	end
	
end

function enemies:drawshield(e)
	if e.shieldopacity > 0 then
		love.graphics.setColor(100,200,255,e.shieldopacity)
		love.graphics.draw(
			enemies.shield,  math.floor(e.x)+e.w/2-(enemies.shield:getWidth()/2/e.shieldscale), 
			math.floor(e.y)+e.h/2-(enemies.shield:getHeight()/2/e.shieldscale), 0, 1/e.shieldscale, 1/e.shieldscale
		)
	end
end

function enemies:draw()
	
	for _, e in pairs (self.wave) do
		local x = math.floor(e.x)
		local y = math.floor(e.y)
	
		if e.angle then
			--rotating face to player
			love.graphics.push()

			love.graphics.translate(e.x+e.w/2,e.y+e.h/2)
			love.graphics.rotate(e.angle)
			love.graphics.translate(-e.x-e.w/2,-e.y-e.h/2)
			
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(
				e.gfx,  x+e.w, 
				y, 0, 1, 1,e.w
				
			)
			enemies:drawshield(e)
			love.graphics.pop()
		else
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(
				e.gfx,  x+e.w, 
				y, 0, -1, 1
				
			)
			enemies:drawshield(e)
		end
	end
	
	--draw this on top everything else
	for _, e in pairs (self.wave) do
		local x = math.floor(e.x)
		local y = math.floor(e.y)
		
		--health bar
		local barheight = 6
		love.graphics.setColor(40,40,40,50)
		love.graphics.rectangle("fill", x+e.w/1.5/4,y-20,e.w/1.5,barheight)
		
		
		love.graphics.setColor(55,155,155,50)
		love.graphics.rectangle("fill", x+e.w/1.5/4,y-20,(e.shield/e.shieldmax)*(e.w/1.5),barheight)
		
		love.graphics.setColor(155,255,255,50)
		love.graphics.rectangle("line", x+e.w/1.5/4,y-20,e.w/1.5,barheight)
		
		if debug then
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("x:"..x, x-10,y-10)
			love.graphics.print("y:".. y, x-10,y)
			
			love.graphics.print("score : "..e.score, x-10,y+10)
			love.graphics.print("shield: "..e.shield, x-10,y+20)
			love.graphics.setColor(255,155,255,155)
			love.graphics.rectangle("line", x,y, e.w, e.h)
		end
	end
end


