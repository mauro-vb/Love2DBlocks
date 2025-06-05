local component = Concord.component("movable", function(c, allowedDirections)
    c.allowedDirections = allowedDirections or { horizontal = true, vertical = true }
end)

return component
