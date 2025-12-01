Config = {
    ServerName = "Server", -- Server Name
    ServerLogo = "", -- Server Logo
    MainIdentifier = "license2", -- Identifier Type (steam, license, xbl, discord, ip)

    Webhooks = {
        ["deaths"] = "https://discord.com/api/webhooks/1444898564135456768/z3XKoCjKfellMqit0XtlMbcovW8eBptAEyMt6N1iCJEF-fKua2lM6ZreSpE1g5BxAHRR",
    }
}
/*
exports['server_logs']:CreateLog({
    category = "server-ac",
    title = payload.count .. "x " .. payload.fromSlot.name,
    action = "Total Cost - " .. payload.price * payload.count .. " EUR",
    color = "purple",
    players = {
        { id = playerId, role = "Player" },
    },
    info = {
        { name = "Name", value = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname },
        { name = "Job", value = player.PlayerData.job.label .. " - " .. player.PlayerData.job.grade.name },
    },
})
*/