local love = require "love"
local Block = require "game_objects.Block"
local Grid = require "game_objects.Grid"
local utils = require "game.utils"
local config = require "game.config"

local Game = {}

local MouseX, MouseY = 0, 0
local dragStartX, dragStartY = nil, nil

local Blocks = {}
local selectedBlock = nil
local G = nil

function Game.load()
    MouseX, MouseY = 0, 0
    G = Grid.new(6, 6)

    local b1 = Block.new({{x=2,y=4}, {x=3,y=4}, {x=4,y=4}},
    {grid=G, allowedDirections = {horizontal=true, vertical=false}})
    table.insert(Blocks, b1)

    local b2 = Block.new({{x=5,y=5}, {x=5,y=4},},
    {grid=G, allowedDirections = {horizontal=true, vertical=true}})
    table.insert(Blocks, b2)

end

function Game.update(dt)
    MouseX, MouseY = love.mouse.getPosition()
end

function Game.draw()
    if G ~= nil then
        G:draw(config.cellSize,config.cellSpacing)
    end
    for _, block in ipairs(Blocks) do
        block:draw(config.cellSize,config.cellSpacing)
    end
end

function Game.mousepressed(x, y, button)
    if button == 1 then
        local gx, gy = utils.screenToGrid(x, y)

        for _, block in ipairs(Blocks) do
            if block:is_on(gx, gy) then
                selectedBlock = block
                dragStartX = x
                dragStartY = y
                return
            end
        end
    end
end


function Game.mousereleased(x, y, button)
    if button == 1 then
        selectedBlock = nil
        dragStartX = nil
        dragStartY = nil
    end
end

function Game.mousemoved(x, y, dx, dy)
    if selectedBlock and dragStartX and dragStartY then
        local totalDX, totalDY = x - dragStartX, y - dragStartY
        local moveX, moveY = 0, 0

        local threshold = config.cellSize * config.dragThreshold

        if math.abs(totalDX) > threshold then
            moveX = totalDX > 0 and 1 or -1
            dragStartX = x
        end

        if math.abs(totalDY) > threshold then
            moveY = totalDY > 0 and 1 or -1
            dragStartY = y
        end

        if moveX ~= 0 or moveY ~= 0 then
            selectedBlock:move(G, moveX, moveY)
        end
    end
end



return Game
