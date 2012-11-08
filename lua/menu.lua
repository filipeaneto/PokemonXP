--[[
   menu.lua
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

require "lua/firstrun"
require "lua/type"

Menu = {}

Type(Menu,
function(menu)

    menu.pages = {
        initial = {
            -- TODO fazer o menu
            { name = "New Game", action = function()
                -- TODO tirar daqui ###########
                xp.map = Map("pallet.map")
                xp.player = Player(Sprite("hero.spr"), 48, 4, 10, 10)
                xp.player:setMovement("down", 0, '')
                xp.player:setMovement("down" ,  0, 1,
                                      "moving-south", "idle-south")
                xp.player:setMovement("up"   ,  0,-1,
                                      "moving-north", "idle-north")
                xp.player:setMovement("left" , -1, 0,
                                      "moving-west" , "idle-west")
                xp.player:setMovement("right",  1, 0,
                                      "moving-east" , "idle-east")
                --#############################
                xp.actualContext = xp.mapContext
            end },
            { name = "Continue", action = function() love.event.quit() end },
            { name = "Options" , action = "options" },
            { name = "Quit"    , action = function() love.event.quit() end }
        },

        options = {
            { name = "Back", action = "initial" }
        }
    }

    menu.actualPage = "initial"
    menu.actualItemIndex = 1

end)

-- simula o comportamento de next
function Menu:itens()
    return next, self.pages[self.actualPage]
end

function Menu:selected()
    return self.actualItemIndex
end

function Menu:click()
    local action = self.pages[self.actualPage][self.actualItemIndex].action

    if type(action) == "function" then
        action(self)
    else
        self.actualPage = action
        self.actualItemIndex = 1
    end
end

function Menu:up()
    if self.actualItemIndex == 1 then
        self.actualItemIndex = #self.pages[self.actualPage]
    else
        self.actualItemIndex = self.actualItemIndex - 1
    end
end

function Menu:down()
    local last = #self.pages[self.actualPage]

    if self.actualItemIndex == last then
        self.actualItemIndex = 1
    else
        self.actualItemIndex = self.actualItemIndex + 1
    end
end

