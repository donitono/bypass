--[[
    AUTOMATION CORE - Clean Version
    Extracted from super.lua - Tab Menu Automation Functions Only
    Author: donitono
    Date: September 13, 2025
    
    Features Included:
    - Auto Cast System
    - Auto Reel System  
    - Auto Shake System
    - Super Instant Reel
    - Auto Appraise System
    - Auto Fishing Loop
    - Zone Cast System
    - Instant Bobber
    - Predictive AutoCast
    
    Note: All debug information and console outputs removed for clean code
]]--

-- Load Detection Bypass System (Optional)
local DetectionBypass = nil
pcall(function()
    DetectionBypass = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/detection_bypass.lua'))()
    if DetectionBypass then
        -- Configure for safer automation
        DetectionBypass.SetConfig("VerboseMode", false)
        DetectionBypass.SetConfig("AlertMode", false) 
        DetectionBypass.SetConfig("MaxActionsPerMinute", 45)
        DetectionBypass.SetConfig("DelayVariation", 0.4)
    end
end)

-- Services
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')

-- Variables
local lp = Players.LocalPlayer
local characterposition
local flags = {}

-- Default Settings
flags['autocast'] = false
flags['autoreel'] = false
flags['autoshake'] = false
flags['autocastdelay'] = 0.01
flags['autoreeldelay'] = 0.01

-- Advanced Features
flags['superinstantreel'] = false
flags['instantbobber'] = false
flags['enhancedinstantbobber'] = false
flags['superinstantnoanimation'] = false
flags['noanimationautocast'] = false
flags['autocastarmmovement'] = false
flags['predictiveautocast'] = false

-- Auto Appraise System
flags['autoappraise'] = false
flags['appraisemode'] = 1 -- 1 = NPC Dialog, 2 = Anywhere
flags['appraisedelay'] = 1.0
local autoAppraiseActive = false
local lastAppraiseTime = 0

-- Auto Fishing Loop System
flags['autofishingloop'] = false
flags['autoequiprod'] = false
flags['equipdelay'] = 0.5
flags['autocastloop'] = true
flags['autoshakeloop'] = true
flags['autoreelloop'] = true
flags['autorestart'] = true
flags['restarttimeout'] = 10
local autoFishingLoopActive = false
local lastProgressTime = 0
local selectedRodName = ""

-- Randomization Settings
flags['enablerandomization'] = true
flags['castpowermin'] = 70
flags['castpowermax'] = 95
flags['reelaccuracymin'] = 75
flags['reelaccuracymax'] = 100
flags['randomizedelay'] = true
flags['delayvariationmin'] = 0.1
flags['delayvariationmax'] = 0.8

-- Zone Cast System
flags['autozonecast'] = false
local selectedZoneCast = ""
local AutoZoneCast = false

-- Super Instant Reel Variables
local superInstantReelActive = false
local lureMonitorConnection = nil

-- Freeze Character
flags['freezechar'] = false
flags['freezecharmode'] = 'Toggled'

-- Safe execution wrapper
local function safeExecute(actionFunc, actionName, baseDelay)
    if DetectionBypass then
        return DetectionBypass.SafeExecute(actionFunc, baseDelay or 0.5)
    else
        -- Fallback without detection bypass
        local delay = baseDelay or 0.5
        task.wait(delay + math.random() * 0.2) -- Add small random delay
        return actionFunc()
    end
end

-- Randomization Helper Functions
local function getRandomCastPower()
    if flags['enablerandomization'] then
        return math.random(flags['castpowermin'], flags['castpowermax'])
    else
        return 100 -- Default perfect cast
    end
end

local function getRandomReelAccuracy()
    if flags['enablerandomization'] then
        return math.random(flags['reelaccuracymin'], flags['reelaccuracymax'])
    else
        return 100 -- Default perfect reel
    end
end

local function getRandomDelay(baseDelay)
    if flags['randomizedelay'] then
        local variation = math.random() * (flags['delayvariationmax'] - flags['delayvariationmin']) + flags['delayvariationmin']
        return baseDelay + variation
    else
        return baseDelay
    end
end

-- Find Rod Function
function FindRod()
    local character = lp.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("events") then
            return tool
        end
    end
    return nil
end

-- Get HumanoidRootPart
function gethrp()
    return lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
end

-- Check if rod is equipped
function hasRodEquipped()
    return FindRod() ~= nil
end

-- Get rods from inventory
function getRodsFromInventory()
    local rods = {}
    if lp.Backpack then
        for _, item in pairs(lp.Backpack:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("events") then
                table.insert(rods, item)
            end
        end
    end
    return rods
end

-- Get best rod from inventory
function getBestRod()
    local rods = getRodsFromInventory()
    if #rods > 0 then
        -- Simple selection - return first available rod
        -- Can be enhanced with rod quality logic
        return rods[1]
    end
    return nil
end

--// AUTO APPRAISE SYSTEM

local function hasAppraisableFish()
    local character = lp.Character
    if not character then return false end
    
    -- Check equipped tool
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("fish") then
        return true
    end
    
    -- Check backpack for fish
    local backpack = lp.Backpack
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("fish") then
                return true
            end
        end
    end
    
    return false
end

local function findNearestAppraiser()
    local character = lp.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local humanoidRootPart = character.HumanoidRootPart
    local nearestAppraiser = nil
    local shortestDistance = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("appraiser") or obj.Name:lower():find("appraise") then
            if obj:FindFirstChild("HumanoidRootPart") then
                local distance = (humanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance and distance < 20 then
                    shortestDistance = distance
                    nearestAppraiser = obj
                end
            end
        end
    end
    
    return nearestAppraiser
end

local function performNPCAppraise()
    local appraiser = findNearestAppraiser()
    if not appraiser then return false end
    
    pcall(function()
        local dialogInteract = ReplicatedStorage.packages.Net.RF.DialogInteract
        if dialogInteract then
            dialogInteract:InvokeServer(appraiser, "appraise")
            task.wait(0.5)
            ReplicatedStorage.packages.Net.RE.EventAppraiseService.RequestAppraiseUI:FireServer()
            task.wait(0.3)
            ReplicatedStorage.packages.Net.RE.EventAppraiseService.StartAppraise:FireServer()
            task.wait(1.0)
            ReplicatedStorage.packages.Net.RE.EventAppraiseService.TakeNow:FireServer()
            return true
        end
    end)
    
    return false
end

local function performAppraiseAnywhere()
    pcall(function()
        local appraiseAnywhere = ReplicatedStorage.packages.Net.RF.AppraiseAnywhere
        if appraiseAnywhere and appraiseAnywhere.HaveValidFish then
            local hasValidFish = appraiseAnywhere.HaveValidFish:InvokeServer()
            if hasValidFish then
                appraiseAnywhere.Fire:InvokeServer()
                return true
            end
        end
    end)
    
    return false
end

local function autoAppraise()
    if not flags['autoappraise'] then return end
    if autoAppraiseActive then return end
    
    local currentTime = tick()
    if currentTime - lastAppraiseTime < flags['appraisedelay'] then return end
    
    if not hasAppraisableFish() then return end
    
    autoAppraiseActive = true
    lastAppraiseTime = currentTime
    
    local success = false
    
    if flags['appraisemode'] == 1 then
        success = performNPCAppraise()
    elseif flags['appraisemode'] == 2 then
        success = performAppraiseAnywhere()
    end
    
    task.wait(0.5)
    autoAppraiseActive = false
end

--// SUPER INSTANT REEL SYSTEM

local function setupSuperInstantReel()
    if not superInstantReelActive then
        superInstantReelActive = true
        
        lureMonitorConnection = RunService.Heartbeat:Connect(function()
            if flags['superinstantreel'] then
                pcall(function()
                    local rod = FindRod()
                    if rod and rod.values then
                        local lureValue = rod.values.lure and rod.values.lure.Value or 0
                        local biteValue = rod.values.bite and rod.values.bite.Value or false
                        
                        -- Animation handling
                        local character = lp.Character
                        if character and character:FindFirstChild("Humanoid") then
                            local humanoid = character.Humanoid
                            
                            if flags['superinstantnoanimation'] then
                                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                                    if track.Name:lower():find("fish") or track.Name:lower():find("reel") or 
                                       track.Name:lower():find("catch") or track.Name:lower():find("lift") or
                                       track.Name:lower():find("cast") or track.Name:lower():find("rod") then
                                        track:Stop()
                                    end
                                end
                            else
                                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                                    if track.Name:lower():find("fish") or track.Name:lower():find("reel") or 
                                       track.Name:lower():find("catch") or track.Name:lower():find("lift") then
                                        track:AdjustSpeed(3)
                                    end
                                end
                            end
                        end
                        
                        -- Ultra-instant catch when fish bites
                        if lureValue >= 95 or biteValue == true then
                            for i = 1, 5 do
                                local reelAccuracy = getRandomReelAccuracy()
                                ReplicatedStorage.events.reelfinished:FireServer(reelAccuracy, true)
                            end
                            
                            local reelGui = lp.PlayerGui:FindFirstChild("reel")
                            if reelGui then
                                reelGui:Destroy()
                            end
                            
                            -- Force stop animations
                            local character = lp.Character
                            if character and character:FindFirstChild("Humanoid") then
                                local humanoid = character.Humanoid
                                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                                    local animName = track.Name:lower()
                                    if animName:find("fish") or animName:find("reel") or animName:find("cast") or
                                       animName:find("rod") or animName:find("catch") or animName:find("lift") or
                                       animName:find("pull") or animName:find("bobber") then
                                        track:Stop()
                                        track:AdjustSpeed(0)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
        
        -- GUI intercept for zero-flash
        local playerGui = lp.PlayerGui
        playerGui.ChildAdded:Connect(function(gui)
            if flags['superinstantreel'] and gui.Name == "reel" then
                pcall(function()
                    gui.Enabled = false
                    gui:Destroy()
                end)
                
                pcall(function()
                    local reelAccuracy = getRandomReelAccuracy()
                    ReplicatedStorage.events.reelfinished:FireServer(reelAccuracy, true)
                end)
            end
        end)
        
        -- Continuous animation disabling
        task.spawn(function()
            while superInstantReelActive do
                task.wait(0.05)
                if flags['superinstantreel'] and flags['superinstantnoanimation'] then
                    pcall(function()
                        local character = lp.Character
                        if character and character:FindFirstChild("Humanoid") then
                            local humanoid = character.Humanoid
                            
                            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                                local animName = track.Name:lower()
                                local animId = tostring(track.Animation.AnimationId):lower()
                                
                                if animName:find("fish") or animName:find("reel") or animName:find("cast") or 
                                   animName:find("rod") or animName:find("catch") or animName:find("lift") or
                                   animName:find("pull") or animName:find("bobber") or animName:find("yank") or
                                   animId:find("fish") or animId:find("reel") or animId:find("cast") or
                                   animId:find("rod") or animId:find("catch") or animId:find("lift") or
                                   animId:find("pull") or animId:find("bobber") or animId:find("yank") then
                                    track:Stop()
                                    track:AdjustSpeed(0)
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
end

setupSuperInstantReel()

--// ZONE CAST SYSTEM

-- Zone Cast Coordinates
local ZoneCastCoordinates = {
    ['Deep Ocean'] = CFrame.new(-2895.302, 126.564, -2737.799),
    ['The Depths'] = CFrame.new(-1516.544, -245.000, -2783.699),
    ['Mushgrove Swamp'] = CFrame.new(2434, 131, -692),
    ['Roslit Bay'] = CFrame.new(-1472, 132, 707),
    ['Moosewood'] = CFrame.new(379, 134, 233),
    ['Sunstone Island'] = CFrame.new(-913, 138, -1133),
    ['Forsaken Shores'] = CFrame.new(-2491, 133, 1561),
    ['Ancient Isle'] = CFrame.new(6056, 195, 276)
}

local function ZoneCasting()
    task.spawn(function()
        while AutoZoneCast do
            local character = lp.Character

            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    local hasBobber = tool:FindFirstChild("bobber")
                    if hasBobber then
                        local ropeConstraint = hasBobber:FindFirstChild("RopeConstraint")
                        if ropeConstraint then
                            ropeConstraint.Length = 200000
                        end

                        local platformSize = Vector3.new(10, 1, 10)
                        local platformPositionOffset = Vector3.new(0, -4, 0)
                        local bobberPosition = nil

                        -- Handle special zones
                        if selectedZoneCast == "Bluefin Tuna Abundance" then
                            local selectedZone = workspace.zones.fishing:FindFirstChild("Deep Ocean")
                            if selectedZone then
                                local abundanceValue = selectedZone:FindFirstChild("Abundance")
                                if abundanceValue and abundanceValue.Value == "Bluefin Tuna" then
                                    bobberPosition = CFrame.new(selectedZone.Position.X, 126.564, selectedZone.Position.Z)
                                end
                            end
                        elseif selectedZoneCast == "Swordfish Abundance" then
                            local selectedZone = workspace.zones.fishing:FindFirstChild("Deep Ocean")
                            if selectedZone then
                                local abundanceValue = selectedZone:FindFirstChild("Abundance")
                                if abundanceValue and abundanceValue.Value == "Swordfish" then
                                    bobberPosition = CFrame.new(selectedZone.Position.X, 126.564, selectedZone.Position.Z)
                                end
                            end
                        else
                            local zoneCoord = ZoneCastCoordinates[selectedZoneCast]
                            if zoneCoord and typeof(zoneCoord) == "CFrame" then
                                bobberPosition = zoneCoord
                            end
                        end

                        -- Apply bobber position
                        if bobberPosition then
                            hasBobber.CFrame = bobberPosition
                            
                            local platform = Instance.new("Part")
                            platform.Size = platformSize
                            platform.Position = hasBobber.Position + platformPositionOffset
                            platform.Anchored = true
                            platform.Parent = hasBobber
                            platform.BrickColor = BrickColor.new("Bright blue")
                            platform.Transparency = 1.000
                            platform.CanCollide = false
                            platform.Name = "ZoneCastPlatform"
                            
                            pcall(function()
                                for _, oldPlatform in pairs(hasBobber:GetChildren()) do
                                    if oldPlatform.Name == "ZoneCastPlatform" and oldPlatform ~= platform then
                                        oldPlatform:Destroy()
                                    end
                                end
                            end)
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end

--// AUTO FISHING LOOP SYSTEM

local function autoEquipRod()
    if not flags['autoequiprod'] then return end
    
    local currentTime = tick()
    if currentTime - lastProgressTime < flags['equipdelay'] then return end
    
    if hasRodEquipped() then return end
    
    local rodToEquip
    if selectedRodName ~= "" then
        -- Find specific rod
        local rods = getRodsFromInventory()
        for _, rod in pairs(rods) do
            if rod.Name == selectedRodName then
                rodToEquip = rod
                break
            end
        end
    else
        -- Get best available rod
        rodToEquip = getBestRod()
    end
    
    if rodToEquip then
        pcall(function()
            lp.Character.Humanoid:EquipTool(rodToEquip)
        end)
        lastProgressTime = currentTime
        task.wait(flags['equipdelay'])
    end
end

local function runAutoFishingLoop()
    if not flags['autofishingloop'] then return end
    
    local currentTime = tick()
    
    -- Step 1: Auto equip rod if needed
    autoEquipRod()
    
    local currentRod = FindRod()
    if currentRod then
        -- Monitor progress
        local lureValue = currentRod.values.lure and currentRod.values.lure.Value or 0
        if lureValue > 50 or lureValue < 5 then
            lastProgressTime = currentTime
        end
        
        -- Enable auto features
        if flags['autocastloop'] then
            flags['autocast'] = true
        end
        if flags['autoshakeloop'] then 
            flags['autoshake'] = true
        end
        if flags['autoreelloop'] then
            flags['autoreel'] = true
            flags['superinstantreel'] = true
        end
        
        -- Auto restart if stuck
        if flags['autorestart'] and (currentTime - lastProgressTime) > (flags['restarttimeout'] or 10) then
            pcall(function()
                currentRod.Parent = lp.Backpack
            end)
            lastProgressTime = currentTime
        end
    end
end

--// MAIN AUTOMATION LOOP

local function runMainLoop()
    -- Auto Fishing Loop
    runAutoFishingLoop()
    
    -- Freeze Character
    if flags['freezechar'] then
        if flags['freezecharmode'] == 'Toggled' then
            if characterposition == nil then
                characterposition = gethrp().CFrame
            else
                gethrp().CFrame = characterposition
            end
        elseif flags['freezecharmode'] == 'Rod Equipped' then
            local rod = FindRod()
            if rod and characterposition == nil then
                characterposition = gethrp().CFrame
            elseif rod and characterposition ~= nil then
                gethrp().CFrame = characterposition
            else
                characterposition = nil
            end
        end
    else
        characterposition = nil
    end
    
    -- Auto Shake
    if flags['autoshake'] and not flags['superinstantreel'] then
        local rod = FindRod()
        if rod ~= nil then
            local shakeui = lp.PlayerGui:FindFirstChild('shakeui')
            if shakeui ~= nil then
                if shakeui.safezone ~= nil then
                    local button = shakeui.safezone.button
                    if button.Visible == true and button.Parent.Visible == true then
                        pcall(function()
                            for i = 1, 20 do
                                ReplicatedStorage.events.fishcaught:FireServer(button.Name, true)
                            end
                        end)
                    end
                end
            end
        end
    end
    
    -- Predictive AutoCast
    if flags['autocast'] and flags['predictiveautocast'] then
        local rod = FindRod()
        
        if rod ~= nil then
            local currentLureValue = rod['values']['lure'].Value
            local currentBiteValue = rod['values']['bite'] and rod['values']['bite'].Value or false
            
            if currentLureValue >= 95 and currentBiteValue == true then
                task.spawn(function()
                    while rod['values']['lure'].Value > 0.001 do
                        task.wait(0.001)
                    end
                    
                    pcall(function()
                        if flags['noanimationautocast'] then
                            rod.events.cast:FireServer(-25, 1)
                        elseif flags['autocastarmmovement'] then
                            rod.events.cast:FireServer(1000000000000, 1)
                        elseif flags['enhancedinstantbobber'] then
                            rod.events.cast:FireServer(-500, 1)
                        elseif flags['instantbobber'] then
                            rod.events.cast:FireServer(-250, 1)
                        else
                            rod.events.cast:FireServer(-25, 1)
                        end
                    end)
                end)
            end
            
            -- Standard autocast fallback
            if currentLureValue <= .001 then
                local currentDelay = flags['autocastdelay'] or 0.01
                currentDelay = currentDelay * 0.1
                task.wait(currentDelay)
                
                if flags['noanimationautocast'] then
                    rod.events.cast:FireServer(-25, 1)
                elseif flags['autocastarmmovement'] then
                    local castPower = getRandomCastPower()
                    rod.events.cast:FireServer(castPower, 1)
                elseif flags['enhancedinstantbobber'] then
                    rod.events.cast:FireServer(-500, 1)
                elseif flags['instantbobber'] then
                    rod.events.cast:FireServer(-250, 1)
                else
                    rod.events.cast:FireServer(-25, 1)
                end
            end
        end
    -- Standard AutoCast
    elseif flags['autocast'] then
        local rod = FindRod()
        local currentDelay = flags['autocastdelay'] or 0.5
        
        if flags['superinstantreel'] then
            currentDelay = math.max(currentDelay, 0.8)
        end
        
        if rod ~= nil and rod['values']['lure'].Value <= .001 then
            -- Use safe execution for casting
            safeExecute(function()
                if flags['noanimationautocast'] then
                    rod.events.cast:FireServer(-25, 1)
                elseif flags['autocastarmmovement'] then
                    local castPower = getRandomCastPower()
                    rod.events.cast:FireServer(castPower, 1)
                elseif flags['enhancedinstantbobber'] then
                    rod.events.cast:FireServer(-500, 1)
                elseif flags['instantbobber'] then
                    rod.events.cast:FireServer(-250, 1)
                else
                    rod.events.cast:FireServer(-25, 1)
                end
                return true
            end, "AutoCast", currentDelay)
        end
    end
    
    -- Auto Reel
    if flags['autoreel'] then
        local rod = FindRod()
        local currentDelay = flags['autoreeldelay'] or 0.5
        if rod ~= nil and rod['values']['lure'].Value == 100 then
            safeExecute(function()
                local reelAccuracy = getRandomReelAccuracy()
                ReplicatedStorage.events.reelfinished:FireServer(reelAccuracy, true)
                return true
            end, "AutoReel", currentDelay)
        end
    end
    
    -- Super Instant Reel Integration
    if flags['superinstantreel'] then
        local rod = FindRod()
        if rod ~= nil then
            local lureValue = rod.values.lure and rod.values.lure.Value or 0
            local biteValue = rod.values.bite and rod.values.bite.Value or false
            
            if lureValue >= 98 or biteValue == true then
                pcall(function()
                    local reelAccuracy = getRandomReelAccuracy()
                    ReplicatedStorage.events.reelfinished:FireServer(reelAccuracy, true)
                    
                    -- Predictive autocast integration
                    if flags['predictiveautocast'] and flags['autocast'] then
                        task.spawn(function()
                            task.wait(0.05) 
                            
                            if flags['noanimationautocast'] then
                                rod.events.cast:FireServer(-25, 1)
                            elseif flags['enhancedinstantbobber'] then
                                rod.events.cast:FireServer(-500, 1)
                            else
                                rod.events.cast:FireServer(-250, 1)
                            end
                        end)
                    end
                end)
            end
        end
    end
    
    -- Auto Appraise
    autoAppraise()
end

--// PUBLIC API

local AutomationCore = {}

function AutomationCore.SetFlag(flagName, value)
    flags[flagName] = value
end

function AutomationCore.GetFlag(flagName)
    return flags[flagName]
end

function AutomationCore.SetZoneCast(zoneName)
    selectedZoneCast = zoneName
    if zoneName and zoneName ~= "" then
        AutoZoneCast = true
        ZoneCasting()
    else
        AutoZoneCast = false
    end
end

function AutomationCore.SetPreferredRod(rodName)
    selectedRodName = rodName or ""
end

function AutomationCore.GetRodsFromInventory()
    return getRodsFromInventory()
end

function AutomationCore.GetDetectionStatus()
    if DetectionBypass then
        return DetectionBypass.GetStatistics()
    else
        return {status = "Detection bypass not loaded", safe = true}
    end
end

function AutomationCore.GetRiskLevel()
    if DetectionBypass then
        local riskLevel, riskText = DetectionBypass.GetRiskStatus()
        return {level = riskLevel, text = riskText}
    else
        return {level = "UNKNOWN", text = "Detection bypass not available"}
    end
end

function AutomationCore.PrintDetectionStatus()
    if DetectionBypass then
        DetectionBypass.PrintStatus()
    else
        print("🛡️ Detection Bypass: Not loaded - using basic safety delays")
    end
end

function AutomationCore.Start()
    lastProgressTime = tick()
    
    -- Main automation loop
    RunService.Heartbeat:Connect(runMainLoop)
end

function AutomationCore.Stop()
    -- Stop all automation
    flags['autocast'] = false
    flags['autoreel'] = false
    flags['autoshake'] = false
    flags['superinstantreel'] = false
    flags['autofishingloop'] = false
    flags['autozonecast'] = false
    AutoZoneCast = false
    
    if lureMonitorConnection then
        lureMonitorConnection:Disconnect()
        lureMonitorConnection = nil
    end
    
    superInstantReelActive = false
end

-- Set flag function for UI integration
function AutomationCore.SetFlag(flagName, value)
    if flags[flagName] ~= nil then
        flags[flagName] = value
        return true
    else
        warn("Flag '" .. tostring(flagName) .. "' does not exist")
        return false
    end
end

-- Get flag function for UI integration  
function AutomationCore.GetFlag(flagName)
    return flags[flagName]
end

-- Get all flags for debugging
function AutomationCore.GetAllFlags()
    return flags
end

-- Initialize automation
AutomationCore.Start()

return AutomationCore