-- states/victory.lua
local Game = require("src/game")

return {
    draw = function()
        love.graphics.setColor(0.2, 0.9, 0.2)
        love.graphics.printf("¡VICTORIA! HAS LIBERADO LA FORJA", 0, 200, 800, "center")
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Puntaje Final: " .. Game.score, 0, 260, 800, "center")
        love.graphics.printf("Presiona 'R' para volver al inicio", 0, 320, 800, "center")
    end,
    
    keypressed = function(key)
        if key == "r" or key == "return" then
            -- Limpiar referencias para reiniciar
            Game.paddle = nil
            Game.ball = nil
            Game.level_obj = nil
            Game.sm:switch("title")
        end
    end
}
