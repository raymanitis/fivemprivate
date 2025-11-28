config = {}

-- target resource (only one of these can be true)
-------------------------------------------------------
config.qbtarget = false
config.oxtarget = true
-------------------------------------------------------


config.pedmodel = 'a_m_m_prolhost_01' -- ped model hash

config.scenario = 'WORLD_HUMAN_CLIPBOARD' -- scenario for ped to play, false to disable

config.locations = {
    ['legion'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(170.6967, -730.0757, 33.1332, 73.4145),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['panto']       = {
            --     price = 50, 
            --     image = 'hhttps://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/panto.png',
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bison.png',
            },
        },

        vehiclespawncoords = vector4(165.5100, -733.8829, 33.1334, 69.0521), -- where vehicle spawns when rented

    },

    ['lidosta'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(-1038.3812, -2730.2063, 20.1693, 182.5869),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['panto']        = {     -- vehicle model name
            --     price = 50,        -- ['vehicle'] = price
            --     image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bison.png',
            },

        },

        vehiclespawncoords = vector4(-1034.7604, -2728.6316, 20.1195, 240.2619), -- where vehicle spawns when rented

    },

    ['vagos'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(413.1587, -2074.4402, 21.3819, 45.3699),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['panto']        = {     -- vehicle model name
            --     price = 50,        -- ['vehicle'] = price
            --     image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bison.png',
            },

        },

        vehiclespawncoords = vector4(412.4859, -2065.9641, 21.4635, 140.9968), -- where vehicle spawns when rented

    },

    ['casino'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(898.6258, -3.3408, 78.9038, 153.4453),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['panto']        = {     -- vehicle model name
            --     price = 50,        -- ['vehicle'] = price
            --     image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bison.png',
            },

        },

        vehiclespawncoords = vector4(898.1673, -7.7601, 78.7641, 148.7935), -- where vehicle spawns when rented

    },

    ['raktuves'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(2943.5298, 2742.8467, 43.3587, 333.4012),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['panto']        = {     -- vehicle model name
            --     price = 50,        -- ['vehicle'] = price
            --     image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bison.png',
            },

        },

        vehiclespawncoords = vector4(2949.1829, 2747.9219, 43.4566, 285.1069), -- where vehicle spawns when rented

    },

    ['pier'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(-1539.7518, -970.4046, 13.0174, 141.2895),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['panto']        = {     -- vehicle model name
            --     price = 50,        -- ['vehicle'] = price
            --     image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150, 
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bison.png',
            },

        },

        vehiclespawncoords = vector4(-1540.3372, -976.9984, 13.0175, 139.7645), -- where vehicle spawns when rented

    },

    ['cietums'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(1852.4259, 2582.4258, 45.6727, 278.1112),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['asea']        = {     -- vehicle model name
            --     price = 50,        -- ['vehicle'] = price
            --     image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100,
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150,
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bison.png',
            },

        },

        vehiclespawncoords = vector4(1854.9558, 2578.7561, 45.6727, 274.6353), -- where vehicle spawns when rented

    },

    ['slimnica'] = {
        ped = true, -- if false uses boxzone (below)

        coords = vector4(24.9519, -420.7652, 39.3394, 201.4882),
        
        -------- boxzone (only used if ped is false) --------

        length = 1.0,  
        width = 1.0,   
        minZ = 30.81,  
        maxZ = 30.81,  
        debug = false, 

        -----------------------------------------------------
        vehicles = {
            -- ['asea']        = {     -- vehicle model name
            --     price = 50,        -- ['vehicle'] = price
            --     image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            -- },
            ['asea']        = {     -- vehicle model name
                price = 75,        -- ['vehicle'] = price
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',      -- image for menu, false for no image
            },
            ['sentinel']    = {
                price = 100,
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/sentinel.png',
            },
            ['bison']       = {
                price = 150,
                image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/asea.png',
            },

        },

        vehiclespawncoords = vector4(23.7902, -426.6794, 39.2777, 162.9189), -- where vehicle spawns when rented

    },


    -- add as many locations as you'd like with any type of vehicle (air, water, land) follow same format as above
}

