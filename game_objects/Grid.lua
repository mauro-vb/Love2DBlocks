local GridCell = require "game_objects.GridCell"
local metatable_functions = require "metatable_functions"

local Grid = {}
Grid.__index = Grid
Grid.__tostring = function(self)
    local output = {"\n"}
    for y = 1, self.height do
        local row = {}
        for x = 1, self.width do
            local cell = self:get(x, y)
            if not cell.active then
                table.insert(row, " ")
            elseif #cell.occupants ~= 0 then
                table.insert(row, "■")
            else
                table.insert(row, "x")
            end
        end
        table.insert(output, table.concat(row, " "))
    end
    table.insert(output, "\n")
    return table.concat(output, "\n")
end


function Grid.new(width, height)
    local self = setmetatable({}, Grid)
    self.width = width
    self.height = height
    
    self.cells = {}
    for x = 1, width do
        self.cells[x] = {}
        for y = 1, height do
            self.cells[x][y] = GridCell.new(x, y)
        end
    end
    return self
end

function Grid:is_within_bounds(x, y)
    return x >= 1 and x <= self.width and y >= 1 and y <= self.height
end

function Grid:get(x, y)
    if self:is_within_bounds(x, y) then
        return self.cells[x][y]
    end
end


function Grid:draw(cellSize, spacing)
    love.graphics.setColor(.7,.7,.8)
    for x = 1, self.width do
        for y = 1, self.height do
            local cell = self:get(x, y)
            local drawX = (x - 1) * (cellSize + spacing)
            local drawY = (y - 1) * (cellSize + spacing)

            cell:draw(drawX, drawY, cellSize)
        end
    end
end

return Grid