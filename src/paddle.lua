-- paddle.lua
local Paddle = {}
Paddle.__index = Paddle

function Paddle.new(x, y)
    return setmetatable({
        x = x,
        y = y,
        w = 100,
        h = 16,
        speed = 500
    }, Paddle)
end

function Paddle:update(dt)
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
    
    -- Limitar el movimiento a los bordes de la pantalla (800 de ancho)
    if self.x < 0 then
        self.x = 0
    elseif self.x + self.w > 800 then
        self.x = 800 - self.w
    end
end

function Paddle:draw()
    love.graphics.setColor(0.35, 0.75, 0.35) -- Verde para la paleta (Forge Shield)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Paddle
