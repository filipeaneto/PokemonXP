--[[
   playermovement.lua
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

PlayerMovement = {}

setmetatable(PlayerMovement, {
    __call = function(table, object)
        obj = {
            object          = object,	
            lastKey         = nil,
            actualKey       = nil,
            nextKey         = nil,
            movement        = {}, -- vetores de movimento
            mAnimation      = {}, -- animação movendo
            iAnimation      = {}  -- animação parado
        }
        
        setmetatable(obj, { __index = PlayerMovement })
        return obj
    end
})

function PlayerMovement:setMovement(key, dv, mAnimation, iAnimation)
    self.movement[key] = dv:clone()
    self.mAnimation[key] = mAnimation
    self.iAnimation[key] = iAnimation

    return true
end

function PlayerMovement:unsetMovement(key)
    if self.movement[key] == nil then return false end

    self.movement[key] = nil
    self.mAnimation[key] = nil
    self.iAnimation[key] = nil
    
    return true
end

function PlayerMovement:keyPressed(key)
    if self.movement[key] == nil then return false end

    self.lastKey = key
    if self.actualKey == nil then
        self.actualKey = key
    else
        self.nextKey = key
    end
    
    return true
end

function PlayerMovement:keyReleased(key)
    if self.movement[key] == nil then return false end
    
    if self.actualKey == key then
        self.actualKey, self.nextKey = self.nextKey, nil
    elseif self.nextKey == key then
        self.nextKey = nil
    end
end

function PlayerMovement:update(dt)
    local actual = self.actualKey
    local object = self.object
        
    object:update(dt)

    if actual then
        if not object.isMoving then
            local dv = self.movement[actual]
            local animation = self.mAnimation[actual]
        
            object:move(dv, animation)
        end
    elseif self.lastKey then
        object:move(nil, self.iAnimation[self.lastKey])
        self.lastKey = nil
    end    
end

