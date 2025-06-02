local ClearBlockEffectsEffect = {}

function ClearBlockEffectsEffect:trigger(block)
    for _, effect in ipairs(block.effects) do
        effect:remove(block)
    end
end
function ClearBlockEffectsEffect:draw(block) end

return ClearBlockEffectsEffect