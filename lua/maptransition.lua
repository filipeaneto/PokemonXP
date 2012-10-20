--[[
   maptransition.lua
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

maptransition = {}

function maptransition.load()
    if maptransition.mode == "to north" then
        maptransition.intY = maptransition.args.intY or 0
        
        maptransition.time = maptransition.args.time or 1
        maptransition.dt = 0
        
        maptransition.newX = 0
        maptransition.newY = (maptransition.intY * xpGame:getGrid().y) - 480
        maptransition.oldX, maptransition.oldY = 0, 0
        
        -- precisa mudar
        maptransition.playerX = object.posX - 1
        maptransition.playerY = object.posY - 1
        maptransition.destY = 30 - maptransition.intY - 1
        
        maptransition.args = nil
    end

    return maptransition
end

function maptransition.update(dt)
    maptransition.dt = maptransition.dt + dt

    if maptransition.mode == "to north" then
        if maptransition.dt < maptransition.time then
            maptransition.oldY = (480-(maptransition.intY*xpGame:getGrid().y)) * 
                                 (maptransition.dt / maptransition.time)
            maptransition.newY = (maptransition.intY * xpGame:getGrid().y) - 
                                  480 + maptransition.oldY

            object.sprite:setPosition(maptransition.playerX * xpGame:getGrid().x + 8,
                maptransition.playerY * xpGame:getGrid().y + 8 +
                (maptransition.destY * xpGame:getGrid().y - 
                maptransition.playerY * xpGame:getGrid().y) *
                (maptransition.dt / maptransition.time)) 
                          
--            local y  = maptransition.playerY
--            local dY = maptransition.destY
--            
--            print(y, dY)
--            
--            y = y + math.floor((dY - y)*(maptransition.dt / maptransition.time))
--            
--            object:setPosition(Vec2(maptransition.playerX, y))
        else
            object:setPosition(Vec2(maptransition.playerX + 1, maptransition.destY + 1))
            xpContext = maptransition.quit()
        end
    end
end


function maptransition.draw()
    maptransition.map:drawBack(maptransition.newX, maptransition.newY)
    xpMap:drawBack(maptransition.oldX, maptransition.oldY)
    -- precisa mudar
    object.sprite:draw()
end

function maptransition.quit()
    xpMap = maptransition.map
    
    return nil
end
