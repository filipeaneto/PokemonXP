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

require("lua/vec2")

Game = {}
setmetatable(Game, {
    __call = function(table)
        obj = {
            spritePath  = "data/sprite/",
            imagePath   = "data/image/",
            
            grid        = Vec2(32, 32),
            
            timerMinDt  = 1/30,
            timerNext   = nil,
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
    love.timer.sleep(self.timerNext - curTime) 
end

function Game:getSpritePath() return self.spritePath end
function Game:getImagePath() return self.imagePath end

function Game:getGrid() return self.grid end

function Game:setFPS(fps) self.timerMinDt = 1/fps end
