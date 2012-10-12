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

    xpGame:setFPS(20)

    xpGame:start()

    collectgarbage("stop")

    abra = Sprite("default32_movement5.spr", "pokemon/063_movement.png")
    abra:setPosition(64, 64)

    object = Object(abra, 96, 8)
    player = PlayerMovement(object)
    player:setMovement("s", Vec2(0, 1), "s", nil)
    player:setMovement("w", Vec2(0,-1), "n", nil)
    player:setMovement("a", Vec2(-1,0), "w", nil)
    player:setMovement("d", Vec2(1, 0), "e", nil)

    hero = Sprite("hero.spr")

    limitKey = 0
    
    
    -- testando NaiveBayesClassifier
    classifier = NaiveBayesClassifier(3, {2, 2, 2})
    classifier:insertClass("yes")
    classifier:insertClass("no")
    
    classifier:insertData({"yes", "red", "sports", "domestic"}) -- 1
    classifier:insertData({"no",  "red", "sports", "domestic"})
    classifier:insertData({"yes", "red", "sports", "domestic"}) -- 3
    classifier:insertData({"no",  "yel", "sports", "domestic"})
    classifier:insertData({"yes", "yel", "sports", "imported"}) -- 5
    classifier:insertData({"no",  "yel", "SUV",    "imported"}) 
    classifier:insertData({"yes", "yel", "SUV",    "imported"}) -- 7
    classifier:insertData({"no",  "yel", "SUV",    "domestic"})
    classifier:insertData({"no",  "red", "SUV",    "imported"}) -- 9
    classifier:insertData({"yes", "red", "sports", "imported"})
    
    result = classifier:classify({"red", "sports", "domestic"}, 0)
    
    -- treinando um pokemon
    classifier = NaiveBayesClassifier(2, {17, 18})
    
    classifier:insertClass("Thunder Shock")
    classifier:insertClass("Tackle")
    
    classifier:insertData({"Thunder Shock", "Normal", "None"})
    classifier:insertData({"Thunder Shock", "Water", "None"})
    classifier:insertData({"Thunder Shock", "Water", "Plant"})
    classifier:insertData({"Thunder Shock", "Fire", "None"})
    classifier:insertData({"Thunder Shock", "Flying", "None"})
    classifier:insertData({"Thunder Shock", "Flying", "Water"})
    
    classifier:insertData({"Tackle", "Rock", "None"})
    classifier:insertData({"Tackle", "Ground", "None"})
    classifier:insertData({"Tackle", "Plant", "None"})
    classifier:insertData({"Tackle", "Fire", "None"})
    
    result = classifier:classify({"Water", "None"})
end

function love.update(dt)
    xpGame:update(dt)

--    limitKey = limitKey + dt

--    if limitKey > 0.8 then
--        if love.keyboard.isDown("a") then

--            object:move(-1, 0, "w")
----            object:getSprite():setAnimation("walking_left")

--        elseif love.keyboard.isDown("s") then

--            object:move(0, 1, "s")
----            object:getSprite():setAnimation("walking_down")

--        elseif love.keyboard.isDown("d") then

--            object:move(1, 0, "e")
----            object:getSprite():setAnimation("walking_right")

--        elseif love.keyboard.isDown("w") then

--            object:move(0, -1, "n")
----            object:getSprite():setAnimation("walking_up")

--        end
--        limitKey = limitKey - 0.8
--    end
    
    


    --object:update(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    local mem = collectgarbage ("count")
    
    if mem > 2048 then
        love.graphics.print("Memory: "..math.floor(mem/1024).." MB", 10, 20)
    else
        love.graphics.print("Memory: "..math.floor(mem).." KB", 10, 20)
    end

    love.graphics.print("Hello World: "..(result or "cagou"), 400, 300)
    object:draw()

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
--    elseif key == "w" then
--        abra:setAnimation("n")
--    elseif key == "s" then
--        abra:setAnimation("s")
--    elseif key == "a" then
--        abra:setAnimation("w")
--    elseif key == "d" then
--        abra:setAnimation("e")
--    elseif key == "z" then
--        abra:setAnimation("sw")
--    elseif key == "x" then
--        abra:setAnimation("se")
--    elseif key == "q" then
--        abra:setAnimation("nw")
--    elseif key == "e" then
--        abra:setAnimation("ne")
    end
    
    player:keyPressed(key)
end

function love.keyreleased(key, unicode)
    player:keyReleased(key)
end

function love.focus(focus)

end

function love.quit()

end

