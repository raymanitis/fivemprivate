local Config = require 'anti_afk/config'

RegisterServerEvent("ray-smallres:anti_afk", function()
    source = source
    if not Config.licenseID[GetPlayerIdentifierByType(source, 'license2')] then
        for _, v in pairs(Config.groups) do
            if not IsPlayerAceAllowed(source, v) then
                DropPlayer(source, "You have been kicked for inactivity.")
            end
        end
    end
end)