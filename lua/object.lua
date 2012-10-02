require("lua/game")
require("lua/vec2")
require("math")

Object = {}

setmetatable(Object, {
    __call = function(table, sprite, speed)
        obj = {
            sprite      = sprite,
            dPosition   = Vec2(sprite:getPosition().x, sprite:getPosition().y),
            speed       = speed or 1
        }
        
        setmetatable(obj, { __index = Object })
        return obj
    end
})

function Object:draw()
    self.sprite:draw()
end

function Object:update(dt)
    local position = self.sprite:getPosition()
    local dp = (position - self.dPosition)
    
    if dp:norm() > self.speed then dp = self.speed * (dp:normalized()) end
    
    self.sprite:setPosition(position - dp)
    self.sprite:update(dt)
end

function Object:move(dx, dy)
    local dv = {}
    if dy == nil then dv = Vec2(dx) else dv = Vec2(dx, dy) end

    dv.x, dv.y = math.floor(dv.x), math.floor(dv.y)

    self.dPosition.x = self.dPosition.x + dv.x * game:getGrid().x
    self.dPosition.y = self.dPosition.y + dv.y * game:getGrid().y
end


function Object:getSprite()
    return self.sprite
end
