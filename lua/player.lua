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

require "lua/object"
require "lua/type"

Player = {}

Type(Player, Object,
function(player, ...)

    -- inicializa os atributos de objeto
    Object.Init(player, ...)

    player.lastKey      = nil
    player.actualKey    = nil
    player.nextKey      = nil

    -- TODO futuramente vetor correndo e de bicicleta
    player.movement     = {} -- vetores de movimento
    player.mAnimation   = {} -- animação movendo
    player.iAnimation   = {} -- animação parado

end)

function Player:setMovement(key, x, y, mAnimation, iAnimation)
    self.movement[key]      = {x, y}
    self.mAnimation[key]    = mAnimation
    self.iAnimation[key]    = iAnimation
end

function Player:unsetMovement(key)
    if not self.movement[key] then return end

    self.movement[key]      = nil
    self.mAnimation[key]    = nil
    self.iAnimation[key]    = nil
end

function Player:keyPressed(key)
    if not self.movement[key] then return end

    self.lastKey = key

    if self.actualKey == nil then
        self.actualKey = key
    else
        self.nextKey = key
    end
end

function Player:keyReleased(key)
    if not self.movement[key] then return end

    if self.actualKey == key then
        self.actualKey, self.nextKey = self.nextKey, nil
    elseif self.nextKey == key then
        self.nextKey = nil
    end
end

function Player:releaseAll()
    self.actualKey    = nil
    self.nextKey      = nil
end

function Player:update(dt)

    local actualKey = self.actualKey

    -- primeiro atualiza como se fosse um object
    Object.update(self, dt)

    -- se tem alguma tecla pressionada
    if actualKey then

        -- e o objeto não está se movendo, adiciona o movimento
        if not self.objIsMoving then
            local x, y = unpack(self.movement[actualKey])
            local animation = self.mAnimation[actualKey]

            self:move(x, y, animation)
        end

    -- se não tem nenhuma tecla pressionada, mantenha a animação idle da última
    -- tecla pressionada
    elseif self.lastKey then

        self:move(nil, nil, self.iAnimation[self.lastKey])
        self.lastKey = nil

    end

end

