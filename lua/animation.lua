--[[
   animation.lua
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

Animation = {}

Type(Animation, Drawable, Updatable,
function(animation, image, cornerX, cornerY, width, height,
         scaleX, scaleY, frameCount, frameLength)

    animation.aniImage          = image         -- LÖVE Image
    -- armazenar os quads da animação
    animation.aniQuads          = {}            -- table

    animation.aniScaleX         = scaleX or 1   -- number
    animation.aniScaleY         = scaleY or 1   -- number

    animation.aniCenterX        = width / 2     -- number
    animation.aniCenterY        = height / 2    -- number

    -- pelo menos um frame
    animation.aniFrameCount     = frameCount or 1   -- number
    animation.aniCurrentFrame   = 0                 -- number

    animation.aniFrameLength    = frameLength       -- number
    animation.aniFrameTimer     = 0.0               -- number

    -- percorre a imagem horizontamente gerando os quads
    for i = 1, frameCount do
        animation.aniQuads[i] =
            love.graphics.newQuad(cornerX + (i - 1) * width, cornerY,
                                  width, height,
                                  image:getWidth(), image:getHeight())
    end

end)

function Animation:reset()
    self.aniCurrentFrame = 0
end

function Animation:setNextAnimation(nextAnimation)
    self.aniNextAnimation = nextAnimation
end

function Animation:update(dt)

    if not self.aniFrameLength then return self end

    self.aniFrameTimer = self.aniFrameTimer + dt

    if self.aniFrameTimer > self.aniFrameLength then

        self.aniFrameTimer = self.aniFrameTimer - self.aniFrameLength
        -- atualiza o frame corrente
        self.aniCurrentFrame = (self.aniCurrentFrame + 1) % self.aniFrameCount

        if self.aniCurrentFrame == 0 then
            -- caso a animação tenha terminado retorna a próximo,
            -- se não há próxima, retorna a si mesma
            return self.aniNextAnimation or self
        end

    end

    return self
end

function Animation:draw(x, y)

    love.graphics.drawq(
        self.aniImage,                          -- imagem
        self.aniQuads[self.aniCurrentFrame + 1],-- quad
        x, y,                                   -- posição
        0,                                      -- rotação
        self.aniScaleX, self.aniScaleY,         -- escala
        self.aniCenterX, self.aniCenterY        -- pivô
    )

end

