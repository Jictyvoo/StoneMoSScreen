function love.load()
    StoneMoSScreen = require "libs.StoneMoSScreen"; StoneMoSScreen.new(800, 600, true, true, true)
    gameDirector = {
        angle = 0, image = love.graphics.newImage("assets/background.png"),
        dynamic_sprite = love.graphics.newImage("assets/sprite_dynamic.png"),
        dynamic = {x = 400, y = 300, sx = 0.5, sy = 0.5, speed = {x = 0, y = 0}},
        pressed_keys = {vertical = "", horizontal = ""}, elapsed_time = 0
    }
end

function love.keypressed(key, scancode, isrepeat)
    if key == "w" then gameDirector.dynamic.speed.y = -2; gameDirector.pressed_keys.vertical = key
    elseif key == "s" then gameDirector.dynamic.speed.y = 2; gameDirector.pressed_keys.vertical = key
    elseif key == "a" then gameDirector.dynamic.speed.x = -2; gameDirector.pressed_keys.horizontal = key
    elseif key == "d" then gameDirector.dynamic.speed.x = 2; gameDirector.pressed_keys.horizontal = key
    end
end

function love.keyreleased(key, scancode)
    if key == gameDirector.pressed_keys.vertical then gameDirector.dynamic.speed.y = 0
    elseif key == gameDirector.pressed_keys.horizontal then gameDirector.dynamic.speed.x = 0
    end
end

function love.update(dt)
    gameDirector.angle = gameDirector.angle + dt
    gameDirector.elapsed_time = gameDirector.elapsed_time + dt
    if gameDirector.elapsed_time >= 0.018 then
        gameDirector.elapsed_time = 0
        gameDirector.dynamic.x = gameDirector.dynamic.x + gameDirector.dynamic.speed.x
        gameDirector.dynamic.y = gameDirector.dynamic.y + gameDirector.dynamic.speed.y
    end
end

function love.draw()
    love.graphics.draw(gameDirector.image, 0, 0, r, 1.389, 1.389, ox, oy)
    StoneMoSScreen.draw(gameDirector.dynamic_sprite, gameDirector.dynamic.x, gameDirector.dynamic.y, r,gameDirector.dynamic.sx, gameDirector.dynamic.sy, ox, oy)
    love.graphics.printf("StoneMoSScreen", 400, 300, 110, "center", gameDirector.angle, sx, sy, 55, 5)
end

function love.resize(w, h)
    StoneMoSScreen.screenResize(w, h)
end
