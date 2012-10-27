--[[
   updatable.lua
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

Updatable = {}

Type(Updatable, function(updatable, fps, func) 
    
    if fps and func then 
        
        assert(type(fps) == "number" and type(func) == "function",
               "Incorrect parameter type: expected number and function")
        
        updatable.updTime = 1 / fps -- number
        updatable.updDT   = 0       -- number
        updatable.updFunc = func    -- function
    
    end
    
end)

function Updatable:update(dt, ...)
    
    self.updDT = self.updDT + dt
    
    if self.updDT > self.updTime then
        self.updFunc(...)
        self.updDT = self.updTime
    end
    
end

