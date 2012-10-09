ImageBank = {}
ImageBank.__index = ImageBank 

function ImageBank.__index(obj, key)
    return obj.images[key]
end

function ImageBank.__newindex(obj, key, value)
    obj.count = obj.count + 1
    
    if obj.count > obj.max then
        obj.images = {}
        obj.count = 1
    end
    
    obj.images[key] = value
end


setmetatable(ImageBank, {
    __call = function(table, max)
        return setmetatable({ count = 0, max = max, images = {} }, ImageBank)
    end
})
