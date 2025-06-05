local utils = require "game.utils"
local config = require "game.config"
--local Gamestate = require 'libs.gamestate' -- For level switch maybe

local game = {}
local world = nil

Concord.utils.loadNamespace("src/components")


function game:enter()
  self.world = Concord.world()
  self.world.grid = utils.make_grid(world, 6, 6, 64)
  self.world:addSystems(
    ECS.s.DrawSystem,
    ECS.s.MovementSystem
    --ECS.s.MoveResolutionSystem,
    --ECS.s.CollisionSystem
  )

  local block1 = Concord.entity(self.world)
    :give("position", 3, 3)
    :give("blockShape", {{x=-1, y=0},{x=0, y=-1},{x=0, y=0}, {x=1, y=0}})
    :give("movable", {horizontal = true, vertical = true})
    :give("drawable", "rectangle", {1, 0, 0, 0.8})
    :give("collidable", true)
  local block2 = Concord.entity(self.world)
    :give("position", 3, 4)
    :give("blockShape", {{x=0, y=0}, {x=1, y=0}})
    :give("movable", {horizontal = true, vertical = false})
    :give("drawable", "rectangle", {1, 0, 0, 0.8})
    :give("collidable", true)

end

function game:update(dt)
  self.world:emit("update", dt)
end

function game:draw()
  self.world:emit("draw")
end

-- Centralized input forwarding
function game:mousepressed(x, y, button)
  self.world:emit("mousepressed", x, y, button)
end

function game:mousereleased(x, y, button)
  self.world:emit("mousereleased", x, y, button)
end

function game:mousemoved(x, y, dx, dy)
  self.world:emit("mousemoved", x, y, dx, dy)
end

return game
