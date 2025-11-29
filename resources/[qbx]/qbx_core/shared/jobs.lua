---Job names must be lower case (top level table key)
---@type table<string, Job>
return {
    ['unemployed'] = {
        label = 'Civilian',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Freelancer',
                payment = 10
            },
        },
    },
    ['police'] = {
        label = 'LSPD',
        type = 'leo',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Officer',
                payment = 75
            },
            [2] = {
                name = 'Sergeant',
                payment = 100
            },
            [3] = {
                name = 'Lieutenant',
                payment = 125
            },
            [4] = {
                name = 'Chief',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['ambulance'] = {
        label = 'EMS',
        type = 'ems',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Paramedic',
                payment = 75
            },
            [2] = {
                name = 'Doctor',
                payment = 100
            },
            [3] = {
                name = 'Surgeon',
                payment = 125
            },
            [4] = {
                name = 'Chief',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['realestate'] = {
        label = 'Real Estate',
        type = 'realestate',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'House Sales',
                payment = 75
            },
            [2] = {
                name = 'Business Sales',
                payment = 100
            },
            [3] = {
                name = 'Broker',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['mechanic'] = {
        label = 'Mechanic',
        type = 'mechanic',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Novice',
                payment = 75
            },
            [2] = {
                name = 'Experienced',
                payment = 100
            },
            [3] = {
                name = 'Advanced',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },

    -- 17 mov darbi 
    
    ['builder'] = {
        label = 'Builder',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Worker',
                payment = 50
            },
        },
    },

    ['garbage'] = {
        label = 'Garbage Collector',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Worker',
                payment = 50
            },
        },
    },
    ['gruppe6'] = {
        label = 'Gruppe 6',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Worker',
                payment = 50
            },
        },
    },
    ['lumberjack'] = {
        label = 'Lumberjack',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Worker',
                payment = 50
            },
        },
    },
    ['miner'] = {
        label = 'Miner',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Worker',
                payment = 50
            },
        },
    },
    ['oilrig'] = {
        label = 'Oil Rig Worker',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Worker',
                payment = 50
            },
        },
    },
}
