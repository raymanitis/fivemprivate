Config = Config or {}
Config.blipsShow = true

Config.Locations = {
    -- [1] = {
    --     vector = vector3(326.0616, -211.7413, 54.0863),
    --     text = "Pink Cage Motel",
    --     color = 17,
    --     sprite = 475,
    --     scale = 0.7,
    -- },
    -- [2] = {
    --     vector = vector3(-1319.7123, -924.8551, 11.1884),
    --     text = "Beach Motel",
    --     color = 17,
    --     sprite = 475,
    --     scale = 0.7,
    -- },
    -- [3] = {
    --     vector = vector3(563.5524, -1766.6329, 29.1466),
    --     text = "Bilingsgate Motel",
    --     color = 17,
    --     sprite = 475,
    --     scale = 0.7,
    -- },

    -- [4] = {
    --     vector = vector3(170.6967, -730.0757, 33.1332),
    --     text = "Vehicle Rental",
    --     color = 38, -- Changed color (example: 38 = light blue)
    --     sprite = 326, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [5] = {
    --     vector = vector3(-1038.3812, -2730.2063, 20.1693),
    --     text = "Vehicle Rental",
    --     color = 38, -- Changed color (example: 38 = light blue)
    --     sprite = 326, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [4] = {
    --     vector = vector3(1852.4259, 2582.4258, 45.6727),
    --     text = "Vehicle Rental",
    --     color = 38, -- Changed color (example: 38 = light blue)
    --     sprite = 326, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [5] = {
    --     vector = vector3(-1826.3263, -1190.4069, 20.1182),
    --     text = "Pearl Restaurant",
    --     color = 67, -- Changed color (example: 38 = light blue)
    --     sprite = 751, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [6] = {
    --     vector = vector3(-1187.7891, -891.3983, 17.9691),
    --     text = "Burger Shot",
    --     color = 81, -- Changed color (example: 38 = light blue)
    --     sprite = 835, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [7] = {
    --     vector = vector3(-556.7430, 274.4943, 83.019),
    --     text = "Tequila La La",
    --     color = 5, -- Changed color (example: 38 = light blue)
    --     sprite = 197, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [8] = {
    --     vector = vector3(294.6643, -963.9695, 29.4183),
    --     text = "The Kebab House",
    --     color = 6, -- Changed color (example: 38 = light blue)
    --     sprite = 833, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.85,
    -- },

    -- [9] = {
    --     vector = vector3(-1388.3422, -587.0659, 30.2185),
    --     text = "Bahama Mamas",
    --     color = 7, -- Changed color (example: 38 = light blue)
    --     sprite = 304, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },
    -- [10] = {
    --     vector = vector3(-1259.1707, -1440.3453, 4.3501),
    --     text = "Marketplace",
    --     color = 5, -- Changed color (example: 38 = light blue)
    --     sprite = 59, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.8,
    -- },

    -- [11] = {
    --     vector = vector3(24.9519, -420.7652, 39.3394),
    --     text = "Vehicle Rental",
    --     color = 38, -- Changed color (example: 38 = light blue)
    --     sprite = 326, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [12] = {
    --     vector = vector3(126.4782, -1346.5406, 33.8852),
    --     text = "Cash Exchange",
    --     color = 52, -- Changed color (example: 38 = light blue)
    --     sprite = 89, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.85,
    -- },

    -- [13] = {
    --     vector = vector3(-1345.4410, -1064.7418, 7.3907),
    --     text = "City Sushi",
    --     color = 9, -- Changed color (example: 38 = light blue)
    --     sprite = 93, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.85,
    -- },

    -- [15] = {
    --     vector = vector3(997.8538, -1843.4720, 31.0429),
    --     text = "Warehouse",
    --     color = 18, -- Changed color (example: 38 = light blue)
    --     sprite = 473, -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },
    --[12] = {
    --    vector = vector3(312.0, -588.0, 43.3),
    --    text = "Hospital",
    --    color = 1, -- Changed color (example: 38 = light blue)
    --    sprite = 61, -- Changed sprite (example: 326 = car icon)
    --    scale = 0.95,
    --},

    -- [10] = { 
    --     vector = vector3(-1088.0260, -1274.2404, 8.4840),
    --     text = "Plama Game",
    --     color = 5,      -- Changed color (example: 38 = light blue)
    --     sprite = 197,    -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },

    -- [7] = {
    --     vector = vector3(1852.4259, 2582.4258, 45.6727),
    --     text = "Vehicle Rental",
    --     color = 38,      -- Changed color (example: 38 = light blue)
    --     sprite = 326,    -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,               -1088.0260, -1274.2404, 8.4840, 10.8253
    -- },

    -- [8] = {
    --     vector = vector3(1852.4259, 2582.4258, 45.6727),
    --     text = "Vehicle Rental",
    --     color = 38,      -- Changed color (example: 38 = light blue)
    --     sprite = 326,    -- Changed sprite (example: 326 = car icon)
    --     scale = 0.7,
    -- },
    -- Example
    -- [[
    -- [4] = {
    --     vector = vector3(0, 0, 0),
    --     text = "Blip Name",
    --     color = 3,
    --     sprite = Blip ID,
    --     scale = size,
    -- }, ]]

    --- add more
}

return Config