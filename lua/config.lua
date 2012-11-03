--[[
   config.lua
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

Config = {}

Type(Config,
function(config)

    -- se não existir arquivo indicando o último usuário
    if not love.filesystem.exists(".lastuser") then

        love.filesystem.write(".lastuser", "return \"default\"\n")
        love.filesystem.mkdir("default")
        love.filesystem.write("default/config.cfg", "return {}\n")

    end

    local chunk = love.filesystem.load(".lastuser")
    config.user = chunk()

    if config.user == "default" then
        config.firstRun = true
    end

    chunk = love.filesystem.load(config.user.."/config.cfg")
    local configData = chunk()

    if configData.fullscreen then
        love.graphics.toggleFullscreen()
    end

    -- preenche dados, tenha sempre um valor default
    config.imageBankSize    = configData.imageBankSize  or 50
    config.fps              = configData.fps            or 24

end)

