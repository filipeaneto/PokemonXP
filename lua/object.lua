require("lua/game")
require("lua/vec2")
require("lua/list")
require("math")

Object = {}

setmetatable(Object, {
    __call = function(table, sprite, speed, deltaStep)
        obj = {
            sprite      = sprite,
            dPosition   = Vec2(sprite:getPosition().x, sprite:getPosition().y),
            speed       = speed or 32,
            movements   = List(),
            isMoving    = false,
            deltaStep   = deltaStep or 2
        }
        
        setmetatable(obj, { __index = Object })
        return obj
    end
})

function Object:draw()
    self.sprite:draw()
end

function Object:update(dt)
    if self.isMoving then    
        local position = self.sprite:getPosition()
        local dp = (position - self.dPosition)
        local norm = dp:norm()
        
        dp = dt * self.speed * (dp:normalized()) 
        
        if norm < self.deltaStep then
            self.isMoving = false
        end
        self.sprite:setPosition(position - dp)
        
    elseif not self.movements:isEmpty() then
        local mov = self.movements:popLeft()
        local dv, animation = mov.vector, mov.animation
        
        if animation ~= nil then self.sprite:setAnimation(animation) end
    
        dv.x, dv.y = math.floor(dv.x), math.floor(dv.y)

        self.dPosition.x = self.dPosition.x + dv.x * game:getGrid().x
        self.dPosition.y = self.dPosition.y + dv.y * game:getGrid().y
        
        self.isMoving = true   
    end
    
    self.sprite:update(dt)
end

function Object:move(dx, dy, animation)
    local dv = {}
    if dy == nil then dv = Vec2(dx) else dv = Vec2(dx, dy) end

    self.movements:pushRight({ vector = dv, animation = animation})
end


function Object:getSprite()
    return self.sprite
end
