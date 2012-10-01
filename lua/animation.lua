Animation = {}
-- Constructor
setmetatable(Animation, {
    __call = function(table, imageData, x, y, width, height, 
                      frameCount, frameLength, nextAnimation)
        
        local obj = {
            images              = {},

            frameCount          = frameCount,
            currentFrame        = 0,
            
            frameLength         = frameLength,
            frameTimer          = 0.0,
            
            playCount           = 0,
            
            nextAnimation       = nextAnimation
        }
        
        for i = 0, frameCount-1 do
            local frameData = love.image.newImageData(width, height)
            frameData:paste(imageData, 0, 0, x + i * width, y, width, height)
            
            obj.images[i + 1] = love.graphics.newImage(frameData)
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

function Animation:getImage()
    return self.images[self.currentFrame + 1]
end
