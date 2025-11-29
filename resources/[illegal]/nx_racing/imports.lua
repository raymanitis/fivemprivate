if not Config.fd_laptop then return end

local isServer = lib.context == 'server'
local appId = 'nx_racing'
local waiting = true

local function serverSide()
    CreateThread(function()
        while not GetResourceState("fd_laptop"):find("start") do
            Wait(500)
        end
        waiting = false

        local added, errorMessage = exports.fd_laptop:addCustomApp({
            id = appId,
            name = "Racing",
            isDefaultApp = true,
            needsUpdate = false,
            icon = 'racing.svg',
            ui = ("https://cfx-nui-%s/web/build/index.html"):format(cache.resource),
            keepAlive = true,
            ignoreInternalLoading = true,
            windowActions = {
                isResizable = false,
                isMaximizable = false,
                isClosable = true,
                isMinimizable = false,
                isDraggable = false
            },
            windowDefaultStates = {
                isMaximized = true,
                isMinimized = false
            },
            onUseServer = function(source)
                SetTimeout(500, function()
                    TriggerClientEvent('nx_racing:client:openLaptop', source)
                end)
            end,
        })

        if not added then
            lib.print.error("Could not add laptop app: ", errorMessage)
        end
    end)
end

local function clientSide()
    local OriginalSendNUIMessage = SendNUIMessage

    function SetNuiFocus() end

    local eventsWithPasstrough = {
        ['setVisibleLaptop'] = true,
        ['setLoadingTablet'] = true,
        ['setRacerInfo'] = true,
        ['setPlayerLeaderboard'] = true,
        ['setInRace'] = true,
        ['setCanCreateTracks'] = true,
        ['setCanStartRaces'] = true,
        ['laptop'] = true,
        ['admin'] = true,
    }

    local eventsThroughBoth = {
        ['setLocales'] = true,
    }

    function SendNUIMessage(data)
        if eventsWithPasstrough[data.action] then
            return exports.fd_laptop:sendAppMessage(appId, data)
        end
        if eventsThroughBoth[data.action] then
            exports.fd_laptop:sendAppMessage(appId, data)
        end
        return OriginalSendNUIMessage(data)
    end
end

if isServer then
    serverSide()
    AddEventHandler('onResourceStart', function(resourceName)
        if resourceName ~= "fd_laptop" then return end
        if waiting then return end
        waiting = true

        serverSide()
    end)
else
    clientSide()
end