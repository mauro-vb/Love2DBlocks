local TileActivatingEffect = {}
TileActivatingEffect.__index = TileActivatingEffect

function TileActivatingEffect.new(mode, direction)
    local self = setmetatable({}, TileActivatingEffect)
    self.mode = mode or "toggle"
    self.direction = direction or "forward"
    return self
end

function TileActivatingEffect:onPlacement(block, dx, dy)
    dx, dy = dx or 0, dy or 0
    if dx == 0 and dy == 0 then return end

    local directions = {}

    if self.direction == "forward" then
        directions = { { dx, dy } }

    elseif self.direction == "backward" then
        directions = { { -dx, -dy } }

    elseif self.direction == "sides" then
        if dx == 0 then directions = {{-1,0},{1,0}} end
        if dy == 0 then directions = {{0,-1},{0,1}}  end
        -- directions = {
        --     { 0, -1 }, { 1, 0 }, { 0, 1 }, { -1, 0 }, -- cardinal
        --     { -1, -1 }, { 1, -1 }, { 1, 1 }, { -1, 1 } -- diagonals
        -- }

    else
        error("Unknown TileActivatingEffect direction: " .. tostring(self.direction))
    end

    for _, pos in ipairs(block.positions) do
        for _, dir in ipairs(directions) do
            local nx, ny = pos.x + dir[1], pos.y + dir[2]
            local neighbor_cell = block.grid:get(nx, ny)

            if neighbor_cell and not neighbor_cell:has_collidable() then
                if not neighbor_cell:has_occupant(block) then
                    if self.mode == "toggle" then
                        neighbor_cell.active = not neighbor_cell.active
                    else
                        neighbor_cell.active = self.mode == "activate" and true or false
                    end
                end
            end
        end
    end
end

return TileActivatingEffect
