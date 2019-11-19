function love.load()
    StoneMoSScreen = require "libs.StoneMoSScreen"; StoneMoSScreen.new(true, 800, 600)
    angle = 0
end

function love.update(dt)
    angle = angle + dt
end

function love.draw()
    love.graphics.printf("StoneMoSScreen", 400, 300, 110, "center", angle, sx, sy, 55, 5)
end

function love.resize(w, h)
    StoneMoSScreen:getScaleDimension():screenResize(w, h)
end
