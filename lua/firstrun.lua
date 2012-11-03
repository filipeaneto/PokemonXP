--[[
   firstrun.lua
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

require "string"

require "lua/context"
require "lua/type"

FirstRunContext = {}

Type(FirstRunContext, Context,
function(context)

    context.inputName = ""

end)

function FirstRunContext:update(dt)

end

function FirstRunContext:draw()

    -- TODO alguém, por favor, deixe isso bonito!
    love.graphics.print("What's your name?", 10, 100)
    love.graphics.print(self.inputName:upper(), 10, 125)

end

-- TODO * permitir outros caracteres e tornar multiplataforma
--      * repetição da tecla (segurar a tecla)
function FirstRunContext:keypressed(key, unicode)

    -- 0-9 => 48-57; A-Z => 97-122; backspace => 8; enter => 13

    -- letras
    if unicode >= 97 and unicode <= 122 then

        self.inputName = self.inputName..key

    -- backspace
    elseif unicode == 8 then

        local len = self.inputName:len()

        if len > 0 then
            self.inputName = self.inputName:sub(0, len - 1)
        end

    elseif unicode == 13 then

        -- TODO criar o novo usuário
        local user = self.inputName:lower()
        love.filesystem.write(".lastuser", "return \""..user.."\"\n")
        love.filesystem.mkdir(user)
        love.filesystem.write(user.."/config.cfg", "return {}\n")

        -- reinicializa o config e o TODO status
        xp.config = Config()
        -- troca de contexto
        xp.actualContext = MenuContext()

    end

end
