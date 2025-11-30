local Config = {}

-- Items required to redeem the vehicle
Config.requiredItems = {
	'candy_red',
	'candy_pink',
	'candy_green',
	'candy_blue',
}

-- Vehicle spawn name to grant permanently to the player
Config.rewardVehicle = 'polycypherwagon'

-- Vehicle spawn location when trading candies
Config.vehicleSpawn = vec4(-1673.9747, -243.6507, 54.6337, 250.3737)

-- Ped interaction settings
Config.pedModel = 'u_m_y_zombie_01'
Config.pedCoords = vec4(-1677.9252, -248.1287, 54.4428, 282.0550)
Config.targetLabel = 'Trade candies for vehicle'

return Config