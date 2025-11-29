-- https://docs.nexure.dev/racing/configuration/config for more information.
-- https://docs.nexure.dev/racing/configuration/config for more information.
-- https://docs.nexure.dev/racing/configuration/config for more information.

return {
    debug = false,
    debugPrints = false,

    -- This won't import the tracks, those need to be imported manually. This will only create the tables and columns.
    autoSQL = {
        enabled = true,
        forced = false,
    },

    UIPosition = "top-left",
    paceNotesPadding = "3.25rem",
    -- These can be any valid CSS color.
    welcomeBackColors = { from = 'yellow', to = 'red' },

    fd_laptop = false,

    -- If you don't have fd_laptop, and don't have a inventory system setup, you can use this command to open the tablet. Set this to false to disable the command.
    command = "tablet",

    framework = "auto",

    useQBCoreInventory = false,

    -- If true, tracks will be automatically verified when they are created. Meaning no need for a staff member to verify them.
    autoVerifyTracks = false,

    phasingMode = "race",

    raceMoneyDistribution = "top",

    -- The minimum amount of players for MMR calculations and prize distribution to be enabled in a race. 
    minimumPlayersForCalculations = 2,

    -- Force the above mentioned minimum player count to even start a race. If true, and a race starts with less players than minimumPlayersForCalculations, then the race will be cancelled.
    forceMinimumPlayersUnranked = false,
    forceMinimumPlayersRanked = false,

    maxBuyIn = 10000,

    maxLaps = 5,

    -- The interval in milliseconds in which the camera will be checked for the player (in case a camera option is defined for a race).
    cameraCheckInterval = 1000,

    raceGeneration = {
        {
            -- Hour is 0-23, Minute is 0-59
            -- !!!
            -- !!! THIS IS BASED ON THE TIME OF YOUR SERVER, NOT YOUR LOCAL TIME. !!!
            -- !!!
            -- generationtmie and racestarttime needs to be in the same day, raceendtime can be in the next day.
            generationTime = { hour = 12, minute = 0 },
            raceStartTime = { hour = 13, minute = 0 },
            raceEndTime = { hour = 23, minute = 0 },
            timeBetweenRaces = 15, -- In minutes

            classes = {
                enabled = true, -- If false, any class will be able to compete in the competitive races.
                evenChances = false, -- If true, the classes will have an even chance of being selected.
                classes = { -- The chances used if uneven, should add up to 1. All classes mentioned are the default classes.
                    { class = 1, chance = 0.05 }, -- 1 - D Class
                    { class = 2, chance = 0.05 }, -- 2 - C Class
                    { class = 3, chance = 0.3 }, -- 3 - B Class
                    { class = 4, chance = 0.3 }, -- 4 - A Class
                    { class = 5, chance = 0.3 }, -- 5 - S Class
                }
            },

            moneyPrize = {
                -- In case an average lap time can't be found, this will be average time of a lap until there's enough data.
                fallbackLapLength = 5,

                -- Minimum and maximum amount of money that can be given per minute of a race.
                -- NOTE: This is not per driven minute of race, but per calculated average race length minute.
                rewardPerMinute = { min = 100, max = 250 },
            },
            laps = {
                min = 1,
                max = 3,
            },
            phasing = {
                enabled = true,
                time = 30,
            },
            cameraOption = {
                random = false,
                fixed = "unset"
            }
        }
    },

    vehicleClasses = {
        mode = "auto",

        -- If mode is manual, this will be the fallback class if the player doesn't have a class.
        manualFallbackClass = 1,
        allowLowerClassesWithHigherClasses = true,

        -- Table of classes, starts at 1 (the worst class) and the higher the number, the better the class.
        -- For example 1 - D Class, 2 - C Class, 3 - B Class, 4 - A Class, 5 - S Class
        classes = {
            { -- 1
                name = "D",
                title = "D Class",
                score = 350,
            },
            { -- 2
                name = "C",
                title = "C Class",
                score = 500,
            },
            { -- 3
                name = "B",
                title = "B Class",
                score = 650,
            },
            { -- 4
                name = "A",
                title = "A Class",
                score = 700,
            },
            { -- 5
                name = "S",
                title = "S Class",
                score = 900,
            },
        }
    },

    checkpointZones = {
        mode = "precise",
        cylinder = {
            dynamic = true,
            defaultSize = 30.0,
        },
        dynamicMultiplier = 2.0,
    },

    -- Default Race UI Style
    raceUiStyle = "advanced",

    -- If true, the resource will detect if a player has crossed the starting line before the race starts.
    -- If the race starts and a player has crossed the starting line, they will be removed from the race.
    startingLineDetection = true,

    -- The color of the marker that shows before
    -- the race has started. This marker shows the direction
    -- of where the first checkpoint is.
    markerShowingRaceDirectionColor = { r = 0, g = 0, b = 255, a = 100 },

    -- The interval in milliseconds in which the waypoint system will be updated. 
    -- Lower values will result in a smoother waypoint movement but will also increase the resource usage.
    -- Personally, I would recommend 50ms as the lowest value. Any lower causes high resource usage
    -- and doesn't really make a difference in the smoothness of the waypoint movement. If you
    -- need high performance, you can increase this value to 100ms or even higher.
    waypointUpdateInterval = 100,

    -- 
    -- THESE ARE DEFAULTS FOR SETTINGS THAT CAN BE CHANGED BY THE USER IN THE SETTINGS MENU.
    -- 
    paceNotesEnabled = true,
    waypointsEnabled = true,
    missedCheckpointDetection = true,
    -- 
    -- END OF DEFAULTS
    -- 

    props = {
        tablet = {
            prop = `prop_nx_racing_tablet`,
            dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base",
            anim = "base",
            bone = 60309,
            offset = vector3(0.03, 0.002, -0.0),
            rot = vector3(10.0, 0.0, 0.0),
        },

        -- If true, props will be dynamic and will be switched based on checkpoint state.
        -- If false, props will be static and will always be the prop thats defined as staticProp.
        dynamicProp = true,

        -- The prop that will be used if dynamicProp is false.
        staticProp = "bzzz_checkpoint_a",

        -- bzzz prop coloring
        -- a = pink,
        -- b = yellow,
        -- c = red,
        -- d = green,
        -- e = blue,

        props = {
            ["start"] = {
                ["gettingReady"] = "bzzz_start_c",
                ["ready"] = "bzzz_start_b",
                ["go"] = "bzzz_start_d",
            },

            ["checkpoint"] = {
                
                -- this is also the prop that will be shown as a placed checkpoint
                -- in the track creator
                ["nextCheckpoint"] = "bzzz_checkpoint_e",

                ["gottenCheckpoint"] = "bzzz_checkpoint_d",

                -- wrong as in checkpoint after the next checkpoint
                ["wrongCheckpoint"] = "bzzz_checkpoint_c",

                -- checkpoint after the wrong checkpoint which technically isn't possible
                -- this is also used as the prop which will be shown when placing a 
                -- checkpoint in the track creator
                ["fallbackCheckpoint"] = "bzzz_checkpoint_a",
            },
            
            ["finish"] = "bzz_finish_a",
        },
    },

    sounds = {
        ["checkpointMissed"] = {
            -- enabled = this is based on the config value missedCheckpointDetection, if that's true, this will be enabled.
            name = "CHECKPOINT_MISSED",
            ref = "HUD_MINI_GAME_SOUNDSET"
        },
        ["getCheckpoint"] = {
            enabled = true,
            name = "Radar_Hack_Button_Success",
            ref = "Cayo_Perico_Attrition_Mode_Sounds"
        },
        ["raceStarted"] = {
            enabled = false,
            name = "Enemy_Capture_Start",
            ref = "GTAO_Magnate_Yacht_Attack_Soundset"
        },
        ["raceEnded"] = {
            enabled = true,
            name = "Checkpoint_Finish",
            ref = "Island_Race_Soundset"
        },
        ["5secondCountdown"] = {
            enabled = true,
            name = "5s",
            ref = "MP_MISSION_COUNTDOWN_SOUNDSET"
        },

        -- Separated countdown sounds, I'm not aware of any good ones.
        ["redCountdown"] = {
            enabled = false,
            name = "10s",
            ref = "MP_MISSION_COUNTDOWN_SOUNDSET"
        },
        ["yellowCountdown"] = {
            enabled = false,
            name = "5s",
            ref = "MP_MISSION_COUNTDOWN_SOUNDSET"
        },
    },

    keybinds = {
        ["placeCheckpoint"] = {
            defaultKey = 'E',
            description = '(Racing) [Track Creator] Place Checkpoint',
        },
        ["removeLastCheckpoint"] = {
            defaultKey = 'LEFT',
            description = '(Racing) [Track Creator] Remove Last Checkpoint',
        },
        ["resetWidth"] = {
            defaultKey = 'RETURN',
            description = '(Racing) [Track Creator] Reset Width',
        },
        ["changeWidthUp"] = {
            defaultKey = 'UP',
            description = '(Racing) [Track Creator] Change Width Up',
        },
        ["changeWidthDown"] = {
            defaultKey = 'DOWN',
            description = '(Racing) [Track Creator] Change Width Down',
        },
        ["saveTrack"] = {
            defaultKey = 'RIGHT',
            description = '(Racing) [Track Creator] Save Track',
        },
        ["exitTrackCreator"] = {
            defaultKey = 'BACK',
            description = '(Racing) [Track Creator] Exit Track Creator',
        }
    },

    -- Time in ms to wait after each deleted entity/blip during cleanup. This can also be set to false to have no delay at all.
    -- For most this shouldn't be changed, but if you have a sensitive anticheat, you might want to increase this to avoid issues.
    waitTimeForCleanUp = false,

    -- If true, the tablet will be open by default when the script is loaded, for those who use customs laptops, etc.
    -- Don't enable this unless you know what you're doing.
    -- This will also make laptop mode forcefully enabled. So in case of not using fd_laptop, make sure imports.lua has been edited accordingly.
    laptopOpenByDefault = false,
}