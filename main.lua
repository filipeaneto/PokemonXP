require("lua/keyboard")
require("lua/sprite")
require("lua/object")
require("lua/game")

function love.load()
    game = Game()
    
    game:setFPS(24)

    game:start()

    object = Object(Sprite("hero.spr"), 96)
    object.deltaStep = 16
    
    
    limitKey = 0
end

function love.update(dt)
    game:update(dt)
    
    limitKey = limitKey + dt
    
    if limitKey > 1 then
        if love.keyboard.isDown("a") then
        
            object:move(-1, 0, "walking_left")
--            object:getSprite():setAnimation("walking_left")
            
        elseif love.keyboard.isDown("s") then
        
            object:move(0, 1, "walking_down")
--            object:getSprite():setAnimation("walking_down")
        
        elseif love.keyboard.isDown("d") then
        
            object:move(1, 0, "walking_right")
--            object:getSprite():setAnimation("walking_right")
        
        elseif love.keyboard.isDown("w") then
        
            object:move(0, -1, "walking_up")
--            object:getSprite():setAnimation("walking_up")
        
        end
        limitKey = limitKey - 0.8
    end

    object:update(dt)
end

function love.draw()
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)

    love.graphics.print("Hello World", 400, 300)
    object:draw()
    
    -- Control FPS
    game:wait()
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)
    if key == "escape" then
        love.event.quit()
    end
end

function love.keyreleased(key, unicode)
    
end

function love.focus(focus)

end

function love.quit()

end
