--[[
   object.lua
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

require "lua/serializable"
require "lua/updatable"
require "lua/drawable"
require "lua/sprite"
require "lua/deque"
require "lua/game"
require "lua/vec2"
require "lua/type"

Object = {}

Type(Object, Drawable, Updatable, Serializable,
function(object, sprite, speed, deltaStep, x, y)

    -- preenche os atributos
    object.objSprite        = sprite            -- Sprite

    object.objSpeed         = speed or 64       -- number
    object.objDeltaStep     = deltaStep or 8    -- number

    object.objMovements     = Deque()           -- Double End Queue

    object.objIsMoving      = false             -- boolean
    object.objLastAnimation = nil               -- string

    object.objPosX          = x or 1            -- number
    object.objPosY          = y or 1            -- number

    -- força a nova posição do sprite
    sprite:setPosition(GRID_X/2 + GRID_X * (object.objPosX - 1),
                       GRID_Y/2 + GRID_Y * (object.objPosY - 1))

    -- no início a posição destino é a mesma da atual
    object.objDestPosition  = Vec2(sprite:getPosition()) -- Vec2

end)

function Object:draw()

    self.objSprite:draw()

    -- uma variável do tipo Object sempre estará se movimentando pelo mapa
    -- deste modo, em algumas situações fica embaixo de outros objetos
    xp.map:drawFront(self.objPosY, self.objPosX)

end

function Object:update(dt)

    ---------------------------------
    -- objeto está se movimentando --
    ---------------------------------
    if self.objIsMoving then

        local position = Vec2(self.objSprite:getPosition())
        local dp = (position - self.objDestPosition)
        local norm = dp:norm()

        -- se movimenta em realação a velocidade e tempo
        dp = dt * self.objSpeed * dp:normalized()

        -- para de andar se estiver próximo o suficiente do destino
        if norm < self.objDeltaStep then
            self.objIsMoving = false
        end
        self.objSprite:setPosition((position - dp):unpack())

    -------------------------------------------------
    -- objeto está parado e tem movimento na lista --
    -------------------------------------------------
    elseif not self.objMovements:isEmpty() then

        local dx, dy, animation = unpack(self.objMovements:popLeft())

        if animation and self.objLastAnimation ~= animation then
            self.objLastAnimation = animation
            self.objSprite:setAnimation(animation)
        end

        -- não se movimenta
        if not dx or not dy then return end

        -- atualiza destino
        local x, y = self.objPosX + dx, self.objPosY + dy

        local event = xp.map.event[y][x]

        if -- se event é nil, o mapa é passável
           not event or
           -- se é um número diferente de 0 também
           (type(event) == "number" and event ~= 0) or
           -- por fim, pode ser uma callback, se esta retorna true, o movimento
           -- pode ser realizado
           (type(event) == "string" and xp.map.callback[event](self, x, y))
        then
            self.objPosX, self.objPosY = x, y

            self.objDestPosition.x = self.objDestPosition.x + dx * GRID_X
            self.objDestPosition.y = self.objDestPosition.y + dy * GRID_Y

            self.objIsMoving = true
        end

    end

    -- sempre atualizar o sprite
    self.objSprite:update(dt)

end

function Object:move(dx, dy, animation)

    self.objMovements:pushRight { dx, dy, animation }

end

function Object:setPosition(x, y)

    self.objPosX = x
    self.objPosY = y

    -- atualiza a posição do sprite
    self.objSprite:setPosition(GRID_X/2 + GRID_X * (x - 1),
                               GRID_Y/2 + GRID_Y * (y - 1))

    self.objDestPosition = Vec2(self.objSprite:getPosition()) -- Vec2

end

function Object:getPosition()
    return self.objPosX, self.objPosY
end

function Object:getSprite()
    return self.objSprite
end

function Object:serialize(compressed)

    return Serializable.serialize({
        self.objSprite:serialize(compressed),
        self.objSpeed,
        self.objDeltaStep,
        self.objPosX,
        self.objPosY
    }, compressed)

end

function Object:Deserialize(serial, compressed)

    if compressed then serial = decompress(serial) end
    serial = deserialize(serial)

    -- deserializa o sprite
    serial[1] = Sprite:Deserialize(serial[1], compressed)

    return Object(unpack(serial))

end

