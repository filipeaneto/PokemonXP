require("lua/game")
require("lua/animation")
require("math")

Sprite = {}
-- Constructor
setmetatable(Sprite, {
    __call = function(table, filename)
        local chunk = love.filesystem.load(Game.GetSpritePath() .. filename)
        local spriteData = chunk()

        local imageData = love.image.newImageData(Game.GetImagePath() ..
                                                  spriteData.imageFilename)

        local obj = {
            animating       = spriteData.animating,
            animation       = {},
            currentAnimation= spriteData.animations[1].name,
            
            rotateByPosition= spriteData.rotating,
            rotation        = 0,
            
            position        = {x = 0, y = 0},
            lastPosition    = {x = 0, y = 0},
            
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

function Sprite:setPosition(x, y)
    if #x ~= 1 or #y ~= 1 then return false end
    return self:setPosition({x = x, y = y})
end

function Sprite:setPosition(position)
    if position.x ~= nil and position.y ~= nil then return false end
    
    self.lastPosition = self.position
    self.position = position
    self:updateRotation()
    
    return true
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
