local DrawSystem = Concord.system({
    blocks = {"blockShape","drawable"}
})

function DrawSystem:init(world)
    self.grid = world.grid or {}
end

function DrawSystem:draw()
    self.grid:draw()
    for _, block in ipairs(self.blocks) do
        for _, pos in ipairs(block.blockShape:getPositions(block.position)) do
            local drawX = (pos.x - 1) * self.grid.cellSize
            local drawY = (pos.y -1) * self.grid.cellSize
            love.graphics.setColor(block.drawable.color,drawX, drawY)
            love.graphics.rectangle("fill", drawX, drawY, self.grid.cellSize, self.grid.cellSize)
        end
    end
end

return DrawSystem