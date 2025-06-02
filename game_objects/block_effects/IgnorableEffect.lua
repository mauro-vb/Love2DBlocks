local IgnorableEffect = {}

function IgnorableEffect:apply(block)
    block:clear_from()
end
function IgnorableEffect:remove(block) end


return IgnorableEffect