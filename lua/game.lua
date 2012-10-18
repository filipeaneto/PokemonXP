--[[
   game.lua
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

require("lua/utils")
require("lua/vec2")

Game = {}
setmetatable(Game, {
    __call = function(table)
        obj = {
            spritePath  = "data/sprite/",
            imagePath   = "data/image/",
            
            grid        = Vec2(16, 16),
            
            timerMinDt  = 1/30,
            timerNext   = nil,
            timerSleep  = 0,
            
            debugCPU    = 0,
            debugMem    = 0,
            debugFPS    = 0,
        }
        
        setmetatable(obj, { __index = Game } )
        return obj
    end
})

function Game:start()
    self.timerNext = love.timer.getMicroTime()
end

function Game:update(dt)
    self.timerNext = self.timerNext + self.timerMinDt
end

function Game:wait()
    local curTime = love.timer.getMicroTime()
    if self.timerNext <= curTime then
        self.timerNext = curTime
        return
    end
    self.timerSleep = self.timerNext - curTime
    love.timer.sleep(self.timerSleep) 
end

function Game:getSpritePath() return self.spritePath end
function Game:getImagePath() return self.imagePath end

function Game:getGrid() return self.grid end

function Game:setFPS(fps) self.timerMinDt = 1/fps end

function Game:updateDebug(dt)
    self.debugFPS = love.timer.getFPS()
    self.debugMem = collectgarbage("count")
    self.debugCPU = (self.timerMinDt - self.timerSleep) / (self.timerMinDt)
end

function Game:drawDebug()
    love.graphics.print("FPS: "..self.debugFPS, 10, 10)
    
    mem = self.debugMem
    if mem > 1024 then
        love.graphics.print("Memory: "..math.round(mem/1024, 1).." MB", 10, 25)
    else
        love.graphics.print("Memory: "..math.floor(mem).." KB", 10, 25)
    end
    
    love.graphics.print("CPU: "..math.floor(self.debugCPU * 100).."%", 10, 40)
end
