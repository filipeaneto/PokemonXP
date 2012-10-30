--[[
   serializable.lua
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

require "Serial/compress"
require "Serial/serial"
require "lua/type"

Serializable = {}

Type(Serializable, function(serializable, typeName)

    -- verifica se o nome do tipo é válido
    assert(type(typeName) == "string" and _G[typeName].init,
           "Incorrect or missing parameter: expected a complex type name")

    serializable.serialType = typeName

end)

function Serializable:serialize(compressed)
    error("Attempt to call unimplemented serialize function")
end

function Serializable.deserialize(data, compressed)
    local t = -- blablabla(data)
    -- bla bla bla

    local typeName = t[1]

    return _G[typeName](unpack(t, 2))
end

