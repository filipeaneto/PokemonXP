--[[
   type.lua
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

require "table"

function isA(self, ctype)

    -- self pode ser uma instância de ctype ou pode ser ctype
    if self == ctype then return true end
    if getmetatable(self) == ctype then return true end

    -- caso não seja, pode ser subtipo de ctype
    if not self._supertype then return false end
    for _, base in ipairs(self._supertype) do
        -- testa para cada supertipo
        if base:isA(ctype) then return true end
    end

    return false

end

function Type(newType, opt, ...)

    assert(type(newType) == "table",
           "Incorrect parameter type: expected table")

    -- se opt é uma tabela, esta será um supertipo de newType
    if type(opt) == "table" then

        local supertype = opt
        for key, value in pairs(supertype) do
            -- copia todos as funções do supertipo
            if type(supertype[key]) == "function" then
                newType[key] = value
            end
        end

        -- insere o supertipo na lista de supertipos
        if not newType._supertype then newType._supertype = {} end
        table.insert(newType._supertype, supertype)

        -- tratar outras opções
        Type(newType, ...)

    -- se opt é uma função, esta será sua função de inicialização
    elseif type(opt) == "function" then

        newType.init = opt
        Type(newType, ...)

    -- caso não haja mais opções, finalize o novo tipo
    elseif not opt then

        assert(newType.init, "Attempt to create type without init function")

        newType.__index = newType

        if not newType._supertype then newType.isA = isA end

        setmetatable(newType, {
            __call = function(_, ...)
                local inst = setmetatable({}, newType)
                inst:init(...)
                return inst
            end
        })

    end

end

