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

require "lua/type"

----------------
-- Constantes --
----------------
GRID_X      = 16
GRID_Y      = GRID_X

SPRITE_PATH = "data/sprite/"
IMAGE_PATH  = "data/image/"
MAP_PATH    = "data/map/"
----------------

Game = {}

Type(Game,
function(game, fps)

    game.timerMinDt = 1 / (xp.config.fps)
    game.timerNext  = love.timer.getMicroTime()
    game.timerSleep = 0

end)

function Game:update()
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

