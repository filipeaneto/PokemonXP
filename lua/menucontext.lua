--[[
   menucontext.lua
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

require "lua/context"
require "lua/type"

MenuContext = {}

Type(MenuContext, Context,
function(context)
    Context.Init(context, "menu")
end)

function MenuContext:update(dt)

end

function MenuContext:draw()

    love.graphics.print(xp.config.user, 550, 10)

    local selected = xp.menu:selected()

    for index, item in xp.menu:itens() do

        if index == selected then
            love.graphics.print(">", 10, 85 + index * 15)
        end
        love.graphics.print(item.name, 20, 85 + index * 15)

    end

end

function MenuContext:keyPressed(key, unicode)
    if key == "return" then
        xp.menu:click()
    elseif key == "up" then
        xp.menu:up()
    elseif key == "down" then
        xp.menu:down()
    end
end

