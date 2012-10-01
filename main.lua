require("lua/sprite")

function love.load()
    sprite = Sprite("hero.spr")
end

function love.update(dt)
    sprite:update(dt)
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
    sprite:draw()
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)

end

function love.keyreleased(key, unicode)
   
end

function love.focus(focus)

end

function love.quit()

end
