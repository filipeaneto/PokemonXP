--[[
   context.lua
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

require "lua/updatable"
require "lua/drawable"
require "lua/type"

Context = {}

Type(Context, Updatable, Drawable, function() end)

function Context:mousePressed(x, y, button)

end

function Context:mouseReleased(x, y, button)

end

function Context:keyPressed(key, unicode)

end

function Context:keyReleased(key, unicode)

end

function Context:focus(focus)

end

function Context:quit()

end
