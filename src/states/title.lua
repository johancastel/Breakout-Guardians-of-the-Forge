-- states/title.lua
local Game = require("src/game")

return {
    draw = function()
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("BREAKOUT: GUARDIANS OF THE FORGE", 0, 220, 800, "center")
        love.graphics.printf("ENTER para jugar", 0, 280, 800, "center")
        
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.printf("Controles: A / D o Flechas para mover. Esc para Pausa.", 0, 400, 800, "center")
    end,
    keypressed = function(key)
        if key == "return" then
            -- Reiniciar estadísticas de juego nuevo
            Game.score = 0
            Game.lives = 3
            Game.level = 1
            Game.powerups = {}
            Game.sm:switch("serve")
        end
    end
}
