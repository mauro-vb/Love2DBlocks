local BlockEffect = {}

function BlockEffect:apply(block) end
function BlockEffect:remove(block) end
function BlockEffect:modifyPlacement(block) end
function BlockEffect:modifyCanMove(block, dx, dy) return dx, dy end
function BlockEffect:draw(x, y) end

return BlockEffect