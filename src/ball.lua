-- ball.lua
local Ball = {}
Ball.__index = Ball

function Ball.new(x, y)
    return setmetatable({
        x = x,
        y = y,
        w = 12,
        h = 12,
        vx = 0,
        vy = 0,
        maxVx = 350
    }, Ball)
end

function Ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Ball:draw()
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Ball:bounceOnPaddle(paddle)
    self.y = paddle.y - self.h        -- reubica la bola encima de la paleta
    self.vy = -math.abs(self.vy)      -- garantiza que salga hacia arriba
    
    local centroBola = self.x + self.w / 2
    local centroPaleta = paddle.x + paddle.w / 2
    local t = (centroBola - centroPaleta) / (paddle.w / 2) -- rango -1 .. +1
    
    self.vx = t * self.maxVx          -- el ángulo depende del punto de impacto
end

function Ball:reset(x, y)
    self.x = x
    self.y = y
    self.vx = 0
    self.vy = 0
end

return Ball
