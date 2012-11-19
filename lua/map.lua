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

require "lua/updatable"
require "lua/drawable"
require "lua/type"
require "lua/game"

Map = {}

Type(Map, Drawable, Updatable,
function(map, filename)

    local chunk = love.filesystem.load(MAP_PATH..filename)
    local mapData = chunk()

    map.event       = mapData.event
    map.callback    = mapData.callback or {}
    map.getName     = mapData.getName or function() return "Untitled" end

    map.backImage   = xp.imageBank:open(mapData.backImage)

    -- carrega todas as front images
    local i, img = 1, "frontImage1"

    while mapData[img] do
        map[img] = xp.imageBank:open(mapData[img])

        i = i + 1
        img = "frontImage"..tostring(i)
    end

end)

function Map:update(dt)

end

function Map:draw(x, y)
    love.graphics.draw(self.backImage, x, y)
end

function Map:drawFront(y, x)
    i = self.event[y][x]
    if type(i) == "number" and i >= 1 then
        love.graphics.draw(self["frontImage"..tostring(i)], 0, 0)
    end
end

--[[
function Map.Transition(filename, mode, args)
    maptransition.map = Map(filename)
    maptransition.mode = mode
    maptransition.args = args

    xpContext = maptransition.load()
end
]]

