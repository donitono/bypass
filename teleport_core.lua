--[[
    TELEPORT CORE - Complete Teleport System
    Extracted from super.lua - Clean Version
    Author: donitono
    Date: September 13, 2025
    
    Features:
    - Complete teleport locations database
    - GPS coordinate system
    - Dynamic zone detection
    - Event location tracking
    - Safe teleportation with validation
    - Category-based organization
]]--

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Variables
local lp = Players.LocalPlayer

--// TELEPORT LOCATIONS DATABASE

local TeleportLocations = {
    ['Zones'] = {
        ['Moosewood'] = CFrame.new(379.875458, 134.500519, 233.5495, -0.033920113, 8.13274355e-08, 0.999424577, 8.98441925e-08, 1, -7.83249803e-08, -0.999424577, 8.7135696e-08, -0.033920113),
        ['Roslit Bay'] = CFrame.new(-1472.9812, 132.525513, 707.644531, -0.00177415239, 1.15743369e-07, -0.99999845, -9.25943056e-09, 1, 1.15759981e-07, 0.99999845, 9.46479251e-09, -0.00177415239),
        ['Forsaken Shores'] = CFrame.new(-2491.104, 133.250015, 1561.2926, 0.355353981, -1.68352852e-08, -0.934731781, 4.69647858e-08, 1, -1.56367586e-10, 0.934731781, -4.38439116e-08, 0.355353981),
        ['Sunstone Island'] = CFrame.new(-913.809143, 138.160782, -1133.25879, -0.746701241, 4.50330218e-09, 0.665159583, 2.84934609e-09, 1, -3.5716119e-09, -0.665159583, -7.71657294e-10, -0.746701241),
        ['Statue of Sovereignty'] = CFrame.new(21.4017925, 159.014709, -1039.14233, -0.865476549, -4.38348664e-08, -0.500949502, -9.38435818e-08, 1, 7.46273798e-08, 0.500949502, 1.11599142e-07, -0.865476549),
        ['Terrapin Island'] = CFrame.new(-193.434143, 135.121979, 1951.46936, 0.512723684, -6.94711346e-08, 0.858553708, 5.44089183e-08, 1, 4.84237539e-08, -0.858553708, 2.18849721e-08, 0.512723684),
        ['Snowcap Island'] = CFrame.new(2607.93018, 135.284332, 2436.13208, 0.909039497, -7.49003748e-10, 0.4167099, 3.38659367e-09, 1, -5.59032465e-09, -0.4167099, 6.49305321e-09, 0.909039497),
        ['Mushgrove Swamp'] = CFrame.new(2434.29785, 131.983276, -691.930542, -0.123090521, -7.92820209e-09, -0.992395461, -9.05862692e-08, 1, 3.2467995e-09, 0.992395461, 9.02970569e-08, -0.123090521),
        ['Ancient Isle'] = CFrame.new(6056.02783, 195.280167, 276.270325, -0.655055285, 1.96010075e-09, 0.755580962, -1.63855578e-08, 1, -1.67997189e-08, -0.755580962, -2.33853594e-08, -0.655055285),
        ['Northern Expedition'] = CFrame.new(-1701.02979, 187.638779, 3944.81494, 0.918493569, -8.5804345e-08, 0.395435959, 8.59132356e-08, 1, 1.74328942e-08, -0.395435959, 1.7961181e-08, 0.918493569),
        ['Northern Summit'] = CFrame.new(19608.791, 131.420105, 5222.15283, 0.462794542, -2.64426987e-08, 0.886465549, -4.47066562e-08, 1, 5.31692343e-08, -0.886465549, -6.42373408e-08, 0.462794542),
        ['Vertigo'] = CFrame.new(-102.40567, -513.299377, 1052.07104, -0.999989033, 5.36423439e-09, 0.00468267547, 5.85247495e-09, 1, 1.04251647e-07, -0.00468267547, 1.04277916e-07, -0.999989033),
        ['Depths Entrance'] = CFrame.new(-15.4965982, -706.123718, 1231.43494, 0.0681341439, 1.15903154e-08, -0.997676194, 7.1017638e-08, 1, 1.64673093e-08, 0.997676194, -7.19745898e-08, 0.0681341439),
        ['The Depths'] = CFrame.new(491.758118, -706.123718, 1230.6377, 0.00879980437, 1.29271776e-08, -0.999961257, 1.95575205e-13, 1, 1.29276803e-08, 0.999961257, -1.13956629e-10, 0.00879980437),
        ['Desolate Deep'] = CFrame.new(491.758118, -706.123718, 1230.6377, 0.00879980437, 1.29271776e-08, -0.999961257, 1.95575205e-13, 1, 1.29276803e-08, 0.999961257, -1.13956629e-10, 0.00879980437),
        ['Overgrowth Caves'] = CFrame.new(19746.2676, 416.00293, 5403.5752, 0.999998748, -6.46175897e-08, 0.00157937454, 6.46226978e-08, 1, -5.95676129e-08, -0.00157937454, 5.95796072e-08, 0.999998748),
        ['Frigid Cavern'] = CFrame.new(20253.6094, 756.525818, 5772.68555, 0.999998748, -6.46175897e-08, 0.00157937454, 6.46226978e-08, 1, -5.95676129e-08, -0.00157937454, 5.95796072e-08, 0.999998748),
    },
    ['NPCs'] = {
        -- Merchants & NPCs
        ['Merchant'] = CFrame.new(415, 135, 200),
        ['Shipwright'] = CFrame.new(320, 135, 275),
        ['Angler'] = CFrame.new(500, 135, 250),
        ['Rod Dealer'] = CFrame.new(450, 135, 300),
        ['Bait Dealer'] = CFrame.new(380, 135, 180),
        ['Inn Keeper'] = CFrame.new(480, 135, 220),
        ['Mod Keeper'] = CFrame.new(365, 135, 190),
        ['Appraiser'] = CFrame.new(420, 145, 260),
        ['AFK Rewards'] = CFrame.new(232, 139, 38),
        
        -- Special NPCs
        ['Sea Traveler'] = CFrame.new(140, 150, 2030),
        ['Treasure Hunting'] = CFrame.new(-2825, 215, 1515),
        ['Gilded Arch'] = CFrame.new(450, 90, 2850),
        ['Trade Plaza'] = CFrame.new(535, 82, 775),
    },
    ['Items & Gear'] = {
        -- Diving Gear
        ['Advanced Diving Gear (Atlantis)'] = CFrame.new(-4452, -603, 1877),
        ['Conception Conch (Atlantis)'] = CFrame.new(-4450, -605, 1874),
        ['Advanced Diving Gear (Desolate)'] = CFrame.new(-790, 125, -3100),
        ['Basic Diving Gear (Desolate)'] = CFrame.new(-1655, -210, -2825),
        ['Tidebreaker'] = CFrame.new(-1645, -210, -2855),
        ['Conception Conch (Desolate)'] = CFrame.new(-1630, -210, -2860),
        ['Aurora Totem'] = CFrame.new(-1800, -135, -3280),
        
        -- Equipment
        ['Bait Crate (Forsaken)'] = CFrame.new(-2490, 130, 1535),
        ['Crab Cage (Forsaken)'] = CFrame.new(-2525, 135, -1575),
        ['Rod of the Zenith'] = CFrame.new(-13625, -11035, 355),
        ['Abyssal Zenith Upgrade'] = CFrame.new(-13515, -11050, 175),
    },
    ['Events & Special'] = {
        -- Event Locations
        ['Archaeological Site'] = CFrame.new(4160, 125, 210),
        ['Grand Reef'] = CFrame.new(-3530, 130, 550),
        ['Atlantean Storm'] = CFrame.new(-3820, 135, 575),
        
        -- Special Areas
        ['FischFright24'] = "dynamic", -- Uses selectedZone.Position
        ['Isonade'] = "dynamic", -- Uses selectedZone.Position
        ['Bluefin Tuna Abundance'] = "abundance", -- Special abundance detection
        ['Swordfish Abundance'] = "abundance", -- Special abundance detection
        
        -- Boss Locations
        ['Cthulhu Boss'] = CFrame.new(-200, 130, 1925),
        ['Kraken Area'] = CFrame.new(1000, 125, -1250),
    },
    ['Chest Locations'] = {
        ['Sunken Chest #1'] = CFrame.new(936, 130, -159),
        ['Sunken Chest #2'] = CFrame.new(-1179, 130, 565),
        ['Sunken Chest #3'] = CFrame.new(-1765, 130, -1040),
        ['Sunken Chest #4'] = CFrame.new(1685, 130, -505),
        ['Sunken Chest #5'] = CFrame.new(880, 130, -1405),
        ['Sunken Chest #6'] = CFrame.new(-2795, 130, 1460),
        ['Sunken Chest #7'] = CFrame.new(-1845, 130, 1710),
        ['Sunken Chest #8'] = CFrame.new(1450, 130, 2420),
        ['Sunken Chest #9'] = CFrame.new(1685, 130, -1475),
        ['Sunken Chest #10'] = CFrame.new(-1030, 130, -2180),
    },
    ['Caves & Underground'] = {
        -- Ice Caves
        ['Ice Rocks Cave'] = CFrame.new(-800, -3280, -625),
        ['Ice Fishing Cave (Central)'] = CFrame.new(-760, -3280, -715),
        ['Ice Portal Back'] = CFrame.new(-735, -3280, -725),
        
        -- Abyssal Zenith
        ['Hidden River (Calm Zone)'] = CFrame.new(-4305, -11230, 1955),
        ['Calm Zone'] = CFrame.new(-4145, -11210, 1395),
        ['Crossbow Arrow (East)'] = CFrame.new(-2300, -11190, 7140),
        ['Crossbow Bow'] = CFrame.new(-4800, -11185, 6610),
        ['Crossbow Arrow (West)'] = CFrame.new(-4035, -11185, 6510),
        ['Hidden River'] = CFrame.new(-4330, -11180, 3120),
        ['Crossbow Base'] = CFrame.new(-4345, -11155, 6490),
        ['Crossbow Base (Main)'] = CFrame.new(-4360, -11090, 7140),
        ['Zenith Tunnel End'] = CFrame.new(-13420, -11050, 110),
        
        -- Other Caves
        ['Keepers Altar'] = CFrame.new(1305, -815, -270),
        ['Vertigo Caves'] = CFrame.new(-110, -515, 1040),
    },
    ['Fishing Spots'] = {
        -- Ocean Spots
        ['Ocean Spot #1'] = CFrame.new(-1270, 125, 1580),
        ['Ocean Spot #2'] = CFrame.new(1000, 125, -1250),
        ['Ocean Spot #3'] = CFrame.new(-530, 125, -425),
        ['Ocean Spot #4'] = CFrame.new(1230, 125, 575),
        ['Ocean Spot #5'] = CFrame.new(1700, 125, -2500),
        
        -- Specialized Fishing Areas
        ['Deep Ocean'] = CFrame.new(1521, 126, -3543),
        ['Desolate Deep Fishing'] = CFrame.new(-1068, 126, -3108),
        ['Hadal Blacksite'] = CFrame.new(5499, 126, 326),
        ['Brine Pool'] = CFrame.new(1710, 126, -3543),
        ['The Abyss'] = CFrame.new(1500, -2490, -3500),
        
        -- Island Fishing Spots
        ['Castaway Cliffs'] = CFrame.new(690, 135, -1693),
        ['Netters Haven'] = CFrame.new(-635, 85, 1005),
        ['Waveborne'] = CFrame.new(360, 90, 780),
        ['Lushgrove'] = CFrame.new(1133, 105, -560),
        ['Emberreach'] = CFrame.new(2390, 83, -490),
        ['Azure Lagoon'] = CFrame.new(-3550, 130, 568),
        ['Winter Village'] = CFrame.new(5815, 145, 270),
    },
    ['Mariana Veil'] = {
        ['Mariana #1'] = CFrame.new(-4305, -11230, 1955),
        ['Mariana #2'] = CFrame.new(-4145, -11210, 1395),
        ['Mariana #3'] = CFrame.new(-2300, -11190, 7140),
        ['Mariana #4'] = CFrame.new(-4800, -11185, 6610),
        ['Mariana #5'] = CFrame.new(-4035, -11185, 6510),
    }
}

-- Zone Cast Coordinates for fishing automation
local ZoneCastCoordinates = {
    -- Event Zones (Dynamic)
    ['FischFright24'] = "dynamic",
    ['Isonade'] = "dynamic", 
    ['Bluefin Tuna Abundance'] = "abundance",
    ['Swordfish Abundance'] = "abundance",
    
    -- Regular Fishing Zones
    ['Deep Ocean'] = CFrame.new(1521, 126, -3543),
    ['Desolate Deep'] = CFrame.new(-1068, 126, -3108),
    ['Hadal Blacksite'] = CFrame.new(5499, 126, 326),
    ['Brine Pool'] = CFrame.new(1710, 126, -3543),
    ['The Abyss'] = CFrame.new(1500, -2490, -3500),
    ['Mushgrove Swamp'] = CFrame.new(2434, 131, -692),
    ['Roslit Bay'] = CFrame.new(-1472, 132, 707),
    ['Moosewood'] = CFrame.new(379, 134, 233),
    ['Sunstone Island'] = CFrame.new(-913, 138, -1133),
    ['Forsaken Shores'] = CFrame.new(-2491, 133, 1561),
    ['Ancient Isle'] = CFrame.new(6056, 195, 276),
}

-- Create combined locations list for easy access
local AllLocationNames = {}
local AllLocations = {}

for category, locations in pairs(TeleportLocations) do
    for name, cframe in pairs(locations) do
        if typeof(cframe) == "CFrame" then
            table.insert(AllLocationNames, name)
            AllLocations[name] = cframe
        end
    end
end

-- Sort alphabetically
table.sort(AllLocationNames)

--// EVENT TRACKING SYSTEM

local EVENTS_DATA = {
    -- Weather Events
    ["Clear Skies"] = {color = Color3.fromRGB(135, 206, 235), zones = {"Ocean", "Moosewood", "Roslit Bay"}},
    ["Foggy Weather"] = {color = Color3.fromRGB(128, 128, 128), zones = {"Ocean", "Forsaken Shores"}},
    ["Windy Weather"] = {color = Color3.fromRGB(173, 216, 230), zones = {"Ocean", "Snowcap Island"}},
    ["Rough Seas"] = {color = Color3.fromRGB(70, 130, 180), zones = {"Ocean", "Deep Ocean"}},
    
    -- Special Events
    ["Meteor Shower"] = {color = Color3.fromRGB(255, 69, 0), zones = {"Ocean", "Ancient Isle"}},
    ["Aurora Borealis"] = {color = Color3.fromRGB(127, 255, 212), zones = {"Northern Expedition", "Snowcap Island"}},
    ["Solar Eclipse"] = {color = Color3.fromRGB(25, 25, 112), zones = {"Ocean", "Statue of Sovereignty"}},
    ["Lunar Eclipse"] = {color = Color3.fromRGB(139, 0, 139), zones = {"Ocean", "Moonstone Island"}},
    ["Blue Moon"] = {color = Color3.fromRGB(100, 100, 255), zones = {"Ocean", "Pond"}},
    
    -- Special Encounters
    ["Travelling Merchant"] = {color = Color3.fromRGB(255, 165, 0), zones = {"Ocean", "Moosewood"}},
    ["Sunken Chests"] = {color = Color3.fromRGB(255, 215, 0), zones = {"Ocean", "The Depths"}},
}

local ZONE_COORDS = {
    ["Ocean"] = CFrame.new(100, 150, 100),
    ["Moosewood"] = TeleportLocations.Zones["Moosewood"],
    ["Roslit Bay"] = TeleportLocations.Zones["Roslit Bay"],
    ["Forsaken Shores"] = TeleportLocations.Zones["Forsaken Shores"],
    ["Sunstone Island"] = TeleportLocations.Zones["Sunstone Island"],
    ["Snowcap Island"] = TeleportLocations.Zones["Snowcap Island"],
    ["Ancient Isle"] = TeleportLocations.Zones["Ancient Isle"],
    ["Northern Expedition"] = TeleportLocations.Zones["Northern Expedition"],
    ["Statue of Sovereignty"] = TeleportLocations.Zones["Statue of Sovereignty"],
    ["The Depths"] = TeleportLocations.Zones["The Depths"],
    ["Deep Ocean"] = CFrame.new(1521, 126, -3543),
}

--// UTILITY FUNCTIONS

-- Get HumanoidRootPart
local function gethrp()
    return lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
end

-- Safe teleport with validation
local function safeTeleport(targetCFrame)
    if not targetCFrame or typeof(targetCFrame) ~= "CFrame" then
        return false, "Invalid CFrame"
    end
    
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return false, "Character not found"
    end
    
    pcall(function()
        lp.Character.HumanoidRootPart.CFrame = targetCFrame
    end)
    
    return true, "Teleported successfully"
end

-- Smooth teleport with tween
local function smoothTeleport(targetCFrame, duration)
    duration = duration or 1
    
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return false, "Character not found"
    end
    
    local humanoidRootPart = lp.Character.HumanoidRootPart
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    return true, "Smooth teleport started"
end

-- Find location by name
local function findLocation(locationName)
    return AllLocations[locationName]
end

-- Get all locations in category
local function getLocationsByCategory(category)
    return TeleportLocations[category] or {}
end

-- Get nearest location to current position
local function getNearestLocation()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return nil, nil, math.huge
    end
    
    local currentPos = lp.Character.HumanoidRootPart.Position
    local nearestName = nil
    local nearestCFrame = nil
    local nearestDistance = math.huge
    
    for name, cframe in pairs(AllLocations) do
        local distance = (currentPos - cframe.Position).Magnitude
        if distance < nearestDistance then
            nearestDistance = distance
            nearestName = name
            nearestCFrame = cframe
        end
    end
    
    return nearestName, nearestCFrame, nearestDistance
end

-- Dynamic zone detection
local function getDynamicZonePosition(zoneName)
    if zoneName == "FischFright24" or zoneName == "Isonade" then
        local selectedZone = workspace.zones and workspace.zones.fishing and workspace.zones.fishing:FindFirstChild(zoneName)
        if selectedZone then
            return CFrame.new(selectedZone.Position.X, 126, selectedZone.Position.Z)
        end
    elseif zoneName:find("Abundance") then
        local selectedZone = workspace.zones and workspace.zones.fishing and workspace.zones.fishing:FindFirstChild("Deep Ocean")
        if selectedZone then
            local abundanceValue = selectedZone:FindFirstChild("Abundance")
            if abundanceValue then
                if (zoneName == "Bluefin Tuna Abundance" and abundanceValue.Value == "Bluefin Tuna") or
                   (zoneName == "Swordfish Abundance" and abundanceValue.Value == "Swordfish") then
                    return CFrame.new(selectedZone.Position.X, 126.564, selectedZone.Position.Z)
                end
            end
        end
    end
    
    return nil
end

--// GPS COORDINATE SYSTEM

local GPS = {
    x = 0,
    y = 150,
    z = 0
}

-- Set GPS coordinates
local function setGPS(x, y, z)
    GPS.x = x or GPS.x
    GPS.y = y or GPS.y
    GPS.z = z or GPS.z
end

-- Get current position as GPS
local function getCurrentGPS()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local pos = lp.Character.HumanoidRootPart.Position
        return {
            x = math.floor(pos.X * 100) / 100,
            y = math.floor(pos.Y * 100) / 100,
            z = math.floor(pos.Z * 100) / 100
        }
    end
    return nil
end

-- Teleport to GPS coordinates
local function teleportToGPS(x, y, z)
    x = x or GPS.x
    y = y or GPS.y  
    z = z or GPS.z
    
    return safeTeleport(CFrame.new(x, y, z))
end

-- Parse GPS coordinates from text
local function parseGPSFromText(text)
    local coords = {}
    local cleanText = text:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1") -- Clean whitespace
    
    -- Try different formats
    for coord in cleanText:gmatch("([-]?%d*%.?%d+)") do
        local num = tonumber(coord)
        if num then
            table.insert(coords, num)
        end
    end
    
    if #coords >= 2 then
        return {
            x = coords[1],
            y = coords[3] or 150, -- Default Y if not provided
            z = coords[2]
        }
    end
    
    return nil
end

--// PUBLIC API

local TeleportCore = {}

-- Basic teleport functions
function TeleportCore.Teleport(locationName)
    local targetCFrame = findLocation(locationName)
    if targetCFrame then
        return safeTeleport(targetCFrame)
    else
        return false, "Location not found: " .. tostring(locationName)
    end
end

function TeleportCore.TeleportSmooth(locationName, duration)
    local targetCFrame = findLocation(locationName)
    if targetCFrame then
        return smoothTeleport(targetCFrame, duration)
    else
        return false, "Location not found: " .. tostring(locationName)
    end
end

function TeleportCore.TeleportToCFrame(cframe)
    return safeTeleport(cframe)
end

-- GPS functions
function TeleportCore.SetGPS(x, y, z)
    setGPS(x, y, z)
end

function TeleportCore.GetCurrentGPS()
    return getCurrentGPS()
end

function TeleportCore.TeleportToGPS(x, y, z)
    return teleportToGPS(x, y, z)
end

function TeleportCore.ParseGPS(text)
    return parseGPSFromText(text)
end

-- Zone and location functions
function TeleportCore.GetAllLocations()
    return AllLocations
end

function TeleportCore.GetLocationsByCategory(category)
    return getLocationsByCategory(category)
end

function TeleportCore.GetCategories()
    local categories = {}
    for category in pairs(TeleportLocations) do
        table.insert(categories, category)
    end
    return categories
end

function TeleportCore.FindLocation(name)
    return findLocation(name)
end

function TeleportCore.GetNearestLocation()
    return getNearestLocation()
end

-- Zone casting support
function TeleportCore.GetZoneCastCoordinates()
    return ZoneCastCoordinates
end

function TeleportCore.GetDynamicZonePosition(zoneName)
    return getDynamicZonePosition(zoneName)
end

-- Event tracking
function TeleportCore.GetEventsData()
    return EVENTS_DATA
end

function TeleportCore.TeleportToEvent(eventName)
    local eventData = EVENTS_DATA[eventName]
    if eventData and #eventData.zones > 0 then
        local targetZone = eventData.zones[1]
        local targetCoord = ZONE_COORDS[targetZone]
        if targetCoord then
            return safeTeleport(targetCoord)
        end
    end
    return false, "Event location not found: " .. tostring(eventName)
end

-- Utility functions
function TeleportCore.GetAllLocationNames()
    return AllLocationNames
end

function TeleportCore.GetLocationCount()
    return #AllLocationNames
end

function TeleportCore.SearchLocations(query)
    local results = {}
    local lowerQuery = query:lower()
    
    for _, name in pairs(AllLocationNames) do
        if name:lower():find(lowerQuery) then
            table.insert(results, name)
        end
    end
    
    return results
end

-- Advanced teleport features
function TeleportCore.TeleportToRandomLocation()
    if #AllLocationNames > 0 then
        local randomName = AllLocationNames[math.random(1, #AllLocationNames)]
        return TeleportCore.Teleport(randomName)
    end
    return false, "No locations available"
end

function TeleportCore.TeleportToCategory(category)
    local locations = getLocationsByCategory(category)
    local locationNames = {}
    
    for name in pairs(locations) do
        table.insert(locationNames, name)
    end
    
    if #locationNames > 0 then
        local randomName = locationNames[math.random(1, #locationNames)]
        return TeleportCore.Teleport(randomName)
    end
    
    return false, "No locations in category: " .. tostring(category)
end

return TeleportCore