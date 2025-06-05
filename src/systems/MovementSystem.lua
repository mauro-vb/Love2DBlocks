local utils = require "game.utils"
local config = require "game.config"

local MovementSystem = Concord.system({
    blocks = {"blockShape", "position", "movable", "collidable"}
})

function MovementSystem:init(world)
    self.grid = world.grid or {}
    self.selectedBlock = nil
    self.dragStartX = nil
    self.dragStartY = nil
end

-- Input handling
function MovementSystem:mousepressed(x, y, button)
    if button ~= 1 then return end

    local gx, gy = utils.screenToGrid(x, y)

    for _, block in ipairs(self.blocks) do
        for _, pos in ipairs(block.blockShape:getPositions(block.position)) do
            if pos.x == gx and pos.y == gy then
                self.selectedBlock = block
                self.dragStartX = x
                self.dragStartY = y
                return
            end
        end
    end
end

function MovementSystem:mousereleased(x, y, button)
    if button == 1 then
        self.selectedBlock = nil
        self.dragStartX = nil
        self.dragStartY = nil
    end
end

function MovementSystem:mousemoved(x, y, dx, dy)
    if not (self.selectedBlock and self.dragStartX and self.dragStartY) then return end

    local totalDX = x - self.dragStartX
    local totalDY = y - self.dragStartY
    local moveX, moveY = 0, 0
    local threshold = config.cellSize * config.dragThreshold

    if math.abs(totalDX) > threshold then
        moveX = totalDX > 0 and 1 or -1
        self.dragStartX = x
    end

    if math.abs(totalDY) > threshold then
        moveY = totalDY > 0 and 1 or -1
        self.dragStartY = y
    end

    if moveX ~= 0 or moveY ~= 0 then
        self.selectedBlock:give("moveIntent", moveX, moveY)
    end
end

function MovementSystem:can_move(block, dx, dy)
    for _, pos in ipairs(block.blockShape:getPositions(block.position)) do
        local x, y = pos.x + dx, pos.y + dy
        for _, other_block in ipairs(self.blocks) do
            if other_block ~= block and other_block.collidable.active and other_block.blockShape:isOn(other_block.position, {x=x, y=y}) then
                return false
            end
        end

        local cell = self.grid:get(x, y)

        if not cell or cell.collidable.active then
            return false
        end
    end
    return true
end

function MovementSystem:update(dt)
    for _, block in ipairs(self.blocks) do
        if block:has("moveIntent") then
            local move = block.moveIntent
            local dx = block.movable.allowedDirections.horizontal and move.dx or 0
            local dy = block.movable.allowedDirections.vertical and move.dy or 0

            if dx ~= 0 or dy ~= 0 then
                
                if self:can_move(block, dx, dy) then
                    -- Apply the move
                    block.position.x = block.position.x + dx
                    block.position.y = block.position.y + dy

                    -- -- Call onPlacement effects, if any
                    -- local effects = block.blockEffects and block.blockEffects.effects or {}
                    -- for _, effect in ipairs(effects) do
                    --     if effect.onPlacement then
                    --         effect:onPlacement(block, dx, dy)
                    --     end
                    -- end
                end

                -- Clear movement intent
                move.dx = 0
                move.dy = 0
            end
        end
       
    end
end

return MovementSystem
