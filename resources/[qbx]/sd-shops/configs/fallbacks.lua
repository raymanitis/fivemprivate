return {
    -- Item Name Fallbacks
    -- The script will attempt to retrieve item names from your inventory system (see bridge/server.lua - Inventory.GetItemLabel)
    -- These fallback names are only used if the inventory system doesn't provide a name/label for the item
    -- If both inventory and fallback fail, the script will convert the spawn name to a readable format (e.g., "twerks_candy" → "Twerks Candy")
    ItemNameFallbacks = {
        -- 24/7 Store Items
        ['water'] = 'Water Bottle',
        ['sandwich'] = 'Sandwich',
        ['coffee'] = 'Coffee',
        ['burger'] = 'Burger',
        ['cola'] = 'E-Cola',
        ['sprunk'] = 'Sprunk',
        ['tosti'] = 'Tosti',
        ['twerks_candy'] = 'Twerks Candy',
        ['cigarette'] = 'Cigarette',
        ['rolling_paper'] = 'Rolling Paper',
        ['scratchcard'] = 'Scratch Card',
        ['id_card'] = 'ID Card',
        ['driver_license'] = 'Driver License',

        -- Medical Items
        ['bandage'] = 'Bandage',
        ['painkillers'] = 'Painkillers',
        ['firstaid'] = 'First Aid Kit',
        ['medicalbag'] = 'Medical Bag',
        ['vicodin'] = 'Vicodin',
        ['morphine'] = 'Morphine',
        ['antibiotics'] = 'Antibiotics',
        ['gauze'] = 'Gauze',
        ['icepack'] = 'Ice Pack',
        ['heatpack'] = 'Heat Pack',

        -- Tools & Equipment
        ['phone'] = 'Phone',
        ['radio'] = 'Radio',
        ['radiocell'] = 'Radio Battery',
        ['lighter'] = 'Lighter',
        ['weapon_flashlight'] = 'Flashlight',
        ['lockpick'] = 'Lockpick',
        ['advancedlockpick'] = 'Advanced Lockpick',
        ['repairkit'] = 'Repair Kit',
        ['advancedrepairkit'] = 'Advanced Repair Kit',
        ['screwdriverset'] = 'Screwdriver Set',
        ['drill'] = 'Drill',
        ['powersaw'] = 'Power Saw',
        ['welding_torch'] = 'Welding Torch',
        ['cleaningkit'] = 'Cleaning Kit',
        ['electronickit'] = 'Electronic Kit',
        ['binoculars'] = 'Binoculars',

        -- Materials & Crafting
        ['metalscrap'] = 'Metal Scrap',
        ['plastic'] = 'Plastic',
        ['copper'] = 'Copper',
        ['iron'] = 'Iron',
        ['aluminium'] = 'Aluminium',
        ['glass'] = 'Glass',
        ['rubber'] = 'Rubber',
        ['wood'] = 'Wood',
        ['wood_planks'] = 'Wood Planks',
        ['md_nails'] = 'Nails',
        ['md_screw'] = 'Screws',

        -- Alcohol & Drinks
        ['beer'] = 'Beer',
        ['vodka'] = 'Vodka',
        ['whiskey'] = 'Whiskey',
        ['wine'] = 'Wine',
        ['tequila'] = 'Tequila',
        ['champagne'] = 'Champagne',
        ['rum'] = 'Rum',

        -- Snacks
        ['chips'] = 'Chips',
        ['chocolate'] = 'Chocolate',
        ['peanuts'] = 'Peanuts',

        -- Weapons & Attachments
        ['weapon_pistol'] = 'Pistol',
        ['weapon_combatpistol'] = 'Combat Pistol',
        ['weapon_appistol'] = 'AP Pistol',
        ['weapon_pistol50'] = 'Pistol .50',
        ['pistol_ammo'] = 'Pistol Ammo',
        ['rifle_ammo'] = 'Rifle Ammo',
        ['shotgun_ammo'] = 'Shotgun Ammo',
        ['smg_ammo'] = 'SMG Ammo',
        ['weapon_suppressor'] = 'Suppressor',
        ['weapon_grip'] = 'Weapon Grip',
        ['weapon_scope'] = 'Weapon Scope',

        -- Misc Items
        ['diving_crate'] = 'Diving Crate'
    },

    -- Item Description Fallbacks
    -- The script will attempt to retrieve item descriptions from your inventory system (see bridge/server.lua - Inventory.GetItemDescription)
    -- These fallback descriptions are only used if the inventory system doesn't provide a description for the item
    -- This ensures all items have user-friendly descriptions even if your inventory doesn't define them
    ItemDescriptionFallbacks = {
        -- 24/7 Store Items
        ['water'] = 'Refreshing bottled water to quench your thirst',
        ['sandwich'] = 'Fresh sandwich perfect for a quick meal',
        ['coffee'] = 'Hot coffee to keep you energized',
        ['burger'] = 'Delicious burger to satisfy your hunger',
        ['cola'] = 'Classic carbonated soft drink',
        ['sprunk'] = 'Refreshing lemon-lime soda',
        ['tosti'] = 'Grilled cheese sandwich',
        ['twerks_candy'] = 'Sweet candy bar',
        ['cigarette'] = 'Pack of cigarettes',
        ['rolling_paper'] = 'Rolling papers for cigarettes',
        ['scratchcard'] = 'Lottery scratch card',
        ['id_card'] = 'Personal identification card',
        ['driver_license'] = 'Valid driver\'s license',

        -- Medical Items
        ['bandage'] = 'Basic bandage for treating minor wounds',
        ['painkillers'] = 'Over-the-counter pain relief medication',
        ['firstaid'] = 'First aid kit with medical supplies',
        ['medicalbag'] = 'Professional medical bag with advanced supplies',
        ['vicodin'] = 'Prescription pain medication',
        ['morphine'] = 'Strong prescription painkiller',
        ['antibiotics'] = 'Antibiotic medication',
        ['gauze'] = 'Medical gauze for wound care',
        ['icepack'] = 'Cold pack for reducing swelling',
        ['heatpack'] = 'Heat pack for muscle relief',

        -- Tools & Equipment
        ['phone'] = 'Smartphone with calling and messaging',
        ['radio'] = 'Portable communication radio',
        ['radiocell'] = 'AAA batteries for radio',
        ['lighter'] = 'Disposable lighter',
        ['weapon_flashlight'] = 'Compact LED flashlight',
        ['lockpick'] = 'Basic lockpicking tool',
        ['advancedlockpick'] = 'Advanced lockpicking set',
        ['repairkit'] = 'Basic tools for vehicle repairs',
        ['advancedrepairkit'] = 'Professional vehicle repair tools',
        ['screwdriverset'] = 'Complete set of screwdrivers',
        ['drill'] = 'Electric power drill',
        ['powersaw'] = 'Power saw for cutting wood',
        ['welding_torch'] = 'Professional welding torch',
        ['cleaningkit'] = 'Cleaning supplies kit',
        ['electronickit'] = 'Electronics repair kit',
        ['binoculars'] = 'High-powered binoculars',

        -- Materials & Crafting
        ['metalscrap'] = 'Scrap metal pieces',
        ['plastic'] = 'Plastic material',
        ['copper'] = 'Copper material',
        ['iron'] = 'Iron material',
        ['aluminium'] = 'Aluminium material',
        ['glass'] = 'Glass material',
        ['rubber'] = 'Rubber material',
        ['wood'] = 'Raw wood',
        ['wood_planks'] = 'Processed wood planks',
        ['md_nails'] = 'Box of nails',
        ['md_screw'] = 'Box of screws',

        -- Alcohol & Drinks
        ['beer'] = 'Cold bottle of beer',
        ['vodka'] = 'Bottle of vodka',
        ['whiskey'] = 'Premium whiskey',
        ['wine'] = 'Bottle of wine',
        ['tequila'] = 'Bottle of tequila',
        ['champagne'] = 'Bottle of champagne',
        ['rum'] = 'Bottle of rum',

        -- Snacks
        ['chips'] = 'Bag of chips',
        ['chocolate'] = 'Chocolate bar',
        ['peanuts'] = 'Roasted peanuts',

        -- Weapons & Attachments
        ['weapon_pistol'] = 'Standard pistol',
        ['weapon_combatpistol'] = 'Combat pistol',
        ['weapon_appistol'] = 'AP pistol',
        ['weapon_pistol50'] = '.50 caliber pistol',
        ['pistol_ammo'] = 'Pistol ammunition',
        ['rifle_ammo'] = 'Rifle ammunition',
        ['shotgun_ammo'] = 'Shotgun shells',
        ['smg_ammo'] = 'SMG ammunition',
        ['weapon_suppressor'] = 'Weapon suppressor',
        ['weapon_grip'] = 'Weapon grip attachment',
        ['weapon_scope'] = 'Weapon scope attachment',

        -- Misc Items
        ['diving_crate'] = 'Mysterious crate found while diving'
    },
}