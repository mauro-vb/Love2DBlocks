local config = require("game.config")
local utils = {}


function utils.make_grid(world, width, height, cellSize)
    local cells = {}

    for x = 1, width do
        cells[x] = {}
        for y = 1, height do
            local cell = Concord.entity(world)
                :give("position", x, y)
                :give("collidable", false)
            cells[x][y] = cell
        end
    end

    return {
        width = width,
        height = height,
        cells = cells,
        cellSize = cellSize,
        get = function(self, x, y)
            if x >= 1 and x <= self.width and y >= 1 and y <= self.height then
                return self.cells[x][y]
            end
        end,
        draw = function ()
            love.graphics.setColor(.8,.8,.8)
            for x = 1, width do
                for y = 1, height do
                    local px = (x-1) * cellSize
                    local py = (y-1) * cellSize
                    love.graphics.rectangle("line", px, py, cellSize, cellSize)
                end
            end
        end
    }
end

function utils.screenToGrid(x, y)
    local gx = math.floor(x / (config.cellSize + config.cellSpacing)) + 1
    local gy = math.floor(y / (config.cellSize + config.cellSpacing)) + 1
    return gx, gy
end

return utils 