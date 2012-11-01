--[[
   main.lua
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

require "lua/sprite"
require "lua/imagebank"

function love.load()

    xp = {
        imageBank = ImageBank(50)
    }

    sprite = Sprite("hero.spr", 100, 100)
    sprite:setAnimation("moving-south")

end

function love.update(dt)

    sprite:update(dt)

end

function love.draw()

    sprite:draw()

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)

    if key == "escape" then
        love.event.quit()
    end

end

function love.keyreleased(key, unicode)

end

function love.focus(focus)

end

function love.quit()

end

