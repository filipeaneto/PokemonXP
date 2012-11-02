--[[
   main.lua
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

require "lua/imagebank"
require "lua/config"
require "lua/sprite"

function love.load()

    -- Tabela global
    xp = {}

    -- Configurações e status do jogo
    -- TODO Abrir o usuário default ou o último utilizado, dentro do menu, o 
    --      jogador será capaz de trocar o usuário corrente
    xp.config = Config()
    xp.status = {}

    -- TODO Atributos do menu
    xp.menuContext  = {} -- TODO
    xp.menu         = {} -- TODO

    -- TODO Atributos do jogo, precarregados para o continuar
    xp.battleContext    = {}                -- TODO
    xp.mapContext       = {}                -- TODO
    xp.imageBank        = ImageBank(xp.config.imageBankSize)
    xp.player           = {}                -- TODO
    xp.game             = {}                -- TODO
    xp.map              = {}                -- TODO

    -- Inicializa o contexto atual como o menu
    xp.actualContext = xp.mapContext

    sprite = Sprite("hero.spr", 100, 100)
    sprite:setAnimation("moving-south")

end

function love.update(dt)

    -- actualContext:update(dt)
    sprite:update(dt)

end

function love.draw()

    -- actualContext:draw()
    sprite:draw()

end

function love.mousepressed(x, y, button)

    -- actualContext:mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

    -- actualContext:mousereleased(x, y, button)

end

function love.keypressed(key, unicode)

    -- actualContext:keypressed(key, unicode)

end

function love.keyreleased(key, unicode)

    -- actualContext:keyreleased(key, unicode)

end

function love.focus(focus)

    -- actualContext:focus(focus)

end

function love.quit()

    -- actualContext:quit()

end

