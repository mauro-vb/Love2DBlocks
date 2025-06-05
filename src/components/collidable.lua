local component = Concord.component("collidable", function(c, active)
    c.active = active == nil and true or active
end)

return component