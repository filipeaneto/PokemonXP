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

    -- duração da transição
    transition.time = arg1 or 1
    -- comprimento da intersecção dos mapas
    transition.int  = arg2 or 1

    -- sprite do personagem e posições
    transition.sprite  = xp.player:getSprite()
    transition.srcX, transition.srcY = transition.sprite:getPosition()

    -- posição do player
    transition.playerX, transition.playerY = xp.player:getPosition()

    if option == "2north" then
        -- funções de atualização e desenho
        transition._update = MapTransitionContext.verticalUpdate
        transition._draw   = MapTransitionContext.verticalDraw

        -- inicializa posições dos mapas (evita operações com nil)
        transition.oldY = 0
        transition.newY = 0

        -- posições finais do player
        transition.playerY = transition.playerY + MAP_Y - transition.int - 1

        -- passar a intersecção para as coordenadas de tela
        -- calcular o ponto A (ponto de origem do novo mapa, apenas y do ponto)
        transition.A = transition.int * GRID_Y - MAP_HEIGHT
    elseif option == "2south" then
        -- funções de atualização e desenho
        transition._update = MapTransitionContext.verticalUpdate
        transition._draw   = MapTransitionContext.verticalDraw

        -- inicializa posições dos mapas (evita operações com nil)
        transition.oldY = 0
        transition.newY = 0

        -- posições finais do player
        transition.playerY = transition.playerY - MAP_Y + transition.int + 1

        -- passar a intersecção para as coordenadas de tela
        -- calcular o ponto A (ponto de origem do novo mapa, apenas y do ponto)
        transition.A = MAP_HEIGHT - transition.int * GRID_Y
    end

end)

function MapTransitionContext:update(dt)

    self.dt = self.dt + dt
    self:_update()

end

function MapTransitionContext:draw()
    self:_draw()
end

function MapTransitionContext:verticalUpdate()

    if self.dt < self.time then

        -- modificador da altura
        local dy = self.A * self.dt / self.time

        self.oldY = self.A - dy
        self.newY = -dy

        self.sprite:setPosition(self.srcX, self.srcY - dy)
    else
        xp.map = self.map
        xp.actualContext = xp.mapContext
        xp.player:setPosition(self.playerX, self.playerY)
    end

end

function MapTransitionContext:verticalDraw()

    self.map:draw(0, self.newY)
    xp.map:draw(0, self.oldY)

    self.sprite:draw()

end

function MapTransitionContext:keyPressed(key, unicode)
    xp.player:keyPressed(key)
end

function MapTransitionContext:keyReleased(key, unicode)
    xp.player:keyReleased(key)
end

