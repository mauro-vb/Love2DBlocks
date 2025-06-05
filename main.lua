local love = require "love"
local Gamestate = require 'libs.gamestate'

Concord = require 'libs.concord'

local game = require "src.states.game"
love.graphics.setDefaultFilter('nearest', 'nearest')
love.window.setMode(800, 600, {resizable=true})

ECS = {
  c = Concord.components,
  a = {},
  s = {}
}

Concord.utils.loadNamespace("src/components")
Concord.utils.loadNamespace("src/systems", ECS.s)

Gamestate.registerEvents()
Gamestate.switch(game)