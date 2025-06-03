local IgnorableBlockEffect = {}

function IgnorableBlockEffect:apply(block)
    block.collidable = false
end

function IgnorableBlockEffect:remove(block)
    block.collidable = true
    block:remove_effect(self)
end

function IgnorableBlockEffect:onPlacement(block, dx, dy)
    dx, dy = dx or 0, dy or 0
    if dx==0 and dy==0 then
        return
    end
    for _, pos in ipairs(block.positions) do
        
        local neighbor_cell = block.grid:get(pos.x + dx, pos.y + dy)
        if neighbor_cell and not neighbor_cell:has_collidable() then--not neighbor_cell:has_other_collidable(block) then
            if not neighbor_cell:has_occupant(block) then
                neighbor_cell.active = false
            end
        end
    end
end

function IgnorableBlockEffect:draw(x, y)
    love.graphics.setColor(0,0,.5)
    love.graphics.line(x, y, x + 15, y + 15)
end

--function IgnorableBlockEffect:modifyPlacement(block) end

return IgnorableBlockEffect