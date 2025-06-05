local component = Concord.component("blockShape", function(c, offsets)
    c.offsets = offsets or {}
end)

function component:getPositions(origin)
    local positions = {}
    for _, offset in ipairs(self.offsets) do
        table.insert(positions, {
            x = origin.x + offset.x,
            y = origin.y + offset.y
        })
    end
    return positions
end

function component:isOn(origin, position)
    for _, pos in ipairs(self:getPositions(origin)) do
        if pos.x == position.x and pos.y == position.y then return true end
    end
    return false
end

return component
