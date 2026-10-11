Config = {
    Team = "Pirates",
    Configuration = {
        HopWhenIdle = true,
        AutoHop = true,
        AutoHopDelay = 60 * 60,
        FpsBoost = false,
        Noclip = true,
        blackscreen = false,
        LowGraphics = true
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true,
        AutoRaceV3 = true,
        AutoRandomFruit = true,
    },
    Sword = {
        ["Shark Saw"]        = false,
        ["Wardens Sword"]    = false,
        ["Pole (1st Form)"]  = false,
        ["Gravity Blade"]    = false,
        ["Longsword"]        = false,
        ["Rengoku"]          = false,
        ["Flail"]            = false,
        ["Twin Hooks"]       = false,
    },
    BossWeapons = {
        ["Awakened Ice Admiral"] = true,
        ["Tide Keeper"]          = true,
        ["Deandre"]              = true,
        ["Urban"]                = true,
        ["Diablo"]               = true,
        ["Soul Reaper"]          = true,
        ["Cake Prince"]          = true,
        ["Core"]                 = true,
        ["Darkbeard"]            = true,
        ["Katakuri"]             = true,
        ["Beautiful Pirates"]    = true,
    },
    Melee = {
        AutoBuy              = true,
        CheckMasteryAfterBuy = true,
        RaidAtV1Mastery      = 500,
        GodhumanAtV2Mastery  = 400,
    },
    AutoKen = true,
    BringMobs = true,
    PanicMode = {
        Enabled          = false,
        LowHealthPercent = 20,
        SafeHealthPercent = 75,
        EscapeHeight     = 2000,
        CheckInterval    = 1,
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = true
    },
    AutoSea2 = true,
    AutoSea3 = true,
    AutoRaidIce_TargetFragments = 5000,
}
print("[Tiro] Script da duoc nap, dang cho game load...")
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

-- [ADDED] Noclip: permite atravessar obstáculos durante o farming.
-- Guarda os valores originais e restaura-os se o Noclip for desligado.
local noclipOriginalCollisions = setmetatable({}, {__mode = "k"})
local function ApplyNoclip(character, enabled)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if enabled then
                if noclipOriginalCollisions[part] == nil then
                    noclipOriginalCollisions[part] = part.CanCollide
                end
                part.CanCollide = false
            else
                local original = noclipOriginalCollisions[part]
                if original ~= nil then
                    part.CanCollide = original
                    noclipOriginalCollisions[part] = nil
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local character = lp.Character
            ApplyNoclip(character, Config.Configuration.Noclip == true)
        end)
    end
end)

lp.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    ApplyNoclip(character, Config.Configuration.Noclip == true)
end)

print("[Main] Bắt đầu Tiro Kaitun Modulo v2.2...")
timeee = os.time()
local W_angle = 30
local lastChange = tick()

-- ============================================================
-- [ADDED] CHỌN VŨ KHÍ (TỪ T-REX HUB)
-- ============================================================
_G.ChooseWP = "Melee"  -- Mặc định Melee (có thể đổi thành Sword, Gun, Blox Fruit)
_G.SelectWeapon = nil

-- Luồng tự động cập nhật vũ khí
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local bp = lp:FindFirstChild("Backpack")
            if not bp then return end
            if _G.ChooseWP == "Melee" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Sword" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Gun" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Blox Fruit" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- [ADDED] GAME DATA (từ data_lua.txt) — bảng tham chiếu thuần
-- KHÔNG wire vào đâu trực tiếp; dùng khi cần tra level→mob/quest
-- ============================================================
local GameData = {
	QUESTS = {
		Sea_1 = {
			{1, 9, "Team-dependent", "Team-dependent", 1},
			{10, 14, "Monkey", "JungleQuest", 1},
			{15, 29, "Gorilla", "JungleQuest", 2, "The Gorilla King", 20},
			{30, 39, "Pirate", "BuggyQuest1", 1},
			{40, 59, "Brute", "BuggyQuest1", 2, "Chief", 55},
			{60, 74, "Desert Bandit", "DesertQuest", 1},
			{75, 89, "Desert Officer", "DesertQuest", 2},
			{90, 99, "Snow Bandit", "SnowQuest", 1},
			{100, 119, "Snowman", "SnowQuest", 2, "Yeti", 105},
			{120, 149, "Chief Petty Officer", "MarineQuest2", 1, "Vice Admiral", 130},
			{150, 174, "Sky Bandit", "SkyQuest", 1},
			{175, 189, "Dark Master", "SkyQuest", 2},
			{190, 209, "Prisoner", "PrisonerQuest", 1},
			{210, 249, "Dangerous Prisoner", "PrisonerQuest", 2, {"Warden", 220, "ImpelQuest", 1}, {"Chief Warden", 230, "ImpelQuest", 2}, {"Swan", 240, "ImpelQuest", 3}},
			{250, 274, "Toga Warrior", "ColosseumQuest", 1},
			{275, 299, "Gladiator", "ColosseumQuest", 2},
			{300, 324, "Military Soldier", "MagmaQuest", 1},
			{325, 374, "Military Spy", "MagmaQuest", 2, "Magma Admiral", 350},
			{375, 399, "Fishman Warrior", "FishmanQuest", 1},
			{400, 449, "Fishman Commando", "FishmanQuest", 2, "Fishman Lord", 425},
			{450, 474, "God's Guard", "SkyExp1Quest", 1},
			{475, 524, "Shanda", "SkyExp1Quest", 2, "Wysper", 500},
			{525, 549, "Royal Squad", "SkyExp2Quest", 1},
			{550, 624, "Royal Soldier", "SkyExp2Quest", 2, "Thunder God", 575},
			{625, 649, "Galley Pirate", "FountainQuest", 1},
			{650, 9999, "Galley Captain", "FountainQuest", 2, "Cyborg", 675},
		},
		Sea_2 = {
			{700, 724, "Raider", "Area1Quest", 1},
			{725, 774, "Mercenary", "Area1Quest", 2, "Diamond", 750},
			{775, 799, "Swan Pirate", "Area2Quest", 1},
			{800, 874, "Factory Staff", "Area2Quest", 2, "Jeremy", 850},
			{875, 899, "Marine Lieutenant", "MarineQuest3", 1},
			{900, 949, "Marine Captain", "MarineQuest3", 2, "Orbitus", 925},
			{950, 974, "Zombie", "ZombieQuest", 1},
			{975, 999, "Vampire", "ZombieQuest", 2},
			{1000, 1049, "Snow Trooper", "SnowMountainQuest", 1},
			{1050, 1099, "Winter Warrior", "SnowMountainQuest", 2},
			{1100, 1124, "Lab Subordinate", "IceSideQuest", 1},
			{1125, 1174, "Horned Warrior", "IceSideQuest", 2, "Smoke Admiral", 1150},
			{1175, 1199, "Magma Ninja", "FireSideQuest", 1},
			{1200, 1249, "Lava Pirate", "FireSideQuest", 2},
			{1250, 1274, "Ship Deckhand", "ShipQuest1", 1},
			{1275, 1299, "Ship Engineer", "ShipQuest1", 2},
			{1300, 1324, "Ship Steward", "ShipQuest2", 1},
			{1325, 1349, "Ship Officer", "ShipQuest2", 2},
			{1350, 1374, "Arctic Warrior", "FrostQuest", 1},
			{1375, 1424, "Snow Lurker", "FrostQuest", 2, "Awakened Ice Admiral", 1400},
			{1425, 1449, "Sea Soldier", "ForgottenQuest", 1},
			{1450, 9999, "Water Fighter", "ForgottenQuest", 2, "Tide Keeper", 1475},
		},
		Sea_3 = {
			{1500, 1524, "Pirate Millionaire", "PiratePortQuest", 1},
			{1525, 1574, "Pistol Billionaire", "PiratePortQuest", 2},
			{1575, 1599, "Dragon Crew Warrior", "DragonCrewQuest", 1},
			{1600, 1624, "Dragon Crew Archer", "DragonCrewQuest", 2},
			{1625, 1649, "Hydra Enforcer", "VenomCrewQuest", 1},
			{1650, 1699, "Venomous Assailant", "VenomCrewQuest", 2},
			{1700, 1724, "Marine Commodore", "MarineTreeIsland", 1},
			{1725, 1774, "Marine Rear Admiral", "MarineTreeIsland", 2},
			{1775, 1799, "Fishman Raider", "DeepForestIsland3", 1},
			{1800, 1824, "Fishman Captain", "DeepForestIsland3", 2},
			{1825, 1849, "Forest Pirate", "DeepForestIsland", 1},
			{1850, 1899, "Mythological Pirate", "DeepForestIsland", 2},
			{1900, 1924, "Jungle Pirate", "DeepForestIsland2", 1},
			{1925, 1974, "Musketeer Pirate", "DeepForestIsland2", 2},
			{1975, 1999, "Reborn Skeleton", "HauntedQuest1", 1},
			{2000, 2024, "Living Zombie", "HauntedQuest1", 2},
			{2025, 2049, "Demonic Soul", "HauntedQuest2", 1},
			{2050, 2074, "Posessed Mummy", "HauntedQuest2", 2},
			{2075, 2099, "Peanut Scout", "NutsIslandQuest", 1},
			{2100, 2124, "Peanut President", "NutsIslandQuest", 2},
			{2125, 2149, "Ice Cream Chef", "IceCreamIslandQuest", 1},
			{2150, 2199, "Ice Cream Commander", "IceCreamIslandQuest", 2},
			{2200, 2224, "Cookie Crafter", "CakeQuest1", 1},
			{2225, 2249, "Cake Guard", "CakeQuest1", 2},
			{2250, 2274, "Baking Staff", "CakeQuest2", 1},
			{2275, 2299, "Head Baker", "CakeQuest2", 2},
			{2300, 2324, "Cocoa Warrior", "ChocQuest1", 1},
			{2325, 2349, "Chocolate Bar Battler", "ChocQuest1", 2},
			{2350, 2374, "Sweet Thief", "ChocQuest2", 1},
			{2375, 2399, "Candy Rebel", "ChocQuest2", 2},
			{2400, 2424, "Candy Pirate", "CandyQuest1", 1},
			{2425, 2449, "Snow Demon", "CandyQuest1", 2},
			{2450, 2474, "Isle Outlaw", "TikiQuest1", 1},
			{2475, 2499, "Island Boy", "TikiQuest1", 2},
			{2500, 2524, "Sun-kissed Warrior", "TikiQuest2", 1},
			{2525, 2549, "Isle Champion", "TikiQuest2", 2},
			{2550, 2574, "Serpent Hunter", "TikiQuest3", 1},
			{2575, 2599, "Skull Slayer", "TikiQuest3", 2},
			{2600, 2624, "Reef Bandit", "SubmergedQuest1", 1},
			{2625, 2649, "Coral Pirate", "SubmergedQuest1", 2},
			{2650, 2674, "Sea Chanter", "SubmergedQuest2", 1},
			{2675, 2699, "High Disciple", "SubmergedQuest3", 1},
			{2700, 9999, "Grand Devotee", "SubmergedQuest3", 2},
		}
	},
	BossList = {
		Sea_1 = {
			{20, "The Gorilla King", "JungleQuest", 3, CFrame.new(-1602, 37, 153)},
			{55, "Chief", "BuggyQuest1", 2, CFrame.new(-1140, 5, 3827)},
			{105, "Yeti", "SnowQuest", 3, CFrame.new(1387, 87, -1298)},
			{130, "Vice Admiral", "MarineQuest2", 2, CFrame.new(-5036, 29, 4325)},
			{220, "Warden", "ImpelQuest", 1, CFrame.new(5192, 3, 686)},
			{230, "Chief Warden", "ImpelQuest", 2, CFrame.new(5192, 3, 686)},
			{240, "Swan", "ImpelQuest", 3, CFrame.new(5192, 3, 686)},
			{350, "Magma Admiral", "MagmaQuest", 3, CFrame.new(-5315, 12, 8517)},
			{425, "Fishman Lord", "FishmanQuest", 3, CFrame.new(61123, 18, 1569)},
			{500, "Wysper", "SkyExp1Quest", 3, CFrame.new(-7862, 5546, -380)},
			{575, "Thunder God", "SkyExp2Quest", 3, CFrame.new(-7903, 5636, -1411)},
			{675, "Cyborg", "FountainQuest", 3, CFrame.new(5258, 39, 4050)},
		},
		Sea_2 = {
			{750, "Diamond", "Area1Quest", 3, CFrame.new(-428, 73, 1835)},
			{850, "Jeremy", "Area2Quest", 3, CFrame.new(637, 73, 918)},
			{925, "Orbitus", "MarineQuest3", 3, CFrame.new(-2442, 73, -3218)},
			{1150, "Smoke Admiral", "IceSideQuest", 3, CFrame.new(-5429, 16, -5298)},
			{1400, "Awakened Ice Admiral", "FrostQuest", 3, CFrame.new(5669, 29, -6483)},
			{1475, "Tide Keeper", "ForgottenQuest", 3, CFrame.new(-3054, 237, -10145)},
		},
		Sea_3 = {
			{1575, "Stone", "PiratePortQuest", 3, CFrame.new(-290, 44, 5580)},
			{1775, "Kilo Admiral", "MarineTreeIsland", 3, CFrame.new(2179, 29, -6740)},
			{1875, "Captain Elephant", "DeepForestIsland", 3, CFrame.new(-13233, 332, -7626)},
			{1950, "Beautiful Pirate", "DeepForestIsland2", 3, CFrame.new(-12682, 391, -9902)},
			{2175, "Cake Queen", "IceCreamIslandQuest", 3, CFrame.new(-819, 65, -10967)},
		}
	},
	MaterialEnemies = {
		Sea_1 = {
			["Angel Wings"] = { "Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God" },
			["Leather + Scrap Metal"] = { "Brute", "Pirate" },
			["Magma Ore"] = { "Military Soldier", "Military Spy", "Magma Admiral" },
			["Fish Tail"] = { "Fishman Warrior", "Fishman Commando", "Fishman Lord" },
		},
		Sea_2 = {
			["Leather + Scrap Metal"] = { "Marine Captain" },
			["Magma Ore"] = { "Magma Ninja", "Lava Pirate" },
			["Ectoplasm"] = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer" },
			["Mystic Droplet"] = { "Water Fighter" },
			["Radioactive Material"] = { "Factory Staff" },
			["Vampire Fang"] = { "Vampire" },
		},
		Sea_3 = {
			["Leather + Scrap Metal"] = { "Jungle Pirate" },
			["Demonic Wisp"] = { "Demonic Soul" },
			["Fish Tail"] = { "Fishman Raider", "Fishman Captain" },
			["Conjured Cocoa"] = { "Chocolate Bar Battler", "Cocoa Warrior" },
			["Dragon Scale"] = { "Dragon Crew Archer", "Dragon Crew Warrior" },
			["Gunpowder"] = { "Pistol Billionaire" },
			["Mini Tusk"] = { "Mythological Pirate" },
			["Nightmare Catcher"] = { "Reborn Skeleton", "Living Zombie" },
		}
	},
	Materials = {
		Sea_1 = { "Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail" },
		Sea_2 = { "Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang" },
		Sea_3 = { "Leather + Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk", "Nightmare Catcher" }
	},
	BossNames = {
		Sea_1 = { "The Gorilla King", "Chief", "Yeti", "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Saw" },
		Sea_2 = { "Diamond", "Jeremy", "Orbitus", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Don Swan" },
		Sea_3 = { "Stone", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen" }
	},
	MeleeNames = {
		Sea_1 = { "Black Leg", "Electro", "Fishman Karate" },
		Sea_2 = { "Death Step", "Dragon Claw", "Sharkman Karate", "Superhuman" },
		Sea_3 = { "Dragon Talon", "Electric Claw", "Godhuman", "Sanguine Art" }
	},
	Melees = {
		["Black Leg"] = {
			Model = "Dark Step Teacher",
			Npc = "Dark Step Teacher",
			npc = "Dark Step Teacher",
			CFrame = CFrame.new(-1147.284, 4.752, 3816.326),
			cframe = CFrame.new(-1147.284, 4.752, 3816.326),
			Remote = { "BuyBlackLeg" },
			remote = { "BuyBlackLeg" },
			Sea = 1
		},
		["Electro"] = {
			Model = "Mad Scientist",
			Npc = "Mad Scientist",
			npc = "Mad Scientist",
			CFrame = CFrame.new(-4842.112, 717.670, -2623.149),
			cframe = CFrame.new(-4842.112, 717.670, -2623.149),
			Remote = { "BuyElectro" },
			remote = { "BuyElectro" },
			Sea = 1
		},
		["Fishman Karate"] = {
			Model = "Water Kung-fu Teacher",
			Npc = "Water Kung-fu Teacher",
			npc = "Water Kung-fu Teacher",
			CFrame = CFrame.new(61122.652, 18.497, 1568.351),
			cframe = CFrame.new(61122.652, 18.497, 1568.351),
			Remote = { "BuyFishmanKarate" },
			remote = { "BuyFishmanKarate" },
			Sea = 1
		},
		["Dragon Claw"] = {
			Model = "Sabi",
			Npc = "Sabi",
			npc = "Sabi",
			CFrame = CFrame.new(699.029, 185.661, 654.895),
			cframe = CFrame.new(699.029, 185.661, 654.895),
			CFrames = {
				Sea_2 = CFrame.new(699.029, 185.661, 654.895),
			},
			cframes = {
				Sea_2 = CFrame.new(699.029, 185.661, 654.895),
			},
			Remote = { { "BlackbeardReward", "DragonClaw", "1" }, { "BlackbeardReward", "DragonClaw", "2" } },
			remote = { { "BlackbeardReward", "DragonClaw", "1" }, { "BlackbeardReward", "DragonClaw", "2" } },
			Sea = 2
		},
		["Superhuman"] = {
			Model = "Martial Arts Master",
			Npc = "Martial Arts Master",
			npc = "Martial Arts Master",
			CFrame = CFrame.new(1377.125, 246.542, -5189.951),
			cframe = CFrame.new(1377.125, 246.542, -5189.951),
			CFrames = {
				Sea_2 = CFrame.new(1377.125, 246.542, -5189.951),
			},
			cframes = {
				Sea_2 = CFrame.new(1377.125, 246.542, -5189.951),
			},
			Remote = { "BuySuperhuman" },
			remote = { "BuySuperhuman" },
			Sea = 2
		},
		["Death Step"] = {
			Model = "Phoeyu, the Reformed",
			Npc = "Phoeyu, the Reformed",
			npc = "Phoeyu, the Reformed",
			CFrame = CFrame.new(6356.472, 296.100, -6762.771),
			cframe = CFrame.new(6356.472, 296.100, -6762.771),
			CFrames = {
				Sea_2 = CFrame.new(6356.472, 296.100, -6762.771),
			},
			cframes = {
				Sea_2 = CFrame.new(6356.472, 296.100, -6762.771),
			},
			Remote = { "BuyDeathStep" },
			remote = { "BuyDeathStep" },
			Sea = 2
		},
		["Sharkman Karate"] = {
			Model = "Sharkman Teacher",
			Npc = "Sharkman Teacher",
			npc = "Sharkman Teacher",
			CFrame = CFrame.new(-2599.622, 238.198, -10315.998),
			cframe = CFrame.new(-2599.622, 238.198, -10315.998),
			CFrames = {
				Sea_2 = CFrame.new(-2599.622, 238.198, -10315.998),
			},
			cframes = {
				Sea_2 = CFrame.new(-2599.622, 238.198, -10315.998),
			},
			Remote = { "BuySharkmanKarate" },
			remote = { "BuySharkmanKarate" },
			Sea = 2
		},
		["Electric Claw"] = {
			Model = "Previous Hero",
			Npc = "Previous Hero",
			npc = "Previous Hero",
			CFrame = CFrame.new(-10368.514, 331.788, -10134.120),
			cframe = CFrame.new(-10368.514, 331.788, -10134.120),
			CFrames = {
				Sea_3 = CFrame.new(-10368.514, 331.788, -10134.120),
			},
			cframes = {
				Sea_3 = CFrame.new(-10368.514, 331.788, -10134.120),
			},
			Remote = { "BuyElectricClaw" },
			remote = { "BuyElectricClaw" },
			Sea = 3
		},
		["Dragon Talon"] = {
			Model = "Uzoth",
			Npc = "Uzoth",
			npc = "Uzoth",
			CFrame = CFrame.new(-9515.372, 142.130, 5535.089),
			cframe = CFrame.new(-9515.372, 142.130, 5535.089),
			CFrames = {
				Sea_3 = CFrame.new(-9515.372, 142.130, 5535.089),
			},
			cframes = {
				Sea_3 = CFrame.new(-9515.372, 142.130, 5535.089),
			},
			Remote = { "BuyDragonTalon" },
			remote = { "BuyDragonTalon" },
			Sea = 3
		},
		["Godhuman"] = {
			Model = "Ancient Monk",
			Npc = "Ancient Monk",
			npc = "Ancient Monk",
			CFrame = CFrame.new(-12463.870, 374.910, -7523.770),
			cframe = CFrame.new(-12463.870, 374.910, -7523.770),
			CFrames = {
				Sea_3 = CFrame.new(-12463.870, 374.910, -7523.770),
			},
			cframes = {
				Sea_3 = CFrame.new(-12463.870, 374.910, -7523.770),
			},
			Remote = { "BuyGodhuman" },
			remote = { "BuyGodhuman" },
			Sea = 3
		},
		["Sanguine Art"] = {
			Model = "Shafi",
			Npc = "Shafi",
			npc = "Shafi",
			CFrame = CFrame.new(-16548.800, 12.000, 412.300),
			cframe = CFrame.new(-16548.800, 12.000, 412.300),
			CFrames = {
				Sea_3 = CFrame.new(-16548.800, 12.000, 412.300),
			},
			cframes = {
				Sea_3 = CFrame.new(-16548.800, 12.000, 412.300),
			},
			Remote = { { "BuySanguineArt", true }, { "BuySanguineArt" } },
			remote = { { "BuySanguineArt", true }, { "BuySanguineArt" } },
			Sea = 3
		},
	},
	ItemsToBuy = {
		["Frags"] = {
			["Race Rerol"] = { "BlackbeardReward", "Reroll", "2" },
			["Reset Stats"] = { "BlackbeardReward", "Refund", "2" }
		},
		["Ability"] = {
			["Geppo"] = { "BuyHaki", "Geppo" },
			["Buso Haki"] = { "BuyHaki", "Buso" },
			["Soru"] = { "BuyHaki", "Soru" },
			["Observation Haki"] = { "KenTalk", "Buy" }
		},
		["Gun"] = {
			["Slingshot"] = { "BuyItem", "Slingshot" },
			["Musket"] = { "BuyItem", "Musket" },
			["Flintlock"] = { "BuyItem", "Flintlock" },
			["Refined Slingshot"] = { "BuyItem", "Refined Flintlock" },
			["Refined Flintlock"] = { "BuyItem", "Refined Flintlock" },
			["Cannon"] = { "BuyItem", "Cannon" },
			["Kabucha"] = { "BlackbeardReward", "Slingshot", "1" },
			["Bizarre Rifle"] = { "Ectoplasm", "Buy", 1 }
		},
		["Accessory"] = {
			["Black Cape"] = { "Black Cape" },
			["Swordsman Hat"] = { "Swordsman Hat" },
			["Tomoe Ring"] = { "Tomoe Ring" }
		},
		["Sword"] = {
			["Cutlass"] = { "Cutlass" },
			["Katana"] = { "Katana" },
			["Iron Mace"] = { "Iron Mace" },
			["Dual Katana"] = { "Duel Katana" },
			["Triple Katana"] = { "Triple Katana" },
			["Pipe"] = { "Pipe" },
			["Dual-Headed Blade"] = { "Dual-Headed Blade" },
			["Bisento"] = { "Bisento" },
			["Soul Cane"] = { "Soul Cane" },
			["Pole v.2"] = { "ThunderGodTalk" }
		}
	},
	Islands = {
		["Sea 1"] = {
			["Pirate Starter"] = CFrame.new(1047, 15, 1506),
			["Marine Starter"] = CFrame.new(-2728, 25, 2056),
			["Middle Town"] = CFrame.new(-688, 15, 1585),
			["Jungle"] = CFrame.new(-1614, 37, 146),
			["Pirate Village"] = CFrame.new(-1173, 45, 3837),
			["Desert"] = CFrame.new(944, 21, 4373),
			["Frozen Village"] = CFrame.new(1298, 87, -1344),
			["Marine Fortress"] = CFrame.new(-4810, 21, 4359),
			["Colosseum"] = CFrame.new(-1535, 7, -3014),
			["Lower Skylands"] = CFrame.new(-4814, 718, -2551),
			["Skylands"] = CFrame.new(-4652, 873, -1754),
			["Upper Skylands"] = CFrame.new(-7895, 5547, -380),
			["Prison"] = CFrame.new(4870, 6, 736),
			["Magma Village"] = CFrame.new(-5290, 9, 8349),
			["Underwater City"] = CFrame.new(61164, 5, 1820),
			["Fountain City"] = CFrame.new(5757, 91, 4017),
			["Jean-Luc Island"] = CFrame.new(-2850, 7, 5355),
		},
		["Sea 2"] = {
			["The Cafe"] = CFrame.new(-382, 73, 290),
			["First Spot"] = CFrame.new(-11, 29, 2771),
			["Dark Arena"] = CFrame.new(3494, 13, -3259),
			["Don Swan Mansion"] = CFrame.new(-317, 331, 597),
			["Don Swan Room"] = CFrame.new(2285, 15, 905),
			["Green Zone"] = CFrame.new(-2258, 73, -2696),
			["Graveyard"] = CFrame.new(-5552, 194, -776),
			["Snow Mountain"] = CFrame.new(752, 408, -5277),
			["Hot and Cold"] = CFrame.new(-6008, 29, -5018),
			["Cursed Ship"] = CFrame.new(919, 125, 32869),
			["Ice Castle"] = CFrame.new(5505, 40, -6178),
			["Forgotten Island"] = CFrame.new(-3050, 240, -10178),
			["Remote Island"] = CFrame.new(4816, 8, 2863),
		},
		["Sea 3"] = {
			["Mansion"] = CFrame.new(-12471, 374, -7551),
			["Port Town"] = CFrame.new(-340, 21, 5524),
			["Great Tree"] = CFrame.new(2205, 22, -6766),
			["Castle On The Sea"] = CFrame.new(-4980, 314, -3018),
			["Hydra Island"] = CFrame.new(5294, 1005, 391),
			["Floating Turtle"] = CFrame.new(-12528, 332, -8658),
			["Haunted Castle"] = CFrame.new(-9517, 142, 5528),
			["Ice Cream Land"] = CFrame.new(-843, 66, -10944),
			["Peanut Land"] = CFrame.new(-2082, 38, -10190),
			["Cake Land"] = CFrame.new(-1897, 14, -11576),
			["Candy Cane Land"] = CFrame.new(-1094, 64, -14519),
			["Chocolate Land"] = CFrame.new(219, 127, -12604),
			["Tiki Outpost"] = CFrame.new(-16224, 9, 439),
		}
	},
	PortalLocations = {
		Sea_1 = {
			Vector3.new(-7894.62, 5545.49, -380.25),
			Vector3.new(-4607.82, 872.54, -1667.56),
			Vector3.new(61163.85, 11.76, 1819.78),
			Vector3.new(3876.28, 35.11, -1939.32)
		},
		Sea_2 = {
			Vector3.new(-288.46, 306.13, 598),
			Vector3.new(2284.91, 15.15, 905.48),
			Vector3.new(923.21, 126.98, 32852.83),
			Vector3.new(-6508.56, 89.03, -132.84)
		},
		Sea_3 = {
			Vector3.new(-5058.77, 314.52, -3155.88),
			Vector3.new(-12463.87, 374.91, -7523.77),
			Vector3.new(28282.57, 14896.85, 105.1),
			Vector3.new(5661.53, 1013.09, -334.96),
			Vector3.new(5319, 23, -93),
			Vector3.new(5651, 1018, -350),
			Vector3.new(28286, 14897, 103)
		}
	},
	SwordData = {
		["Dark Blade"] = { Rarity = "Mythical", Order = 1 },
		["True Triple Katana"] = { Rarity = "Mythical", Order = 1 },
		["Cursed Dual Katana"] = { Rarity = "Mythical", Order = 1 },
		["Hallow Scythe"] = { Rarity = "Mythical", Order = 1 },
		["Triple Dark Blade"] = { Rarity = "Mythical", Order = 1 },
		["Dog Blade"] = { Rarity = "Mythical", Order = 1 },

		["Rengoku"] = { Rarity = "Legendary", Order = 2 },
		["Yama"] = { Rarity = "Legendary", Order = 2 },
		["Tushita"] = { Rarity = "Legendary", Order = 2 },
		["Buddy Sword"] = { Rarity = "Legendary", Order = 2 },
		["Shark Anchor"] = { Rarity = "Legendary", Order = 2 },
		["Fox Lamp"] = { Rarity = "Legendary", Order = 2 },
		["Dragon Trident"] = { Rarity = "Legendary", Order = 2 },
		["Saber"] = { Rarity = "Legendary", Order = 2 },
		["Canvander"] = { Rarity = "Legendary", Order = 2 },
		["Dark Dagger"] = { Rarity = "Legendary", Order = 2 },
		["Dragonheart"] = { Rarity = "Legendary", Order = 2 },
		["Koko"] = { Rarity = "Legendary", Order = 2 },
		["Midnight Blade"] = { Rarity = "Legendary", Order = 2 },
		["Oroshi"] = { Rarity = "Legendary", Order = 2 },
		["Pole (1st Form)"] = { Rarity = "Legendary", Order = 2 },
		["Pole (2nd Form)"] = { Rarity = "Legendary", Order = 2 },
		["Saishi"] = { Rarity = "Legendary", Order = 2 },
		["Shizu"] = { Rarity = "Legendary", Order = 2 },
		["Longsword"] = { Rarity = "Legendary", Order = 2 },
		["Pipe"] = { Rarity = "Legendary", Order = 2 },
		["Soul Cane"] = { Rarity = "Legendary", Order = 2 },
		["Trident"] = { Rarity = "Legendary", Order = 2 },
		["Wardens Sword"] = { Rarity = "Legendary", Order = 2 },
		["Bisento"] = { Rarity = "Legendary", Order = 2 },
		["Triple Katana"] = { Rarity = "Legendary", Order = 2 },
		["Twin Hooks"] = { Rarity = "Legendary", Order = 2 },
		["Dual-Headed Blade"] = { Rarity = "Legendary", Order = 2 },
		["Flail"] = { Rarity = "Legendary", Order = 2 },
		["Gravity Blade"] = { Rarity = "Legendary", Order = 2 },

		["Spikey Trident"] = { Rarity = "Rare", Order = 3 },
		["Fishing Trophy"] = { Rarity = "Rare", Order = 3 },
		["Shark Saw"] = { Rarity = "Rare", Order = 3 },

		["Iron Mace"] = { Rarity = "Uncommon", Order = 4 },

		["Cutlass"] = { Rarity = "Common", Order = 5 },
		["Katana"] = { Rarity = "Common", Order = 5 },
		["Dual Katana"] = { Rarity = "Common", Order = 5 },
	},
	BoatsList = {
		'Dinghy',
		'PirateSloop',
		'PirateBrigade',
		'PirateGrandBrigade',
		'MarineSloop',
		'MarineBrigade',
		'MarineGrandBrigade',
		'Beast Hunter',
		'Lantern',
		'Guardian',
		'Grand Brigade',
		'Sloop',
		'The Sentinel'
	},
	ZoneList = {
		'Level 1',
		'Level 2',
		'Level 3',
		'Level 4',
		'Level 5',
		'Level 6',
		'Infinite'
	},
	SeaEventTargets = {
		"Terror Shark",
		"Sea Beast",
		"Shark",
		"Piranha",
		"Fish Crew Member",
		"Pirate Brigade",
		"Pirate Grand Brigade",
		"Ghost Ship"
	},
	RodsList = {
		"Fishing Rod",
		"Gold Rod",
		"Shark Rod",
		"Shell Rod",
		"Treasure Rod",
		"Shark (Corrupted)",
		"Shell (Celestial)"
	},
	BaitsList = {
		"Basic Bait",
		"Kelp Bait",
		"Good Bait",
		"Abyssal Bait",
		"Frozen Bait",
		"Epic Bait",
		"Carnivore Bait"
	},
	DungeonCards = {
		"Hyper",
		"Overflow",
		"Fortress",
		"Shadow",
		"Sniper",
		"Lifesteal",
		"Unbreakable",
		"Health",
		"Defense",
		"Armor",
		"Melee",
		"Sword",
		"Fruit",
		"Gun"
	},
	TrainMethods = {
		"Bones",
		"Cakes"
	},
	LegendarySwordNames = {
		"Shizu",
		"Oroshi",
		"Saishi"
	},
	BossHopNames = {
		"Greybeard",
		"Darkbeard",
		"Cursed Captain",
		"rip_indra True Form",
		"Soul Reaper",
		"Cake Prince",
		"Dough King",
		"Tyrant of the Skies"
	},
	BossMap = {
		["Greybeard"] = "Greybeard",
		["Darkbeard"] = "Darkbeard",
		["Cursed Captain"] = "CursedCaptain",
		["rip_indra True Form"] = "Ripindra",
		["Soul Reaper"] = "SoulReaper",
		["Cake Prince"] = "CakePrince",
		["Dough King"] = "DoughKing",
		["Tyrant of the Skies"] = "Tyrant"
	},
	ScrollList = {
		"Common Scroll",
		"Rare Scroll",
		"Legendary Scroll",
		"Mythical Scroll"
	},
	ChestTiers = {
		"Diamond",
		"Gold",
		"Silver"
	},
	IgnoreNPC = {
		"Quest",
		"Boat",
		"Home"
	},
	DracoSequence = {
		"Relic1",
		"EndRelic1",
		"Relic2",
		"EndRelic2",
		"Relic3",
		"EndRelic3"
	},
	SwordList = {
		"Shizu",
		"Saishi",
		"Oroshi"
	},
	DealerFruitList = {
		"Rocket-Rocket",
		"Spin-Spin",
		"Blade-Blade",
		"Spring-Spring",
		"Bomb-Bomb",
		"Smoke-Smoke",
		"Spike-Spike",
		"Flame-Flame",
		"Ice-Ice",
		"Sand-Sand",
		"Dark-Dark",
		"Eagle-Eagle",
		"Diamond-Diamond",
		"Light-Light",
		"Rubber-Rubber",
		"Ghost-Ghost",
		"Magma-Magma",
		"Quake-Quake",
		"Buddha-Buddha",
		"Love-Love",
		"Creation-Creation",
		"Spider-Spider",
		"Sound-Sound",
		"Phoenix-Phoenix",
		"Portal-Portal",
		"Lightning-Lightning",
		"Pain-Pain",
		"Blizzard-Blizzard",
		"Gravity-Gravity",
		"Mammoth-Mammoth",
		"T-Rex-T-Rex",
		"Dough-Dough",
		"Shadow-Shadow",
		"Venom-Venom",
		"Gas-Gas",
		"Spirit-Spirit",
		"Tiger-Tiger",
		"Yeti-Yeti",
		"Kitsune-Kitsune",
		"Control-Control",
		"Dragon-Dragon"
	}
}

function hoangtuveu()
    local W = {Instances = {}}
    repeat task.wait() until game.CoreGui

    -- BombaCat Hub dashboard - interface adapted to match the supplied reference
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "BombaCatHubUI"
    gui.Parent = game:GetService("CoreGui")
    gui.Enabled = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = false

    local function make(className, props, parent)
        local obj = Instance.new(className)
        for k, v in pairs(props or {}) do obj[k] = v end
        obj.Parent = parent
        return obj
    end
    local function corner(parent, radius)
        make("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
    end
    local function label(parent, name, text, size, color, font, props)
        props = props or {}
        props.Name = name; props.Text = text; props.TextSize = size
        props.TextColor3 = color; props.Font = font or Enum.Font.Gotham
        props.BackgroundTransparency = 1
        props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
        props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
        return make("TextLabel", props, parent)
    end

    local gold = Color3.fromRGB(215, 181, 91)
    local white = Color3.fromRGB(232, 235, 243)
    local muted = Color3.fromRGB(151, 160, 178)
    local panelColor = Color3.fromRGB(7, 11, 20)
    local cardColor = Color3.fromRGB(14, 19, 31)
    local green = Color3.fromRGB(105, 220, 164)

    -- Compact centered layout matching the supplied reference image.
    local panel = make("Frame", {Name="MainPanel", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(0.5,0,0.5,0), Size=UDim2.new(0,394,0,292), BackgroundColor3=panelColor, BorderSizePixel=0}, gui)
    corner(panel, 16)
    make("UIStroke", {Color=gold, Thickness=1.6, Transparency=0.04}, panel)

    -- Floating top pill (the small "island" in the reference): stays visible
    -- while the main dashboard is hidden and toggles the dashboard on tap.
    local island = make("TextButton", {
        Name="BombaCatIsland", AnchorPoint=Vector2.new(0.5,0),
        Position=UDim2.new(0.5,0,0,-28), Size=UDim2.new(0,320,0,34),
        BackgroundColor3=Color3.fromRGB(10,16,25), BackgroundTransparency=0.04,
        BorderSizePixel=0, Text="", AutoButtonColor=true, ZIndex=20
    }, gui)
    corner(island,18)
    make("UIStroke", {Color=Color3.fromRGB(34,47,59),Thickness=1.2,Transparency=0.1}, island)
    local islandDot = make("Frame", {Name="StatusDot",Position=UDim2.new(0,12,0.5,-4),Size=UDim2.new(0,8,0,8),BackgroundColor3=green,BorderSizePixel=0,ZIndex=21}, island)
    corner(islandDot,8)
    label(island,"IslandBrand","BombaCat Hub",10,gold,Enum.Font.GothamBold,{Position=UDim2.new(0,28,0,0),Size=UDim2.new(0,91,1,0),ZIndex=21})
    local islandTask = label(island,"IslandTask","Level Farming | Mercenary | ...",10,white,Enum.Font.GothamBold,{Position=UDim2.new(0,123,0,0),Size=UDim2.new(1,-151,1,0),TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=21})
    local islandArrow = label(island,"IslandArrow",panel.Visible and "⌄" or "⌃",14,muted,Enum.Font.GothamBold,{Position=UDim2.new(1,-25,0,0),Size=UDim2.new(0,18,1,0),TextXAlignment=Enum.TextXAlignment.Center,ZIndex=21})
    island.Activated:Connect(function()
        panel.Visible = not panel.Visible
        islandArrow.Text = panel.Visible and "⌄" or "⌃"
    end)

    make("UIPadding", {PaddingTop=UDim.new(0,9),PaddingBottom=UDim.new(0,9),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)}, panel)
    make("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6), FillDirection=Enum.FillDirection.Vertical}, panel)

    local header = make("Frame", {Name="Header", LayoutOrder=1, Size=UDim2.new(1,0,0,22), BackgroundTransparency=1}, panel)
    label(header,"HubTitle","BombaCat Hub",13,gold,Enum.Font.GothamBold,{Size=UDim2.new(0.64,0,1,0),Position=UDim2.new(0,0,0,0)})
    local active = make("TextLabel", {Name="ActiveBadge",Text="● ACTIVE",TextSize=9,Font=Enum.Font.GothamBold,TextColor3=green,BackgroundColor3=Color3.fromRGB(20,48,40),BorderSizePixel=0,Size=UDim2.new(0,62,0,19),Position=UDim2.new(1,-62,0,1)}, header)
    corner(active,12)
    make("Frame", {Name="HeaderDivider",LayoutOrder=2,Size=UDim2.new(1,0,0,1),BackgroundColor3=Color3.fromRGB(49,54,66),BorderSizePixel=0},panel)

    local profile = make("Frame", {Name="PlayerSession",LayoutOrder=3,Size=UDim2.new(1,0,0,26),BackgroundColor3=cardColor,BorderSizePixel=0},panel); corner(profile,7)
    local avatar = make("ImageLabel", {Name="PlayerAvatar",BackgroundColor3=Color3.fromRGB(33,39,53),BorderSizePixel=0,Position=UDim2.new(0,4,0,3),Size=UDim2.new(0,20,0,20),Image=""},profile); corner(avatar,10)
    label(profile,"PlayerName",game:GetService("Players").LocalPlayer.DisplayName,8,white,Enum.Font.GothamBold,{Position=UDim2.new(0,29,0,0),Size=UDim2.new(0.34,0,1,0),TextTruncate=Enum.TextTruncate.AtEnd})
    local sessionLabel = label(profile,"SessionTime","0hrs, 0min, 0sec  |  Total: 0day, 0hrs, 0min, 0sec",7,gold,Enum.Font.GothamBold,{Position=UDim2.new(0.35,0,0,0),Size=UDim2.new(0.64,-5,1,0),TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd})
    task.spawn(function()
        pcall(function()
            local image = game:GetService("Players"):GetUserThumbnailAsync(game:GetService("Players").LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            avatar.Image = image
        end)
    end)
    local sessionStart = tick()
    task.spawn(function()
        while gui.Parent do
            local elapsed = math.floor(tick()-sessionStart)
            local hours = math.floor(elapsed/3600); local minutes = math.floor((elapsed%3600)/60); local seconds = elapsed%60
            sessionLabel.Text = string.format("%dhrs, %dmin, %dsec  |  Total: 0day, 0hrs, %dmin, %dsec",hours,minutes,seconds,math.floor(elapsed/60),seconds)
            task.wait(1)
        end
    end)

    local middle = make("Frame", {Name="MainSections",LayoutOrder=4,Size=UDim2.new(1,0,0,102),BackgroundTransparency=1},panel)
    local mission = make("Frame", {Name="MissionControl",Position=UDim2.new(0,0,0,0),Size=UDim2.new(0.59,-3,1,0),BackgroundColor3=cardColor,BorderSizePixel=0},middle); corner(mission,9)
    make("UIPadding",{PaddingTop=UDim.new(0,7),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,7)},mission)
    label(mission,"MissionTitle","◉  MISSION CONTROL",9,gold,Enum.Font.GothamBold,{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,14)})
    local taskLabel = label(mission,"Task","Level Farming | Claiming Quest",8,white,Enum.Font.Gotham,{Position=UDim2.new(0,0,0,19),Size=UDim2.new(1,0,0,28),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top})
    local subTaskLabel = label(mission,"SubTask","SubTask: Preparing next task...",7,muted,Enum.Font.Gotham,{Position=UDim2.new(0,0,0,53),Size=UDim2.new(1,0,0,34),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top})

    local right = make("Frame", {Name="RightSections",Position=UDim2.new(0.59,3,0,0),Size=UDim2.new(0.41,-3,1,0),BackgroundTransparency=1},middle)
    local auxCard = make("Frame",{Name="AuxiliaryTask",Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,48),BackgroundColor3=cardColor,BorderSizePixel=0},right); corner(auxCard,8)
    label(auxCard,"AuxTitle","◉  AUXILIARY TASK",7,gold,Enum.Font.GothamBold,{Position=UDim2.new(0,6,0,4),Size=UDim2.new(1,-12,0,12)})
    local auxValue = label(auxCard,"AuxValue","Farming until enough mastery for Electro",7,white,Enum.Font.Gotham,{Position=UDim2.new(0,6,0,17),Size=UDim2.new(1,-12,0,27),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top})
    local engineCard = make("Frame",{Name="EngineController",Position=UDim2.new(0,0,0,53),Size=UDim2.new(1,0,0,49),BackgroundColor3=cardColor,BorderSizePixel=0},right); corner(engineCard,8)
    label(engineCard,"EngineTitle","◉  ENGINE CONTROLLER",7,green,Enum.Font.GothamBold,{Position=UDim2.new(0,6,0,4),Size=UDim2.new(1,-12,0,12)})
    local engineValue = label(engineCard,"EngineValue","LevelFarm",8,white,Enum.Font.Gotham,{Position=UDim2.new(0,6,0,18),Size=UDim2.new(1,-12,0,20)})

    local stats = make("Frame",{Name="Stats",LayoutOrder=5,Size=UDim2.new(1,0,0,43),BackgroundTransparency=1},panel)
    make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5)},stats)
    local function statCard(name,titleText,valueText,order)
        local card=make("Frame",{Name=name,LayoutOrder=order,Size=UDim2.new(1/3,-4,1,0),BackgroundColor3=cardColor,BorderSizePixel=0},stats); corner(card,8)
        label(card,name.."Title",titleText,7,gold,Enum.Font.GothamBold,{Position=UDim2.new(0,6,0,4),Size=UDim2.new(1,-10,0,12),TextTruncate=Enum.TextTruncate.AtEnd})
        return label(card,name.."Value",valueText,11,white,Enum.Font.GothamBold,{Position=UDim2.new(0,6,0,19),Size=UDim2.new(1,-10,0,18),TextTruncate=Enum.TextTruncate.AtEnd})
    end
    local levelValue=statCard("PlayerLevel","♧ PLAYER LEVEL","--",1)
    local beliValue=statCard("Beli","◈ BELI/WEALTH","$ --",2)
    local fragmentsValue=statCard("Fragments","✧ FRAGMENTS","--",3)

    local masteryCard=make("Frame",{Name="CombatMastery",LayoutOrder=6,Size=UDim2.new(1,0,0,39),BackgroundColor3=cardColor,BorderSizePixel=0},panel); corner(masteryCard,8)
    label(masteryCard,"MasteryTitle","◉  COMBAT MASTERY / ARSENAL",8,Color3.fromRGB(182,112,255),Enum.Font.GothamBold,{Position=UDim2.new(0,7,0,3),Size=UDim2.new(1,-14,0,12)})
    local masteryValue=label(masteryCard,"MasteryValue","Current weapon/style: --",9,white,Enum.Font.Gotham,{Position=UDim2.new(0,7,0,17),Size=UDim2.new(1,-14,0,17),TextTruncate=Enum.TextTruncate.AtEnd})

    W.Instances['Task1'] = taskLabel
    W.Instances['Task2'] = subTaskLabel
    W.Instances['MainTextLabel'] = taskLabel
    W.Instances['AuxValue'] = auxValue
    W.Instances['EngineValue'] = engineValue
    W.Instances['MasteryValue'] = masteryValue
    W.Instances['IslandTask'] = islandTask
    W.Instances['DebugLine'] = engineValue -- [FIX] o Engine Controller nunca atualizava (a chave DebugLine não existia)

    function SetText(key, text)
        -- [FIX] sem animação de fade: com atualizações rápidas os tweens competiam e o texto ficava quase invisível
        local target = W.Instances[key]
        if not target then return end
        text = tostring(text)
        if target.Text ~= text then target.Text = text end
        if target.TextTransparency ~= 0 then target.TextTransparency = 0 end
    end
    task.spawn(function()
        while gui.Parent do
            pcall(function()
                local data = game:GetService("Players").LocalPlayer:FindFirstChild("Data")
                local level = data and data:FindFirstChild("Level")
                local beli = data and data:FindFirstChild("Beli")
                local frags = data and data:FindFirstChild("Fragments")
                levelValue.Text = level and tostring(level.Value) or "--"
                beliValue.Text = beli and ("$ " .. tostring(beli.Value)) or "$ --"
                fragmentsValue.Text = frags and tostring(frags.Value) or "--"
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                local tool = character and character:FindFirstChildOfClass("Tool")
                if not tool and player:FindFirstChild("Backpack") then tool = player.Backpack:FindFirstChildOfClass("Tool") end
                local mastery = tool and tool:FindFirstChild("Level")
                masteryValue.Text = tool and (tool.Name .. ": " .. (mastery and tostring(mastery.Value) or "--")) or "Current weapon/style: --"
            end)
            task.wait(1)
        end
    end)
    getgenv().alert = function() end
    W.SetText = SetText
    -- [FIX] a barra (ilha) estava fixa em "Level Farming | Mercenary | ...": agora segue MainTask | SubTask
    task.spawn(function()
        while gui.Parent do
            pcall(function()
                local T = ScriptStorage and ScriptStorage.Task
                if T then
                    local m = tostring(T.MainTask or "")
                    local sb = tostring(T.SubTask or "")
                    local txt = m
                    if sb ~= "" and sb ~= "Idle" then txt = m .. " | " .. sb end
                    if txt ~= "" and islandTask.Text ~= txt then islandTask.Text = txt end
                end
            end)
            task.wait(0.4)
        end
    end)
    W.ToggleUI = function()
        panel.Visible = not panel.Visible
        islandArrow.Text = panel.Visible and "⌄" or "⌃"
    end
    W.ToggleInterface = W.ToggleUI
    W.RegisterForBlur = function() end

    -- ============================================================
    -- LOGIC TỪ TEST.TXT (GIỮ NGUYÊN, BAO GỒM FAST ATTACK VÀ EQUIP)
    -- ============================================================
    if false then
        spawn(function()
            pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/sucvatthieunang/Trackstat/refs/heads/main/cac")))
        end)
    end
    alert("cac", "Endpoint reached")
    OldSessionTime = isfile and readfile and isfile('.tdif-' .. game.Players.LocalPlayer.Name) and tonumber(readfile(".tdif-" .. game.Players.LocalPlayer.Name)) or 0
    repeat
        task.wait()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)
    until game.Players.LocalPlayer.Character
    alert("team assembled")
    repeat wait() until game.Players.LocalPlayer.Character
    spawn(function()
        game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild('NewIslandLOD', 9999):Destroy()
        game:GetService("Players")
        LocalPlayer.PlayerScripts:WaitForChild('IslandLOD', 9999):Destroy()
    end)
    alert('wait 1', 'ok')
    local J = {'RawConstants', "Utilly", "QuestManager", 'SpawnRegionLoader', 'TweenController', "AttackController", 'CombatController', 'FunctionsHandler', "Hooks", "Debug", "Hop", "Storage"}
    StartTick = tick()
    repeat
        task.wait()
    until SetText
    alert('load 2')
    SetText('MainTextLabel', 'Initalizing Script..')
    local J = "Rua_Hub/Blox_Fruit/Assets/"
    ScriptStorage = {IsInitalized = false, PlayerData = {}, Melees = {}, CurrentMeleeData = {}, Enemies = {}, Tools = {}, Backpack = {}, IgnoreStoreFruits = {}, Connections = {LocalPlayer = {}}, Task = {}, Tracebacks = {}, TaskController = {}, TracebackUpdater = {}, Interface = W, NPCs = {}, Map = {}}
    Players = game.Players
    LocalPlayer = Players.LocalPlayer
    Character = Players.LocalPlayer.Character
    Humanoid = Character:WaitForChild('Humanoid')
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    PlayerGui = LocalPlayer:WaitForChild('PlayerGui', 10)
    Lighting = game:GetService('Lighting')
    Services = {}
    setmetatable(Services, {__index = function(J, J) return game:GetService(J) end})
    setmetatable(ScriptStorage.Enemies, {__index = function(J, J) return Services.Workspace.Enemies:FindFirstChild(J) or Services.ReplicatedStorage:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Map, {__index = function(J, J) return Services.Workspace.Map:FindFirstChild(J) or Services.Workspace:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Tools, {__index = function(J, J) return LocalPlayer.Character:FindFirstChild(J) or (LocalPlayer:FindFirstChild('Backpack') and LocalPlayer.Backpack:FindFirstChild(J)) end})
    setmetatable(ScriptStorage.NPCs, {__index = function(J, J) if not J then return end; return workspace.NPCs:FindFirstChild(J) or game.ReplicatedStorage.NPCs:FindFirstChild(J) end})

    -- ============================================================
    -- [NEW] PANIC MODE + AUTO KEN — đặt sớm ngay đầu, chạy độc lập qua
    -- task.spawn riêng (không qua TasksOrder) để phản ứng máu thấp NGAY
    -- LẬP TỨC, không phải chờ tới lượt dispatch. Gộp chung Auto-Ken vào
    -- đây theo đúng yêu cầu boss man.
    -- ============================================================
    _G.PanicModeActive = false

    task.spawn(function()
        local escapeY = nil
        while task.wait(Config.PanicMode.CheckInterval) do
            pcall(function()
                if not Config.PanicMode.Enabled then return end
                local char = LocalPlayer.Character
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")

                -- [FIXED] Nhân vật chết lúc đang trốn trên cao (_G.PanicModeActive
                -- = true) mà không reset state → lúc hồi sinh, nhân vật MỚI (máu
                -- đầy, đứng dưới đất) bị code tưởng "đang trốn, cần giữ độ cao cũ"
                -- → kéo lên trời vô lý ngay sau khi respawn. Reset ngay khi phát
                -- hiện chết, không chỉ return im lặng.
                if not hum or not hrp or hum.Health <= 0 then
                    if _G.PanicModeActive then
                        _G.PanicModeActive = false
                        escapeY = nil
                    end
                    return
                end

                local pct = (hum.Health / hum.MaxHealth) * 100

                if not _G.PanicModeActive and pct < Config.PanicMode.LowHealthPercent then
                    -- [FIXED] Huỷ tween đang chạy (nếu có) trước khi ép CFrame —
                    -- không thì TweenController đang chạy dở (VD: LevelFarm đang
                    -- tween tới quest) sẽ tiếp tục update CFrame theo hướng CŨ ở
                    -- frame sau, kéo nhân vật xuống lại gần như ngay lập tức,
                    -- vô hiệu hoá panic mode.
                    pcall(function() if TweenInstance then TweenInstance:Cancel() end end)
                    _G.PanicModeActive = true
                    escapeY = hrp.Position.Y + Config.PanicMode.EscapeHeight
                    SetTask("MainTask", "⚠️ PANIC MODE | Máu " .. math.floor(pct) .. "% — bay lên trốn")
                    hrp.CFrame = CFrame.new(hrp.Position.X, escapeY, hrp.Position.Z)

                elseif _G.PanicModeActive then
                    -- Đang trốn trên cao — giữ nguyên độ cao, chờ hồi máu
                    if hrp.Position.Y < (escapeY or 0) - 50 then
                        pcall(function() if TweenInstance then TweenInstance:Cancel() end end)
                        hrp.CFrame = CFrame.new(hrp.Position.X, escapeY, hrp.Position.Z)
                    end
                    if pct >= Config.PanicMode.SafeHealthPercent then
                        -- [NEW] Hồi đủ máu → bay xuống lại, tắt panic mode
                        SetTask("MainTask", "✅ Máu hồi " .. math.floor(pct) .. "% — bay xuống tiếp tục farm")
                        _G.PanicModeActive = false
                        escapeY = nil
                    else
                        SetTask("SubTask", "PANIC MODE | Đang trốn trên cao — máu " .. math.floor(pct) .. "%/" .. Config.PanicMode.SafeHealthPercent .. "%")
                    end
                end
            end)
        end
    end)

    -- [NEW] Auto Ken (Haki Quan Sát / Observation Haki) — spam liên tục
    -- tới khi mở được thì ngưng, không spam nữa
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if not Config.AutoKen then return end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HasKen") then
                    return -- đã mở rồi, không spam nữa
                end
                Services.ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
            end)
        end
    end)


    function CreateTraceback(J, W) table.insert(ScriptStorage.Tracebacks, (GetCurrentDateTime() .. ' ( ' .. DispTime(os.time() - os.time(), true) .. ' ) after execution | ' .. J .. " | " .. W)) end
    function Report(message)
        pcall(function()
            print("[Kaitun Report]", tostring(message))
            CreateTraceback("Report", tostring(message))
        end)
    end
    function SetTask(J, W)
        if ScriptStorage.Task[J] == W then return end
        local a = {MainTask = "Task1", SubTask = 'Task2'}
        if a[J] then if SetText then SetText(a[J], J .. ' : ' .. W) end end
        ScriptStorage.Task[J] = W
        ScriptStorage.Task[J .. '-d'] = os.time()
    end
    Remotes = {}
    BindedMeleeNPCNames = {BlackLeg = 'Dark Step Teacher', Electro = "Mad Scientist", FishmanKarate = "Water Kung-fu Teacher", DeathStep = "Phoeyu, the Reformed", SharkmanKarate = 'Sharkman Teacher', DragonTalon = "Uzoth", ElectricClaw = 'Previous Hero', Godhuman = "Ancient Monk"}
    local J = {}
    setmetatable(Remotes, {__index = function(W, W)
        if W ~= 'CommF_' then
            print('captured unregistered signal', key)
            return Services.ReplicatedStorage.Remotes[W]
        end
        local W = {InvokeServer = function(a, ...)
            print('remote fired', ...)
            local a, h = ...
            if string.find(a, "Buy") == 1 and not h then
                local h = string.gsub(a, 'Buy', "")
                if BindedMeleeNPCNames then
                    if table.find(J, h) then
                        local a = ScriptStorage.NPCs[BindedMeleeNPCNames[h]]
                        if a then
                            local h = a.WorldPivot
                            if CaculateDistance(h) > 10 then
                                repeat
                                    wait(1)
                                    TweenController.Create(h.Position)
                                until CaculateDistance(h) < 10
                                task.wait(3)
                                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
                            end
                        end
                    end
                end
            end
            return Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
        end}
        return W
    end})
    Tasks = {}
    function AwaitUntilPlayerLoaded(W, a)
        repeat task.wait() until W.Character and W.Character:FindFirstChild('Humanoid')
        local hum = W.Character.Humanoid
        repeat task.wait() until hum.Health > 0
    end
    function AddPoint()
        local W = {}
        local a
        for h, h in LocalPlayer.Data.Stats:GetChildren() do
            if h and h:FindFirstChild('Level') then W[h.Name] = h.Level.Value end
        end
        if W.Defense < MaxLevel and (W.Defense < (ScriptStorage.PlayerData.Level / 80) or MaxLevel - W.Melee < 100) then
            a = 'Defense'
        elseif W.Melee < MaxLevel then
            a = "Melee"
        else
            a = 'Sword'
        end
        Remotes.CommF_:InvokeServer("AddPoint", a, 999)
    end
    local W = {Currencies = {Level = "#00BFFF", Beli = "#00BFFF", Fragments = "#00BFFF"}, Races = {}}
function RefreshPlayerData()
    pcall(function()
        for a, a in LocalPlayer.Data:GetChildren() do 
            pcall(function() ScriptStorage.PlayerData[a.Name] = a.Value end) 
        end
    end)
    local a = ""
    for h, X in ScriptStorage.PlayerData do
        local w = W.Currencies[h]
        if w then a = a .. '<font color="' .. w .. '">' .. h .. "</font>: " .. X .. ' ' end
    end
    if ScriptStorage.Interface then SetText('Currencies', a) end
end
    function RefreshRace()
        local W, a = Remotes.CommF_:InvokeServer('Alchemist', "1"), Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        ScriptStorage.PlayerData.RaceLevel = 1
        if LocalPlayer.Character:FindFirstChild("RaceTransformed") then
            ScriptStorage.PlayerData.RaceLevel = 4
        elseif a == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 3
        elseif W == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 2
        end
    end
    function RefreshInventory()
        ScriptStorage.Backpack = {}
        local LP = game.Players.LocalPlayer
        local ok, Items = pcall(function() return require(game.ReplicatedStorage.ItemReplicationService)._UserCache[LP.UserId] end)
        if not ok or not Items then
            for W, W in Remotes.CommF_:InvokeServer('getInventory') do ScriptStorage.Backpack[W.Name] = W end
            return
        end
        local Q = Items:GetItems("Quantity")
        local M = Items:GetItems("Mastery")
        local C = require(game.ReplicatedStorage.ItemConfig)
        local W = require(game.ReplicatedStorage.Modules.CombatUtil)
        local mas = {}
        if M then for _, v in pairs(M) do mas[v.ItemId] = v.Value end end
        local function clean(s) return s:gsub(" %[.-%]", "") end
        for _, v in pairs(Q) do
            local id, qt = v.ItemId, v.Value
            local ty, dn = "?", ""
            pcall(function()
                local c = C.match(id):unwrap()
                if c and c.Index then ty = c.Index.IdType; dn = c.Index.DebugLabel end
            end)
            local name = clean(dn)
            if name ~= "" then
                local entry = {Name = name, Count = qt, ItemId = id}
                ScriptStorage.Backpack[name] = entry
                if ty == "Moveset" or ty == "PhysicalMoveset" then
                    local md = mas[id]
                    if md then
                        local wd = W:GetWeaponData(name)
                        if wd then
                            if tostring(wd.WeaponType):find("Sword") then
                                entry.Type = "Sword"
                                entry.Mastery = md
                                entry.MasteryRequirements = {[1] = 350}
                            else
                                ScriptStorage.Melees[name] = md
                            end
                        end
                    end
                end
            end
        end
    end
    function ResearchMoves(W)
        if W and tostring(W) == 'V' then
            if ScriptStorage.Connections.BurstCheck then
                ScriptStorage.Connections.BurstCheck:Disconnect()
                task.wait(1)
            end
            print('[ Debug ] Registering burst', W)
            ScriptStorage.Connections.BurstCheck = W.Cooldown:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if EnablingBurstDebounce and os.time() - EnablingBurstDebounce < 10 then return end
                local a = W.Cooldown.AbsoluteSize.X
                if a < 3 then
                    EnablingBurstDebounce = os.time()
                    task.wait(5)
                    SendKey('V', 0)
                end
            end)
        end
    end
    function CheckMeleeBurstMove(W)
        if W.Name == "Black Leg" or W.Name == "Death Step" then
            local a = PlayerGui.Main.Skills:WaitForChild(W.Name, 9)
            ResearchMoves(a:WaitForChild("V"))
        end
    end
    function RefreshMelees(W)
        local a = ''
        for h, X in ScriptStorage.Melees do a = a .. h .. ": " .. X .. " " end
        a = a == '' and '[0]' or a
        if W then return a end
        if ScriptStorage.Interface then SetText('Melees', a) end
    end
    function MeleeCheck(W)
        print('Melee check', W)
        if W and typeof(W) == "Instance" and W:IsA("Tool") then
            if W.ToolTip == "Melee" then
                if ScriptStorage.Connections.Melees then ScriptStorage.Connections.Melees:Disconnect() end
                ScriptStorage.CurrentMeleeData.Name = W.Name
                pcall(function() ScriptStorage.Connections.Melees:Destroy() end)
                local lv = W:FindFirstChild("Level")
                if lv then
                    ScriptStorage.Connections.Melees = lv.Changed:Connect(function(a)
                        ScriptStorage.Melees[W.Name] = a
                        RefreshMelees()
                    end)
                    ScriptStorage.Melees[W.Name] = lv.Value
                end
                RefreshMelees()
            elseif string.find(tostring(W), "Fruit") then
                task.spawn(function()
                    if table.find(ScriptStorage.IgnoreStoreFruits, W:GetAttribute('OriginalName')) then return end
                    local a = Remotes.CommF_:InvokeServer("StoreFruit", W:GetAttribute("OriginalName"), W)
                end)
            end
        end
    end
    SetText('MainTextLabel', 'Refreshing Player Data')
    MeleeCheck(LocalPlayer.Character:FindFirstChildOfClass('Tool'))
    RefreshPlayerData()
    function RegisterLocalPlayerEventsConnection()
        task.spawn(function()
            -- [FIXED - bớt delay theo yêu cầu boss man] 6s → 3s. Đủ để
            -- Character/Data ổn định sau spawn trước khi check HasBuso.
            task.wait(3)
            if LocalPlayer.Character:FindFirstChild('HasBuso') then return end
            Remotes.CommF_:InvokeServer("Buso")
        end)
        for W, W in ScriptStorage.Connections.LocalPlayer do pcall(function() W:Disconnect() end) end
        AwaitUntilPlayerLoaded(LocalPlayer)
        LocalPlayer:SetAttribute("IsAvailable", true)
        ScriptStorage.Connections.LocalPlayer["HealthCheck"] = LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
            local W = LocalPlayer.Character.Humanoid.Health
            LocalPlayer:SetAttribute("IsAvailable", W > 10)
            ScriptStorage.LocalPlayerHealth = W
        end)
        ScriptStorage.Connections.LocalPlayer['Melee'] = LocalPlayer.Character.ChildAdded:Connect(MeleeCheck)
        local bp = LocalPlayer:WaitForChild("Backpack")
        ScriptStorage.Connections.LocalPlayer['Fruit'] = bp.ChildAdded:Connect(MeleeCheck)
        for _, c in ipairs(bp:GetChildren()) do MeleeCheck(c) end
        LastIdleCheck = os.time()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        ScriptStorage.Connections.LocalPlayer.PositionChecker = hrp:GetPropertyChangedSignal('CFrame'):Connect(function()
            if os.time() == LastIdleCheck then return end
            LastIdleCheck = os.time()
            if oldPos then
                if (hrp.CFrame.p - oldPos).magnitude < 2 then return end
            end
            oldPos = (hrp.CFrame.p)
            LastIdling = os.time()
        end)
        local W = LocalPlayer.Data:WaitForChild('Points')
        ScriptStorage.Connections.LocalPlayer.PointConnection = W:GetPropertyChangedSignal('Value'):Connect(function()
            local W = LocalPlayer.Data:WaitForChild('Points')
            if OldPointValue == W then return end
            OldPointValue = W
            AddPoint()
        end)
    end
    RegisterLocalPlayerEventsConnection(LocalPlayer)
    game.Players.LocalPlayer.CharacterAdded:Connect(function(W)
        print('[ Debug ] re-registering events')
        RegisterLocalPlayerEventsConnection(LocalPlayer)
    end)
    task.spawn(function()
        task.wait(3)
        if LocalPlayer.Character:FindFirstChild("HasBuso") then return end
        Remotes.CommF_:InvokeServer("Buso")
    end)
    print(1)

    -- ============================================================
    -- BẢNG MELEE & DATA (GIỮ NGUYÊN)
    -- ============================================================
    MeleesTable = {"Black Leg", 'Electro', "Fishman Karate", "Dragon Claw", "Superhuman", 'Death Step', 'Electric Claw', 'Sharkman Karate', 'Dragon Talon', "Godhuman"}
    MeleesId = {'BlackLeg', "Electro", 'FishmanKarate', "DragonClaw", "Superhuman", 'DeathStep', "ElectricClaw", "SharkmanKarate", 'DragonTalon', 'Godhuman'}
    MeleePrices = {["Black Leg"] = {Price = {Beli = 150000}, Id = "BlackLeg", NextLevelRequirement = 300, position = CFrame.new(), Requirements = function() return true end, Buy = function(W) return BuyMelee("BlackLeg", W, 'Dark Step Teacher') end}, ['Electro'] = {Price = {Beli = 500000}, Id = 'Electro', NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('Electro', W, "Mad Scientist") end}, ['Fishman Karate'] = {Price = {Beli = 750000}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('FishmanKarate', W, 'Water Kung-fu Teacher') end}, ['Dragon Claw'] = {Price = {Fragments = 1500}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonClaw", W, "Sabi") end}, ["Superhuman"] = {Price = {Beli = 3000000}, NextLevelRequirement = nil, Requirements = function() return true end, Buy = function(W) return BuyMelee("Superhuman", W, "Martial Arts Master") end}, ["Death Step"] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DeathStep", W, "Phoeyu, the Reformed") end}, ['Sharkman Karate'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee('SharkmanKarate', W, 'Sharkman Teacher') end}, ['Electric Claw'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("ElectricClaw", W, 'Previous Hero') end}, ['Dragon Talon'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonTalon", W, 'Uzoth') end}, ["Godhuman"] = {Price = {Beli = 5000000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("Godhuman", W, 'Ancient Monk') end}}
    DropItemData = {['Buddy Sword'] = {Sea = 3, Level = 1500, Boss = "Cake Queen"}, ['Canvander'] = {Sea = 3, Level = 1500, Boss = "Beautiful Pirate"}, ['Twin Hooks'] = {Sea = 3, Level = 1500, Boss = 'Captain Elephant'}, ["Venom Bow"] = {Sea = 3, Level = 1500, Boss = "Hydra Leader"}}
    GodhumanMaterials = {['Fish Tail'] = {20, 3, {"Fishman Raider", "Fishman Captain"}, {'DeepForestIsland3', 1, 1775, 'Turtle Adventure Quest Giver'}}, ['Dragon Scale'] = {10, 3, {"Dragon Crew Warrior", "Dragon Crew Archer"}, {'DragonCrewQuest', 1, 1575, 'Dragon Crew Quest Giver'}}, ["Magma Ore"] = {20, 2, {'Magma Ninja'}, {"FireSideQuest", 1, 1100, "Fire Quest Giver"}}, ["Mystic Droplet"] = {10, 2, {'Sea Soldier', 'Water Fighter'}, {'ForgottenQuest', 2, 1425, 'Forgotten Quest Giver'}}}
    SeaIndexes = {"Main", "Dressrosa", "Zou"}

    -- [FIXED - QUAN TRỌNG] RefreshTasksData là first-match-wins: handler
    -- nào Refresh() trả về giá trị TRƯỚC trong mảng này thắng NGAY, dừng
    -- luôn (return ở dòng ~4051), không kiểm tra tiếp các handler sau.
    -- "LevelFarm" đứng đầu + Refresh gần như LUÔN trả về (1/2/4, hiếm khi
    -- nil) → nó thắng MỌI vòng, SpecialBossesTask/SwordBossTask/
    -- CakePrinceTask/BossesTask phía sau KHÔNG BAO GIỜ được chạy tới —
    -- đây mới là lý do thật "không thấy farm boss lấy item", không phải
    -- do boss hiếm/config sai. Đưa hết boss-farming lên TRƯỚC LevelFarm:
    -- boss nào đang farm được thì ưu tiên, hết boss mới rơi xuống LevelFarm.
    -- [FIXED - XUNG ĐỘT] Lúc reorder ưu tiên boss-farming (lượt trước), tao
    -- viết đè nguyên khối TasksOrder và LÀM MẤT 5 handler đã fix từ rất lâu
    -- ("Saber","CursedDualKatana","SoulGuitar","EvoRace","RaceAwakening") —
    -- y hệt bug gốc "registered nhưng không nằm trong TasksOrder = không
    -- bao giờ chạy" mà tao đã tốn nhiều lượt để tìm ra và fix trước đó.
    -- Khôi phục lại đầy đủ, vẫn giữ thứ tự ưu tiên boss-farming mới.
    -- [FIXED - theo spec 2e/2g] RaidController tự check "fr > 5000 then
    -- return nil" ĐÚNG rồi (dòng ~3005) — vấn đề là nó đứng SAU
    -- CakePrinceTask/MeleesController/CDK trong TasksOrder (first-match-
    -- wins), nên dù Fragments cạn, mấy handler "training" phía trước vẫn
    -- thắng dispatch trước, RaidController không bao giờ được chạy tới.
    -- Đưa RaidController/AutoRaidIce lên TRƯỚC các hoạt động "training"
    -- (không khẩn cấp như boss hiếm) — Fragments thấp thì tự nhường,
    -- Fragments đủ thì RaidController tự trả nil, rơi xuống training tiếp.
    -- [FIXED - theo spec 2g] "MeleesController" đứng CUỐI danh sách khiến
    -- LevelFarm (đứng rất trước, Refresh gần như luôn trả về giá trị) LUÔN
    -- thắng dispatch — "melee đủ mastery thì dừng LevelFarm chuyển bước
    -- tiếp theo" không bao giờ có cơ hội xảy ra vì MeleesController không
    -- bao giờ được chạy tới. Đưa lên ngang hàng ưu tiên với CakePrinceTask
    -- (trước LevelFarm) — mua melee/kiểm tra điều kiện tiên quyết giờ mới
    -- thật sự preempt được leveling thường.
    TasksOrder = {
        "SpecialBossesTask", "SwordBossTask", "BossesTask",
        "RaidController", "AutoRaidIce",
        "CakePrinceTask", "MeleesController",
        "Saber", -- [FIX] antes do LevelFarm (o LevelFarm quase nunca devolve nil e bloqueava o Saber)
        "LevelFarm", "Tushita", 'Yama',
        "CursedDualKatana", "SoulGuitar", "EvoRace", "RaceAwakening",
        -- [FIXED - xung đột code phát hiện khi rà toàn bộ] Bỏ "Wenlocktoad"
        -- và "ExpRedeem" khỏi danh sách này — cả 2 CÓ gọi :Register() (tạo
        -- task slot rỗng) nhưng KHÔNG hề có RegisterMethod("Refresh"/"Start")
        -- ở bất kỳ đâu trong file. Dispatcher (RefreshTasksData, có "if k
        -- then" guard trước khi gọi) không crash vì việc này, nhưng mỗi tick
        -- vẫn tốn 1 lần lookup FunctionsHandler[name] + kiểm tra Initalized
        -- cho 2 task không bao giờ làm gì cả — dọn bỏ. Cũng bỏ luôn bản
        -- "ThirdSeaPuzzle" bị lặp 2 lần (1 lần double-quote, 1 lần single-
        -- quote) — hệ thống first-match-wins nên lần lặp lại chỉ tốn thêm
        -- 1 lần gọi Refresh() y hệt trong CÙNG 1 tick, không có tác dụng gì.
        'Trevor', "UtillyItemsActivitation", 'ColosseumPuzzle', "ThirdSeaPuzzle", "PirateRaid", "SecondSeaPuzzle", "CollectDrops"}
    MaxLevel = 2800
    placeId = game.PlaceId
    if placeId == 85211729168715 or placeId == 2753915549 then
        Sea = 'Main'
        SeaIndex = 1
    elseif placeId == 79091703265657 or placeId == 4442272183 then
        Sea = "Dressrosa"
        SeaIndex = 2
    elseif placeId == 100117331123089 or placeId == 7449423635 then
        Sea = "Zou"
        SeaIndex = 3
    end
    Portals = ({{Vector3.new(-7894.6201171875, 5545.49169921875, -380.246346191406), Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625), Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875), Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)}, {Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312), Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625), Vector3.new(923.21252441406, 126.9760055542, 32852.83203125), Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)}, {}})[SeaIndex]
    -- [FIXED] Bỏ 'Cake Prince' khỏi đây — giờ có CakePrinceTask riêng
    -- (chủ động farm quái mở khoá + tự trigger summon), tránh 2 hệ thống
    -- cùng đánh 1 boss gây xung đột combat
    BossesOrder = {"Awakened Ice Admiral", "Tide Keeper", 'Deandre', "Urban", "Diablo", 'Soul Reaper'}
    BossesOrderLevel = {['Awakened Ice Admiral'] = 700, ['Tide Keeper'] = 700, ['Deandre'] = 1500, ['Urban'] = 1500, ['Diablo'] = 1500, ['Soul Reaper'] = 1500}
    BossesOrderWL = {["Deandre"] = 1500, ["Urban"] = 1500, ["Diablo"] = 1500, ['Don Swan'] = 1100, ["Awakened Ice Admiral"] = 700, ['Tide Keeper'] = 700}
    -- [ADDED] Katakuri — KHÔNG tìm thấy trong file nat kaitun hay bất kỳ
    -- nguồn nào tao có, nên đây là giá trị đoán an toàn (level 2150, giống
    -- mức các boss cuối game khác). Nếu sai level thật, báo tao sửa lại.
    -- [FIXED] "Hải Tặc Đào Hoa" = "Beautiful Pirates" — trước đây tao đoán
    -- nhầm là Cake Prince, boss man đã sửa lại đúng tên. Toạ độ lấy từ
    -- file bypass-teleport verified (Vector3.new(5319, 23, -93)) — level
    -- chưa có nguồn xác nhận, tạm để 1500 giống tier Deandre/Urban/Diablo,
    -- báo tao nếu sai.
    SpecialBossesOrder = {["Core"] = 700, ['Darkbeard'] = 700, ["Katakuri"] = 2150, ["Beautiful Pirates"] = 1500}
    -- [NEW - theo spec] Toạ độ farm Bones ở Haunted Castle, dùng chung cho
    -- Fire Essence (Dragon Talon), Hallow Essence (CDK), và Yama/Tushita
    HAUNTED_CASTLE_BONES_CF = CFrame.new(-8817.880859375, 191.16761779785, 6298.6557617188)
    BeautifulPiratesCF = CFrame.new(5319, 23, -93)

    -- Config.Sword và Config.BossWeapons giờ nằm ở đầu file (khối Config = {...})
    -- theo đúng yêu cầu "để config lên trên cùng" — không định nghĩa lại ở đây nữa
    BlankTablets = {"Segment6", 'Segment2', 'Segment8', "Segment9", 'Segment5'}
    Trophy = {["Segment1"] = "Trophy1", ["Segment3"] = "Trophy2", ['Segment4'] = "Trophy3", ['Segment7'] = "Trophy4", ["Segment10"] = "Trophy5"}
    Pipes = {['Part1'] = 'Really black', ['Part2'] = 'Really black', ["Part3"] = "Dusty Rose", ['Part4'] = "Storm blue", ['Part5'] = 'Really black', ['Part6'] = "Parsley green", ["Part7"] = 'Really black', ["Part8"] = "Dusty Rose", ["Part9"] = 'Really black', ['Part10'] = 'Storm blue'}
    function GenerateUUID()
        local W = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", '[xy]', function(W)
            local W = (Idx == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', W)
        end)
    end
    function CheckIsPlayerAlive(W) W = W or LocalPlayer; return W and W.Character and W.Character.Humanoid and W.Character.HumanoidRootPart and W.Character.Head and W.Character.Humanoid.Health > 0 end
    function ConvertTo(W, a) return W.new(a.X, a.Y, a.Z) end
    function CaculateDistance(W, a)
        if not W then return 0 end
        a = a or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        local h, X = ConvertTo(Vector3, W), ConvertTo(Vector3, a)
        return (h - X).magnitude
    end
    function DispTime(W, a)
        W = tonumber(W)
        if not W then return "[err]" end
        local h = math.floor(W / 86400)
        local X = math.floor(math.fmod(W, 86400) / 3600)
        local w = math.floor(math.fmod(W, 3600) / 60)
        local D = math.floor(math.fmod(W, 60))
        if a then return (h .. "day, " .. X .. "hrs, " .. w .. "min, " .. D .. 'sec.') end
        return (h .. 'day, ' .. X .. "hrs.")
    end
    function GetCurrentDateTime()
        local W = os.date("*t")
        local a = W.hour
        local h = W.min
        local X = W.day
        local w = W.month
        local D = W.year
        local y = W.wday
        local W = string.format('%02d:%02d ', a, h)
        local a = {'Sun', "Mon", 'Tue', "Wed", 'Thu', "Fri", 'Sat'}
        local h = a[y]
        local a = {"Jan", "Feb", "Mar", 'Apr', "May", 'Jun', "Jul", 'Aug', 'Sep', "Oct", 'Nov', "Dec"}
        local y = a[w]
        local a = string.format('%s, %s %d %d', h, y, X, D)
        return W .. a
    end
    function RandomArguments(...) local W = {...}; return W[math.random(0, #W)] end
    function RoundVector3Down(W) return Vector3.new(math.floor(W.X / 10) * 10, math.floor(W.Y / 10) * 10, math.floor(W.Z / 10) * 10) end

    -- ============================================================
    -- XOAY VÒNG TRÒN CŨ (DÙNG TICK)
    -- ============================================================
    -- [FIXED] W_angle/lastChange chưa từng được khởi tạo — gọi hàm này lần
    -- đầu sẽ crash ("attempt to compare nil with number") vì so sánh
    -- W_angle (nil) > 50000. Khởi tạo trước khi dùng.
    W_angle = W_angle or 0
    lastChange = lastChange or tick()

    -- [UPDATED] Đổi tốc độ theo bản boss man đưa: 0.01s / 20° (mượt hơn
    -- bản cũ 0.4s / 80°, xoay liên tục thay vì giật cục)
    CaculateCircreDirection = function(a)
        if W_angle > 50000 then W_angle = 60 end
        W_angle = W_angle + ((tick() - lastChange) > 0.01 and 20 or 0)
        if tick() - lastChange > 0.01 then lastChange = tick() end
        local h = a + Vector3.new(math.cos(math.rad(W_angle)) * 40, 0, math.sin(math.rad(W_angle)) * 40)
        return CFrame.new(RoundVector3Down(h.p))
    end

    function GetMonAsSortedRange()
        local W = {}
        table.foreach(Services.Workspace.Enemies:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.foreach(game.ReplicatedStorage:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.sort(W, function(a, h) return CaculateDistance(a.HumanoidRootPart.CFrame) < CaculateDistance(h.HumanoidRootPart.CFrame) end)
        return W
    end
    print(1.5)
    function GetMeleeIdByName(W) for a, h in MeleesTable do if h == W then return MeleesId[a] end end end
    function FindMeleeNPC(npcName)
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
            if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
                return npc.HumanoidRootPart.Position
            end
        end
        return nil
    end
    function getpos(W)
        for a, a in game:GetService("ReplicatedStorage").NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
        for a, a in workspace.NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
    end

    -- ============================================================
    -- HÀM HỖ TRỢ AUTO FULL MELEE
    -- ============================================================
    function GetBP(meleeName)
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild(meleeName) then return bp[meleeName] end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild(meleeName) then return char[meleeName] end
        return nil
    end

    function GetM(matName)
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return 0 end
        for _, v in pairs(bp:GetChildren()) do
            if v.Name == matName and v:FindFirstChild("Count") then
                return v.Count.Value
            end
        end
        return 0
    end

    function GetConnectionEnemies(enemyName)
        local nearest, dist = nil, math.huge
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name == enemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (root.Position - hrp.Position).Magnitude
                    if d < dist then
                        dist = d
                        nearest = enemy
                    end
                end
            end
        end
        return nearest
    end

    function BuyMelee(W, a)
        if W == "DragonClaw" then
            if workspace.NPCs:FindFirstChild('Sabi') then
                if a then
                    if type(Remotes.CommF_:InvokeServer("BlackbeardReward", 'DragonClaw', '1') == 1) == "number" and Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1') == 1 == 1 and not table.find(J, W) then table.insert(J, W) end
                    return Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
                end
                return Remotes.CommF_:InvokeServer('BlackbeardReward', "DragonClaw", '2')
            end
        end
        if W == "Godhuman" then
            -- [FIXED - verified từ message_10] BuyGodhuman cần gọi 2 LẦN
            -- (true, rồi không tham số) — generic 1-lần bên dưới không đủ,
            -- y hệt pattern Dragon Talon đã verify trước đó.
            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
            local result = Remotes.CommF_:InvokeServer("BuyGodhuman")
            if not table.find(J, W) then table.insert(J, W) end
            return result
        end
        if a then
            local a = Remotes.CommF_:InvokeServer('Buy' .. W, true)
            print("Response_", a == 1, typeof(a))
            if type(a) == 'number' and not table.find(J, W) then table.insert(J, W) end
            return a == 1
        end
        return Remotes.CommF_:InvokeServer("Buy" .. W)
    end

    function SendKey(J, W)
        (function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, J, false, game)
            task.wait(W)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, J, false, game)
        end)()
    end

    function FruitIdToName(J)
        local W = string.match(J, "((%u)[^%-]+)$")
        return W .. ' Fruit'
    end
    function Split(J, W)
        if W == nil then W = "%s" end
        local a = {}
        for h in string.gmatch(J, '([^' .. W .. ']+)') do table.insert(a, h) end
        return a
    end
    function FruitNameToId(J)
        local W = Split(J)[1]
        return W .. '-' .. W
    end

    -- ============================================================
    -- J QUESTS
    -- ============================================================
    local J = {CurrentLevel = 2, DoubleQuest = true, CurrentQuests = {}, BlacklistedQuestIds = {BartiloQuest = 1, CitizenQuest = 1, Trainees = 1, MarineQuest = 1, ImpelQuest = 1}}
    local W = require(game.ReplicatedStorage.GuideModule).Data.NPCList
    repeat task.wait() until game.Players.LocalPlayer.DataLoaded and ScriptStorage
    J.Quests = require(game.ReplicatedStorage.Quests)
    function J.Set(W, a, h) W[a] = h end
    function J.RefreshQuest(W)
        local timeout = os.time()
        while not ScriptStorage.PlayerData.Level do
            task.wait(1)
            print('[ Debug ] Waiting for LocalPlayer datas.')
            if os.time() - timeout > 30 then
                print('[ Debug ] Timeout waiting for player data, skipping quest refresh')
                return
            end
        end
        local a = 0
        local h
        for X, w in J.Quests do
            if not J.BlacklistedQuestIds[X] then
                if (w[1].LevelReq >= a and w[1].LevelReq <= ScriptStorage.PlayerData.Level) then
                    a = w[1].LevelReq
                    h = w
                    W.CurrentQuestId = X
                    if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex == 2 and X == 'ForgottenQuest' then break end
                end
            end
        end
        local a = h[#h]
        for X, X in a.Task do if X == 1 then table.remove(h, #h) end end
        for a, X in require(game.ReplicatedStorage.GuideModule).Data.NPCList do
            for w, w in X.Levels do if w == h[#h].LevelReq then W.CurrentNpc = a.CFrame end end
        end
        W.CurrentQuests = h
    end
    function J.GetCurrentQuest(W)
        local a = W.CurrentQuests[W.CurrentLevel] and W.CurrentQuests[W.CurrentLevel].LevelReq <= ScriptStorage.PlayerData.Level and W.CurrentLevel or 1
        for h in W.CurrentQuests[a].Task do return h, W.CurrentNpc, W.CurrentQuestId, a, W.CurrentQuests[a].Name end
    end
    function J.MarkAsCompleted(W) W.CurrentLevel = W.CurrentLevel == 2 and 1 or 2 end
    function J.AbandonQuest()
        print('Abandon Quest')
        Remotes.CommF_:InvokeServer("AbandonQuest")
    end
    function J.GetCurrentClaimQuest(W)
        local W = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", '%2')
        return (type(W) == "string" and string.gsub(W, "Military ", "Mil. ") or W), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    function J.StartQuest(W, a)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer('ColorsDealer', "2")
        return Remotes.CommF_:InvokeServer("StartQuest", W, a)
    end

    -- ============================================================
    -- SCRIPTSTORAGE MOB REGIONS
    -- ============================================================
    ScriptStorage.MobRegions = {}
    for W, W in game:GetService("ReplicatedStorage").FortBuilderReplicatedSpawnPositionsFolder:GetChildren() do
        ScriptStorage.MobRegions[tostring(W)] = ScriptStorage.MobRegions[tostring(W)] or {}
        table.insert(ScriptStorage.MobRegions[tostring(W)], W.CFrame)
    end

    -- ============================================================
    -- TWEEN CONTROLLER
    -- ============================================================
    TweenController = {}

    -- [ADDED - theo yêu cầu boss man: "dùng tween của file red magic hub"]
    -- Port block-tween + sync loop từ main_red_magic_beta.txt — tween 1
    -- Part vô hình ("block") thay vì tween thẳng HumanoidRootPart, nhân
    -- vật tự "bám" theo block khi đang farm (getgenv().OnFarm), tránh anti-
    -- cheat detect việc set CFrame của HRP trực tiếp mỗi frame.
    local block = Instance.new("Part", workspace)
    block.Size = Vector3.new(1, 1, 1)
    block.Name = "Rip_Indra"
    block.Anchored = true
    block.CanCollide = false
    block.CanTouch = false
    block.Transparency = 1
    do
        local blockfind = workspace:FindFirstChild(block.Name)
        if blockfind and blockfind ~= block then blockfind:Destroy() end
    end
    task.spawn(function()
        while task.wait() do
            if block and block.Parent == workspace then
                getgenv().OnFarm = shouldTween and true or false
            else
                getgenv().OnFarm = false
            end
        end
    end)
    -- Guardar as colisões originais para restaurá-las corretamente no fim do voo.
    local flightCollisionState = setmetatable({}, {__mode = "k"})
    local lastFlightCharacter = nil
    local lastFarmState = false
    local function SetFlightCollision(character, flying)
        if not character then return end
        if flying then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if flightCollisionState[part] == nil then
                        flightCollisionState[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        else
            for part, originalValue in pairs(flightCollisionState) do
                if part and part.Parent then part.CanCollide = originalValue end
                flightCollisionState[part] = nil
            end
        end
    end

    task.spawn(function()
        local player = game.Players.LocalPlayer
        local RunService = game:GetService("RunService")
        while true do
            RunService.PreSimulation:Wait()
            pcall(function()
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local flying = getgenv().OnFarm == true and block and block.Parent == workspace and root ~= nil
                if character ~= lastFlightCharacter then
                    SetFlightCollision(lastFlightCharacter, false)
                    lastFlightCharacter = character
                    lastFarmState = false
                end
                if flying and root then root.CFrame = block.CFrame end
                if character and flying ~= lastFarmState then
                    SetFlightCollision(character, flying)
                    lastFarmState = flying
                end
            end)
        end
    end)

    local W = 0
    local W = {}
    for a, a in game.ReplicatedStorage.NPCs:GetChildren() do if a.Name == 'Set Home Point' then table.insert(W, a:GetModelCFrame()) end end
    function TweenController.Update()
        local a = game.Players.LocalPlayer.Character.HumanoidRootPart
        HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if CaculateDistance(a.CFrame) > 250 then
            pcall(function() TweenInstance:Cancel() end)
            TweenDebounce = true
            a.CFrame = HumanoidRootPart.CFrame
            TweenDebounce = false
        end
        HumanoidRootPart.CFrame = a.CFrame + Vector3.new(0, 3, 0)
    end
    function GetPortal(a)
        local h, X = 9e9, nil
        for w, w in Portals do
            local D = CaculateDistance(w, a)
            if D < (CaculateDistance(a) - 300) and D < h then
                h = D
                X = w
            end
        end
        if X then
            Remotes.CommF_:InvokeServer("requestEntrance", X)
            return task.wait()
        end
    end
    function GetEntries(a)
        local h, X = 9e9, nil
        for w, w in W do
            local W = CaculateDistance(w, a)
            if W < (CaculateDistance(a) - 700) and W < h then
                h = W
                X = w
            end
        end
        if X then if os.time() - 0 > 30 then for W = 1, 10, 1 do task.wait() end end end
    end
    function TweenController.Tween2(W, a)
        TweenInstance2 = Services.TweenService:Create(W, TweenInfo.new(CaculateDistance(W.CFrame, a) / 50, Enum.EasingStyle.Linear), {CFrame = ConvertTo(CFrame, a) - Vector3.new(0, 0, 0)})
        TweenInstance2:Play()
    end
    function CheckItem(itemName)
        local bp = game.Players.LocalPlayer:FindFirstChild('Backpack')
        for _, v in next, bp and bp:GetChildren() or {} do
            if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
        end
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in next, char:GetChildren() do
                if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
            end
        end
        return false
    end

    -- [FIXED - theo yêu cầu boss man: "bỏ bypass teleport"] Đã xoá hẳn toàn
    -- bộ cụm hàm bypass-teleport (CheckLegendaryItems/InArea/GetSpawnPoint/
    -- CanBypassTeleport/GetBypassCFrame/BypassTP) — kiểm tra kỹ trước khi
    -- xoá: không còn nơi nào khác trong file gọi các hàm này (cả 2 điểm
    -- gọi BypassTP() duy nhất, trong TweenController.Create và
    -- _SgCollectChest, đã được thay bằng tween thường ở trên).

    -- ============================================================
    -- [FIXED] TWEEN CONTROLLER - movimento contínuo e colisões restauradas
    -- ============================================================
    local activeTweenTarget = nil
    function TweenController.Create(W)
        if not W or TweenDebounce then return end
        -- [FIX Electro] enquanto a missão do Electro está ativa, só ela move o personagem
        local eqa = getgenv().ElectroQuestActive
        if eqa and os.clock() - eqa < 3 and not getgenv().ElectroTweenCall then return end
        local a = typeof(W) ~= 'CFrame' and ConvertTo(CFrame, W) or W
        local character = game.Players.LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- [FIXED - theo yêu cầu boss man: "bỏ bypass teleport"] Đã xoá hẳn
        -- nhánh BypassTP (dist>=4000 → đổi spawn point) — không còn dùng
        -- cơ chế bypass qua spawn point nữa, mọi khoảng cách đều tween bình
        -- thường qua block (từ main_red_magic_beta.txt).
        local head = character:WaitForChild("Head")
        if not head:FindFirstChild("eltrul") then
            local bv = Instance.new('BodyVelocity')
            bv.Name = "eltrul"
            bv.MaxForce = Vector3.new(0, math.huge, 0)
            bv.Velocity = Vector3.zero
            bv.Parent = head
        end
        if CaculateDistance(a) > 500 then
            if SeaIndex == 3 and not ScriptStorage.Backpack['Valkyrie Helm'] then
            elseif SeaIndex ~= 3 then
                GetPortal(a)
            end
        end
        if CaculateDistance(Vector3.new(11256, -2138.0, 9888), a) < (CaculateDistance(a) - 700) and SeaIndex == 3 then
            local gatePos = CFrame.new(-16269.0, 23, 1371)
            if CaculateDistance(gatePos) > 60 then
                TweenController.Create(gatePos)
                task.wait(1)
                return
            end
            local net = require(game.ReplicatedStorage.Modules.Net)
            net:RemoteFunction('SubmarineWorkerSpeak'):InvokeServer('TravelToSubmergedIsland')
        end

        a = CFrame.new(a.Position)
        local target = a
        local activeTween = TweenInstance
        local distToTarget = CaculateDistance(hrp.CFrame, target)

        if distToTarget <= 5 then
            if activeTween then pcall(function() activeTween:Cancel() end) end
            shouldTween = false
            activeTweenTarget = nil
            hrp.CFrame = target
            block.CFrame = target
            return
        end

        -- Evitar reiniciar o voo continuamente quando o farming pede quase
        -- sempre o mesmo destino. Reiniciar tweens era a causa dos solavancos.
        if activeTween and activeTween.PlaybackState == Enum.PlaybackState.Playing then
            local oldTarget = activeTweenTarget
            if oldTarget and (oldTarget.Position - target.Position).Magnitude < 8 then
                return
            end
            pcall(function() activeTween:Cancel() end)
        else
            block.CFrame = hrp.CFrame
        end

        local dist = CaculateDistance(block.CFrame, target)
        local divisor = (CombatController and CombatController.FLY_SPEED) or 190 -- studs/s (antes: 230)
        local duration = math.max(dist / divisor, 0.08)
        shouldTween = true
        activeTweenTarget = target
        local thisTween = Services.TweenService:Create(block, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = target})
        TweenInstance = thisTween
        thisTween:Play()
        task.spawn(function()
            thisTween.Completed:Wait()
            if TweenInstance == thisTween then
                shouldTween = false
                activeTweenTarget = nil
            end
        end)
    end

    -- ============================================================
    -- FAST ATTACK & EQUIP WEAPON (LẤY TỪ TEST.TXT - GIỮ NGUYÊN)
    -- ============================================================
    local W = {}
    local a = game:GetService('Players')
    local h = game:GetService("RunService")
    local h = game:GetService('ReplicatedStorage')
    local X = game:GetService("Workspace")
    local X = game:GetService("VirtualInputManager")
    local X = a.LocalPlayer
    local X = h:WaitForChild('Modules')
    local w = X:WaitForChild("Net")
    local X = w:WaitForChild("RE/RegisterAttack")
    local X = w:WaitForChild('RE/RegisterHit')
    local X = w:WaitForChild('RE/ShootGunEvent')
    local X = h:WaitForChild("Remotes"):WaitForChild('Validator2')
    local h = game.ReplicatedStorage.Modules
    local X = h.Net
    local h, h = X:WaitForChild("RE/RegisterHit"), X:WaitForChild('RE/RegisterAttack')
    local h = {}
    function GetAllBladeHits()
        bladehits = {}
        for X, X in pairs(workspace.Enemies:GetChildren()) do
            if X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    function Getplayerhit()
        bladehits = {}
        for X, X in pairs(workspace.Characters:GetChildren()) do
            if X.Name ~= game.Players.LocalPlayer.Name and X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    local X = (Services.ReplicatedStorage.Modules.Net)
    local w = require(X):RemoteEvent("RegisterAttack", true)
    local D = require(X):RemoteEvent("RegisterHit", true)
    function h:Attack(target)
        local X = {}
        -- No farming, limitar o hit ao NPC atual; não incluir jogadores próximos.
        if target and target.Parent and target:FindFirstChild("Humanoid")
            and target.Humanoid.Health > 0 and target:FindFirstChild("HumanoidRootPart") then
            local character = game.Players.LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root and (target.HumanoidRootPart.Position - root.Position).Magnitude <= 65 then
                table.insert(X, target)
            end
        else
            for _, mob in pairs(GetAllBladeHits()) do table.insert(X, mob) end
        end
        if #X == 0 then return end
        local y = {[1] = nil, [2] = {}, [4] = "078da5141"}
        for _, mob in pairs(X) do
            local head = mob:FindFirstChild("Head") or mob.HumanoidRootPart
            w:FireServer(0)
            if not y[1] then y[1] = head end
            table.insert(y[2], {[1] = mob, [2] = mob.HumanoidRootPart})
            table.insert(y[2], mob)
        end
        D:FireServer(unpack(y))
    end
    task.spawn(function()
        while task.wait(.06) do if _G.FastAttack == os.time() then pcall(function() h:Attack() end) end end
    end)
-- Ataque normal pela ferramenta equipada; evita disparar o RegisterHit customizado
-- que podia ser rejeitado pelo servidor e deixar os NPCs sem perder vida.
local _lastToolAttack = 0
function W.Attack(target)
    local now = os.clock()
    if now - _lastToolAttack < 0.12 then return end
    _lastToolAttack = now
    -- Tentar o hit normal do jogo e o registo de hit apenas no NPC-alvo.
    -- Se o servidor rejeitar o registo remoto, a ativação normal continua a ser tentada.
    pcall(function() h:Attack(target) end)
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        local tool = character and character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end)
end

    CombatController = {GRAB = false, GRAB_DISTANCE = SeaIndex == 1 and 250 or 350, MAX_ATTACK_DURATION = 2, MAX_ATTACK_DURATION_2 = 60, LEVITATE_TIME = 0, CurrentIndex = 1}

    -- ============================================================
    -- BRING MOBS (portado do Main.txt — module.BringEnemies)
    -- Para cada mob vivo com o mesmo nome do alvo: se o executor for
    -- network owner e estiver a <= BRING_DISTANCE de ti, desliga colisão
    -- de todas as partes, trava com BodyVelocity "Lock", WalkSpeed 0 e
    -- teleporta o modelo para o CFrame do alvo.
    -- Liga/desliga com Config.BringMobs. Chamado dentro do CombatController.Grab.
    -- ============================================================
    local BRING_DISTANCE = 500 -- mesmo valor fixo usado no Main.txt
    -- [FIX morte] altura de voo acima do mob e máximo de mobs puxados por ciclo (o alcance de ataque é 65 studs)
    CombatController.HOVER_HEIGHT = 30
    CombatController.BRING_MAX    = 6
    CombatController.FLY_SPEED    = 190  -- velocidade de voo em studs/s (era 230); baixa mais se ainda for corrigido de volta
    -- Mobs para os quais o bring fica DESLIGADO (prisioneiros: há NPCs da quest secreta da prisão com o mesmo nome)
    CombatController.NO_BRING = {["Prisoner"] = true, ["Dangerous Prisoner"] = true}
    -- NPCs a saltar (ex.: prisioneiro da quest secreta: "Confront the prisoner before attacking!")
    CombatController.IGNORE_SECONDS = 600
    CombatController.IsIgnored = function(mob)
        local untilT = mob and mob:GetAttribute("BombaIgnoreUntil")
        return untilT ~= nil and os.clock() < untilT
    end
    CombatController.Skip = function(mob, why)
        if not mob then return end
        pcall(function()
            mob:SetAttribute("BombaIgnoreUntil", os.clock() + CombatController.IGNORE_SECONDS)
            print("[BombaCat] NPC saltado (" .. tostring(why) .. "): " .. mob.Name)
        end)
    end

    local function _bmAlive(m)
        return m and not m:FindFirstChild("VehicleSeat")
            and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0
            and m:FindFirstChild("HumanoidRootPart")
    end
    local function _bmPlayerNear(pos)
        local chars = workspace:FindFirstChild("Characters")
        if not chars then return false end
        for _, c in ipairs(chars:GetChildren()) do
            if _bmAlive(c) and c.Name ~= LocalPlayer.Name
                and (c.HumanoidRootPart.Position - pos).Magnitude <= 1000 then
                return true
            end
        end
        return false
    end
    local function _bmOwner(part)
        if isnetworkowner then
            local ok, res = pcall(isnetworkowner, part)
            return ok and res
        end
        return part.ReceiveAge == 0 and _bmPlayerNear(part.Position)
    end

    local _bmLastLog, _bmErrLogged = 0, false
    BringEnemy = function(Mon)
        if not Config.BringMobs then return end
        Mon = Mon or MonResult
        if not _bmAlive(Mon) then return end
        if CombatController.NO_BRING and CombatController.NO_BRING[Mon.Name] then return end
        local enemyFolder = workspace:FindFirstChild("Enemies")
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not enemyFolder or not myRoot then return end

        if sethiddenproperty then
            pcall(sethiddenproperty, LocalPlayer, "SimulationRadius", math.huge)
        end

        local TargetPos = Mon.HumanoidRootPart.CFrame
        local moved = 0
        for _, v in next, enemyFolder:GetChildren() do
            if v ~= Mon and v.Name == Mon.Name and _bmAlive(v) then
                local hrp = v.HumanoidRootPart
                -- [FIX] sem verificação de network owner: o fallback antigo exigia OUTRO jogador
                -- por perto, por isso a jogar sozinho nunca puxava nada.
                if (hrp.Position - myRoot.Position).Magnitude <= BRING_DISTANCE then
                    local ok, err = pcall(function()
                        for _, a in pairs(v:GetChildren()) do
                            if a:IsA("BasePart") then
                                a.CanCollide = false
                            end
                        end
                        if not hrp:FindFirstChild("Lock") then
                            local Lock = Instance.new("BodyVelocity")
                            Lock.Name = "Lock"
                            Lock.Parent = hrp
                            Lock.Velocity = Vector3.new(0, 0, 0)
                            Lock.MaxForce = Vector3.new(10000, 10000, 10000)
                        end
                        v.Humanoid.WalkSpeed = 0
                        -- [FIX] CFrame direto na HRP (SetPrimaryPartCFrame falha em silêncio se o modelo não tiver PrimaryPart)
                        hrp.CFrame = TargetPos
                    end)
                    if ok then
                        moved = moved + 1
                        if moved >= (CombatController.BRING_MAX or 6) then break end
                    elseif not _bmErrLogged then
                        _bmErrLogged = true
                        warn("[BombaCat BringMobs] erro ao mover mob: " .. tostring(err))
                    end
                end
            end
        end

        if os.time() - _bmLastLog >= 10 then
            _bmLastLog = os.time()
            print("[BombaCat BringMobs] alvo: " .. tostring(Mon.Name) .. " | mobs puxados neste ciclo: " .. moved .. " | isnetworkowner: " .. tostring(isnetworkowner ~= nil) .. " | sethiddenproperty: " .. tostring(sethiddenproperty ~= nil))
        end
    end


    LastFound = os.time()
    function CombatController.Grab(mobName)
        BringEnemy(MonResult)
    end
    function Sort1(entity) return entity and entity:FindFirstChild("HumanoidRootPart") and math.floor(CaculateDistance(entity.HumanoidRootPart.CFrame)) end
    function CombatController.Search(names)
        local candidates = {}
        local anyFound = false
        for _, entity in GetMonAsSortedRange() do
            if table.find(names, entity.Name) and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0 then
                if (entity:GetAttribute('FailureCount') or 0) < 3 and not CombatController.IsIgnored(entity) then
                    anyFound = true
                    table.insert(candidates, entity)
                end
            end
        end
        table.sort(candidates, function(entity, other) return Sort1(entity) < Sort1(other) end)
        if anyFound then
            local best = candidates[1]
            return best
        end
        for _, npcName in names do
            local npc = game.ReplicatedStorage:FindFirstChild(npcName)
            if npc then return npc end
        end
    end
    function CombatController.Attack(h, X, w, D)
        if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]['InCombat'] then
            pcall(function() if TweenInstance then TweenInstance:Cancel() end end) -- [FIXED] không tween về (0,0,0) khi Sweet Chalice InCombat
            return
        end
        sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
        h = type(h) == "string" and {h} or (h or {})
        for y, L in (h) do
            if CombatController.ShouldAbort and CombatController.ShouldAbort() then return end
            local b = tostring(L)
            if b == 'Deandre' or b == "Urban" or b == "Diablo" and (os.time() - (LastFire12 or 0)) > 180 then
                LastFire12 = os.time()
                Remotes.CommF_:InvokeServer("EliteHunter")
            end
            if X then
                local b = GetMonAsSortedRange()[1]
                local C = b and b:FindFirstChild('HumanoidRootPart') and b.HumanoidRootPart.Position
                if C and CaculateDistance(C) < w then MonResult = b end
            else
                MonResult = CombatController.Search(h)
            end
            if MonResult then
                LastFound = os.time()
                local h, w = 0, os.time()
                SetTask('SubTask', '⚔️ Attacking ' .. tostring(MonResult.Name))
                local w, b = 0, os.time()
                while task.wait() do
                    if _G.Stop then return end
                    if CombatController.IsIgnored(MonResult) then return end -- NPC saltado: volta a procurar outro
                    if CombatController.ShouldAbort and CombatController.ShouldAbort() then return end
                    if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]["InCombat"] then
                        pcall(function() if TweenInstance then TweenInstance:Cancel() end end) -- [FIXED] không tween về (0,0,0) khi Sweet Chalice InCombat
                        return
                    end
                    local C = MonResult:FindFirstChild('Humanoid')
                    local p = MonResult:FindFirstChild('HumanoidRootPart')
                    if not C or C.Health <= 0 then
                        if MonResult.Name == "Don Swan" then Storage:Set("SwanDefeated", true) end
                        break
                    end
                    -- Aproximação fixa e acima do NPC: não usar CaculateCircreDirection,
                    -- que move em círculo. 12 studs evitam entrar no volume físico do NPC.
                    TweenController.Create(p.Position + Vector3.new(0, CombatController.HOVER_HEIGHT or 30, 0))
                    if CaculateDistance(p.Position + Vector3.new(0, 35, 0)) < 150 then
                        y = D and D()
                        CombatController.Grab(L or '')
                        if MonResult.Name ~= "Core" then
                            if ScriptStorage.PlayerData.Level > 100 and w >= CombatController.MAX_ATTACK_DURATION_2 and C.Health - C.MaxHealth == 0 then
                                SetTask('SubTask', 'Hop Server - Mob Health Unchanged ( ' .. C.Health .. ' / ' .. C.MaxHealth .. ')')
                                alert("stuck", "Mob health unchanged")
                                _G.Stop = true
                                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                            end
                            if h >= CombatController.MAX_ATTACK_DURATION and C.Health - C.MaxHealth == 0 then
                                h = 0
                                local D = MonResult:GetAttribute('OldPosition')
                                if D then
                                    MonResult:SetPrimaryPartCFrame(CFrame.new(D))
                                    MonResult:SetAttribute('IgnoreGrab', true)
                                    MonResult:SetAttribute('FailureCount', (MonResult:GetAttribute("FailureCount") or 0) + 1)
                                    alert('Failed to attack', "Returning to the old posiiton ( #" .. MonResult:GetAttribute("FailureCount") .. " )")
                                    MonResult.HumanoidRootPart.CFrame = (CFrame.new(D))
                                    task.wait()
                                    return
                                end
                            end
                        end
                        if (FarmFruitMastery or math.huge) - os.time() < 3 and math.floor(MonResult.Humanoid.Health / MonResult.Humanoid.MaxHealth * 100) < 30 and not FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                            TweenController.Create((p.CFrame) + Vector3.new(0, 25, 0))
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Blox Fruit')
                            LockAimPositionTo(MonResult.HumanoidRootPart.CFrame.p)
                            local D = {'Z', 'X', "C", 'V'}
                            local y = D[math.random(1, #D)]
                            SendKey(y, .31)
                        else
                            -- [FIXED] Ưu tiên dùng _G.SelectWeapon nếu có
                            if _G.SelectWeapon and CheckItem(_G.SelectWeapon) then
                                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(_G.SelectWeapon)
                            else
                                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(ScriptStorage.ForceToUseSword and 'Sword' or "Melee")
                            end
                        end
                        W:Attack(MonResult)
                        if os.time() ~= b then
                            b = os.time()
                            h = h + 1
                            w = w + 1
                        end
                        if h > 30 and MonResult.Name ~= "Core" then
                            alert("Take more than 30s to attack, canceling")
                            break
                        end
                    end
                end
            elseif not X then
                if (os.time() - LastFound) > 200 then
                    alert('MeyyHub', 'Error while farming, rejoin')
                    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                    return
                end
                local h = ScriptStorage.MobRegions[L]
                if not h then
                    local X = Services.Workspace.Enemies:FindFirstChild(L) or game.ReplicatedStorage:FindFirstChild(L)
                    h = X and {X:GetPrimaryPartCFrame().p}
                end
                if not h then
                    Report('[ Game data error ] Mob with name ' .. tostring(L) .. ' have no spawn region datas')
                    return
                end
                local X
                if not h[CombatController.CurrentIndex] then CombatController.CurrentIndex = 1 end
                X = h[CombatController.CurrentIndex]
                local h = os.time()
                TweenController.Create(X + Vector3.new(0, 35, 35))
                if CaculateDistance(X + Vector3.new(0, 35, 35)) < 15 then CombatController.CurrentIndex = CombatController.CurrentIndex + 1 end
            end
        end
    end
    LevelFarmTTL = 0
    LastTravel = os.time()
    FunctionsHandler = {Initalized = false}
    print(3000)
    setmetatable(FunctionsHandler, {__index = function(h, X)
        QueryResult = rawget(h, X)
        if not QueryResult then
            return {
                Register = function(w)
                    if w == false then return end
                    Result = {CacheListener = {}, RealCache = {}, Methods = {}, Constants = {}, Events = {}, Initalized = true}
                    function Result.RegisterMethod(w, D, y)
                        w.Methods[D] = {Name = D, Callback = y, Call = function(w, ...) return w.Callback(...) end, Events = {}}
                        return true
                    end
                    setmetatable(Result.Constants, {__newindex = function() assert(false, 'cannot change constant value!') end})
                    if h.Constants[Key] then
                        function Result.SaveConstant(w, w, w) return assert(false, 'constant name was used before!') end
                        rawset(h.Constants, Key, Value)
                    end
                    function Result.Set(h, w, D)
                        h.CacheListener[w] = D
                        return D
                    end
                    function Result.Get(h, w) return h.Constants[w] or h.RealCache[w] end
                    function Result.AddVariableChangeListener(h, w, D) h.Events[w] = D end
                    Result.CacheListener.__parent = Result
                    setmetatable(Result.CacheListener, {__newindex = function(h, w, D)
                        _ = h.__parent.Events[w] and h.__parent.Events[w](w, D)
                        h.__parent.RealCache[w] = D
                    end})
                    FunctionsHandler[X] = Result
                end, Initalized = false
            }
        end
        return QueryResult
    end})
    function FunctionsHandler.SynchorizeUntilModuleLoaded(h, X)
        local w = os.time()
        while not h.Initalized do
            task.wait()
            local h = os.time() - w
            assert(not (X and h > X), "timed out")
        end
    end
    function GetCurrentClaimQuest(h)
        local h = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2")
        return (type(h) == "string" and string.gsub(h, "Military ", "Mil. ") or h), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    FunctionsHandler.LocalPlayerController.Register()
    FunctionsHandler.ExpRedeem:Register()
    FunctionsHandler.LevelFarm:Register()
    FunctionsHandler.Saber:Register()
    FunctionsHandler.Rengoku:Register()
    FunctionsHandler.Yama:Register()
    FunctionsHandler.Tushita:Register()
    FunctionsHandler.SpikeyTrident:Register()
    FunctionsHandler.SharkAchor:Register()
    FunctionsHandler.Pole:Register()
    FunctionsHandler.FoxLamp:Register()
    FunctionsHandler.DarkDagger:Register()
    FunctionsHandler.Canvander:Register()
    FunctionsHandler.BuddySword:Register()
    FunctionsHandler.HallowScythe:Register()
    FunctionsHandler.CursedDualKatana:Register()
    FunctionsHandler.AcidumRifle:Register()
    FunctionsHandler.Kabucha:Register()
    FunctionsHandler.VenomBow:Register()
    FunctionsHandler.SoulGuitar:Register()
    FunctionsHandler.DragonStorm:Register()
    FunctionsHandler.InsictV2:Register()
    FunctionsHandler.RainbowSaviour:Register()
    FunctionsHandler.DarkBladeV2:Register()
    FunctionsHandler.SecondSeaPuzzle:Register()
    FunctionsHandler.ColosseumPuzzle:Register()
    FunctionsHandler.Trevor:Register()
    FunctionsHandler.EvoRace:Register()
    FunctionsHandler.Wenlocktoad:Register()
    FunctionsHandler.DarkBladeV3:Register()
    FunctionsHandler.ThirdSeaPuzzle:Register()
    FunctionsHandler.DojoQuest:Register()
    FunctionsHandler.RaceAwakening:Register()
    FunctionsHandler.PirateRaid:Register()
    FunctionsHandler.SwordBossTask:Register()
    FunctionsHandler.CakePrinceTask:Register()
    FunctionsHandler.RaidController:Register()
    FunctionsHandler.AutoRaidIce:Register()
    FunctionsHandler.MeleesController:Register()
    FunctionsHandler.Superhuman:Register()
    FunctionsHandler.DeathStep:Register()
    FunctionsHandler.SharkmanKarate:Register()
    FunctionsHandler.ElectricClaw:Register()
    FunctionsHandler.DragonTalon:Register()
    FunctionsHandler.Godhuman:Register()
    FunctionsHandler.BossesTask:Register()
    FunctionsHandler.SpecialBossesTask:Register()
    FunctionsHandler.CollectDrops:Register()
    FunctionsHandler.CollectBerries:Register()
    FunctionsHandler.UtillyItemsActivitation:Register()

    -- ============================================================
    -- AUTO FULL MELEE - TƯƠNG THÍCH VỚI LEVEL FARM
    -- ============================================================
    -- [NEW] V1 → V2 pairing — dùng để biết trái nào đang farm mastery là
    -- V1 của võ nào, và tên teacher/style tương ứng theo MeleePrices
    local V1ToV2 = {
        ["Black Leg"]      = "Death Step",       -- "Dark Step" (tên Teacher)
        ["Electro"]        = "Electric Claw",
        ["Fishman Karate"] = "Sharkman Karate",   -- "Water Kung Fu"
        ["Dragon Claw"]    = "Dragon Talon",
    }

    FunctionsHandler.MeleesController:RegisterMethod("Refresh", function()
        if not Config.Items.AutoFullyMelees or not Config.Melee.AutoBuy then return nil end
        -- Prioridade especial: antes do nível 200, só interrompe o farm de níveis
        -- quando já pode comprar o Black Leg (Dark Step) e ainda não o possui.
        local currentLevel = ScriptStorage.PlayerData.Level or 0
        if currentLevel < 200 then
            if not CheckItem("Black Leg") and (ScriptStorage.PlayerData.Beli or 0) >= 150000 then
                return true
            end
            return nil
        end
        -- [FIX farm de nível] Do nível 200 ao 299 não há nada para comprar/treinar:
        -- Black Leg já comprado (ou sem 150 000 Beli) e todos os outros estilos pedem nível 300+.
        -- Antes, o Refresh devolvia true, o Start saía logo com "Cần Player Level 300 cho Black Leg"
        -- e, como MeleesController vem ANTES de LevelFarm, o farm de nível nunca corria.
        if currentLevel < 300 then
            if CheckItem("Black Leg") or (ScriptStorage.PlayerData.Beli or 0) < 150000 then
                return nil
            end
            return true
        end
        -- [FIXED] Bỏ "if _G.Level then return nil end" — đây là khóa VĨNH VIỄN,
        -- một khi thiếu tiền 1 lần là MeleesController tắt luôn mãi mãi vì
        -- không có chỗ nào khác set lại _G.Level = false. Bỏ hẳn cờ này,
        -- để Refresh tự nhiên re-check mỗi vòng — rẻ, an toàn, tự phục hồi.

        local allMelees = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"}
        local hasAll = true
        for _, name in ipairs(allMelees) do
            if not CheckItem(name) then
                hasAll = false
                break
            end
        end
        if hasAll then
            SetTask('MainTask', 'Auto Full Melee | ✅ Đã có tất cả!')
            return nil
        end
        return true
    end)


    -- ============================================================
    -- [NEW] ELECTRO — missão do Lightning Bolt (update novo do Blox Fruits)
    -- Fluxo: falar com o Mad Scientist -> "I'll get you one" -> partir uma
    -- nuvem de tempestade carregada em Skylands -> voltar e "Hand it over"
    -- -> "Pay $500,000" (o BuyElectro normal do script continua como reserva).
    -- Só corre no Sea 1 (as nuvens ficam em Skylands).
    -- ============================================================
    local MeleeBlock = {} -- [FIX] melee que não deu para comprar fica em pausa (e o script farma) em vez de repetir para sempre
    local ElectroQuestStep -- (um só local fora do bloco: evita o limite de 200 locals da função)
    do
    local ElectroQuest = {taken = false, takenAt = 0, delivered = false, fails = 0, lastScan = 0, cloud = nil, debugged = false}
    local ELECTRO_NPC = "Mad Scientist"
    local ELECTRO_FALLBACK_CF = CFrame.new(-4842.112, 717.670, -2623.149)

    -- Só a missão do Electro pode mover o personagem enquanto estiver ativa (evita 2 tweens a disputar o bloco e o personagem ficar parado no ar)
    local function ElectroMove(cf)
        getgenv().ElectroTweenCall = true
        local ok, err = pcall(TweenController.Create, cf)
        getgenv().ElectroTweenCall = false
        if not ok then warn("[BombaCat Electro] tween falhou: " .. tostring(err)) end
    end

    local function ElectroBoltCount()
        local e = ScriptStorage.Backpack and ScriptStorage.Backpack["Lightning Bolt"]
        if type(e) == "table" then return e.Count or 1 end
        if e then return 1 end
        return CheckItem("Lightning Bolt") and 1 or 0
    end

    local function ElectroNPCCFrame()
        local ok, cf = pcall(function()
            local npc = workspace.NPCs:FindFirstChild(ELECTRO_NPC)
            if npc then return npc:GetPivot() end
        end)
        if ok and cf then return cf end
        return ELECTRO_FALLBACK_CF
    end

    -- Procura um botão/etiqueta visível no PlayerGui cujo texto contenha um dos padrões.
    local function ElectroFindGui(patterns)
        local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return nil end
        for _, d in ipairs(pg:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel")) and type(d.Text) == "string" and d.Text ~= "" then
                local t = string.lower(d.Text)
                for _, p in ipairs(patterns) do
                    if string.find(t, p, 1, true) then
                        local btn = d:IsA("GuiButton") and d or d:FindFirstAncestorWhichIsA("GuiButton")
                        local visible = true
                        local node = d
                        while node and node:IsA("GuiObject") do
                            if not node.Visible then visible = false break end
                            node = node.Parent
                        end
                        if visible then return btn or d, d end
                    end
                end
            end
        end
        return nil
    end

    local function ElectroClickGui(btn)
        if not btn or not btn:IsA("GuiButton") then return false end
        local fired = false
        if typeof(getconnections) == "function" then
            for _, sig in ipairs({btn.MouseButton1Click, btn.Activated, btn.MouseButton1Down, btn.MouseButton1Up}) do
                local okC, conns = pcall(getconnections, sig)
                if okC and conns then
                    for _, c in ipairs(conns) do
                        if pcall(function() c:Fire() end) then fired = true end
                    end
                end
            end
        end
        if not fired and typeof(firesignal) == "function" then
            fired = pcall(firesignal, btn.MouseButton1Click) or pcall(firesignal, btn.Activated)
        end
        return fired
    end

    local function ElectroTalk()
        local npc = workspace.NPCs:FindFirstChild(ELECTRO_NPC)
        if not npc then return false end
        local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and typeof(fireproximityprompt) == "function" then pcall(fireproximityprompt, prompt) end
        local cd = npc:FindFirstChildWhichIsA("ClickDetector", true)
        if cd and typeof(fireclickdetector) == "function" then pcall(fireclickdetector, cd) end
        return true
    end

    -- Nuvens de tempestade carregadas (heurística: nome com "cloud" + efeito de relâmpago/luz).
    -- Se o jogo usar outros nomes, o debug abaixo imprime os candidatos na consola.
    local function ElectroFindCloud()
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        if ElectroQuest.cloud and ElectroQuest.cloud.Parent and os.clock() - ElectroQuest.lastScan < 3 then
            return ElectroQuest.cloud
        end
        ElectroQuest.lastScan = os.clock()
        local best, bestDist, seen = nil, math.huge, {}
        for i, o in ipairs(workspace:GetDescendants()) do
            if i % 4000 == 0 then task.wait() end
            if o:IsA("BasePart") then
                local n = string.lower(o.Name)
                if string.find(n, "cloud", 1, true) or string.find(n, "storm", 1, true) or string.find(n, "thunder", 1, true) or string.find(n, "lightning", 1, true) then
                    local charged = string.find(n, "storm", 1, true) or string.find(n, "thunder", 1, true) or string.find(n, "lightning", 1, true) or string.find(n, "charged", 1, true)
                        or o:FindFirstChildWhichIsA("Beam", true) or o:FindFirstChildWhichIsA("PointLight", true)
                        or o:FindFirstChildWhichIsA("ParticleEmitter", true) or o:FindFirstChildWhichIsA("ClickDetector", true)
                    if o.Position.Y > 300 then
                        if not seen[o.Name] then seen[o.Name] = true end
                        if charged then
                            local d = (o.Position - hrp.Position).Magnitude
                            if d < bestDist then best, bestDist = o, d end
                        end
                    end
                end
            end
        end
        if not ElectroQuest.debugged then
            ElectroQuest.debugged = true
            local names = {}
            for k in pairs(seen) do names[#names + 1] = k end
            print("[BombaCat Electro] nomes de nuvens/tempestade encontrados em Skylands: " .. (#names > 0 and table.concat(names, ", ") or "nenhum"))
        end
        ElectroQuest.cloud = best
        return best
    end

    local function ElectroHitCloud()
        local vim = game:GetService("VirtualInputManager")
        pcall(function() vim:SendMouseButtonEvent(500, 400, 0, true, game, 0) end)
        task.wait(0.05)
        pcall(function() vim:SendMouseButtonEvent(500, 400, 0, false, game, 0) end)
    end

    -- Devolve true quando o Electro já pode seguir para a compra normal.
    ElectroQuestStep = function()
        if SeaIndex ~= 1 or ElectroQuest.delivered then getgenv().ElectroQuestActive = false return true end
        -- Sem 500k Beli e sem a missão em curso: não interrompe o farm de nível (que dá Beli)
        if (ScriptStorage.PlayerData.Beli or 0) < 500000 and ElectroBoltCount() == 0 and not ElectroQuest.taken then
            getgenv().ElectroQuestActive = false
            return true
        end
        getgenv().ElectroQuestActive = os.clock() -- carimbo de tempo: expira sozinho se a tarefa mudar
        ElectroQuest.startedAt = ElectroQuest.startedAt or os.clock()
        if os.clock() - ElectroQuest.startedAt > 420 then
            -- 7 min sem concluir: desiste por 15 min e deixa o script farmar
            warn("[BombaCat Electro] missão sem progresso há 7 min; pausa de 15 min.")
            ElectroQuest.startedAt, ElectroQuest.taken, ElectroQuest.fails = nil, false, 0
            MeleeBlock["Electro"] = os.clock() + 900
            getgenv().ElectroQuestActive = false
            return true
        end
        if os.clock() - (ElectroQuest.lastLog or 0) > 5 then
            ElectroQuest.lastLog = os.clock()
            print(string.format("[BombaCat Electro] bolt=%d taken=%s delivered=%s distNPC=%d Beli=%s",
                ElectroBoltCount(), tostring(ElectroQuest.taken), tostring(ElectroQuest.delivered),
                CaculateDistance(ElectroNPCCFrame()), tostring(ScriptStorage.PlayerData.Beli)))
        end

        local npcCF = ElectroNPCCFrame()

        -- 1) Já tem o Lightning Bolt: entregar
        if ElectroBoltCount() > 0 then
            if CaculateDistance(npcCF) > 12 then
                SetTask('MainTask', 'Auto Full Melee | Electro: levar o Lightning Bolt ao Mad Scientist')
                ElectroMove(npcCF)
                return false
            end
            SetTask('MainTask', 'Auto Full Melee | Electro: entregar o Lightning Bolt')
            ElectroTalk(); task.wait(0.8)
            local btn = ElectroFindGui({"hand it over"})
            if btn then ElectroClickGui(btn); task.wait(1) end
            local pay = ElectroFindGui({"pay $500,000", "pay $500"})
            if pay then ElectroClickGui(pay); task.wait(0.5) end
            if ElectroBoltCount() == 0 then ElectroQuest.delivered = true; ElectroQuest.startedAt = nil; getgenv().ElectroQuestActive = false end
            return false
        end

        -- 2) Ainda não aceitou a missão: falar com o Mad Scientist
        if not ElectroQuest.taken or os.clock() - ElectroQuest.takenAt > 240 then
            if CaculateDistance(npcCF) > 12 then
                SetTask('MainTask', 'Auto Full Melee | Electro: ir ao Mad Scientist (Skylands)')
                ElectroMove(npcCF)
                return false
            end
            SetTask('MainTask', 'Auto Full Melee | Electro: aceitar a missão do Lightning Bolt')
            ElectroTalk(); task.wait(0.8)
            -- Já entregou antes (só falta pagar)?
            local pay = ElectroFindGui({"pay $500,000", "pay $500"})
            if pay then
                ElectroQuest.delivered = true
                ElectroClickGui(pay)
                return false
            end
            local accept = ElectroFindGui({"i'll get you one", "ill get you one", "get you one"})
            if accept then
                ElectroClickGui(accept); task.wait(0.8)
                ElectroQuest.taken, ElectroQuest.takenAt, ElectroQuest.fails = true, os.clock(), 0
            else
                ElectroQuest.fails = ElectroQuest.fails + 1
                if ElectroQuest.fails >= 4 then
                    -- Não achou as opções de diálogo: deixa o BuyElectro normal tentar, sem bloquear o script
                    warn("[BombaCat Electro] não encontrei o diálogo do Mad Scientist; a usar a compra normal.")
                    ElectroQuest.delivered = true
                    getgenv().ElectroQuestActive = false
                    return true
                end
            end
            return false
        end

        -- 3) Missão ativa: caçar uma nuvem carregada em Skylands
        local cloud = ElectroFindCloud()
        if cloud then
            SetTask('MainTask', 'Auto Full Melee | Electro: a partir uma nuvem de tempestade')
            ElectroMove(cloud.CFrame * CFrame.new(0, 0, 6))
            if CaculateDistance(cloud.CFrame) < 25 then
                local tool = _G.SelectWeapon
                if tool then pcall(function() FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(tool) end) end
                ElectroHitCloud()
            end
        else
            SetTask('MainTask', 'Auto Full Melee | Electro: à procura de nuvens carregadas em Skylands')
            ElectroMove(npcCF * CFrame.new(0, 150, 0))
        end
        return false
    end
    end -- fim do bloco do Electro

    FunctionsHandler.MeleesController:RegisterMethod("Start", function()
        if not Config.Items.AutoFullyMelees or not Config.Melee.AutoBuy then return end
        -- [FIX] melee que precisa de mastery (o treino a sério acontece no fim, ver abaixo)
        local trainName, trainTarget = nil, nil
        local function farmWith(weapon)
            -- Corre o farm de nível com o melee escolhido equipado (o Attack respeita _G.SelectWeapon)
            local lf = FunctionsHandler.LevelFarm
            local okR, hR = pcall(function() return lf.Methods.Refresh:Call() end)
            if not (okR and hR) then return end
            local oldSel = _G.SelectWeapon
            if weapon then _G.SelectWeapon = weapon end
            local okS, errS = pcall(function() lf.Methods.Start:Call(hR) end)
            _G.SelectWeapon = oldSel
            if not okS then error(errS, 0) end
        end
        local currentLevel = ScriptStorage.PlayerData.Level or 0
        -- A tarefa só é selecionada abaixo do nível 200 quando falta comprar
        -- Black Leg e existem pelo menos 150 000 Beli. Não tenta comprar os
        -- restantes estilos antes do nível normal de progressão.
        if currentLevel < 200 and (CheckItem("Black Leg") or (ScriptStorage.PlayerData.Beli or 0) < 150000) then
            return
        end

        local meleeList = {
            -- [FIXED - LỖI NỀN TẢNG] Trước đây key = "BuyBlackLeg" v.v. —
            -- nhưng BuyMelee() TỰ thêm "Buy" ở trong ('Buy' .. W), nên gọi
            -- ra remote "BuyBuyBlackLeg" — KHÔNG TỒN TẠI, mua không bao giờ
            -- thành công. Đồng thời special-case DragonClaw/Godhuman trong
            -- BuyMelee so sánh W=="DragonClaw"/"Godhuman" (không "Buy...")
            -- nên trước đây KHÔNG BAO GIỜ khớp, luôn rơi vào nhánh generic
            -- sai. Bỏ hẳn tiền tố "Buy" khỏi key — để BuyMelee tự thêm.
            {name = "Black Leg", key = "BlackLeg", price = {Beli = 150000}, levelReq = 300},
            {name = "Electro", key = "Electro", price = {Beli = 500000}, levelReq = 300, needLightningBolt = true},
            {name = "Fishman Karate", key = "FishmanKarate", price = {Beli = 750000}, levelReq = 300},
            {name = "Dragon Claw", key = "DragonClaw", price = {Fragments = 1500}, levelReq = 300},
            {name = "Superhuman", key = "Superhuman", price = {Beli = 3000000}, levelReq = nil, needMastery = {item = "Dragon Claw", value = 300}},
            {name = "Death Step", key = "DeathStep", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Library Key"},
            {name = "Sharkman Karate", key = "SharkmanKarate", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Water Key"},
            {name = "Electric Claw", key = "ElectricClaw", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400},
            {name = "Dragon Talon", key = "DragonTalon", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needFireEssence = true},
            {name = "Godhuman", key = "Godhuman", price = {Beli = 5000000, Fragments = 5000}, levelReq = 400, needMaterials = true},
        }

        -- [NEW] Cổng kiểm tra "mọi thứ đủ điều kiện chưa" — boss man yêu
        -- cầu: chỉ khi TẤT CẢ 9 melee (V1+V2, gồm cả Superhuman — spec mới
        -- yêu cầu Superhuman cũng phải đạt 500 trước Godhuman, KHÁC với
        -- thiết kế cũ của tao lúc trước loại trừ nó, đã sửa lại) đã MUA
        -- XONG và ĐẠT mastery mục tiêu (V1=500, V2=400) thì mới bắt đầu
        -- farm vật liệu/F/Beli cho Godhuman.
        local MASTERY_GATE_MELEES = {
            {name = "Black Leg",       target = Config.Melee.RaidAtV1Mastery},
            {name = "Electro",         target = Config.Melee.RaidAtV1Mastery},
            {name = "Fishman Karate",  target = Config.Melee.RaidAtV1Mastery},
            {name = "Dragon Claw",     target = Config.Melee.RaidAtV1Mastery},
            {name = "Superhuman",      target = Config.Melee.RaidAtV1Mastery},
            {name = "Death Step",      target = Config.Melee.GodhumanAtV2Mastery},
            {name = "Sharkman Karate", target = Config.Melee.GodhumanAtV2Mastery},
            {name = "Electric Claw",   target = Config.Melee.GodhumanAtV2Mastery},
            {name = "Dragon Talon",    target = Config.Melee.GodhumanAtV2Mastery},
        }

        local function AllMeleesReady()
            for _, m in ipairs(MASTERY_GATE_MELEES) do
                if not CheckItem(m.name) then return false, m.name .. " (chưa mua)" end
                local mst = ScriptStorage.Melees[m.name] or 0
                if mst < m.target then return false, m.name .. " (" .. mst .. "/" .. m.target .. ")" end
            end
            return true
        end


        -- Sea nào không có tên trong bảng = thầy đó không đứng ở Sea đó,
        -- phải qua Sea khác (Sea 3 có đủ cả 8 thầy nên dùng làm fallback)
        local TeacherLocations = {
            ["Water Kung-fu Teacher"] = {
                [1] = CFrame.new(61586.96, 19.58, 987.59),
                [2] = CFrame.new(-4957.68, 35.94, -4665.6),
                [3] = CFrame.new(-5023.91, 371.02, -3191.46),
            },
            ["Mad Scientist"] = {
                [1] = CFrame.new(-4842.112, 717.670, -2623.149), -- [FIX] ilha mais baixa de Skylands (igual à tabela do Electro, linha ~350)
                [2] = CFrame.new(-4866.16, 33.92, -4767.11),
                [3] = CFrame.new(-4996.06, 313.21, -3201.83),
            },
            ["Dark Step Teacher"] = {
                [1] = CFrame.new(-983.62, 12.44, 3990.46),
                [2] = CFrame.new(-4752.44, 33.92, -4848.04),
                [3] = CFrame.new(-5045.61, 370.01, -3182.31),
            },
            ["Phoeyu, the Reformed"] = {
                [2] = CFrame.new(6356.47, 296.1, -6762.78),
                [3] = CFrame.new(-4999.24, 314.01, -3221.58),
            },
            ["Sharkman Teacher"] = {
                [2] = CFrame.new(-2599.63, 238.19, -10316),
                [3] = CFrame.new(-4971.21, 313.88, -3223.08),
            },
            ["Previous Hero"] = {
                [3] = CFrame.new(-10371.48, 330.76, -10131.42),
            },
            ["Uzoth"] = {
                [3] = CFrame.new(5661.89, 1210.87, 863.17),
            },
            ["Ancient Monk"] = {
                [3] = CFrame.new(-13774.1, 333.73, -9879.91),
            },
        }
        -- [NEW] Melee nào → thầy nào (khớp với tên trong MeleePrices.Buy)
        -- Dragon Claw ("Sabi") và Superhuman ("Martial Arts Master") KHÔNG
        -- có trong data boss man cho — để trống, không bịa toạ độ
        local MeleeTeacher = {
            ["Fishman Karate"]   = "Water Kung-fu Teacher",
            ["Electro"]          = "Mad Scientist",
            ["Black Leg"]        = "Dark Step Teacher",
            ["Death Step"]       = "Phoeyu, the Reformed",
            ["Sharkman Karate"]  = "Sharkman Teacher",
            ["Electric Claw"]    = "Previous Hero",
            ["Dragon Talon"]     = "Uzoth",
            ["Godhuman"]         = "Ancient Monk",
        }

        -- [NEW] Tween tới đúng thầy trước khi mua — đây là phần BỊ THIẾU
        -- khiến "mua bị lỗi" (gọi remote mua nhưng nhân vật không đứng gần
        -- NPC nên server từ chối). Sea hiện tại có thầy → dùng luôn; không
        -- có → qua Sea 3 (thầy nào cũng có mặt ở đó).
        local function GoToTeacher(meleeName)
            local teacher = MeleeTeacher[meleeName]
            if not teacher then return true end -- không có data vị trí, bỏ qua bước này
            local locs = TeacherLocations[teacher]
            if not locs then return true end

            local cf = locs[SeaIndex]
            if not cf then
                if SeaIndex ~= 3 then
                    Remotes.CommF_:InvokeServer("TravelZou")
                    return false
                end
                return true -- đang ở Sea 3 mà bảng thiếu toạ độ Sea 3 (không nên xảy ra)
            end

            if CaculateDistance(cf) > 10 then
                TweenController.Create(cf)
                return false
            end
            return true
        end

        for _, melee in ipairs(meleeList) do
            if _G.Stop then return end

            local bp = CheckItem(melee.name)
            if not bp then
                if MeleeBlock[melee.name] and os.clock() < MeleeBlock[melee.name] then
                    SetTask('SubTask', 'Auto Full Melee | ' .. melee.name .. ' em pausa — a farmar Beli/nível')
                    farmWith(trainName)
                    return
                end
                -- [NEW] Dragon Claw V1 cần riêng 1500 Fragments — nếu chưa
                -- đủ thì đây chính là lý do phải farm raid (raid cho
                -- Fragments), không phải lỗi gì khác
                if melee.name == "Dragon Claw" and (ScriptStorage.PlayerData.Fragments or 0) < 1500 then
                    SetTask('MainTask', 'Auto Full Melee | Dragon Claw cần 1500 Fragments — đang farm Raid (' .. (ScriptStorage.PlayerData.Fragments or 0) .. '/1500)')
                    return
                end

                local canBuy = true
                for currency, amount in pairs(melee.price) do
                    local have = (currency == "Beli" and ScriptStorage.PlayerData.Beli) or
                                 (currency == "Fragments" and ScriptStorage.PlayerData.Fragments) or 0
                    if have < amount then canBuy = false end
                end
                -- [FIXED] needKey/needFireEssence/needMaterials trước đây
                -- nằm ở nhánh "ĐÃ SỞ HỮU" (else bên dưới) — vô nghĩa, vì đây
                -- là điều kiện TIÊN QUYẾT phải có TRƯỚC khi mua, không phải
                -- thứ cần check sau khi đã mua xong. Chuyển về đúng chỗ.

                if melee.needKey and not CheckItem(melee.needKey) then
                    SetTask('MainTask', 'Auto Full Melee | Lấy ' .. melee.needKey .. ' cho ' .. melee.name)
                    if melee.needKey == "Library Key" then
                        local admiral = GetConnectionEnemies("Awakened Ice Admiral")
                        if admiral then
                            -- [FIXED - giảm delay] Attack() đã tự block chờ
                            -- hạ xong rồi, wait(2) sau đó là dư thừa
                            CombatController.Attack("Awakened Ice Admiral")
                        else
                            TweenController.Create(CFrame.new(5668.978, 28.52, -6483.352))
                        end
                    elseif melee.needKey == "Water Key" then
                        local tide = GetConnectionEnemies("Tide Keeper")
                        if tide then
                            CombatController.Attack("Tide Keeper")
                        else
                            TweenController.Create(CFrame.new(-3053.981, 237.19, -10145.039))
                        end
                    end
                    return
                end

                -- [NEW] Điều kiện tiên quyết mastery — verified từ raw_6:
                -- Superhuman cần Dragon Claw đạt 300 mastery trước khi mua
                -- [NEW] Electro: missão do Lightning Bolt antes da compra
                if melee.needLightningBolt then
                    if not ElectroQuestStep() then return end
                end

                if melee.needMastery then
                    local preMastery = ScriptStorage.Melees[melee.needMastery.item] or 0
                    if not CheckItem(melee.needMastery.item) or preMastery < melee.needMastery.value then
                        SetTask('MainTask', 'Auto Full Melee | Cần ' .. melee.needMastery.item .. ' đạt ' .. melee.needMastery.value .. ' mastery trước (hiện ' .. preMastery .. ') để mua ' .. melee.name)
                        return
                    end
                end

                if melee.needFireEssence then
                    local hasFireEssence = CheckItem("Fire Essence")

                    if hasFireEssence then
                        -- [FIXED] Verified từ raw_6: equip Fire Essence rồi gọi
                        -- BuyDragonTalon HAI LẦN (true, rồi không tham số) —
                        -- trước đây tao chỉ farm bones, chưa từng thật sự dùng
                        -- Fire Essence để mua Dragon Talon.
                        SetTask('MainTask', 'Auto Full Melee | Dùng Fire Essence mua Dragon Talon')
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fire Essence")
                        task.wait(0.5)
                        Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
                        Remotes.CommF_:InvokeServer("BuyDragonTalon")
                        return
                    end

                    if not CheckItem(melee.name) then
                        -- [FIXED] Ngưỡng thật 500 Bones (giống CDK), burst-buy
                        -- tới khi hết, không nhỏ giọt buy(1,1) từng lần
                        local bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                        if bonesCount and bonesCount > 500 then
                            SetTask('MainTask', 'Auto Full Melee | Đổi Bones lấy Fire Essence (' .. bonesCount .. ')')
                            repeat
                                Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                                task.wait(0.2)
                                bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                            until not bonesCount or bonesCount <= 0
                            return
                        end
                        if not ScriptStorage.Enemies["Reborn Skeleton"] and not ScriptStorage.Enemies["Living Zombie"]
                            and not ScriptStorage.Enemies["Demonic Soul"] and not ScriptStorage.Enemies["Posessed Mummy"] then
                            -- [NEW] Chưa thấy quái gần đây → di chuyển tới đúng
                            -- điểm farm Haunted Castle thay vì đứng im chờ
                            SetTask('MainTask', 'Auto Full Melee | Di chuyển tới Haunted Castle farm Bones (' .. (bonesCount or 0) .. '/500)')
                            TweenController.Create(HAUNTED_CASTLE_BONES_CF)
                            return
                        end
                        SetTask('MainTask', 'Auto Full Melee | Farm Bones cho Fire Essence (' .. (bonesCount or 0) .. '/500)')
                        CombatController.Attack({'Reborn Skeleton', 'Living Zombie', 'Demonic Soul', 'Posessed Mummy'})
                        return
                    end
                end

                if melee.needMaterials then
                    -- [NEW] Cổng "mọi thứ đủ điều kiện chưa" — CHỈ farm vật
                    -- liệu Godhuman khi cả 8 melee kia đã mua + đủ mastery
                    local ready, reason = AllMeleesReady()
                    if not ready then
                        SetTask('MainTask', 'Auto Full Melee | Godhuman: chưa đủ điều kiện — ' .. (reason or "?"))
                        return
                    end

                    local materials = {
                        {name = "Dragon Scale", need = 10, sea = 3, mobs = {"Dragon Crew Warrior", "Dragon Crew Archer"}},
                        {name = "Fish Tail", need = 20, sea = 3, mobs = {"Fishman Raider", "Fishman Captain"}},
                        {name = "Mystic Droplet", need = 10, sea = 2, mobs = {"Sea Soldier", "Water Fighter"}},
                        {name = "Magma Ore", need = 20, sea = 2, mobs = {"Magma Ninja"}},
                    }
                    for _, mat in ipairs(materials) do
                        local count = ScriptStorage.Backpack[mat.name] and ScriptStorage.Backpack[mat.name].Count or 0
                        if count < mat.need then
                            if SeaIndex ~= mat.sea then
                                Remotes.CommF_:InvokeServer(mat.sea == 2 and "TravelDressrosa" or "TravelZou")
                                return
                            end
                            SetTask('MainTask', 'Auto Full Melee | Godhuman: farm ' .. mat.name .. ' (' .. count .. '/' .. mat.need .. ')')
                            CombatController.Attack(mat.mobs)
                            return
                        end
                    end
                    -- Đủ vật liệu rồi → rơi xuống check tiền/Fragments bên dưới để mua
                end

                if canBuy then
                    -- [FIXED - LỖI SÂU] GoToTeacher() của tao tự tween thủ
                    -- công là ĐÚNG (dùng toạ độ verified, phủ đủ cả
                    -- DragonClaw/Superhuman mà bảng gốc BindedMeleeNPCNames
                    -- KHÔNG có) — giữ nguyên bước này.
                    -- NHƯNG cách gọi remote SAI: trước giờ chỉ gọi
                    -- BuyMelee(key, true) — đây là proxy CHECK (2nd arg=true
                    -- khiến auto-navigate của proxy gốc dòng ~427 bị skip vì
                    -- nó yêu cầu "not h"), KHÔNG PHẢI lệnh mua thật. Phải gọi
                    -- THÊM lần 2 KHÔNG kèm true để proxy thật sự chạy nhánh
                    -- mua (dòng 446 luôn invoke thật, nhưng cần đủ 2 bước để
                    -- J ghi nhận hợp lệ trước khi bước 2 chạy).
                    if not GoToTeacher(melee.name) then
                        SetTask('MainTask', 'Auto Full Melee | Di chuyển tới ' .. (MeleeTeacher[melee.name] or "?") .. ' để mua ' .. melee.name)
                        return
                    end
                    SetTask('MainTask', 'Auto Full Melee | Mua ' .. melee.name)
                    local checkResult = BuyMelee(melee.key, true)  -- Bước 1: check (proxy ghi vào J nếu hợp lệ)
                    task.wait(0.3)
                    BuyMelee(melee.key)                            -- Bước 2: mua thật (kích hoạt proxy auto-navigate + invoke thật)
                    task.wait(0.5)
                    if CheckItem(melee.name) then
                        SetTask('MainTask', 'Auto Full Melee | ✅ Mua thành công ' .. melee.name)
                        -- Comprou o Dark Step antes do nível 200: devolve o controlo
                        -- ao LevelFarm em vez de tentar comprar outros estilos já.
                        if melee.name == "Black Leg" and currentLevel < 200 then
                            return
                        end
                    else
                        SetTask('SubTask', 'Auto Full Melee | Đã gửi lệnh mua ' .. melee.name .. ' — kiểm tra lại vòng sau')
                        local fk = melee.name .. "#falhas"
                        MeleeBlock[fk] = (MeleeBlock[fk] or 0) + 1
                        if MeleeBlock[fk] >= 3 then
                            MeleeBlock[fk] = 0
                            MeleeBlock[melee.name] = os.clock() + 600
                            warn("[BombaCat] Compra de " .. melee.name .. " falhou 3 vezes; pausa de 10 min (o script volta a farmar).")
                        end
                    end
                else
                    -- [FIXED] Không còn set _G.Level=true (khóa vĩnh viễn) —
                    -- chỉ báo trạng thái rồi return, Refresh sẽ tự thử lại
                    -- vòng sau khi tiền/Fragments đủ (RaidController vẫn
                    -- chạy song song farm Fragments qua TasksOrder bình thường)
                    -- Đúng yêu cầu boss man: "chạy lại mua tới chừng nào mua được"
                    -- [FIX] Sem Beli/Fragments (ou sem nível) para comprar: não fica parado.
                    -- MeleesController vem ANTES do LevelFarm e, como o dispatcher usa "o primeiro que responde ganha",
                    -- este "return" deixava o personagem parado. Agora corre o farm de nível (que dá Beli).
                    farmWith(trainName)
                    return
                end
            else
                -- [FIXED] Mastery đọc từ ScriptStorage.Melees[name] — đây mới
                -- là nguồn thật (xem dòng ~403). "bp.Level.Value" cũ KHÔNG
                -- TỒN TẠI trên tool, khiến toàn bộ check mastery bị bỏ qua
                -- lặng lẽ (bp:FindFirstChild("Level") luôn nil → điều kiện
                -- luôn false) — đây là lý do auto melee tưởng đã "sẵn sàng"
                -- dù mastery còn thấp.
                local mastery = ScriptStorage.Melees[melee.name] or 0

                if melee.levelReq and ScriptStorage.PlayerData.Level < melee.levelReq then
                    -- [FIX] Sem Beli/Fragments (ou sem nível) para comprar: não fica parado.
                    -- MeleesController vem ANTES do LevelFarm e, como o dispatcher usa "o primeiro que responde ganha",
                    -- este "return" deixava o personagem parado. Agora corre o farm de nível (que dá Beli).
                    farmWith(trainName)
                    return
                end

                -- [NEW] V1 đạt 500 mastery + chưa có V2 tương ứng → ưu tiên
                -- Raid lấy Fragments (yêu cầu boss man: "nếu đc 500 mastery
                -- thì đi raid để có F mua võ v2"). Đạt rồi thì KHÔNG return
                -- cứng — để vòng lặp tiếp tục xử lý các melee còn lại ("kiểm
                -- tra nếu đủ điều kiện mastery thì mua melee khác").
                local v2Name = V1ToV2[melee.name]
                if Config.Melee.CheckMasteryAfterBuy and v2Name and not CheckItem(v2Name) then
                    if mastery < Config.Melee.RaidAtV1Mastery then
                        SetTask('SubTask', melee.name .. ' đang train mastery (' .. mastery .. '/' .. Config.Melee.RaidAtV1Mastery .. ')')
                        trainName = trainName or melee.name
                        trainTarget = trainTarget or Config.Melee.RaidAtV1Mastery
                    else
                        local v2Data = MeleePrices[v2Name]
                        local needFrags = (v2Data and v2Data.Price and v2Data.Price.Fragments) or 5000
                        local needBeli  = (v2Data and v2Data.Price and v2Data.Price.Beli) or 2500000
                        local haveFrags = ScriptStorage.PlayerData.Fragments or 0
                        local haveBeli  = ScriptStorage.PlayerData.Beli or 0
                        if haveFrags < needFrags or haveBeli < needBeli then
                            SetTask('MainTask', string.format(
                                'Auto Full Melee | %s đạt %d mastery — chờ Raid farm Fragments cho %s (F:%d/%d, Beli:%d/%d)',
                                melee.name, mastery, v2Name, haveFrags, needFrags, haveBeli, needBeli
                            ))
                        end
                    end
                end

                -- [NEW] V2 đạt 400 mastery → điều kiện Godhuman coi như đạt
                -- cho MELEE NÀY (còn đủ điều kiện TỔNG THỂ hay chưa thì
                -- AllMeleesReady() ở nhánh needMaterials phía trên quyết định)
                local V2_TO_GODHUMAN = {["Death Step"]=true, ["Sharkman Karate"]=true, ["Electric Claw"]=true, ["Dragon Talon"]=true}
                if Config.Melee.CheckMasteryAfterBuy and V2_TO_GODHUMAN[melee.name] and not CheckItem("Godhuman") then
                    if mastery < Config.Melee.GodhumanAtV2Mastery then
                        SetTask('SubTask', melee.name .. ' đang train mastery (' .. mastery .. '/' .. Config.Melee.GodhumanAtV2Mastery .. ')')
                        trainName = trainName or melee.name
                        trainTarget = trainTarget or Config.Melee.GodhumanAtV2Mastery
                    end
                end

                SetTask('SubTask', '✅ ' .. melee.name .. ' đã sẵn sàng')
            end
        end

        if trainName then
            -- [FIX] Antes ficava só a mostrar "treinar mastery" e não fazia nada (e bloqueava o resto).
            -- Agora equipa esse melee e farma mobs até chegar à mastery alvo.
            local mst = (ScriptStorage.Melees and ScriptStorage.Melees[trainName]) or 0
            if SetText then SetText('AuxValue', 'Farming until enough mastery for ' .. trainName .. ' (' .. mst .. ' / ' .. tostring(trainTarget) .. ')') end
            farmWith(trainName)
            return
        end

        SetTask('MainTask', 'Auto Full Melee | 🎉 Hoàn thành tất cả!')
    end)

    -- ============================================================
    -- LEVEL FARM - HOÀN CHỈNH
    -- ============================================================
    -- [ADDED - theo yêu cầu boss man: "sửa hệ thống farm lv... từ file
    -- message 10"] QuestController — theo dõi quest bằng REMOTE EVENT thật
    -- (Remotes.QuestUpdate) thay vì GetCurrentClaimQuest() (đọc GUI text
    -- PlayerGui.Main.Quest.Container.QuestTitle.Title.Text). Đọc GUI text
    -- có độ trễ replication thật — bắn StartQuest xong, đọc lại GUI ngay
    -- frame kế có thể vẫn thấy tên quest CŨ, khiến so sánh "CurrentClaim
    -- Quest1 ~= Q.NameMon" sai và gọi AbandonQuest ngay quest vừa nhận.
    -- Remotes.QuestUpdate:OnClientEvent bắn THẲNG từ server mỗi khi quest
    -- state đổi — không polling, không trễ.
    QuestController = {
        CurrentQuest = "",
        CurrentQuestName = "",
        QuestConnection = nil,
    }
    QuestController.Set = function(self, data)
        self.CurrentQuest = (function()
            for i, _ in next, data.Progress do
                return i
            end
        end)()
        self.CurrentQuestName = data.InternalQuestName
    end
    QuestController.Reset = function(self)
        self.CurrentQuest = ""
        self.CurrentQuestName = ""
    end
    local questConnectOk = pcall(function()
        QuestController.QuestConnection = Services.ReplicatedStorage.Remotes.QuestUpdate.OnClientEvent:Connect(function(a2, a3)
            if a2 and typeof(a2) == "table" then
                QuestController:Set(a2)
                return
            end
            QuestController:Reset()
        end)
    end)
    -- [FIXED] QuestController.CurrentQuestName là tên QUEST (vd
    -- "BanditQuest1"), KHÁC với GetCurrentClaimQuest() (tên MOB đọc từ GUI
    -- text) — 2 thứ không so sánh chéo được. HasActiveQuest()/GetActive
    -- QuestName() tách riêng, và nếu không kết nối được Remotes.QuestUpdate
    -- thì trả về nil để Start() tự rơi về GetCurrentClaimQuest() (so mob
    -- name như cũ) — không trộn lẫn 2 loại tên.
    function HasActiveQuestEvent()
        return questConnectOk and QuestController.QuestConnection ~= nil
    end
    function GetActiveQuestName()
        if not HasActiveQuestEvent() then return nil end
        if QuestController.CurrentQuest == "" then return false end
        return QuestController.CurrentQuestName
    end

    local function ManualLevelLookup()
        -- [ADDED - theo yêu cầu boss man] Bảng farm-lv THỦ CÔNG, KHÔNG phụ
        -- thuộc J.RefreshQuest/require(Quests) (chuỗi đang gãy — J.RefreshQuest
        -- match ScriptStorage.PlayerData.Level với LevelReq trong Quests module,
        -- lỡ không khớp thì "h" ở đó ra nil rồi crash ngay dòng kế — đúng kiểu
        -- "request data lv" mà farm theo không chạy nữa). Bảng này CHỈ đọc
        -- ScriptStorage.PlayerData.Level (property thường, không qua request/
        -- module-matching gì cả) rồi tra thẳng mob+CFrame, y hệt cách vantablack/
        -- Maru Premium làm — dữ liệu lấy nguyên từ file tham chiếu thật đã verify
        -- (toạ độ CFrame chính xác từng đảo, không đoán).
        local MyLevel = ScriptStorage.PlayerData.Level or 0
        local Mon, Qdata, Qname, NameMon = "", 0, "", ""
        local PosQ, PosM = nil, nil

        if SeaIndex == 1 then
            if MyLevel >= 1 and MyLevel <= 9 then
                Mon = "Bandit"; Qdata = 1; Qname = "BanditQuest1"; NameMon = "Bandit"
                PosQ = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, 0, -0.341998369, 0, 1, 0, 0.341998369, 0, 0.939700544)
                PosM = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
            elseif MyLevel >= 10 and MyLevel <= 14 then
                Mon = "Monkey"; Qdata = 1; Qname = "JungleQuest"; NameMon = "Monkey"
                PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
                PosM = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
            elseif MyLevel >= 15 and MyLevel <= 29 then
                Mon = "Gorilla"; Qdata = 2; Qname = "JungleQuest"; NameMon = "Gorilla"
                PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
                PosM = CFrame.new(-1129.8836669921875, 40.46354675296875, -525.4237060546875)
            elseif MyLevel >= 30 and MyLevel <= 39 then
                Mon = "Pirate"; Qdata = 1; Qname = "BuggyQuest1"; NameMon = "Pirate"
                PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
            elseif MyLevel >= 40 and MyLevel <= 59 then
                Mon = "Brute"; Qdata = 2; Qname = "BuggyQuest1"; NameMon = "Brute"
                PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
            elseif MyLevel >= 60 and MyLevel <= 74 then
                Mon = "Desert Bandit"; Qdata = 1; Qname = "DesertQuest"; NameMon = "Desert Bandit"
                PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
                PosM = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
            elseif MyLevel >= 75 and MyLevel <= 89 then
                Mon = "Desert Officer"; Qdata = 2; Qname = "DesertQuest"; NameMon = "Desert Officer"
                PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
                PosM = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
            elseif MyLevel >= 90 and MyLevel <= 99 then
                Mon = "Snow Bandit"; Qdata = 1; Qname = "SnowQuest"; NameMon = "Snow Bandit"
                PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
                PosM = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)
            elseif MyLevel >= 100 and MyLevel <= 119 then
                Mon = "Snowman"; Qdata = 2; Qname = "SnowQuest"; NameMon = "Snowman"
                PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
                PosM = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
            elseif MyLevel >= 120 and MyLevel <= 149 then
                Mon = "Chief Petty Officer"; Qdata = 1; Qname = "MarineQuest2"; NameMon = "Chief Petty Officer"
                PosQ = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)
            elseif MyLevel >= 150 and MyLevel <= 174 then
                Mon = "Sky Bandit"; Qdata = 1; Qname = "SkyQuest"; NameMon = "Sky Bandit"
                PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)
            elseif MyLevel >= 175 and MyLevel <= 189 then
                Mon = "Dark Master"; Qdata = 2; Qname = "SkyQuest"; NameMon = "Dark Master"
                PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)
            elseif MyLevel >= 190 and MyLevel <= 209 then
                Mon = "Prisoner"; Qdata = 1; Qname = "PrisonerQuest"; NameMon = "Prisoner"
                PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, 0, -0.995993316, 0, 1, 0, 0.995993316, 0, -0.0894274712)
                PosM = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)
            elseif MyLevel >= 210 and MyLevel <= 249 then
                Mon = "Dangerous Prisoner"; Qdata = 2; Qname = "PrisonerQuest"; NameMon = "Dangerous Prisoner"
                PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, 0, -0.995993316, 0, 1, 0, 0.995993316, 0, -0.0894274712)
                PosM = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)
            elseif MyLevel >= 250 and MyLevel <= 274 then
                Mon = "Toga Warrior"; Qdata = 1; Qname = "ColosseumQuest"; NameMon = "Toga Warrior"
                PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
                PosM = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)
            elseif MyLevel >= 275 and MyLevel <= 299 then
                Mon = "Gladiator"; Qdata = 2; Qname = "ColosseumQuest"; NameMon = "Gladiator"
                PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
                PosM = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)
            elseif MyLevel >= 300 and MyLevel <= 324 then
                Mon = "Military Soldier"; Qdata = 1; Qname = "MagmaQuest"; NameMon = "Military Soldier"
                PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
                PosM = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875)
            elseif MyLevel >= 325 and MyLevel <= 374 then
                Mon = "Military Spy"; Qdata = 2; Qname = "MagmaQuest"; NameMon = "Military Spy"
                PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
                PosM = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)
            elseif MyLevel >= 375 and MyLevel <= 399 then
                Mon = "Fishman Warrior"; Qdata = 1; Qname = "FishmanQuest"; NameMon = "Fishman Warrior"
                PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                PosM = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)
            elseif MyLevel >= 400 and MyLevel <= 449 then
                Mon = "Fishman Commando"; Qdata = 2; Qname = "FishmanQuest"; NameMon = "Fishman Commando"
                PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                PosM = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)
            elseif MyLevel >= 450 and MyLevel <= 474 then
                Mon = "God's Guard"; Qdata = 1; Qname = "SkyExp1Quest"; NameMon = "God's Guard"
                PosQ = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, 0.996191859)
                PosM = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)
            elseif MyLevel >= 475 and MyLevel <= 524 then
                Mon = "Shanda"; Qdata = 2; Qname = "SkyExp1Quest"; NameMon = "Shanda"
                PosQ = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
                PosM = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)
            elseif MyLevel >= 525 and MyLevel <= 549 then
                Mon = "Royal Squad"; Qdata = 1; Qname = "SkyExp2Quest"; NameMon = "Royal Squad"
                PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)
            elseif MyLevel >= 550 and MyLevel <= 624 then
                Mon = "Royal Soldier"; Qdata = 2; Qname = "SkyExp2Quest"; NameMon = "Royal Soldier"
                PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)
            elseif MyLevel >= 625 and MyLevel <= 649 then
                Mon = "Galley Pirate"; Qdata = 1; Qname = "FountainQuest"; NameMon = "Galley Pirate"
                PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
                PosM = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)
            elseif MyLevel >= 650 then
                Mon = "Galley Captain"; Qdata = 2; Qname = "FountainQuest"; NameMon = "Galley Captain"
                PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
                PosM = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)
            end
        elseif SeaIndex == 2 then
            if MyLevel >= 700 and MyLevel <= 724 then
                Mon = "Raider"; Qdata = 1; Qname = "Area1Quest"; NameMon = "Raider"
                PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
                PosM = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
            elseif MyLevel >= 725 and MyLevel <= 774 then
                Mon = "Mercenary"; Qdata = 2; Qname = "Area1Quest"; NameMon = "Mercenary"
                PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
                PosM = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
            elseif MyLevel >= 775 and MyLevel <= 799 then
                Mon = "Swan Pirate"; Qdata = 1; Qname = "Area2Quest"; NameMon = "Swan Pirate"
                PosQ = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
                PosM = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)
            elseif MyLevel >= 800 and MyLevel <= 874 then
                Mon = "Factory Staff"; Qdata = 2; Qname = "Area2Quest"; NameMon = "Factory Staff"
                PosQ = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 0, -0.999488771, 0, 1, 0, 0.999488771, 0, -0.0319722369)
                PosM = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)
            elseif MyLevel >= 875 and MyLevel <= 899 then
                Mon = "Marine Lieutenant"; Qdata = 1; Qname = "MarineQuest3"; NameMon = "Marine Lieutenant"
                PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)
            elseif MyLevel >= 900 and MyLevel <= 949 then
                Mon = "Marine Captain"; Qdata = 2; Qname = "MarineQuest3"; NameMon = "Marine Captain"
                PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
                PosM = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)
            elseif MyLevel >= 950 and MyLevel <= 974 then
                Mon = "Zombie"; Qdata = 1; Qname = "ZombieQuest"; NameMon = "Zombie"
                PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
                PosM = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)
            elseif MyLevel >= 975 and MyLevel <= 999 then
                Mon = "Vampire"; Qdata = 2; Qname = "ZombieQuest"; NameMon = "Vampire"
                PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
                PosM = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
            elseif MyLevel >= 1000 and MyLevel <= 1049 then
                Mon = "Snow Trooper"; Qdata = 1; Qname = "SnowMountainQuest"; NameMon = "Snow Trooper"
                PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
                PosM = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)
            elseif MyLevel >= 1050 and MyLevel <= 1099 then
                Mon = "Winter Warrior"; Qdata = 2; Qname = "SnowMountainQuest"; NameMon = "Winter Warrior"
                PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
                PosM = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)
            elseif MyLevel >= 1100 and MyLevel <= 1124 then
                Mon = "Lab Subordinate"; Qdata = 1; Qname = "IceSideQuest"; NameMon = "Lab Subordinate"
                PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
                PosM = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)
            elseif MyLevel >= 1125 and MyLevel <= 1174 then
                Mon = "Horned Warrior"; Qdata = 2; Qname = "IceSideQuest"; NameMon = "Horned Warrior"
                PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
                PosM = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)
            elseif MyLevel >= 1175 and MyLevel <= 1199 then
                Mon = "Magma Ninja"; Qdata = 1; Qname = "FireSideQuest"; NameMon = "Magma Ninja"
                PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
                PosM = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)
            elseif MyLevel >= 1200 and MyLevel <= 1249 then
                Mon = "Lava Pirate"; Qdata = 2; Qname = "FireSideQuest"; NameMon = "Lava Pirate"
                PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
                PosM = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
            elseif MyLevel >= 1250 and MyLevel <= 1274 then
                Mon = "Ship Deckhand"; Qdata = 1; Qname = "ShipQuest1"; NameMon = "Ship Deckhand"
                PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
                PosM = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)
            elseif MyLevel >= 1275 and MyLevel <= 1299 then
                Mon = "Ship Engineer"; Qdata = 2; Qname = "ShipQuest1"; NameMon = "Ship Engineer"
                PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
                PosM = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)
            elseif MyLevel >= 1300 and MyLevel <= 1324 then
                Mon = "Ship Steward"; Qdata = 1; Qname = "ShipQuest2"; NameMon = "Ship Steward"
                PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
                PosM = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)
            elseif MyLevel >= 1325 and MyLevel <= 1349 then
                Mon = "Ship Officer"; Qdata = 2; Qname = "ShipQuest2"; NameMon = "Ship Officer"
                PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
                PosM = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)
            elseif MyLevel >= 1350 and MyLevel <= 1374 then
                Mon = "Arctic Warrior"; Qdata = 1; Qname = "FrostQuest"; NameMon = "Arctic Warrior"
                PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
                PosM = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)
            elseif MyLevel >= 1375 and MyLevel <= 1424 then
                Mon = "Snow Lurker"; Qdata = 2; Qname = "FrostQuest"; NameMon = "Snow Lurker"
                PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
                PosM = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)
            elseif MyLevel >= 1425 and MyLevel <= 1449 then
                Mon = "Sea Soldier"; Qdata = 1; Qname = "ForgottenQuest"; NameMon = "Sea Soldier"
                PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0, 0.13915664, 0, 0.990270376)
                PosM = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)
            elseif MyLevel >= 1450 then
                Mon = "Water Fighter"; Qdata = 2; Qname = "ForgottenQuest"; NameMon = "Water Fighter"
                PosQ = CFrame.new(-3054, 240, -10146)
                PosM = CFrame.new(-3291, 252, -10501)
            end
        elseif SeaIndex == 3 then
            if MyLevel >= 1500 and MyLevel <= 1524 then
                Mon = "Pirate Millionaire"; Qdata = 1; Qname = "PiratePortQuest"; NameMon = "Pirate Millionaire"
                PosQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
            elseif MyLevel >= 1525 and MyLevel <= 1574 then
                Mon = "Pistol Billionaire"; Qdata = 2; Qname = "PiratePortQuest"; NameMon = "Pistol Billionaire"
                PosQ = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
                PosM = CFrame.new(-187.3301544189453, 86.23987579345703, 6013.513671875)
            elseif MyLevel >= 1575 and MyLevel <= 1599 then
                Mon = "Dragon Crew Warrior"; Qdata = 1; Qname = "DragonCrewQuest"; NameMon = "Dragon Crew Warrior"
                PosQ = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375)
                PosM = CFrame.new(6920.71435546875, 56.15597152709961, -942.5044555664062)
            elseif MyLevel >= 1600 and MyLevel <= 1624 then
                Mon = "Dragon Crew Archer"; Qdata = 2; Qname = "DragonCrewQuest"; NameMon = "Dragon Crew Archer"
                PosQ = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375)
                PosM = CFrame.new(6817.91259765625, 484.804443359375, 513.4141235351562)
            elseif MyLevel >= 1625 and MyLevel <= 1649 then
                Mon = "Hydra Enforcer"; Qdata = 1; Qname = "VenomCrewQuest"; NameMon = "Hydra Enforcer"
                PosQ = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125)
                PosM = CFrame.new(4584.69287109375, 1002.6435546875, 705.7958984375)
            elseif MyLevel >= 1650 and MyLevel <= 1699 then
                Mon = "Venomous Assailant"; Qdata = 2; Qname = "VenomCrewQuest"; NameMon = "Venomous Assailant"
                PosQ = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125)
                PosM = CFrame.new(4638.78564453125, 1078.94091796875, 881.8002319335938)
            elseif MyLevel >= 1700 and MyLevel <= 1724 then
                Mon = "Marine Commodore"; Qdata = 1; Qname = "MarineTreeIsland"; NameMon = "Marine Commodore"
                PosQ = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
                PosM = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)
            elseif MyLevel >= 1725 and MyLevel <= 1774 then
                Mon = "Marine Rear Admiral"; Qdata = 2; Qname = "MarineTreeIsland"; NameMon = "Marine Rear Admiral"
                PosQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
                PosM = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)
            elseif MyLevel >= 1775 and MyLevel <= 1799 then
                Mon = "Fishman Raider"; Qdata = 2; Qname = "DeepForestIsland3"; NameMon = "Fishman Raider"
                PosQ = CFrame.new(3142.67822, 108.42981, 7482.37988, 0.34205412, 0, 0.939680243, 0, 1, 0, -0.939680243, 0, 0.34205412)
                PosM = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
            elseif MyLevel >= 1800 and MyLevel <= 1824 then
                Mon = "Fishman Captain"; Qdata = 1; Qname = "DeepForestIsland3"; NameMon = "Fishman Captain"
                PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
                PosM = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)
            elseif MyLevel >= 1825 and MyLevel <= 1849 then
                Mon = "Forest Pirate"; Qdata = 2; Qname = "DeepForestIsland"; NameMon = "Forest Pirate"
                PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
                PosM = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
            elseif MyLevel >= 1850 and MyLevel <= 1899 then
                Mon = "Forest Pirate"; Qdata = 1; Qname = "DeepForestIsland"; NameMon = "Forest Pirate"
                PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
                PosM = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
            elseif MyLevel >= 1900 and MyLevel <= 1924 then
                Mon = "Jungle Pirate"; Qdata = 2; Qname = "DeepForestIsland"; NameMon = "Jungle Pirate"
                PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
                PosM = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
            elseif MyLevel >= 1925 and MyLevel <= 1974 then
                Mon = "Musketeer Pirate"; Qdata = 2; Qname = "DeepForestIsland2"; NameMon = "Musketeer Pirate"
                PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
                PosM = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
            elseif MyLevel >= 1975 and MyLevel <= 1999 then
                Mon = "Reborn Skeleton"; Qdata = 1; Qname = "HauntedQuest1"; NameMon = "Reborn Skeleton"
                PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                PosM = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
            elseif MyLevel >= 2000 and MyLevel <= 2024 then
                Mon = "Living Zombie"; Qdata = 2; Qname = "HauntedQuest1"; NameMon = "Living Zombie"
                PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                PosM = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
            elseif MyLevel >= 2025 and MyLevel <= 2049 then
                Mon = "Demonic Soul"; Qdata = 1; Qname = "HauntedQuest2"; NameMon = "Demonic Soul"
                PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
            elseif MyLevel >= 2050 and MyLevel <= 2074 then
                Mon = "Posessed Mummy"; Qdata = 2; Qname = "HauntedQuest2"; NameMon = "Posessed Mummy"
                PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
            elseif MyLevel >= 2075 and MyLevel <= 2099 then
                Mon = "Peanut Scout"; Qdata = 1; Qname = "NutsIslandQuest"; NameMon = "Peanut Scout"
                PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
            elseif MyLevel >= 2100 and MyLevel <= 2124 then
                Mon = "Peanut President"; Qdata = 1; Qname = "NutsIslandQuest"; NameMon = "Peanut President"
                PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
            elseif MyLevel >= 2125 and MyLevel <= 2149 then
                Mon = "Ice Cream Chef"; Qdata = 1; Qname = "IceCreamIslandQuest"; NameMon = "Ice Cream Chef"
                PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
            elseif MyLevel >= 2150 and MyLevel <= 2199 then
                Mon = "Ice Cream Commander"; Qdata = 2; Qname = "IceCreamIslandQuest"; NameMon = "Ice Cream Commander"
                PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                PosM = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
            elseif MyLevel >= 2200 and MyLevel <= 2224 then
                Mon = "Cookie Crafter"; Qdata = 1; Qname = "CakeQuest1"; NameMon = "Cookie Crafter"
                PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
                PosM = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
            elseif MyLevel >= 2225 and MyLevel <= 2249 then
                Mon = "Cake Guard"; Qdata = 2; Qname = "CakeQuest1"; NameMon = "Cake Guard"
                PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
                PosM = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
            elseif MyLevel >= 2250 and MyLevel <= 2274 then
                Mon = "Baking Staff"; Qdata = 1; Qname = "CakeQuest2"; NameMon = "Baking Staff"
                PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
                PosM = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
            elseif MyLevel >= 2275 and MyLevel <= 2299 then
                Mon = "Head Baker"; Qdata = 2; Qname = "CakeQuest2"; NameMon = "Head Baker"
                PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
                PosM = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
            elseif MyLevel >= 2300 and MyLevel <= 2324 then
                Mon = "Cocoa Warrior"; Qdata = 1; Qname = "ChocQuest1"; NameMon = "Cocoa Warrior"
                PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
                PosM = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
            elseif MyLevel >= 2325 and MyLevel <= 2349 then
                Mon = "Chocolate Bar Battler"; Qdata = 2; Qname = "ChocQuest1"; NameMon = "Chocolate Bar Battler"
                PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
                PosM = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
            elseif MyLevel >= 2350 and MyLevel <= 2374 then
                Mon = "Sweet Thief"; Qdata = 1; Qname = "ChocQuest2"; NameMon = "Sweet Thief"
                PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
                PosM = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
            elseif MyLevel >= 2375 and MyLevel <= 2399 then
                Mon = "Candy Rebel"; Qdata = 2; Qname = "ChocQuest2"; NameMon = "Candy Rebel"
                PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
                PosM = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
            elseif MyLevel >= 2400 and MyLevel <= 2424 then
                Mon = "Candy Pirate"; Qdata = 1; Qname = "CandyQuest1"; NameMon = "Candy Pirate"
                PosQ = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
                PosM = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
            elseif MyLevel >= 2425 and MyLevel <= 2449 then
                Mon = "Snow Demon"; Qdata = 2; Qname = "CandyQuest1"; NameMon = "Snow Demon"
                PosQ = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
                PosM = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)
            elseif MyLevel >= 2450 and MyLevel <= 2474 then
                Mon = "Isle Outlaw"; Qdata = 1; Qname = "TikiQuest1"; NameMon = "Isle Outlaw"
                PosQ = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
                PosM = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656)
            elseif MyLevel >= 2475 and MyLevel <= 2524 then
                Mon = "Island Boy"; Qdata = 2; Qname = "TikiQuest1"; NameMon = "Island Boy"
                PosQ = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
                PosM = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562)
            elseif MyLevel >= 2525 and MyLevel <= 2574 then
                Mon = "Isle Champion"; Qdata = 1; Qname = "TikiQuest2"; NameMon = "Isle Champion"
                PosQ = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
                PosM = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375)
            elseif MyLevel >= 2575 and MyLevel <= 2599 then
                Mon = "Skull Slayer"; Qdata = 2; Qname = "TikiQuest3"; NameMon = "Skull Slayer"
                PosQ = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0, 0.308980465, 0, 0.951068401)
                PosM = CFrame.new(-16887.7305, 113.074638, 1629.97778, -0.559032857, 1.2313353e-08, -0.829145491, 1.05618814e-09, 1, 1.41385428e-08, 0.829145491, 7.02817626e-09, -0.559032857)
            elseif MyLevel >= 2600 and MyLevel <= 2624 then
                Mon = "Reef Bandit"; Qdata = 1; Qname = "SubmergedQuest1"; NameMon = "Reef Bandit"
                PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612)
                PosM = CFrame.new(11019.1318, -2146.06812, 9342.3916, -0.719955266, -1.74275385e-08, 0.69402045, 5.76556367e-08, 1, 8.49211546e-08, -0.69402045, 1.01153624e-07, -0.719955266)
            elseif MyLevel >= 2625 and MyLevel <= 2649 then
                Mon = "Coral Pirate"; Qdata = 2; Qname = "SubmergedQuest1"; NameMon = "Coral Pirate"
                PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612)
                PosM = CFrame.new(10808.6006, -2030.36145, 9364.2334, -0.775185347, -0.0359364748, 0.6307109, 0.0615428537, 0.989336014, 0.132010356, -0.628728986, 0.141148239, -0.764707148)
            elseif MyLevel >= 2650 and MyLevel <= 2674 then
                Mon = "Sea Chanter"; Qdata = 1; Qname = "SubmergedQuest2"; NameMon = "Sea Chanter"
                PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728)
                PosM = CFrame.new(10671.2715, -2057.59155, 10047.2588)
            elseif MyLevel >= 2675 and MyLevel <= 2699 then
                Mon = "Ocean Prophet"; Qdata = 2; Qname = "SubmergedQuest2"; NameMon = "Ocean Prophet"
                PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728)
                PosM = CFrame.new(11008.5195, -2007.72839, 10223.0791, -0.688615739, 2.33523378e-09, -0.725126445, 2.99292546e-09, 1, 3.78221315e-10, 0.725126445, -1.90980032e-09, -0.688615739)
            elseif MyLevel >= 2700 and MyLevel <= 2724 then
                Mon = "High Disciple"; Qdata = 1; Qname = "SubmergedQuest3"; NameMon = "High Disciple"
                PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187)
                PosM = CFrame.new(9750.41602, -1966.93884, 9753.36035, -0.749824047, 5.57797613e-08, -0.661637306, 2.03500754e-08, 1, 6.1243199e-08, 0.661637306, 3.24572511e-08, -0.749824047)
            elseif MyLevel >= 2725 then
                Mon = "Grand Devotee"; Qdata = 2; Qname = "SubmergedQuest3"; NameMon = "Grand Devotee"
                PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187)
                PosM = CFrame.new(9611.70508, -1993.47119, 9882.68848, -0.591375351, 4.14332426e-08, -0.806396425, 4.73774868e-08, 1, 1.66361875e-08, 0.806396425, -2.83668058e-08, -0.591375351)
            end
        end

        if Mon == "" or not PosM then return nil end
        return {Mon = Mon, Qdata = Qdata, Qname = Qname, NameMon = NameMon, PosQ = PosQ, PosM = PosM}
    end


    -- ══════════════════════════════════════════════════════════════════
    -- [ADDED từ message_10] AUTO STORE FRUIT — tự lưu trái cây từ
    -- Backpack/Character vào inventory (StoreFruit) mỗi 1s.
    -- Dùng ScriptStorage.IgnoreStoreFruits để tránh lưu trùng trái
    -- đang được dùng bởi AutoRandomFruit / AutoRaidIce.
    -- Không dùng checkItem() (message_10 only) → dùng table.find trực tiếp.
    -- ══════════════════════════════════════════════════════════════════
    task.spawn(function()
        while true do
            pcall(function()
                local gg = {}
                for _, container in next, {LocalPlayer.Backpack, LocalPlayer.Character} do
                    if container then
                        for _, v in next, container:GetChildren() do
                            if v.Name:find("Fruit") and v:IsA("Tool") then
                                local ori = v:GetAttribute("OriginalName") or v.Name
                                -- Bỏ qua nếu đang bị IgnoreStoreFruits hold
                                if not table.find(ScriptStorage.IgnoreStoreFruits, v.Name)
                                and not table.find(ScriptStorage.IgnoreStoreFruits, ori) then
                                    table.insert(gg, {tool = v, ori = ori})
                                end
                            end
                        end
                    end
                end
                if #gg > 0 then
                    local sf = {}
                    local ok, inv = pcall(function()
                        return Remotes.CommF_:InvokeServer("getInventoryFruits")
                    end)
                    if ok and type(inv) == "table" then
                        for _, _v in pairs(inv) do
                            if type(_v) == "table" and _v.Name then
                                sf[_v.Name] = true
                            end
                        end
                    end
                    for _, v in pairs(gg) do
                        if not sf[v.ori] then
                            pcall(function()
                                Remotes.CommF_:InvokeServer("StoreFruit", v.ori, v.tool)
                            end)
                            sf[v.ori] = true
                        end
                    end
                end
            end)
            -- Cousin DLCBoxData ping (từ message_10 — giữ như gốc)
            pcall(function()
                Remotes.CommF_:InvokeServer("Cousin", "DLCBoxData")
            end)
            task.wait(1)
        end
    end)

    -- [ADDED] AUTO RANDOM FRUIT — tự đổi ngẫu nhiên giữa các trái ÁC QUỶ
    -- đang sở hữu trong túi đồ. Dùng getInventoryFruits (lấy danh sách trái
    -- đang có) + LoadFruit (trang bị) — cả 2 remote này đã CÓ THẬT và được
    -- dùng sẵn ở AutoRaidIce.GetCheapestFruit/BuyChip trong chính file này,
    -- không phải tự chế. Đọc Config.Items.AutoRandomFruit (đúng convention
    -- của file — mọi feature khác đều đọc thẳng Config.Items.X, không qua
    -- _G mirror).
    task.spawn(function()
        while task.wait(30) do
            pcall(function()
                if not Config.Items.AutoRandomFruit then return end
                local ok, inventoryFruits = pcall(function()
                    return Remotes.CommF_:InvokeServer("getInventoryFruits")
                end)
                if not ok or type(inventoryFruits) ~= "table" then return end
                local names = {}
                for _, fruitData in pairs(inventoryFruits) do
                    if fruitData and fruitData.Name then
                        table.insert(names, fruitData.Name)
                    end
                end
                if #names == 0 then return end
                local picked = names[math.random(1, #names)]
                table.insert(ScriptStorage.IgnoreStoreFruits, picked)
                Remotes.CommF_:InvokeServer("LoadFruit", picked)
            end)
        end
    end)

    -- ══════════════════════════════════════════════════════════════════
    -- [REPLACED per promt_fix_kaitun — PATCH #1] CheckDataLevel từ message(10)
    -- ⚠️ CẢNH BÁO: kiến trúc ánh xạ CỨNG level→quái (lv<70→Shanda, lv<120→God's Guard)
    -- KHÔNG check vị trí thật trên map — rủi ro đơ nếu vị trí không khớp.
    -- Đây y chang kiểu đã được DynamicIsland gỡ trước đó. Port lại per boss man.
    -- Ánh xạ: plr.Data.Level.Value → ScriptStorage.PlayerData.Level
    -- ══════════════════════════════════════════════════════════════════
    FunctionsHandler.LevelFarm:RegisterMethod("Refresh", function()
        local eqa = getgenv().ElectroQuestActive
        if eqa and os.clock() - eqa < 3 then return nil end -- [FIX Electro] missão do Electro tem prioridade total
        -- Guard chống xung đột AutoSea3/AutoSea2
        if _G.SeaTransitionActive then return nil end

        local lv = ScriptStorage.PlayerData.Level or 0
        -- Ánh xạ y hệt message(10) CheckDataLevel()
        if lv < 10 then
            return 1
        elseif lv < 70 then
            return 2   -- Shanda @ Upper Skylands
        elseif lv < 120 then
            return 3   -- God's Guard @ Skylands
        else
            return 4
        end
    end)
    -- ══════════════════════════════════════════════════════════════════
    -- [REPLACED per promt_fix_kaitun — PATCH #2] Chuyển thể FarmLevelLogic
    -- Ánh xạ Bước 2:
    --   plr.Data.Level.Value   → ScriptStorage.PlayerData.Level
    --   PLACE_ID.sea1/2/3()   → SeaIndex == 1/2/3
    --   bringMob+equipWeapon+FastAttack → CombatController.Attack(name)
    --   CheckMonster(name)    → không cần (đã có trong CombatController.Attack)
    --   Teleport("sky 3/2")   → TweenController.Create trực tiếp (không requestEntrance)
    --                           + TweenController.Create fallback
    -- Giải pháp HYBRID (Cách 1): thêm check vị trí thật (CurrentLocation)
    -- TRƯỚC khi TweenController.Create — vừa dùng logic message(10), vừa không đơ.
    -- ══════════════════════════════════════════════════════════════════
    FunctionsHandler.LevelFarm:RegisterMethod("Start", function(h)
        local currentLevel = ScriptStorage.PlayerData.Level or 0

        -- Guard: đã lên đủ level sang Sea 2 → không farm Sea 1 nữa
        if currentLevel >= 700 and SeaIndex == 1 then return end

        -- ── Sea 3: farm Bones nếu cần (giữ nguyên bản DynamicIsland gốc)
        if SeaIndex == 3 then
            if (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 50 then
                if os.time() > (BonesCooldown or 0) then
                    local X, X, X, w = Remotes.CommF_:InvokeServer("Bones", "Check")
                    if tonumber(X or 1) == 0 then
                        local X = Split(w, ":")
                        local w = ((tonumber(X[1]) * 60) + tonumber(X[2])) * 60
                        BonesCooldown = os.time() + w
                    else
                        Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                    end
                end
            end
        end

        -- ═══ h == 2: level 10–69 → farm Shanda @ Upper Skylands ═══════
        -- Tương đương nhánh `levelData == 2` của message(10).txt
        -- Teleport("sky 3") → TweenController.Create Upper Skylands
        if h == 2 then
            if SeaIndex == 1 then
                local loc = LocalPlayer:GetAttribute("CurrentLocation")
                if not loc or (loc ~= "Skylands" and loc ~= "Upper Skylands") then
                    -- [FIXED] Bỏ requestEntrance, chỉ dùng tween
                    TweenController.Create(CFrame.new(-7894, 5547, -380))
                    task.wait(1)
                    return
                end
            end
            SetTask("MainTask", "Level Farm | Shanda | Upper Skylands")

            local foundMob = false
            for _, folder in ipairs({workspace.Enemies, game.ReplicatedStorage}) do
                for _, v2 in ipairs(folder:GetChildren()) do
                    if v2.Name == "Shanda" and v2:IsA("Model") then
                        local hum = v2:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            foundMob = true
                            SetTask("SubTask", "⚔️ Attacking Shanda")
                            CombatController.Attack("Shanda")
                            break
                        end
                    end
                end
                if foundMob then break end
            end
            if not foundMob then
                local spawnFolder = game.ReplicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
                local n = spawnFolder and spawnFolder:FindFirstChild("Shanda")
                if n then
                    TweenController.Create(n:GetPivot() + Vector3.new(0, 25, 0))
                else
                    TweenController.Create(CFrame.new(-7783, 5576, -519))
                end
            end

        -- ═══ h == 3: level 70–119 → farm God's Guard @ Skylands ══════
        -- Tương đương nhánh `levelData == 3` của message(10).txt
        -- Teleport("sky 2") → TweenController.Create Skylands
        elseif h == 3 then
            if SeaIndex == 1 then
                local loc = LocalPlayer:GetAttribute("CurrentLocation")
                if not loc or (loc ~= "Skylands" and loc ~= "Upper Skylands") then
                    -- [FIXED] Bỏ requestEntrance, chỉ dùng tween
                    TweenController.Create(CFrame.new(-4650, 872, -1775))
                    task.wait(1.5)
                    return
                end
            end
            SetTask("MainTask", "Level Farm | God's Guard | Skylands")

            local foundMob = false
            for _, folder in ipairs({workspace.Enemies, game.ReplicatedStorage}) do
                for _, v2 in ipairs(folder:GetChildren()) do
                    if v2.Name == "God's Guard" and v2:IsA("Model") then
                        local hum = v2:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            foundMob = true
                            SetTask("SubTask", "⚔️ Attacking God's Guard")
                            CombatController.Attack("God's Guard")
                            break
                        end
                    end
                end
                if foundMob then break end
            end
            if not foundMob then
                local spawnFolder = game.ReplicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
                local n = spawnFolder and spawnFolder:FindFirstChild("God's Guard")
                if n then
                    TweenController.Create(n:GetPivot() + Vector3.new(0, 25, 0))
                end
            end

        -- ═══ h == 4 / h == 1: farm chung qua ManualLevelLookup ════════
        else
            local Q = ManualLevelLookup()
            if not Q then
                Report("LevelFarm: ManualLevelLookup không tìm được mốc (lv="
                    .. tostring(currentLevel) .. ", sea=" .. tostring(SeaIndex) .. ")")
                return
            end
            SetTask("SubTask", "📋 " .. Q.NameMon .. " | Quest: " .. Q.Mon)

            local activeQuestName = GetActiveQuestName()
            if activeQuestName ~= nil then
                if activeQuestName ~= false then
                    if activeQuestName ~= Q.Qname then return J.AbandonQuest() end
                else
                    if not Q.PosQ then return end
                    TweenController.Create(Q.PosQ + Vector3.new(0, 5, 3))
                    SetTask("MainTask", "Level Farm | " .. Q.Mon .. " | Nhận Quest")
                    if CaculateDistance(Q.PosQ) > 10 then return end
                    task.wait(0.5)
                    LevelFarmTTL = 0
                    J.StartQuest(Q.Qname, Q.Qdata)
                    task.wait(0.3)
                end
            else
                CurrentClaimQuest1 = GetCurrentClaimQuest()
                if CurrentClaimQuest1 then
                    if CurrentClaimQuest1 ~= Q.NameMon and CurrentClaimQuest1 ~= (Q.NameMon .. "s") then
                        return J.AbandonQuest()
                    end
                else
                    if not Q.PosQ then return end
                    TweenController.Create(Q.PosQ + Vector3.new(0, 5, 3))
                    SetTask("MainTask", "Level Farm | " .. Q.Mon .. " | Nhận Quest")
                    if CaculateDistance(Q.PosQ) > 10 then return end
                    task.wait(0.5)
                    LevelFarmTTL = 0
                    J.StartQuest(Q.Qname, Q.Qdata)
                    task.wait(0.3)
                end
            end
            -- CombatController.Attack tự làm: tìm quái + tween + đánh
            -- (thay thế bringMob + equipWeapon + FastAttack + CheckMonster)
            -- [FIX] Se ficar sem missão enquanto mata NPCs, para o ataque e volta a pegar a missão.
            -- Só aborta se não houver missão nem no evento QuestUpdate nem no GUI por mais de 1.5s.
            SetTask("MainTask", "Level Farm | " .. Q.Mon .. " | Farming")
            local noQuestSince = nil
            CombatController.ShouldAbort = function()
                local guiQuest = false
                pcall(function() guiQuest = LocalPlayer.PlayerGui.Main.Quest.Visible end)
                local ev = GetActiveQuestName()
                if guiQuest or (ev ~= nil and ev ~= false) then
                    noQuestSince = nil
                    return false
                end
                noQuestSince = noQuestSince or os.clock()
                return (os.clock() - noQuestSince) > 1.5
            end
            local okAtk, errAtk = pcall(CombatController.Attack, Q.Mon)
            CombatController.ShouldAbort = nil -- limpa sempre, para não afetar bosses/outras tarefas
            if not okAtk then error(errAtk, 0) end
        end
    end)

    -- ============================================================
    -- EQUIP WEAPON (TỪ TEST.TXT - ĐÃ CÓ SẴN TRONG CombatController.Attack)
    -- ============================================================
    FunctionsHandler.LocalPlayerController:RegisterMethod("EquipTool", function(h)
        if not Humanoid then return end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return end
        for X, X in bp:GetChildren() do
            if X:IsA('Tool') and X.Name ~= "Tool" and (X.Name == tostring(h) or X.ToolTip == h) then
                LocalPlayer.Character:WaitForChild('Humanoid'):EquipTool(X)
            end
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ToggleAbilities', function(h, X)
        if h == 'Buso' then
            if LocalPlayer:HasTag('Buso') and not X or X then Remotes.CommF_:InvokeServer('Buso') end
        elseif h == "Observation" then
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ConfigurationAbilitiesToggle', function()
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Buso', SCRIPT_CONFIG.BUSO)
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Observation', SCRIPT_CONFIG.OBSERVATION)
    end)
    print(3)

    -- ============================================================
    -- SABER QUEST - HOÀN CHỈNH
    -- ============================================================
    FunctionsHandler.Saber:RegisterMethod('Refresh', function()
        if not Config.Items.Saber then return end
        if ScriptStorage.Backpack.Saber then return end
        if ScriptStorage.PlayerData.Level < 200 then return end
        -- [FIX] agora o Saber é verificado em todos os ciclos: só pergunta ao servidor a cada 5s
        -- (ou logo que o evento RefreshQuestPro avisar que o progresso mudou)
        local lastRef = FunctionsHandler.Saber:Get('LastestRefreshSenque')
        if not SaberForceRefresh and lastRef and os.time() - lastRef < 5 then
            return FunctionsHandler.Saber:Get("CurrentProgressLevel")
        end
        SaberForceRefresh = false
        local X = Remotes.CommF_:InvokeServer('ProQuestProgress')
        local h
        for w, w in X.Plates do if w == false then h = 1 end end
        if not h then
            if not X.UsedTorch then h = 2
            elseif not X.UsedCup then h = 3
            elseif not X.TalkedSon then h = 4
            elseif not X.KilledMob then h = 5
            elseif not X.UsedRelic then h = 6
            elseif not X.KilledShanks then h = 7 end
        end
        FunctionsHandler.Saber:Set("CurrentProgressLevel", h)
        FunctionsHandler.Saber:Set('LastestRefreshSenque', os.time())
        return h
    end)

    FunctionsHandler.Saber:RegisterMethod('GetQuestplates', function()
        local h = FunctionsHandler.Saber:Get("QuestplatesCache")
        if h then return h end
        local h = Services.Workspace.Map.Jungle
        local X = {}
        table.foreach(h.QuestPlates:GetChildren(), function(h, w) h = w:FindFirstChild("Button") and table.insert(X, w) end)
        FunctionsHandler.Saber:Set('QuestplatesCache', X)
        return X
    end)

    FunctionsHandler.Saber:RegisterMethod('Start', function()
        local h, X = FunctionsHandler.Saber:Get("CurrentProgressLevel"), FunctionsHandler.Saber:Get('LastestRefreshSenque')
        if not h then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        elseif h == 0 then
        elseif os.time() - X > 60 then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        else
            if h == 1 then
                local X = FunctionsHandler.Saber.Methods.GetQuestplates:Call()
                for w, D in X do
                    SetTask('MainTask', "Saber Quest | Quest Plates | Touching " .. w .. "/5")
                    while CaculateDistance(D.Button.CFrame) > 20 do
                        task.wait()
                        TweenController.Create(D.Button.CFrame)
                    end
                    task.wait(1)
                end
            elseif h == 2 then
                SetTask('MainTask', 'Saber Quest | Torch Puzzle | Using Torch')
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'GetTorch')
                task.wait(1)
                Remotes.CommF_:InvokeServer('ProQuestProgress', "DestroyTorch")
            elseif h == 3 then
                SetTask('MainTask', "Saber Quest | Sick Man | Helping with Cup")
                Remotes.CommF_:InvokeServer('ProQuestProgress', "GetCup")
                if ScriptStorage.Tools.Cup then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Cup')
                    task.wait(1)
                    Remotes.CommF_:InvokeServer("ProQuestProgress", 'FillCup', LocalPlayer.Character.Cup)
                end
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'SickMan')
            elseif h == 4 then
                SetTask('MainTask', 'Saber Quest | Rich Son | Getting Information')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
            elseif h == 5 then
                SetTask("MainTask", "Saber Quest | Mob Leader | Defeating Boss")
                CombatController.Attack('Mob Leader')
            elseif h == 6 then
                SetTask("MainTask", 'Saber Quest | Relic | Placing at Location')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
                Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
            elseif h == 7 then
                SetTask('MainTask', "Saber Quest | Saber Expert | Final Battle")
                CombatController.Attack("Saber Expert")
            end
        end
    end)
    Remotes.RefreshQuestPro.OnClientEvent:Connect(function(...)
        SaberForceRefresh = true
        return FunctionsHandler.Saber.Methods.Refresh.Callback(...)
    end)

    -- ============================================================
    -- SECOND SEA PUZZLE (DRESSROSA)
    -- ============================================================
    FunctionsHandler.SecondSeaPuzzle:RegisterMethod('Refresh', function()
        if ScriptStorage.PlayerData.Level < 700 or SeaIndex ~= 1 then return end
        if FunctionsHandler.SecondSeaPuzzle:Get('IsCompleted') then return end
        local k = Remotes.CommF_:InvokeServer('DressrosaQuestProgress')
        if not k.TalkedDetective then Result = 1
        elseif not k.KilledIceBoss then Result = 2
        else FunctionsHandler.SecondSeaPuzzle:Set("IsCompleted", true) end
        FunctionsHandler.SecondSeaPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.SecondSeaPuzzle:Set('LastestRefreshSenque', os.time())
        return Result
    end)

    FunctionsHandler.SecondSeaPuzzle:RegisterMethod("Start", function()
        local k, h = FunctionsHandler.SecondSeaPuzzle:Get('CurrentProgressLevel'), FunctionsHandler.SecondSeaPuzzle:Get('LastestRefreshSenque')
        FunctionsHandler.SecondSeaPuzzle:Set('CurrentProgressLevel', nil)
        if not k then
            FunctionsHandler.SecondSeaPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.SecondSeaPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask('SubTask', '🧩 Sea2: Talk to Detective')
            SetTask('MainTask', "Auto Second Sea - Talk To Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
        elseif k == 2 then
            SetTask('SubTask', '🧩 Sea2: Defeat Ice Admiral')
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
            SetTask("MainTask", "Auto Second Sea - Defeating Ice Admiral")
            CombatController.Attack("Ice Admiral")
            Remotes.CommF_:InvokeServer('TravelDressrosa')
        end
    end)

    -- ============================================================
    -- COLOSSEUM PUZZLE (BARTILO)
    -- ============================================================
    FunctionsHandler.ColosseumPuzzle:RegisterMethod("Refresh", function()
        if SeaIndex ~= 2 then return end
        if ScriptStorage.PlayerData.Level < 850 or ScriptStorage.Backpack['Warrior Helmet'] then return end
        local k = Remotes.CommF_:InvokeServer("BartiloQuestProgress")
        if not k.KilledBandits then Result = 1
        elseif not k.KilledSpring then
            if ScriptStorage.Enemies.Jeremy then Result = 2 end
        elseif not k.DidPlates then Result = 3 end
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.ColosseumPuzzle:Set("LastestRefreshSenque", os.time())
        return Result
    end)

    FunctionsHandler.ColosseumPuzzle:RegisterMethod('Start', function()
        local k, h = FunctionsHandler.ColosseumPuzzle:Get("CurrentProgressLevel"), FunctionsHandler.ColosseumPuzzle:Get("LastestRefreshSenque")
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", nil)
        if not k then
            FunctionsHandler.ColosseumPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.ColosseumPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask("MainTask", 'Auto Bartilo Quest - Defeating 50x Swan Pirate')
            local h, X = J:GetCurrentClaimQuest()
            if h then
                if not string.find(X, '50') then J.AbandonQuest()
                else CombatController.Attack("Swan Pirate") end
            else
                J.StartQuest('BartiloQuest', 1)
            end
        elseif k == 2 then
            SetTask('MainTask', "Auto Bartilo Quest - Defeating Jeremy")
            CombatController.Attack("Jeremy")
        elseif k == 3 then
            SetTask("MainTask", 'Auto Bartilo Quest - Doing Puzzle')
            if CaculateDistance(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566)) > 10 then
                alert("tween to")
                TweenController.Create(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566))
            else
                LocalPlayer = game.Players.LocalPlayer
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836.0, 11, 1714)
                alert("1")
                task.wait(.5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                alert('2')
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.87305, 19.3777466, 1712.01807)
                alert("3")
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(1)
                alert("4")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(1)
                alert('5')
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(1)
                alert("6")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(1)
                alert("7")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(1)
                alert("8")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1813.51843, 14.8604736, 1724.79541)
            end
        end
    end)

    -- ============================================================
    -- EVOLUTION RACE (RACE V2)
    -- ============================================================
    FunctionsHandler.EvoRace:RegisterMethod("Refresh", function()
        if not Config.Items.RaceV2 then return end
        if SeaIndex ~= 2 then return end
        if getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost ~= 0 or ScriptStorage.PlayerData.Level < 900 or ScriptStorage.PlayerData.Beli < 1000000 or ScriptStorage.PlayerData.RaceLevel ~= 1 then return end
        return true
    end)

    FunctionsHandler.EvoRace:RegisterMethod('Start', function()
        Remotes.CommF_:InvokeServer('Alchemist', "1")
        Remotes.CommF_:InvokeServer('Alchemist', '2')
        for k = 1, 2, 1 do
            SetTask('SubTask', '🌈 Collecting Flower ' .. k .. ' for Race V2')
            local h = ScriptStorage.Tools["Flower " .. k]
            local X = Services.Workspace:FindFirstChild('Flower' .. k)
            if not h then
                if X and X.Transparency == 0 then
                    SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. k)
                    while not ScriptStorage.Tools["Flower " .. k] do
                        task.wait()
                        TweenController.Create(X.CFrame + Vector3.new(0, math.random(-1.0, 2), 0))
                    end
                end
            end
        end
        if not ScriptStorage.Tools['Flower 3'] then
            SetTask('SubTask', '🌈 Farming Swan Pirate for Flower 3')
            SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. 3)
            CombatController.Attack('Swan Pirate')
        else
            SetTask('SubTask', '🌈 Race V2 completed, idling...')
            SetTask("MainTask", 'Auto Race V2 - Idling')
            if LocalPlayer.Character.HumanoidRootPart.CFrame.Y < 50000 then
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0))
            end
            Remotes.CommF_:InvokeServer("Alchemist", "3")
            RefreshRace()
        end
    end)

    -- ============================================================
    -- [REBUILT] RACE AWAKENING (= "Race V3") — bị mất sạch RegisterMethod
    -- trong 1 lượt sửa lớn trước đó (chỉ còn :Register() trơ), audit lại
    -- toàn bộ file mới phát hiện. Xây lại từ data verified NatAov +
    -- raw_6.txt + message_10.txt (nguồn MỚI NHẤT, verified nhất).
    -- [FIXED - theo message_10] Thứ tự boss Human THẬT là Jeremy → Diamond
    -- → Orbitus — bản trước tao để SAI thành Orbitus→Jeremy→Diamond. Có cả
    -- toạ độ chờ thật cho từng bước. Dùng Wenlocktoad("1") LÀM STATE DRIVER
    -- (đọc từ server mỗi lần) thay vì cờ nội bộ `_raceAwakenState.started`
    -- dễ bị lệch nếu script restart giữa chừng.
    -- [NEW - theo message_10] Thêm race Mink ("Rabbit" trong Race.Value):
    -- farm 30 cái workspace.ChestModels rồi claim — hoàn toàn không có
    -- trước đây.
    -- Race Fishman: GIỮ NGUYÊN y hệt bản cũ theo đúng yêu cầu ("trừ tộc cá
    -- fishman") — không đụng vào đoạn Sea Beast/skill hotbar bên dưới.
    -- ============================================================
    local _raceAwakenState = {
        humanStage = 0,  -- 0=Jeremy, 1=Diamond, 2=Orbitus, 3=claim
        minkChestsDone = 0,
    }
    local HUMAN_V3_WAIT_CF = {
        [0] = CFrame.new(2333.209228515625, 449.2427062988281, 699.5128784179688),   -- chờ Jeremy
        [1] = CFrame.new(-1713.5589599609375, 198.99554443359375, -104.31584167480469), -- chờ Diamond
        [2] = CFrame.new(-2148.7568359375, 73.27831268310547, -4304.4130859375),     -- chờ Orbitus
    }
    local HUMAN_V3_BOSS_NAME = {[0] = "Jeremy", [1] = "Diamond", [2] = "Orbitus"}

    local function _fightWorldBossV3(bossName, waitCF)
        local live = ScriptStorage.Enemies[bossName]
        if not live then
            SetTask("SubTask", "Race Awakening | Chờ " .. bossName .. " — di chuyển tới điểm hẹn")
            if waitCF then TweenController.Create(waitCF) end
            return false
        end
        local hum = live:FindFirstChildOfClass("Humanoid")
        local hrp = live:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            SetTask("MainTask", "Race Awakening | Fighting " .. bossName)
            TweenController.Create(hrp.CFrame + Vector3.new(0, 30, 0))
            if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                pcall(function() Remotes.CommF_:InvokeServer("Buso") end)
            end
            CombatController.Attack(bossName)
            return false
        end
        return true -- dead
    end

    FunctionsHandler.RaceAwakening:RegisterMethod("Refresh", function()
        if not Config.Items.AutoRaceV3 then return nil end
        local data = LocalPlayer:FindFirstChild("Data")
        if not data or not data:FindFirstChild("Race") then return nil end
        if data.Race:FindFirstChild("Evolved") then return nil end -- đã Awaken rồi
        local raceVal = data.Race.Value
        if raceVal ~= "Human" and raceVal ~= "Fishman" and raceVal ~= "Rabbit" then return nil end
        if (ScriptStorage.PlayerData.Level or 0) < 1400 then return nil end
        if (ScriptStorage.PlayerData.Beli or 0) < 2000000 then return nil end
        local wOk = pcall(function() return Remotes.CommF_:InvokeServer("Wenlocktoad", "3") end)
        local wResult = wOk and Remotes.CommF_:InvokeServer("Wenlocktoad", "3") or nil
        if wResult == -2 then return nil end
        local tOk, tResult = pcall(function() return Remotes.CommF_:InvokeServer("TalkTrevor", "1") end)
        if not tOk or tResult ~= 0 then return nil end
        return true
    end)

    FunctionsHandler.RaceAwakening:RegisterMethod("Start", function()
        local data = LocalPlayer:FindFirstChild("Data")
        if not data or not data:FindFirstChild("Race") then return end
        local race = data.Race.Value

        -- [FIXED] Dùng Wenlocktoad("1") làm state driver thật, đọc lại mỗi
        -- lần thay vì tin cờ nội bộ — khớp state-machine verified message_10
        local check = Remotes.CommF_:InvokeServer("Wenlocktoad", "1")

        if check == 0 then
            SetTask("MainTask", "Race Awakening | Bắt đầu quest (Wenlocktoad)")
            Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
            return
        elseif check == 2 then
            SetTask("MainTask", "Race Awakening | Đủ điều kiện — claim!")
            Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
            return
        elseif check ~= 1 then
            return -- giá trị lạ, chờ vòng sau
        end

        -- check == 1: đang trong giai đoạn đánh boss/farm theo race
        if race == "Human" then
            local stage = _raceAwakenState.humanStage
            if stage >= 3 then
                SetTask("MainTask", "Race Awakening | Hoàn thành 3 boss — claim!")
                Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                _raceAwakenState.humanStage = 0
                return
            end
            local bossName = HUMAN_V3_BOSS_NAME[stage]
            SetTask("SubTask", "Race Awakening | " .. (stage + 1) .. "/3 " .. bossName)
            if _fightWorldBossV3(bossName, HUMAN_V3_WAIT_CF[stage]) then
                _raceAwakenState.humanStage = stage + 1
            end

        elseif race == "Rabbit" then
            -- [NEW - Mink] Farm 30 ChestModels rồi claim
            local chestFolder = workspace:FindFirstChild("ChestModels")
            if not chestFolder then
                SetTask("SubTask", "Race Awakening | Mink: không tìm thấy ChestModels")
                return
            end
            if _raceAwakenState.minkChestsDone >= 30 then
                SetTask("MainTask", "Race Awakening | Mink: đủ 30 rương — claim!")
                Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                return
            end
            local chests = chestFolder:GetChildren()
            local idx = _raceAwakenState.minkChestsDone + 1
            local chest = chests[idx]
            if chest and chest:FindFirstChild("WorldPivot") then
                SetTask("MainTask", "Race Awakening | Mink: rương " .. idx .. "/30")
                TweenController.Create(chest.WorldPivot.Position)
                if CaculateDistance(chest.WorldPivot.Position) < 10 then
                    _raceAwakenState.minkChestsDone = _raceAwakenState.minkChestsDone + 1
                end
            else
                SetTask("SubTask", "Race Awakening | Mink: hết rương khả dụng (" .. #chests .. " tổng)")
            end

        elseif race == "Fishman" then
            -- (GIỮ NGUYÊN không đổi — theo đúng yêu cầu loại trừ Fishman)
            SetTask("MainTask", "Race Awakening | Fishman: farm Sea Beast")
            local seaBeasts = Services.Workspace:FindFirstChild("SeaBeasts")
            if not seaBeasts then
                SetTask("SubTask", "⚠️ Không tìm thấy workspace.SeaBeasts — hop thử")
                Hop()
                return
            end
            pcall(function() Remotes.CommF_:InvokeServer("BuyFishmanKarate") end)
            local target = nil
            for _, beast in pairs(seaBeasts:GetChildren()) do
                local h = beast:FindFirstChild("Health")
                local hrp = beast:FindFirstChild("HumanoidRootPart")
                if h and hrp and h.Value > 0 then target = beast break end
            end
            if not target then
                SetTask("SubTask", "Fishman | Chưa thấy Sea Beast, đợi spawn...")
                task.wait(3)
                return
            end
            TweenController.Create(target.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
            if CaculateDistance(target.HumanoidRootPart.CFrame) < 15 then
                pcall(function()
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fishman Karate")
                end)
                SetTask("SubTask", "Fishman | Đang đánh Sea Beast (skill Z/X/C)")
                pcall(function()
                    Services.VirtualInputManager:SendKeyEvent(true, "Z", false, game)
                    task.wait(0.3)
                    Services.VirtualInputManager:SendKeyEvent(false, "Z", false, game)
                end)
            end
        end
    end)

    -- ============================================================
    -- BOSSES TASK
    -- ============================================================
    -- ============================================================
    -- [FIXED] Xác nhận boss chết THẬT — tránh false-positive lúc chuyển
    -- phase (bug boss man báo: đánh "Hải Tặc Đào Hoa" [Cake Prince] qua
    -- phase 2, Parent/Humanoid tạm biến mất trong animation chuyển phase,
    -- code cũ tưởng chết → reset nhầm, bỏ dở boss đang đánh dở).
    -- Giờ: mất dấu / Health<=0 → CHỜ xác nhận liên tục 3 giây, nếu tên đó
    -- xuất hiện sống lại (phase mới) trong lúc chờ thì huỷ reset, đánh tiếp.
    -- ============================================================
    local function ConfirmBossDead(bossName)
        -- [FIXED - bớt delay theo yêu cầu boss man] 3×1s (3.0s tổng) →
        -- 6×0.3s (1.8s tổng). KHÔNG rút bằng cách giảm số lần check xuống —
        -- làm vậy sẽ yếu lại đúng cái bug false-positive từng fix. Thay vào
        -- đó tăng gấp đôi số lần poll (3→6) trong khi tổng thời gian NGẮN
        -- hơn 40% — vừa nhanh hơn vừa bắt "sống lại giữa chừng" nhạy hơn.
        for _ = 1, 6 do
            task.wait(0.3)
            local stillThere = ScriptStorage.Enemies[bossName]
            if stillThere and stillThere:FindFirstChild("Humanoid") and stillThere.Humanoid.Health > 0 then
                return false -- sống lại (chuyển phase) — KHÔNG phải chết thật
            end
        end
        return true -- 1.8s liên tục không thấy sống lại — chắc chắn chết
    end

    FunctionsHandler.BossesTask:RegisterMethod("Refresh", function()
        local k
        for h, h in BossesOrder do
            -- [FIXED] Thêm gate Config.BossWeapons — trước đây không có cách
            -- nào tắt farm 1 boss cụ thể, giờ set Config.BossWeapons[name]=false là bỏ qua
            if Config.BossWeapons[h] ~= false then
                local X = BossesOrderLevel[h]
                if ScriptStorage.PlayerData.Level >= X then
                    local X = ScriptStorage.Enemies[h]
                    if X and X:FindFirstChild("Humanoid") and X.Humanoid.Health > 0 then k = X end
                end
            end
        end
        if k and (CaculateDistance(k.HumanoidRootPart.CFrame) < (SeaIndex == 2 and 3000 or 5000) or BossesOrderWL[tostring(k)] or ScriptStorage.PlayerData.Level == MaxLevel) then
            return k
        end
    end)

    FunctionsHandler.BossesTask:RegisterMethod('Start', function(k)
        if k then
            SetTask("MainTask", "Auto Farm Boss - Defeating " .. k.Name)
            SetTask('SubTask', '👑 Boss: ' .. k.Name .. ' | HP: ' .. math.floor(k.Humanoid.Health / k.Humanoid.MaxHealth * 100) .. '%')
            CombatController.Attack(tostring(k), null, null, function() SpecialItems = nil end)
            SpecialItems = nil

            -- Não fazer reset/respawn depois de derrotar um boss.
            -- Confirmar a morte apenas para atualizar o estado e deixar o ciclo normal continuar.
            pcall(function()
                if k.Parent == nil or (k:FindFirstChild("Humanoid") and k.Humanoid.Health <= 0) then
                    if ConfirmBossDead(k.Name) then
                        SetTask('SubTask', '✅ Boss derrotado: ' .. k.Name .. ' — a continuar sem reset')
                    else
                        SetTask('SubTask', k.Name .. ' está a mudar de fase — continuar a lutar')
                    end
                end
            end)
        end
    end)

    -- ============================================================
    -- SPECIAL BOSSES TASK
    -- ============================================================
    FunctionsHandler.SpecialBossesTask:RegisterMethod('Refresh', function()
        local k
        for h, X in SpecialBossesOrder do
            -- [FIXED] Cùng gate Config.BossWeapons như BossesTask
            if Config.BossWeapons[h] ~= false and ScriptStorage.PlayerData.Level >= X then
                local X = ScriptStorage.Enemies[h]
                if X and X:FindFirstChild('Humanoid') and X.Humanoid.Health > 0 then k = X end
            end
        end
        -- [ADDED] Không thấy boss nào lên → farm Bones nhẹ nhàng ở nền
        -- (fire-and-forget, KHÔNG return true nên LevelFarm vẫn chạy bình
        -- thường) — Bones là nguyên liệu Fire Essence (Dragon Talon) VÀ
        -- theo nat kaitun cũng liên quan tới tỉ lệ Soul Reaper xuất hiện
        if not k then
            pcall(function()
                local bonesCheck = Remotes.CommF_:InvokeServer("Bones", "Check")
                if bonesCheck and bonesCheck > 0 then
                    Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                end
            end)
        end
        return k
    end)

    FunctionsHandler.SpecialBossesTask:RegisterMethod('Start', function(k)
        if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
            pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
        end
        if k then
            SetTask('MainTask', "Auto Farm Boss - Defeating " .. k.Name)
            SetTask('SubTask', '👾 Special Boss: ' .. k.Name)
            CombatController.Attack(tostring(k))

            -- Não fazer reset/respawn depois de derrotar um boss especial.
            pcall(function()
                if k.Parent == nil or (k:FindFirstChild("Humanoid") and k.Humanoid.Health <= 0) then
                    if ConfirmBossDead(k.Name) then
                        SetTask('SubTask', '✅ Boss especial derrotado: ' .. k.Name .. ' — sem reset')
                    else
                        SetTask('SubTask', k.Name .. ' está a mudar de fase — continuar a lutar')
                    end
                end
            end)
        end
    end)

    -- ============================================================
    -- RAID CONTROLLER
    -- ============================================================
    -- ============================================================
    -- [NEW] getInventoryFruits — đọc trực tiếp ItemConfig/FruitInfo,
    -- không qua remote round-trip, có sẵn Rarity để lọc
    -- ============================================================
    local function getInventoryFruits()
        local fruits = {}
        local inventory = require(ReplicatedStorage.ItemConfig):GetItems(ReplicatedStorage.ItemConfig.KEYS.QUANTITY)
        for _, item in pairs(inventory) do
            if item.Value and item.Value > 0 then
                local _, data = pcall(function()
                    return ReplicatedStorage.FruitInfo.List[item.ItemId]
                end)
                if data then
                    local name = data.Display.Name or item.ItemId
                    local rarity = data.Rarity and data.Rarity.Name or "Unknown"
                    local value = data.Price or 0
                    table.insert(fruits, {Name = name, Rarity = rarity, Value = value})
                end
            end
        end
        return fruits
    end

    -- [NEW] Chọn trái để bán/dùng mua chip: ưu tiên Common/Uncommon + giá
    -- thấp nhất; nếu không có trái Common/Uncommon nào thì lấy trái rẻ
    -- nhất trong kho bất kể rarity
    local function PickFruitToSpend()
        local ok, fruits = pcall(getInventoryFruits)
        if not ok or not fruits or #fruits == 0 then return nil end

        local commonUncommon = {}
        for _, f in ipairs(fruits) do
            if f.Rarity == "Common" or f.Rarity == "Uncommon" then
                table.insert(commonUncommon, f)
            end
        end

        local pool = #commonUncommon > 0 and commonUncommon or fruits
        table.sort(pool, function(a, b) return (a.Value or 0) < (b.Value or 0) end)
        return pool[1]
    end

    -- ============================================================
    -- ============================================================
    -- [NEW] SWORD BOSS TASK — farm boss lấy sword, 100% verified từ
    -- file_kaitun_dự_phòng.lua (Configs["Sword"] + CheckBoss + "gi" check)
    -- Có sẵn check inventory: đã có sword đó rồi thì bỏ qua, không đánh nữa
    -- ============================================================
    local SwordBossList = {
        {sword = "Shark Saw",       boss = "The Saw",              sea = 1, level = 100},
        {sword = "Wardens Sword",   boss = "Chief Warden",         sea = 1, level = 100},
        {sword = "Pole (1st Form)", boss = "Thunder God",          sea = 1, level = 100},
        {sword = "Gravity Blade",   boss = "Orbitus",               sea = 2, level = 800},
        {sword = "Longsword",       boss = "Diamond",               sea = 2, level = 800},
        {sword = "Rengoku",         boss = "Awakened Ice Admiral",  sea = 2, level = 800},
        {sword = "Flail",           boss = "Smoke Admiral",         sea = 2, level = 0},
        {sword = "Twin Hooks",      boss = "Captain Elephant",      sea = 3, level = 0},
    }
    -- Toạ độ dùng Hidden Key / Library Key mở khoá Rengoku (verified)
    local HIDDEN_KEY_CF  = CFrame.new(6572.29248, 295.712677, -6966.09961)
    local LIBRARY_KEY_CF = CFrame.new(6377.12549, 296.634735, -6843.76025)

    FunctionsHandler.SwordBossTask:RegisterMethod("Refresh", function()
        for _, sw in ipairs(SwordBossList) do
            -- [NEW] Check inventory liên tục — có sword rồi thì bỏ qua
            -- (đúng yêu cầu boss man: "check inventory ... nếu có ko đánh nữa")
            if Config.Sword[sw.sword] and not CheckItem(sw.sword)
                and SeaIndex == sw.sea and (ScriptStorage.PlayerData.Level or 0) >= sw.level then
                local boss = ScriptStorage.Enemies[sw.boss]
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    return sw
                end
            end
        end
        -- Riêng Rengoku: có thêm 2 đường phụ qua Hidden Key / Library Key
        -- (không cần boss đang sống, chỉ cần đang cầm chìa + ở Sea 2)
        if Config.Sword["Rengoku"] and not CheckItem("Rengoku") and SeaIndex == 2 then
            if CheckItem("Hidden Key") or CheckItem("Library Key") then
                return {sword = "Rengoku", useKey = true}
            end
        end
        return nil
    end)

    FunctionsHandler.SwordBossTask:RegisterMethod("Start", function(sw)
        if not sw then return end

        if sw.useKey then
            local keyName = CheckItem("Hidden Key") and "Hidden Key" or "Library Key"
            local cf = keyName == "Hidden Key" and HIDDEN_KEY_CF or LIBRARY_KEY_CF
            SetTask("MainTask", "Sword Boss | Dùng " .. keyName .. " mở Rengoku")
            TweenController.Create(cf)
            if CaculateDistance(cf) <= 5 then
                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(keyName)
            end
            return
        end

        local boss = ScriptStorage.Enemies[sw.boss]
        if not boss then return end

        SetTask("MainTask", "Sword Boss | Đánh " .. sw.boss .. " lấy " .. sw.sword)
        if boss:FindFirstChild("HumanoidRootPart") then
            TweenController.Create(boss.HumanoidRootPart.CFrame + Vector3.new(0, 30, 0))
        end
        CombatController.Attack(sw.boss)

        -- Não fazer reset/respawn depois de derrotar o boss da tarefa.
        pcall(function()
            if boss.Parent == nil or (boss:FindFirstChild("Humanoid") and boss.Humanoid.Health <= 0) then
                if ConfirmBossDead(sw.boss) then
                    SetTask('SubTask', '✅ Boss derrotado: ' .. sw.boss .. ' — sem reset')
                else
                    SetTask('SubTask', sw.boss .. ' está a mudar de fase — continuar a lutar')
                end
            end
        end)
    end)


    -- Cake Prince [Lv. 2300] [Raid Boss] (Sea 3, đảo CakeLoaf)
    -- [FIXED - theo spec mới] TRƯỚC ĐÂY dùng để farm Fragment (gate bởi
    -- Fragments > 5000) — spec mới yêu cầu XOÁ HẲN mục đích đó, "chỉ dùng
    -- raid để lấy Fragment". Cake Prince giờ CHỈ dùng để farm MASTERY cho
    -- melee đang tập (V1 cần 500, V2 cần 400) — giết Cake Prince với vũ
    -- khí đang tập cho mastery tăng nhanh hơn quái thường.
    -- ============================================================
    local CAKE_AREA_CF   = CFrame.new(-2077, 252, -12373)        -- đảo CakeLoaf nói chung
    local CAKE_BOSS_CF   = CFrame.new(-2151.82, 149.32, -12404.91) -- chỗ Cake Prince xuất hiện
    local CAKE_UNLOCK_MOBS = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}

    -- [NEW] Xác định melee nào đang cần train mastery — dùng chung giữa
    -- CakePrinceTask và MeleesController để đồng bộ (train đúng cái đang
    -- thiếu, theo đúng thứ tự V1 → V2 spec yêu cầu)
    local MASTERY_TRAIN_ORDER = {
        {name = "Black Leg",       target = 500, tier = "V1"},
        {name = "Electro",         target = 500, tier = "V1"},
        {name = "Fishman Karate",  target = 500, tier = "V1"},
        {name = "Dragon Claw",     target = 500, tier = "V1"},
        {name = "Superhuman",      target = 500, tier = "V1"},
        {name = "Death Step",      target = 400, tier = "V2"},
        {name = "Sharkman Karate", target = 400, tier = "V2"},
        {name = "Electric Claw",   target = 400, tier = "V2"},
        {name = "Dragon Talon",    target = 400, tier = "V2"},
    }

    function GetCurrentTrainingMelee()
        for _, m in ipairs(MASTERY_TRAIN_ORDER) do
            if CheckItem(m.name) then
                local mastery = ScriptStorage.Melees[m.name] or 0
                if mastery < m.target then
                    return m.name, mastery, m.target
                end
            end
        end
        return nil
    end

    FunctionsHandler.CakePrinceTask:RegisterMethod("Refresh", function()
        if SeaIndex ~= 3 then return nil end
        if (ScriptStorage.PlayerData.Level or 0) < 1500 then return nil end
        -- [FIXED] Gate bằng "có melee nào đang cần train mastery không",
        -- KHÔNG còn gate bằng Fragments nữa
        local trainingName = GetCurrentTrainingMelee()
        if not trainingName then return nil end
        return trainingName
    end)

    FunctionsHandler.CakePrinceTask:RegisterMethod("Start", function(trainingName)
        if not trainingName then return end
        local mastery, target = ScriptStorage.Melees[trainingName] or 0, nil
        for _, m in ipairs(MASTERY_TRAIN_ORDER) do
            if m.name == trainingName then target = m.target break end
        end

        -- [NEW] Check mastery mỗi vòng — đạt ngưỡng thì dừng farm, để
        -- Refresh() vòng sau tự chuyển qua melee tiếp theo cần train
        if mastery >= (target or 500) then
            SetTask("SubTask", "✅ " .. trainingName .. " đạt " .. mastery .. " mastery — chuyển melee tiếp theo")
            return
        end

        -- [NEW] Trang bị đúng melee đang cần train trước khi đánh, để
        -- damage tính mastery cho ĐÚNG vũ khí
        pcall(function()
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(trainingName)
        end)

        local cakeLoaf  = workspace.Map:FindFirstChild("CakeLoaf")
        local bigMirror = cakeLoaf and cakeLoaf:FindFirstChild("BigMirror")
        local enemies   = workspace.Enemies

        -- Chưa tới đảo Cake → tp tới trước
        if not cakeLoaf then
            SetTask("MainTask", "Cake Mastery | " .. trainingName .. " (" .. mastery .. "/" .. (target or 500) .. ") — di chuyển tới đảo Cake")
            TweenController.Create(CAKE_AREA_CF)
            return
        end

        local mirrorOpen = bigMirror and bigMirror:FindFirstChild("Other") and bigMirror.Other.Transparency == 0
        local bossUp     = enemies:FindFirstChild("Cake Prince")

        if mirrorOpen or bossUp then
            -- Gương đã mở HOẶC boss đã lên → đánh (mastery tăng nhanh)
            local boss = enemies:FindFirstChild("Cake Prince")
            if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                SetTask("MainTask", "Cake Mastery | " .. trainingName .. " (" .. mastery .. "/" .. (target or 500) .. ") | Cake Prince HP " .. math.floor(boss.Humanoid.Health / boss.Humanoid.MaxHealth * 100) .. "%")
                TweenController.Create(boss.HumanoidRootPart.CFrame + Vector3.new(0, 30, 0))
                CombatController.Attack("Cake Prince")

                -- Não fazer reset/respawn depois de derrotar Cake Prince.
                pcall(function()
                    if boss.Parent == nil or boss.Humanoid.Health <= 0 then
                        if ConfirmBossDead("Cake Prince") then
                            SetTask('SubTask', '✅ Cake Prince derrotado — continuar sem reset')
                        else
                            SetTask('SubTask', 'Cake Prince está a mudar de fase — continuar a lutar')
                        end
                    end
                end)
            else
                TweenController.Create(CAKE_BOSS_CF)
            end
            return
        end

        -- Gương chưa mở, boss chưa lên → farm quái thường lấy mastery +
        -- check tiến độ mở khoá (đủ thì tự trigger spawn Cake Prince)
        SetTask("MainTask", "Cake Mastery | " .. trainingName .. " (" .. mastery .. "/" .. (target or 500) .. ") — farm quái thường")
        local killedStr = Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        local killed = killedStr and tonumber(tostring(killedStr):match("%d+")) or 0
        local remaining = math.max(0, 500 - killed)

        if remaining <= 0 then
            SetTask("MainTask", "Cake Mastery | Đủ điều kiện — đang triệu hồi Cake Prince")
            Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
            task.wait(1)
            return
        end

        -- Chưa đủ → farm quái mở khoá
        SetTask("MainTask", "Cake Prince | Farm quái mở khoá — còn " .. remaining .. "/500")
        local mob = nil
        for _, mobName in ipairs(CAKE_UNLOCK_MOBS) do
            local m = enemies:FindFirstChild(mobName)
            if m and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then mob = m break end
        end
        if mob then
            TweenController.Create(mob.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
            CombatController.Attack(CAKE_UNLOCK_MOBS)
        else
            TweenController.Create(CAKE_AREA_CF)
        end
    end)


    FunctionsHandler.RaidController:RegisterMethod("RefreshRaidType", function()
        for k, k in require(game.ReplicatedStorage.Raids).raids do
            if string.find(ScriptStorage.PlayerData.DevilFruit, k) then
                FunctionsHandler.RaidController:Set('CurrentChip', k)
                return
            end
        end
        FunctionsHandler.RaidController:Set('CurrentChip', 'Flame')
    end)

    FunctionsHandler.RaidController:RegisterMethod('GetRaidableFruit', function()
        -- [FIXED] Trước đây lấy trái ĐẦU TIÊN tìm thấy dưới 1tr Beli, không
        -- quan tâm rarity — dễ lỡ tay bán nhầm trái đắt/hiếm nếu nó đứng
        -- trước trong Backpack. Giờ dùng PickFruitToSpend(): ưu tiên
        -- Common/Uncommon + rẻ nhất, fallback rẻ nhất toàn kho nếu không có.
        local picked = PickFruitToSpend()
        if picked then
            for k, k in ScriptStorage.Backpack do
                if k.Name == picked.Name then return k end
            end
        end
        -- fallback về logic cũ nếu getInventoryFruits() lỗi vì lý do gì đó
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value < 1000000 then return k end
            end
        end
    end)

    FunctionsHandler.RaidController:RegisterMethod("GetCurrentRaidIsland", function()
        local IslandsList = {{}, {}, {}, {}, {}}
        for k, k in workspace['_WorldOrigin'].Locations:GetChildren() do
            if string.find(k.Name, 'Island ') and CaculateDistance(k.Position, Vector3.new(0, 0, 0)) > 7000 then
                local h = string.gsub(k.Name, "Island ", "")
                local X = tonumber(h)
                table.insert(IslandsList[X], k)
            end
        end
        for k = 5, 1, -1 do
            for h, h in IslandsList[k] do if CaculateDistance(h.Position) < 2000 then return h end end
        end
        return nil
    end)

    function CheckSpecialMicrochip()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        for _, h in {LocalPlayer.Character:GetChildren(), bp and bp:GetChildren() or {}} do
            for _, X in h do if X.Name == "Special Microchip" then return X end end
        end
        return nil
    end

    FunctionsHandler.RaidController:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        if lv < 1300 then return nil end
        if CheckSpecialMicrochip() then return nil end
        local fr = ScriptStorage.PlayerData.Fragments or 0
        if lv < 1500 and fr > 2000 then return nil end
        if lv < MaxLevel and fr > 5000 then return nil end
        if lv >= MaxLevel and fr > 10000 then return nil end
        local fruit = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
        if fruit then FunctionsHandler.RaidController:Set("CurrentProgressLevel", fruit) end
        return fruit or FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() or CheckSpecialMicrochip()
    end)

    FunctionsHandler.RaidController:RegisterMethod("Start", function()
        if not FunctionsHandler.RaidController:Get('CurrentChip') then FunctionsHandler.RaidController.Methods.RefreshRaidType:Call() end
        local k = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        RefreshInventory()
        FunctionsHandler.RaidController:Set("CurrentProgressLevel", nil)
        if not k then
            SetTask('MainTask', 'Auto Raid - Buying Chip - ' .. FunctionsHandler.RaidController:Get("CurrentChip"))
            if not ScriptStorage.Tools['Special Microchip'] then
                local h = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
                table.insert(ScriptStorage.IgnoreStoreFruits, h.Name)
                alert('Load Fruit', h.Name)
                Remotes.CommF_:InvokeServer('LoadFruit', h.Name)
                Remotes.CommF_:InvokeServer("RaidsNpc", 'Select', FunctionsHandler.RaidController:Get('CurrentChip'))
                task.wait(2)
            end
            local h = ({nil, 'Circle Island', "Boat Castle"})[SeaIndex]
            if not ScriptStorage.Map[h] and not ScriptStorage.Map[h] then
                task.wait(1)
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
            end
            if not ScriptStorage.Map[h]:FindFirstChild('RaidSummon2') then
                task.wait(1)
                TweenController.Create(ScriptStorage.Map[h]:GetModelCFrame() or ScriptStorage.Map[h]:GetModelCFrame())
            end
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Special Microchip')
            fireclickdetector((ScriptStorage.Map[h] or workspace.Map:FindFirstChild(h) or workspace:FindFirstChild(h)).RaidSummon2.Button.Main.ClickDetector)
            local h = os.time()
            SetTask("MainTask", "Auto Raid - Waiting Until Raid Is Started")
            repeat task.wait() until os.time() - (LastRaidAlert2 or 0) < 20 or os.time() - h > 30
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            repeat task.wait() until os.time() - (LastRaidAlert or 0) < 20 or os.time() - h > 30
            alert('cac', "Tween Paused")
            task.wait(.5)
            if os.time() - h > 30 then
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                SetTask('MainTask', "Auto Raid - Raid Is Not Stared?")
                Report('[ Raid Error ] Time Limit Reached')
            end
            LastRaidAlert = 0
        else
            SetTask('MainTask', "Auto Raid - " .. k.Name .. " /5")
            SetTask('SubTask', 'Raid Island ' .. k.Name .. ' | Clearing wave...')
            local islandNum = tonumber(string.match(k.Name, "(%d+)"))
            if islandNum and islandNum >= 4 then
                TweenController.Create(k.Position + Vector3.new(0, 50, 0))
                task.wait(0.5)
                for _, v in workspace.Enemies:GetChildren() do
                    pcall(function()
                        if v:FindFirstChild("Humanoid") then v.Humanoid.Health = 0 end
                        if v:FindFirstChild("HumanoidRootPart") then v.HumanoidRootPart.CanCollide = false end
                        v:BreakJoints()
                    end)
                end
            else
                local h = false
                for X, X in GetMonAsSortedRange() do
                    local w = os.time()
                    while X and X:FindFirstChild("HumanoidRootPart") and X.Humanoid.Health > 0 and CaculateDistance(X.HumanoidRootPart.Position) < 1000 and os.time() - w < 60 and task.wait(.05) do
                        h = true
                        if string.find(X.Name, "Master") or true then
                            CombatController.Attack(X.Name)
                        else
                            pcall(sethiddenproperty, LocalPlayer, 'SimulationRadius', math.huge)
                            pcall(function()
                                X.HumanoidRootPart.CanCollide = false
                                X.Humanoid.Health = 0
                                X:BreakJoints()
                            end)
                        end
                    end
                end
                if not h then TweenController.Create(k.Position + Vector3.new(0, 100, 0)) end
            end
        end
    end)

    -- ============================================================
    -- AUTO RAID ICE
    -- ============================================================
    local RAID_ICE_CHIP_COOLDOWN = 2 * 60 * 60

    -- [NEW] 2 helper lấy từ Moonlight_New_Public_source.lua (chỉ lấy LOGIC,
    -- bỏ hết toggle/UI của nó) — dùng để làm AutoRaidIce đáng tin cậy hơn:
    -- 1. TriggerInteractive: bấm nút raid summon bằng CẢ ProximityPrompt
    --    LẪN ClickDetector (tìm đệ quy) — code cũ chỉ cứng path ClickDetector
    --    1 chỗ, nếu game đổi qua ProximityPrompt thì "Khong tim thay button"
    --    dù nút vẫn ở đó.
    -- 2. RaidTimerActive: check trực tiếp PlayerGui.Main.TopHUDList.RaidTimer
    --    .Visible — biết NGAY raid đã bắt đầu hay chưa, không cần đợi
    --    notification 'go!'/'raid' bắn ra (vẫn giữ 2 cái đó làm dự phòng).
    local function TriggerInteractive(object)
        if not object then return false end
        local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and typeof(fireproximityprompt) == "function" then
            local ok = pcall(fireproximityprompt, prompt)
            if ok then return true end
        end
        local click = object:FindFirstChildWhichIsA("ClickDetector", true)
        if click and typeof(fireclickdetector) == "function" then
            local ok = pcall(fireclickdetector, click)
            if ok then return true end
        end
        return false
    end

    local function RaidTimerActive()
        local ok, result = pcall(function()
            local gui  = LocalPlayer:FindFirstChild("PlayerGui")
            local main = gui and gui:FindFirstChild("Main")
            local top  = main and main:FindFirstChild("TopHUDList")
            local timer = top and top:FindFirstChild("RaidTimer")
            return timer and timer.Visible or false
        end)
        return ok and result or false
    end


    FunctionsHandler.AutoRaidIce:RegisterMethod("GetCheapestFruit", function(maxPrice)
        maxPrice = maxPrice or 1000000
        local ok1, fruitPrices = pcall(function() return Remotes.CommF_:InvokeServer("GetFruits") end)
        local ok2, inventoryFruits = pcall(function() return Remotes.CommF_:InvokeServer("getInventoryFruits") end)
        if not ok1 or not ok2 then return nil end
        local priceMap = {}
        for _, v in pairs(fruitPrices) do
            if v.Price and v.Price <= maxPrice then
                priceMap[v.Name] = v.Price
            end
        end
        local cheapest, lowestPrice = nil, math.huge
        for _, fruitData in pairs(inventoryFruits) do
            local name = fruitData.Name
            if name and priceMap[name] and priceMap[name] < lowestPrice then
                lowestPrice = priceMap[name]
                cheapest = name
            end
        end
        return cheapest, lowestPrice
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("KillAura", function()
        local currentIsland = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        pcall(sethiddenproperty, LocalPlayer, 'SimulationRadius', math.huge)
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            pcall(function()
                if currentIsland then
                    local dist = CaculateDistance(v.HumanoidRootPart.Position, currentIsland.Position)
                    if dist > 1500 then return end
                end
                if v:FindFirstChild("Humanoid") then v.Humanoid.Health = 0 end
                if v:FindFirstChild("HumanoidRootPart") then v.HumanoidRootPart.CanCollide = false end
                v:BreakJoints()
            end)
        end
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("BuyChip", function()
        local lastBuy = Storage:Get("RaidIceLastChipBuy") or 0
        if os.time() - lastBuy < RAID_ICE_CHIP_COOLDOWN then return false end
        local fruitName = FunctionsHandler.AutoRaidIce.Methods.GetCheapestFruit:Call(1000000)
        if fruitName then
            SetTask('MainTask', 'Auto Raid Ice | Mua chip bang trai ' .. fruitName)
            table.insert(ScriptStorage.IgnoreStoreFruits, fruitName)
            Remotes.CommF_:InvokeServer('LoadFruit', fruitName)
            task.wait(0.5)
            Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
            task.wait(1)
            RefreshInventory()
            if CheckSpecialMicrochip() then
                Storage:Set("RaidIceLastChipBuy", os.time())
                Storage:Save()
                return true
            else
                for i = 1, 2 do
                    task.wait(2)
                    Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
                    task.wait(1)
                    RefreshInventory()
                    if CheckSpecialMicrochip() then
                        Storage:Set("RaidIceLastChipBuy", os.time())
                        Storage:Save()
                        return true
                    end
                end
                SetTask('MainTask', 'Auto Raid Ice | Mua chip that bai')
                return false
            end
        elseif (ScriptStorage.PlayerData.Beli or 0) >= 100000 then
            SetTask('MainTask', 'Auto Raid Ice | Mua chip bang Beli')
            Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
            task.wait(1)
            RefreshInventory()
            if CheckSpecialMicrochip() then
                Storage:Set("RaidIceLastChipBuy", os.time())
                Storage:Save()
                return true
            end
            return false
        end
        SetTask('MainTask', 'Auto Raid Ice | Khong du tai nguyen mua chip')
        return false
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        local fr = ScriptStorage.PlayerData.Fragments or 0
        local target = Config.AutoRaidIce_TargetFragments or 5000
        if lv < 1300 then return nil end
        if fr >= target then
            SetTask('MainTask', 'Raid Ice | Da dat target: ' .. fr .. '/' .. target)
            return nil
        end
        local hasChip = CheckSpecialMicrochip() ~= nil
        local onRaid = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        if onRaid then return true end
        if hasChip then return true end
        local lastBuy = Storage:Get("RaidIceLastChipBuy") or 0
        if os.time() - lastBuy >= RAID_ICE_CHIP_COOLDOWN then return true end
        return nil
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("Start", function()
        local currentIsland = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        local target = Config.AutoRaidIce_TargetFragments or 5000
        local fr = ScriptStorage.PlayerData.Fragments or 0
        if fr >= target then
            SetTask('MainTask', 'Raid Ice | Da dat target fragments')
            return
        end
        if currentIsland then
            local islandNum = tonumber(string.match(currentIsland.Name, "(%d+)"))
            SetTask('MainTask', 'Raid Ice | Fragments: ' .. fr .. '/' .. target .. ' | Dao ' .. (islandNum or "?") .. '/5')
            SetTask('SubTask', 'Raid Ice | Clearing island ' .. (islandNum or "?"))
            if islandNum and islandNum >= 3 then
                SetTask('MainTask', 'Raid Ice | Dao ' .. islandNum .. ' | Kill Aura')
                FunctionsHandler.AutoRaidIce.Methods.KillAura:Call()
                TweenController.Create(currentIsland.Position + Vector3.new(0, 50, 0))
                task.wait(1)
            else
                local hasEnemy = false
                for _, v in GetMonAsSortedRange() do
                    if CaculateDistance(v.HumanoidRootPart.Position) < 1500 then
                        hasEnemy = true
                        CombatController.Attack(v.Name)
                        break
                    end
                end
                if not hasEnemy then
                    TweenController.Create(currentIsland.Position + Vector3.new(0, 100, 0))
                end
            end
            return
        end
        if not CheckSpecialMicrochip() then
            local bought = FunctionsHandler.AutoRaidIce.Methods.BuyChip:Call()
            if not bought then return end
            task.wait(2)
            RefreshInventory()
        end
        if not CheckSpecialMicrochip() then return end
        local mapName = ({nil, 'Circle Island', 'Boat Castle'})[SeaIndex]
        if not mapName then return end
        local mapObj = ScriptStorage.Map[mapName]
        if not mapObj then
            Report('[AutoRaidIce] Khong tim thay Map: ' .. mapName)
            return
        end
        local summonCFrame
        if SeaIndex == 2 then summonCFrame = CFrame.new(-6438.73, 250.64, -4501.50)
        elseif SeaIndex == 3 then summonCFrame = CFrame.new(-5097.93, 316.44, -3142.66) end
        if summonCFrame then
            SetTask('MainTask', 'Raid Ice | Di den summon button')
            TweenController.Create(summonCFrame)
            local t0 = tick()
            repeat task.wait(0.3) until CaculateDistance(summonCFrame) < 25 or tick()-t0 > 20
        end
        if not mapObj:FindFirstChild('RaidSummon2') then
            TweenController.Create(mapObj:GetModelCFrame())
            task.wait(1)
            return
        end
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Special Microchip')
        local btn = (mapObj or workspace.Map:FindFirstChild(mapName) or workspace:FindFirstChild(mapName))
        local summonObj = btn and btn:FindFirstChild("RaidSummon2")
        local clickSuccess = false
        for retry = 1, 3 do
            if retry > 1 then task.wait(3) end
            pcall(function()
                -- [FIXED] Dùng TriggerInteractive thay vì chỉ fireclickdetector
                -- cứng 1 path — bắt được cả ProximityPrompt lẫn ClickDetector
                if summonObj and TriggerInteractive(summonObj) then
                    clickSuccess = true
                    SetTask('MainTask', 'Raid Ice | Da click start (lan ' .. retry .. ')')
                else
                    SetTask('MainTask', 'Raid Ice | Khong tim thay button (lan ' .. retry .. ')')
                end
            end)
            if clickSuccess then break end
        end
        if not clickSuccess then
            SetTask('MainTask', 'Raid Ice | Khong the click start')
            return
        end
        SetTask('MainTask', 'Raid Ice | Cho raid bat dau...')
        local raidStarted = false
        for attempt = 1, 3 do
            if attempt > 1 then
                SetTask('MainTask', 'Raid Ice | Thu lai lan ' .. attempt)
                pcall(function()
                    if summonObj then TriggerInteractive(summonObj) end
                end)
            end
            local h = os.time()
            repeat task.wait(0.5) until
                RaidTimerActive() or
                os.time() - (LastRaidAlert2 or 0) < 20 or
                os.time() - (LastRaidAlert or 0) < 20 or
                os.time() - h > 35
            if os.time() - h <= 35 then
                raidStarted = true
                break
            end
        end
        if raidStarted then
            LastRaidAlert = 0
            SetTask('MainTask', 'Raid Ice | Raid bat dau!')
        else
            Report('[AutoRaidIce] Raid khong bat dau')
            SetTask('MainTask', 'Raid Ice | Raid khong bat dau, thu lai sau...')
        end
    end)

    -- ============================================================
    -- COLLECT DROPS
    -- ============================================================
    FunctionsHandler.CollectDrops:RegisterMethod("Refresh", function()
        local k = {}
        for h in ScriptStorage.Backpack do k[FruitIdToName(h)] = h end
        for h, h in workspace:GetChildren() do
            if string.find(h.Name, 'Fruit') and not a:FindFirstChild(h.Name) and h:FindFirstChild("Handle") and not k[tostring(h)] and not ScriptStorage.Backpack[FruitNameToId(tostring(h))] then
                FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', h)
                return h
            end
        end
    end)

    FunctionsHandler.CollectDrops:RegisterMethod('Start', function()
        local k = FunctionsHandler.CollectDrops:Get('CurrentProgressLevel')
        FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', nil)
        if k then
            SetTask('SubTask', '📦 Collecting: ' .. tostring(k))
            SetTask("MainTask", "Auto Collect Drop Items - " .. tostring(k))
            TweenController.Create(k:GetModelCFrame())
        end
    end)

    -- ============================================================
    -- UTILLY ITEMS ACTIVATION
    -- ============================================================
    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Refresh', function()
        if os.time() - timeee < 20 then return end
        if not SpecialItems then
            SpecialItems = {}
            local k = {}
            IceAdmiralPassed = true
            if not ScriptStorage.Backpack.Rengoku then
                table.insert(SpecialItems, "Hidden Key")
                IceAdmiralPassed = false
            end
            if SeaIndex == 2 and Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor") then
                table.insert(SpecialItems, 'Library Key')
                IceAdmiralPassed = false
            end
            if IceAdmiralPassed then table.insert(k, 'Awakened Ice Admiral') end
            local h = not ScriptStorage.Melees['Sharkman Karate'] and Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            SharkmanPassed = typeof(h) == 'string'
            if typeof(h) == "string" then
                table.insert(SpecialItems, 'Water Key')
            else
                TidePassed = true
                table.insert(k, 'Tide Keeper')
            end
            if ScriptStorage.Backpack.Yama then
                table.insert(k, "Deandre")
                table.insert(k, 'Urban')
                table.insert(k, 'Diablo')
            end
            local function h()
                local X = {}
                for w, w in BossesOrder do
                    local D = true
                    for y, y in k do if y == w then D = false end end
                    if D then table.insert(X, w) end
                end
                local k = #X
                for w = 1, k - 1 do
                    for D = 1, k - w do
                        local k = key and tostring(X[D][key]):lower() or tostring(X[D]):lower()
                        local w = key and tostring(X[D + 1][key]):lower() or tostring(X[D + 1]):lower()
                        if k > w then X[D], X[D + 1] = X[D + 1], X[D] end
                    end
                end
                return X
            end
            BossesOrder = h()
            for k, h in DropItemData do
                if not ScriptStorage.Backpack[k] and SeaIndex == h.Sea then
                    if ScriptStorage.PlayerData.Level >= h.Level then
                        BossesOrderLevel[h.Boss] = h.Level
                        table.insert(BossesOrder, h.Boss)
                    end
                end
            end
            if FunctionsHandler.Trevor:Get("IsCompleted") and not Storage:Get('SwanDefeated') then
                BossesOrderLevel["Don Swan"] = 1100
                table.insert(BossesOrder, 'Don Swan')
                if SeaIndex == 2 and ScriptStorage.PlayerData.Level > 1500 and not ScriptStorage.Enemies['Don Swan'] then
                    alert("Don Swan", 'Hopping for Don Swan')
                    Hop()
                end
            end
        end
        for k, k in SpecialItems do
            if ScriptStorage.Tools[k] then
                FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', k)
                return k
            end
        end
        if SeaIndex == 3 and (ScriptStorage.Melees["Death Step"] or 0) >= 400 and (ScriptStorage.Melees["Black Leg"] or 0) >= 400 and ScriptStorage.PlayerData.Beli >= 2500000 and ScriptStorage.PlayerData.Fragments >= 5000 and not ScriptStorage.Melees['Electric Claw'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Previous Hero")
            return 'Previous Hero'
        end
        if ScriptStorage.Tools["Red Key"] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Red Key")
            return 'Red Key'
        end
        if ScriptStorage.Tools['Hallow Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", 'Soul Reaper Spawner')
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fire Essence")
            return "Soul Reaper Spawner"
        end
        if ScriptStorage.Tools['Fire Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Uzoth")
            return 'Uzoth'
        end
    end)

    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Start', function()
        local k = FunctionsHandler.UtillyItemsActivitation:Get("CurrentProgressLevel")
        if k == 'Hidden Key' then
            SetTask('SubTask', '🔑 Using Hidden Key for Rengoku')
            Remotes.CommF_:InvokeServer("OpenRengoku")
        elseif k == 'Water Key' then
            SetTask('SubTask', '🔑 Using Water Key for Sharkman Karate')
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Water Key")
            Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        elseif k == "Library Key" then
            SetTask('SubTask', '🔑 Using Library Key')
            Remotes.CommF_:InvokeServer("OpenLibrary")
            Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor"):Destroy()
        elseif k == "Red Key" then
            SetTask('SubTask', '🔑 Submitting Red Key to scientist')
            alert('Red Key', "Submitting red key to the scienctist.")
            Remotes.CommF_:InvokeServer('CakeScientist', "Check")
            ScriptStorage.Tools["Red Key"]:Destroy()
        elseif k == 'Previous Hero' then
            SetTask('SubTask', '⚡ Buying Electric Claw from Previous Hero')
            Remotes.CommF_:InvokeServer('BuyElectricClaw', "Start")
            task.wait(3)
            repeat
                task.wait()
                TweenController.Create(CFrame.new(-12548.0, 332.378 + math.random(-2.0, 2), -7617.0))
            until CaculateDistance(CFrame.new(-12548.0, 332.378, -7617.0)) < 30
            Data = MeleePrices["Electric Claw"]
            Data.Buy(1)
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
        elseif k == "Uzoth" then
            SetTask('SubTask', '🔥 Using Fire Essence for Dragon Talon')
            print('Use Fire Essence')
            Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
            Remotes.CommF_:InvokeServer('BuyDragonTalon')
            IsFireEssenceGave = true
            Report("Fire Essence Used")
        elseif k == "Soul Reaper Spawner" then
            SetTask('SubTask', '💀 Using Hallow Essence to spawn Soul Reaper')
            print("Use Hallow Essence")
            if CaculateDistance(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame) < 100 then SpecialItems = nil end
            TweenController.Create(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame)
        end
    end)

    -- ============================================================
    -- TREVOR
    -- ============================================================
    FunctionsHandler.Trevor:RegisterMethod('GetFruit', function()
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value > 1000000 and k.Value < 2500000 then return k end
            end
        end
    end)

    FunctionsHandler.Trevor:RegisterMethod('Refresh', function()
        if FunctionsHandler.Trevor:Get('IsCompleted') or os.time() - timeee < 1 then return end
        if ScriptStorage.PlayerData.Level < 1100 then return end
        local k = FunctionsHandler.Trevor.Methods.GetFruit:Call()
        if k then FunctionsHandler.Trevor:Set('Fruit', k) end
        TrevorDebounce = os.time()
        if not FunctionsHandler.Trevor:Get('IsCompleted') then
            FunctionsHandler.Trevor:Set('IsCompleted', (Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0))
        end
        return not FunctionsHandler.Trevor:Get("IsCompleted") and k
    end)

    FunctionsHandler.Trevor:RegisterMethod("Start", function()
        alert('[ cac ]', "Pulling fruit for trevor...")
        local k = FunctionsHandler.Trevor:Get("Fruit")
        FunctionsHandler.Trevor:Set('Fruit', nil)
        table.insert(ScriptStorage.IgnoreStoreFruits, k.Name)
        Remotes.CommF_:InvokeServer('LoadFruit', k.Name)
        task.wait()
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(FruitIdToName(k.Name))
        Remotes.CommF_:InvokeServer('TalkTrevor', '1')
        Remotes.CommF_:InvokeServer('TalkTrevor', "2")
        Remotes.CommF_:InvokeServer("TalkTrevor", "3")
        task.wait(1)
        FunctionsHandler.Trevor:Set('IsCompleted', true)
    end)

    -- ============================================================
    -- THIRD SEA PUZZLE (ZOU)
    -- ============================================================
    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod("Refresh", function()
        if ScriptStorage.PlayerData.Level < 1500 or SeaIndex ~= 2 then return end
        if nil == FunctionsHandler.ThirdSeaPuzzle:Get('State') then
            ZQuestProgress = Remotes.CommF_:InvokeServer("ZQuestProgress", 'Check')
            print('ZQuestProgress', ZQuestProgress)
            FunctionsHandler.ThirdSeaPuzzle:Set("State", ZQuestProgress == 0)
        end
        return FunctionsHandler.ThirdSeaPuzzle:Get('State')
    end)

    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod('Start', function()
        local k = FunctionsHandler.ThirdSeaPuzzle:Get("State")
        SetTask('SubTask', '🧩 Sea3: Starting ZQuest...')
        alert('1093', "start")
        if k then
            alert('1095', "case test")
            repeat
                task.wait(1)
                alert('1096', 'fire')
                print('StartResponse', Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin"))
            until CaculateDistance(Vector3.new(0, 0, 0)) > 20000
            task.spawn(function()
                alert("1098", "rejoin")
                -- [FIXED - bớt delay theo yêu cầu boss man] 30s → 15s. Vẫn
                -- giữ đủ thời gian cho server đăng ký state trước khi rejoin
                -- ép buộc, chỉ rút phân nửa thay vì bỏ hẳn (bỏ hẳn dễ rejoin
                -- lúc server chưa kịp lưu progress ZQuest).
                task.wait(15)
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
            end)
            alert("attack")
            while task.wait() do CombatController.Attack("rip_indra") end
        end
    end)

    -- ============================================================
    -- YAMA
    -- ============================================================
    FunctionsHandler.Yama:RegisterMethod('Refresh', function()
        if SeaIndex ~= 3 then return end
        if ScriptStorage.Backpack.Yama then return end
        if not FunctionsHandler.Yama:Get("EliteCount") then
            FunctionsHandler.Yama:Set("EliteCount", Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end
        if FunctionsHandler.Yama:Get('EliteCount') >= 30 then return true end
    end)

    FunctionsHandler.Yama:RegisterMethod("Start", function()
        SetTask('SubTask', '🗡️ Getting Yama...')
        repeat
            task.wait()
            TweenController.Create(game:GetService("ReplicatedStorage").FakeIslands.Waterfall:GetModelCFrame())
        until workspace.Map:FindFirstChild("Waterfall") and workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        fireclickdetector(workspace.Map.Waterfall.SealedKatana.Hitbox.ClickDetector)
    end)

    -- ============================================================
    -- PIRATE RAID
    -- ============================================================
    FunctionsHandler.PirateRaid:RegisterMethod("Refresh", function()
        local k = FunctionsHandler.PirateRaid:Get('Senque')
        return k and os.time() - k < 500
    end)

    FunctionsHandler.PirateRaid:RegisterMethod("Start", function()
        local k = GetMonAsSortedRange()
        local h = Vector3.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
        if k[1] then
            local X, w = k[1]:FindFirstChild("Humanoid"), k[1]:FindFirstChild("HumanoidRootPart")
            if w and X and X.Health > 0 and CaculateDistance(w.CFrame, h) < 500 then
                CombatController.Attack(k[1].Name)
                return
            end
        end
        TweenController.Create(h)
    end)

    -- ============================================================
    -- SOUL GUITAR - SỬA LOGIC TỪ HI.LUA + AUTO CHEST (MỚI)
    -- ============================================================
    -- ========== HÀM HỖ TRỢ ==========
    local _SgSpecialItems = {
        "God's Chalice", "Fist of Darkness", "Sweet Chalice",
        "Hallow Essence", "Mirror Fractal"
    }

    local function _SgHasSpecialItem()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local char = LocalPlayer.Character
        for _, name in ipairs(_SgSpecialItems) do
            if bp and bp:FindFirstChild(name) then return true, name end
            if char and char:FindFirstChild(name) then return true, name end
        end
        return false, nil
    end

    local function _SgGetChests()
        local chests = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent
               and string.find(string.lower(obj.Name), "chest") then
                table.insert(chests, obj)
            end
        end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            table.sort(chests, function(a, b)
                if a and b and a.Parent and b.Parent then
                    return (pos - a.Position).Magnitude < (pos - b.Position).Magnitude
                end
                return false
            end)
        end
        return chests
    end

    local function _SgCollectChest(chest)
        pcall(function()
            if not chest or not chest.Parent then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            local targetCF = chest.CFrame + Vector3.new(0, 3, 0)
            -- [FIXED - theo yêu cầu boss man: "bỏ bypass teleport"] Bỏ nhánh
            -- BypassTP cho rương xa (>3000 stud) — luôn dùng
            -- TweenController.Create bình thường, không đổi spawn point nữa.
            TweenController.Create(targetCF)
            task.wait(0.35)
            if firetouchinterest then
                firetouchinterest(hrp, chest, 0)
                task.wait()
                firetouchinterest(hrp, chest, 1)
            end
        end)
    end

    local _SgChestPhaseDone = false
    local _SgVisited = {}

    local function _SgHopServer()
        SetTask("MainTask", "🎸 Soul Guitar | Hop: Đang tìm server...")
        local ok, servers = pcall(GetServers)
        if ok and servers then
            local list = {}
            for jobId, data in pairs(servers) do
                if jobId ~= game.JobId and not _SgVisited[jobId] then
                    table.insert(list, {id = jobId, players = data.Count or 0})
                end
            end
            table.sort(list, function(a, b) return a.players < b.players end)
            if list[1] then
                _SgVisited[list[1].id] = true
                SetTask("SubTask", "🎸 Hop → " .. list[1].id:sub(1,8) .. "... (" .. list[1].players .. " players)")
                pcall(function()
                    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", list[1].id)
                end)
                -- [FIXED - bớt delay theo yêu cầu boss man] 8s → 4s. Teleport
                -- server thường tự cắt kết nối client trong vài giây, 4s vẫn
                -- đủ để không chạy tiếp code khi lệnh teleport chưa kịp ăn.
                task.wait(4)
                _SgChestPhaseDone = false
                return
            end
        end
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local resp = game:HttpGet(url)
            local data = game:GetService("HttpService"):JSONDecode(resp)
            if not data or not data.data then return end
            table.sort(data.data, function(a, b) return (a.playing or 0) < (b.playing or 0) end)
            for _, sv in ipairs(data.data) do
                local slots = (sv.maxPlayers or 0) - (sv.playing or 0)
                if slots >= 2 and sv.id ~= game.JobId and not _SgVisited[sv.id] then
                    _SgVisited[sv.id] = true
                    SetTask("SubTask", "🎸 Hop HTTP → " .. sv.id:sub(1,8) .. " (" .. (sv.playing or 0) .. "/" .. (sv.maxPlayers or 0) .. ")")
                    pcall(function()
                        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", sv.id)
                    end)
                    -- [FIXED - bớt delay theo yêu cầu boss man] 8s → 4s (giống nhánh hop ở trên)
                    task.wait(4)
                    _SgChestPhaseDone = false
                    return
                end
            end
        end)
        SetTask("MainTask", "🎸 Soul Guitar | Hop: Không tìm được server, thử lại...")
        -- [FIXED - bớt delay theo yêu cầu boss man] retry backoff 5s → 2s
        task.wait(2)
    end

    local function _SgRunChestBatch()
        local hasItem, itemName = _SgHasSpecialItem()
        if hasItem then
            SetTask("MainTask", "🎸 Auto Chest: Found " .. itemName .. " — dừng")
            return false
        end
        if ScriptStorage.Backpack["Skull Guitar"] then
            return false
        end
        local chests = _SgGetChests()
        SetTask("SubTask", "🎸 Auto Chest: " .. #chests .. " rương còn lại")
        if #chests == 0 then
            return false
        end
        for _, chest in ipairs(chests) do
            if _G.Stop then return false end
            local hasMid, nameMid = _SgHasSpecialItem()
            if hasMid then
                SetTask("MainTask", "🎸 Auto Chest: Found " .. nameMid)
                return false
            end
            if chest and chest.Parent then
                SetTask("MainTask", "🎸 Collecting: " .. chest.Name)
                _SgCollectChest(chest)
                task.wait(0.2)
            end
        end
        return #_SgGetChests() > 0
    end

    -- ========== LOGIC CHÍNH ==========
    FunctionsHandler.SoulGuitar:RegisterMethod("Refresh", function()
        if not Config.Items.SoulGuitar then return end
        if ScriptStorage.Backpack['Skull Guitar'] then return end
        if ScriptStorage.PlayerData.Level < 2300 then return end

        local ectoCount = (ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
        local bonesCount = (ScriptStorage.Backpack['Bones'] or {Count = 0}).Count or 0
        local frags = ScriptStorage.PlayerData.Fragments or 0

        -- BƯỚC 1: Farm Ectoplasm đến 250 ở Sea 2
        if ectoCount < 250 then
            _SgChestPhaseDone = false
            return 1
        end

        -- BƯỚC 2: Nếu chưa có Dark Fragment → farm chest → summon Blackbeard → đánh
        if not ScriptStorage.Backpack['Dark Fragment'] then
            if ScriptStorage.Backpack['Fist of Darkness'] then
                return 10   -- summon & đánh Blackbeard
            end
            if not _SgChestPhaseDone then
                local chests = _SgGetChests()
                if #chests > 0 then
                    return 9   -- auto chest
                else
                    _SgChestPhaseDone = true
                    SetTask("MainTask", "🎸 Soul Guitar | Hết rương, hop server để tìm Fist of Darkness")
                    task.spawn(_SgHopServer)
                    return
                end
            else
                _SgChestPhaseDone = false
                return 9
            end
        end

        -- BƯỚC 3: Đã có Dark Fragment, chuyển sang puzzle ở Sea 3
        if SeaIndex ~= 3 then
            SetTask('MainTask', '🎸 Soul Guitar: Teleport to Sea 3')
            Remotes.CommF_:InvokeServer("TravelZou")
            return
        end

        SoulGuitarProcess = Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", 'Check')
        if not SoulGuitarProcess then
            Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            if not CheckFullMoon() then
                SetTask('MainTask', 'Hopping for full moon (soul guitar)')
                _SgHopServer()
            end
            return 7
        end
        if not SoulGuitarProcess.Swamp      then return 2
        elseif not SoulGuitarProcess.Gravestones then return 3
        elseif not SoulGuitarProcess.Ghost  then return 4
        elseif not SoulGuitarProcess.Trophies   then return 5
        elseif not SoulGuitarProcess.Pipes  then return 6
        elseif bonesCount >= 500 and frags >= 5000 and not ScriptStorage.Backpack["Skull Guitar"] then
            return 8
        end
    end)

    FunctionsHandler.SoulGuitar:RegisterMethod('Start', function(k)
        if k == 9 then
            SetTask("MainTask", "🎸 Soul Guitar | Auto Chest: Nhặt rương...")
            local hasMore = _SgRunChestBatch()
            if not hasMore then
                _SgChestPhaseDone = true
            end

        elseif k == 10 then
            SetTask('SubTask', '🎸 Soul Guitar: Summon Blackbeard')
            local darkArenaPos = CFrame.new(-1742.0, 241.0, 1290.0)
            TweenController.Create(darkArenaPos)
            task.wait(1)
            pcall(function()
                Remotes.CommF_:InvokeServer("Blackbeard", "Spawn")
            end)
            task.wait(1)
            SetTask('MainTask', '🎸 Soul Guitar: Đánh Blackbeard để lấy Dark Fragment')
            CombatController.Attack("Blackbeard")

        elseif k == 7 then
            SetTask('SubTask', '🎸 Soul Guitar: Full moon gravestone')
            while CaculateDistance(CFrame.new(-8654.0, 140, 6167)) > 5 do
                task.wait()
                TweenController.Create(CFrame.new(-8654.0, 140, 6167))
            end
            SoulGuitarProcess = Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)

        elseif k == 1 then
            if SeaIndex ~= 2 then
                SetTask("SubTask", '🎸 Soul Guitar: Teleport Sea 2 để farm ectoplasm')
                SetTask("MainTask", 'Teleport to second sea to farm ectoplasm')
                Remotes.CommF_:InvokeServer("TravelDressrosa")
                return
            else
                local ecto = (ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
                SetTask("SubTask", '🎸 Soul Guitar: Farming Ectoplasm (' .. ecto .. '/250)')
                SetTask("MainTask", "Soul Guitar | Ectoplasm " .. ecto .. "/250")
                CombatController.Attack({"Ship Deckhand", "Ship Engineer", 'Ship Steward', "Ship Officer"})
                return
            end

        elseif k == 2 then
            SetTask('SubTask', '🎸 Soul Guitar: Kill Living Zombies (Swamp)')
            TTL9 = TTL9 or 0
            if os.time() ~= LastestTime1 then
                TTL9 = TTL9 + 1
                LastestTime1 = os.time()
            end
            if TTL9 > 60 then _SgHopServer() return end

            local zombies = {}
            for _, enemy in ipairs(Services.Workspace.Enemies:GetChildren()) do
                if enemy.Name == "Living Zombie" then
                    table.insert(zombies, enemy)
                end
            end

            if #zombies < 6 then
                SetTask('MainTask', 'Soul Guitar: Waiting Living Zombies (' .. #zombies .. '/6)')
                TweenController.Create(ScriptStorage.MobRegions["Living Zombie"][1] + Vector3.new(0, 30, 0))
            else
                local startT = os.time()
                for idx, zombie in ipairs(zombies) do
                    local hum  = zombie:FindFirstChild("Humanoid")
                    local root = zombie:FindFirstChild("HumanoidRootPart")
                    if not hum or not root then continue end
                    while task.wait() and hum.Health > 7000 do
                        SetTask('MainTask', 'Soul Guitar: Weakening zombie ' .. idx .. '/' .. #zombies)
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
                        if os.time() - startT > 60 then _SgHopServer() return end
                        TweenController.Create(root.CFrame + Vector3.new(0, 50, 0))
                        pcall(function() _G.FastAttack = os.time() end)
                    end
                end
                SetTask("MainTask", 'Soul Guitar: Finishing all Living Zombies')
                local killT = os.time()
                while workspace.Enemies:FindFirstChild("Living Zombie") and task.wait() do
                    if os.time() - killT > 60 then _SgHopServer() return end
                    CombatController.Attack('Living Zombie')
                end
                TTL9 = 0
            end

        elseif k == 3 then
            SetTask('SubTask', '🎸 Soul Guitar: Placard puzzle')
            local castle = workspace.Map["Haunted Castle"]
            while CaculateDistance(CFrame.new(-8800.0, 178, 6033)) > 10 do
                task.wait()
                SetTask("MainTask", "Soul Guitar: Completing placards...")
                TweenController.Create(CFrame.new(-8800.0, 178, 6033))
            end
            for placadName, dir in pairs({
                Placard1 = "Right", Placard2 = "Right", Placard3 = "Left",
                Placard4 = "Right", Placard5 = "Left", Placard6 = "Left", Placard7 = "Left"
            }) do
                pcall(function() fireclickdetector(castle[placadName][dir].ClickDetector) end)
            end

        elseif k == 4 then
            SetTask('SubTask', '🎸 Soul Guitar: Ghost task')
            Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")

        elseif k == 5 then
            SetTask('SubTask', '🎸 Soul Guitar: Trophy puzzle')
            if CaculateDistance(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) > 30 then
                TweenController.Create(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375))
            else
                local tablet = workspace.Map['Haunted Castle'].Tablet
                for _, segName in pairs(BlankTablets) do
                    local seg = tablet[segName]
                    if seg and seg.Line.Rotation.Z ~= 0 then
                        repeat task.wait() fireclickdetector(seg.ClickDetector)
                        until seg.Line.Rotation.Z == 0
                    end
                end
                for segName, trophyName in pairs(Trophy) do
                    pcall(function()
                        local handle = workspace.Map["Haunted Castle"].Trophies.Quest[trophyName].Handle
                        local rotPart = tostring(handle.CFrame):split(", ")[4]
                        local targetRot = (rotPart == "1" or rotPart == "-1") and "90" or "180"
                        local seg = tablet[segName]
                        if seg and not string.find(tostring(seg.Line.Rotation.Z), targetRot) then
                            repeat task.wait() fireclickdetector(seg.ClickDetector)
                            until string.find(tostring(seg.Line.Rotation.Z), targetRot)
                        end
                    end)
                end
            end

        elseif k == 6 then
            SetTask('SubTask', '🎸 Soul Guitar: Pipe puzzle')
            for pipeName, colorName in pairs(Pipes) do
                pcall(function()
                    local pipe = workspace.Map['Haunted Castle']['Lab Puzzle'].ColorFloor.Model[pipeName]
                    if pipe and pipe.BrickColor.Name ~= colorName then
                        repeat task.wait() fireclickdetector(pipe.ClickDetector)
                        until pipe.BrickColor.Name == colorName
                    end
                end)
            end
            Remotes.CommF_:InvokeServer('soulGuitarBuy')

        elseif k == 8 then
            SetTask('SubTask', '🎸 Soul Guitar: Buying Skull Guitar')
            Remotes.CommF_:InvokeServer('soulGuitarBuy')
        end
    end)
    -- ============================================================
    -- KẾT THÚC PHẦN SOUL GUITAR
    -- ============================================================

    -- ============================================================
    -- TUSHITA
    -- ============================================================
    FunctionsHandler.Tushita:RegisterMethod("Refresh", function()
        if ScriptStorage.Backpack.Tushita then return end
        if ScriptStorage.PlayerData.Level < 2000 then return end
        if SeaIndex ~= 3 then return end
        TushitaProgress = TushitaProgress or Remotes.CommF_:InvokeServer("TushitaProgress")
        if not TushitaProgress.OpenedDoor then
            if ScriptStorage.Enemies["rip_indra True Form"] then
                TushitaProgress = nil
                return 1
            end
        else
            if ScriptStorage.Enemies['Longma'] then
                TushitaProgress = nil
                return 2
            end
        end
    end)

    FunctionsHandler.Tushita:RegisterMethod('Start', function(k)
        if k == 1 then
            SetTask('SubTask', '🗡️ Tushita: Placing torches (Step 1)')
            alert('Auto Tushita', 'Placing torches...')
            TweenController.Create(CFrame.new(5714, math.random(19, 21), 256))
            if ScriptStorage.Tools["Holy Torch"] then
                for W = 1, 5 do Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", W) end
                return true
            end
        elseif k == 2 then
            SetTask('SubTask', '🗡️ Tushita: Defeating Longma (Step 2)')
            alert("Auto Tushita", "Defeating Longma")
            CombatController.Attack("Longma")
        end
    end)

    -- ============================================================
    -- CURSED DUAL KATANA (CDK)
    -- ============================================================
    FunctionsHandler.CursedDualKatana:RegisterMethod("Refresh", function()
        if not Config.Items.CursedDualKatana then return end
        local k = ScriptStorage.Backpack
        if ScriptStorage.PlayerData.Level < 2200 then return end
        -- [FIXED - theo spec] Trước đây thiếu mastery 350 thì chỉ `return`
        -- im lặng, không chủ động làm gì. Giờ trả tín hiệu "trainSwords" để
        -- Start() chuyển sang farm Bones tại Haunted Castle, check mastery
        -- mỗi giây, chỉ khi CẢ HAI Yama+Tushita >= 350 mới cho CDK bắt đầu.
        if k["Cursed Dual Katana"] then return end
        if not k.Tushita or (k.Tushita.Mastery or 0) < 350 or not k.Yama or (k.Yama.Mastery or 0) < 350 then
            return {"trainSwords"}
        end
        if SeaIndex ~= 3 then return end
        local k = CdkProgess or Remotes.CommF_:InvokeServer("CDKQuest", 'Progress') or 'uwu'
        if not k or k == 'uwu' then return end
        if workspace.Map.Turtle.Cursed:FindFirstChild("Breakable") then
            alert('Cursed Dual Katana', 'Open Door')
            return {"break"}
        end
        local W = {Good = 'Tushita', Evil = 'Yama'}
        if k.Good == 4 and k.Evil == 4 then
            print("burn 2")
            return {'burn 2'}
        end
        if k.Good == 3 or k.Evil == 3 then
            print('burn 1')
            return {"burn"}
        end
        if k.Opened then
            for h, X in k do
                if h ~= 'Opened' and h ~= "Finished" and X < 3 then
                    print(h, X)
                    ScriptStorage.CdkCache = {h, X + 1}
                    if not ScriptStorage.Tools[W[h]] then Remotes.CommF_:InvokeServer('LoadItem', W[h]) end
                    alert("Cursed Dual Katana", "Start " .. tostring(W[h]) .. ' ' .. tostring(h))
                    Remotes.CommF_:InvokeServer('CDKQuest', 'StartTrial', h)
                    SetTask("MainTask", "Cursed Dual Katana - " .. tostring(W[h]) .. ' ' .. tostring(h))
                    return false
                end
            end
        end
        local k = ScriptStorage.CdkCache
        if not k then return end
        local W, h = k[1], k[2]
        if W == "Evil" and h == 3 then
            -- [FIXED] Trước đây chỉ set ForceToRollBone=true rồi đứng im —
            -- biến đó không có handler nào đọc, nên bước này bị TREO VĨNH
            -- VIỄN. Thay bằng chuỗi thật: Bones → Hallow Essence → equip
            -- tại toạ độ triệu hồi → Soul Reaper xuất hiện → đánh.
            -- (verified từ main_red_magic_beta.txt + raw_6, khớp nhau)
            local HALLOW_SUMMON_CF = CFrame.new(-8932.86, 143.258, 6063.31)

            if ScriptStorage.Enemies['Soul Reaper'] then
                -- Đã lên rồi → đánh, không cần làm gì thêm ở nhánh này
                return k
            end

            local hasHallow = ScriptStorage.Backpack["Hallow Essence"]
                or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Hallow Essence"))

            if hasHallow then
                SetTask('SubTask', 'CDK Quest / Dùng Hallow Essence triệu hồi Soul Reaper')
                TweenController.Create(HALLOW_SUMMON_CF)
                if CaculateDistance(HALLOW_SUMMON_CF) <= 8 then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Hallow Essence")
                end
                return
            else
                -- [FIXED] Ngưỡng thật là 500 Bones, không phải 50 — verified
                -- từ raw_6.txt ("CheckItem(Bones) > 500"). Dưới 500 thì farm
                -- tiếp, KHÔNG bắn Buy (dư/thiếu bones lẻ tẻ không đủ đổi).
                local bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                SetTask('SubTask', 'CDK Quest / Farm Bones cho Hallow Essence (' .. tostring(bonesCount) .. '/500)')

                if bonesCount and bonesCount > 500 then
                    -- [FIXED] Đủ 500 → xả hết 1 lượt (verified: repeat Buy(1,1)
                    -- cho tới khi Check == 0), không nhỏ giọt từng lần 1 nữa
                    repeat
                        Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                        task.wait(0.2)
                        bonesCount = Remotes.CommF_:InvokeServer("Bones", "Check")
                    until not bonesCount or bonesCount <= 0
                    return
                end

                if not ScriptStorage.Enemies["Reborn Skeleton"] and not ScriptStorage.Enemies["Living Zombie"]
                    and not ScriptStorage.Enemies["Demonic Soul"] and not ScriptStorage.Enemies["Posessed Mummy"] then
                    -- [NEW] Chưa thấy xác gần đây → di chuyển tới đúng điểm
                    -- farm Haunted Castle thay vì đứng im chờ
                    SetTask('SubTask', 'CDK Quest / Di chuyển tới Haunted Castle farm Bones')
                    TweenController.Create(HAUNTED_CASTLE_BONES_CF)
                    return
                end
                CombatController.Attack({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
                return
            end
        elseif W == 'Good' then
            if h == 2 then
                SetTask("SubTask", 'CDK Quest / Waiting until pirate raid started')
                return
            elseif h == 3 and not ScriptStorage.Enemies["Cake Queen"] then
                Hop()
                SetTask('SubTask', "CDK Quest / Waiting until Cake Queen boss spawned")
                return
            end
        end
        return k
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("GetHazeMon", function()
        local k = {}
        for W, W in LocalPlayer.QuestHaze:GetChildren() do if W.Value > 0 then table.insert(k, W) end end
        table.sort(k, function(W, h) return CaculateDistance(W:GetAttribute('Position')) < CaculateDistance(h:GetAttribute('Position')) end)
        return tostring(k[1])
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("DoDimension", function(k)
        local W = string.gsub(k, ' ', "")
        local k = os.time()
        repeat
            task.wait()
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            if os.time() - k > 60 then return end
        until os.time() - TorchEnabledTime < 10
        repeat
            task.wait()
            local k = workspace.Map:WaitForChild(W, 10)
            if k then
                for h, h in k:GetChildren() do
                    if h and string.find(h.Name, "Torch") and h:FindFirstChild('ProximityPrompt') and h.ProximityPrompt.Enabled then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = h.CFrame
                        h.ProximityPrompt.HoldDuration = 0
                        task.wait(1)
                        local X = game:GetService("VirtualInputManager")
                        X:SendKeyEvent(true, "E", 0, game)
                        X:SendKeyEvent(false, "E", 0, game)
                        fireproximityprompt(workspace.Map:WaitForChild(W, 10):FindFirstChild(tostring(h)).ProximityPrompt)
                    end
                    for W, W in workspace.Enemies:GetChildren() do
                        local h = W:FindFirstChild("HumanoidRootPart")
                        local X = W:FindFirstChild("Humanoid")
                        if h and X and CaculateDistance(h.CFrame) < 1000 then CombatController.Attack(W.Name) end
                    end
                end
                ExitDoor = k:FindFirstChild("Exit")
                print("exit door", ExitDoor)
                if ExitDoor then
                    PortalBrick = tostring(ExitDoor.BrickColor)
                    print("Brick color", ExitDoor, ExitDoor.BrickColor, PortalBrick)
                end
            else
                print('no island idk wt-')
            end
            print('loop damn', PortalBrick)
        until PortalBrick == 'Olive' or PortalBrick == "Cloudy grey"
        print('leave')
        while os.time() - DoneCdkTick > 15 do
            TweenController.Create(ExitDoor.CFrame + Vector3.new(0, math.random(1, 5), 0))
            task.wait()
        end
        Hop()
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("Start", function(k)
        local W = workspace.Map.Turtle.Cursed
        if k[1] == "trainSwords" then
            -- [NEW - theo spec] Yama/Tushita chưa đủ 350 mastery — farm
            -- Bones tại Haunted Castle, trang bị đúng kiếm đang thiếu để
            -- mastery tính đúng vũ khí. Bones thu được dùng chung cho Fire
            -- Essence (Dragon Talon) và Hallow Essence (CDK) sau này.
            local bp = ScriptStorage.Backpack
            local tushitaMastery = bp.Tushita and bp.Tushita.Mastery or 0
            local yamaMastery    = bp.Yama and bp.Yama.Mastery or 0

            local swordToTrain = nil
            if not bp.Tushita then
                swordToTrain = "buy_tushita"
            elseif tushitaMastery < 350 then
                swordToTrain = "Tushita"
            elseif not bp.Yama then
                swordToTrain = "buy_yama"
            elseif yamaMastery < 350 then
                swordToTrain = "Yama"
            end

            if swordToTrain == "buy_tushita" or swordToTrain == "buy_yama" then
                SetTask('MainTask', 'CDK Prep | Chưa có ' .. (swordToTrain == "buy_tushita" and "Tushita" or "Yama") .. ' — chờ Tushita/Yama handler mua')
                return
            end

            SetTask('MainTask', string.format('CDK Prep | Tushita %d/350, Yama %d/350', tushitaMastery, yamaMastery))

            if swordToTrain then
                pcall(function()
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(swordToTrain)
                end)
            end

            if not ScriptStorage.Enemies["Reborn Skeleton"] and not ScriptStorage.Enemies["Living Zombie"]
                and not ScriptStorage.Enemies["Demonic Soul"] and not ScriptStorage.Enemies["Posessed Mummy"] then
                SetTask('SubTask', 'CDK Prep | Di chuyển tới Haunted Castle')
                TweenController.Create(HAUNTED_CASTLE_BONES_CF)
                return
            end
            CombatController.Attack({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
            return
        end
        if k[1] == 'break' then
            SetTask('SubTask', '⚔️ CDK: Opening door')
            TweenController.Create(workspace.Map.Turtle.Cursed.Breakable.CFrame)
            Remotes.CommF_:InvokeServer('CDKQuest', "OpenDoor")
            Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
            workspace.Map.Turtle.Cursed.Breakable:Destroy()
            CdkProgess = nil
            return
        end
        if k[1] == "burn 2" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals (step 2)')
            if workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled then
                fireproximityprompt(workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt)
                task.wait(1)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                -- [FIXED - bớt delay theo yêu cầu boss man] 10s → 5s. Đây là
                -- chờ respawn sau self-kill, 5s vẫn đủ dư so với thời gian
                -- respawn thực tế (thường 2-3s) của Blox Fruits.
                task.wait(5)
            else
                CDKAttempts = (CDKAttempts or 0) + 1
                TweenController.Create(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
                -- [FIXED - bớt delay theo yêu cầu boss man] 5s/5s → 3s/3s
                task.wait(3)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(3)
                if CDKAttempts > 5 then Hop() end
                CdkProgess = nil
            end
        elseif k[1] == "burn" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals')
            for W = 1, 3, 1 do
                local h = workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W)
                if workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).ProximityPrompt.Enabled then
                    repeat
                        task.wait()
                        TweenController.Create(workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).CFrame)
                    until CaculateDistance(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).CFrame) < 5
                    fireproximityprompt(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).ProximityPrompt)
                    task.wait(3)
                    pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                end
                CdkProgess = nil
            end
        elseif k[1] == 'Evil' then
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Forest Pirate')
                local W = ScriptStorage.Enemies["Forest Pirate"]
                TweenController.Create((W and W.HumanoidRootPart.CFrame) or ScriptStorage.MobRegions["Forest Pirate"][0])
                CdkProgess = nil
            elseif k[2] == 2 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Haze monster')
                CombatController.Attack(FunctionsHandler.CursedDualKatana.Methods.GetHazeMon:Call())
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Soul Reaper')
                Report("found cdk yama 3")
                while not (os.time() - TorchEnabledTime < 100 or not ScriptStorage.Enemies["Soul Reaper"]) do
                    print("tweening to soul reaper")
                    task.wait()
                    if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                        pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                    end
                    TweenController.Create(ScriptStorage.Enemies["Soul Reaper"]:GetModelCFrame())
                end
                if not ScriptStorage.Enemies["Soul Reaper"] then return end
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Hell Dimension")
                CdkProgess = nil
            end
        else
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Boat Dealer')
                for W, W in game.ReplicatedStorage.NPCs:GetChildren() do
                    if W.Name == "Luxury Boat Dealer" then
                        repeat
                            task.wait()
                            if os.time() - DoneCdkTick < 15 then return end
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = (W:GetModelCFrame())
                            RealNPC = nil
                            for h, h in workspace.NPCs:GetChildren() do
                                if CaculateDistance(h:GetModelCFrame(), W:GetModelCFrame()) < 20 then
                                    RealNPC = h
                                    break
                                end
                            end
                        until CaculateDistance(W:GetModelCFrame()) < 5 and RealNPC
                        Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", RealNPC)
                    end
                end
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Cake Queen')
                repeat
                    task.wait()
                    print('attacking cage queen')
                    CombatController.Attack("Cage Queen")
                until os.time() - TorchEnabledTime < 10 or not ScriptStorage.Enemies['Cake Queen']
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
                Report('Cake Queen')
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Heavenly Dimension")
                CdkProgess = nil
            end
        end
    end)

    -- ============================================================
    -- NOTIFICATION LISTENERS
    -- ============================================================
    local k = {Listeners = {}}
    TorchEnabledTime = 0
    DoneCdkTick = 0
    getgenv().NotificationCallBack = (function(W)
        for h, X in k.Listeners do
            if string.find(string.lower(W), string.lower(h)) then X(W) end
        end
    end)
    function k:RegisterNotifyListener(W, h) k.Listeners[W] = h end
    k:RegisterNotifyListener('go!', function() LastRaidAlert = os.time() end)
    k:RegisterNotifyListener('raid', function() LastRaidAlert2 = os.time() end)
    k:RegisterNotifyListener("been spotted approaching", function() FunctionsHandler.PirateRaid:Set('Senque', os.time()) end)
    k:RegisterNotifyListener('job', function() FunctionsHandler.PirateRaid:Set('Senque', 0) end)
    k:RegisterNotifyListener("level", function() AddPoint() end)
    k:RegisterNotifyListener("torch", function() TorchEnabledTime = os.time() end)
    k:RegisterNotifyListener("scroll reacts", function() DoneCdkTick = os.time() end)
    k:RegisterNotifyListener("elite", function()
        FunctionsHandler.Yama:Set('EliteCount', Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        alert("[MeyyHub ] ", "Elite defeated: " .. tostring(FunctionsHandler.Yama:Get("EliteCount") or 'n/a'))
    end)
    k:RegisterNotifyListener('the raid with', function()
        if ScriptStorage.PlayerData.Level < MaxLevel then return end
        Remotes.CommF_:InvokeServer('Awakener', "Awaken")
    end)
    k:RegisterNotifyListener('quest completed', function()
        J:RefreshQuest()
        task.wait()
        if not J:GetCurrentClaimQuest() then J:MarkAsCompleted() end
    end)
    local k
    k = hookfunction(require(game.ReplicatedStorage.Notification).new, function(W, h)
        v21 = tostring(tostring(W or '') .. tostring(h or "")) or ""
        getgenv().NotificationCallBack(v21)
        return k(W, h)
    end)

    -- ============================================================
    -- SERVER MANAGEMENT
    -- ============================================================
    if SeaIndex ~= 1 then end
    function IfTableHaveIndex(k) for W in k do return true end end
    print(1)
    function GetServers()
        if LastServersDataPulled then
            if os.time() - LastServersDataPulled < 60 then return CachedServers end
        end
        for k = 1, 100, 1 do
            local W = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(k)
            if IfTableHaveIndex(W) then
                LastServersDataPulled = os.time()
                CachedServers = W
                return W
            end
        end
    end
    spawn(function()
        GetServers()
        -- [FIXED - bớt delay theo yêu cầu boss man] 180s → 90s. Không rút
        -- sâu hơn nữa để tránh spam API server-list của Roblox (public API
        -- có rate-limit thật), 90s vẫn đủ nhanh để danh sách hop không bị cũ.
        while task.wait(90) do GetServers() end
    end)
    function Hop(k, W)
        local h = GetServers()
        local X = {}
        for w, D in h do
            table.insert(X, {JobId = w, Players = D.Count, LastUpdate = D.__LastUpdate, Region = D.Region})
        end
        print(#X, "servers received")
        for h = 1, #X do
            while task.wait() do
                local h = math.random(1, #X)
                ServerData = X[h]
                if ServerData then
                    if not k or ServerData.Players < k then
                        if not W or ServerData.Regoin == W then
                            print("Found Server:", ServerData.JobId, "Player Count:", ServerData.Players, 'Region:', ServerData.Region)
                            break
                        end
                    end
                end
            end
        end
        print('Teleporting to', ServerData.JobId, "..")
        game:GetService("ReplicatedStorage"):WaitForChild('__ServerBrowser'):InvokeServer("teleport", ServerData.JobId)
    end
    LowHop = function(k, k)
        local k = {}
        local W = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true')
        local h = game:GetService("HttpService"):JSONDecode(W)
        if h and h.data then
            for W, W in next, h.data do
                if type(W) == "table" and tonumber(W.playing) and tonumber(W.maxPlayers) and W.playing < 5 and W.id ~= JobId then
                    table.insert(k, 1, W.id)
                end
            end
        end
        if #k > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, k[math.random(1, #k)], game.Players.LocalPlayer)
        else
            return alert('Serverhop', "Couldn't find a server.")
        end
    end

    -- ============================================================
    -- STORAGE
    -- ============================================================
    Storage = {WRITE_DELAY = .5, Data = {}}
    Services = {}
    setmetatable(Services, {__index = function(k, k) return game:GetService(k) end})
    LocalPlayer = game.Players.LocalPlayer
    local k = ".storage_u_" .. tostring(LocalPlayer)
    function Decode(W) return Services.HttpService:JSONDecode(W) end
    function Encode(W) return Services.HttpService:JSONEncode(W) end
    print(5)
    function Storage.Set(W, h, X) W.Data[h] = X end
    function Storage.Get(W, h) return W.Data[h] end
    function Storage.Save(W) pcall(function() if writefile then writefile(k, Encode(W.Data)) end end) end
    if isfile and readfile and not isfile(k) then
        pcall(writefile, k, "{}")
        task.wait(1)
    end
    Storage.Data = {}
    if readfile then pcall(function() Storage.Data = Decode(readfile(k) or '{}') end) end
    spawn(function() while task.wait(Storage.WRITE_DELAY) do Storage:Save() end end)
    CreateTraceback('Initalize', "Initalizing script..")
    local k = {}
    SetTask("MainTask", 'Level Farming')
    SetTask("SubTask", "Idle")
    ParsingTimes = 0
    function RefreshTasksData()
        if _G.Stop then return end
        for W, W in TasksOrder do
            local h = FunctionsHandler[W]
            if not h.Initalized then
                if not k[W] then
                    print("[ Debug ] Task", Name, "is not registered yet")
                    k[W] = true
                end
            else
                local k = h.Methods.Refresh
                local X = h.Methods.Start
                if k then
                    local h = k:Call(ParsingTimes < 100)
                    ParsingTimes = ParsingTimes + 1
                    if h and ParsingTimes > 100 then
                        CurrentTask = CurrentTask ~= W
                        CurrentTask = W
                        ScriptStorage.Interface.SetText('DebugLine', W)
                        X:Call(h)
                        return
                    end
                end
            end
        end
    end
    SetText('MainTextLabel', "Refreshing Player Items..")
    AddPoint()
    J:RefreshQuest()
    RefreshInventory()
    Remotes.CommE.OnClientEvent:Connect(function(...)
        local J = {...}
        if string.find(J[1], 'Item') then RefreshInventory() end
    end)
    RefreshRace()
    a.LocalPlayer.Idled:Connect(function()
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end)
    SetText("MainTextLabel", 'Loaded In ' .. tick() - StartTick .. 'ms!')
    -- ============================================================
    -- [REPLACED] FPS BOOSTER — hàm cũ EnableFpsBoost() có "if true then
    -- return end" ngay dòng đầu, khiến TOÀN BỘ ~100 dòng optimize không
    -- bao giờ chạy dù Config.Configuration.FpsBoost = true hay false.
    -- Thay bằng logic raw9jjs.txt (đơn giản, verified hoạt động): chuyển
    -- xám toàn bộ map + nhân vật, tắt particle/trail, hạ QualityLevel.
    -- Theo dõi DescendantAdded liên tục — object mới spawn ra (quái, boss,
    -- item) cũng tự động bị áp dụng, không cần chạy lại thủ công.
    -- ============================================================
    local function GrayAndOptimize(object)
        if object:IsA("BasePart") or object:IsA("MeshPart") or object:IsA("UnionOperation") then
            object.Material = Enum.Material.Plastic
            object.Reflectance = 0
            if not object.Name:find("Handle") and not object.Name:find("Attachment") then
                pcall(function() object.Color = Color3.fromRGB(128, 128, 128) end)
            end
        end
        if object:IsA("Decal") or object:IsA("Texture") then
            object.Transparency = 1
        end
        if object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Smoke") or object:IsA("Fire") then
            object.Enabled = false
        end
    end

    local function EnableFpsBoost()
        if not (Config.Configuration and Config.Configuration.FpsBoost) then return end
        task.spawn(function()
            pcall(function()
                Services.Lighting.GlobalShadows = false
                Services.Lighting.Brightness = 1
                Services.Lighting.Ambient = Color3.fromRGB(128, 128, 128)
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end

                for _, descendant in ipairs(workspace:GetDescendants()) do
                    pcall(GrayAndOptimize, descendant)
                end

                local function onCharacterAdded(character)
                    if not character then return end
                    task.wait(0.5)
                    for _, descendant in ipairs(character:GetDescendants()) do
                        pcall(GrayAndOptimize, descendant)
                    end
                end
                if LocalPlayer and LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
                LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
                Services.Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(onCharacterAdded)
                end)

                -- [FIXED - LAG] task.wait(0.1) TRONG event handler chạy cho
                -- MỌI object thêm vào workspace là nguồn lag rất lớn — lúc
                -- farm boss/raid/quest, hàng trăm object sinh ra mỗi giây
                -- (particle, projectile, xác quái, hiệu ứng đòn đánh...),
                -- MỖI CÁI đều tạo 1 lần yield 100ms → dồn ứ lịch chạy, đúng
                -- khớp mô tả "farm boss/lv/quest rất lag" của boss man.
                -- Bỏ hẳn wait, không cần thiết (set Color/Material ngay sau
                -- khi object được tạo là an toàn). Thêm lọc loại object
                -- SỚM để khỏi tốn pcall cho thứ chắc chắn không liên quan
                -- đồ hoạ (Script, Sound, Folder, Value...).
                local GRAYABLE_CLASSES = {
                    BasePart = true, MeshPart = true, UnionOperation = true,
                    Decal = true, Texture = true, ParticleEmitter = true,
                    Trail = true, Smoke = true, Fire = true,
                }
                workspace.DescendantAdded:Connect(function(descendant)
                    if not (Config.Configuration and Config.Configuration.FpsBoost) then return end
                    if not GRAYABLE_CLASSES[descendant.ClassName] then return end
                    pcall(GrayAndOptimize, descendant)
                end)

                print("[✅ FPS Boost] Đã bật gray mode + giảm đồ hoạ (raw9jjs)")
            end)
        end)
    end
    EnableFpsBoost()
    QueueList = {}
    function NearbyHopHandler()
        do return end
        if NearbyHopHandlerDebounce and os.time() - NearbyHopHandlerDebounce < 10 then return end
        NearbyHopHandlerDebounce = os.time()
        for J, J in a:GetPlayers() do
            local k = J and J.Character and J.Character:FindFirstChild("HumanoidRootPart") and J.Character.HumanoidRootPart.Position
            if k then
                local W = QueueList[J.Name]
                if not W then
                    QueueList[J.Name] = os.time()
                else
                    if os.time() - W > 30 then
                        if CaculateDistance(k) < 100 then
                            Hop('nearby plr')
                            -- [FIXED - bớt delay theo yêu cầu boss man] 5s → 2s
                            task.wait(2)
                        else
                            QueueList[J.Name] = nil
                        end
                    end
                end
            end
        end
    end
    task.spawn(function()
        while task.wait() do
            if not _G.Stop then
                NearbyHopHandler()
                if LocalPlayer.Character:FindFirstChild('Humanoid') and LocalPlayer.Character.Humanoid.Sit then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                pcall(RefreshPlayerData)
                local J = os.time() - timeee
                local r = J + OldSessionTime
                if writefile then pcall(writefile, ".tdif-" .. game.Players.LocalPlayer.Name, tostring(r)) end
                if ScriptStorage.Interface then
                    SetText('LiveTime', "Total Elapsed Time: " .. DispTime(r, true) .. ' Elapsed Time: ' .. DispTime(J, true))
                end
                RefreshDebounce = os.time()
            end
        end
    end)
    AddPoint()
    Remotes.CommF_:InvokeServer("Cousin", 'Buy')
    task.spawn(function()
        task.wait(Config.Configuration.AutoHopDelay)
        if not Config.Configuration.AutoHop then Hop('Autohop') end
    end)

    -- ============================================================
    -- AUTO SEA 2 & 3 (CÁC THREAD RIÊNG)
    -- ============================================================
    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoSea2 then
                pcall(function()
                    if ScriptStorage.PlayerData.Level >= 700 and SeaIndex ~= 2 then
                        _G.SeaTransitionActive = true  -- [ADDED] đồng bộ với AutoSea3, tránh LevelFarm giành tween
                        local iceDoor = workspace.Map.Ice.Door
                        if iceDoor and iceDoor.CanCollide == true and iceDoor.Transparency == 0 then
                            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Key")
                            TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65))
                            repeat task.wait() until not Config.AutoSea2 or (HumanoidRootPart and (HumanoidRootPart.Position - Vector3.new(1347.71, 37.38, -1325.65)).Magnitude < 5)
                        elseif iceDoor and iceDoor.CanCollide == false and iceDoor.Transparency == 1 then
                            if workspace.Enemies:FindFirstChild("Ice Admiral") then
                                CombatController.Attack("Ice Admiral")
                                repeat task.wait() until not Config.AutoSea2 or not workspace.Enemies:FindFirstChild("Ice Admiral") or workspace.Enemies["Ice Admiral"].Humanoid.Health <= 0
                                Remotes.CommF_:InvokeServer("TravelDressrosa")
                            else
                                TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65))
                            end
                        else
                            Remotes.CommF_:InvokeServer("TravelDressrosa")
                        end
                        -- [ADDED] Check PlaceId thật để xác nhận đã sang Sea 2, timeout 60s tránh treo vĩnh viễn
                        local waitStart = tick()
                        repeat
                            task.wait(1)
                        until game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
                           or SeaIndex == 2 or (tick() - waitStart) > 60
                        _G.SeaTransitionActive = false
                    end
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if not Config.AutoSea3 then _G.SeaTransitionActive = false end
            if SeaIndex == 3 then _G.RipIndraBegun = false end
            if Config.AutoSea3 then
                pcall(function()
                    -- [FIXED] Thiếu "SeaIndex ~= 3" — trước đây vòng lặp này
                    -- chạy MÃI MÃI kể cả sau khi đã ở Sea 3, tiếp tục gọi
                    -- BartiloQuestProgress/tween mỗi 0.5s dù đã xong quest,
                    -- có thể trả giá trị lạ và tween lung tung. AutoSea2 bên
                    -- trên đã có sẵn check này, AutoSea3 bị thiếu do sót.
                    if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex ~= 3 then
                        -- [ADDED] Khóa LevelFarm lại — "bỏ mấy thứ làm dang dở
                        -- khác" trong lúc đang xử lý quest/di chuyển sang Sea 3
                        _G.SeaTransitionActive = true

                        local bartiloProgress = Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                        if bartiloProgress == 0 then
                            local questText = game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                            if string.find(questText, "Swan Pirates") and string.find(questText, "50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                                local swan = workspace.Enemies:FindFirstChild("Swan Pirate")
                                if swan and swan:FindFirstChild("Humanoid") and swan.Humanoid.Health > 0 then
                                    CombatController.Attack("Swan Pirate")
                                else
                                    TweenController.Create(CFrame.new(1057.93, 137.61, 1242.08))
                                end
                            else
                                TweenController.Create(CFrame.new(-456.29, 73.02, 299.90))
                            end
                        elseif bartiloProgress == 1 then
                            local jeremy = workspace.Enemies:FindFirstChild("Jeremy")
                            if jeremy and jeremy:FindFirstChild("Humanoid") and jeremy.Humanoid.Health > 0 then
                                CombatController.Attack("Jeremy")
                            else
                                TweenController.Create(CFrame.new(2099.88, 448.93, 648.00))
                            end
                        elseif bartiloProgress == 2 then
                            TweenController.Create(CFrame.new(-1836, 11, 1714))
                            if CaculateDistance(CFrame.new(-1836, 11, 1714)) < 5 then
                                local positions = {
                                    CFrame.new(-1850.49, 13.18, 1750.90),
                                    CFrame.new(-1858.87, 19.38, 1712.02),
                                    CFrame.new(-1803.94, 16.58, 1750.90),
                                    CFrame.new(-1858.56, 16.86, 1724.80),
                                    CFrame.new(-1869.54, 15.99, 1681.01),
                                    CFrame.new(-1800.10, 16.50, 1684.52),
                                    CFrame.new(-1819.26, 14.80, 1717.91),
                                    CFrame.new(-1813.52, 14.86, 1724.80)
                                }
                                for _, pos in ipairs(positions) do
                                    if not Config.AutoSea3 then break end
                                    HumanoidRootPart.CFrame = pos
                                    task.wait(0.1)
                                end
                            end
                        elseif bartiloProgress == 3 then
                            local unlockables = Remotes.CommF_:InvokeServer("GetUnlockables")
                            if unlockables.FlamingoAccess == nil then
                                local inventoryFruits = Remotes.CommF_:InvokeServer("getInventoryFruits")
                                local fruitStore = {}
                                for _, v in pairs(inventoryFruits) do
                                    for i1, v1 in pairs(v) do
                                        if i1 == "Name" then table.insert(fruitStore, v1) end
                                    end
                                end
                                local fruitPrices = Remotes.CommF_:InvokeServer("GetFruits")
                                local availableFruits = {}
                                for _, v in next, fruitPrices do
                                    if v.Price >= 1000000 then table.insert(availableFruits, v.Name) end
                                end
                                for _, fruitName in pairs(availableFruits) do
                                    for _, storeFruit in pairs(fruitStore) do
                                        if fruitName == storeFruit and unlockables.FlamingoAccess == nil then
                                            if not game.Players.LocalPlayer.Backpack:FindFirstChild(fruitName) then
                                                Remotes.CommF_:InvokeServer("LoadFruit", fruitName)
                                            else
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                                            end
                                        end
                                    end
                                end
                                Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                            else
                                local zCheck = Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
                                if zCheck == 0 then
                                    local rip_indra = workspace.Enemies:FindFirstChild("rip_indra")
                                    if rip_indra and rip_indra:FindFirstChild("Humanoid") and rip_indra.Humanoid.Health > 0 then
                                        -- [FIXED] Đánh XONG rồi CHỜ nó chết hẳn (giống pattern Ice
                                        -- Admiral ở AutoSea2 — đã chạy đúng từ trước), thay vì đánh
                                        -- 1 phát rồi thoát ra chờ vòng poll 0.5s sau mới biết kết quả
                                        CombatController.Attack("rip_indra")
                                        repeat
                                            task.wait()
                                            CombatController.Attack("rip_indra")
                                        until not Config.AutoSea3
                                           or not rip_indra.Parent
                                           or rip_indra.Humanoid.Health <= 0

                                        -- [ADDED] Vừa xác nhận chết xong → re-check + travel NGAY,
                                        -- không đợi vòng poll 0.5s tiếp theo (giữ nhất quán với cách
                                        -- AutoSea2 gọi TravelDressrosa ngay sau khi Ice Admiral chết)
                                        task.wait(1)
                                        local zAfterKill = Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
                                        if zAfterKill == 1 or zAfterKill == 2 then
                                            Remotes.CommF_:InvokeServer("TravelZou")
                                            local waitStart2 = tick()
                                            repeat
                                                task.wait(1)
                                            until game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
                                               or SeaIndex == 3 or (tick() - waitStart2) > 60
                                        end

                                    elseif not rip_indra then
                                        -- [FIXED] CHỈ gọi "Begin" khi rip_indra CHƯA TỪNG spawn —
                                        -- trước đây branch else này bắt luôn cả trường hợp "vừa giết
                                        -- xong, xác còn đó Health=0", gọi lại Begin liên tục reset
                                        -- quest → zCheck không bao giờ lên 1 → không bao giờ travel.
                                        if not _G.RipIndraBegun then
                                            Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                                            _G.RipIndraBegun = true
                                        end
                                        TweenController.Create(CFrame.new(2288.80, 15.19, 863.03))
                                    else
                                        -- rip_indra tồn tại nhưng Health<=0 (xác vừa chết, server
                                        -- chưa kịp dọn) → KHÔNG gọi Begin, chỉ đợi rồi để vòng poll
                                        -- 0.5s tiếp theo tự đọc lại zCheck (server cần chút thời gian)
                                        task.wait(1)
                                    end
                                elseif zCheck == 1 then
                                    -- [ADDED] Đây là bước TELEPORT SANG PLACE KHÁC thật sự
                                    -- (Sea 3 = PlaceId khác hẳn, không phải chỉ đổi map trong
                                    -- cùng server). Gọi xong PHẢI đợi xác nhận qua game.PlaceId
                                    -- rồi mới coi là xong — không thì code phía dưới (hoặc
                                    -- LevelFarm) vẫn tưởng đang ở Sea 2, dùng HumanoidRootPart/
                                    -- workspace CŨ đã bị hủy khi qua place mới → dịch tùm lum.
                                    Remotes.CommF_:InvokeServer("TravelZou")
                                    local waitStart = tick()
                                    repeat
                                        task.wait(1)
                                    until game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
                                       or SeaIndex == 3 or (tick() - waitStart) > 60
                                else
                                    local donSwan = workspace.Enemies:FindFirstChild("Don Swan")
                                    if donSwan and donSwan:FindFirstChild("Humanoid") and donSwan.Humanoid.Health > 0 then
                                        CombatController.Attack("Don Swan")
                                    else
                                        TweenController.Create(CFrame.new(2288.80, 15.19, 863.03))
                                    end
                                end
                            end
                        end
                    else
                        -- [ADDED] Level chưa đủ HOẶC đã ở Sea 3 rồi → không có
                        -- lý do gì để khóa LevelFarm nữa, trả lại quyền farm bình thường
                        _G.SeaTransitionActive = false
                    end
                end)
            end
        end
    end)

    -- ============================================================
    -- ANTI LAG / LOW GRAPHICS
    -- ============================================================
    if Config.Configuration and Config.Configuration.LowGraphics ~= false then
        task.spawn(function()
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
                lighting.Brightness = 0
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
                local terrain = workspace.Terrain
                if terrain then
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 0
                end
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Lifetime = NumberRange.new(0)
                    elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    end
                end
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = "Level01"
                    settings().Rendering.GraphicsMode = "NoGraphics"
                end
                print("[✅ Anti Lag] Đã áp dụng tối ưu đồ họa!")
            end)
        end)
    end

--============================================================
-- [EXTRAS] NO ANIMATION + AUTO REDEEM CODES + AUTO RANDOM FRUIT (GACHA)
-- Opções (pode editar/desligar):
Config.Extras = {
    NoAnimation      = false,  -- manter animações para não interromper ataques melee
    AutoRedeemCodes  = true,   -- resgata todos os códigos no início
    AutoGachaFruit   = true,   -- rola o Gacha (Random Fruit) automaticamente
    GachaInterval    = 5,      -- segundos entre cada checagem do gacha
}
-- Mantém a opção antiga sincronizada com a opção de gacha acima.
Config.Items.AutoRandomFruit = Config.Extras.AutoGachaFruit
--============================================================
task.spawn(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    -- NO ANIMATION
    local function disableAnimations(character)
        if not Config.Extras.NoAnimation or not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0) end)
            end
        end
        local animate = character:FindFirstChild("Animate")
        if animate then pcall(function() animate.Disabled = true end) end
    end
    if LP.Character then task.spawn(disableAnimations, LP.Character) end
    LP.CharacterAdded:Connect(function(char) task.wait(0.5); disableAnimations(char) end)
    task.spawn(function()
        while task.wait(5) do pcall(disableAnimations, LP.Character) end
    end)

    -- AUTO REDEEM CODES: movido para fora de hoangtuveu() (ver bloco antes da chamada final)

    -- AUTO RANDOM FRUIT (GACHA - Zioles)
    getgenv().AutoRandomFruit = Config.Extras.AutoGachaFruit

    local GachaRF
    local function getGachaRF()
        if GachaRF then return GachaRF end
        local ok = pcall(function()
            GachaRF = game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RF/GachaNetworkRF", 10)
        end)
        return ok and GachaRF or nil
    end

    local function GachaCall(ctx)
        local rf = getGachaRF()
        if not rf then return false, "GachaNetworkRF nao encontrado" end
        local ok, result = pcall(function()
            return rf:InvokeServer({
                SpokeNPC = "Blox Fruit Gacha",
                Context = ctx,
                BoxName = "ZiolesGacha",
            })
        end)
        if not ok then return false, tostring(result) end
        return true, result
    end

    task.spawn(function()
        while task.wait(Config.Extras.GachaInterval or 5) do
            if getgenv().AutoRandomFruit and Config.Extras.AutoGachaFruit then
                local ok, result = GachaCall("Check")
                if ok and typeof(result) == "table" and result.RequirementsMet then
                    local ok2, r2 = GachaCall("Purchase")
                    print(ok2 and "[BombaCat Gacha] Compra solicitada." or ("[BombaCat Gacha] Falha: " .. tostring(r2)))
                    task.wait(1.5) -- evita enviar pedidos de compra em sequência demasiado rápida
                elseif not ok then
                    warn("[BombaCat Gacha] Não foi possível verificar o gacha: " .. tostring(result))
                end
            end
        end
    end)

    getgenv().HexHubOficial = {
        Start = function() getgenv().AutoRandomFruit = true; Config.Extras.AutoGachaFruit = true end,
        Stop  = function() getgenv().AutoRandomFruit = false; Config.Extras.AutoGachaFruit = false end,
        Spin  = function() return GachaCall("Purchase") end,
        Check = function() return GachaCall("Check") end,
    }
end)


    -- ============================================================
    -- VÒNG LẶP CHÍNH
    -- ============================================================
    while task.wait() do
        if Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
            SetTask('MainTask', "Rejoining due idle in 10 min!")
            task.wait(1)
            while task.wait() do game:GetService('TeleportService'):Teleport(game.PlaceId) end
        end
        if not AnimationDelay or os.time() - AnimationDelay > 60 then
            AnimationDelay = os.time()
        end
        if ScriptStorage.PlayerData.Level and ScriptStorage.PlayerData.Level > 0 then
            local J, r = xpcall(RefreshTasksData, debug.traceback)
            if not J then 
                print('[ Error ]', r)
                task.wait(1)
            end
        else
            task.wait(1)
            pcall(RefreshPlayerData)
        end
    end
end


--============================================================
-- [VOID ATTACK] ATAQUE ENVIADO PELO USUARIO
--============================================================
do
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RS_Remotes = ReplicatedStorage:WaitForChild("Remotes")

local RE_ShootGunEvent = Net:WaitForChild("RE/ShootGunEvent")
local RE_RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RE_RegisterHit = Net:WaitForChild("RE/RegisterHit")
local GunValidator = RS_Remotes:WaitForChild("Validator2")

local SUCCESS_SHOOT, SHOOT_FUNCTION = pcall(function()
    return getupvalue(require(ReplicatedStorage.Controllers.CombatController).Attack, 9)
end)

local capturedChild, RemoteId = nil, nil

local function tryCapture(parent)
    if not parent then return end
    for _, item in ipairs(parent:GetChildren()) do
        if item:IsA("RemoteEvent") then
            local attr = item:GetAttribute("Id")
            if attr then
                RemoteId, capturedChild = attr, item
                return true
            end
        end
    end
    return false
end

for _, name in ipairs({"Util","Common","Remotes","Assets","FX"}) do
    local c = ReplicatedStorage:FindFirstChild(name)
    if c then
        tryCapture(c)
        c.ChildAdded:Connect(function(ch)
            if ch:IsA("RemoteEvent") and ch:GetAttribute("Id") then
                RemoteId, capturedChild = ch:GetAttribute("Id"), ch
            end
        end)
    end
end

getgenv().VOidAttack = getgenv().VOidAttack or {}
local CFG = getgenv().VOidAttack

-- Limpar bloqueios locais deixados por uma execução anterior do VOID ATTACK.
pcall(function()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in ipairs(enemies:GetChildren()) do
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hrp then
                local lock = hrp:FindFirstChild("VOidLock")
                if lock then lock:Destroy() end
                local gyro = hrp:FindFirstChild("VOidGyro")
                if gyro then gyro:Destroy() end
            end
        end
    end
end)

-- FIX: o VOID ATTACK concorria com o CombatController/BringMob.
-- Fica desligado por defeito para não prender NPCs com BodyPosition/BodyGyro
-- nem bloquear o farming normal. O ataque normal do hub continua ativo.
CFG.Enabled          = false
CFG.Range            = CFG.Range            or 90
CFG.AttackPlayers    = CFG.AttackPlayers    ~= false
CFG.AttackMobs       = CFG.AttackMobs       ~= false
CFG.MultiHitCount    = CFG.MultiHitCount    or 3
CFG.MultiHitDelay    = CFG.MultiHitDelay    or 0.02
CFG.LoopDelay        = CFG.LoopDelay        or 0.01
CFG.MeleeDelay       = CFG.MeleeDelay       or 0.12
CFG.UseObfuscated    = CFG.UseObfuscated    ~= false
CFG.VisualActivate   = CFG.VisualActivate   ~= false
CFG.Paralyze         = false
CFG.ParalyzeTick     = CFG.ParalyzeTick     or 0.01
CFG.ResetCooldown    = CFG.ResetCooldown    ~= false

CFG.HitboxLimbs = CFG.HitboxLimbs or {
    "RightLowerArm","RightUpperArm","LeftLowerArm","LeftUpperArm",
    "RightHand","LeftHand","RightLowerLeg","LeftLowerLeg",
    "RightUpperLeg","LeftUpperLeg","RightFoot","LeftFoot",
    "Head","Torso","HumanoidRootPart"
}

local function GetValidator2()
    if not SUCCESS_SHOOT or not SHOOT_FUNCTION then
        return math.random(1, 99999999), 1
    end

    local v53 = getupvalue(SHOOT_FUNCTION, 13)
    local v54 = getupvalue(SHOOT_FUNCTION, 14)
    local v55 = getupvalue(SHOOT_FUNCTION, 15)
    local v56 = getupvalue(SHOOT_FUNCTION, 16)
    local v57 = getupvalue(SHOOT_FUNCTION, 17)
    local v58 = getupvalue(SHOOT_FUNCTION, 18)
    local v59 = getupvalue(SHOOT_FUNCTION, 19)

    local v93 = v53 * v54
    local v96 = (v55 * v54 + v53 * v56) % v57
    v96 = (v96 * v57 + v93) % v58
    v55 = math.floor(v96 / v57)
    v53 = v96 - v55 * v57
    v59 = v59 + 1

    setupvalue(SHOOT_FUNCTION, 13, v53)
    setupvalue(SHOOT_FUNCTION, 15, v55)
    setupvalue(SHOOT_FUNCTION, 19, v59)

    return math.floor(v96 / v58 * 16777215), v59
end

local function isAlive(m)
    local h = m and m:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getHitbox(m)
    for _ = 1, 6 do
        local name = CFG.HitboxLimbs[math.random(#CFG.HitboxLimbs)]
        local part = m:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    return m:FindFirstChild("HumanoidRootPart")
end

local function collectTargets(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return {} end
    local pos = root.Position
    local list = {}

    local function scan(folder)
        if not folder then return end
        for _, e in ipairs(folder:GetChildren()) do
            if e ~= char and isAlive(e) then
                local rp = e:FindFirstChild("HumanoidRootPart")
                if rp and (rp.Position - pos).Magnitude <= CFG.Range then
                    list[#list + 1] = e
                end
            end
        end
    end

    if CFG.AttackMobs    then scan(workspace:FindFirstChild("Enemies"))    end
    if CFG.AttackPlayers then scan(workspace:FindFirstChild("Characters")) end
    return list
end

local function buildConfig(targets)
    local cfg = {}
    for _, e in ipairs(targets) do
        local part = getHitbox(e)
        if part then cfg[#cfg + 1] = {e, part} end
    end
    return cfg
end

local function fireStandard(targets)
    local cfg = buildConfig(targets)
    if #cfg == 0 then return end

    local primary = cfg[1][1]:FindFirstChild("Head")
                    or cfg[1][1]:FindFirstChild("HumanoidRootPart")
    if not primary then return end

    RE_RegisterAttack:FireServer(0)
    RE_RegisterHit:FireServer(primary, cfg)
end

local function fireObfuscated(targets)
    if not (CFG.UseObfuscated and capturedChild and RemoteId) then return end
    local cfg = buildConfig(targets)
    if #cfg == 0 then return end

    local primary = cfg[1][1]:FindFirstChild("Head")
                    or cfg[1][1]:FindFirstChild("HumanoidRootPart")
    if not primary then return end

    pcall(function()
        RE_RegisterAttack:FireServer()
        local key1 = string.gsub("RE/RegisterHit", ".", function(ch)
            return string.char(bit32.bxor(string.byte(ch),
                math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1))
        end)
        local seed = Net.seed:InvokeServer() * 2
        local key2 = bit32.bxor(RemoteId + 909090, seed)
        cloneref(capturedChild):FireServer(key1, key2, primary, cfg)
    end)
end

local function clearAllCooldowns(tool)
    if not (CFG.ResetCooldown and tool) then return end
    pcall(function()
        for _, v in ipairs(tool:GetDescendants()) do
            if v:IsA("NumberValue") then
                local n = v.Name:lower()
                if n:find("cooldown") or n:find("cd") or n:find("reload") then
                    v.Value = 0
                end
            end
        end
    end)
end

local paralyzedMobs = {}

local function paralyzeMob(mob)
    if not CFG.Paralyze or not mob or not mob.Parent then return end

    local hrp = mob:FindFirstChild("HumanoidRootPart")
    local hum = mob:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local stored = paralyzedMobs[mob]
    local lockedPos = stored and stored.pos or hrp.Position
    if not stored then
        paralyzedMobs[mob] = { pos = lockedPos }
    end

    pcall(function()
        if setnetworkowner then setnetworkowner(mob, false) end
    end)

    pcall(function()
        hrp.Velocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(lockedPos, lockedPos + hrp.CFrame.LookVector)
    end)

    pcall(function()
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hum.JumpHeight = 0
        hum.AutoRotate = false
    end)

    pcall(function()
        local bp = hrp:FindFirstChild("VOidLock")
        if not bp then
            bp = Instance.new("BodyPosition")
            bp.Name = "VOidLock"
            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.P = 200000
            bp.D = 1000
            bp.Position = lockedPos
            bp.Parent = hrp
        else
            bp.Position = lockedPos
        end

        local bg = hrp:FindFirstChild("VOidGyro")
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.Name = "VOidGyro"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 200000
            bg.D = 1000
            bg.CFrame = CFrame.new(lockedPos, lockedPos + hrp.CFrame.LookVector)
            bg.Parent = hrp
        else
            bg.CFrame = CFrame.new(lockedPos, lockedPos + hrp.CFrame.LookVector)
        end
    end)
end

local function clearParalyze(mob)
    if not mob then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        if hrp:FindFirstChild("VOidLock") then hrp.VOidLock:Destroy() end
        if hrp:FindFirstChild("VOidGyro") then hrp.VOidGyro:Destroy() end
    end)
    paralyzedMobs[mob] = nil
end

local function attackMelee(char, tool, targets)
    for _, t in ipairs(targets) do paralyzeMob(t) end

    for i = 1, CFG.MultiHitCount do
        task.spawn(function()
            fireStandard(targets)
            fireObfuscated(targets)
        end)
        if i < CFG.MultiHitCount then task.wait(CFG.MultiHitDelay) end
    end

    if CFG.VisualActivate and tool then
        pcall(function() tool:Activate() end)
    end
end

local function attackFruit(char, tool, targets)
    for _, t in ipairs(targets) do paralyzeMob(t) end

    local remote = tool:FindFirstChild("LeftClickRemote")
    if not remote then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local trp  = targets[1]:FindFirstChild("HumanoidRootPart")
    if not (root and trp) then return end
    local dir = (trp.Position - root.Position).Unit
    pcall(function() remote:FireServer(dir, 1) end)
end

local function attackGun(char, tool, targets)
    for _, t in ipairs(targets) do paralyzeMob(t) end

    local hrp = targets[1]:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    clearAllCooldowns(tool)

    pcall(function()
        tool:SetAttribute("LocalTotalShots", (tool:GetAttribute("LocalTotalShots") or 0) + 1)
    end)

    pcall(function()
        GunValidator:FireServer(GetValidator2())
    end)

    pcall(function()
        RE_ShootGunEvent:FireServer(hrp.Position, { hrp })
    end)
end

local lastMelee = 0

task.spawn(function()
    while task.wait(CFG.LoopDelay) do
        if not CFG.Enabled or (getgenv().ElectroQuestActive and os.clock() - getgenv().ElectroQuestActive < 3) then continue end

        local char = LocalPlayer.Character
        if not char or not isAlive(char) then continue end

        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then continue end

        local tip = tool.ToolTip
        local now = os.clock()

        if tip == "Melee" or tip == "Sword" then
            if now - lastMelee >= CFG.MeleeDelay then
                local targets = collectTargets(char)
                if #targets > 0 then
                    lastMelee = now
                    pcall(attackMelee, char, tool, targets)
                end
            end

        elseif tip == "Blox Fruit" then
            local targets = collectTargets(char)
            if #targets > 0 then pcall(attackFruit, char, tool, targets) end

        elseif tip == "Gun" then
            local targets = collectTargets(char)
            if #targets > 0 then pcall(attackGun, char, tool, targets) end
        end
    end
end)

task.spawn(function()
    while task.wait(CFG.ParalyzeTick) do
        if not CFG.Enabled or not CFG.Paralyze then continue end

        local char = LocalPlayer.Character
        if not char then continue end

        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then continue end

        local tip = tool.ToolTip
        if tip ~= "Melee" and tip ~= "Sword" and tip ~= "Gun" and tip ~= "Blox Fruit" then
            continue
        end

        local targets = collectTargets(char)
        for _, t in ipairs(targets) do paralyzeMob(t) end

        for mob in pairs(paralyzedMobs) do
            if not mob.Parent or not isAlive(mob) then
                clearParalyze(mob)
            end
        end
    end
end)

getgenv().VOidAttack = CFG

end

-- Interface HEX Hub antiga removida; mantida a interface principal BombaCat Hub.

-- Iniciar o loop principal apenas depois de configurar as funções extras.
--============================================================
-- AUTO REDEEM CODES (bloco independente, corre mesmo que algo dentro de hoangtuveu() falhe)
--============================================================
task.spawn(function()
    local AUTO_REDEEM = true   -- põe false para desligar
    if not AUTO_REDEEM then return end

    -- Códigos de 2x EXP e outros (cada código só pode ser usado 1 vez por conta).
    local REDEEM_CODES = {
            -- 2x EXP
            "SUB2GAMERROBOT_EXP1",
            "EASTEREXP",
            "1lostadmin ",
            "Axiore",
            "TheGreatAce",
            "Sub2Fer999",
            "Enyu_is_Pro",
            "JCWK",
            "Starcodeheo",
            "Magicbus",
            "Kittgaming",
            "Sub2CaptainMaui",
            "Sub2OfficialNoobie",
            "Sub2NoobMaster123",
            "Sub2Daigrock",
            "StrawHatMaine",
            "TantaiGaming",
            "Bluxxy",
            -- Outros códigos que dão reset de stats, título ou Beli.
            "SUB2GAMERROBOT_RESET1",
            "Sub2UncleKizaru",
            "KITT_RESET",
            "Bignews",
            "Fudd10",
            "Fudd10_v2",
            "Chandler",
        }

    local RS = game:GetService("ReplicatedStorage")
    local HttpService = game:GetService("HttpService")
    if not game:IsLoaded() then game.Loaded:Wait() end
    repeat task.wait(1) until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
    task.wait(5)

    -- procura o remote de códigos: Remotes.Redeem (usado pelo menu de códigos) e, em segundo, CommF_
    local remotes = RS:WaitForChild("Remotes", 30)
    if not remotes then
        warn("[BombaCat Hub] AutoRedeem: pasta ReplicatedStorage.Remotes não encontrada.")
        return
    end
    local remote, mode
    for _ = 1, 30 do
        local r = remotes:FindFirstChild("Redeem")
        if r and r:IsA("RemoteFunction") then remote, mode = r, "Redeem" break end
        task.wait(1)
    end
    if not remote then
        local c = remotes:FindFirstChild("CommF_")
        if c and c:IsA("RemoteFunction") then remote, mode = c, "CommF_" end
    end
    if not remote then
        warn("[BombaCat Hub] AutoRedeem: nenhum RemoteFunction de códigos encontrado (Remotes.Redeem / CommF_).")
        return
    end
    print("[BombaCat Hub] AutoRedeem a usar remote: Remotes." .. remote.Name .. " | códigos: " .. #REDEEM_CODES)

    for _, code in ipairs(REDEEM_CODES) do
        local ok, result = pcall(function()
            if mode == "Redeem" then
                return remote:InvokeServer(code)
            end
            return remote:InvokeServer("Redeem", code)
        end)
        local shown
        if not ok then
            shown = "ERRO: " .. tostring(result)
        elseif typeof(result) == "table" then
            local okJ, txt = pcall(function() return HttpService:JSONEncode(result) end)
            shown = okJ and txt or tostring(result)
        else
            shown = tostring(result)
        end
        print("[BombaCat Hub] [" .. code .. "] -> " .. shown)
        task.wait(1.5)
    end
    print("[BombaCat Hub] AutoRedeem terminou.")
end)

--============================================================
-- DIAGNÓSTICO BOMBACAT (só imprime no console, não altera o farm)
-- Mostra quando o personagem morre e quando é movido de repente para longe.
--============================================================
task.spawn(function()
    local lp = game.Players.LocalPlayer
    local function taskInfo()
        local T = (ScriptStorage and ScriptStorage.Task) or {}
        return tostring(T.MainTask) .. " | " .. tostring(T.SubTask)
    end
    local function hook(char)
        local hum = char:WaitForChild("Humanoid", 15)
        if hum then
            hum.Died:Connect(function()
                local r = char:FindFirstChild("HumanoidRootPart")
                print("[BombaCat Debug] PERSONAGEM MORREU em " .. (r and tostring(r.Position) or "?") .. " | " .. taskInfo())
            end)
        end
    end
    if lp.Character then task.spawn(hook, lp.Character) end
    lp.CharacterAdded:Connect(function(c)
        print("[BombaCat Debug] reapareceu | " .. taskInfo())
        hook(c)
    end)

    local last
    while task.wait(0.4) do
        local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if r then
            if last and (r.Position - last).Magnitude > 600 and not getgenv().OnFarm then
                print("[BombaCat Debug] salto de " .. math.floor((r.Position - last).Magnitude) .. " studs sem voo | " .. taskInfo())
            end
            last = r.Position
        end
    end
end)

--============================================================
-- SALTAR NPC DA QUEST SECRETA DA PRISÃO
-- Quando aparece "Confront the prisoner before attacking!", o NPC atual é ignorado
-- (10 min) e o script passa para outro prisioneiro.
--============================================================
task.spawn(function()
    local lp = game.Players.LocalPlayer
    local pg = lp:WaitForChild("PlayerGui")
    local PHRASE = "confront the prisoner"
    local lastHit = 0
    local function check(txt)
        if type(txt) ~= "string" or txt == "" then return end
        if string.find(string.lower(txt), PHRASE, 1, true) and os.clock() - lastHit > 0.8 then
            lastHit = os.clock()
            local mob = MonResult
            if mob and CombatController and CombatController.Skip then
                CombatController.Skip(mob, "Confront the prisoner")
            end
        end
    end
    local hooked = setmetatable({}, {__mode = "k"})
    local function hook(o)
        if hooked[o] then return end
        if o:IsA("TextLabel") or o:IsA("TextButton") then
            hooked[o] = true
            check(o.Text)
            o:GetPropertyChangedSignal("Text"):Connect(function() check(o.Text) end)
        end
    end
    for _, d in ipairs(pg:GetDescendants()) do hook(d) end
    pg.DescendantAdded:Connect(hook)
end)

hoangtuveu()
