-- game.lua
-- Estado compartido del mundo y referencias a la máquina de estados y objetos
local Game = {
    score = 0,
    lives = 3,
    level = 1,
    sm = nil,
    paddle = nil,
    ball = nil,
    level_obj = nil,
    powerups = {}
}

return Game
