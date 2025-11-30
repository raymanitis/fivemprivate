local Config = {}

-- Zones where /stuck is disabled
-- Each zone is a circle with a center and radius (in meters)
-- Example zone (uncomment and adjust):
-- {
-- 	label = "Mission Row PD",
-- 	center = vec3(441.2, -982.1, 30.7),
-- 	radius = 120.0
-- }
Config.StuckBlockedZones = {
	-- Define polygon zones using points (preferred). Example 4-point territory:
	{
		label = "Mission Row PD",
		points = {
			vec3(446.8585, -983.1715, 28.1505),
			vec3(446.8514, -997.5657, 28.2038),
			vec3(456.9839, -997.4716, 27.9662),
			vec3(456.9855, -983.2651, 27.9690)
		},
		minZ = 26.5,
		maxZ = 35.0
	}

	-- Or circular zones using center + radius:
	-- {
	-- 	label = "Mission Row PD",
	-- 	center = vec3(451.1371, -990.5491, 27.5120),
	-- 	radius = 120.0
	-- }
}

return Config
