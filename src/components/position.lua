local component = Concord.component("position", function(c, x, y)
    c.x = x or 1
    c.y = y or 1
end)

return component