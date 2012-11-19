--[[
   debug.lua
   This file is part of PokémonXP

   Copyright (C) 2012 - Filipe Neto

   PokémonXP is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   PokémonXP is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with PokémonXP. If not, see <http://www.gnu.org/licenses/>.
]]

require "lua/updatable"
require "lua/drawable"
require "lua/utils"
require "lua/type"

-- TODO pensar em um modo de mostrar o uso da CPU
Debug = {}

Type(Debug, Updatable, Drawable,
function(debug, fps)

    Updatable.Init(debug, fps or 1, Debug.updateDebug_)

    debug.FPS = love.timer.getFPS()
    debug.Mem = collectgarbage("count")

end)

function Debug:updateDebug_()

    self.FPS = love.timer.getFPS()
    self.Mem = collectgarbage("count")

end

function Debug:draw()

    love.graphics.print("FPS: "..self.FPS, 10, 10)

    mem = self.Mem
    if mem > 1024 then
        love.graphics.print("Memory: "..math.round(mem/1024, 1).." MB", 10, 25)
    else
        love.graphics.print("Memory: "..math.floor(mem).." KB", 10, 25)
    end

    love.graphics.print("Context: "..xp.actualContext:getName(), 10, 40)

end

