local love = require "love"

local GridCell = {}
GridCell.__index = GridCell

function GridCell.new(x, y, opts)
    opts = opts or {}
    local self = setmetatable({}, GridCell)
    

    self.x = x
    self.y = y
    self.active = opts.active or true
    self.occupant = opts.occupant or nil
    self.effect = opts.effect or {}
    return self
end


function GridCell:draw(x, y, size)
    if self.active then
        love.graphics.rectangle("fill", x, y, size, size)
    end
end

return GridCell