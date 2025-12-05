Config = Config or {}

--[[ --------------------------------------------------------------------------
    Chopshop Mission PED Configuration

    - Change `coords` to move the PED.
    - Change `model` to whatever PED you want (can be a hash or model name).
    - If `enabled = false`, the PED won't spawn.
-----------------------------------------------------------------------------]]

Config.ChopshopPed = {
    enabled = true,

    -- Default PED model (you can replace with your "ve4 ped skin" model)
    -- Examples: "a_f_m_bevhills_01", "a_m_m_farmer_01", etc.
    model = `a_f_m_bevhills_01`,

    -- vec4(x, y, z, heading) - EDIT THIS TO YOUR DESIRED LOCATION
    -- This uses ox_lib's vec4 helper.
    coords = vec4(1187.6022, 2636.1753, 38.4018, 332.8315),
}


