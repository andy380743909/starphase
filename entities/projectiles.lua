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
 
projectiles = {}

projectiles.missiles = {}

projectiles.cannon = {}
projectiles.cannon.gfx = love.graphics.newImage("gfx/projectiles/cannon.png")
projectiles.cannon.damage = 10
projectiles.cannon.sound = {}
projectiles.cannon.sound.shoot = love.audio.newSource("sfx/projectiles/shoot.wav", "static")
projectiles.cannon.sound.shoot:setVolume(0.3)
projectiles.cannon.description = "Standard issue pulse cannons"

projectiles.blaster = {}
projectiles.blaster.gfx = love.graphics.newImage("gfx/projectiles/blaster.png")
projectiles.blaster.damage = 15
projectiles.blaster.sound = {}
projectiles.blaster.sound.shoot = love.audio.newSource("sfx/projectiles/shoot3.wav", "static")
projectiles.blaster.sound.shoot:setVolume(0.3)
projectiles.blaster.description = "A powerful energy discharge focused into a single projectile"

projectiles.plasma = {}
projectiles.plasma.gfx = love.graphics.newImage("gfx/projectiles/plasma.png")
projectiles.plasma.damage = 20
projectiles.plasma.sound = {}
projectiles.plasma.sound.shoot = love.audio.newSource("sfx/projectiles/shoot4.wav", "static")
projectiles.plasma.sound.shoot:setVolume(0.3)
projectiles.plasma.description = "Alternating plasma cannons"

projectiles.beam = {}
projectiles.beam.gfx = love.graphics.newImage("gfx/projectiles/beam.png")
projectiles.beam.damage = 0.2
projectiles.beam.sound = {}
projectiles.beam.sound.shoot = love.audio.newSource("sfx/projectiles/shoot2.wav", "static")
projectiles.beam.sound.shoot:setVolume(0.1)
projectiles.beam.description = "A frequency disruptor, has a more damaging effect on larger targets"

projectiles.wave = {}
projectiles.wave.gfx = love.graphics.newImage("gfx/projectiles/wave.png")
projectiles.wave.damage = 2
projectiles.wave.sound = {}
projectiles.wave.sound.shoot = love.audio.newSource("sfx/projectiles/shoot2.wav", "static")
projectiles.wave.sound.shoot:setVolume(0.1)
projectiles.wave.description = "Proton beam"

projectiles.radial = {}
projectiles.radial.gfx = love.graphics.newImage("gfx/projectiles/radial.png")
projectiles.radial.damage = 55
projectiles.radial.sound = {}
projectiles.radial.sound.shoot = love.audio.newSource("sfx/projectiles/shoot5.wav", "static")
projectiles.radial.sound.shoot:setVolume(0.5)
projectiles.radial.description = "A momentary plasam discharge, radiating out from all sides"

projectiles.rocket = {}
projectiles.rocket.gfx = love.graphics.newImage("gfx/projectiles/rocket.png")
projectiles.rocket.damage = 80
projectiles.rocket.sound = {}
projectiles.rocket.sound.shoot = love.audio.newSource("sfx/projectiles/shoot7.wav", "static")
projectiles.rocket.sound.shoot:setVolume(0.3)
projectiles.rocket.sound.launch = love.audio.newSource("sfx/projectiles/shoot6.wav", "static")
projectiles.rocket.sound.launch:setVolume(0.3)
projectiles.rocket.description = "Alternating torpedos which explode on contact"

projectiles.barrier = {}
projectiles.barrier.gfx = love.graphics.newImage("gfx/projectiles/barrier.png")
projectiles.barrier.damage = 120
projectiles.barrier.description = "Defensive proximity shields"


function projectiles:update(dt)
	if paused then return end
	--process projectiles movement
	
	for i=#self.missiles,1,-1 do
		local p = self.missiles[i]
		
		--player projectiles
		if p.player then

			
			if p.type == "cannon" then
				p.x = p.x + p.xvel *dt
			end
			
			if p.type == "blaster" then
				p.x = p.x + p.xvel *dt
			end
			
			if p.type == "plasma" then
				self:rotate(p, 15, dt)
				p.x = p.x + p.xvel *dt
			end
			
			if p.type == "beam" then
				p.x = p.x + p.xvel *dt
			end
			
			if p.type == "radial" then
				self:rotate(p, 5, dt)
				p.x = p.x + p.xvel *dt
				p.y = p.y + p.yvel *dt
				
				p.timer = math.max(0, p.timer - dt)
				if p.timer <= 0 then
					sound:play(projectiles.rocket.sound.launch)
					--[[ FIX THIS!"
					explosions:addobject(
						p.x-explosions.size/2+p.w/2,p.y-explosions.size/2+p.h/2,0,0
					)
					--]]
					table.remove(self.missiles, i)
				end
			end
			
			if p.type == "wave" then
				if p.yvel > 300 then p.switch = false end
				if p.yvel < -300 then p.switch = true end
			
				p.yvel = p.yvel + (p.switch and 50 or -50)
				
				p.x = p.x + p.xvel *dt
				p.y = p.y + p.yvel *dt
				
			end
			
			if p.type == "rocket" then
				if (p.yvel >= -p.trigger and p.switch) or (p.yvel <= p.trigger and not p.switch) then
					p.yvel = 0
					p.x = p.x + p.xvel *dt
					if not p.launched then
						sound:play(projectiles.rocket.sound.launch)
						p.launched = true
					end
				else
					p.yvel = p.yvel + (p.switch and 10 or -10)
					
					p.y = p.y + p.yvel *dt
					p.x = p.x + 80 *dt
				end
			end
			
			if p.type == "barrier" then
				self:rotate(p, 10, dt)
				p.x = 80 * math.cos(p.rotation) + player.x+player.w/2 -p.w/2
				p.y = 80 * math.sin(p.rotation) + player.y+player.h/2 -p.h/2
			end

		--enemy projectiles
		elseif not p.player then
			p.x = p.x - math.floor(p.xvel *dt)
			
			if not cheats.invincible then
			if player.alive and collision:check(p.x,p.y,p.w,p.h, player.x,player.y,player.w,player.h) then
					 
				table.remove(self.missiles, i)
				player.shield = player.shield - p.damage
				sound:play(enemies.sound.explode)
					
		
			end
			end
		end
		
		
		if p.x > starfield.w  or
			p.x + p.w < 0 or
			p.y + p.h < 0 or
			p.y > starfield.h 
		then
			table.remove(self.missiles, i)
		
		end
		
	end
end


function projectiles:draw()
	for _, p in ipairs (projectiles.missiles) do




		if p.player then

			if p.type == "cannon" then
				love.graphics.setColor(p.r,p.g,p.b,255)
				love.graphics.draw(
					p.gfx,  p.x, 
					p.y, 0, 1, 1				
				)
			end
			
			if p.type == "blaster" then
				love.graphics.setColor(p.r,p.g,p.b,255)
				love.graphics.draw(
					p.gfx,  p.x, 
					p.y, 0, 1, 1				
				)
			end
			
			if p.type == "wave" then
				love.graphics.setColor(p.r,p.g,p.b,150)
				love.graphics.draw(
					p.gfx,  p.x, 
					p.y, 0, 1, 1				
				)				
			end
			
			if p.type == "plasma" or p.type == "radial" then
				love.graphics.push()
				love.graphics.setColor(p.r,p.g,p.b,255)
				love.graphics.translate(p.x+p.w/2,p.y+p.h/2)
				love.graphics.rotate(p.rotation or 0)
				love.graphics.translate(-p.x-p.w/2,-p.y-p.h/2)
				love.graphics.draw(
					p.gfx, p.x, 
					p.y,  0, 1, 1
				)
				love.graphics.pop()
			end
			
			if p.type == "rocket" then
				love.graphics.setColor(p.r,p.g,p.b,255)
				love.graphics.draw(
					p.gfx,  p.x, 
					p.y, 0, 1, 1				
				)
				
			end
			
			if p.type == "barrier" then
				love.graphics.push()
				love.graphics.setColor(p.r,p.g,p.b,140)
				love.graphics.translate(p.x+p.w/2,p.y+p.h/2)
				love.graphics.rotate(p.rotation or 0)
				love.graphics.translate(-p.x-p.w/2,-p.y-p.h/2)
				love.graphics.draw(
					p.gfx,  p.x, 
					p.y,  0, 1, 1
				)
				love.graphics.pop()
			end
			
			if p.type == "beam" then
				love.graphics.setColor(p.r,p.g,p.b,125)
				love.graphics.draw(
					p.gfx, p.x, 
					p.y, 0, 1, 1				
				)
	


			end
		elseif not p.player then
			if p.type == "cannon" then
				love.graphics.setColor(p.r,p.g,p.b,255)
				love.graphics.draw(
					p.gfx,  p.x, 
					p.y, 0, -1, 1,p.w
				)
			end
		end
		
		if debug then
		--[[	love.graphics.setColor(p.r,p.g,p.b,140)			
			love.graphics.rectangle(
				"line",
				p.x,
				p.y,
				p.w,
				p.h
			)--]]
		end
		
	end
end


function projectiles:rotate(projectile, amount, dt)
		if not projectile.rotation then projectile.rotation = 0 end
		projectile.rotation = projectile.rotation + dt * amount
		projectile.rotation = projectile.rotation % (2*math.pi)
end

