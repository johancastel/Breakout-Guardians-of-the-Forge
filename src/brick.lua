-- brick.lua · clase base
local Brick = {}
Brick.__index = Brick

function Brick.new(x, y)
    return setmetatable({ x = x, y = y, w = 48, h = 20, _dead = false }, Brick)
end

function Brick:onHit() -- comportamiento por defecto
    self._dead = true
    return 10 -- puntos que otorga
end

function Brick:draw()
    if self._dead then return end
    love.graphics.setColor(0.9, 0.35, 0.35)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    
    -- Dibujar borde para diferenciar los bloques
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Brick
