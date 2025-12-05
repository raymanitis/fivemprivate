Config = Config or {}

--[[ --------------------------------------------------------------------------
    Chopshop Mission PED Configuration

    - Change `coords` to move the PED.
    - Change `model` to whatever PED you want (can be a hash or model name).
    - If `enabled = false`, the PED won't spawn.
-----------------------------------------------------------------------------]]

Config.ChopshopPed = {
    enabled = true,

    -- Default PED model (replace with your own if you want)
    -- Example Mexican-style ped: csb_ramp_mex
    model = `csb_ramp_mex`,

    -- vec4(x, y, z, heading) - EDIT THIS TO YOUR DESIRED LOCATION
    -- This uses ox_lib's vec4 helper.
    coords = vec4(1187.6022, 2636.1753, 38.4018, 332.8315),
}


