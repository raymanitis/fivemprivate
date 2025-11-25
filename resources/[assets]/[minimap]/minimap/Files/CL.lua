local replacement = {
  ["TITLE"] = "FE_THDR_GTAO",
  ["MAP"] = "PM_SCR_MAP",
  ["GAME"] = "PM_SCR_GAM",
  ["LEAVE"] = "PM_PANE_LEAVE",
  ["QUIT"] = "PM_PANE_QUIT",
  ["INFO"] = "PM_SCR_INF",
  ["STATS"] = "PM_SCR_STA",
  ["SETTINGS"] = "PM_SCR_SET",
  ["GALLERY"] = "PM_SCR_GAL",
  ["KEYBIND"] = "PM_PANE_CFX",
  ["EDITOR"] = "PM_SCR_RPL",
}

CreateThread(function()
  
  SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
  SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
  SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
  SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
  SetMapZoomDataLevel(4, 24.3, 0.9, 0.08, 0.0, 0.0)
  SetMapZoomDataLevel(5, 55.0, 0.0, 0.1, 2.0, 1.0)
  SetMapZoomDataLevel(6, 450.0, 0.0, 0.1, 1.0, 1.0)
  SetMapZoomDataLevel(7, 4.5, 0.0, 0.0, 0.0, 0.0)
  SetMapZoomDataLevel(8, 11.0, 0.0, 0.0, 2.0, 3.0)

  while true do
    Wait(80)
    local ped = PlayerPedId()
    if IsPedOnFoot(ped) then
      SetRadarZoom(1200)
    elseif IsPedInAnyVehicle(ped, true) then
      SetRadarZoom(1200)
    end
  end
end)

CreateThread(function()
  if Config.Options.ChangeHeaderNames then
    for key, value in pairs(Config.Options.Header) do
      if replacement[key] then
        AddTextEntry(replacement[key], value)
      end
    end
  end

  -- Apply color changes if enabled
  if Config.Options.enableColorChanges then
    ReplaceHudColourWithRgba(116,
      Config.Options.RedGreenBlueAlpha.HudLineColor["RED"],
      Config.Options.RedGreenBlueAlpha.HudLineColor["GREEN"],
      Config.Options.RedGreenBlueAlpha.HudLineColor["BLUE"],
      Config.Options.RedGreenBlueAlpha.HudLineColor["ALPHA"]
    )

    ReplaceHudColourWithRgba(117,
      Config.Options.RedGreenBlueAlpha.PauseMenuStyleColor["RED"],
      Config.Options.RedGreenBlueAlpha.PauseMenuStyleColor["GREEN"],
      Config.Options.RedGreenBlueAlpha.PauseMenuStyleColor["BLUE"],
      Config.Options.RedGreenBlueAlpha.PauseMenuStyleColor["ALPHA"]
    )

    ReplaceHudColourWithRgba(142,
      Config.Options.RedGreenBlueAlpha.MapWaypointColor["RED"],
      Config.Options.RedGreenBlueAlpha.MapWaypointColor["GREEN"],
      Config.Options.RedGreenBlueAlpha.MapWaypointColor["BLUE"],
      Config.Options.RedGreenBlueAlpha.MapWaypointColor["ALPHA"]
    )
  end

  if Config.Options.enableBackground then
    RequestStreamedTextureDict('xminimap_200_200', true)

    while not HasStreamedTextureDictLoaded("xminimap_200_200") do
      Wait(100)
    end

    while true do
      if IsPauseMenuActive() then
        SetScriptGfxDrawBehindPausemenu(true)
        DrawSprite("xminimap_200_200", 'maincolor', 0.5, 0.5, 1.0, 1.0, 0, 255, 255, 255, Config.Options.opacity)
        PushScaleformMovieFunctionParameterBool(true)
        if Config.Options.ChangeHeaderNames then
          BeginScaleformMovieMethodOnFrontendHeader("SET_HEADING_DETAILS")
          PushScaleformMovieFunctionParameterString(Config.Options.Header['SERVER_NAME'])
          PushScaleformMovieFunctionParameterString(Config.Options.Header['SERVER_TEXT'])
          PushScaleformMovieFunctionParameterString(Config.Options.Header['SERVER_DISCORD'])
        end
        ScaleformMovieMethodAddParamBool(false)
        EndScaleformMovieMethod()
        Wait(3)
      else
        SetStreamedTextureDictAsNoLongerNeeded('xminimap_200_200')
        Wait(150)
      end
    end
  end
end)

function AddTextEntry(key, value)
  Citizen.InvokeNative(0x32CA01C3, key, value)
end

CreateThread(function()
  while true do
    SetRadarAsExteriorThisFrame()
    local coords = vec(4700.0, -5145.0)
    SetRadarAsInteriorThisFrame(`h4_fake_islandx`, coords.x, coords.y, 0, 0)
    Wait(0)
  end
end)