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
require "lua/object"
require "lua/config"
require "lua/sprite"
require "lua/player"
require "lua/menu"
require "lua/map"

-- não esquecer de tirar o debug na versão final
require "lua/debug"

function love.load()

    -- Tabela global
    xp = {}

    -- Configurações e status do jogo
    -- TODO Abrir o usuário default ou o último utilizado, dentro do menu, o 
    --      jogador será capaz de trocar o usuário corrente
    xp.config = Config()
    xp.status = {}

    -- TODO Atributos do menu
    xp.menuContext  = {} -- Será preenchido quando inicilizar o menu
    xp.menu         = Menu() -- TODO

    -- TODO Atributos do jogo, precarregados para o continuar
    xp.battleContext    = {}                -- TODO
    xp.mapContext       = {}                -- TODO
    xp.imageBank        = ImageBank()
    xp.player           = {}                -- TODO
    xp.map              = {}                -- TODO deve ser preenchido por outro
                                            --      contexto
    xp.game             = Game()


    -- Inicializa o contexto atual como o menu
    xp.actualContext = xp.menuContext

    -- não esquecer de tirar o Debug na versão final
    debug = Debug()
    --    xp.map = Map("pallet.map")
    --    player = Player(Sprite("hero.spr"), 48, 4, 10, 10)

    --    player:setMovement("down" ,  0, 1, "moving-south", "idle-south")
    --    player:setMovement("up"   ,  0,-1, "moving-north", "idle-north")
    --    player:setMovement("left" , -1, 0, "moving-west" , "idle-west")
    --    player:setMovement("right",  1, 0, "moving-east" , "idle-east")

end

function love.update(dt)

    xp.game:update()
    debug:update(dt)

    xp.actualContext:update(dt)
    -- player:update(dt)

end

function love.draw()

    xp.actualContext:draw()
    -- xp.map:draw()
    -- player:draw()

    debug:draw()
    xp.game:wait()

end

function love.mousepressed(x, y, button)

    xp.actualContext:mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

    xp.actualContext:mousereleased(x, y, button)

end

function love.keypressed(key, unicode)

    xp.actualContext:keypressed(key, unicode)

    -- TODO que porquisse, tira isso daqui!
    if key == "escape" then love.event.quit() end
    -- player:keyPressed(key)

end

function love.keyreleased(key, unicode)

    xp.actualContext:keyreleased(key, unicode)
    -- player:keyReleased(key)

end

function love.focus(focus)

    xp.actualContext:focus(focus)

end

function love.quit()

    xp.actualContext:quit()

end

