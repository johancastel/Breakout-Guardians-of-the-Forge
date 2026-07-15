-- states/pause.lua
local Game = require("src/game")

return {
    draw = function()
        -- Dibujar el fondo del juego estático
        Game.level_obj:draw()
        Game.paddle:draw()
        Game.ball:draw()
        for _, p in ipairs(Game.powerups) do
            p:draw()
        end
        
        -- Superposición semitransparente de pausa
        love.graphics.setColor(0, 0, 0, 0.65)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        
        -- Mensajes en pantalla
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("JUEGO EN PAUSA", 0, 240, 800, "center")
        love.graphics.printf("Presiona ESC o ENTER para continuar", 0, 300, 800, "center")
    end,
    
    keypressed = function(key)
        if key == "escape" or key == "return" then
            Game.sm:switch("play")
        end
    end
}
