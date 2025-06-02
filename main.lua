local love = require "love"

local Game = require "game.game"

love.graphics.setDefaultFilter('nearest', 'nearest')

local currentMode = Game

function love.load()
    currentMode.load()
    love.window.setTitle('Hello love2d!')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    -- ...
end

function love.keypressed(key)
    currentMode.keysPressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    currentMode.update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    currentMode.draw()
end


function love.mousepressed(x, y, button)
    currentMode.mousepressed(x, y, button)
end


function love.mousereleased(x, y, button)
    currentMode.mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    currentMode.mousemoved(x, y, dx, dy)
end
