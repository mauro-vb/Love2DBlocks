local Block =  {}
Block.__index = Block

function Block.new(positions, opts)
    opts = opts or {}
    local self = setmetatable({}, Block) 
    

    self.positions = positions or {}
    self.allowedDirections = opts.allowedDirections or {horizontal=true, vertical=true}
    self.effects = opts.effects or {}
    self.grid = opts.grid or nil
    if self.grid then
        self:place_on(self.grid)
    end
    return self
end

function Block:place_on(grid)
    self.grid = grid
    for _, pos in ipairs(self.positions) do
        local cell = grid:get(pos.x, pos.y)
        if cell then
            cell.occupant = self
        end
    end
end

function Block:clear_from(grid)
    for _, pos in ipairs(self.positions) do
        local cell = grid:get(pos.x, pos.y)
        if cell and cell.occupant == self then
            cell.occupant = nil
        end
    end
end

function Block:is_on(x, y)
    for _, pos in ipairs(self.positions) do
        if pos.x == x and pos.y == y then
            return true
        end
    end
    return false
end

function Block:can_move(grid, dx, dy)
    -- Look for modifyCanMove
    for _, effect in ipairs(self.effects) do
        if effect.modifyCanMove then
            return effect:modifyCanMove(grid, dx, dy)
        end
    end
    -- Default check
    for _, pos in ipairs(self.positions) do
        local x, y = pos.x + dx, pos.y + dy
        local cell = grid:get(x, y)
        if not cell or not cell.active or cell.occupant then
            return false
        end
    end
    return true
end

function Block:move(grid, dx, dy)
    dx = self.allowedDirections.horizontal and dx or 0
    dy = self.allowedDirections.vertical and dy or 0
    self:clear_from(grid)
    if self:can_move(grid, dx, dy) then
        for _, pos in ipairs(self.positions) do
            pos.x = pos.x + dx
            pos.y = pos.y + dy
        end
    end
    self:place_on(grid)
end

function Block:draw(cellSize, spacing)
    love.graphics.setColor(1, 0, 0)

    for _, pos in ipairs(self.positions) do
        local drawX = (pos.x - 1) * (cellSize + spacing)
        local drawY = (pos.y - 1) * (cellSize + spacing)
        love.graphics.rectangle("fill", drawX, drawY, cellSize, cellSize)
    end
end

return Block