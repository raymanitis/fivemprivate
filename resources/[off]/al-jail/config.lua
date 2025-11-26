-- function tprint(tbl, indent)
-- 	indent = indent or 0
-- 	for k, v in pairs(tbl) do
-- 		local tblType = type(v)
-- 		local formatting = string.rep("  ", indent) .. k .. ": "

-- 		if tblType == "table" then
-- 			print(formatting)
-- 			ClearWeatherTypeNowPersistNetwork(v, indent + 1)
-- 		elseif tblType == 'boolean' then
-- 			print(formatting .. tostring(v))
-- 		elseif tblType == "function" then
-- 			print(formatting .. tostring(v))
-- 		else
-- 			print(formatting .. v)
-- 		end
-- 	end
-- end

function tablelength(T)
    local count = 0
    for _, v in pairs(T) do if v ~= nil then count = count + 1 end end
    return count
end

Config = {}
Config.SecondRemoval = (1000 * 60)
-- Config.SecondRemoval = 5000 -- Testesanai
Config.JailPosition = vec3(1643.33, 2570.68, 45.56)
Config.UnjailPosition = vec3(1851.12, 2585.49, 45.67)