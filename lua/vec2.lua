Vec2 = {}
Vec2.__index = Vec2

function Vec2.__add(a, b)
  if type(a) == "number" then
    return Vec2.new(b.x + a, b.y + a)
  elseif type(b) == "number" then
    return Vec2.new(a.x + b, a.y + b)
  else
    return Vec2.new(a.x + b.x, a.y + b.y)
  end
end

function Vec2.__sub(a, b)
  if type(a) == "number" then
    return Vec2.new(b.x - a, b.y - a)
  elseif type(b) == "number" then
    return Vec2.new(a.x - b, a.y - b)
  else
    return Vec2.new(a.x - b.x, a.y - b.y)
  end
end

function Vec2.__mul(a, b)
  if type(a) == "number" then
    return Vec2.new(b.x * a, b.y * a)
  elseif type(b) == "number" then
    return Vec2.new(a.x * b, a.y * b)
  else
    return Vec2.new(a.x * b.x, a.y * b.y)
  end
end

function Vec2.__div(a, b)
  if type(a) == "number" then
    return Vec2.new(b.x / a, b.y / a)
  elseif type(b) == "number" then
    return Vec2.new(a.x / b, a.y / b)
  else
    return Vec2.new(a.x / b.x, a.y / b.y)
  end
end

function Vec2.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

function Vec2.__lt(a, b)
  return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function Vec2.__le(a, b)
  return a.x <= b.x and a.y <= b.y
end

function Vec2.__tostring(a)
  return "(" + a.x + ", " + a.y + ")"
end

function Vec2.new(x, y)
  return setmetatable({ x = x or 0, y = y or 0 }, Vec2)
end

function Vec2.distance(a, b)
  return (b - a):norm()
end

function Vec2:clone()
  return Vec2.new(self.x, self.y)
end

function Vec2:unpack()
  return self.x, self.y
end

function Vec2:norm()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:norm2()
  return self.x * self.x + self.y * self.y
end

function Vec2:normalize()
  local norm = self:norm()
  self.x = self.x / norm
  self.y = self.y / norm
  return self
end

function Vec2:normalized()
  return self / self:norm()
end

function Vec2:rotate(phi)
  local c = math.cos(phi)
  local s = math.sin(phi)
  self.x = c * self.x - s * self.y
  self.y = s * self.x + c * self.y
  return self
end

function Vec2:rotated(phi)
  return self:clone():rotate(phi)
end

function Vec2:perpendicular()
  return Vec2.new(-self.y, self.x)
end

function Vec2:projectOn(other)
  return (self * other) * other / other:norm2()
end

function Vec2:cross(other)
  return self.x * other.y - self.y * other.x
end

function Vec2:copy()
  return Vec2(self.x, self.y)
end

setmetatable(Vec2, { __call = function(_, ...) return Vec2.new(...) end })
