-- states/play.lua
local Game = require("src/game")
local Collision = require("src/collision")
local PowerUp = require("src/powerup")
local Levels = require("src/levels")

return {
    update = function(dt)
        -- 1. Actualizar paleta y bola
        Game.paddle:update(dt)
        Game.ball:update(dt)

        -- 2. Colisiones de la bola con los bordes de la pantalla
        -- Bordes laterales
        if Game.ball.x < 0 then
            Game.ball.x = 0
            Game.ball.vx = -Game.ball.vx
        elseif Game.ball.x + Game.ball.w > 800 then
            Game.ball.x = 800 - Game.ball.w
            Game.ball.vx = -Game.ball.vx
        end

        -- Borde superior
        if Game.ball.y < 0 then
            Game.ball.y = 0
            Game.ball.vy = -Game.ball.vy
        end

        -- Caída por el borde inferior (pérdida de vida)
        if Game.ball.y > 600 then
            Game.lives = Game.lives - 1
            if Game.lives <= 0 then
                Game.sm:switch("gameover")
            else
                -- Regresar a modo de saque
                Game.sm:switch("serve")
            end
            return
        end

        -- 3. Colisión bola con paleta
        if Collision.aabb(Game.ball, Game.paddle) then
            Game.ball:bounceOnPaddle(Game.paddle)
        end

        -- 4. Colisiones bola con bloques
        for _, b in ipairs(Game.level_obj.bricks) do
            if not b._dead and Collision.aabb(Game.ball, b) then
                Collision.resolveBallBrick(Game.ball, b)
                local points = b:onHit()
                Game.score = Game.score + points
                
                -- Spawnear power-up con probabilidad del 15% (solo si el ladrillo murió)
                if b._dead and math.random() < 0.15 then
                    local p = PowerUp.new(
                        b.x + b.w / 2 - 8,
                        b.y + b.h / 2 - 8,
                        function()
                            -- Efecto: ensanchar la paleta temporalmente
                            Game.paddle.w = math.min(180, Game.paddle.w * 1.3)
                        end
                    )
                    table.insert(Game.powerups, p)
                end
                break -- resolver una colisión por frame para evitar bugs físicos
            end
        end

        -- 5. Actualizar y recoger Power-ups
        for i = #Game.powerups, 1, -1 do
            local p = Game.powerups[i]
            p:update(dt)
            
            if not p._dead and Collision.aabb(p, Game.paddle) then
                p.efecto() -- aplicar efecto callback
                p._dead = true
            end
            
            if p._dead then
                table.remove(Game.powerups, i)
            end
        end

        -- 6. Comprobación de nivel completado
        if Game.level_obj:isCleared() then
            if Game.level < #Levels then
                Game.level = Game.level + 1
                Game.level_obj = nil -- forzar carga de siguiente nivel
                Game.sm:switch("serve")
            else
                Game.sm:switch("victory")
            end
        end
    end,

    draw = function()
        -- Dibujar todos los objetos del juego
        Game.level_obj:draw()
        Game.paddle:draw()
        Game.ball:draw()
        
        for _, p in ipairs(Game.powerups) do
            p:draw()
        end

        -- HUD superior
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Nivel: " .. Game.level .. "  Vidas: " .. Game.lives .. "  Puntaje: " .. Game.score, 20, 20)
    end,

    keypressed = function(key)
        if key == "escape" then
            Game.sm:switch("pause")
        end
    end
}
