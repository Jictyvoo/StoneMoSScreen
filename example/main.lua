function love.load()
    StoneMoSScreen = require "libs.StoneMoSScreen"; StoneMoSScreen.new(true, 800, 600)
end

function love.update(dt)
end

function love.draw()
end

function love.resize(w, h)
    StoneMoSScreen:getScaleDimension():screenResize(w, h)
end
