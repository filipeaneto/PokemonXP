Animation = {}
-- Constructor
setmetatable(Animation, {
    __call = function(table, image, x, y, mirror, width, height,
                      frameCount, frameLength, nextAnimation)

        local obj = {
            image               = image,
            quads               = {},

            scale               = { x = 1, y = 1 },
            center              = { x = width/2, y = height/2 },

            frameCount          = frameCount,
            currentFrame        = 0,

            frameLength         = frameLength,
            frameTimer          = 0.0,

            playCount           = 0,

            nextAnimation       = nextAnimation
        }

        for i = 0, frameCount-1 do
            obj.quads[i + 1] = love.graphics.newQuad(
                x + i * width, y, width, height,
                image:getWidth(), image:getHeight()
            )
        end

        if mirror.x then obj.scale.x = - obj.scale.x end
        if mirror.y then obj.scale.y = - obj.scale.y end

        setmetatable(obj, { __index = Animation })
        return obj
    end
})

function Animation:update(dt)
    if self.frameLength == nil then return end

    self.frameTimer = self.frameTimer + dt

    while self.frameTimer > self.frameLength do
        self.frameTimer = self.frameTimer - self.frameLength
        self.currentFrame = (self.currentFrame + 1) % self.frameCount

        if self.currentFrame == 0 then self.playCount = self.playCount + 1 end
    end
end

function Animation:getQuad()
    return self.quads[self.currentFrame + 1]
end

function Animation:draw(x, y)
    love.graphics.drawq(self.image, self:getQuad(), x, y, 0,
                        self.scale.x, self.scale.y,
                        self.center.x, self.center.y)
end

