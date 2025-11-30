local postals = require 'postal/config'

CreateThread(function()
    ReplaceHudColourWithRgba(142, 34, 139, 230, 255)
    --postals = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
    --postals = json.decode(postals)
    --for i, postal in ipairs(postals) do postals[i] = { vec2(postal.x, postal.y), code = postal.code } end
end)

RegisterNetEvent("postalCode:setPoint")
AddEventHandler("postalCode:setPoint", function(postalCode)
    local setPostal = postals[tostring(postalCode)]
    if setPostal then
        SetNewWaypoint(setPostal.x, setPostal.y)
        lib.notify({ 
            description = "GPS set to postal code: ".. postalCode,
            type = 'success'
        })
    else
        lib.notify({ 
            description = "This postal code doesn't exist!",
            type = 'error'
        })
    end
end)