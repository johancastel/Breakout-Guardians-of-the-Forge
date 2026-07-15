-- powerup.lua
local PowerUp = {}
PowerUp.__index = PowerUp

function PowerUp.new(x, y, efecto)
    return setmetatable({ 
        x = x, 
        y = y, 
        w = 16, 
        h = 16, 
        vy = 120, 
        efecto = efecto,
        _dead = false
    }, PowerUp)
end

function PowerUp:update(dt)
    self.y = self.y + self.vy * dt
    -- Si se sale de la pantalla por abajo, se marca como muerto
    if self.y > 600 then
        self._dead = true
    end
end

function PowerUp:draw()
    if self._dead then return end
    love.graphics.setColor(0.9, 0.8, 0.2) -- Color dorado/amarillo
    love.graphics.circle("fill", self.x + self.w / 2, self.y + self.h / 2, self.w / 2)
    
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.circle("line", self.x + self.w / 2, self.y + self.h / 2, self.w / 2)
end

return PowerUp
