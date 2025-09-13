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
local TeleportLocations = {
    ["Spawn"] = Vector3.new(0, 0, 0),
    ["Shop"] = Vector3.new(100, 0, 100),
    -- Add more locations as needed
}

for locationName, position in pairs(TeleportLocations) do
    TeleportTab:CreateButton({
        Name = "Teleport to " .. locationName,
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
                Utils.Notify("Teleport", "Teleported to " .. locationName, 2)
            end
        end,
    })
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
    Name = "Check Automation Status",
    Callback = function()
        local autoFishing = AutomationCore.GetFlag("autofishingloop")
        local autocast = AutomationCore.GetFlag("autocast")
        local autoreel = AutomationCore.GetFlag("autoreel")
        local superinstant = AutomationCore.GetFlag("superinstantreel")
        
        local status = "🔄 Auto Fishing Loop: " .. (autoFishing and "ON" or "OFF") .. "\n" ..
                      "🎣 Auto Cast: " .. (autocast and "ON" or "OFF") .. "\n" ..
                      "⚡ Auto Reel: " .. (autoreel and "ON" or "OFF") .. "\n" ..
                      "🚀 Super Instant: " .. (superinstant and "ON" or "OFF")
        
        Utils.Notify("System Status", status, 5)
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