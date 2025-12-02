return {
    defaultStressRelief = {
        min = 0,
        max = 4
    },
    ---@class anim
    ---@field clip string
    ---@field dict string
    ---@field flag number

    ---@class prop
    ---@field model string
    ---@field bone number
    ---@field pos vector3
    ---@field rot vector3

    ---@class stressRelief
    ---@field min number
    ---@field max number

    ---@class consumable
    ---@field min number
    ---@field max number
    ---@field anim anim?
    ---@field prop table?
    ---@field stressRelief table?

    ---@class consumableAlcohol : consumable
    ---@field alcoholLevel number?

    consumables = {
        ---@type table<string, consumable>
        food = {
            brownie = {
                min = 20,
                max = 21,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            bagel = {
                min = 20,
                max = 21,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            baconburger = {
                min = 10,
                max = 15,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
        },

        ---@type table<string, consumable>
        drink = {
            bubbletea = {
                min = 10,
                max = 15,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            coffee_frappuccino = {
                min = 10,
                max = 15,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            water_bottle = {
                min = 10,
                max = 15,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
        },

        ---@type table<string, consumableAlcohol>
        alcohol = {
            drink_beer = {
                min = 10,
                max = 15,
                stressRelief = {
                    min = 1,
                    max = 4
                },
                alcoholLevel = 0.25
            },
            drink_vodka = {
                min = 10,
                max = 15,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
        },
    },
}