local love = require "love"

local GridCell = {}
GridCell.__index = GridCell

function GridCell.new(x, y, opts)
    opts = opts or {}
    local self = setmetatable({}, GridCell)
    

    self.x = x
    self.y = y
    self.active = opts.active or true
    self.occupants = opts.occupants or {}
    self.effects = opts.effects or {}
    return self
end

function GridCell:trigger_effects(block)
    for _, effect in ipairs(self.effects) do
        print(effect)
        effect:trigger(block)
    end
end

function GridCell:remove_occupant(occupant)
    for i = #self.occupants, 1, -1 do
        if self.occupants[i] == occupant then
            table.remove(self.occupants, i)
        end
    end
end

function GridCell:block_entered(info)
    table.insert(self.occupants, info.block)
    self:trigger_effects(info.block)
end

function GridCell:block_exited(info)
    self:remove_occupant(info.block)
    --print("block exited")
end

function GridCell:draw(x, y, size)
    if self.active then
        love.graphics.rectangle("fill", x, y, size, size)
    end
end

return GridCell