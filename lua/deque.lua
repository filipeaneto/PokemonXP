Deque = {}

setmetatable(Deque, {
    __call = function(table)
        obj = { first = 0, last = -1 }
        setmetatable(obj, { __index = Deque })
        return obj
    end
})

function Deque:pushLeft (value)
  local first = self.first - 1
  self.first = first
  self[first] = value
end

function Deque:pushRight (value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function Deque:isEmpty()
   return self.first > self.last 
end

function Deque:popLeft ()
  local first = self.first
  if first > self.last then error("list is empty") end
  local value = self[first]
  self[first] = nil        -- to allow garbage collection
  self.first = first + 1
  return value
end

function Deque:popRight ()
  local last = self.last
  if self.first > last then error("list is empty") end
  local value = self[last]
  self[last] = nil         -- to allow garbage collection
  self.last = last - 1
  return value
end

