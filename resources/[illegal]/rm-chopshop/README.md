## rm-chopshop

Simple configurable chopshop job using `ox_lib`, `ox_target`, `ox_inventory` and optional `qbx_core`.

### Requirements

- **ox_lib**
- **ox_target**
- **ox_inventory**
- **(optional) qbx_core** for citizenid support and money rewards
- **MySQL** configured for `ox_lib` (`lib.mysql`) – used to store chopshop XP per citizenid

### Installation

- Put this resource in your server resources folder (e.g. `resources/[illegal]/rm-chopshop`).
- Ensure the resource **after** its dependencies, for example:

```lua
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qbx_core -- if you use Qbox/QBX
ensure rm-chopshop
```

### Configuration

- **Chopshop ped / location**
  - Edit `config/sv_config.lua` → `Config.ChopshopPed`:
    - `model`: ped model (e.g. ``csb_ramp_mex``)
    - `coords`: `vec4(x, y, z, heading)`

- **Delivery zone**
  - Edit `Config.ChopshopDeliveryZone` in `sv_config.lua` – 4 `vec3` points that form a rectangle where vehicles are delivered.

- **Contracts and vehicles**
  - Edit `config/config.lua` → `Config.ChopshopContracts`:
    - Classes: `A`, `B`, `C`, `D`
    - For each class:
      - `label`: display name
      - `vehicles`: list of vehicle model names
      - `minVehicles` / `maxVehicles`: random count of required vehicles per mission (clamped to the list size).

- **Rewards**
  - Edit `Config.ChopshopRewards` in `sv_config.lua`:
    - Per-class (`A`, `B`, `C`, `D`) config.
    - `items`: array of item rewards with:
      - `name`, `min`, `max`, `chance` (0–100).
    - `money`: optional:
      - `min`, `max`, `chance`, `account` (e.g. `cash`, `bank`, `black_money`).
    - You must plug actual money giving logic into the commented part in `server.lua` for your framework.

- **XP / Level system**
  - Edit `Config.ChopshopXP` in `sv_config.lua`:
    - `startXP`: starting XP for new players.
    - `classes[classKey]`:
      - `requiredXP`: XP needed to access that class (D, C, B, A).
      - `minXP` / `maxXP`: random XP gained when a contract of that class is completed.

### How it works (gameplay)

- Talk to the ped (Carlos) using `ox_target`.
- Choose to make money → accept the chop job.
- Script selects the **highest class you unlock** based on your chopshop XP.
- You receive an item `chopshop_contract` in `ox_inventory` with the contract info.
- Go to the delivery zone with a required vehicle:
  - Text UI shows `[E] Deliver vehicle`.
  - Press **E**:
    - A 3 minute progress circle runs (`Chopping vehicle...`).
    - On success the car is "stripped" and deleted, and your contract progress updates.
- When all contract vehicles are delivered:
  - You’re told to go back to Carlos.
  - Tell him you finished → rewards + XP are given and the contract item is removed.

### Database / XP persistence

- On resource start, the script automatically creates a table (if not existing):

```sql
CREATE TABLE IF NOT EXISTS rm_chopshop_xp (
    citizenid VARCHAR(64) NOT NULL PRIMARY KEY,
    xp INT NOT NULL DEFAULT 0
);
```

- XP is saved per **citizenid** (Qbox-style).
- On player drop and when XP changes, XP is persisted using `lib.mysql`.

### Exports

- **Get player XP by citizenid**

```lua
local xp = exports['rm-chopshop']:GetChopshopXP(citizenid)
```

- **Get player chopshop class by citizenid**

```lua
local class, xp = exports['rm-chopshop']:GetChopshopClass(citizenid)
-- class is one of 'D', 'C', 'B', 'A'
```

These exports are server-side and can be used in other resources to check a character’s chopshop level or gating other content.

