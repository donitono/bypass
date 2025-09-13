--[[
    Rayfield UI Template - Modifiable Version
    Created for easy customization and expansion
    Author: GitHub Copilot Assistant
    Date: September 13, 2025
]]--

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Load Automation Core
local AutomationCore = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/automation_core.lua'))()

-- Load Teleport Core
local TeleportCore = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/teleport_core.lua'))()

-- UI Configuration
local UIConfig = {
    Name = "Bypass Hub",
    LoadingTitle = "Bypass Interface Suite",
    LoadingSubtitle = "by donitono",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BypassHub",
        FileName = "config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Bypass Hub",
        Subtitle = "Key System",
        Note = "Enter the key to access",
        FileName = "key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"BYPASS2025"}
    }
}

-- Create Main Window
local Window = Rayfield:CreateWindow(UIConfig)

-- Variables for features
local Features = {
    -- Auto Fishing
    AutoFishing = false,
    AutoCast = false,
    AutoReel = false,
    AutoShake = false,
    
    -- Delays
    CastDelay = 0.1,
    ReelDelay = 0.1,
    ShakeDelay = 0.1,
    
    -- Visual
    ESPEnabled = false,
    TracersEnabled = false,
    
    -- Teleport
    TeleportSpeed = 16,
    
    -- Misc
    WalkSpeed = 16,
    JumpPower = 50,
    NoClip = false
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

--// UTILITY FUNCTIONS
local Utils = {}

function Utils.Notify(title, content, duration)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3,
        Image = 4483362458,
        Actions = {
            Ignore = {
                Name = "OK",
                Callback = function() end
            }
        }
    })
end

function Utils.ToggleFeature(featureName, state)
    Features[featureName] = state
    print(featureName .. " set to: " .. tostring(state))
end

function Utils.SetDelay(delayType, value)
    Features[delayType] = value
    print(delayType .. " set to: " .. tostring(value))
end

--// MAIN TAB
local MainTab = Window:CreateTab("🏠 Main", 4483362458)

local MainSection = MainTab:CreateSection("Main Controls")

local AutoFishingToggle = MainTab:CreateToggle({
    Name = "Auto Fishing (Master)",
    CurrentValue = false,
    Flag = "AutoFishingMaster",
    Callback = function(Value)
        AutomationCore.SetFlag("autofishingloop", Value)
        Utils.ToggleFeature("AutoFishing", Value)
        if Value then
            Utils.Notify("Auto Fishing", "Master toggle enabled", 2)
        else
            Utils.Notify("Auto Fishing", "Master toggle disabled", 2)
        end
    end,
})

local AutoCastToggle = MainTab:CreateToggle({
    Name = "Auto Cast",
    CurrentValue = false,
    Flag = "AutoCast",
    Callback = function(Value)
        AutomationCore.SetFlag("autocast", Value)
        Utils.ToggleFeature("AutoCast", Value)
        Utils.Notify("Auto Cast", Value and "Enabled" or "Disabled", 2)
    end,
})

local AutoReelToggle = MainTab:CreateToggle({
    Name = "Auto Reel",
    CurrentValue = false,
    Flag = "AutoReel",
    Callback = function(Value)
        AutomationCore.SetFlag("autoreel", Value)
        Utils.ToggleFeature("AutoReel", Value)
        Utils.Notify("Auto Reel", Value and "Enabled" or "Disabled", 2)
    end,
})

local AutoShakeToggle = MainTab:CreateToggle({
    Name = "Auto Shake",
    CurrentValue = false,
    Flag = "AutoShake",
    Callback = function(Value)
        AutomationCore.SetFlag("autoshake", Value)
        Utils.ToggleFeature("AutoShake", Value)
        Utils.Notify("Auto Shake", Value and "Enabled" or "Disabled", 2)
    end,
})

-- Advanced Fishing Features
local SuperInstantToggle = MainTab:CreateToggle({
    Name = "Super Instant Reel",
    CurrentValue = false,
    Flag = "SuperInstantReel",
    Callback = function(Value)
        AutomationCore.SetFlag("superinstantreel", Value)
        Utils.Notify("Super Instant Reel", Value and "Enabled - Ultra fast catch!" or "Disabled", 2)
    end,
})

local InstantBobberToggle = MainTab:CreateToggle({
    Name = "Instant Bobber",
    CurrentValue = false,
    Flag = "InstantBobber",
    Callback = function(Value)
        AutomationCore.SetFlag("instantbobber", Value)
        Utils.Notify("Instant Bobber", Value and "Enabled - No cast animation!" or "Disabled", 2)
    end,
})

local PredictiveCastToggle = MainTab:CreateToggle({
    Name = "Predictive AutoCast",
    CurrentValue = false,
    Flag = "Predictivecast",
    Callback = function(Value)
        AutomationCore.SetFlag("predictiveautocast", Value)
        Utils.Notify("Predictive Cast", Value and "Enabled - Zero gap casting!" or "Disabled", 2)
    end,
})

local AutoAppraiseToggle = MainTab:CreateToggle({
    Name = "Auto Appraise Fish",
    CurrentValue = false,
    Flag = "AutoAppraise",
    Callback = function(Value)
        AutomationCore.SetFlag("autoappraise", Value)
        Utils.Notify("Auto Appraise", Value and "Enabled - Auto appraise fish!" or "Disabled", 2)
    end,
})

--// SETTINGS TAB
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

local DelaySection = SettingsTab:CreateSection("Delay Settings")

local CastDelaySlider = SettingsTab:CreateSlider({
    Name = "Cast Delay (seconds)",
    Range = {0.01, 5},
    Increment = 0.01,
    CurrentValue = 0.1,
    Flag = "CastDelay",
    Callback = function(Value)
        AutomationCore.SetFlag("autocastdelay", Value)
        Utils.SetDelay("CastDelay", Value)
    end,
})

local ReelDelaySlider = SettingsTab:CreateSlider({
    Name = "Reel Delay (seconds)",
    Range = {0.01, 5},
    Increment = 0.01,
    CurrentValue = 0.1,
    Flag = "ReelDelay",
    Callback = function(Value)
        AutomationCore.SetFlag("autoreeldelay", Value)
        Utils.SetDelay("ReelDelay", Value)
    end,
})

local ShakeDelaySlider = SettingsTab:CreateSlider({
    Name = "Shake Delay (seconds)",
    Range = {0.01, 5},
    Increment = 0.01,
    CurrentValue = 0.1,
    Flag = "ShakeDelay",
    Callback = function(Value)
        -- Shake delay is handled internally by automation core
        Utils.SetDelay("ShakeDelay", Value)
    end,
})

local AppraiseDelaySlider = SettingsTab:CreateSlider({
    Name = "Appraise Delay (seconds)",
    Range = {0.5, 10},
    Increment = 0.1,
    CurrentValue = 1.0,
    Flag = "AppraiseDelay",
    Callback = function(Value)
        AutomationCore.SetFlag("appraisedelay", Value)
    end,
})

--// VISUAL TAB
local VisualTab = Window:CreateTab("👁️ Visual", 4483362458)

local ESPSection = VisualTab:CreateSection("ESP & Visual Features")

local ESPToggle = VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        Utils.ToggleFeature("ESPEnabled", Value)
        Utils.Notify("ESP", Value and "Enabled" or "Disabled", 2)
    end,
})

local TracersToggle = VisualTab:CreateToggle({
    Name = "Enable Tracers",
    CurrentValue = false,
    Flag = "Tracers",
    Callback = function(Value)
        Utils.ToggleFeature("TracersEnabled", Value)
        Utils.Notify("Tracers", Value and "Enabled" or "Disabled", 2)
    end,
})

--// PLAYER TAB
local PlayerTab = Window:CreateTab("🏃 Player", 4483362458)

local MovementSection = PlayerTab:CreateSection("Movement Settings")

local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Features.WalkSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
        Utils.Notify("Walk Speed", "Set to " .. Value, 1)
    end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {1, 200},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        Features.JumpPower = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
        Utils.Notify("Jump Power", "Set to " .. Value, 1)
    end,
})

local NoClipToggle = PlayerTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        Utils.ToggleFeature("NoClip", Value)
        Utils.Notify("No Clip", Value and "Enabled" or "Disabled", 2)
        
        -- NoClip implementation
        if Value then
            spawn(function()
                while Features.NoClip and LocalPlayer.Character do
                    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    wait()
                end
            end)
        else
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local FreezeCharacterToggle = PlayerTab:CreateToggle({
    Name = "Freeze Character",
    CurrentValue = false,
    Flag = "FreezeCharacter",
    Callback = function(Value)
        AutomationCore.SetFlag("freezechar", Value)
        Utils.Notify("Freeze Character", Value and "Enabled - Character frozen!" or "Disabled", 2)
    end,
})

local FreezeModeOptions = {"Toggled", "Rod Equipped"}
local FreezeModeDropdown = PlayerTab:CreateDropdown({
    Name = "Freeze Mode",
    Options = FreezeModeOptions,
    CurrentOption = "Toggled",
    Flag = "FreezeMode",
    Callback = function(Option)
        AutomationCore.SetFlag("freezecharmode", Option)
        Utils.Notify("Freeze Mode", "Set to: " .. Option, 2)
    end,
})

--// TELEPORT TAB
local TeleportTab = Window:CreateTab("📍 Teleport", 4483362458)

local TeleportSection = TeleportTab:CreateSection("Quick Teleports")

-- Zone Cast Section
local ZoneCastSection = TeleportTab:CreateSection("Zone Cast")

local ZoneCastToggle = TeleportTab:CreateToggle({
    Name = "Enable Zone Cast",
    CurrentValue = false,
    Flag = "ZoneCast",
    Callback = function(Value)
        AutomationCore.SetFlag("autozonecast", Value)
        if not Value then
            AutomationCore.SetZoneCast("") -- Disable zone cast
        end
        Utils.Notify("Zone Cast", Value and "Enabled" or "Disabled", 2)
    end,
})

local ZoneOptions = {
    "Deep Ocean",
    "The Depths", 
    "Mushgrove Swamp",
    "Roslit Bay",
    "Moosewood",
    "Sunstone Island",
    "Forsaken Shores",
    "Ancient Isle",
    "Bluefin Tuna Abundance",
    "Swordfish Abundance"
}

local ZoneCastDropdown = TeleportTab:CreateDropdown({
    Name = "Select Zone",
    Options = ZoneOptions,
    CurrentOption = "Deep Ocean",
    Flag = "SelectedZone",
    Callback = function(Option)
        AutomationCore.SetZoneCast(Option)
        Utils.Notify("Zone Cast", "Set to: " .. Option, 2)
    end,
})

-- Add teleport locations here
local TeleportCategories = TeleportCore.GetCategories()

-- Quick Teleport Buttons for Popular Locations
local popularLocations = {
    "Moosewood",
    "Roslit Bay", 
    "Forsaken Shores",
    "Ancient Isle",
    "The Depths",
    "Merchant",
    "Appraiser"
}

for _, locationName in pairs(popularLocations) do
    TeleportTab:CreateButton({
        Name = "🚀 " .. locationName,
        Callback = function()
            local success, message = TeleportCore.Teleport(locationName)
            Utils.Notify("Teleport", message or ("Teleported to " .. locationName), 2)
        end,
    })
end

-- GPS Teleport Section
local GPSSection = TeleportTab:CreateSection("🧭 GPS Teleport")

local gpsX, gpsY, gpsZ = 0, 150, 0

local GPSXInput = TeleportTab:CreateInput({
    Name = "GPS X Coordinate",
    PlaceholderText = "Enter X coordinate...",
    RemoveTextAfterFocusLost = false,
    Flag = "GPSX",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            gpsX = num
            TeleportCore.SetGPS(gpsX, gpsY, gpsZ)
        end
    end,
})

local GPSYInput = TeleportTab:CreateInput({
    Name = "GPS Y Coordinate",
    PlaceholderText = "Enter Y coordinate (default: 150)...",
    RemoveTextAfterFocusLost = false,
    Flag = "GPSY",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            gpsY = num
            TeleportCore.SetGPS(gpsX, gpsY, gpsZ)
        end
    end,
})

local GPSZInput = TeleportTab:CreateInput({
    Name = "GPS Z Coordinate", 
    PlaceholderText = "Enter Z coordinate...",
    RemoveTextAfterFocusLost = false,
    Flag = "GPSZ",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            gpsZ = num
            TeleportCore.SetGPS(gpsX, gpsY, gpsZ)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🚀 Teleport to GPS",
    Callback = function()
        local success, message = TeleportCore.TeleportToGPS(gpsX, gpsY, gpsZ)
        Utils.Notify("GPS Teleport", message or ("Teleported to " .. gpsX .. ", " .. gpsY .. ", " .. gpsZ), 2)
    end,
})

TeleportTab:CreateButton({
    Name = "📍 Get Current Position",
    Callback = function()
        local currentGPS = TeleportCore.GetCurrentGPS()
        if currentGPS then
            gpsX, gpsY, gpsZ = currentGPS.x, currentGPS.y, currentGPS.z
            TeleportCore.SetGPS(gpsX, gpsY, gpsZ)
            Utils.Notify("GPS", "Current: " .. gpsX .. ", " .. gpsY .. ", " .. gpsZ, 3)
        else
            Utils.Notify("GPS", "Character not found", 2)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🎲 Random Location",
    Callback = function()
        local success, message = TeleportCore.TeleportToRandomLocation()
        Utils.Notify("Random Teleport", message or "Teleported to random location", 2)
    end,
})

TeleportTab:CreateButton({
    Name = "📍 Nearest Location Info",
    Callback = function()
        local nearestName, nearestCFrame, distance = TeleportCore.GetNearestLocation()
        if nearestName then
            Utils.Notify("Nearest Location", nearestName .. " (" .. math.floor(distance) .. "m away)", 3)
        else
            Utils.Notify("Nearest", "No locations found", 2)
        end
    end,
})

-- Player Teleport Section
local PlayerSection = TeleportTab:CreateSection("👥 Player Teleports")

local selectedPlayerName = ""
local followingPlayer = false

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {"Loading players..."},
    CurrentOption = "Loading players...",
    Flag = "SelectedPlayer",
    Callback = function(Option)
        selectedPlayerName = Option
    end,
})

-- Function to refresh player list
local function refreshPlayerList()
    local playerNames = TeleportCore.getPlayerNames()
    local dropdownOptions = {}
    
    for _, playerData in ipairs(playerNames) do
        table.insert(dropdownOptions, playerData.display)
    end
    
    if #dropdownOptions == 0 then
        dropdownOptions = {"No players online"}
    end
    
    -- Update dropdown options
    pcall(function()
        PlayerDropdown:SetOptions(dropdownOptions)
        if #dropdownOptions > 0 and dropdownOptions[1] ~= "No players online" then
            selectedPlayerName = dropdownOptions[1]
            PlayerDropdown:Set(dropdownOptions[1])
        end
    end)
end

-- Auto-refresh player list every 5 seconds
spawn(function()
    while true do
        refreshPlayerList()
        wait(5)
    end
end)

TeleportTab:CreateButton({
    Name = "🔄 Refresh Player List",
    Callback = function()
        refreshPlayerList()
        Utils.Notify("Player List", "Refreshed player list", 2)
    end,
})

TeleportTab:CreateButton({
    Name = "🚀 Teleport to Player",
    Callback = function()
        if selectedPlayerName == "" or selectedPlayerName == "Loading players..." or selectedPlayerName == "No players online" then
            Utils.Notify("Player Teleport", "Please select a valid player first", 2)
            return
        end
        
        local playerNames = TeleportCore.getPlayerNames()
        local targetPlayer = nil
        
        for _, playerData in ipairs(playerNames) do
            if playerData.display == selectedPlayerName then
                targetPlayer = playerData.player
                break
            end
        end
        
        if targetPlayer then
            local success, message = TeleportCore.teleportToPlayer(targetPlayer)
            Utils.Notify("Player Teleport", message or ("Teleported to " .. targetPlayer.Name), 2)
        else
            Utils.Notify("Player Teleport", "Player not found or disconnected", 2)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🎯 Teleport to Nearest Player", 
    Callback = function()
        local nearestPlayer, distance = TeleportCore.getNearestPlayer()
        if nearestPlayer then
            local success, message = TeleportCore.teleportToPlayer(nearestPlayer)
            Utils.Notify("Player Teleport", 
                message or ("Teleported to " .. nearestPlayer.Name .. " (" .. math.floor(distance) .. "m away)"), 3)
        else
            Utils.Notify("Player Teleport", "No players found nearby", 2)
        end
    end,
})

local AutoFollowToggle = TeleportTab:CreateToggle({
    Name = "🔗 Auto Follow Player",
    CurrentValue = false,
    Flag = "AutoFollow",
    Callback = function(Value)
        if Value then
            if selectedPlayerName == "" or selectedPlayerName == "Loading players..." or selectedPlayerName == "No players online" then
                Utils.Notify("Auto Follow", "Please select a valid player first", 2)
                AutoFollowToggle:Set(false)
                return
            end
            
            local playerNames = TeleportCore.getPlayerNames()
            local targetPlayer = nil
            
            for _, playerData in ipairs(playerNames) do
                if playerData.display == selectedPlayerName then
                    targetPlayer = playerData.player
                    break
                end
            end
            
            if targetPlayer then
                local success, message = TeleportCore.startAutoFollow(targetPlayer)
                Utils.Notify("Auto Follow", message, 2)
                followingPlayer = true
            else
                Utils.Notify("Auto Follow", "Player not found", 2)
                AutoFollowToggle:Set(false)
            end
        else
            local success, message = TeleportCore.stopAutoFollow()
            Utils.Notify("Auto Follow", message, 2)
            followingPlayer = false
        end
    end,
})

TeleportTab:CreateButton({
    Name = "📢 Bring All Players (Admin)", 
    Callback = function()
        local success, message = TeleportCore.bringAllPlayers()
        Utils.Notify("Bring Players", message, 3)
    end,
})

-- Show player distances
TeleportTab:CreateButton({
    Name = "📏 Show Player Distances",
    Callback = function()
        local players = TeleportCore.getAllPlayers()
        if #players == 0 then
            Utils.Notify("Player Distances", "No players online", 2)
            return
        end
        
        local distances = {}
        for _, player in ipairs(players) do
            local distance = TeleportCore.getPlayerDistance(player)
            table.insert(distances, {
                name = player.Name,
                distance = math.floor(distance)
            })
        end
        
        -- Sort by distance
        table.sort(distances, function(a, b) return a.distance < b.distance end)
        
        local message = "Player Distances:\n"
        for i, data in ipairs(distances) do
            if i <= 5 then -- Show only top 5 closest
                message = message .. data.name .. ": " .. data.distance .. "m\n"
            end
        end
        
        Utils.Notify("Player Distances", message, 5)
    end,
})

-- Category-based teleport dropdowns
for _, category in pairs(TeleportCategories) do
    local categorySection = TeleportTab:CreateSection(category)
    local locations = TeleportCore.GetLocationsByCategory(category)
    local locationNames = {}
    
    for name, _ in pairs(locations) do
        if typeof(TeleportCore.FindLocation(name)) == "CFrame" then
            table.insert(locationNames, name)
        end
    end
    
    table.sort(locationNames)
    
    if #locationNames > 0 then
        local selectedLocation = ""
        
        local categoryDropdown = TeleportTab:CreateDropdown({
            Name = "Select " .. category:gsub("&", "and"),
            Options = locationNames,
            CurrentOption = locationNames[1],
            Flag = "Selected" .. category:gsub("%s+", ""),
            Callback = function(Option)
                selectedLocation = Option
            end,
        })
        
        TeleportTab:CreateButton({
            Name = "Teleport to " .. category,
            Callback = function()
                if selectedLocation ~= "" then
                    local success, message = TeleportCore.Teleport(selectedLocation)
                    Utils.Notify("Teleport", message or ("Teleported to " .. selectedLocation), 2)
                else
                    Utils.Notify("Teleport", "No location selected", 2)
                end
            end,
        })
    end
end

--// MISC TAB
local MiscTab = Window:CreateTab("🔧 Misc", 4483362458)

local MiscSection = MiscTab:CreateSection("Miscellaneous Features")

local ResetCharacterButton = MiscTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
            Utils.Notify("Reset", "Character reset", 2)
        end
    end,
})

local RejoinButton = MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
})

--// INFO TAB
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

local InfoSection = InfoTab:CreateSection("About This UI")

InfoTab:CreateLabel("Rayfield UI Template v2.0")
InfoTab:CreateLabel("Integrated with Automation Core")
InfoTab:CreateLabel("Full fishing automation system")

local CreditsSection = InfoTab:CreateSection("Credits")

InfoTab:CreateLabel("UI Library: Rayfield")
InfoTab:CreateLabel("Automation: Custom Core System")
InfoTab:CreateLabel("Template by: GitHub Copilot")
InfoTab:CreateLabel("Modified by: donitono")

local SystemSection = InfoTab:CreateSection("System Status")

InfoTab:CreateButton({
    Name = "Check System Status",
    Callback = function()
        local autoFishing = AutomationCore.GetFlag("autofishingloop")
        local autocast = AutomationCore.GetFlag("autocast")
        local autoreel = AutomationCore.GetFlag("autoreel")
        local superinstant = AutomationCore.GetFlag("superinstantreel")
        local totalLocations = #TeleportCore.GetAllLocationNames()
        local currentPos = TeleportCore.GetCurrentGPS()
        
        local status = "🔄 Auto Fishing Loop: " .. (autoFishing and "ON" or "OFF") .. "\n" ..
                      "🎣 Auto Cast: " .. (autocast and "ON" or "OFF") .. "\n" ..
                      "⚡ Auto Reel: " .. (autoreel and "ON" or "OFF") .. "\n" ..
                      "🚀 Super Instant: " .. (superinstant and "ON" or "OFF") .. "\n" ..
                      "📍 Total Locations: " .. totalLocations .. "\n" ..
                      "🧭 Current Position: " .. (currentPos and (currentPos.x .. ", " .. currentPos.y .. ", " .. currentPos.z) or "Unknown")
        
        Utils.Notify("System Status", status, 8)
    end,
})

InfoTab:CreateButton({
    Name = "Teleport System Info",
    Callback = function()
        local categories = TeleportCore.GetCategories()
        local totalLocations = TeleportCore.GetLocationCount()
        local nearestName, _, distance = TeleportCore.GetNearestLocation()
        
        local info = "📊 Teleport System Status:\n" ..
                    "📁 Categories: " .. #categories .. "\n" ..
                    "📍 Total Locations: " .. totalLocations .. "\n" ..
                    "🎯 Nearest: " .. (nearestName or "None") .. 
                    (distance and distance < math.huge and (" (" .. math.floor(distance) .. "m)") or "")
        
        Utils.Notify("Teleport Info", info, 5)
    end,
})

InfoTab:CreateButton({
    Name = "Emergency Stop All",
    Callback = function()
        AutomationCore.SetFlag("autofishingloop", false)
        AutomationCore.SetFlag("autocast", false)
        AutomationCore.SetFlag("autoreel", false)
        AutomationCore.SetFlag("autoshake", false)
        AutomationCore.SetFlag("superinstantreel", false)
        AutomationCore.SetFlag("autozonecast", false)
        AutomationCore.SetZoneCast("")
        Utils.Notify("Emergency Stop", "All automation stopped!", 3)
    end,
})

--// EXAMPLE: How to add a new button
MiscTab:CreateButton({
    Name = "Example Button",
    Callback = function()
        Utils.Notify("Example", "This is an example button!", 3)
        print("Example button pressed!")
        -- Add your code here
    end,
})

--// EXAMPLE: How to add a new toggle
local ExampleToggle = MiscTab:CreateToggle({
    Name = "Example Toggle",
    CurrentValue = false,
    Flag = "ExampleToggle",
    Callback = function(Value)
        print("Example toggle set to:", Value)
        -- Add your code here
    end,
})

--// EXAMPLE: How to add a new slider
local ExampleSlider = MiscTab:CreateSlider({
    Name = "Example Slider",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 50,
    Flag = "ExampleSlider",
    Callback = function(Value)
        print("Example slider set to:", Value)
        -- Add your code here
    end,
})

--// EXAMPLE: How to add a new textbox
local ExampleTextbox = MiscTab:CreateInput({
    Name = "Example Input",
    PlaceholderText = "Enter text here...",
    RemoveTextAfterFocusLost = false,
    Flag = "ExampleInput",
    Callback = function(Text)
        print("Example input text:", Text)
        -- Add your code here
    end,
})

--// CHARACTER REFRESH HANDLER
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    
    -- Reapply settings after character respawn
    wait(1)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Features.WalkSpeed
        LocalPlayer.Character.Humanoid.JumpPower = Features.JumpPower
    end
end)

--// STARTUP NOTIFICATION
Utils.Notify("Rayfield UI", "UI loaded successfully! Ready for customization.", 5)

print("Rayfield UI Template loaded successfully!")
print("Edit this file to add your own features.")

--[[
MODIFICATION GUIDE:
1. To add a new tab: Window:CreateTab("Tab Name", IconId)
2. To add a new section: Tab:CreateSection("Section Name")
3. To add a button: Tab:CreateButton({Name = "Button Name", Callback = function() end})
4. To add a toggle: Tab:CreateToggle({Name = "Toggle Name", CurrentValue = false, Flag = "Flag", Callback = function(Value) end})
5. To add a slider: Tab:CreateSlider({Name = "Slider Name", Range = {min, max}, Increment = step, CurrentValue = default, Flag = "Flag", Callback = function(Value) end})
6. To add an input: Tab:CreateInput({Name = "Input Name", PlaceholderText = "placeholder", RemoveTextAfterFocusLost = false, Flag = "Flag", Callback = function(Text) end})
7. To add a dropdown: Tab:CreateDropdown({Name = "Dropdown Name", Options = {"Option1", "Option2"}, CurrentOption = "Option1", Flag = "Flag", Callback = function(Option) end})

Remember to:
- Add your variables to the Features table
- Use Utils.Notify() for notifications
- Use flags for saving configurations
- Test your modifications before finalizing
]]--