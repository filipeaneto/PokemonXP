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

require("lua/game")
require("lua/vec2")
require("lua/list")
require("math")

Object = {}

setmetatable(Object, {
    __call = function(table, sprite, map, speed, deltaStep)
        obj = {
            sprite          = sprite,
            dPosition       = Vec2(8, 8),
            
            speed           = speed or 64,
            deltaStep       = deltaStep or 8,
            
            movements       = List(),
            
            isMoving        = false,
            lastAnimation   = nil,
            
            map             = map,
            
            posX            = 1,
            posY            = 1
        }
        
        sprite:setPosition(8, 8, true)
        
        setmetatable(obj, { __index = Object })
        return obj
    end
})

function Object:draw()
    self.sprite:draw()
end

function Object:update(dt)
    if self.isMoving then    
        local position = self.sprite:getPosition()
        local dp = (position - self.dPosition)
        local norm = dp:norm()
 
        dp = dt * self.speed * (dp:normalized()) 
        
        if norm < self.deltaStep then
            self.isMoving = false
        end
        self.sprite:setPosition(position - dp)
        
    elseif not self.movements:isEmpty() then
        local mov = self.movements:popLeft()
        local dv, animation = mov.vector, mov.animation

        if animation ~= nil and self.lastAnimation ~= animation then
            self.lastAnimation = animation
            self.sprite:setAnimation(animation) 
        end
        
        local x, y = self.posX, self.posY
        dv.x, dv.y = math.floor(dv.x), math.floor(dv.y)
        
--        print("x: "..x.." y: "..y)
--        print("direção: "..(2.5 - 1.5*dv.x - 0.5*dv.y))
--        print(self.map.collisionMask[x][y][2.5 - 1.5*dv.x - 0.5*dv.y])
--        print("**********")
--        
--        if self.map.collisionMask[y][x][2.5 - 1.5*dv.x - 0.5*dv.y] then
            self.posX, self.posY = self.posX + dv.x, self.posY + dv.y
        
            self.dPosition.x = self.dPosition.x + dv.x * xpGame:getGrid().x
            self.dPosition.y = self.dPosition.y + dv.y * xpGame:getGrid().y
            
            self.isMoving = true               
--        end

    end
    
    self.sprite:update(dt)
end

function Object:move(dv, animation)
    self.movements:pushRight({ vector = dv:clone(), animation = animation})
end


function Object:getSprite()
    return self.sprite
end


--[[
    (-1, 0) = (-1) + 2*( 0) - 2.5*(-1 + (-1) + ( 0)) = 4
    ( 0,-1) = ( 0) + 2*(-1) - 2.5*(-1 + ( 0) + (-1)) = 3
    ( 0, 1) = ( 0) + 2*( 1) - 2.5*(-1 + ( 0) + ( 1)) = 2
    ( 1, 0) = ( 1) + 2*( 0) - 2.5*(-1 + ( 1) + ( 0)) = 1
    
    (x, y) = x + 2y - 2.5(-1 + x + y) = x + 2y + 2.5 -2.5x - 2.5y =
           = -1.5*x - 0.5*y + 2.5 ou 2.5 - 1.5y - 0.5x
           
    1 - direita         1 - baixo
    2 - baixo       ou  2 - direita
    3 - cima            3 - esqueda
    4 - esquerda        4 - cima
    
    técnica Z
]]

