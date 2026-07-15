-- states/serve.lua
local Game = require("src/game")
local Paddle = require("src/paddle")
local Ball = require("src/ball")
local Level = require("src/level")
local Levels = require("src/levels")

return {
    enter = function()
        -- Inicializar pala si no existe
        if not Game.paddle then
            Game.paddle = Paddle.new(350, 520)
        end
        
        -- Inicializar nivel si no existe
        if not Game.level_obj then
            Game.level_obj = Level.new()
            Game.level_obj:load(Levels[Game.level])
        end
        
        -- Colocar bola sobre la paleta
        if not Game.ball then
            Game.ball = Ball.new(0, 0)
        end
        Game.ball:reset(Game.paddle.x + Game.paddle.w / 2 - Game.ball.w / 2, Game.paddle.y - Game.ball.h)
        Game.powerups = {}
    end,
    
    update = function(dt)
        -- Permitir movimiento de la paleta antes de lanzar
        Game.paddle:update(dt)
        -- Alinear bola
        Game.ball.x = Game.paddle.x + Game.paddle.w / 2 - Game.ball.w / 2
        Game.ball.y = Game.paddle.y - Game.ball.h
    end,
    
    draw = function()
        -- Dibujar el estado actual
        Game.level_obj:draw()
        Game.paddle:draw()
        Game.ball:draw()
        
        -- HUD superior
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Nivel: " .. Game.level .. "  Vidas: " .. Game.lives .. "  Puntaje: " .. Game.score, 20, 20)
        love.graphics.printf("PRESIONA ESPACIO PARA LANZAR", 0, 320, 800, "center")
    end,
    
    keypressed = function(key)
        if key == "space" then
            -- Dar velocidad inicial y cambiar a juego activo
            Game.ball.vx = math.random(-80, 80)
            Game.ball.vy = -350
            Game.sm:switch("play")
        end
    end
}
