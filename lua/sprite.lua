--[[
   sprite.lua
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

require "lua/serializable"
require "lua/animation"
require "lua/updatable"
require "lua/drawable"
require "lua/type"
require "lua/game"

Sprite = {}

Type(Sprite, Drawable, Updatable, Serializable,
function(sprite, filename, posX, posY, imageFilename)

    -- abre o arquivo .spr ou .spt
    local chunk = love.filesystem.load(SPRITE_PATH..filename)
    local spriteData = chunk()

    -- verifica sobreescrita da imagem
    imageFilename = imageFilename or spriteData.imageFilename
    assert(type(imageFilename) == "string",
           "Incorrect or missing parameter: expected image filename")

    -- recupera e atualiza o banco de imagens
    local image = xp.imageBank[imageFilename] or
                  love.graphics.newImage(IMAGE_PATH..imageFilename)
    xp.imageBank[imageFilename] = image

    -- funções de inicialização dos supertipos não serão utilizados
    -- preenche os demais atributos
    sprite.sprFilename         = filename

    sprite.sprImage            = image                 -- LÖVE Image
    sprite.sprImageFilename    = imageFilename         -- string

    sprite.sprPosX             = posX or 0             -- number
    sprite.sprPosY             = posY or 0             -- number

    sprite.sprWidth            = spriteData.width      -- number
    sprite.sprHeight           = spriteData.height     -- number

    local animations = {}
    -- cria animações
    for _, animData in ipairs(spriteData.animations) do

        local scaleX, scaleY = animData.scaleX or 1, animData.scaleY or 1
        if animData.mirrorX then scaleX = -scaleX end
        if animData.mirrorY then scaleY = -scaleY end

        animations[animData.name] =
            Animation(image, animData.x, animData.y,
                      sprite.sprWidth, sprite.sprHeight,
                      scaleX, scaleY,
                      animData.frameCount, animData.frameLength)
    end

    -- atribui próxima animação
    for _, animData in ipairs(spriteData.animations) do

        animations[animData.name]:
            setNextAnimation(animations[animData.nextAnimation])

    end

    sprite.sprAnimating        = spriteData.animating  -- boolean
    sprite.sprAnimationByName  = animations            -- table

    local firstAnimName = spriteData.animations[1].name
    sprite.sprAnimation = animations[firstAnimName]    -- Animation

end)

function Sprite:setPosition(x, y)
    self.sprPosX, self.sprPosY = x, y
end

function Sprite:getPosition()
    return self.sprPosX, self.sprPosY
end

function Sprite:setAnimation(animationName)

    self.sprAnimation:reset()
    self.sprAnimation = self.sprAnimationByName[animationName]

end

function Sprite:update(dt)

    if self.sprAnimating then
        -- atualiza a animação se necessário
        self.sprAnimation = self.sprAnimation:update(dt)
    end

end

function Sprite:draw()
    self.sprAnimation:draw(self.sprPosX, self.sprPosY)
end

function Sprite:serialize(compressed)

    return Serializable.serialize({
        self.sprFilename,
        self.sprPosX,
        self.sprPosY,
        self.sprImageFilename
    }, compressed)

end
