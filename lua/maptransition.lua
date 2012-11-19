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

require "lua/type"
require "lua/map"

MapTransitionContext = {}

Type(MapTransitionContext, Context,
function(transition, mapFilename, option, arg1, arg2)

    Context.Init(transition, "Map Transition")

    -- TODO mapBank
    transition.map = Map(mapFilename)
    transition.option = option
    transition.dt = 0

    if option == "to north" then
        -- duração da transição
        transition.time = arg1 or 1
        -- comprimento da intersecção dos mapas
        transition.int  = arg2 or 1

        -- funções de atualização e desenho
        transition._update = MapTransitionContext.toNorthUpdate
        transition._draw   = MapTransitionContext.toNorthDraw

        -- sprite do personagem e posições
        transition.sprite  = xp.player:getSprite()
        transition.destX, transition.srcY = transition.sprite:getPosition()
        transition.destY = transition.srcY + (MAP_Y - transition.int - 1) * GRID_Y

        -- posições dos mapas
        transition.oldY = 0
        transition.newY = 0

        -- posições finais do player
        transition.playerX, transition.playerY = xp.player:getPosition()
        transition.playerY = transition.playerY + MAP_Y - transition.int - 1

        -- passar a intersecção para as coordenadas de tela
        transition.int  = transition.int * GRID_Y
    end

end)

function MapTransitionContext:update(dt)

    self.dt = self.dt + dt
    self:_update()

end

function MapTransitionContext:draw()
    self:_draw()
end

function MapTransitionContext:toNorthUpdate()

    if self.dt < self.time then

        -- tempo relativo
        local relTime = self.dt / self.time

        self.oldY = (480 - self.int) * relTime
        self.newY = self.int - 480 + self.oldY

        self.sprite:setPosition(self.destX,
                                self.srcY + (self.destY - self.srcY) * relTime)
    else
        xp.map = self.map
        xp.actualContext = xp.mapContext
        xp.player:releaseAll()
        xp.player:setPosition(self.playerX, self.playerY)
    end

end

function MapTransitionContext:toNorthDraw()

    self.map:draw(self.newX, self.newY)
    xp.map:draw(self.oldX, self.oldY)

    self.sprite:draw()

end

