Config = {} -- NOTE: you can use command /convertProperties in game to convert properties from esx_tk_housing V1 / esx_tk_garage V1 to tk_housing V2

Config.DebugMode = false -- false / true
Config.Framework = 'qb' -- esx / qb
Config.NotificationType = 'ox' -- esx / qb / ox / mythic
Config.Locale = 'en' -- en / fi, you can translate the script in the locales folder
Config.Inventory = 'ox' -- default / qb_old / qb_new / ox / quasar
Config.Clothing = 'illenium' -- default / illenium
Config.HelpNotification = false -- false / true, use helpnotification instead of 3d text
Config.UseOxLib = true -- false / true, remember to add " shared_script '@ox_lib/init.lua' " to fxmanifest.lua if set to true
Config.UseOxTarget = true -- false / true

Config.UISettings = {
    color = 'blue',
    shade = 6,
}

Config.Controls = { -- https://docs.fivem.net/docs/game-references/controls/
    interact = 38, -- E
    takePhoto = 38, -- E
    cancelPhoto = 194, -- BACKSPACE
    furnish = {
        cancel = 194, -- BACKSPACE
        place = 38, -- E
        toggleFocus = 19, -- ALT
        toggleMode = 37, -- TAB
        remove = 178, -- DELETE
        toggleTracking = 137, -- CAPS LOCK
        rotateUp = 15, -- Scroll up
        rotateDown = 14, -- Scroll down
        rotatePrimary = 36, -- LCTRL
        rotateSecondary = 21, -- LSHIFT
    },
}
Config.CloseWithESC = true -- true / false, allow closing UI with ESC

Config.Dist = {
    house = 2,
    garage = 2,
    door = 2,
    exit = 2,
    storage = 2,
    wardrobe = 2,
    yard = 100, -- distance at which you can see the yard furniture
}

Config.Jobs = {
    realEstate = { -- jobs that should be able to create properties, DONT CHANGE THIS LINE
        real_estate = 0, -- CHANGE JOB NAME AND GRADE HERE
        realestate = 0, -- you can also add more jobs here
    },
    police = { -- jobs that should be able to enter all properties, DONT CHANGE THIS LINE
        police = 0, -- CHANGE JOB NAME AND GRADE HERE
        leo = 0,
        sheriff = 0,
    },
}
Config.PoliceNeededItem = 'police_stormram' -- item needed for police to enter properties

Config.EnableRemoving = true -- true / false, should you be able to remove properties (only works if a property doesn't have an owner)
Config.EnableEditing = true -- true / false, should you be able to edit properties (only works if a property doesn't have an owner)
Config.AllowAdmins = {
    createProperty = true, -- true / false
    removeProperty = true, -- true / false
}
Config.AdminGroups = {
    admin = true,
    --superadmin = true,
}

Config.MaxProperties = 99 -- max amount of properties player can own
Config.SellBackPercentage = 50 -- how much should you get back from the original price of a property when you sell it
Config.MaxPermissions = 10 -- max amount of players that can have permissions to a property
Config.DisableSelling = false -- true / false, should the selling of properties be disabled
Config.DisableTransferring = false -- true / false, should the transferring of properties be disabled
Config.ShowAllPropertiesInPropertyList = false -- false / true, should all properties be shown in property list (if set to false only properties that are manually put up for sale by property owner. If true all properties, including non-owned properties will be shown)

Config.PropertyList = {
    showAllUnownedProperties = false, -- false / true, should all unowned properties be shown in property list
    allowPlayersToList = true, -- false / true, should players be able to list properties for sale
    allowRealEstateToList = true, -- false / true, should real estate agents be able to list properties for sale
}

Config.Furnishing = {
    enable = true,
    sellPercentage = 50, -- how much should you get back from the original price of a furniture when you remove (sell) it
    maxStorages = 100, -- how many storages can be placed in a property
    showImages = false, -- false / true, should images be shown in furniture menu (images are taken from a website so the quality/placement/availability of images may vary)
    --imagePath = ('https://somewebsite.com/%s.jpg'),
}

Config.Gizmo = {
    enable = false, -- false / true, should gizmo be used for furnishing (requires https://github.com/DemiAutomatic/object_gizmo to work)
    camera = 'follow', -- default / follow
    maxDist = 50, -- max distance player can be from the property
}
Config.RentInterval = 1000 * 60 * 60 * 12 -- how often rent should be paid (12 hours)

Config.Doorbell = {
    notifyAlways = true, -- true / false, should there also be a notification from doorbell to property owner even when they aren't inside the property
    cooldown = 2500, -- cooldown for pressing doorbell (in milliseconds)
    maxDist = 10, -- max distance player can be from the door to still be able to get inside the property
}

Config.Lockpicking = { -- by default lockpicking minigame uses pd-safe, you can change it in client/main_editable.lua
    door = {
        enable = false, -- true / false, should you be able to lockpick doors of other players' properties
        item = 'lockpick', -- item needed to lockpick
        playersWithAccessNeeded = 1, -- how many online players with access to the property do you need in order to be able to lockpick it
    },
    storage = {
        enable = false, -- true / false, should you be able to lockpick storages of other players' properties
        item = 'lockpick', -- item needed to lockpick
        playersWithAccessNeeded = 1, -- how many online players with access to the storage do you need in order to be able to lockpick it
    },
}

Config.StorageBlacklist = { -- items that can't be stored in property storages
    --money = true,
    --weapon_pistol = true,
}

Config.UseCustomGarageMenu = false -- false / true, should custom garage menu be used
Config.ClearGarageEntrances = false -- false / true, should garage entrances be cleared of NPCs
Config.GarageCooldown = 2000 -- cooldown for spamming garage leaving / entering (in milliseconds)
Config.GarageVehicleExitOffset = 0.0 -- offset for vehicle spawn coords when leaving a garage
Config.CanStore = {
    NPCVehicles = true, -- should you be able to store NPC vehicles in garages
    OtherPlayerVehicles = true, -- should you be able to store other player's vehicles in garages
}
Config.DefaultGarage = 'Centre' -- incase vehicles somehow get bugged when you take them out, set the garage name here where they should be stored
Config.BetaVehicleSpawning = false -- false / true, alternative way for spawning vehicles (currently in beta, needs testing)
Config.GarageInteriors = { -- Garage interior settings
    small = {
        label = 'Small',
        exits = {
            {label = 'Front Door', coords = vec4(172.89, -1007.75, -99.0, 0.0)},
            {label = 'Side Door', coords = vec4(178.9, -1000.18, -99.0, 175.4)},
        },
    },
    medium = {
        label = 'Medium',
        exits = {
            {label = 'Front Door', coords = vec4(194.65, -1026.79, -99.0, 0.0)},
            {label = 'Side Door', coords = vec4(207.38, -1018.27, -99.0, 90.4)},
        },
    },
    medium_highend = {
        label = 'Medium High End',
        exits = {
            {label = 'Front Door', coords = vec4(194.65, -1026.79, -99.0, 0.0)},
            {label = 'Side Door', coords = vec4(207.38, -1018.27, -99.0, 90.4)},
        },
    },
    large = {
        label = 'Large',
        exits = {
            {label = 'Front Door', coords = vec4(224.53, -1006.73, -99.0, 0.0)},
            {label = 'Side Door', coords = vec4(238.57, -1004.67, -99.0, 89.6)},
        },
    },
}

Config.Blips = {
    owned = {
        enable = true, -- true / false
        color = 0, -- https://docs.fivem.net/docs/game-references/blips/ (Scroll to the bottom)
        scale = 0.8, -- This needs to be a float (eg. 1.0, 1.2, 2.0)
        sprite = 40, -- https://docs.fivem.net/docs/game-references/blips/
    },
    on_sale = {
        enable = true,
        color = 11,
        scale = 0.8,
        sprite = 350,
    },
}
Config.Markers = {
    house = {
        enable = false,
        dist = 6,
        type = 20,
        scale = vec3(0.3, 0.3, 0.3),
        color = vec4(255, 255, 255, 150),
        bob = false,
        faceCamera = true,
    },
    garage = {
        enable = false,
        dist = 6,
        type = 20,
        scale = vec3(0.3, 0.3, 0.3),
        color = vec4(255, 255, 255, 150),
        bob = false,
        faceCamera = true,
    },
    door = {
        enable = false,
        dist = 6,
        type = 20,
        scale = vec3(0.3, 0.3, 0.3),
        color = vec4(255, 255, 255, 150),
        bob = false,
        faceCamera = true,
    },
    exit = {
        enable = false,
        dist = 6,
        type = 20,
        scale = vec3(0.3, 0.3, 0.3),
        color = vec4(255, 255, 255, 150),
        bob = false,
        faceCamera = true,
    },
    storage = {
        enable = false,
        dist = 4,
        type = 20,
        scale = vec3(0.3, 0.3, 0.3),
        color = vec4(255, 255, 255, 150),
        bob = false,
        faceCamera = true,
    },
    wardrobe = {
        enable = false,
        dist = 4,
        type = 20,
        scale = vec3(0.3, 0.3, 0.3),
        color = vec4(255, 255, 255, 150),
        bob = false,
        faceCamera = true,
    },
}

Config.ShellOffset = vec3(0.0, 0.0, 500.0)
Config.HouseInteriors = { -- House interior settings, don't change if you don't know what you are doing
    {
        model = `shell_trailer`,
        label = 'Trailer',
        exits = {
            {label = 'Front Door', coords = vec4(-1.4, -2.1, 1.3, 358.63)},
            {label = 'Side Door', coords = vec4(-1.4, 0.0, 1.3, 358.63)},
        },
    },
    {
        model = `shell_lester`,
        label = 'Lester',
        exits = {
            {label = 'Front Door', coords = vec4(-1.780, -0.795, 1.1, 270.30)},
        },
    },
    {
        model = `shell_v16low`,
        label = 'V16 Low',
        exits = {
            {label = 'Front Door', coords = vec4(4.693, -6.015, 1.11, 358.634)},
        },
    },
    {
        model = `shell_trevor`,
        label = 'Trevor',
        exits = {
            {label = 'Front Door', coords = vec4(0.374, -3.789, 1.428, 358.633)},
        },
    },
    {
        model = `shell_frankaunt`,
        label = 'Franklin Aunt',
        exits = {
            {label = 'Front Door', coords = vec4(-0.36, -5.89, 1.70, 358.21)},
        },
    },
    {
        model = `shell_v16mid`,
        label = 'V16 Mid',
        exits = {
            {label = 'Front Door', coords = vec4(1.561, -14.305, 1.147, 2.263)},
        }
    },
    {
        model = `shell_ranch`,
        label = 'Ranch',
        exits = {
            {label = 'Front Door', coords = vec4(-1.257, -5.469, 1.5, 270.57)},
        },
    },
    {
        model = `shell_michael`,
        label = 'Michael',
        exits = {
            {label = 'Front Door', coords = vec4(-9.49, 5.54, 1.0, 270.86)},
        },
    },
    --[[ { -- IPLs can also be used like this
        isIpl = true, -- this is required for IPLs
        label = 'IPL',
        model = `ipl_1`, -- this can be whatever (make sure it's inside backticks or just use a number), it's just used to identify the interior
        exits = {
            {label = 'Front Door', coords = vec4(151.48, -1007.29, -99.0, 0.0)},
        },
    }, ]]

    -- All K4MB1 Maps shells are listed down here (https://www.k4mb1maps.com/)

    --[[
    -- 1AprilUpdate

    {
        model = `k4mb1_furnishedoffice1_shell`,
        label = 'k4mb1_furnishedoffice1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(3.5, -2.0, 0.1, 90.43)},
        },
    },
    {
        model = `k4mb1_furnishedoffice2_shell`,
        label = 'k4mb1_furnishedoffice2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(4.5, 4.0, 0.0, 177.33)},
        },
    },
    {
        model = `k4mb1_furnishedoffice3_shell`,
        label = 'k4mb1_furnishedoffice3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.5, -0.3, 0.0, 95.2)},
        },
    },
    {
        model = `k4mb1_furnishedoffice4_shell`,
        label = 'k4mb1_furnishedoffice4_shell',
        exits = {
            {label = 'Front Door', coords = vec4(9.0, -2.3, 1.0, 92.77)},
        },
    },
    {
        model = `k4mb1_furnishedoffice5_shell`,
        label = 'k4mb1_furnishedoffice5_shell',
        exits = {
            {label = 'Front Door', coords = vec4(1.8, -12.0, 2.0, 3.5)},
        },
    },
    {
        model = `k4mb1_hoodhouse1_shell`,
        label = 'k4mb1_hoodhouse1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-2.3, -7.4, 0.5, 90.5)},
        },
    },
    {
        model = `k4mb1_laundry_shell`,
        label = 'k4mb1_laundry_shell',
        exits = {
            {label = 'Front Door', coords = vec4(10.5, -6.0, 4.5, 0.0)},
        },
    },
    {
        model = `k4mb1_palhouse1_shell`,
        label = 'k4mb1_palhouse1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.7, 5.6, 2.2, 97.0)},
        },
    },
    {
        model = `k4mb1_sandyhouse1_shell`,
        label = 'k4mb1_sandyhouse1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(1.6, -5.0, 1.0, 0.0)},
        },
    },
    {
        model = `kambi_emptyhouse1`,
        label = 'kambi_emptyhouse1',
        exits = {
            {label = 'Front Door', coords = vec4(-1.0, -2.4, 0.0, 269.2)},
        },
    },
    {
        model = `kambi_furnishedhouse1`,
        label = 'kambi_furnishedhouse1',
        exits = {
            {label = 'Front Door', coords = vec4(-1.0, -2.4, 0.0, 269.2)},
        },
    },
    
    -- 1JanuaryUpdate:
    
    {
        model = `k4mb1_basement1_shell`,
        label = 'k4mb1_basement1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-5.08, -4.33, 5.90, 3.45)},
        },
    },
    {
        model = `k4mb1_basement2_shell`,
        label = 'k4mb1_basement2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-5.08, -4.33, 5.90, 3.45)},
        },
    },
    {
        model = `k4mb1_basement3_shell`,
        label = 'k4mb1_basement3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-5.08, -4.33, 5.90, 3.45)},
        },
    },
    {
        model = `k4mb1_basement4_shell`,
        label = 'k4mb1_basement4_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-5.08, -4.33, 5.90, 3.45)},
        },
    },
    {
        model = `k4mb1_basement5_shell`,
        label = 'k4mb1_basement5_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-5.08, -4.33, 5.90, 3.45)},
        },
    },
    {
        model = `k4mb1_casinohotel_shell`,
        label = 'k4mb1_casinohotel_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-3.03, -0.03, 0.10, 266.896057)},
        },
    },
    {
        model = `k4mb1_house1_shell`,
        label = 'k4mb1_house1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-3.119751, -4.734863, 3.7, 3.864161)},
        },
    },
    {
        model = `k4mb1_house2_shell`,
        label = 'k4mb1_house2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-8.603210, 1.091309, 3.7, 270.22)},
        },
    },
    {
        model = `k4mb1_house3_shell`,
        label = 'k4mb1_house3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(8.877808, -7.610352, 3.3, 3.61461)},
        },
    },
    {
        model = `k4mb1_house4_shell`,
        label = 'k4mb1_house4_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-2.22, -2.50, 0.70, 357.22)},
        },
    },

    -- 1SeptemberUpdate

    {
        model = `gunworkshop_k4mb1`,
        label = 'gunworkshop_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(0.111511, 4.884186, 0.615547, 198.17)},
        },
    },
    {
        model = `luxury_housing1_k4mb1`,
        label = 'luxury_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-6.354858, -0.932922, 1.529790, 265.74)},
        },
    },
    {
        model = `luxury_housing2_k4mb1`,
        label = 'luxury_housing2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-6.354858, -0.932922, 1.529790, 265.74)},
        },
    },
    {
        model = `luxury_housing3_k4mb1`,
        label = 'luxury_housing3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-6.354858, -0.932922, 1.529790, 265.74)},
        },
    },
    {
        model = `luxury_housing4_k4mb1`,
        label = 'luxury_housing4_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-6.354858, -0.932922, 1.529790, 265.74)},
        },
    },
    {
        model = `manor_housing1_k4mb1`,
        label = 'manor_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(6.710498, -8.742065, 13.216461, 0.0)},
        },
    },
    {
        model = `new_garages1_k4mb1`,
        label = 'new_garages1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-0.010498, 13.742065, 5.216461, 180.0)},
        },
    },
    {
        model = `new_garages2_k4mb1`,
        label = 'new_garages2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-3.885496, 0.018372, 0.119728, 271.723022)},
        },
    },
    {
        model = `new_garages3_k4mb1`,
        label = 'new_garages3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-3.557486, -0.223755, 0.113129, 269.100739)},
        },
    },
    {
        model = `new_garages4_k4mb1`,
        label = 'new_garages4_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(8.948175, 1.714355, 0.049950, 95.899307)},
        },
    },
    {
        model = `safehouse_k4mb1`,
        label = 'safehouse_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-5.319298, 1.057007, -0.032585, 269.940521)},
        },
    },
    {
        model = `warehouse_k4mb1`,
        label = 'warehouse_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(12.581251, -7.218262, 1.202477, 90.42)},
        },
    },

    -- ClassicHousing 
    
    {
        model = `classichouse_shell`,
        label = 'classichouse_shell',
        exits = {
            {label = 'Front Door', coords = vec4(4.776749, -1.983886, 4.584564, 82.28)},
        },
    },
    {
        model = `classichouse2_shell`,
        label = 'classichouse2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(4.776749, -1.983886, 5.584564, 82.28)},
        },
    },
    {
        model = `classichouse3_shell`,
        label = 'classichouse3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(4.776749, -1.983886, 5.584564, 82.28)},
        },
    },

    --DefaultHousing

    {
        model = `shell_lester`,
        label = 'shell_lester',
        exits = {
            {label = 'Front Door', coords = vec4(-1.606091, -5.912278, 1.2, 358.633972168)},
        },
    },
    {
        model = `shell_ranch`,
        label = 'shell_ranch',
        exits = {
            {label = 'Front Door', coords = vec4(-1.329970, 5.418801, 2.5, 358.633972168)},
        },
    },
    {
        model = `shell_trailer`,
        label = 'shell_trailer',
        exits = {
            {label = 'Front Door', coords = vec4(-1.457713, -1.989568, 3.0, 358.633972168)},
        },
    },
    {
        model = `shell_trevor`,
        offset = vector4(0.264359, -3.759369, 2.398148, 176.609085),
    },
    {
        model = `shell_v16low`,
        label = 'shell_v16low',
        exits = {
            {label = 'Front Door', coords = vec4(4.684745, -6.564815, 1.2, 358.633972168)},
        },
    },
    {
        model = `shell_v16mid`,
        label = 'shell_v16mid',
        exits = {
            {label = 'Front Door', coords = vec4(1.443699, -14.254955, 1.2, 358.633972168)},
        },
    },

    --DeluxeHousing

    {
        model = `shell_highend`,
        label = 'shell_highend',
        exits = {
            {label = 'Front Door', coords = vec4(-22.285980, -0.344971, 8.007278, 272.07)},
        },
    },
    {
        model = `shell_highendv2`,
        label = 'shell_highendv2',
        exits = {
            {label = 'Front Door', coords = vec4(-10.477051, 0.960693, 6.7, 270.17)},
        },
    },
    {
        model = `shell_michael`,
        label = 'shell_michael',
        exits = {
            {label = 'Front Door', coords = vec4(-8.991788, 5.8, 10.190231, 270.92)},
        },
    },

    --EmptyHotelHousing

    {
        model = `k4_hotel1_shell`,
        label = 'k4_hotel1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(5.032410, 4.079437, 0.614975, 183.71)},
        },
    },
    {
        model = `k4_hotel2_shell`,
        label = 'k4_hotel2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(5.032410, 4.079437, 0.614975, 183.71)},
        },
    },
    {
        model = `k4_hotel3_shell`,
        label = 'k4_hotel3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(5.032410, 4.079437, 0.614975, 183.71)},
        },
    },

    --EmptyMotelHousing

    {
        model = `k4_motel1_shell`,
        label = 'k4_motel1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.435547, -2.391693, 0.873642, 268.1)},
        },
    },
    {
        model = `k4_motel2_shell`,
        label = 'k4_motel2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(0.124939, -3.713745, 0.592621, 0.0)},
        },
    },
    {
        model = `k4_motel3_shell`,
        label = 'k4_motel3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(3.206482, 3.477509, 0.508859, 177.55)},
        },
    },

    --FurnishedHighendLabs

    {
        model = `k4coke_shell`,
        label = 'k4coke_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-10.894897, -2.486176, 20.357056, 276.14)},
        },
    },
    {
        model = `k4meth_shell`,
        label = 'k4meth_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-10.894897, -2.486176, 8.357056, 276.14)},
        },
    },
    {
        model = `k4weed_shell`,
        label = 'k4weed_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-10.894897, -2.486176, 20.357056, 276.14)},
        },
    },

    --FurnishedHotels

    {
        model = `modernhotel_shell`,
        offset = vector4(4.959091, 4.216187, 0.682167, 300.109680),
    },
    {
        model = `modernhotel2_shell`,
        label = 'modernhotel2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(5.032410, 4.079437, 0.614975, 179.7)},
        },
    },
    {
        model = `modernhotel3_shell`,
        label = 'modernhotel3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(5.032410, 4.079437, 0.614975, 179.7)},
        },
    },

    --FurnishedHousing

    {
        model = `furnitured_lowapart`,
        label = 'furnitured_lowapart',
        exits = {
            {label = 'Front Door', coords = vec4(4.867130, -1.397278, 1.145584, 1.633508)},
        },
    },
    {
        model = `furnitured_midapart`,
        label = 'furnitured_midapart',
        exits = {
            {label = 'Front Door', coords = vec4(1.481842, -10.215332, 1.2, 358.633972168)},
        },
    },
    {
        model = `furnitured_motel`,
        label = 'furnitured_motel',
        exits = {
            {label = 'Front Door', coords = vec4(1.481842, -10.215332, 1.2, 358.633972168)},
        },
    },

    --FurnishedLabs

    {
        model = `shell_coke1`,
        label = 'shell_coke1',
        exits = {
            {label = 'Front Door', coords = vec4(-6.253662, 8.439575, 0.471497, 180.6)},
        },
    },
    {
        model = `shell_coke2`,
        label = 'shell_coke2',
        exits = {
            {label = 'Front Door', coords = vec4(-6.253662, 8.439575, 0.471497, 180.6)},
        },
    },
    {
        model = `shell_meth`,
        label = 'shell_meth',
        exits = {
            {label = 'Front Door', coords = vec4(-6.253662, 8.439575, 0.471497, 180.6)},
        },
    },
    {
        model = `shell_weed`,
        label = 'shell_weed',
        exits = {
            {label = 'Front Door', coords = vec4(17.883362, 11.651215, -0.666962, 90.8)},
        },
    },
    {
        model = `shell_weed2`,
        label = 'shell_weed2',
        exits = {
            {label = 'Front Door', coords = vec4(17.883362, 11.651215, -0.666962, 90.8)},
        },
    },

    --FurnishedMotels

    {
        model = `classicmotel_shell`,
        label = 'classicmotel_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.011169, -3.700958, 0.592621, 0.0)},
        },
    },
    {
        model = `highendmotel_shell`,
        label = 'highendmotel_shell',
        exits = {
            {label = 'Front Door', coords = vec4(3.089539, 3.506805, 0.908859, 180.61)},
        },
    },
    {
        model = `standardmotel_shell`,
        offset = vector4(-0.373535, -2.395386, 0.935326, 130.537155),
    },

    --FurnishedStashhouse

    {
        model = `container2_shell`,
        label = 'container2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.015747, -5.739349, 0.716324, 0.0)},
        },
    },
    {
        model = `stashhouse1_shell`,
        label = 'stashhouse1_shell',
        exits = {
            {label = 'Front Door', coords = vec4(21.070313, -0.646851, 18.570790, 82.596138)},
        },
    },
    {
        model = `stashhouse3_shell`,
        label = 'stashhouse3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.162476, 5.610306, 0.418259, 183.3)},
        },
    },

    --HighendHousing

    {
        model = `shell_apartment1`,
        label = 'shell_apartment1',
        exits = {
            {label = 'Front Door', coords = vec4(-2.197006, 9.045532, 9.002113, 184.68)},
        },
    },
    {
        model = `shell_apartment2`,
        label = 'shell_apartment2',
        exits = {
            {label = 'Front Door', coords = vec4(-2.197006, 9.045532, 9.002113, 184.68)},
        },
    },
    {
        model = `shell_apartment3`,
        label = 'shell_apartment3',
        exits = {
            {label = 'Front Door', coords = vec4(11.723969, 4.505249, 8.2, 124.56)},
        },
    },

    --MansionHousing

    {
        model = `k4_mansion_shell`,
        label = 'k4_mansion_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.149323, -0.625119, 8.413507, 182.11)},
        },
    },
    {
        model = `k4_mansion2_shell`,
        label = 'k4_mansion2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.149323, -0.625119, 8.413507, 182.11)},
        },
    },
    {
        model = `k4_mansion3_shell`,
        label = 'k4_mansion3_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-0.149323, -0.625119, 8.413507, 182.11)},
        },
    },

    --MediumHousing

    {
        model = `shell_frankaunt`,
        label = 'shell_frankaunt',
        exits = {
            {label = 'Front Door', coords = vec4(-0.248180, -6.009651, 1.8, 358.633972168)},
        },
    },
    {
        model = `shell_medium2`,
        label = 'shell_medium2',
        exits = {
            {label = 'Front Door', coords = vec4(6.069122, 0.394775, 0.138916, 4.643677)},
        },
    },
    {
        model = `shell_medium3`,
        label = 'shell_medium3',
        exits = {
            {label = 'Front Door', coords = vec4(5.789444, -1.667908, 5.004852, 89.03)},
        },
    },

    --ModernHousing

    {
        model = `shell_banham`,
        label = 'shell_banham',
        exits = {
            {label = 'Front Door', coords = vec4(-3.261871, -1.579712, 6.036842, 82.72)},
        },
    },
    {
        model = `shell_westons`,
        label = 'shell_westons',
        exits = {
            {label = 'Front Door', coords = vec4(4.382950, 10.503174, 6.349475, 179.37)},
        },
    },
    {
        model = `shell_westons2`,
        label = 'shell_westons2',
        exits = {
            {label = 'Front Door', coords = vec4(-1.831970, 10.464172, 6.442517, 179.37)},
        },
    },

    --ShellsGarage

    {
        model = `shell_garagel`,
        label = 'shell_garagel',
        exits = {
            {label = 'Front Door', coords = vec4(11.765564, -14.352966, 0.429962, 83.45)},
        },
    },
    {
        model = `shell_garagem`,
        label = 'shell_garagem',
        exits = {
            {label = 'Front Door', coords = vec4(13.833588, 1.626221, 1.2, 358.633972168)},
        },
    },
    {
        model = `shell_garages`,
        label = 'shell_garages',
        exits = {
            {label = 'Front Door', coords = vec4(5.688721, 3.871887, 0.930031, 174.46)},
        },
    },

    --ShellsOffice

    {
        model = `shell_office1`,
        label = 'shell_office1',
        exits = {
            {label = 'Front Door', coords = vec4(1.112735, 5.006403, 2.0, 358.633972168)},
        },
    },
    {
        model = `shell_office2`,
        label = 'shell_office2',
        exits = {
            {label = 'Front Door', coords = vec4(3.632568, -1.852280, 0.555504, 89.34)},
        },
    },
    {
        model = `shell_officebig`,
        label = 'shell_officebig',
        exits = {
            {label = 'Front Door', coords = vec4(-12.364502, -3.764099, 5.031563, 0.0)},
        },
    },

    --ShellsStashhouse

    {
        model = `container_shell`,
        label = 'container_shell',
        exits = {
            {label = 'Front Door', coords = vec4(0.099396, -5.647644, 1.2, 358.633972168)},
        },
    },
    {
        model = `stashhouse_shell`,
        label = 'stashhouse_shell',
        exits = {
            {label = 'Front Door', coords = vec4(21.070313, -0.646851, 14.570790, 82.596138)},
        },
    },
    {
        model = `stashhouse2_shell`,
        label = 'stashhouse2_shell',
        exits = {
            {label = 'Front Door', coords = vec4(-1.945059, 2.157104, -0.211769, 272.95)},
        },
    },

    --ShellsStore

    {
        model = `shell_barber`,
        label = 'shell_barber',
        exits = {
            {label = 'Front Door', coords = vec4(1.612305, 5.450272, 0.872826, 187.76)},
        },
    },
    {
        model = `shell_gunstore`,
        label = 'shell_gunstore',
        exits = {
            {label = 'Front Door', coords = vec4(-1.014648, -5.390396, 0.693390, 0.0)},
        },
    },
    {
        model = `shell_store1`,
        label = 'shell_store1',
        exits = {
            {label = 'Front Door', coords = vec4(-2.697184, 4.684138, 1.2, 358.633972168)},
        },
    },
    {
        model = `shell_store2`,
        label = 'shell_store2',
        exits = {
            {label = 'Front Door', coords = vec4(-0.765503, -5.170990, 0.276688, 0.0)},
        },
    },
    {
        model = `shell_store3`,
        label = 'shell_store3',
        exits = {
            {label = 'Front Door', coords = vec4(-0.041626, -7.869644, 1.128952, 0.0)},
        },
    },

    --ShellsWarehouse

    {
        model = `shell_warehouse1`,
        label = 'shell_warehouse1',
        exits = {
            {label = 'Front Door', coords = vec4(-8.895659, 0.169503, 1.2, 358.633972168)},
        },
    },
    {
        model = `shell_warehouse2`,
        label = 'shell_warehouse2',
        exits = {
            {label = 'Front Door', coords = vec4(-12.493774, 5.542618, -0.628975, 265.43)},
        },
    },
    {
        model = `shell_warehouse3`,
        label = 'shell_warehouse3',
        exits = {
            {label = 'Front Door', coords = vec4(2.618225, -1.458923, 0.487114, 90.19)},
        },
    },

    --V2DefaultHousing

    {
        model = `default_housing1_k4mb1`,
        label = 'default_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(0.341354, 5.643433, 1.477180, 181.94)},
        },
    },
    {
        model = `default_housing2_k4mb1`,
        label = 'default_housing2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-5.179077, -4.887207, 1.830948, 267.45)},
        },
    },
    {
        model = `default_housing3_k4mb1`,
        label = 'default_housing3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-1.323883, -2.026917, 1.320457, 358.19)},
        },
    },
    {
        model = `default_housing4_k4mb1`,
        label = 'default_housing4_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(0.059586, -3.759644, 0.991960, 359.97)},
        },
    },
    {
        model = `default_housing5_k4mb1`,
        label = 'default_housing5_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(1.432739, -14.084991, 0.937408, 360.0)},
        },
    },
    {
        model = `default_housing6_k4mb1`,
        label = 'default_housing6_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(4.677618, -6.588533, 0.854195, 359.11)},
        },
    },

    --V2DeluxeHousing

    {
        model = `deluxe_housing1_k4mb1`,
        label = 'deluxe_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-22.285980, -0.344971, 8.007278, 272.07)},
        },
    },
    {
        model = `deluxe_housing2_k4mb1`,
        label = 'deluxe_housing2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-10.470276, 0.934265, 6.734932, 279.75)},
        },
    },
    {
        model = `deluxe_housing3_k4mb1`,
        label = 'deluxe_housing3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-9.691788, 5.689941, 1.190231, 270.92)},
        },
    },

    --V2HighendHousing

    {
        model = `highend_housing1_k4mb1`,
        label = 'highend_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-2.197006, 9.045532, 9.002113, 184.68)},
        },
    },
    {
        model = `highend_housing2_k4mb1`,
        label = 'highend_housing2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-2.197006, 9.045532, 9.002113, 184.68)},
        },
    },
    {
        model = `highend_housing3_k4mb1`,
        label = 'highend_housing3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(11.723969, 4.505249, 6.809669, 124.56)},
        },
    },

    --V2MediumHousing

    {
        model = `medium_housing1_k4mb1`,
        label = 'medium_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-0.342346, -5.893997, 0.860092, 0.0)},
        },
    },
    {
        model = `medium_housing2_k4mb1`,
        label = 'medium_housing2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(6.000778, 0.339172, 1.139000, 5.26)},
        },
    },
    {
        model = `medium_housing3_k4mb1`,
        label = 'medium_housing3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(5.789444, -1.667908, 5.004852, 89.03)},
        },
    },

    --V2ModernHousing

    {
        model = `modern_housing1_k4mb1`,
        label = 'modern_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(4.382950, 10.503174, 6.349475, 179.37)},
        },
    },
    {
        model = `modern_housing2_k4mb1`,
        label = 'modern_housing2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-1.831970, 10.464172, 6.442517, 179.37)},
        },
    },
    {
        model = `modern_housing3_k4mb1`,
        label = 'modern_housing3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(-3.261871, -1.579712, 6.036842, 82.72)},
        },
    },

    --VinewoodHousing

    {
        model = `vinewood_housing1_k4mb1`,
        label = 'vinewood_housing1_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(11.208313, -2.752686, 4.2, 82.72)},
        },
    },
    {
        model = `vinewood_housing2_k4mb1`,
        label = 'vinewood_housing2_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(1.643433, 4.888428, 6.7, 182.89)},
        },
    },
    {
        model = `vinewood_housing3_k4mb1`,
        label = 'vinewood_housing3_k4mb1',
        exits = {
            {label = 'Front Door', coords = vec4(3.423401, 7.123108, 2.094058, 182.84)},
        },
    },]]
}

Config.Furniture = {
    decorations = {
        {price = 700, label = 'Bottle', model = 'apa_mp_h_acc_bottle_01'},
        {price = 700, label = 'Candles', model = 'apa_mp_h_acc_candles_01'},
        {price = 700, label = 'Mirror', model = 'p_int_jewel_mirror'},
        {price = 700, label = 'Decorative Plate', model = 'apa_mp_h_acc_dec_plate_01'},
        {price = 700, label = 'Vase', model = 'apa_mp_h_acc_vase_01'},
        {price = 700, label = 'Desk Supplies', model = 'v_res_desktidy'},
        {price = 700, label = 'Ashtray', model = 'ex_prop_ashtray_luxe_02'},
        {price = 700, label = 'Bong', model = 'prop_bong_01'},
        {price = 700, label = 'Mr Rasberry Clean', model = 'prop_mr_rasberryclean'},
        {price = 1000, label = 'Guitar', model = 'prop_acc_guitar_01'},
        {price = 500, label = 'Planning Board', model = 'p_planning_board_04'},
        {price = 500, label = 'Hotel Clock', model = 'prop_hotel_clock_01'},
        {price = 700, label = 'Pamphlet', model = 'p_cs_pamphlet_01_s'},
        {price = 500, label = 'Big Clock', model = 'prop_big_clock_01'},
        {price = 500, label = 'Egg Clock', model = 'prop_egg_clock_01'},
        {price = 100, label = 'Green Screen', model = 'prop_ld_greenscreen_01'},
        {price = 500, label = 'Dart', model = 'prop_dart_bd_cab_01'},
        {price = 500, label = 'Dart 2', model = 'prop_dart_bd_01'},
        {price = 500, label = 'Exercise Bike', model = 'prop_exercisebike'},
        {price = 500, label = 'Laz', model = 'p_laz_j02_s'},
        {price = 100, label = 'Dummy', model = 'prop_dummy_01'},
        {price = 100, label = 'E Guitar 1', model = 'prop_el_guitar_01'},
        {price = 100, label = 'E Guitar 2', model = 'prop_el_guitar_02'},
        {price = 100, label = 'E Guitar 2', model = 'prop_el_guitar_03'},
        {price = 100, label = 'Ceramic Jug', model = 'prop_ceramic_jug_01'},
        {price = 50, label = 'Candles 1', model = 'apa_mp_h_acc_candles_06'},
        {price = 50, label = 'Candles 2', model = 'apa_mp_h_acc_candles_05'},
        {price = 50, label = 'Candles 3', model = 'apa_mp_h_acc_candles_04'},
        {price = 300, label = 'Rug 1', model = 'apa_mp_h_acc_rugwools_01'},
        {price = 300, label = 'Rug 2', model = 'apa_mp_h_acc_rugwoolm_01'},
        {price = 300, label = 'Rug 3', model = 'apa_mp_h_acc_rugwooll_04'},
        {price = 300, label = 'Rug 4', model = 'apa_mp_h_acc_rugwooll_03'},
        {price = 300, label = 'Rug 5', model = 'apa_mp_h_acc_rugwoolm_04'},
        {price = 300, label = 'Rug 6', model = 'apa_mp_h_acc_rugwools_03'},
        {price = 300, label = 'Vintage Clock', model = 'prop_v_5_bclock'},
        {price = 300, label = 'American Flag Clock', model = 'prop_v_15_cars_clock'},
        {price = 300, label = 'Modern Clock', model = 'prop_sm_19_clock'},
        {price = 300, label = 'Sports Clock', model = 'prop_sports_clock_01'},
        {price = 300, label = 'Candle 1', model = 'prop_mem_candle_01'},
        {price = 300, label = 'Crown Clock', model = 'prop_game_clock_01'},
        {price = 300, label = 'Kronos Clock', model = 'prop_game_clock_02'},
        {price = 300, label = 'Modern Clock 2', model = 'prop_id2_20_clock'},
        {price = 300, label = 'CIty name', model = 'ex_office_citymodel_01'},
        {price = 300, label = 'Mask', model = 'apa_mp_h_acc_dec_head_01'},
        {price = 300, label = 'Vase 1', model = 'ex_mp_h_acc_vase_06'},
        {price = 300, label = 'Red Vase', model = 'ex_mp_h_acc_vase_02'},
        {price = 300, label = 'Bust', model = 'hei_prop_hei_bust_01'},
        {price = 300, label = 'Arcade Machine', model = 'prop_arcade_01'},
        {price = 6500, label = 'Neon Sign 1', model = 'prop_beer_neon_01'},
        {price = 6500, label = 'Neon Sign 2', model = 'prop_beer_neon_02'},
        {price = 6500, label = 'Neon Sign 3', model = 'prop_beer_neon_03'},
        {price = 6500, label = 'Neon Sign 3', model = 'prop_beer_neon_04'},
        {price = 6500, label = 'Neon Sign Patriot', model = 'prop_patriotneon'},
        {price = 6500, label = 'Neon Sign Pussy Beer', model = 'prop_barrachneon'},
    },
    electronics = {
        {price = 100, label = 'Lamp', model = 'prop_cd_lamp'},
        {price = 1800, label = 'Shredder', model = 'v_ret_gc_shred'},
        {price = 800, label = 'Antique telephone', model = 'apa_mp_h_acc_phone_01'},
        {price = 14700, label = 'TV wall white-gray with electronics', model = 'apa_mp_h_str_avunitl_04'},
        {price = 6700, label = 'TV wooden wall with television', model = 'apa_mp_h_str_avunitl_01_b'},
        {price = 14300, label = 'Television with yellow speakers', model = 'apa_mp_h_str_avunitm_01'},
        {price = 12000, label = 'TV with white speakers', model = 'apa_mp_h_str_avunitm_03'},
        {price = 12900, label = 'Television with accessories', model = 'apa_mp_h_str_avunits_01'},
        {price = 6900, label = 'TV on a metal table', model = 'apa_mp_h_str_avunits_01'},
        {price = 5500, label = 'Notebook', model = 'bkr_prop_clubhouse_laptop_01a'},
        {price = 4400, label = 'Notebook', model = 'bkr_prop_clubhouse_laptop_01b'},
        {price = 12400, label = 'Money counter', model = 'bkr_prop_money_counter'},
        {price = 700, label = 'Large upright fan', model = 'bkr_prop_weed_fan_floor_01a'},
        {price = 2400, label = 'Tvsmash', model = 'des_tvsmash_start'},
        {price = 2700, label = 'Wall TV', model = 'ex_prop_ex_tv_flat_01'},
        {price = 3500, label = 'Desktop monitor with keyboard', model = 'ex_prop_monitor_01_ex'},
        {price = 4700, label = 'Desktop monitor with keyboard', model = 'ex_prop_trailer_monitor_01'},
        {price = 200, label = 'TV driver', model = 'ex_prop_tv_settop_remote'},
        {price = 2200, label = 'TV box', model = 'ex_prop_tv_settop_box'},
        {price = 1000, label = 'Table fan', model = 'gr_prop_bunker_deskfan_01a'},
        {price = 8400, label = 'Television with speakers and all equipment', model = 'hei_heist_str_avunitl_03'},
        {price = 1700, label = 'telephone landline', model = 'hei_prop_hei_bank_phone_01'},
        {price = 3800, label = 'Alarm', model = 'hei_prop_hei_bio_panel'},
        {price = 2100, label = 'Keyboard', model = 'hei_prop_hei_cs_keyboard'},
        {price = 8900, label = 'Project board', model = 'hei_prop_hei_muster_01'},
        {price = 1800, label = 'WIFI', model = 'hei_prop_server_piece_01'},
        {price = 3300, label = 'White notebook', model = 'p_laptop_02_s'},
        {price = 7900, label = 'Table Hockey', model = 'prop_airhockey_01'},
        {price = 2400, label = 'Portable Radio', model = 'prop_boombox_01'},
        {price = 2500, label = 'DVD player', model = 'prop_cctv_cont_03'},
        {price = 3300, label = 'CD player', model = 'prop_cctv_cont_04'},
        {price = 900, label = 'PC Mouse', model = 'prop_cs_mouse_01'},
        {price = 900, label = 'Wall clock', model = 'prop_game_clock_01'},
        {price = 600, label = 'Wall clock black', model = 'prop_game_clock_02'},
        {price = 3400, label = 'HiFi system', model = 'prop_hifi_01'},
        {price = 1500, label = 'square clock', model = 'prop_hotel_clock_01'},
        {price = 1500, label = 'Clock', model = 'prop_id2_20_clock'},
        {price = 3400, label = 'Nikon Handheld Camera', model = 'prop_ing_camera_01'},
        {price = 1700, label = 'White keyboard', model = 'prop_keyboard_01a'},
        {price = 1600, label = 'Router', model = 'prop_ld_armour'},
        {price = 1700, label = 'Old monitor', model = 'prop_ld_monitor_01'},
        {price = 2300, label = 'Small old monitor', model = 'prop_monitor_01b'},
        {price = 400, label = 'RETRO monitor', model = 'prop_monitor_03b'},
        {price = 5900, label = 'Monitor', model = 'prop_monitor_w_large'},
        {price = 4800, label = 'Repráček', model = 'prop_mp3_dock'},
        {price = 4000, label = 'White PC', model = 'prop_pc_01a'},
        {price = 4800, label = 'Black PC', model = 'prop_pc_02a'},
        {price = 2500, label = 'Mobile', model = 'prop_phone_ing'},
        {price = 2100, label = 'Mobile', model = 'prop_phone_ing_02'},
        {price = 2000, label = 'Mobile', model = 'prop_phone_ing_02_lod'},
        {price = 2300, label = 'Mobile', model = 'prop_phone_ing_03'},
        {price = 1000, label = 'RETRO radio', model = 'prop_radio_01'},
        {price = 1100, label = 'Small speaker', model = 'prop_speaker_05'},
        {price = 1000, label = 'Speaker', model = 'prop_speaker_06'},
        {price = 1900, label = 'Speaker', model = 'prop_speaker_08'},
        {price = 2000, label = 'Old TV', model = 'prop_trev_tv_01'},
        {price = 500, label = 'Old TV', model = 'prop_tv_03'},
        {price = 300, label = 'Old TV', model = 'prop_tv_01'},
        {price = 400, label = 'RETRO TV', model = 'prop_tv_04'},
        {price = 1700, label = 'Old TV', model = 'prop_tv_06'},
        {price = 6500, label = 'Plasma big screen', model = 'prop_tv_flat_01'},
        {price = 12500, label = 'Plasma thin TV', model = 'prop_tv_flat_01_screen'},
        {price = 1600, label = 'Plasma small television', model = 'prop_tv_flat_02'},
        {price = 2100, label = 'Plasma small television', model = 'prop_tv_flat_02b'},
        {price = 900, label = 'Small TV with stand', model = 'prop_tv_flat_03'},
        {price = 300, label = 'Small TV on the wall', model = 'prop_tv_flat_03b'},
        {price = 9200, label = 'Television Michael 50cm', model = 'prop_tv_flat_michael'},
        {price = 1000, label = 'Little US Clock', model = 'prop_v_15_cars_clock'},
        {price = 4000, label = 'Professional camera', model = 'prop_v_cam_01'},
        {price = 4700, label = 'VET player RETRO', model = 'prop_vcr_01'},
        {price = 9900, label = 'Mixing desk', model = 'v_club_vu_deckcase'},
        {price = 1500, label = 'RETRO Laptop', model = 'v_ind_ss_laptop'},
        {price = 100, label = 'Stapler', model = 'v_ret_gc_staple'},
        {price = 1900, label = 'Hardisk', model = 'xm_prop_x17_harddisk_01a'},
        {price = 5300, label = 'Computer', model = 'xm_prop_x17_res_pctower'},
        {price = 12900, label = 'Plasma TV', model = 'xm_prop_x17_tv_flat_01'},
        {price = 6600, label = 'Plasma TV', model = 'xm_prop_x17_tv_flat_02'},
        {price = 14000, label = 'Jukebox', model = 'bkr_prop_clubhouse_jukebox_01b'},
        {price = 1700, label = 'USB', model = 'hei_prop_hst_usb_drive'},
        {price = 700, label = 'Flashlight', model = 'p_cs_police_torch_s'},
        {price = 1000, label = 'Microphone', model = 'p_ing_microphonel_01'},
        {price = 1600, label = 'Radio', model = 'prop_tapeplayer_01'},
        {price = 4500, label = 'Multifunction Laser Printer', model = 'prop_printer_01'},
        {price = 11200, label = 'Multifunction Laser Printer', model = 'prop_printer_02'},
        {price = 20300, label = 'Jukebox 2', model = 'prop_50s_jukebox'},
        {price = 21200, label = 'Arcade games', model = 'prop_arcade_01'},
        {price = 3800, label = 'Astronomical Clock', model = 'prop_v_5_bclock'},
        {price = 22200, label = 'Table with three monitors', model = 'xm_prop_base_staff_desk_01'},
        {price = 17900, label = 'Table with three monitors', model = 'xm_prop_base_staff_desk_02'},
        {price = 1500, label = 'Napkin machine', model = 'prop_handdry_01'},
        {price = 2700, label = 'Washing Machine', model = 'prop_washer_02'},
        {price = 600, label = 'Washing machine with its years', model = 'prop_washer_03'},
        {price = 700, label = 'RETRO washing machine', model = 'v_ret_fh_dryer'},
    },
    storage = {
        {price = 700, label = 'Iron used closed cabinet', model = 'p_cs_locker_01_s', isStorage = true, weight = 10000, slots = 10}, -- you can set weight and slots for each storage item individually
        {price = 700, label = 'Locker 2', model = 'p_cs_locker_02', isStorage = true},
        {price = 700, label = 'Iron open cabinet', model = 'p_cs_locker_01', isStorage = true},
        {price = 700, label = 'Crate 1', model = 'prop_lev_crate_01', isStorage = true},
        {price = 700, label = 'Cabinet 4', model = 'prop_cabinet_02b', isStorage = true},
        {price = 700, label = 'Cabinet 5', model = 'prop_cabinet_01b', isStorage = true},
        {price = 700, label = 'Devin Box', model = 'prop_devin_box_closed', isStorage = true},
        {price = 700, label = 'Crate 3', model = 'prop_mil_crate_01', isStorage = true},
        {price = 700, label = 'Safe 1', model = 'prop_ld_int_safe_01', isStorage = true},
        {price = 700, label = 'Safe 2', model = 'p_v_43_safe_s', isStorage = true},
        {price = 700, label = 'Woodtable', model = 'prop_mil_crate_02', isStorage = true},
    },
    tables = {
        {price = 5600, label = 'Glass table', model = 'apa_mp_h_din_table_04'},
        {price = 5000, label = 'Glass table', model = 'apa_mp_h_din_table_11'},
        {price = 5300, label = 'Glass table', model = 'apa_mp_h_tab_sidelrg_07'},
        {price = 1200, label = 'Black Round Table', model = 'apa_mp_h_tab_sidelrg_04'},
        {price = 1600, label = 'Glass table', model = 'apa_mp_h_tab_sidelrg_01'},
        {price = 5700, label = 'Decorative glass table', model = 'apa_mp_h_tab_sidelrg_02'},
        {price = 2600, label = 'Black coffee table', model = 'apa_mp_h_yacht_coffee_table_01'},
        {price = 4200, label = 'Square table', model = 'apa_mp_h_yacht_side_table_01'},
        {price = 3400, label = 'Small table', model = 'gr_dlc_gr_yacht_props_table_01'},
        {price = 4700, label = 'Long table', model = 'gr_dlc_gr_yacht_props_table_02'},
        {price = 1000, label = 'Particleboard table', model = 'prop_rub_table_01'},
        {price = 700, label = 'Particleboard dining table', model = 'prop_rub_table_02'},
        {price = 700, label = 'TV table', model = 'prop_tv_cabinet_03'},
        {price = 300, label = 'TV table', model = 'prop_tv_cabinet_04'},
        {price = 800, label = 'TV table', model = 'prop_tv_cabinet_05'},
        {price = 5300, label = 'Black modern table', model = 'v_ilev_liconftable_sml'},
        {price = 4100, label = 'Bar', model = 'xm_prop_lab_desk_01'},
    },
    sofas = {
        {price = 11500, label = 'Couch with pillows', model = 'prop_couch_01'},
        {price = 6500, label = 'Padded bench', model = 'prop_wait_bench_01'},
        {price = 4400, label = 'White leather sofa', model = 'xm_lab_sofa_01'}
    },
    kitchen = {
        {price = 800, label = 'Kitchen scale', model = 'bkr_prop_coke_scale_01'},
        {price = 1000, label = 'Home coffee maker', model = 'prop_coffee_mac_02'},
        {price = 5200, label = 'Automatic juice mixer', model = 'prop_juice_dispenser'},
        {price = 200, label = 'White wall phone', model = 'prop_office_phone_tnt'},
        {price = 2300, label = 'Fruit Blender', model = 'p_kitch_juicer_s'},
        {price = 1500, label = 'Kettle', model = 'prop_kettle_01'},
        {price = 2600, label = 'Crushing machine', model = 'prop_slush_dispenser'},
        {price = 700, label = 'Coffee pot', model = 'xm_prop_x17_coffee_jug'},
        {price = 3700, label = 'Mini bar fridge', model = 'prop_bar_fridge_03'},
        {price = 800, label = 'Plastic red cup', model = 'apa_prop_cs_plastic_cup_01'},
        {price = 1000, label = 'Trash', model = 'prop_bin_10a'},
        {price = 400, label = 'Universal Cleaner', model = 'prop_blox_spray'},
        {price = 200, label = 'Green bucket', model = 'prop_buck_spade_05'},
        {price = 400, label = 'Blue bucket', model = 'prop_buck_spade_06'},
        {price = 200, label = 'Red bucket', model = 'prop_buck_spade_07'},
        {price = 700, label = 'Cups', model = 'prop_food_cups2'},
        {price = 400, label = 'White Cup', model = 'prop_mug_02'},
        {price = 800, label = 'Bowl with donut lid', model = 'v_res_cakedome'},
        {price = 1000, label = 'Loose tea container', model = 'v_res_fa_pottea'},
        {price = 300, label = 'Deep Plate', model = 'v_res_mbowl'},
        {price = 500, label = 'Paper napkins', model = 'v_ret_ta_paproll'},
        {price = 400, label = 'Glasses', model = 'p_w_grass_gls_s'},
        {price = 300, label = 'Glasses', model = 'prop_cocktail'},
        {price = 600, label = 'Knife', model = 'prop_cs_bowie_knife'},
    },
    bedroom = {
        {price = 100, label = 'Double bed', model = 'p_lestersbed_s'},
        {price = 600, label = 'Double bed', model = 'p_v_res_tt_bed_s'},
        {price = 400, label = 'Double modern bed', model = 'apa_mp_h_bed_double_08'},
        {price = 1100, label = 'Double modern bed', model = 'apa_mp_h_bed_wide_05'},
        {price = 2200, label = 'Double modern bed', model = 'apa_mp_h_yacht_bed_02'},
        {price = 700, label = 'Single sofa bed', model = 'ex_prop_exec_bed_01'},
        {price = 3100, label = 'Double modern bed', model = 'hei_heist_bed_double_08'},
        {price = 4400, label = 'Chest of drawers', model = 'apa_mp_h_bed_chestdrawer_02', isWardrobe = true},
        {price = 400, label = 'RETRO wardrobe', model = 'apa_mp_h_str_shelffloorm_02', isWardrobe = true},
        {price = 100, label = 'RETRO chest of drawers low', model = 'apa_mp_h_str_sideboardl_11', isWardrobe = true},
        {price = 2500, label = 'Gray-white low cabinet', model = 'apa_mp_h_str_sideboardl_13', isWardrobe = true},
        {price = 700, label = 'Wooden chest of drawers', model = 'apa_mp_h_str_sideboardl_14', isWardrobe = true},
        {price = 500, label = 'Wood brindle feather duster', model = 'apa_mp_h_str_sideboardm_02', isWardrobe = true},
    }
}
-- if you dont want people on your server to add the properties manually uncomment this
-- when uncommented, these will be inserted to database with current data
-- if you want to change them, you need to change them in the database or by using the ingame property editor
--[[ Config.Properties = {
    {name = 'Mirror Park Blvd 1', coords = vec3(1228.86, -725.41, 60.80), houseInteriorIndex = 1, price = 100000}, -- you can define the price and interior here, otherwise random values will be generated
    {name = 'Mirror Park Blvd 2', coords = vec3(1222.79, -697.04, 60.80)},
    {name = 'Mirror Park Blvd 3', coords = vec3(1221.39, -668.83, 63.49)},
    {name = 'Mirror Park Blvd 4', coords = vec3(1206.88, -620.22, 66.44)},
    {name = 'Mirror Park Blvd 5', coords = vec3(1203.69, -598.96, 68.06)},
    {name = 'Mirror Park Blvd 6', coords = vec3(1200.84, -575.72, 69.14)},
    {name = 'Mirror Park Blvd 7', coords = vec3(1204.48, -557.80, 69.62)},
    {name = 'East Mirror Dr 1', coords = vec3(1241.99, -565.69, 69.66)},
    {name = 'East Mirror Dr 2', coords = vec3(1241.38, -601.70, 69.43)},
    {name = 'East Mirror Dr 3', coords = vec3(1251.20, -621.31, 69.41)},
    {name = 'East Mirror Dr 4', coords = vec3(1265.51, -648.17, 67.92)},
    {name = 'East Mirror Dr 5', coords = vec3(1271.05, -683.56, 66.03)},
    {name = 'East Mirror Dr 6', coords = vec3(1265.37, -703.04, 64.57)},
    {name = 'Nikola Pl 1', coords = vec3(1302.80, -528.49, 71.46)},
    {name = 'Nikola Pl 2', coords = vec3(1328.17, -535.87, 72.44)},
    {name = 'Nikola Pl 3', coords = vec3(1347.80, -547.87, 73.89)},
    {name = 'Nikola Pl 4', coords = vec3(1372.98, -555.50, 74.69)},
    {name = 'Nikola Pl 5', coords = vec3(1388.53, -569.69, 74.50)},
    {name = 'Nikola Pl 6', coords = vec3(1386.18, -593.38, 74.49)},
    {name = 'Nikola Pl 7', coords = vec3(1367.30, -606.03, 74.71)},
    {name = 'Nikola Pl 8', coords = vec3(1341.83, -597.71, 74.70)},
    {name = 'Nikola Pl 9', coords = vec3(1323.54, -582.69, 73.25)},
    {name = 'Nikola Pl 10', coords = vec3(1301.33, -573.53, 71.73)},
    {name = 'East Mirror Dr 7', coords = vec3(1250.87, -515.61, 69.35)},
    {name = 'East Mirror Dr 8', coords = vec3(1251.77, -494.21, 69.91)},
    {name = 'East Mirror Dr 9', coords = vec3(1260.26, -479.69, 70.19)},
    {name = 'East Mirror Dr 10', coords = vec3(1266.02, -458.10, 70.52)},
    {name = 'East Mirror Dr 11', coords = vec3(1262.53, -429.83, 70.01)},
    {name = 'West Mirror Drive 1', coords = vec3(1114.05, -391.22, 68.95)},
    {name = 'Bridge St 1', coords = vec3(1100.71, -411.34, 67.56)},
    {name = 'Bridge St 2', coords = vec3(1099.57, -438.43, 67.79)},
    {name = 'Bridge St 3', coords = vec3(1098.68, -464.57, 67.32)},
    {name = 'Bridge St 4', coords = vec3(1090.41, -484.43, 65.66)},
    {name = 'Bridge St 5', coords = vec3(1046.37, -498.00, 64.08)},
    {name = 'Bridge St 6', coords = vec3(1051.57, -470.53, 63.90)},
    {name = 'Bridge St 7', coords = vec3(1056.18, -448.91, 66.26)},
    {name = 'West Mirror Drive 2', coords = vec3(1014.60, -469.24, 64.51)},
    {name = 'West Mirror Drive 3', coords = vec3(970.12, -502.26, 62.14)},
    {name = 'West Mirror Drive 4', coords = vec3(946.01, -518.88, 60.63)},
    {name = 'West Mirror Drive 5', coords = vec3(924.35, -526.06, 59.79)},
    {name = 'West Mirror Drive 6', coords = vec3(893.17, -540.66, 58.51)},
    {name = 'Nikola Ave 1', coords = vec3(920.01, -570.06, 58.37)},
    {name = 'Nikola Ave 2', coords = vec3(965.34, -542.24, 59.53)},
    {name = 'Nikola Ave 3', coords = vec3(987.96, -526.07, 60.70)},
    {name = 'Nikola Ave 4', coords = vec3(1006.55, -511.12, 60.99)},
    {name = 'Bridge St 8', coords = vec3(1061.02, -378.75, 68.23)},
    {name = 'West Mirror Drive 7', coords = vec3(1029.21, -408.61, 66.14)},
    {name = 'West Mirror Drive 8', coords = vec3(1010.47, -423.40, 65.35)},
    {name = 'West Mirror Drive 9', coords = vec3(988.01, -433.55, 63.89)},
    {name = 'West Mirror Drive 10', coords = vec3(967.38, -451.86, 62.79)},
    {name = 'West Mirror Drive 11', coords = vec3(944.21, -463.37, 61.40)},
    {name = 'West Mirror Drive 12', coords = vec3(922.03, -477.96, 61.08)},
    {name = 'West Mirror Drive 13', coords = vec3(906.37, -489.69, 59.44)},
    {name = 'West Mirror Drive 14', coords = vec3(878.67, -498.27, 58.10)},
    {name = 'West Mirror Drive 15', coords = vec3(861.86, -509.14, 57.52)},
    {name = 'West Mirror Drive 16', coords = vec3(850.31, -532.71, 57.92)},
    {name = 'West Mirror Drive 17', coords = vec3(844.30, -563.34, 57.83)},
    {name = 'West Mirror Drive 18', coords = vec3(861.66, -583.55, 58.16)},
    {name = 'West Mirror Drive 19', coords = vec3(886.77, -608.21, 58.45)},
    {name = 'West Mirror Drive 20', coords = vec3(902.97, -615.59, 58.45)},
    {name = 'West Mirror Drive 21', coords = vec3(928.89, -639.78, 58.24)},
    {name = 'West Mirror Drive 22', coords = vec3(943.65, -653.62, 58.43)},
    {name = 'West Mirror Drive 23', coords = vec3(960.43, -669.66, 58.45)},
    {name = 'West Mirror Drive 24', coords = vec3(970.92, -700.51, 58.48)},
    {name = 'West Mirror Drive 25', coords = vec3(979.34, -716.14, 58.22)},
    {name = 'West Mirror Drive 26', coords = vec3(997.10, -729.37, 57.82)},
    {name = 'Wild Oats Dr 1', coords = vec3(223.48, 514.19, 140.77)},
    {name = 'Wild Oats Dr 2', coords = vec3(149.16, 474.69, 142.51)},
    {name = 'Wild Oats Dr 3', coords = vec3(107.17, 467.23, 147.37)},
    {name = 'Wild Oats Dr 4', coords = vec3(57.98, 450.17, 147.03)},
    {name = 'Wild Oats Dr 5', coords = vec3(-7.57, 468.17, 145.87)},
    {name = 'Wild Oats Dr 6', coords = vec3(-66.52, 490.63, 144.69)},
    {name = 'Wild Oats Dr 7', coords = vec3(-109.90, 502.31, 143.48)},
    {name = 'Wild Oats Dr 8', coords = vec3(-175.49, 502.46, 137.42)},
    {name = 'Wild Oats Dr 9', coords = vec3(-230.23, 487.93, 128.77)},
    {name = 'Didion Dr 1', coords = vec3(-312.14, 474.67, 111.82)},
    {name = 'Whispymound Dr 1', coords = vec3(8.63, 540.41, 176.03)},
    {name = 'Whispymound Dr 2', coords = vec3(45.97, 555.89, 180.08)},
    {name = 'Whispymound Dr 3', coords = vec3(84.99, 561.71, 182.77)},
    {name = 'Whispymound Dr 4', coords = vec3(119.37, 564.46, 183.96)},
    {name = 'Whispymound Dr 5', coords = vec3(150.84, 555.85, 183.74)},
    {name = 'Whispymound Dr 6', coords = vec3(216.34, 620.42, 187.76)},
    {name = 'Whispymound Dr 7', coords = vec3(232.14, 672.09, 189.98)},
    {name = 'Lake Vinewood Dr 1', coords = vec3(228.73, 765.82, 204.98)},
    {name = 'Grove St 1', coords = vec3(76.20, -1948.22, 21.17)},
    {name = 'Grove St 2', coords = vec3(85.96, -1959.71, 21.12)},
    {name = 'Grove St 3', coords = vec3(114.31, -1961.08, 21.33)},
    {name = 'Grove St 4', coords = vec3(126.88, -1929.94, 21.38)},
    {name = 'Grove St 5', coords = vec3(118.42, -1920.99, 21.32)},
    {name = 'Grove St 6', coords = vec3(100.99, -1912.16, 21.41)},
    {name = 'Grove St 7', coords = vec3(72.24, -1939.14, 21.37)},
    {name = 'Grove St 8', coords = vec3(56.66, -1922.79, 21.91)},
    {name = 'Grove St 9', coords = vec3(38.96, -1911.64, 21.95)},
    {name = 'Grove St 10', coords = vec3(23.56, -1896.17, 22.96)},
    {name = 'Grove St 11', coords = vec3(5.31, -1884.29, 23.70)},
    {name = 'Grove St 12', coords = vec3(-4.75, -1872.09, 24.15)},
    {name = 'Grove St 13', coords = vec3(-20.41, -1858.89, 25.41)},
    {name = 'Grove St 14', coords = vec3(-34.43, -1847.23, 26.19)},
    {name = 'Grove St 15', coords = vec3(-42.02, -1792.18, 27.83)},
    {name = 'Grove St 16', coords = vec3(-50.40, -1783.22, 28.30)},
    {name = 'Grove St 17', coords = vec3(21.35, -1844.61, 24.60)},
    {name = 'Grove St 18', coords = vec3(29.99, -1854.56, 24.07)},
    {name = 'Grove St 19', coords = vec3(45.88, -1864.12, 23.28)},
    {name = 'Grove St 20', coords = vec3(54.33, -1872.97, 22.81)},
    {name = 'Covenant Ave 1', coords = vec3(104.17, -1885.29, 24.32)},
    {name = 'Covenant Ave 2', coords = vec3(115.46, -1887.88, 23.93)},
    {name = 'Covenant Ave 3', coords = vec3(128.03, -1896.80, 23.67)},
    {name = 'Covenant Ave 4', coords = vec3(148.88, -1904.54, 23.53)},
    {name = 'Roy Lowenstein Blvd 1', coords = vec3(208.63, -1895.23, 24.81)},
    {name = 'Covenant Ave 5', coords = vec3(192.38, -1883.39, 25.06)},
    {name = 'Covenant Ave 6', coords = vec3(171.65, -1871.31, 24.40)},
    {name = 'Covenant Ave 7', coords = vec3(149.99, -1864.66, 24.59)},
    {name = 'Covenant Ave 8', coords = vec3(130.64, -1853.20, 25.23)},
    {name = 'Brouge Ave 1', coords = vec3(152.21, -1823.37, 27.86)},
    {name = 'Roy Lowenstein Blvd 2', coords = vec3(179.29, -1924.02, 21.37)},
    {name = 'Roy Lowenstein Blvd 3', coords = vec3(165.11, -1944.98, 20.24)},
    {name = 'Roy Lowenstein Blvd 4', coords = vec3(148.95, -1960.41, 19.46)},
    {name = 'Roy Lowenstein Blvd 5', coords = vec3(144.34, -1968.98, 18.86)},
    {name = 'Niland Ave 1', coords = vec3(1932.35, 3804.73, 32.91)},
    {name = 'Algonquin Blvd 1', coords = vec3(1925.10, 3824.74, 32.44)},
    {name = 'Niland Ave 2', coords = vec3(1899.00, 3781.69, 32.88)},
    {name = 'Algonquin Blvd 2', coords = vec3(1880.65, 3810.55, 32.78)},
    {name = 'Zancudo Ave 1', coords = vec3(1827.13, 3729.30, 33.96)},
    {name = 'Zancudo Ave 2', coords = vec3(1779.36, 3640.83, 34.50)},
    {name = 'Algonquin Blvd 3', coords = vec3(1774.35, 3743.37, 34.66)},
    {name = 'Armadillo Ave 1', coords = vec3(1843.67, 3777.73, 33.59)},
    {name = 'Algonquin Blvd 4', coords = vec3(1937.11, 3890.85, 32.46)},
    {name = 'Algonquin Blvd 5', coords = vec3(1902.30, 3866.90, 33.07)},
    {name = 'Mountain View Dr 1', coords = vec3(1748.93, 3783.25, 34.83)},
    {name = 'Mountain View Dr 2', coords = vec3(1745.96, 3788.53, 34.83)},
    {name = 'Mountain View Dr 3', coords = vec3(1733.44, 3808.64, 35.13)},
    {name = 'Cholla Springs Ave 1', coords = vec3(1763.70, 3823.57, 34.77)},
    {name = 'Cholla Springs Ave 2', coords = vec3(1760.04, 3821.44, 34.77)},
    {name = 'Cholla Springs Ave 3', coords = vec3(1813.33, 3853.88, 34.35)},
    {name = 'Cholla Springs Ave 4', coords = vec3(1831.64, 3868.18, 34.08)},
    {name = 'Cholla Springs Ave 5', coords = vec3(1833.93, 3863.32, 34.30)},
    {name = 'Niland Ave 3', coords = vec3(1859.51, 3865.38, 33.06)},
    {name = 'Niland Ave 4', coords = vec3(1861.93, 3857.14, 36.27)},
    {name = 'Niland Ave 5', coords = vec3(1894.47, 3896.06, 33.21)},
    {name = 'Niland Ave 6', coords = vec3(1880.12, 3920.75, 33.21)},
    {name = 'Marina Dr 1', coords = vec3(1915.98, 3909.50, 33.44)},
    {name = 'Cholla Springs Ave 6', coords = vec3(1638.85, 3731.76, 35.07)},
    {name = 'Cholla Springs Ave 7', coords = vec3(1728.89, 3851.52, 34.78)},
    {name = 'Niland Ave 7', coords = vec3(1845.80, 3914.31, 33.46)},
    {name = 'Niland Ave 8', coords = vec3(1842.18, 3928.29, 33.53)},
    {name = 'Marina Dr 2', coords = vec3(1803.48, 3913.87, 37.06)},
    {name = 'Marina Dr 3', coords = vec3(1781.37, 3911.24, 34.91)},
    {name = 'Marina Dr 4', coords = vec3(1733.37, 3895.24, 35.56)},
    {name = 'Marina Dr 5', coords = vec3(1691.78, 3865.82, 34.91)},
    {name = 'Marina Dr 6', coords = vec3(1661.32, 3820.03, 35.47)},
    {name = 'Panorama Dr 1', coords = vec3(1540.78, 3721.10, 34.88)},
    {name = 'Panorama Dr 2', coords = vec3(1500.93, 3694.97, 35.25)},
    {name = 'Lesbos Ln 1', coords = vec3(1430.70, 3671.38, 34.83)},
    {name = 'Lesbos Ln 2', coords = vec3(1435.43, 3657.11, 34.40)},
    {name = 'Lesbos Ln 3', coords = vec3(1436.30, 3639.12, 34.95)},
    {name = 'Marina Dr 7', coords = vec3(1385.12, 3659.50, 34.93)},
    {name = 'Marina Dr 8', coords = vec3(1407.12, 3655.69, 34.43)},
    {name = 'Calafia Rd 1', coords = vec3(98.02, 3682.01, 39.74)},
    {name = 'Calafia Rd 2', coords = vec3(105.46, 3728.41, 40.21)},
    {name = 'Calafia Rd 3', coords = vec3(70.43, 3753.41, 39.77)},
    {name = 'Calafia Rd 4', coords = vec3(51.95, 3742.00, 40.11)},
    {name = 'Calafia Rd 5', coords = vec3(30.74, 3736.35, 40.63)},
    {name = 'Calafia Rd 6', coords = vec3(13.40, 3724.75, 39.68)},
    {name = 'Calafia Rd 7', coords = vec3(15.22, 3688.84, 40.13)},
    {name = 'Calafia Rd 8', coords = vec3(68.09, 3693.25, 40.66)},
    {name = 'Calafia Rd 9', coords = vec3(41.57, 3705.39, 40.52)},
    {name = 'Calafia Rd 10', coords = vec3(40.59, 3715.85, 39.67)},
    {name = 'Calafia Rd 11', coords = vec3(84.64, 3717.96, 40.36)},
    {name = 'Calafia Rd 12', coords = vec3(78.08, 3732.46, 40.32)},
    {name = 'Great Ocean Hwy 1', coords = vec3(-1058.82, 4915.37, 211.82)},
    {name = 'Great Ocean Hwy 2', coords = vec3(-1075.74, 4897.41, 214.27)},
    {name = 'Great Ocean Hwy 3', coords = vec3(-1098.53, 4893.42, 216.07)},
    {name = 'Great Ocean Hwy 4', coords = vec3(-1113.49, 4903.58, 218.60)},
    {name = 'Great Ocean Hwy 5', coords = vec3(-1144.14, 4908.46, 220.97)},
    {name = 'Great Ocean Hwy 6', coords = vec3(-1146.44, 4940.85, 222.27)},
    {name = 'Procopio Promenade 10', coords = vec3(-709.87, 5768.67, 17.51)},
    {name = 'Procopio Promenade 9', coords = vec3(-706.02, 5766.78, 17.51)},
    {name = 'Procopio Promenade 8', coords = vec3(-701.78, 5764.89, 17.51)},
    {name = 'Procopio Promenade 7', coords = vec3(-698.20, 5763.21, 17.51)},
    {name = 'Procopio Promenade 6', coords = vec3(-694.07, 5761.30, 17.51)},
    {name = 'Procopio Promenade 5', coords = vec3(-690.18, 5759.49, 17.51)},
    {name = 'Procopio Promenade 4', coords = vec3(-687.39, 5759.04, 17.51)},
    {name = 'Procopio Promenade 3', coords = vec3(-685.93, 5763.11, 17.51)},
    {name = 'Procopio Promenade 2', coords = vec3(-683.91, 5766.50, 17.51)},
    {name = 'Procopio Promenade 1', coords = vec3(-681.93, 5770.75, 17.51)},
    {name = 'Procopio Promenade 11', coords = vec3(-480.81, 6266.25, 13.63)},
    {name = 'Procopio Promenade 12', coords = vec3(-453.57, 6337.12, 12.90)},
    {name = 'Paleto Blvd 1', coords = vec3(-374.56, 6190.98, 31.73)},
    {name = 'Paleto Blvd 2', coords = vec3(-356.99, 6207.47, 31.85)},
    {name = 'Paleto Blvd 3', coords = vec3(-347.29, 6225.23, 31.88)},
    {name = 'Paleto Blvd 4', coords = vec3(-15.18, 6557.69, 33.24)},
    {name = 'Paleto Blvd 5', coords = vec3(11.60, 6578.39, 33.07)},
    {name = 'Paleto Blvd 6', coords = vec3(31.61, 6596.41, 32.82)},
    {name = 'Procopio Dr 1', coords = vec3(56.47, 6646.05, 32.28)},
    {name = 'Procopio Dr 2', coords = vec3(35.63, 6663.06, 32.19)},
    {name = 'Procopio Dr 3', coords = vec3(-9.57, 6654.11, 31.69)},
    {name = 'Procopio Dr 4', coords = vec3(1.40, 6612.76, 32.08)},
    {name = 'Procopio Dr 5', coords = vec3(-41.42, 6637.02, 31.09)},
    {name = 'Procopio Dr 6', coords = vec3(-26.83, 6597.55, 31.86)},
    {name = 'Procopio Dr 7', coords = vec3(-44.70, 6582.37, 32.18)},
    {name = 'Procopio Dr 8', coords = vec3(-130.58, 6551.60, 29.52)},
    {name = 'Procopio Dr 9', coords = vec3(-105.61, 6528.55, 30.17)},
    {name = 'Procopio Dr 10', coords = vec3(-214.89, 6444.24, 31.31)},
    {name = 'Procopio Dr 11', coords = vec3(-189.29, 6409.56, 32.30)},
    {name = 'Procopio Dr 12', coords = vec3(-214.01, 6396.43, 33.09)},
    {name = 'Procopio Dr 13', coords = vec3(-237.55, 6422.75, 31.17)},
    {name = 'Procopio Dr 14', coords = vec3(-227.87, 6378.04, 31.76)},
    {name = 'Procopio Dr 15', coords = vec3(-272.19, 6400.67, 31.50)},
    {name = 'Procopio Dr 16', coords = vec3(-248.09, 6370.40, 31.85)},
    {name = 'Paleto Blvd 7', coords = vec3(-280.75, 6351.04, 32.60)},
    {name = 'Paleto Blvd 8', coords = vec3(-302.08, 6326.99, 32.89)},
    {name = 'Procopio Dr 17', coords = vec3(-332.35, 6302.38, 33.09)},
    {name = 'Procopio Dr 18', coords = vec3(-359.55, 6334.68, 29.85)},
    {name = 'Duluoz Ave 1', coords = vec3(-371.07, 6266.77, 31.88)},
    {name = 'Procopio Dr 19', coords = vec3(-379.93, 6252.76, 31.85)},
    {name = 'Procopio Dr 20', coords = vec3(-407.05, 6313.87, 28.94)},
    {name = 'Procopio Dr 21', coords = vec3(-437.97, 6272.14, 30.07)},
    {name = 'Procopio Dr 22', coords = vec3(-441.84, 6198.09, 29.55)},
    {name = 'Paleto Blvd 9', coords = vec3(-157.29, 6409.41, 31.92)},
    {name = 'Paleto Blvd 10', coords = vec3(-150.56, 6416.88, 31.92)},
    {name = 'Cascabel Ave 1', coords = vec3(-150.20, 6422.40, 31.92)},
    {name = 'Cascabel Ave 2', coords = vec3(-160.14, 6432.25, 31.92)},
    {name = 'Cascabel Ave 3', coords = vec3(-167.40, 6439.33, 31.92)},
    {name = 'Great Ocean Hwy 7', coords = vec3(1538.82, 6321.92, 25.06)},
    {name = 'Senora Fwy 1', coords = vec3(1510.48, 6326.12, 24.61)},
    {name = 'Senora Fwy 2', coords = vec3(2221.37, 5614.58, 54.90)},
    {name = 'Union Rd 1', coords = vec3(2451.97, 4968.90, 46.57)},
    {name = 'Catfish View 1', coords = vec3(3311.14, 5176.07, 19.61)},
    {name = 'Catfish View 2', coords = vec3(3725.27, 4525.20, 22.47)},
    {name = 'Catfish View 3', coords = vec3(3689.20, 4562.84, 25.18)},
    {name = 'Senora Way 1', coords = vec3(2526.44, 2586.44, 38.55)},
    {name = 'Senora Way 2', coords = vec3(2352.66, 2523.37, 47.69)},
    {name = 'Senora Way 3', coords = vec3(2359.85, 2541.87, 47.70)},
    {name = 'Senora Way 4', coords = vec3(2363.54, 2555.92, 46.69)},
    {name = 'Senora Fwy 3', coords = vec3(2332.94, 2524.61, 46.62)},
    {name = 'Senora Fwy 4', coords = vec3(2321.14, 2535.61, 47.20)},
    {name = 'Senora Fwy 5', coords = vec3(2319.07, 2553.48, 47.69)},
    {name = 'Senora Fwy 6', coords = vec3(2338.61, 2570.59, 47.72)},
    {name = 'Senora Fwy 7', coords = vec3(2334.30, 2589.31, 47.74)},
    {name = 'Senora Fwy 8', coords = vec3(2337.67, 2605.05, 47.17)},
    {name = 'Senora Fwy 9', coords = vec3(2357.40, 2609.53, 47.17)},
    {name = 'Senora Rd 1', coords = vec3(1394.68, 1141.90, 114.62)},
    {name = 'Los Santos Freeway 1', coords = vec3(1532.03, 1728.03, 109.92)},
    {name = 'Senora Fwy 10', coords = vec3(1535.58, 2231.84, 77.70)},
    {name = 'Senora Rd 2', coords = vec3(1400.99, 2169.73, 97.87)},
    {name = 'Senora Rd 3', coords = vec3(347.84, 2564.94, 43.52)},
    {name = 'Senora Rd 4', coords = vec3(366.84, 2571.37, 44.39)},
    {name = 'Senora Rd 5', coords = vec3(382.55, 2576.46, 44.37)},
    {name = 'Senora Rd 6', coords = vec3(403.75, 2584.34, 43.52)},
    {name = 'Route 68 1', coords = vec3(471.14, 2607.53, 44.48)},
    {name = 'Route 68 2', coords = vec3(506.73, 2610.26, 43.98)},
    {name = 'Route 68 3', coords = vec3(564.44, 2598.90, 43.88)},
    {name = 'Route 68 4', coords = vec3(341.31, 2615.70, 44.67)},
    {name = 'Route 68 5', coords = vec3(346.53, 2618.73, 44.69)},
    {name = 'Route 68 6', coords = vec3(354.01, 2620.43, 44.67)},
    {name = 'Route 68 7', coords = vec3(359.79, 2622.90, 44.67)},
    {name = 'Route 68 8', coords = vec3(366.84, 2624.93, 44.67)},
    {name = 'Route 68 9', coords = vec3(372.16, 2628.31, 44.69)},
    {name = 'Route 68 10', coords = vec3(379.78, 2629.39, 44.67)},
    {name = 'Route 68 11', coords = vec3(385.11, 2632.72, 44.68)},
    {name = 'Route 68 12', coords = vec3(392.51, 2634.41, 44.67)},
    {name = 'Route 68 13', coords = vec3(397.80, 2637.72, 44.68)},
    {name = 'Nowhere Rd 1', coords = vec3(2166.24, 3380.10, 46.43)},
    {name = 'Smoke Tree Rd 1', coords = vec3(2167.80, 3331.50, 46.47)},
    {name = 'Smoke Tree Rd 2', coords = vec3(2200.96, 3318.13, 46.85)},
    {name = 'Smoke Tree Rd 3', coords = vec3(2389.28, 3309.85, 47.64)},
    {name = 'Smoke Tree Rd 4', coords = vec3(2389.58, 3341.42, 47.50)},
    {name = 'Senora Fwy 11', coords = vec3(2618.79, 3274.92, 55.74)},
    {name = 'Senora Fwy 12', coords = vec3(2634.44, 3292.01, 55.73)},
    {name = 'Senora Fwy 13', coords = vec3(2632.49, 3258.08, 55.46)},
    {name = 'Senora Fwy 14', coords = vec3(2660.09, 3291.70, 55.64)},
    {name = 'Carson Ave 1', coords = vec3(282.80, -1899.10, 27.27)},
    {name = 'Roy Lowenstein Blvd 6', coords = vec3(270.10, -1917.04, 26.18)},
    {name = 'Roy Lowenstein Blvd 7', coords = vec3(258.14, -1927.06, 25.44)},
    {name = 'Roy Lowenstein Blvd 8', coords = vec3(250.72, -1935.03, 24.71)},
    {name = 'Jamestown St 1', coords = vec3(291.40, -1980.02, 21.60)},
    {name = 'Jamestown St 2', coords = vec3(295.90, -1971.72, 22.90)},
    {name = 'Jamestown St 3', coords = vec3(312.59, -1956.58, 24.62)},
    {name = 'Carson Ave 2', coords = vec3(324.30, -1937.35, 25.02)},
    {name = 'Jamestown St 4', coords = vec3(256.58, -2023.60, 19.27)},
    {name = 'Jamestown St 5', coords = vec3(251.26, -2030.09, 18.71)},
    {name = 'Jamestown St 6', coords = vec3(368.45, -1896.04, 25.18)},
    {name = 'Jamestown St 7', coords = vec3(385.05, -1881.49, 26.03)},
    {name = 'Jamestown St 8', coords = vec3(399.44, -1864.83, 26.72)},
    {name = 'Jamestown St 9', coords = vec3(412.64, -1855.93, 27.32)},
    {name = 'Jamestown St 10', coords = vec3(427.48, -1841.97, 28.46)},
    {name = 'Macdonald St 1', coords = vec3(440.14, -1829.93, 28.36)},
    {name = 'Jamestown St 11', coords = vec3(495.28, -1823.25, 28.87)},
    {name = 'Jamestown St 12', coords = vec3(500.31, -1812.88, 28.89)},
    {name = 'Jamestown St 13', coords = vec3(511.92, -1790.83, 28.93)},
    {name = 'Jamestown St 14', coords = vec3(513.97, -1780.94, 28.91)},
    {name = 'Jamestown St 15', coords = vec3(500.52, -1697.14, 29.79)},
    {name = 'Jamestown St 16', coords = vec3(490.09, -1714.22, 29.71)},
    {name = 'Jamestown St 17', coords = vec3(479.75, -1736.23, 29.15)},
    {name = 'Jamestown St 18', coords = vec3(474.48, -1757.79, 29.09)},
    {name = 'Jamestown St 19', coords = vec3(472.52, -1775.21, 29.07)},
    {name = 'Roy Lowenstein Blvd 9', coords = vec3(443.30, -1707.38, 29.71)},
    {name = 'Roy Lowenstein Blvd 10', coords = vec3(430.84, -1725.69, 29.60)},
    {name = 'Roy Lowenstein Blvd 11', coords = vec3(419.35, -1735.73, 29.61)},
    {name = 'Roy Lowenstein Blvd 12', coords = vec3(405.42, -1751.29, 29.71)},
    {name = 'Roy Lowenstein Blvd 13', coords = vec3(333.15, -1741.29, 29.73)},
    {name = 'Roy Lowenstein Blvd 14', coords = vec3(320.65, -1759.91, 29.64)},
    {name = 'Roy Lowenstein Blvd 15', coords = vec3(304.59, -1775.62, 29.10)},
    {name = 'Roy Lowenstein Blvd 16', coords = vec3(300.18, -1784.07, 28.44)},
    {name = 'Roy Lowenstein Blvd 17', coords = vec3(288.66, -1792.60, 28.09)},
    {name = 'Forum Dr 1', coords = vec3(-158.09, -1680.06, 33.83)},
    {name = 'Forum Dr 2', coords = vec3(-148.28, -1687.74, 32.87)},
    {name = 'Forum Dr 3', coords = vec3(-146.83, -1688.47, 33.07)},
    {name = 'Forum Dr 4', coords = vec3(-142.43, -1692.28, 32.87)},
    {name = 'Forum Dr 5', coords = vec3(-141.66, -1693.75, 33.07)},
    {name = 'Forum Dr 6', coords = vec3(-141.70, -1693.59, 36.16)},
    {name = 'Forum Dr 7', coords = vec3(-142.92, -1691.88, 36.17)},
    {name = 'Forum Dr 8', coords = vec3(-146.57, -1688.82, 36.17)},
    {name = 'Forum Dr 9', coords = vec3(-148.50, -1687.20, 36.17)},
    {name = 'Forum Dr 10', coords = vec3(-157.17, -1679.92, 36.97)},
    {name = 'Forum Dr 11', coords = vec3(-158.75, -1679.63, 36.97)},
    {name = 'Forum Dr 12', coords = vec3(-216.46, -1674.40, 34.46)},
    {name = 'Forum Dr 13', coords = vec3(-212.29, -1667.47, 34.46)},
    {name = 'Forum Dr 14', coords = vec3(-212.29, -1660.72, 34.46)},
    {name = 'Forum Dr 15', coords = vec3(-216.90, -1648.49, 34.46)},
    {name = 'Forum Dr 16', coords = vec3(-225.06, -1649.00, 35.28)},
    {name = 'Forum Dr 17', coords = vec3(-224.90, -1666.25, 34.46)},
    {name = 'Forum Dr 18', coords = vec3(-224.89, -1654.41, 37.64)},
    {name = 'Forum Dr 19', coords = vec3(-223.83, -1648.57, 38.44)},
    {name = 'Forum Dr 20', coords = vec3(-216.88, -1648.82, 37.64)},
    {name = 'Forum Dr 21', coords = vec3(-212.29, -1660.78, 37.64)},
    {name = 'Forum Dr 22', coords = vec3(-212.26, -1667.86, 37.64)},
    {name = 'Forum Dr 23', coords = vec3(-216.65, -1674.41, 37.64)},
    {name = 'Forum Dr 24', coords = vec3(-223.94, -1674.40, 37.64)},
    {name = 'Forum Dr 25', coords = vec3(-224.89, -1666.77, 37.64)},
    {name = 'Forum Dr 26', coords = vec3(-209.40, -1600.30, 34.87)},
    {name = 'Forum Dr 27', coords = vec3(-210.05, -1607.15, 34.87)},
    {name = 'Forum Dr 28', coords = vec3(-212.07, -1617.20, 34.87)},
    {name = 'Forum Dr 29', coords = vec3(-213.62, -1618.08, 34.87)},
    {name = 'Forum Dr 30', coords = vec3(-223.07, -1617.67, 34.87)},
    {name = 'Forum Dr 31', coords = vec3(-223.06, -1601.26, 34.88)},
    {name = 'Forum Dr 32', coords = vec3(-223.07, -1585.55, 34.87)},
    {name = 'Forum Dr 33', coords = vec3(-215.74, -1576.33, 34.87)},
    {name = 'Forum Dr 34', coords = vec3(-219.17, -1579.77, 34.87)},
    {name = 'Forum Dr 35', coords = vec3(-205.74, -1585.74, 34.87)},
    {name = 'Forum Dr 36', coords = vec3(-205.60, -1585.16, 38.06)},
    {name = 'Forum Dr 37', coords = vec3(-219.37, -1580.03, 38.05)},
    {name = 'Forum Dr 38', coords = vec3(-223.07, -1586.03, 38.05)},
    {name = 'Forum Dr 39', coords = vec3(-223.15, -1601.04, 38.05)},
    {name = 'Forum Dr 40', coords = vec3(-223.07, -1617.68, 38.06)},
    {name = 'Forum Dr 41', coords = vec3(-213.20, -1618.09, 38.05)},
    {name = 'Forum Dr 42', coords = vec3(-211.97, -1617.05, 38.05)},
    {name = 'Forum Dr 43', coords = vec3(-209.98, -1606.82, 38.05)},
    {name = 'Forum Dr 44', coords = vec3(-208.85, -1601.16, 38.05)},
    {name = 'Carson Ave 3', coords = vec3(-167.77, -1534.31, 35.10)},
    {name = 'Forum Dr 45', coords = vec3(-174.00, -1547.53, 35.13)},
    {name = 'Forum Dr 46', coords = vec3(-179.58, -1554.18, 35.13)},
    {name = 'Forum Dr 47', coords = vec3(-187.21, -1563.27, 35.76)},
    {name = 'Forum Dr 48', coords = vec3(-191.88, -1560.01, 34.95)},
    {name = 'Forum Dr 49', coords = vec3(-196.12, -1555.58, 34.96)},
    {name = 'Forum Dr 50', coords = vec3(-184.38, -1539.45, 34.36)},
    {name = 'Carson Ave 4', coords = vec3(-180.15, -1534.39, 34.36)},
    {name = 'Carson Ave 5', coords = vec3(-174.62, -1528.82, 34.35)},
    {name = 'Carson Ave 6', coords = vec3(-167.41, -1534.53, 38.33)},
    {name = 'Carson Ave 7', coords = vec3(-174.47, -1528.68, 37.54)},
    {name = 'Carson Ave 8', coords = vec3(-180.34, -1534.62, 37.54)},
    {name = 'Forum Dr 51', coords = vec3(-184.44, -1539.53, 37.54)},
    {name = 'Forum Dr 52', coords = vec3(-173.99, -1547.51, 38.33)},
    {name = 'Forum Dr 53', coords = vec3(-179.97, -1554.57, 38.33)},
    {name = 'Forum Dr 54', coords = vec3(-187.00, -1563.02, 39.13)},
    {name = 'Forum Dr 55', coords = vec3(-188.60, -1562.76, 39.13)},
    {name = 'Forum Dr 56', coords = vec3(-192.08, -1559.83, 38.34)},
    {name = 'Forum Dr 57', coords = vec3(-195.75, -1555.82, 38.33)},
    {name = 'Carson Ave 9', coords = vec3(-119.99, -1574.60, 34.18)},
    {name = 'Carson Ave 10', coords = vec3(-114.30, -1579.39, 34.18)},
    {name = 'Carson Ave 11', coords = vec3(-118.70, -1585.92, 34.21)},
    {name = 'Carson Ave 12', coords = vec3(-122.86, -1590.89, 34.21)},
    {name = 'Forum Dr 58', coords = vec3(-140.55, -1599.47, 34.83)},
    {name = 'Forum Dr 59', coords = vec3(-147.98, -1596.70, 34.83)},
    {name = 'Forum Dr 60', coords = vec3(-140.30, -1587.58, 34.24)},
    {name = 'Forum Dr 61', coords = vec3(-134.32, -1580.46, 34.21)},
    {name = 'Forum Dr 62', coords = vec3(-134.47, -1580.59, 37.41)},
    {name = 'Forum Dr 63', coords = vec3(-139.35, -1586.98, 37.41)},
    {name = 'Forum Dr 64', coords = vec3(-148.00, -1596.71, 38.21)},
    {name = 'Forum Dr 65', coords = vec3(-146.43, -1597.33, 38.21)},
    {name = 'Forum Dr 66', coords = vec3(-140.38, -1599.44, 38.21)},
    {name = 'Carson Ave 13', coords = vec3(-119.97, -1574.54, 37.41)},
    {name = 'Carson Ave 14', coords = vec3(-113.80, -1579.68, 37.41)},
    {name = 'Carson Ave 15', coords = vec3(-119.38, -1586.38, 37.41)},
    {name = 'Carson Ave 16', coords = vec3(-123.18, -1591.26, 37.41)},
    {name = 'Strawberry Ave 1', coords = vec3(-83.64, -1622.97, 31.48)},
    {name = 'Strawberry Ave 2', coords = vec3(-89.37, -1629.82, 31.50)},
    {name = 'Strawberry Ave 3', coords = vec3(-97.17, -1639.13, 32.10)},
    {name = 'Strawberry Ave 4', coords = vec3(-105.33, -1632.79, 32.91)},
    {name = 'Strawberry Ave 5', coords = vec3(-109.62, -1628.56, 32.91)},
    {name = 'Carson Ave 17', coords = vec3(-97.77, -1612.49, 32.31)},
    {name = 'Carson Ave 18', coords = vec3(-93.57, -1607.28, 32.31)},
    {name = 'Carson Ave 19', coords = vec3(-88.01, -1601.41, 32.31)},
    {name = 'Carson Ave 20', coords = vec3(-80.36, -1607.85, 31.48)},
    {name = 'Carson Ave 21', coords = vec3(-80.32, -1607.75, 34.69)},
    {name = 'Carson Ave 22', coords = vec3(-93.50, -1607.19, 35.49)},
    {name = 'Carson Ave 23', coords = vec3(-97.91, -1612.46, 35.49)},
    {name = 'Strawberry Ave 6', coords = vec3(-83.63, -1622.98, 34.69)},
    {name = 'Strawberry Ave 7', coords = vec3(-89.63, -1630.14, 34.69)},
    {name = 'Strawberry Ave 8', coords = vec3(-98.12, -1638.83, 35.49)},
    {name = 'Strawberry Ave 9', coords = vec3(-96.84, -1638.73, 35.49)},
    {name = 'Strawberry Ave 10', coords = vec3(-105.50, -1632.48, 36.29)},
    {name = 'Strawberry Ave 11', coords = vec3(-109.65, -1628.70, 36.29)},
    {name = 'Strawberry Ave 12', coords = vec3(-114.31, -1659.61, 32.56)},
    {name = 'Strawberry Ave 13', coords = vec3(-124.13, -1671.32, 32.56)},
    {name = 'Strawberry Ave 14', coords = vec3(-131.20, -1665.86, 32.56)},
    {name = 'Forum Dr 67', coords = vec3(-138.74, -1658.90, 33.38)},
    {name = 'Strawberry Ave 15', coords = vec3(-129.20, -1647.53, 33.30)},
    {name = 'Strawberry Ave 16', coords = vec3(-120.98, -1653.47, 32.56)},
    {name = 'Strawberry Ave 17', coords = vec3(-26.92, -1544.12, 30.67)},
    {name = 'Strawberry Ave 18', coords = vec3(-20.18, -1550.50, 30.68)},
    {name = 'Strawberry Ave 19', coords = vec3(-24.54, -1556.55, 30.69)},
    {name = 'Carson Ave 24', coords = vec3(-35.83, -1555.15, 30.68)},
    {name = 'Carson Ave 25', coords = vec3(-44.76, -1547.22, 31.51)},
    {name = 'Carson Ave 26', coords = vec3(-36.25, -1537.09, 31.45)},
    {name = 'Strawberry Ave 20', coords = vec3(-19.86, -1550.48, 33.82)},
    {name = 'Strawberry Ave 21', coords = vec3(-26.48, -1544.33, 33.82)},
    {name = 'Carson Ave 27', coords = vec3(-35.95, -1536.89, 34.62)},
    {name = 'Carson Ave 28', coords = vec3(-33.87, -1567.58, 33.02)},
    {name = 'Carson Ave 29', coords = vec3(-28.10, -1560.79, 33.82)},
    {name = 'Carson Ave 30', coords = vec3(-35.85, -1555.14, 33.82)},
    {name = 'Carson Ave 31', coords = vec3(-44.46, -1547.13, 34.62)},
    {name = 'Forum Dr 68', coords = vec3(-65.12, -1512.85, 33.44)},
    {name = 'Forum Dr 69', coords = vec3(-72.03, -1508.34, 33.43)},
    {name = 'Forum Dr 70', coords = vec3(-78.18, -1515.79, 34.25)},
    {name = 'Carson Ave 32', coords = vec3(-69.31, -1526.87, 34.24)},
    {name = 'Carson Ave 33', coords = vec3(-59.08, -1530.99, 34.24)},
    {name = 'Carson Ave 34', coords = vec3(-62.21, -1532.69, 34.24)},
    {name = 'Carson Ave 35', coords = vec3(-52.94, -1523.34, 33.44)},
    {name = 'Carson Ave 36', coords = vec3(-59.98, -1517.17, 33.44)},
    {name = 'Forum Dr 71', coords = vec3(-77.84, -1515.33, 37.42)},
    {name = 'Forum Dr 72', coords = vec3(-72.06, -1508.50, 36.62)},
    {name = 'Forum Dr 73', coords = vec3(-65.16, -1512.83, 36.62)},
    {name = 'Carson Ave 37', coords = vec3(-59.71, -1517.43, 36.62)},
    {name = 'Carson Ave 38', coords = vec3(-53.17, -1523.62, 36.62)},
    {name = 'Carson Ave 39', coords = vec3(-58.84, -1530.53, 37.42)},
    {name = 'Carson Ave 40', coords = vec3(-62.61, -1532.36, 37.42)},
    {name = 'Carson Ave 41', coords = vec3(-69.20, -1526.83, 37.42)},
    {name = 'Forum Dr 74', coords = vec3(-113.61, -1467.48, 33.82)},
    {name = 'Forum Dr 75', coords = vec3(-107.82, -1473.36, 33.82)},
    {name = 'Forum Dr 76', coords = vec3(-112.48, -1479.25, 33.82)},
    {name = 'Carson Ave 42', coords = vec3(-119.95, -1478.52, 33.82)},
    {name = 'Carson Ave 43', coords = vec3(-125.61, -1473.88, 33.82)},
    {name = 'Carson Ave 44', coords = vec3(-132.34, -1462.75, 33.82)},
    {name = 'Carson Ave 45', coords = vec3(-126.64, -1456.53, 34.61)},
    {name = 'Carson Ave 46', coords = vec3(-122.74, -1459.94, 33.82)},
    {name = 'Carson Ave 47', coords = vec3(-122.74, -1459.93, 36.99)},
    {name = 'Carson Ave 48', coords = vec3(-127.72, -1456.92, 37.79)},
    {name = 'Carson Ave 49', coords = vec3(-132.31, -1462.71, 36.99)},
    {name = 'Carson Ave 50', coords = vec3(-138.01, -1470.98, 36.99)},
    {name = 'Carson Ave 51', coords = vec3(-126.17, -1473.50, 36.99)},
    {name = 'Carson Ave 52', coords = vec3(-119.91, -1478.76, 36.99)},
    {name = 'Forum Dr 77', coords = vec3(-112.43, -1479.18, 36.99)},
    {name = 'Forum Dr 78', coords = vec3(-107.63, -1473.45, 36.99)},
    {name = 'Forum Dr 79', coords = vec3(-113.51, -1467.68, 36.99)},
    {name = 'Forum Dr 80', coords = vec3(-64.47, -1449.63, 32.52)},
    {name = 'Forum Dr 81', coords = vec3(-45.50, -1445.62, 32.43)},
    {name = 'Forum Dr 82', coords = vec3(-32.86, -1446.58, 31.89)},
    {name = 'Forum Dr 83', coords = vec3(-14.25, -1441.59, 31.10)},
    {name = 'Forum Dr 84', coords = vec3(-1.91, -1442.08, 30.96)},
    {name = 'Forum Dr 85', coords = vec3(16.30, -1444.19, 30.95)},
    {name = 'Macdonald St 2', coords = vec3(252.74, -1670.70, 29.66)},
    {name = 'Brouge Ave 2', coords = vec3(240.89, -1687.73, 29.69)},
    {name = 'Brouge Ave 3', coords = vec3(223.00, -1702.84, 29.70)},
    {name = 'Brouge Ave 4', coords = vec3(216.44, -1717.43, 29.68)},
    {name = 'Brouge Ave 5', coords = vec3(197.87, -1725.82, 29.66)},
    {name = 'Brouge Ave 6', coords = vec3(250.06, -1730.83, 29.67)},
    {name = 'Brouge Ave 7', coords = vec3(257.47, -1722.68, 29.65)},
    {name = 'Brouge Ave 8', coords = vec3(269.59, -1712.90, 29.67)},
    {name = 'Macdonald St 3', coords = vec3(282.08, -1694.86, 29.65)},
    {name = 'Prosperity St 1', coords = vec3(-986.78, -1199.40, 6.05)},
    {name = 'Palomino Ave 1', coords = vec3(-1002.18, -1218.45, 5.76)},
    {name = 'Palomino Ave 2', coords = vec3(-1011.70, -1224.21, 5.95)},
    {name = 'Palomino Ave 3', coords = vec3(-1035.55, -1227.89, 6.38)},
    {name = 'Invention Ct 1', coords = vec3(-1068.83, -1162.28, 2.16)},
    {name = 'Invention Ct 2', coords = vec3(-1063.78, -1159.97, 2.55)},
    {name = 'Invention Ct 3', coords = vec3(-1046.19, -1159.91, 2.16)},
    {name = 'Invention Ct 4', coords = vec3(-1034.75, -1147.16, 2.16)},
    {name = 'Invention Ct 5', coords = vec3(-1024.84, -1139.31, 2.75)},
    {name = 'Invention Ct 6', coords = vec3(-1040.20, -1136.01, 2.16)},
    {name = 'Invention Ct 7', coords = vec3(-1074.07, -1152.56, 2.16)},
    {name = 'Invention Ct 8', coords = vec3(-977.73, -1108.06, 2.15)},
    {name = 'Invention Ct 9', coords = vec3(-992.15, -1103.73, 2.15)},
    {name = 'Invention Ct 10', coords = vec3(-970.17, -1093.00, 2.15)},
    {name = 'Invention Ct 11', coords = vec3(-959.70, -1109.71, 2.15)},
    {name = 'Invention Ct 12', coords = vec3(-948.51, -1107.55, 2.17)},
    {name = 'Invention Ct 13', coords = vec3(-952.61, -1077.65, 2.67)},
    {name = 'Invention Ct 14', coords = vec3(-938.65, -1087.90, 2.15)},
    {name = 'Invention Ct 15', coords = vec3(-942.98, -1075.61, 2.74)},
    {name = 'Imagination Ct 1', coords = vec3(-989.29, -989.61, 2.05)},
    {name = 'Imagination Ct 2', coords = vec3(-986.55, -981.58, 2.15)},
    {name = 'Imagination Ct 3', coords = vec3(-1007.17, -989.55, 2.15)},
    {name = 'Imagination Ct 4', coords = vec3(-1008.43, -1015.21, 2.15)},
    {name = 'Imagination Ct 5', coords = vec3(-1023.35, -998.03, 2.15)},
    {name = 'Imagination Ct 6', coords = vec3(-1022.20, -1022.96, 2.15)},
    {name = 'Imagination Ct 7', coords = vec3(-1041.84, -1025.52, 2.57)},
    {name = 'Imagination Ct 8', coords = vec3(-1081.02, -1036.23, 2.15)},
    {name = 'Imagination Ct 9', coords = vec3(-1108.23, -1041.75, 2.15)},
    {name = 'Imagination Ct 10', coords = vec3(-1104.20, -1059.51, 2.41)},
    {name = 'Imagination Ct 11', coords = vec3(-1114.40, -1068.67, 2.15)},
    {name = 'Imagination Ct 12', coords = vec3(-1122.21, -1046.29, 2.15)},
    {name = 'Imagination Ct 13', coords = vec3(-1161.19, -1099.90, 2.22)},
    {name = 'Del Perro Fwy 1', coords = vec3(-1750.64, -697.34, 10.18)},
    {name = 'Del Perro Fwy 2', coords = vec3(-1770.76, -677.70, 10.39)},
    {name = 'Magellan Ave 1', coords = vec3(-1788.07, -672.04, 10.65)},
    {name = 'Magellan Ave 2', coords = vec3(-1793.45, -663.90, 10.60)},
    {name = 'Magellan Ave 3', coords = vec3(-1816.83, -636.73, 10.94)},
    {name = 'Magellan Ave 4', coords = vec3(-1821.15, -626.84, 11.15)},
    {name = 'Magellan Ave 5', coords = vec3(-1836.50, -631.77, 10.75)},
    {name = 'Del Perro Fwy 3', coords = vec3(-1869.50, -590.61, 11.86)},
    {name = 'Del Perro Fwy 4', coords = vec3(-1865.02, -594.38, 11.84)},
    {name = 'Del Perro Fwy 5', coords = vec3(-1871.31, -589.13, 11.87)},
    {name = 'Del Perro Fwy 6', coords = vec3(-1877.07, -584.40, 11.85)},
    {name = 'Del Perro Fwy 7', coords = vec3(-1882.97, -578.45, 11.82)},
    {name = 'Del Perro Fwy 8', coords = vec3(-1901.44, -586.12, 11.87)},
    {name = 'Del Perro Fwy 9', coords = vec3(-1898.50, -572.41, 11.85)},
    {name = 'Del Perro Fwy 10', coords = vec3(-1917.72, -558.74, 11.85)},
    {name = 'Del Perro Fwy 11', coords = vec3(-1918.45, -542.56, 11.82)},
    {name = 'Del Perro Fwy 12', coords = vec3(-1944.63, -527.65, 11.82)},
    {name = 'Del Perro Fwy 13', coords = vec3(-1949.84, -523.27, 11.84)},
    {name = 'Del Perro Fwy 14', coords = vec3(-1965.64, -509.96, 11.83)},
    {name = 'Del Perro Fwy 15', coords = vec3(-1961.15, -513.46, 11.83)},
    {name = 'Del Perro Fwy 16', coords = vec3(-1977.63, -508.95, 11.85)},
    {name = 'North Rockford Dr 1', coords = vec3(-1873.27, 202.11, 84.36)},
    {name = 'North Rockford Dr 2', coords = vec3(-1906.23, 252.64, 86.25)},
    {name = 'North Rockford Dr 3', coords = vec3(-1922.34, 298.48, 89.29)},
    {name = 'North Rockford Dr 4', coords = vec3(-1931.64, 362.53, 93.79)},
    {name = 'North Rockford Dr 5', coords = vec3(-1941.03, 387.20, 96.51)},
    {name = 'North Rockford Dr 6', coords = vec3(-1943.52, 449.48, 102.93)},
    {name = 'North Rockford Dr 7', coords = vec3(-1937.98, 551.40, 114.83)},
    {name = 'North Rockford Dr 8', coords = vec3(-1929.08, 595.37, 122.28)},
    {name = 'North Rockford Dr 9', coords = vec3(-1896.29, 642.39, 130.21)},
    {name = 'North Rockford Dr 10', coords = vec3(-1974.45, 630.78, 122.54)},
    {name = 'North Rockford Dr 11', coords = vec3(-1995.78, 590.97, 117.90)},
    {name = 'North Rockford Dr 12', coords = vec3(-2014.89, 499.86, 107.17)},
    {name = 'North Rockford Dr 13', coords = vec3(-2011.13, 445.00, 103.02)},
    {name = 'North Rockford Dr 14', coords = vec3(-2008.49, 367.45, 94.81)},
    {name = 'North Rockford Dr 15', coords = vec3(-1995.35, 300.75, 91.96)},
    {name = 'North Rockford Dr 16', coords = vec3(-1969.87, 246.24, 87.06)},
    {name = 'North Rockford Dr 17', coords = vec3(-1960.46, 212.33, 86.00)},
    {name = 'North Rockford Dr 18', coords = vec3(-1931.38, 163.20, 84.00)},
    {name = 'North Rockford Dr 19', coords = vec3(-1898.58, 132.90, 81.33)},
    {name = 'North Rockford Dr 20', coords = vec3(-1861.71, 309.89, 88.37)},
    {name = 'Richman St 1', coords = vec3(-1808.23, 333.75, 88.82)},
    {name = 'Richman St 2', coords = vec3(-1742.37, 364.82, 88.08)},
    {name = 'Richman St 3', coords = vec3(-1672.92, 386.35, 88.70)},
    {name = 'Ace Jones Dr 1', coords = vec3(-1804.86, 437.14, 128.12)},
    {name = 'Didion Dr 2', coords = vec3(-72.84, 427.88, 112.54)},
    {name = 'Didion Dr 3', coords = vec3(-349.72, 514.03, 120.15)},
    {name = 'Didion Dr 4', coords = vec3(-386.32, 504.87, 119.91)},
    {name = 'Didion Dr 5', coords = vec3(-378.13, 548.17, 123.44)},
    {name = 'Didion Dr 6', coords = vec3(-418.40, 568.19, 124.56)},
    {name = 'Didion Dr 7', coords = vec3(-459.23, 537.93, 120.95)},
    {name = 'Didion Dr 8', coords = vec3(-500.25, 553.71, 119.64)},
    {name = 'Milton Rd 1', coords = vec3(-519.84, 594.26, 120.34)},
    {name = 'Didion Dr 9', coords = vec3(-475.12, 585.93, 128.18)},
    {name = 'Milton Rd 2', coords = vec3(-514.81, 628.27, 132.95)},
    {name = 'Milton Rd 3', coords = vec3(-522.34, 628.54, 137.48)},
    {name = 'Normandy Dr 1', coords = vec3(-564.39, 684.29, 145.80)},
    {name = 'Normandy Dr 2', coords = vec3(-605.80, 673.34, 150.85)},
    {name = 'Hillcrest Ave 1', coords = vec3(-662.28, 679.15, 153.42)},
    {name = 'Hillcrest Ave 2', coords = vec3(-700.69, 647.54, 154.68)},
    {name = 'Hillcrest Ave 3', coords = vec3(-668.68, 638.23, 149.03)},
    {name = 'Hillcrest Ave 4', coords = vec3(-686.69, 596.80, 143.20)},
    {name = 'Hillcrest Ave 5', coords = vec3(-703.89, 589.60, 141.48)},
    {name = 'Hillcrest Ave 6', coords = vec3(-732.64, 594.57, 141.45)},
    {name = 'Hillcrest Ave 7', coords = vec3(-752.16, 620.40, 141.88)},
    {name = 'Hillcrest Ave 8', coords = vec3(-764.95, 650.79, 145.10)},
    {name = 'Hillcrest Ave 9', coords = vec3(-819.40, 696.92, 147.61)},
    {name = 'Hillcrest Ave 10', coords = vec3(-852.80, 695.31, 148.40)},
    {name = 'Hillcrest Ave 11', coords = vec3(-885.30, 699.74, 150.78)},
    {name = 'Hillcrest Ave 12', coords = vec3(-908.49, 694.59, 150.93)},
    {name = 'Hillcrest Ave 13', coords = vec3(-931.45, 691.33, 152.97)},
    {name = 'Hillcrest Ave 14', coords = vec3(-973.88, 684.65, 157.54)},
    {name = 'Hillcrest Ave 15', coords = vec3(-996.84, 681.98, 159.99)},
    {name = 'Hillcrest Ave 16', coords = vec3(-1019.65, 718.62, 163.50)},
    {name = 'Hillcrest Ave 17', coords = vec3(-1055.92, 761.71, 167.00)},
    {name = 'North Sheldon Ave 1', coords = vec3(-997.87, 768.84, 170.92)},
    {name = 'North Sheldon Ave 2', coords = vec3(-972.60, 752.76, 175.88)},
    {name = 'North Sheldon Ave 3', coords = vec3(-962.93, 813.40, 177.16)},
    {name = 'North Sheldon Ave 4', coords = vec3(-912.67, 778.12, 186.42)},
    {name = 'North Sheldon Ave 5', coords = vec3(-867.43, 785.60, 191.43)},
    {name = 'North Sheldon Ave 6', coords = vec3(-824.22, 806.72, 202.18)},
    {name = 'Normandy Dr 3', coords = vec3(-747.14, 808.52, 214.53)},
    {name = 'Normandy Dr 4', coords = vec3(-655.38, 803.68, 198.50)},
    {name = 'Normandy Dr 5', coords = vec3(-595.13, 780.80, 188.64)},
    {name = 'Normandy Dr 6', coords = vec3(-597.34, 763.63, 188.70)},
    {name = 'Normandy Dr 7', coords = vec3(-645.78, 740.50, 173.78)},
    {name = 'Normandy Dr 8', coords = vec3(-579.84, 733.57, 183.71)},
    {name = 'Normandy Dr 9', coords = vec3(-566.37, 761.71, 184.93)},
    {name = 'Normandy Dr 10', coords = vec3(-599.45, 806.41, 190.67)},
    {name = 'Milton Rd 4', coords = vec3(-658.42, 887.01, 228.78)},
    {name = 'Milton Rd 5', coords = vec3(-597.47, 852.08, 210.90)},
    {name = 'Milton Rd 6', coords = vec3(-536.68, 818.17, 197.58)},
    {name = 'Milton Rd 7', coords = vec3(-494.74, 796.45, 183.85)},
    {name = 'Milton Rd 8', coords = vec3(-495.16, 739.19, 162.53)},
    {name = 'Milton Rd 9', coords = vec3(-533.06, 708.38, 152.35)},
    {name = 'Kimble Hill Dr 1', coords = vec3(-476.57, 648.13, 143.89)},
    {name = 'Kimble Hill Dr 2', coords = vec3(-445.74, 686.16, 152.45)},
    {name = 'Kimble Hill Dr 3', coords = vec3(-400.23, 665.49, 163.33)},
    {name = 'Kimble Hill Dr 4', coords = vec3(-340.76, 626.03, 170.86)},
    {name = 'Kimble Hill Dr 5', coords = vec3(-353.27, 667.52, 168.58)},
    {name = 'Kimble Hill Dr 6', coords = vec3(-308.28, 643.01, 175.63)},
    {name = 'Kimble Hill Dr 7', coords = vec3(-293.36, 601.32, 181.08)},
    {name = 'Kimble Hill Dr 8', coords = vec3(-257.44, 632.61, 187.32)},
    {name = 'Kimble Hill Dr 9', coords = vec3(-232.47, 589.01, 189.94)},
    {name = 'Kimble Hill Dr 10', coords = vec3(-189.38, 617.55, 199.08)},
    {name = 'Kimble Hill Dr 11', coords = vec3(-126.78, 588.76, 204.12)},
    {name = 'Ace Jones Dr 2', coords = vec3(-1539.68, 421.30, 109.53)},
    {name = 'Ace Jones Dr 3', coords = vec3(-1496.50, 437.38, 112.01)},
    {name = 'Ace Jones Dr 4', coords = vec3(-1500.36, 522.41, 117.79)},
    {name = 'Ace Jones Dr 5', coords = vec3(-1454.22, 512.51, 117.21)},
    {name = 'Ace Jones Dr 6', coords = vec3(-1452.59, 545.80, 120.30)},
    {name = 'Hangman Ave 1', coords = vec3(-1405.71, 526.92, 123.35)},
    {name = 'Hangman Ave 2', coords = vec3(-1404.98, 561.70, 124.92)},
    {name = 'Hangman Ave 3', coords = vec3(-1366.73, 611.48, 133.43)},
    {name = 'Hangman Ave 4', coords = vec3(-1337.45, 606.03, 133.89)},
    {name = 'North Sheldon Ave 7', coords = vec3(-1277.52, 630.09, 143.26)},
    {name = 'North Sheldon Ave 8', coords = vec3(-1291.59, 649.71, 141.01)},
    {name = 'North Sheldon Ave 9', coords = vec3(-1248.15, 643.34, 142.16)},
    {name = 'North Sheldon Ave 10', coords = vec3(-1241.40, 673.68, 142.33)},
    {name = 'North Sheldon Ave 11', coords = vec3(-1219.19, 665.68, 143.95)},
    {name = 'North Sheldon Ave 12', coords = vec3(-1197.36, 693.53, 146.91)},
    {name = 'North Sheldon Ave 13', coords = vec3(-1165.18, 727.44, 155.11)},
    {name = 'North Sheldon Ave 14', coords = vec3(-1118.13, 762.15, 163.80)},
    {name = 'North Sheldon Ave 15', coords = vec3(-1130.72, 784.39, 163.40)},
    {name = 'North Sheldon Ave 16', coords = vec3(-1100.66, 797.07, 166.66)},
    {name = 'Mad Wayne Thunder Dr 1', coords = vec3(-1413.39, 462.50, 108.75)},
    {name = 'Mad Wayne Thunder Dr 2', coords = vec3(-1371.74, 444.17, 105.40)},
    {name = 'Mad Wayne Thunder Dr 3', coords = vec3(-1343.82, 481.34, 102.31)},
    {name = 'Mad Wayne Thunder Dr 4', coords = vec3(-1308.05, 449.76, 100.41)},
    {name = 'Mad Wayne Thunder Dr 5', coords = vec3(-1294.09, 454.88, 97.09)},
    {name = 'Mad Wayne Thunder Dr 6', coords = vec3(-1258.80, 447.02, 94.29)},
    {name = 'Mad Wayne Thunder Dr 7', coords = vec3(-1216.20, 458.77, 91.49)},
    {name = 'Mad Wayne Thunder Dr 8', coords = vec3(-1174.55, 440.31, 86.85)},
    {name = 'Mad Wayne Thunder Dr 9', coords = vec3(-1158.91, 481.43, 85.64)},
    {name = 'Mad Wayne Thunder Dr 10', coords = vec3(-1122.73, 485.76, 81.71)},
    {name = 'Mad Wayne Thunder Dr 11', coords = vec3(-1087.87, 479.27, 77.13)},
    {name = 'Mad Wayne Thunder Dr 12', coords = vec3(-1094.29, 427.28, 75.88)},
    {name = 'Cockingend Dr 1', coords = vec3(-1052.02, 431.64, 77.06)},
    {name = 'Cockingend Dr 2', coords = vec3(-1009.25, 479.68, 79.41)},
    {name = 'Cockingend Dr 3', coords = vec3(-1039.90, 508.07, 84.38)},
    {name = 'Cockingend Dr 4', coords = vec3(-1007.31, 513.28, 79.11)},
    {name = 'Cockingend Dr 5', coords = vec3(-987.43, 487.80, 81.78)},
    {name = 'Cockingend Dr 6', coords = vec3(-967.44, 510.32, 81.58)},
    {name = 'Cockingend Dr 7', coords = vec3(-950.59, 464.74, 80.80)},
    {name = 'Cockingend Dr 8', coords = vec3(-971.16, 455.95, 79.81)},
    {name = 'Cockingend Dr 9', coords = vec3(-968.35, 436.50, 80.57)},
    {name = 'South Mo Milton Dr 1', coords = vec3(-843.05, 466.65, 87.21)},
    {name = 'South Mo Milton Dr 2', coords = vec3(-875.70, 486.17, 87.33)},
    {name = 'South Mo Milton Dr 3', coords = vec3(-849.01, 509.23, 90.34)},
    {name = 'South Mo Milton Dr 4', coords = vec3(-883.79, 518.07, 91.96)},
    {name = 'South Mo Milton Dr 5', coords = vec3(-873.94, 562.33, 96.14)},
    {name = 'South Mo Milton Dr 6', coords = vec3(-907.50, 544.90, 100.20)},
    {name = 'South Mo Milton Dr 7', coords = vec3(-904.41, 587.81, 100.66)},
    {name = 'South Mo Milton Dr 8', coords = vec3(-924.63, 561.63, 99.95)},
    {name = 'South Mo Milton Dr 9', coords = vec3(-958.15, 607.02, 106.30)},
    {name = 'South Mo Milton Dr 10', coords = vec3(-974.32, 581.82, 103.13)},
    {name = 'South Mo Milton Dr 11', coords = vec3(-1022.63, 586.92, 103.43)},
    {name = 'South Mo Milton Dr 12', coords = vec3(-1107.52, 594.31, 104.45)},
    {name = 'South Mo Milton Dr 13', coords = vec3(-1090.50, 548.40, 103.15)},
    {name = 'South Mo Milton Dr 14', coords = vec3(-1125.46, 548.60, 102.57)},
    {name = 'South Mo Milton Dr 15', coords = vec3(-1146.50, 545.99, 101.82)},
    {name = 'South Mo Milton Dr 16', coords = vec3(-1167.11, 568.03, 101.35)},
    {name = 'South Mo Milton Dr 17', coords = vec3(-1193.07, 564.09, 100.34)},
    {name = 'South Mo Milton Dr 18', coords = vec3(-1277.67, 497.10, 97.41)},
    {name = 'Picture Perfect Drive 1', coords = vec3(-824.80, 422.28, 92.12)},
    {name = 'Picture Perfect Drive 2', coords = vec3(-762.17, 431.19, 100.19)},
    {name = 'Picture Perfect Drive 3', coords = vec3(-784.62, 459.36, 100.38)},
    {name = 'Picture Perfect Drive 4', coords = vec3(-717.99, 449.03, 106.91)},
    {name = 'Picture Perfect Drive 5', coords = vec3(-721.24, 490.01, 109.04)},
    {name = 'Picture Perfect Drive 6', coords = vec3(-678.96, 511.65, 113.53)},
    {name = 'Picture Perfect Drive 7', coords = vec3(-667.12, 472.01, 114.14)},
    {name = 'Picture Perfect Drive 8', coords = vec3(-641.07, 520.52, 109.88)},
    {name = 'Picture Perfect Drive 9', coords = vec3(-622.84, 489.16, 108.40)},
    {name = 'Picture Perfect Drive 10', coords = vec3(-580.49, 492.12, 108.90)},
    {name = 'Picture Perfect Drive 11', coords = vec3(-595.24, 530.28, 107.41)},
    {name = 'Milton Rd 10', coords = vec3(-536.98, 477.58, 102.75)},
    {name = 'Milton Rd 11', coords = vec3(-561.20, 403.05, 101.81)},
    {name = 'Milton Rd 12', coords = vec3(-595.62, 393.21, 101.43)},
    {name = 'Milton Rd 13', coords = vec3(-615.48, 398.26, 101.63)},
    {name = 'Cox Way 1', coords = vec3(-516.60, 433.48, 97.36)},
    {name = 'Cox Way 2', coords = vec3(-500.00, 398.40, 98.27)},
    {name = 'Didion Dr 10', coords = vec3(-477.39, 354.29, 104.15)},
    {name = 'Didion Dr 11', coords = vec3(-444.28, 343.18, 105.09)},
    {name = 'Didion Dr 12', coords = vec3(-409.39, 341.74, 108.43)},
    {name = 'Didion Dr 13', coords = vec3(-371.83, 343.40, 109.94)},
    {name = 'Didion Dr 14', coords = vec3(-328.08, 369.68, 110.01)},
    {name = 'Didion Dr 15', coords = vec3(-297.92, 380.36, 112.10)},
    {name = 'Didion Dr 16', coords = vec3(-240.08, 381.64, 111.94)},
    {name = 'Didion Dr 17', coords = vec3(-166.40, 424.43, 111.81)},
    {name = 'Didion Dr 18', coords = vec3(-214.09, 399.88, 111.30)},
    {name = 'Cox Way 3', coords = vec3(-305.19, 431.66, 110.31)},
    {name = 'Cox Way 4', coords = vec3(-355.81, 422.36, 110.50)},
    {name = 'Cox Way 5', coords = vec3(-400.95, 427.46, 111.86)},
    {name = 'Cox Way 6', coords = vec3(-450.89, 395.62, 104.78)},
    {name = 'Steele Way 1', coords = vec3(-1038.36, 221.74, 63.89)},
    {name = 'Steele Way 2', coords = vec3(-949.42, 196.72, 67.39)},
    {name = 'West Eclipse Blvd 1', coords = vec3(-902.46, 191.67, 68.96)},
    {name = 'Steele Way 3', coords = vec3(-998.14, 157.87, 61.77)},
    {name = 'Steele Way 4', coords = vec3(-971.23, 122.23, 56.57)},
    {name = 'Spanish Ave 1', coords = vec3(-913.54, 108.50, 55.03)},
    {name = 'West Eclipse Blvd 2', coords = vec3(-816.82, 178.10, 72.23)},
    {name = 'Edwood Way 1', coords = vec3(-830.39, 115.14, 56.03)},
    {name = 'Bay City Ave 1', coords = vec3(-1085.83, -1503.89, 5.71)},
    {name = 'Bay City Ave 2', coords = vec3(-1086.11, -1492.28, 5.12)},
    {name = 'Bay City Ave 3', coords = vec3(-1101.82, -1492.45, 4.41)},
    {name = 'Bay City Ave 4', coords = vec3(-1110.67, -1498.62, 4.20)},
    {name = 'Bay City Ave 5', coords = vec3(-1116.38, -1506.18, 3.94)},
    {name = 'Melanoma St 1', coords = vec3(-1086.90, -1529.95, 4.21)},
    {name = 'Melanoma St 2', coords = vec3(-1078.12, -1524.96, 4.43)},
    {name = 'Bay City Ave 6', coords = vec3(-1069.67, -1514.93, 4.71)},
    {name = 'Melanoma St 3', coords = vec3(-1058.16, -1539.89, 4.57)},
    {name = 'Melanoma St 4', coords = vec3(-1066.10, -1545.36, 4.43)},
    {name = 'Melanoma St 5', coords = vec3(-1076.85, -1553.93, 4.15)},
    {name = 'Melanoma St 6', coords = vec3(-1084.44, -1558.58, 4.15)},
    {name = 'Magellan Ave 6', coords = vec3(-1056.94, -1587.59, 4.13)},
    {name = 'Magellan Ave 7', coords = vec3(-1037.49, -1605.21, 4.50)},
    {name = 'Magellan Ave 8', coords = vec3(-1041.58, -1590.84, 4.51)},
    {name = 'Bay City Ave 7', coords = vec3(-1032.24, -1582.80, 4.72)},
    {name = 'Bay City Ave 8', coords = vec3(-1098.26, -1679.01, 3.88)},
    {name = 'Bay City Ave 9', coords = vec3(-1097.41, -1673.04, 8.39)},
    {name = 'Melanoma St 7', coords = vec3(-1114.81, -1577.55, 4.06)},
    {name = 'Magellan Ave 9', coords = vec3(-1083.16, -1631.58, 4.26)},
    {name = 'Bay City Ave 10', coords = vec3(-1070.10, -1653.52, 3.93)},
    {name = 'Magellan Ave 10', coords = vec3(-1075.41, -1645.44, 4.02)},
    {name = 'Magellan Ave 11', coords = vec3(-1093.65, -1608.28, 8.46)},
    {name = 'Banham Canyon Dr 1', coords = vec3(-2797.70, 1431.39, 100.93)},
    {name = 'Buen Vino Rd 1', coords = vec3(-2587.68, 1911.06, 167.02)},
    {name = 'Lake Vinewood Est 1', coords = vec3(-112.97, 986.11, 235.75)},
    {name = 'Lake Vinewood Est 2', coords = vec3(-151.73, 910.68, 235.66)},
    {name = 'Lake Vinewood Est 3', coords = vec3(-85.69, 834.89, 235.92)},
} ]]