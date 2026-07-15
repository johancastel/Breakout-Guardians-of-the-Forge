-- strongbrick.lua · POLIMORFISMO: aguantar 2 golpes
local Brick = require("src/brick")

local StrongBrick = setmetatable({}, { __index = Brick })
StrongBrick.__index = StrongBrick

function StrongBrick.new(x, y)
    local self = Brick.new(x, y) -- 1) llama al constructor del padre
    self._hp = 2                 -- vida extra
    return setmetatable(self, StrongBrick) -- 2) re-etiqueta como StrongBrick
end

function StrongBrick:onHit() -- misma firma, otra conducta
    self._hp = self._hp - 1
    if self._hp <= 0 then 
        self._dead = true 
        return 20 -- otorga más puntos al destruirse
    end
    return 10 -- otorga puntos en cada impacto
end

return StrongBrick
