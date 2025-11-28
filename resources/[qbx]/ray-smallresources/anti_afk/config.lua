local Config = {
    timeAFK = 1800, -- 30 minutes
    licenseID = { -- No kick licenses
        ["license2:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"] = true,
        ["license2:zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"] = true
    },
    groups = { -- No kick groups
        'mod',
        'admin'
    }
}

return Config