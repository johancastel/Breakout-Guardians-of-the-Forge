-- level.lua
local Brick = require("src/brick")
local StrongBrick = require("src/strongbrick")
local UnbreakableBrick = require("src/unbreakablebrick")

local Level = {}
Level.__index = Level

function Level.new()
    return setmetatable({ bricks = {} }, Level)
end

function Level:load(layout)
    self.bricks = {}
    local startX = 90
    local startY = 60
    for row, cols in ipairs(layout) do
        for col, code in ipairs(cols) do
            local x = startX + (col - 1) * 52
            local y = startY + (row - 1) * 24
            if code == 1 then
                table.insert(self.bricks, Brick.new(x, y))
            elseif code == 2 then
                table.insert(self.bricks, StrongBrick.new(x, y))
            elseif code == 3 then
                table.insert(self.bricks, UnbreakableBrick.new(x, y))
            end
        end
    end
end

function Level:draw()
    for _, b in ipairs(self.bricks) do
        b:draw()
    end
end

function Level:isCleared()
    for _, b in ipairs(self.bricks) do
        -- Si queda algún bloque vivo que no sea indestructible, el nivel no está limpio.
        if not b._dead and getmetatable(b) ~= UnbreakableBrick then
            return false
        end
    end
    return true
end

return Level
