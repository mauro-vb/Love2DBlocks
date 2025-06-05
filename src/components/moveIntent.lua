local component = Concord.component("moveIntent", function(c, dx, dy)
    c.dx = dx or 0
    c.dy = dy or 0
end)

return component