function love.load()
    StoneMoSScreen = require "libs.StoneMoSScreen"; StoneMoSScreen.new(800, 600, true, true, true)
    angle = 0; image = love.graphics.newImage("assets/background.png")
end

function love.update(dt)
    angle = angle + dt
end

function love.draw()
    love.graphics.draw(image, 0, 0, r, 1.3913, 1.3071, ox, oy)
    love.graphics.printf("StoneMoSScreen", 400, 300, 110, "center", angle, sx, sy, 55, 5)
end

function love.resize(w, h)
    StoneMoSScreen.screenResize(w, h)
end
