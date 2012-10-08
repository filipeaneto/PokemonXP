require("lua/game")
require("lua/animation")
require("math")

Sprite = {}
-- Constructor
setmetatable(Sprite, {
    __call = function(table, filename, imageFilename)
        print("creating: sprite: " .. filename)
        local chunk = love.filesystem.load(game:getSpritePath() .. filename)
        local spriteData = chunk()

        spriteData.imageFilename = imageFilename or spriteData.imageFilename

        if imageBank[spriteData.imageFilename] == nil then
            print("imageBank: "..spriteData.imageFilename.." missing")
            print("image: "..spriteData.imageFilename.." opened")
        else
            print("imageBank: "..spriteData.imageFilename.." is already opened")
            print("image: "..spriteData.imageFilename.." loaded")
        end

        local image = imageBank[spriteData.imageFilename] or
            love.graphics.newImage(game:getImagePath() .. spriteData.imageFilename)

        imageBank[spriteData.imageFilename] = image


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
            obj.animation[spriteData.animations[i].name] =
                Animation(image, spriteData.animations[i].x,
                          spriteData.animations[i].y,
                          obj.width, obj.height,
                          spriteData.animations[i].frameCount,
                          spriteData.animations[i].frameLength,
                          spriteData.animations[i].nextAnimation)
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

