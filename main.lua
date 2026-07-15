if os.getenv("LOVE2D_TOOLS") then pcall(require, "_love2d_tools_bridge") end
-- main.lua · el cableado
local StateMachine = require("src/statemachine")
local Game = require("src/game")

function love.load()
    -- Semilla aleatoria
    math.randomseed(os.time())
    
    -- Configuración de la máquina de estados
    Game.sm = StateMachine.new({
        title = require("src/states/title"),
        serve = require("src/states/serve"),
        play = require("src/states/play"),
        pause = require("src/states/pause"),
        gameover = require("src/states/gameover"),
        victory = require("src/states/victory"),
    })
    Game.sm:switch("title")
end

function love.update(dt) 
    Game.sm:update(dt) 
end

function love.draw() 
    Game.sm:draw() 
end

function love.keypressed(k) 
    Game.sm:keypressed(k) 
end