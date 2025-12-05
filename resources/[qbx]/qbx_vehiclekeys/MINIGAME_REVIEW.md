# Minigame Review - Vehicle Lockpicking & Hotwiring

## Overview
This script uses `ox_lib` skill minigames (via `lib.skillCheck()`) for two scenarios:
1. **Lockpicking Vehicle Doors** - When outside the vehicle
2. **Hotwiring Vehicle Ignition** - When inside the vehicle in driver seat

---

## 1. Lockpick Vehicle Door Minigame

### Location
**File:** `client/functions.lua`  
**Function:** `LockpickDoor()`  
**Line:** 193

### Code Snippet
```lua
193:        local isSuccess = customChallenge or lib.skillCheck(skillCheckConfig.difficulty, skillCheckConfig.inputs)
```

### Full Function Context
```lua
161:function LockpickDoor(isAdvancedLockedpick, maxDistance, customChallenge)
162:    maxDistance = maxDistance or 2
163:    local pedCoords = GetEntityCoords(cache.ped)
164:    local vehicle = lib.getClosestVehicle(pedCoords, maxDistance * 2, false)
165:
166:    if not vehicle then return end
167:
168:    local isDriverSeatFree = IsVehicleSeatFree(vehicle, -1)
169:
170:    if GetVehicleDoorLockStatus(vehicle) < 2 then exports.qbx_core:Notify(locale('notify.vehicle_is_unlocked'), 'error') return end
171:
172:    --- player may attempt to open the lock if:
173:    if not isDriverSeatFree -- no one in the driver's seat
174:        or not getIsCloseToAnyBone(pedCoords, vehicle, doorBones, maxDistance) -- the player's ped is close enough to the driver's door
175:        or GetVehicleConfig(vehicle).lockpickImmune
176:    then return end
177:
178:    local skillCheckConfig = config.skillCheck[isAdvancedLockedpick and 'advancedLockpick' or 'lockpick']
179:
180:    skillCheckConfig = skillCheckConfig.model[GetEntityModel(vehicle)]
181:        or skillCheckConfig.class[GetVehicleClass(vehicle)]
182:        or skillCheckConfig.default
183:    if not next(skillCheckConfig) then return end
184:
185:    if islockpickingProcessLocked then return end
186:    islockpickingProcessLocked = true
187:
188:    CreateThread(function()
189:        local anim = config.anims.lockpick.model[GetEntityModel(vehicle)]
190:            or config.anims.lockpick.class[GetVehicleClass(vehicle)]
191:            or config.anims.lockpick.default
192:        lib.playAnim(cache.ped, anim.dict, anim.clip, 3.0, 3.0, -1, 16, 0, false, false, false)
193:        local isSuccess = customChallenge or lib.skillCheck(skillCheckConfig.difficulty, skillCheckConfig.inputs)
194:
195:        if getIsVehicleInRange(vehicle, maxDistance) then
196:            lockpickCallback(vehicle, isAdvancedLockedpick, isSuccess)
197:        end
198:
199:        Wait(config.lockpickCooldown)
200:        islockpickingProcessLocked = false
201:    end)
202:end
```

### Triggered By
**File:** `client/main.lua`  
**Line:** 199
```lua
188:RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced)
189:    local vehicle = cache.vehicle
190:    if vehicle then
191:        if GetKeySearchEnabled() then
192:            DisableKeySearch()
193:            Hotwire(vehicle, isAdvanced)
194:            EnableKeySearch()
195:        else
196:            Hotwire(vehicle, isAdvanced)
197:        end
198:    else
199:        LockpickDoor(isAdvanced)
200:    end
201:end)
```

### Minigame Configuration
**File:** `config/client.lua`  
**Lines:** 107-118 (normal lockpick), 119-128 (advanced lockpick)

#### Normal Lockpick Config:
- **Default:** `normalLockpickSkillCheck` (4 inputs: '1', '2', '3', '4')
- **Difficulty:** ['easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'medium']
- **Vehicle Class Overrides:**
  - Planes/Helicopters/Emergency: Hard difficulty
  - Open Wheel: Easy difficulty
  - Military/Trains: Cannot be lockpicked (empty config)

#### Advanced Lockpick Config:
- **Default:** `easyLockpickSkillCheck` (3 inputs: '1', '2', '3')
- **Difficulty:** ['easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'medium']
- **Vehicle Class Overrides:** Same as normal lockpick

---

## 2. Hotwire Vehicle Ignition Minigame

### Location
**File:** `client/functions.lua`  
**Function:** `Hotwire()`  
**Line:** 248

### Code Snippet
```lua
248:        local isSuccess = customChallenge or lib.skillCheck(skillCheckConfig.difficulty, skillCheckConfig.inputs)
```

### Full Function Context
```lua
231:function Hotwire(vehicle, isAdvancedLockedpick, customChallenge)
232:    if cache.seat ~= -1 or GetIsVehicleAccessible(vehicle) then return end
233:    local skillCheckConfig = config.skillCheck[isAdvancedLockedpick and 'advancedHotwire' or 'hotwire']
234:
235:    skillCheckConfig = skillCheckConfig.model[GetEntityModel(vehicle)]
236:        or skillCheckConfig.class[GetVehicleClass(vehicle)]
237:        or skillCheckConfig.default
238:    if not next(skillCheckConfig) then return end
239:
240:    if isHotwiringProcessLocked then return end
241:    isHotwiringProcessLocked = true
242:
243:    CreateThread(function()
244:        local anim = config.anims.hotwire.model[GetEntityModel(vehicle)]
245:        or config.anims.hotwire.class[GetVehicleClass(vehicle)]
246:        or config.anims.hotwire.default
247:        lib.playAnim(cache.ped, anim.dict, anim.clip, 3.0, 3.0, -1, 16, 0, false, false, false)
248:        local isSuccess = customChallenge or lib.skillCheck(skillCheckConfig.difficulty, skillCheckConfig.inputs)
249:
250:        hotwireCallback(vehicle, isAdvancedLockedpick, isSuccess)
251:
252:        Wait(config.hotwireCooldown)
253:        isHotwiringProcessLocked = false
254:    end)
255:end
```

### Triggered By
**File:** `client/main.lua`  
**Line:** 193 or 196
```lua
188:RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced)
189:    local vehicle = cache.vehicle
190:    if vehicle then
191:        if GetKeySearchEnabled() then
192:            DisableKeySearch()
193:            Hotwire(vehicle, isAdvanced)
194:            EnableKeySearch()
195:        else
196:            Hotwire(vehicle, isAdvanced)
197:        end
198:    else
199:        LockpickDoor(isAdvanced)
200:    end
201:end)
```

### Minigame Configuration
**File:** `config/client.lua`  
**Lines:** 130-141 (normal hotwire), 142-152 (advanced hotwire)

#### Normal Hotwire Config:
- **Default:** `normalLockpickSkillCheck` (4 inputs: '1', '2', '3', '4')
- **Difficulty:** ['easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'medium']
- **Vehicle Class Overrides:**
  - Planes/Helicopters/Emergency: Hard difficulty
  - Open Wheel: Easy difficulty
  - Military/Trains: Cannot be hotwired (empty config)

#### Advanced Hotwire Config:
- **Default:** `easyLockpickSkillCheck` (3 inputs: '1', '2', '3')
- **Difficulty:** ['easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'medium']
- **Vehicle Class Overrides:** Same as normal hotwire

---

## Skill Check Difficulty Definitions

**File:** `config/client.lua`  
**Lines:** 9-24

### Easy Lockpick Skill Check
```lua
difficulty = { 'easy', 'easy', { areaSize = 60, speedMultiplier = 1 }, 'medium' }
inputs = { '1', '2', '3' }
```

### Normal Lockpick Skill Check
```lua
difficulty = { 'easy', 'easy', { areaSize = 60, speedMultiplier = 1 }, 'medium' }
inputs = { '1', '2', '3', '4' }
```

### Hard Lockpick Skill Check
```lua
difficulty = { 'easy', 'easy', { areaSize = 60, speedMultiplier = 2 }, 'medium' }
inputs = { '1', '2', '3', '4' }
```

---

## Summary

### Lockpick Vehicle (Door) Minigame
- **Location:** `client/functions.lua:193`
- **Function:** `LockpickDoor()`
- **Config Source:** `config.skillCheck.lockpick` or `config.skillCheck.advancedLockpick`
- **Triggered When:** Player uses lockpick item while outside a locked vehicle

### Hotwire Vehicle (Ignition) Minigame
- **Location:** `client/functions.lua:248`
- **Function:** `Hotwire()`
- **Config Source:** `config.skillCheck.hotwire` or `config.skillCheck.advancedHotwire`
- **Triggered When:** Player uses lockpick item while inside vehicle in driver seat

Both minigames use the same difficulty system but can be configured independently for different vehicle types, classes, or models.

