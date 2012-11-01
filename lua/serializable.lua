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

require "serial/compress"
require "serial/serial"
require "lua/type"

Serializable = {}

Type(Serializable,
function(serializable)

end)

function Serializable:serialize(compressed)
    local serial = serialize(self)

    if compressed then serial = compress(serial) end

    return serial
end

function Serializable:Deserialize(serial, compressed)

    if compressed then serial = decompress(serial) end
    serial = deserialize(serial)

    return self(unpack(serial)) -- chama construtor do tipo

end

