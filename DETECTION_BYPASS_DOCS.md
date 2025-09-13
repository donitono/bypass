# 🛡️ Bypass Detection Systems - Documentation

## Overview

The **Bypass Detection Systems** adalah framework canggih yang dirancang untuk melindungi automation scripts dari sistem deteksi game. Sistem ini menggunakan berbagai teknik untuk mensimulasikan behavior manusia dan menghindari pattern yang mencurigakan.

## 🎯 Core Features

### 1. **Smart Delay Randomization**
- Generate delay yang random seperti manusia
- Variasi timing yang natural
- Adaptive delay berdasarkan risk level

### 2. **Human Behavior Simulation**
- Simulasi reaction time manusia
- Random "mistakes" dan "think time"
- Pattern breaking untuk menghindari deteksi

### 3. **Rate Limiting Protection**
- Monitoring actions per minute
- Automatic cooldown saat rate limit tercapai
- Burst mode detection dan mitigation

### 4. **Risk Assessment System**
- Real-time risk monitoring (0-100 scale)
- Multiple risk factors analysis
- Adaptive behavior berdasarkan risk level

### 5. **Pattern Analysis**
- Deteksi pattern repetitif
- Automatic pattern breaking
- Variance analysis untuk natural behavior

## 🔧 Quick Start

### Method 1: Standalone Usage
```lua
local DetectionBypass = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/detection_bypass.lua'))()

-- Safe execution
DetectionBypass.SafeExecute(function()
    -- Your automation code here
    ReplicatedStorage.events.cast:FireServer(100, 1)
    return true
end, 0.5) -- base delay 0.5 seconds
```

### Method 2: Integrated with Automation Core
```lua
-- Automation core automatically loads detection bypass
local AutomationCore = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/automation_core.lua'))()

-- Check detection status
local risk = AutomationCore.GetRiskLevel()
print("Current risk:", risk.level, risk.text)
```

## ⚙️ Configuration Options

### Basic Settings
```lua
DetectionBypass.SetConfig("MinDelay", 0.1)           -- Minimum delay (seconds)
DetectionBypass.SetConfig("MaxDelay", 2.0)           -- Maximum delay (seconds)
DetectionBypass.SetConfig("DelayVariation", 0.3)     -- Delay randomization (0-1)
DetectionBypass.SetConfig("PatternBreak", 0.15)      -- Pattern break chance (15%)
```

### Human Simulation
```lua
DetectionBypass.SetConfig("ReactionTime", 0.2)       -- Human reaction time
DetectionBypass.SetConfig("ErrorRate", 0.02)         -- Mistake simulation (2%)
```

### Safety Limits
```lua
DetectionBypass.SetConfig("MaxActionsPerMinute", 60) -- Rate limiting
DetectionBypass.SetConfig("CooldownAfterBurst", 5)   -- Cooldown time
```

### Monitoring
```lua
DetectionBypass.SetConfig("VerboseMode", true)       -- Enable detailed logs
DetectionBypass.SetConfig("AlertMode", true)         -- Enable risk alerts
DetectionBypass.SetConfig("AdaptiveBehavior", true)  -- Auto risk adaptation
```

## 📊 Risk Assessment System

### Risk Levels
- **🟢 LOW (0-20)**: Safe operation
- **🟡 MEDIUM (21-40)**: Moderate risk - consider slowing down  
- **🟠 HIGH (41-60)**: High risk - recommend cooldown
- **🔴 CRITICAL (61-100)**: Critical risk - stop immediately

### Risk Factors
1. **High Frequency**: Too many actions per minute
2. **Pattern Detected**: Repetitive timing detected
3. **Too Perfect**: Unrealistic success rate
4. **Continuous Operation**: Long periods without breaks

### Automatic Responses
- **Risk 21-40**: Increase delays by 50%
- **Risk 41-60**: Double all delays
- **Risk 61-80**: Triple delays + forced breaks
- **Risk 80+**: Block actions until risk decreases

## 🎮 Usage Examples

### Example 1: Safe Fishing Automation
```lua
local DetectionBypass = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/detection_bypass.lua'))()

-- Configure for fishing
DetectionBypass.SetConfig("MaxActionsPerMinute", 30)
DetectionBypass.SetConfig("DelayVariation", 0.5)

-- Safe fishing loop
while fishing do
    -- Safe cast
    DetectionBypass.SafeExecute(function()
        rod.events.cast:FireServer(100, 1)
        return true
    end, 2.0)
    
    -- Wait for fish...
    
    -- Safe reel
    DetectionBypass.SafeExecute(function()
        ReplicatedStorage.events.reelfinished:FireServer(100, true)
        return true
    end, 1.0)
    
    -- Check risk level
    local risk = DetectionBypass.CalculateRiskLevel()
    if risk > 60 then
        print("⚠️ High risk detected, taking a break...")
        wait(30) -- Extended break
    end
end
```

### Example 2: Batch Safe Execution
```lua
-- Execute multiple actions safely
local actions = {
    {name = "Equip Rod", func = function() return equipRod() end, delay = 1.0},
    {name = "Cast", func = function() return castRod() end, delay = 0.8},
    {name = "Shake", func = function() return autoShake() end, delay = 0.3},
    {name = "Reel", func = function() return autoReel() end, delay = 0.5}
}

local results = DetectionBypass.SafeBatch(actions)
for _, result in ipairs(results) do
    print(result.action .. ": " .. (result.success and "SUCCESS" or "FAILED"))
end
```

### Example 3: Monitoring & Status
```lua
-- Start automatic monitoring
DetectionBypass.StartAutoMonitoring(60) -- Check every minute

-- Manual status check
DetectionBypass.PrintStatus()

-- Get detailed statistics
local stats = DetectionBypass.GetStatistics()
print("Total actions:", stats.totalActions)
print("Current risk:", stats.currentRiskLevel)
print("Actions last minute:", stats.actionsLastMinute)

-- Reset if needed
DetectionBypass.ResetStatistics()
```

## 🛠️ Advanced Features

### Custom Risk Assessment
```lua
-- Add custom risk factors
local customRisk = function()
    local risk = 0
    -- Your custom risk calculation
    if someCondition then
        risk = risk + 15
    end
    return risk
end
```

### Integration with UI Systems
```lua
-- For Rayfield UI integration
local riskInfo = AutomationCore.GetRiskLevel()
RayfieldNotification("Risk Level: " .. riskInfo.level, riskInfo.text, 3)
```

### Emergency Protocols
```lua
-- Auto-stop on critical risk
DetectionBypass.StartAutoMonitoring(30)
DetectionBypass.SetConfig("AlertMode", true)

-- Manual emergency stop
if DetectionBypass.CalculateRiskLevel() >= 80 then
    -- Stop all automation
    AutomationCore.Stop()
    warn("🚨 EMERGENCY STOP - Critical risk detected!")
end
```

## 🔍 How It Works

### 1. **Action Timing Analysis**
```lua
-- System tracks timing between actions
lastActions = {1663123456.123, 1663123458.456, 1663123460.789}

-- Calculates intervals and variance
intervals = {2.333, 2.333} -- Too consistent = suspicious
variance = 0.000 -- Low variance = pattern detected
```

### 2. **Human-like Randomization**
```lua
-- Base delay: 0.5 seconds
-- + Variation: ±0.15 seconds (30% of 0.5)
-- + Reaction time: +0.2 seconds (30% chance)
-- + Think time: +0-1 seconds (10% chance)
-- = Final delay: 0.35-1.85 seconds (natural range)
```

### 3. **Adaptive Behavior**
```lua
-- Normal operation: 1.0x delay
-- Medium risk: 1.5x delay
-- High risk: 2.0x delay  
-- Critical risk: 3.0x delay + forced breaks
```

## ⚠️ Best Practices

### DO:
✅ Configure appropriate limits for your use case  
✅ Monitor risk levels regularly  
✅ Use realistic timing settings  
✅ Enable adaptive behavior  
✅ Take breaks during long sessions  

### DON'T:
❌ Set extremely low delays (< 0.1s)  
❌ Disable all randomization  
❌ Ignore high risk warnings  
❌ Run 24/7 without breaks  
❌ Use perfect success rates  

## 🐛 Troubleshooting

### Common Issues

**Q: Actions are being skipped too often**
```lua
-- A: Lower the error rate and risk sensitivity
DetectionBypass.SetConfig("ErrorRate", 0.01) -- Reduce from 2% to 1%
DetectionBypass.SetConfig("MaxActionsPerMinute", 45) -- Increase limit
```

**Q: Risk level is always high**
```lua
-- A: Check your timing patterns
DetectionBypass.PrintStatus() -- See which risk factors are active
DetectionBypass.ResetStatistics() -- Reset if needed
```

**Q: System is too slow**
```lua
-- A: Adjust configuration for faster operation
DetectionBypass.SetConfig("DelayVariation", 0.1) -- Less randomization
DetectionBypass.SetConfig("AdaptiveBehavior", false) -- Disable adaptation
```

**Q: Detection bypass not loading**
```lua
-- A: Check internet connection and URL
pcall(function()
    DetectionBypass = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/detection_bypass.lua'))()
    print("Detection bypass loaded:", DetectionBypass ~= nil)
end)
```

## 📈 Performance Impact

### Resource Usage:
- **CPU**: Minimal impact (< 1% additional usage)
- **Memory**: ~50KB for tracking data
- **Network**: No additional requests after loading

### Timing Impact:
- **Normal delay**: 0.5s → 0.35-1.85s (natural variation)
- **High risk**: 0.5s → 1.5-3.0s+ (safety increase)
- **Pattern break**: +1-3s occasionally (human-like)

## 🔄 Updates & Maintenance

The detection bypass system is automatically updated via GitHub raw URLs. To force reload:

```lua
-- Force reload detection bypass
DetectionBypass = nil
DetectionBypass = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/detection_bypass.lua'))()
```

## 📞 Support

For questions or issues:
1. Check the troubleshooting section
2. Review your configuration settings
3. Monitor risk levels and adjust accordingly
4. Use verbose mode for detailed debugging

---

**Created by:** donitono  
**Repository:** https://github.com/donitono/bypass  
**File:** detection_bypass.lua  
**Last Updated:** September 13, 2025

**⚠️ Disclaimer:** This system is for educational purposes. Use responsibly and in accordance with game terms of service.