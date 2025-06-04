local IgnorableBlockEffect = {}

function IgnorableBlockEffect:apply(block)
    block.collidable = false
end

function IgnorableBlockEffect:remove(block)
    block.collidable = true
    block:remove_effect(self)
end

function IgnorableBlockEffect:draw(x, y)
    love.graphics.setColor(0,0,.5)
    love.graphics.line(x, y, x + 15, y + 15)
end

return IgnorableBlockEffect