--[[
   map.lua
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

Map = {}

setmetatable(Map, {
    __call = function(table, filename)
        local chunk = love.filesystem.load(xpGame:getMapPath() .. filename)
        local mapData = chunk()

        local obj = {
            event       = mapData.event,
            callback    = mapData.callback or {},
            getName     = mapData.getName or function() return "No name." end
        }

        obj.backImage = love.graphics.newImage(xpGame:getImagePath()..
                                               mapData.backImage)

        local i, img = 1, "frontImage1"
        
        while mapData[img] do
            obj[img] = love.graphics.newImage(xpGame:getImagePath()..
                                              mapData[img])
            
            i = i + 1
            img = "frontImage"..tostring(i)
        end

        setmetatable(obj, { __index = Map })
        return obj
    end
})

function Map:drawBack()
    love.graphics.draw(self.backImage, 0, 0)
end

function Map:drawFront(y, x)
    i = self.event[y][x]
    if type(i) == "number" and i >= 1 then
        love.graphics.draw(self["frontImage"..tostring(i)], 0, 0)
    end
end

