--[[
   vec2.lua
   This file is part of PokémonXP

   Copyright (C) 2012 - Filipe Neto

   PokémonXP is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   PokémonXP is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with PokémonXP. If not, see <http://www.gnu.org/licenses/>.
]]

--[[ Descrição da Classe: Vetor de duas dimensões.

Atributos públicos:
        x - valor x do vetor
        y - valor y do vetor
]]

Vec2 = {}
Vec2.__index = Vec2

--[[ Descrição do Método: Soma de vetores

c = Vec2.__add(a, b)
    Vec2 a, b: operandos
    Vec2 c: vetor soma
]]
function Vec2.__add(a, b)
    return Vec2.new(a.x + b.x, a.y + b.y)
end

--[[ Descrição do Método: Subtração de vetores

c = Vec2.__sub(a, b)
    Vec2 a, b: operandos
    Vec2 c: vetor diferença
]]
function Vec2.__sub(a, b)
    return Vec2.new(a.x - b.x, a.y - b.y)
end

--[[ Descrição do Método: Multiplicação por escalar

c = Vec2.__mul(a, b)
    Vec2 a, Number b | Number a, Vec2 b: operandos
    Vec2 c: vetor produto
]]
function Vec2.__mul(a, b)
    if type(a) == "number" then
        return Vec2.new(b.x * a, b.y * a)
    elseif type(b) == "number" then
        return Vec2.new(a.x * b, a.y * b)
    end
end

--[[ Descrição do Método: Divisão por escalar

c = Vec2.__div(a, b)
    Vec2 a, Number b | Number a, Vec2 b: operandos
    Vec2 c: vetor resultante
]]
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
    return a:norm2() < b:norm2()
end

function Vec2.__le(a, b)
    return a:norm2() <= b:norm2()
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
    return self:clone():normalize()
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

function Vec2:dot(other)
    return self.x * other.x + self.y * other.y
end

function Vec2:cross(other)
    return self.x * other.y - self.y * other.x
end

setmetatable(Vec2, { __call = function(_, ...) return Vec2.new(...) end })

