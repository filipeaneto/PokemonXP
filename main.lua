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

require("lua/imagebank")
require("lua/sprite")
require("lua/object")
require("lua/game")

function love.load()
    game = Game()
    imageBank= ImageBank(50)

    game:setFPS(24)

    game:start()

    object = Object(Sprite("hero.spr"), 90, 4)

    abra = Sprite("default32_movement5.spr", "pokemon/063_movement.png")
    abra:setPosition(64, 64)

    limitKey = 0
end

function love.update(dt)
    game:update(dt)

    limitKey = limitKey + dt

    if limitKey > 0.8 then
        if love.keyboard.isDown("a") then

            object:move(-1, 0, "walking_left")
--            object:getSprite():setAnimation("walking_left")

        elseif love.keyboard.isDown("s") then

            object:move(0, 1, "walking_down")
--            object:getSprite():setAnimation("walking_down")

        elseif love.keyboard.isDown("d") then

            object:move(1, 0, "walking_right")
--            object:getSprite():setAnimation("walking_right")

        elseif love.keyboard.isDown("w") then

            object:move(0, -1, "walking_up")
--            object:getSprite():setAnimation("walking_up")

        end
        limitKey = limitKey - 0.8
    end

    object:update(dt)
    abra:update(dt)
end

function love.draw()
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    local mem = collectgarbage ("count")
    
    if mem > 2048 then
        love.graphics.print("Memory: "..math.floor(mem/1024).." MB", 10, 20)
    else
        love.graphics.print("Memory: "..math.floor(mem).." KB", 10, 20)
    end

    love.graphics.print("Hello World", 400, 300)
    object:draw()
    abra:draw()

    -- Control FPS
    game:wait()
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)
    if key == "escape" then
        love.event.quit()
    elseif key == "w" then
        abra:setAnimation("n")
    elseif key == "s" then
        abra:setAnimation("s")
    elseif key == "a" then
        abra:setAnimation("w")
    elseif key == "d" then
        abra:setAnimation("e")
    elseif key == "z" then
        abra:setAnimation("sw")
    elseif key == "x" then
        abra:setAnimation("se")
    elseif key == "q" then
        abra:setAnimation("nw")
    elseif key == "e" then
        abra:setAnimation("ne")
    end
end

function love.keyreleased(key, unicode)

end

function love.focus(focus)

end

function love.quit()

end

