---@diagnostic disable: duplicate-doc-alias, duplicate-doc-field

/*  

    All of the types that might help you in creating drugs.
    You need to have this vscode plugin to get the code suggestions: https://marketplace.visualstudio.com/items?itemName=overextended.cfxlua-vscode
    Also make sure to open the whole lunar_drugscreator folder in vscode otherwise this file won't load into the language server.

*/

---@class AnimPropData
---@field model string
---@field bone? number
---@field pos vector3
---@field rot vector3

---@class ServerConfig
---@field harvestingZones HarvestingZone[]
---@field processingZones ProcessingZone[]
---@field plants table<integer, Plant>
---@field lamps Lamp[]
---@field laboratories table<integer, Laboratory>
---@field processingTables ProcessingTable[]
---@field suppliers Supplier[]
---@field consumables Consumable[]
---@field pocketProcessing PocketProcessing[]
---@field retailSellingZones RetailSellingZone[]
---@field wholesaleSettings WholesaleSettings
---@field generalSettings GeneralSettings

---@class HarvestingZone
---@field label string
---@field duration number
---@field progress string
---@field model string|number
---@field interactionOffset vector3
---@field icon string
---@field errorMessage string?
---@field radius number
---@field requiredItem string?
---@field giveItems { name: string, amount: { min: number, max: number } }[]
---@field animation AnimProps?
---@field animationProp AnimPropData?
---@field maxSpawned number
---@field locations { coords: vector3, radius: number, interval: number }[]
---@field target boolean?

---@alias SyncedScene 'coke_cutting' | 'coke_packing_basic' | 'coke_packing_advanced' | 'coke_unpacking' | 'meth_breaking' | 'meth_packing' | 'meth_cooking' | 'weed_sorting_left' | 'weed_sorting_right' | 'weed_sorting_left_v2' | 'weed_sorting_right_v2'

---@class ProcessingZone
---@field label string
---@field icon string
---@field duration number
---@field progress string
---@field radius number
---@field errorMessage string?
---@field requiredItems { name: string, amount: number }[]
---@field giveItems { name: string, amount: { min: number, max: number } }[]
---@field animation AnimProps?
---@field animationProp AnimPropData?
---@field syncedScene SyncedScene?
---@field requiresLab integer[]
---@field locations { coords: vector3, animOrigin: vector4? }[]
---@field target boolean?

---@class Plant
---@field progressDuration number
---@field seedItem string
---@field waterItem string
---@field fertilizerItem string
---@field requiredItems { name: string, amount: number, removeAfterUse: boolean }[]
---@field stages { model: string|number, offsetZ: number? }[]
---@field grassOnly boolean 
---@field giveItem string
---@field giveSeedChance number
---@field maxGiveCount number will calculate based on amount of required items
---@field maxPerPlayer number?
---@field growthDuration number
---@field statsDecrement number
---@field blockRadius number
---@field target boolean?

---@class Lamp
---@field model string|number
---@field item string
---@field range number
---@field headingOffset number
---@field ambient boolean
---@field target boolean?

---@class Laboratory
---@field label string -- used in the purchase dialog
---@field purchaseable boolean
---@field account string
---@field requiredItem string?
---@field laptop vector3
---@field iplTier 'basic' | 'upgrade'
---@field exit { target: vector3, coords: vector4 }
---@field entrances table<integer, { target: vector3, coords: vector4, price: integer, disableAnim: boolean }>
---@field blipEnabled boolean
---@field blipData { text: string, sprite: number, color: number, size: number }?
---@field target boolean?

---@class ProcessingTable
---@field item string
---@field model string|number
---@field duration number
---@field interactionOffset vector3
---@field radius number
---@field animation AnimProps?
---@field animationProp AnimPropData?
---@field blockMultipleUsers boolean
---@field recipes { duration: number, progress: string, requiredItems: { name: string, amount: number }[], giveItems: { name: string, amount: { min: number, max: number } }[] }[]
---@field target boolean?

---@class Supplier
---@field label string
---@field radius number
---@field model string|number
---@field account string
---@field blipEnabled boolean
---@field blipData { sprite: number, color: number, size: number }?
---@field locations vector4[]
---@field items { name: string, price: number }[] -- stock resets each server restart
---@field target boolean?

---@class Consumable
---@field name string
---@field progress string
---@field progressDuration number
---@field animation AnimProps?
---@field animationProp AnimPropData?
---@field effects { duration: number, visualEffect: { intensity: number, type: string }, cameraShake: { intensity: number, type: string }, walkClipSet: string, tripChance: number, speed: number, health: number, hunger: number, thirst: number, armour: number, overdoseLevel: number }

---@class PocketProcessing
---@field activationItem string -- the item you use in your inventory to activate the recipe
---@field animation AnimProps?
---@field animationProp AnimPropData?
---@field recipes { duration: number, progress: string, requiredItems: { name: string, amount: number }[], giveItems: { name: string, amount: { min: number, max: number } }[] }[]

---@class RetailSellingZone
---@field label string
---@field priceTolerance number -- the price tolerance of people in this area in 0.0 to 1.0
---@field maxAttempts number -- maximum number of attempts he can try to sell above standard price
---@field acceptChance number -- if above standard price then this is the chance he will accept
---@field reportChance number -- the chance that you will be reported for selling
---@field account string -- the account to add the money to
---@field items { name: string, price: number, amount: { min: number, max: number } }[]
---@field locations { coords: vector3, radius: number }[]
---@field target boolean?

---@class WholesaleSettings
---@field enabled boolean
---@field phoneItem string
---@field animation AnimProps?
---@field animationProp AnimPropData?
---@field clientInterval { min: number, max: number }
---@field locations vector4[]
---@field account string
---@field items { name: string, price: { min: number, max: number }, amount: { min: number, max: number } }[]

---@class GeneralSettings
---@field sellDivisor number
---@field plantInterval number
---@field retailSellingCommand string
---@field retailSellingMinPolice number
---@field progressDurations { watering: number, fertilizing: number, harvesting: number }
---@field disableHackingDevice boolean
---@field betterTablePlacing boolean
---@field webhook string?