require("lua/vec2")

Game = {}
setmetatable(Game, {
    __call = function(table)
        obj = {
            spritePath  = "data/sprite/",
            imagePath   = "data/image/",
            
            grid        = Vec2(64, 64),
            
            timerMinDt  = 1/30,
            timerNext   = nil,
        }
        
        setmetatable(obj, { __index = Game } )
        return obj
    end
})

function Game:start()
    self.timerNext = love.timer.getMicroTime()
end

function Game:update(dt)
    self.timerNext = self.timerNext + self.timerMinDt
end

function Game:wait()
    local curTime = love.timer.getMicroTime()
    if self.timerNext <= curTime then
        self.timerNext = curTime
        return
    end
    love.timer.sleep(self.timerNext - curTime) 
end

function Game:getSpritePath() return self.spritePath end
function Game:getImagePath() return self.imagePath end

function Game:getGrid() return self.grid end

function Game:setFPS(fps) self.timerMinDt = 1/fps end
