-- Releatonships --
Citizen.CreateThread(function()
    --  Relationship Types:
    --  0 = Companion
    --  1 = Respect
    --  2 = Like
    --  3 = Neutral
    --  4 = Dislike
    --  5 = Hate

    local PlayerHash = `PLAYER`
    local SetRelationshipBetweenGroups = SetRelationshipBetweenGroups
    while true do
        SetRelationshipBetweenGroups(3, `AMBIENT_GANG_HILLBILLY`, PlayerHash)
        SetRelationshipBetweenGroups(0, `AMBIENT_GANG_BALLAS`, PlayerHash)
        SetRelationshipBetweenGroups(0, `AMBIENT_GANG_MEXICAN`, PlayerHash)
        SetRelationshipBetweenGroups(0, `AMBIENT_GANG_FAMILY`, PlayerHash)
        SetRelationshipBetweenGroups(0, `AMBIENT_GANG_MARABUNTE`, PlayerHash)
        SetRelationshipBetweenGroups(0, `AMBIENT_GANG_SALVA`, PlayerHash)
        SetRelationshipBetweenGroups(0, `AMBIENT_GANG_LOST`, PlayerHash)
        SetRelationshipBetweenGroups(0, `GANG_1`, PlayerHash)
        SetRelationshipBetweenGroups(0, `GANG_2`, PlayerHash)
        SetRelationshipBetweenGroups(0, `GANG_9`, PlayerHash)
        SetRelationshipBetweenGroups(0, `GANG_10`, PlayerHash)
        SetRelationshipBetweenGroups(2, `FIREMAN`, PlayerHash)
        SetRelationshipBetweenGroups(2, `MEDIC`, PlayerHash)
        SetRelationshipBetweenGroups(3, `COP`, PlayerHash)
        SetRelationshipBetweenGroups(5, `PRISONER`, PlayerHash)
        Wait(1000)
    end
end)