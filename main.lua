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
require("lua/map")

function love.load()
    -- Variaveis globais importantes
    xpGame = Game()
    xpImageBank = ImageBank(50)
    xpPlayer = {}
    xpMap = {}
    
    -- inicia o jogo
    xpGame:setFPS(24)
    xpGame:start()

    -- se necessário, desligue o Garbage Collector
    -- collectgarbage("stop")
    
    -- inicializa o mapa
--    local chunk = love.filesystem.load("data/map/pallet.map")
--    chunk() -- mudar para .events
    xpMap = Map("pallet.map")

    --local abra = Sprite("default32_movement5.spr", "pokemon/063_movement.png")
    local hero = Sprite("hero.spr")
    object = Object(hero, xpMap, 48, 4)
    object:setPosition(Vec2(20, 20))
    local player = PlayerMovement(object)
    
    player:setMovement("s", Vec2(0, 1), "m-s", "i-s")
    player:setMovement("w", Vec2(0,-1), "m-n", "i-n")
    player:setMovement("a", Vec2(-1,0), "m-w", "i-w")
    player:setMovement("d", Vec2(1, 0), "m-e", "i-e")
    
    xpPlayer = player

--    xpMap.back  = love.graphics.newImage("data/image/pallet.png")
--    xpMap.front1 = love.graphics.newImage("data/image/palletf1.png")
    
    debugDt = 0
end

function love.update(dt)
    xpGame:update(dt)

    debugDt = debugDt + dt
    if debugDt > 1 then
        xpGame:updateDebug(dt)
        debugDt = 0
    end
    
    if xpContext then
        xpContext.update(dt)
    else
        xpPlayer:update(dt) -- tá muito lento (?)
    end
end

function love.draw()
    --love.graphics.draw(xpMap.back, 0, 0)

    if xpContext then
        xpContext.draw()
    else
        -- precisa ser mudado
        xpMap:drawBack()
        object:draw()
    end
    
    -- love.graphics.draw(xpMap.front, 0, 0)

    xpGame:drawDebug()    
    
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
--    elseif key == "g" then
--        collectgarbage()
    end
    
    if xpContext == nil then
        xpPlayer:keyPressed(key)
    end
end

function love.keyreleased(key, unicode)
    xpPlayer:keyReleased(key)
end

function love.focus(focus)

end

function love.quit()

end

