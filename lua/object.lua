require("lua/game")
require("lua/vec2")
require("math")

Object = {}

setmetatable(Object, {
    __call = function(table, sprite)
        obj = {
            sprite = sprite
        }
        
        setmetatable(obj, { __index = Object })
        return obj
    end
})

function Object:draw()
    self.sprite:draw()
end

function Object:update(dt)
    self.sprite:update(dt)
end

function Object:move(dx, dy)
    local dv = {}
    if dy == nil then dv = dx else dv = Vec2(dx, dy) end

    dv.x, dv.y = math.floor(dv.x), math.floor(dv.y)

    self.sprite:setPosition(
        self.sprite:getPosition().x + dx * game:getGrid().x,
        self.sprite:getPosition().y + dy * game:getGrid().y
    )
end


function Object:getSprite()
    return self.sprite
end
