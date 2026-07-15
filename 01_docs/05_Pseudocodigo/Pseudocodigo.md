# Pseudocódigo del Game Loop Principal

## Algoritmo General: Breakout - Guardians of the Forge

```text
INICIO

    // 1. Inicialización e Instanciación de Objetos
    game = Game:new()
    game:load()

    Establecer estado inicial: game.currentState = "TITLE"

    // 2. Ciclo Principal del Juego (Game Loop)
    Mientras game.isRunning == verdadero hacer

        // --- FASE 1: LEER ENTRADA (INPUT) ---
        input = LeerEntradaTeclado()

        // --- FASE 2: ACTUALIZAR ESTADO (UPDATE) ---
        // Se calcula el tiempo transcurrido desde el último frame (Delta Time)
        dt = ObtenerDeltaTime()

        Según game.currentState hacer

            "TITLE"
                Si input.enter == presionado entonces
                    game:changeState("LOADING_LEVEL")
                Fin Si

            "LOADING_LEVEL"
                level = Level:new()
                level:loadLevel(game.currentLevel)
                
                paddle = Paddle:new()
                ball = Ball:new()
                ball:reset()
                
                ui = UI:new()
                ui:updateLives(game.lives)
                ui:updateScore(0)
                
                game:changeState("PLAY")

            "PLAY"
                // Entrada del jugador para mover la paleta
                Si input.flecha_izquierda == presionado entonces
                    paddle:moveLeft()
                Sino Si input.flecha_derecha == presionado entonces
                    paddle:moveRight()
                Fin Si

                // Actualizaciones físicas con Delta Time (dt)
                paddle:update(dt)
                ball:move()
                ball:update(dt)
                level:update(dt)

                // Detección y resolución de colisiones
                Si DetectarColision(ball, paddle) entonces
                    ball:bounce()
                    sonido_rebote:play()
                Fin Si

                Para cada bloque en level.bricks hacer
                    Si DetectarColision(ball, bloque) entonces
                        bloque:hit()
                        ball:bounce()
                        Si bloque.health == 0 entonces
                            bloque:destroy()
                            ui:updateScore(100)
                            Si bloque.containsPower == verdadero entonces
                                powerup = PowerUp:new()
                                powerup:spawn(bloque.x, bloque.y, "fireball")
                            Fin Si
                        Fin Si
                    Fin Si
                Fin Para

                // Comprobación de poder activo
                Si powerup != nulo y powerup.isActive entonces
                    powerup:update(dt)
                    Si DetectarColision(powerup, paddle) entonces
                        paddle:catchPower(powerup.type)
                        powerup:apply(ball) // o paddle
                    Fin Si
                Fin Si

                // Control de vidas y derrota
                Si ball.y > Pantalla.alto entonces
                    game.lives = game.lives - 1
                    ui:updateLives(game.lives)
                    Si game.lives == 0 entonces
                        game:changeState("GAME_OVER")
                    Sino
                        ball:reset()
                    Fin Si
                Fin Si

                // Control de victoria de nivel
                Si level:isCompleted() entonces
                    game:changeState("LEVEL_COMPLETE")
                Fin Si

                // Transición a pausa
                Si input.escape == presionado entonces
                    game:changeState("PAUSE")
                Fin Si

            "PAUSE"
                Si input.tecla_c == presionado entonces
                    game:changeState("PLAY") // Resume
                Sino Si input.tecla_s == presionado entonces
                    game.isRunning = falso  // Salir
                Fin Si

            "LEVEL_COMPLETE"
                game:nextLevel()
                Si game.currentLevel <= MAX_NIVELES entonces
                    game:changeState("LOADING_LEVEL")
                Sino
                    game:changeState("TITLE")
                Fin Si

            "GAME_OVER"
                Si input.enter == presionado entonces
                    game:restartGame()
                    game:changeState("TITLE")
                Sino Si input.tecla_s == presionado entonces
                    game.isRunning = falso
                Fin Si

        Fin Según

        // --- FASE 3: DIBUJAR PANTALLA (RENDER) ---
        LimpiarPantalla()

        Según game.currentState hacer

            "TITLE"
                DibujarPantallaTitulo()

            "LOADING_LEVEL"
                DibujarMensajeCarga()

            "PLAY"
                level:draw()
                paddle:draw()
                ball:draw()
                Si powerup != nulo y powerup.isActive entonces
                    powerup:draw()
                Fin Si
                ui:drawHUD()

            "PAUSE"
                level:draw()
                paddle:draw()
                ball:draw()
                ui:drawHUD()
                DibujarMenuPausa()

            "LEVEL_COMPLETE"
                ui:drawHUD()
                DibujarMensajeVictoriaNivel()

            "GAME_OVER"
                DibujarPantallaGameOver()

        Fin Según

        MostrarEnPantalla()

    Fin Mientras

FIN
```