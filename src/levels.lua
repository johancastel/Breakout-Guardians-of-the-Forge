-- levels.lua
-- 0 = vacío, 1 = normal (Brick), 2 = resistente (StrongBrick), 3 = indestructible (UnbreakableBrick)
return {
    { -- Nivel 1
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1},
        {0, 1, 1, 3, 3, 1, 1, 3, 3, 1, 1, 0}
    },
    { -- Nivel 2
        {2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1},
        {1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2},
        {3, 3, 0, 0, 3, 3, 3, 3, 0, 0, 3, 3}
    }
}
