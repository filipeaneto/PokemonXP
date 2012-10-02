Vec2 = {}

setmetatable(Vec2, {
    __call = function(table, x, y)
        obj = { x = x or 0, y = y or 0}
        setmetatable(obj, { __index = Vec2 })
        return obj
    end
})

function Vec2.__add(a, b)
    return Vec2(a.x + b.x, a.y + b.y)
end
