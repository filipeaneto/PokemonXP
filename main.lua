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

require("lua/playermovement")
require("lua/naivebayes")
require("lua/imagebank")
require("lua/sprite")
require("lua/object")
require("lua/game")

function love.load()
    xpGame = Game()
    xpImageBank= ImageBank(50)

    xpGame:setFPS(24)

    xpGame:start()

    collectgarbage("stop")
    
    local chunk = love.filesystem.load("data/map/kanto_001.map")
    local map = chunk()

    abra = Sprite("default32_movement5.spr", "pokemon/063_movement.png")
    abra:setPosition(224, 288)

    object = Object(abra, map, 48, 4)
    player = PlayerMovement(object)
    
    player:setMovement("s", Vec2(0, 1), "s", nil)
    player:setMovement("w", Vec2(0,-1), "n", nil)
    player:setMovement("a", Vec2(-1,0), "w", nil)
    player:setMovement("d", Vec2(1, 0), "e", nil)
    
    pallet = love.graphics.newImage("data/image/kanto_001.png")
    pallet2 = love.graphics.newImage("data/image/kanto_001f.png")
end

function love.update(dt)
    xpGame:update(dt)
    player:update(dt) -- tá muito lento
    --object:update(dt)
end

function love.draw()
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    local mem = collectgarbage ("count")
    
    if mem > 1000 then
        love.graphics.print("Memory: "..math.floor(mem/1024).." MB", 10, 20)
    else
        love.graphics.print("Memory: "..math.floor(mem).." KB", 10, 20)
    end
    
    love.graphics.draw(pallet, 0, 0)
    -- absurdamente lento :(
--    for i = 0, 20 do
--        for j = 0, 15 do
--            love.graphics.rectangle("line", i*32 - 16, j*32 - 16, 32, 32)
--        end
--    end
    object:draw()
    love.graphics.draw(pallet2, 0, 0)

    -- Control FPS
    xpGame:wait()
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)
    if key == "escape" then
        love.event.quit()
    elseif key == "g" then
        collectgarbage()
    else
        player:keyPressed(key)
    end
end

function love.keyreleased(key, unicode)
    player:keyReleased(key)
end

function love.focus(focus)

end

function love.quit()

end

