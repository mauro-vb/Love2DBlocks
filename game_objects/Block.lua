local tween = require "libraries.tween"
local config = require "game.config"

local Block =  {}
Block.__index = Block

function Block.new(positions, grid, opts)
    opts = opts or {}
    local self = setmetatable({}, Block) 
    

    self.positions = positions or {}
    self.allowedDirections = opts.allowedDirections or {horizontal=true, vertical=true}
    self.effects = opts.effects or {}
    self.grid = grid or nil
    self.collidable = opts.collidable ~= nil and opts.collidable or true
    self.tweens = {}
    if self.grid then
        self:place_on_grid()
    end

    for _, effect in ipairs(self.effects) do
        effect:apply(self)
    end
    for _, pos in ipairs(self.positions) do
        pos.drawX = (pos.x - 1) * (config.cellSize + config.cellSpacing)
        pos.drawY = (pos.y - 1) * (config.cellSize + config.cellSpacing)
    end

    return self
end

function Block:place_on_grid(dx, dy)
    for i, pos in ipairs(self.positions) do
        local cell = self.grid:get(pos.x, pos.y)
        if cell then
            cell:block_entered({ block = self, dx = dx, dy = dy })
        end
    end
    -- check for onPlacement
    for _, effect in ipairs(self.effects) do
        if effect.onPlacement then
            effect:onPlacement(self, dx, dy)
        end
    end
end

function Block:clear_from_grid(dx, dy)
    for i, pos in ipairs(self.positions) do
        local cell = self.grid:get(pos.x, pos.y)
        if cell then
            cell:block_exited({ block = self, dx = dx, dy = dy })
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

function Block:can_move(dx, dy)
    -- Look for modifyCanMove
    for _, effect in ipairs(self.effects) do
        if effect.modifyCanMove then
            return effect:modifyCanMove(dx, dy)
        end
    end
    -- Default check
    for _, pos in ipairs(self.positions) do
        local x, y = pos.x + dx, pos.y + dy
        local cell = self.grid:get(x, y)
        
        if not cell or not cell.active then
            return false
        end

        if cell:has_other_collidable(self) then
            return false
        end
    end
    return true
end

function Block:move(dx, dy)
    dx = self.allowedDirections.horizontal and dx or 0
    dy = self.allowedDirections.vertical and dy or 0

    if self:can_move(dx, dy) then
        self:clear_from_grid(dx, dy)
        for i, pos in ipairs(self.positions) do
            pos.x = pos.x + dx
            pos.y = pos.y + dy

            local targetDrawX = (pos.x - 1) * (config.cellSize + config.cellSpacing)
            local targetDrawY = (pos.y - 1) * (config.cellSize + config.cellSpacing)
            local tweenX = tween.new(0.075, pos, { drawX = targetDrawX }, tween.easing.inOutCirc)
            local tweenY = tween.new(0.075, pos, { drawY = targetDrawY }, tween.easing.inOutCirc)
            table.insert(self.tweens, tweenX)
            table.insert(self.tweens, tweenY)
        end
        self:place_on_grid(dx, dy)
    end
end


function Block:get_mask()
    local minX, minY = math.huge, math.huge
    for _, pos in ipairs(self.positions) do
        if pos.x < minX then minX = pos.x end
        if pos.y < minY then minY = pos.y end
    end

    local mask = {}
    for _, pos in ipairs(self.positions) do
        local relX = pos.x - minX + 1
        local relY = pos.y - minY + 1
        mask[relY] = mask[relY] or {}
        mask[relY][relX] = true
    end

    return mask, minX, minY
end

function Block:remove_effect(effect)
    for i = #self.effects, 1, -1 do
        if self.effects[i] == effect then
            table.remove(self.effects, i)
        end
    end
end


function Block:update(dt)
    for i = #self.tweens, 1, -1 do
        local tween = self.tweens[i]
        local complete = tween:update(dt)
        if complete then
            table.remove(self.tweens, i)
        end
    end
end



function Block:draw(cellSize, spacing)
    for _, pos in ipairs(self.positions) do
        love.graphics.setColor(1, 0, 0, .45)
        love.graphics.rectangle("fill", pos.drawX, pos.drawY, cellSize, cellSize)

        for _, effect in ipairs(self.effects) do
            effect:draw(pos.drawX, pos.drawY)
        end
    end
end


return Block