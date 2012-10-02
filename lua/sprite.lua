require("lua/game")
require("lua/animation")
require("math")

Sprite = {}
-- Constructor
setmetatable(Sprite, {
    __call = function(table, filename)
        local chunk = love.filesystem.load(game:getSpritePath() .. filename)
        local spriteData = chunk()

        local imageData = love.image.newImageData(game:getImagePath() ..
                                                  spriteData.imageFilename)

        local obj = {
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
        
        if spriteData.animating then
            for i = 1, #spriteData.animations do
                obj.animation[spriteData.animations[i].name] =
                    Animation(imageData, spriteData.animations[i].x,
                              spriteData.animations[i].y,
                              obj.width, obj.height,
                              spriteData.animations[i].frameCount,
                              spriteData.animations[i].frameLength,
                              spriteData.animations[i].nextAnimation)
            end
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

function Sprite:getCurrentFrameAnimation()
    return animations[currentAnimation]
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
    self.animation[self.currentAnimation].playCount = 0
    self.currentAnimation = animation
end

function Sprite:update(dt)
    if self.animating then
        self.animation[self.currentAnimation]:update(dt)
        
        if self.animation[self.currentAnimation].nextAnimation ~= nil then
            if self.animation[self.currentAnimation].playCount > 0 then
                self.animation[self.currentAnimation].playCount = 0
                self.currentAnimation = 
                    self.animation[self.currentAnimation].nextAnimation
            end
        end
    end
end
   
function Sprite:draw()
    love.graphics.draw(self.animation[self.currentAnimation]:getImage(),
                       self.position.x, self.position.y)
end
