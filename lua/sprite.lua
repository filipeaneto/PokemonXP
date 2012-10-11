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

require("lua/game")
require("lua/animation")
require("math")

Sprite = {}
-- Constructor
setmetatable(Sprite, {
    __call = function(table, filename, imageFilename)
        print("creating: sprite: " .. filename)
        local chunk = love.filesystem.load(xpGame:getSpritePath() .. filename)
        local spriteData = chunk()

        spriteData.imageFilename = imageFilename or spriteData.imageFilename

        if xpImageBank[spriteData.imageFilename] == nil then
            print("imageBank: "..spriteData.imageFilename.." missing")
            print("image: "..spriteData.imageFilename.." opened")
        else
            print("imageBank: "..spriteData.imageFilename.." is already opened")
            print("image: "..spriteData.imageFilename.." loaded")
        end

        local image = xpImageBank[spriteData.imageFilename] or
                        love.graphics.newImage(xpGame:getImagePath() ..
                                               spriteData.imageFilename)

        xpImageBank[spriteData.imageFilename] = image


        local obj = {
            image           = image,

            animating       = spriteData.animating,
            animation       = {},
            currentAnimation= spriteData.animations[1].name,

            rotateByPosition= spriteData.rotating,
            rotation        = 0,

            position        = Vec2(),
            lastPosition    = Vec2(),

            width           = spriteData.width,
            height          = spriteData.height,

            center          = {spriteData.width / 2, spriteData.height / 2}
        }

        for i = 1, #spriteData.animations do
            local iAnimation = spriteData.animations[i]

            obj.animation[iAnimation.name] =
                Animation(image, iAnimation.x, iAnimation.y,
                          { x = iAnimation.mirrorX, y = iAnimation.mirrorY },
                          obj.width, obj.height,
                          iAnimation.frameCount,
                          iAnimation.frameLength,
                          iAnimation.nextAnimation)
        end

        setmetatable(obj, { __index = Sprite })
        return obj
    end
})

function Sprite:updateRotation()
    if self.rotateByPosition then
        rotation = math.atan2(position.y - lastPosition.y,
                              position.x - lastPosition.x)
    end
end

function Sprite:getCurrentAnimation()
    return self.animation[self.currentAnimation]
end

function Sprite:setPosition(x, y, teleport)
    local position
    if y == nil then position = Vec2(x.x, x.y) else position = Vec2(x, y) end

    self.lastPosition = self.position
    self.position = position

    if teleport == nil then self:updateRotation() end

    return true
end

function Sprite:getPosition(cood)
    if cood == nil then
        return self.position
    else
        return self.position[cood]
    end
end

function Sprite:setAnimation(animation)
    self:getCurrentAnimation().playCount = 0
    self.currentAnimation = animation
end

function Sprite:update(dt)
    if self.animating then
        local animation = self:getCurrentAnimation()
        animation:update(dt)

        if animation.nextAnimation ~= nil then
            if animation.playCount > 0 then
                animation.playCount = 0
                self.currentAnimation = animation.nextAnimation
            end
        end
    end
end

function Sprite:draw()
    self.animation[self.currentAnimation]:draw(self.position.x, self.position.y)
end

