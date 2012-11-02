--[[
   imagebank.lua
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

ImageBank = {}

Type(ImageBank,
function(imageBank, max)

    imageBank.ibkMax    = max or 1
    imageBank.ibkCount  = 0
    imageBank.ibkImages = {}

end)

function ImageBank:open(name)

    if self.ibkImages[name] then 
        return self.ibkImages[name]
    end

    self.ibkCount = self.ibkCount + 1

    if self.ibkCount > self.ibkMax then
        self.ibkImages = {}
        self.ibkCount = 1
    end

    self.ibkImages[name] = love.graphics.newImage(name)

    return self.ibkImages[name]

end

