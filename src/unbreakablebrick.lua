-- unbreakablebrick.lua
local Brick = require("src/brick")

local UnbreakableBrick = setmetatable({}, { __index = Brick })
UnbreakableBrick.__index = UnbreakableBrick

function UnbreakableBrick.new(x, y)
    local self = Brick.new(x, y)
    return setmetatable(self, UnbreakableBrick)
end

function UnbreakableBrick:onHit()
    return 0 -- Indestructible: no recibe daño y no otorga puntos
end

function UnbreakableBrick:draw()
    if self._dead then return end
    love.graphics.setColor(0.5, 0.5, 0.5) -- Gris para bloques indestructibles
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return UnbreakableBrick
