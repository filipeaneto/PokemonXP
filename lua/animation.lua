Animation = {}
-- Constructor
setmetatable(Animation, {
    __call = function(table, image, x, y, width, height,
                      frameCount, frameLength, nextAnimation)

        local obj = {
            image               = image,
            quads               = {},

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
    love.graphics.drawq(self.image, self:getQuad(), x, y)
end

