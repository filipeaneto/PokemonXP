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

require "lua/menucontext"
require "lua/mapcontext"
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
    xp.config       = Config()


    -- TODO Atributos do jogo, serão preenchidos por outros contextos
    xp.battleContext    = {}
    xp.mapContext       = MapContext()
    xp.player           = {}
    xp.map              = {}

    -- TODO Atributos do menu
    xp.menu         = Menu()
    xp.menuContext = MenuContext()

    -- Inicializa o contexto atual como o menu ou com o firstRun
    if xp.config.firstRun then
        xp.actualContext = FirstRunContext()
    else
        xp.status       = {} -- TODO
        xp.imageBank    = ImageBank()
        xp.game         = Game()

        xp.actualContext = xp.menuContext
    end

    -- TODO não esquecer de tirar o Debug na versão final
    debug = Debug()

end

function love.update(dt)

    xp.game:update()
    debug:update(dt)

    xp.actualContext:update(dt)

end

function love.draw()

    xp.actualContext:draw()

    debug:draw()
    xp.game:wait()

end

function love.mousepressed(x, y, button)

    xp.actualContext:mousePressed(x, y, button)

end

function love.mousereleased(x, y, button)

    xp.actualContext:mouseReleased(x, y, button)

end

function love.keypressed(key, unicode)

    xp.actualContext:keyPressed(key, unicode)

    -- TODO que porquisse, tira isso daqui!
    if key == "escape" then love.event.quit() end

end

function love.keyreleased(key, unicode)

    xp.actualContext:keyReleased(key, unicode)

end

function love.focus(focus)

    xp.actualContext:focus(focus)

end

function love.quit()

    xp.actualContext:quit()

end

