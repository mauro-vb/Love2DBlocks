local config = require("game.config")

local utils = {}

function utils.screenToGrid(x, y)
    local gx = math.floor(x / (config.cellSize + config.cellSpacing)) + 1
    local gy = math.floor(y / (config.cellSize + config.cellSpacing)) + 1
    return gx, gy
end

return utils 