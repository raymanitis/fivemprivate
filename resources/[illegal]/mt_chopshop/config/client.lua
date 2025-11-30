return {
    debug = false,

    textUIPos = 'top-center',
    Key = 38,

    policeAlertChance = true, -- Place here the chance to call police (in percentage) or place false to disable it

    destroyPartTime = 5000,
    useMinigame = true,

    chopshopZones = {
        {
            blip = {
                enabled = false,
                sprite = 68,
                color = 0,
                scale = 0.6,
                display = 4,
                label = 'Sandy Shores',
                coords = vec3(2707.6416, 4134.2603, 43.8940),
            },
            points = {
                vec3(2698.3462, 4125.8467, 42.0),
                vec3(2720.7268, 4121.5195, 42.0),
                vec3(2726.3545, 4150.1274, 42.0),
                vec3(2697.3960, 4149.1968, 42.0),
            },
            thickness = 10.0,
            machine = {
                coords = vec4(2707.6416, 4134.2603, 42.8940, 292.2094+180),
                propname = 'gr_prop_gr_vertmill_01a',
            }
        },
        {
            blip = {
                enabled = false,
                sprite = 68,
                color = 0,
                scale = 0.6,
                display = 4,
                label = 'Vinewood',
                coords = vec3(515.3065, 167.7385, 99.3685),
            },
            points = {
                vec3(530.4636, 160.8515, 98.0),
                vec3(532.7673, 168.9278, 98.0),
                vec3(515.6038, 175.1074, 98.0),
                vec3(512.7119, 167.7469, 98.0)
            },
            thickness = 10.0,
            machine = {
                coords = vec4(515.3065, 167.7385, 98.3685, 306.5148+180),
                propname = 'gr_prop_gr_vertmill_01a',
            }
        },
        {
            blip = {
                enabled = false,
                sprite = 68,
                color = 0,
                scale = 0.6,
                display = 4,
                label = 'Vepucci',
                coords = vec3(-864.5042, -1096.9215, 2.1630),
            },
            points = {
                vec3(-860.7031, -1105.8759, 1.0),
                vec3(-848.6877, -1097.6552, 1.0),
                vec3(-859.6498, -1075.0159, 1.0),
                vec3(-875.5047, -1083.8007, 1.0)
            },
            thickness = 10.0,
            machine = {
                coords = vec4(-864.5042, -1096.9215, 1.1630, 333.6124+180),
                propname = 'gr_prop_gr_vertmill_01a',
            }
        },
        {
            blip = {
                enabled = false,
                sprite = 68,
                color = 0,
                scale = 0.6,
                display = 4,
                label = 'Paleto',
                coords = vec3(-298.3208, 6282.4697, 31.4923),
            },
            points = {
                vec3(-307.0458, 6286.8052, 30.0),
                vec3(-288.5699, 6268.3804, 30.0),
                vec3(-273.0142, 6280.5649, 30.0),
                vec3(-292.6175, 6301.1680, 30.0)
            },
            thickness = 10.0,
            machine = {
                coords = vec4(-298.3208, 6282.4697, 30.4923, 254.8047+180),
                propname = 'gr_prop_gr_vertmill_01a',
            }
        },
    },

    blacklisteVehicles = { -- place here the vehicles you want to not be able to scrap
        'phantom',
    },

    blacklistedVehiclesTypes = { -- place here the vehicles types you want to not be able to scrap
        'bike',
        'boat',
        'heli',
        'plane',
        'submarine',
        'trailer',
        'train'
    },

    bones = { -- Don't touch if you don't know what you doin
        { prop = 'prop_car_door_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, 0.0, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 56604, pos = vec3(0.0, 0.40, 0.1), rot = vec3(0.0, 0.0, 180.0) }, type = 'door', doorID = 0, id = 'door_dside_f', label = 'Door', pickAnim = { scenario = 'WORLD_HUMAN_WELDING' } },
        { prop = 'prop_car_door_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, 0.0, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 56604, pos = vec3(0.0, 0.40, 0.1), rot = vec3(0.0, 0.0, 180.0) }, type = 'door', doorID = 1, id = 'door_pside_f', label = 'Door', pickAnim = { scenario = 'WORLD_HUMAN_WELDING' } },
        { prop = 'prop_car_door_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, 0.0, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 56604, pos = vec3(0.0, 0.40, 0.1), rot = vec3(0.0, 0.0, 180.0) }, type = 'door', doorID = 2, id = 'door_dside_r', label = 'Door', pickAnim = { scenario = 'WORLD_HUMAN_WELDING' } },
        { prop = 'prop_car_door_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, 0.0, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 56604, pos = vec3(0.0, 0.40, 0.1), rot = vec3(0.0, 0.0, 180.0) }, type = 'door', doorID = 3, id = 'door_pside_r', label = 'Door', pickAnim = { scenario = 'WORLD_HUMAN_WELDING' } },
        { prop = 'imp_prop_impexp_bonnet_02a', duration = 5000, propPosOnMachine = { pos = vec3(0.0, -0.5, 1.1), rot = vec3(10.0, 0.0, 180.0) }, propPos = { bone = 56604, pos = vec3(0.0, 0.75, 0.0), rot = vec3(2.0, 10.0, 0.0) }, type = 'door', doorID = 4, id = 'bonnet', label = 'Boonet', pickAnim = { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 1 } },
        { prop = 'imp_prop_impexp_trunk_01a', duration = 5000, propPosOnMachine = { pos = vec3(0.0, 0.0, 1.2), rot = vec3(0.0, 0.0, 0.0) }, propPos = { bone = 56604, pos = vec3(0.0, 0.40, 0.1), rot = vec3(0.0, 0.0, 180.0) }, type = 'door', doorID = 5, id = 'boot', label = 'Boot', pickAnim = { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 1 } },
        { prop = 'prop_wheel_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, -0.4, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 60309, pos = vec3(-0.05, 0.16, 0.32), rot = vec3(-130.0, -55.0, 150.0) }, type = 'wheel', wheelID = 0, id = 'wheel_lf', label = 'Wheel', pickAnim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 } },
        { prop = 'prop_wheel_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, -0.4, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 60309, pos = vec3(-0.05, 0.16, 0.32), rot = vec3(-130.0, -55.0, 150.0) }, type = 'wheel', wheelID = 1, id = 'wheel_rf', label = 'Wheel', pickAnim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 } },
        { prop = 'prop_wheel_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, -0.4, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 60309, pos = vec3(-0.05, 0.16, 0.32), rot = vec3(-130.0, -55.0, 150.0) }, type = 'wheel', wheelID = 2, id = 'wheel_lr', label = 'Wheel', pickAnim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 } },
        { prop = 'prop_wheel_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, -0.4, 1.2), rot = vec3(90.0, 0.0, 0.0) }, propPos = { bone = 60309, pos = vec3(-0.05, 0.16, 0.32), rot = vec3(-130.0, -55.0, 150.0) }, type = 'wheel', wheelID = 3, id = 'wheel_rr', label = 'Wheel', pickAnim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 } },
        { prop = 'prop_car_engine_01', duration = 5000, propPosOnMachine = { pos = vec3(0.0, -0.7, 1.0), rot = vec3(0.0, 0.0, 0.0) }, propPos = { bone = 56604, pos = vec3(-0.07, 0.40, 0.0), rot = vec3(0.0, 0.0, 0.0) }, type = 'engine', wheelID = 3, id = 'engine', label = 'Engine', pickAnim = { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 1 } },
    }
}
