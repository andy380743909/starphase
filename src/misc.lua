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
 
misc = {}



function math.round(num, idp)
	-- round integer to decimal places
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function ripairs(t)
	--same as ipairs, but itterate from last to first
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end




function misc:count(t)
	local c = 0
	for _ in pairs(t) do c = c + 1 end
	return c
end
 

function misc:togglefullscreen()
	local fs, fstype = love.window.getFullscreen()

	if fs then
		local success = love.window.setFullscreen( false )
	else
		local success = love.window.setFullscreen( true, "desktop" )
	end
			
	if not success then
		print("Failed to toggle fullscreen!")
	end

end

function misc:togglepaused()
	if paused then
		self:unpause()
	else
		self:pause()
	end
end


function misc:pause()
	hud.display.paused = hud.display.progress
	love.mouse.setVisible(true)
	love.mouse.setGrabbed(false)
	paused = true
end


function misc:unpause()
	hud.display.progress = hud.display.paused 
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	paused = false
end


function misc:formatTime(n)
	return string.format("%02d",n / 60 / 60) .. ":" .. 
		string.format("%02d",n / 60 % 60) .. ":" .. 
		string.format("%02d",n % 60)
end


