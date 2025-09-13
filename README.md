# Bypass Hub - Automation System

## 🚀 Quick Start

### Method 1: Load Full UI (Recommended)
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/rayfield_ui.lua'))()
```

### Method 2: Load Only Automation Core
```lua
local AutomationCore = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/automation_core.lua'))()

-- Enable features manually
AutomationCore.SetFlag("autocast", true)
AutomationCore.SetFlag("superinstantreel", true)
```

## 🎯 Features

### ⚡ Core Automation
- **Auto Cast** - Automatic fishing rod casting
- **Auto Reel** - Automatic fish reeling
- **Auto Shake** - Automatic shake mini-game
- **Super Instant Reel** - Ultra-fast fish catching
- **Predictive AutoCast** - Zero-gap casting system

### 🐟 Advanced Features  
- **Auto Appraise** - Automatic fish appraisal
- **Zone Cast** - Cast to specific fishing zones
- **Instant Bobber** - No animation casting
- **Auto Fishing Loop** - Complete automation cycle
- **Freeze Character** - Stay in position while fishing

### 📍 Zone Cast Locations
- Deep Ocean
- The Depths
- Mushgrove Swamp  
- Roslit Bay
- Moosewood
- Sunstone Island
- Forsaken Shores
- Ancient Isle
- Bluefin Tuna Abundance (Dynamic)
- Swordfish Abundance (Dynamic)

## 🎮 Usage Examples

### Basic Auto Fishing
```lua
-- Load the UI
loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/rayfield_ui.lua'))()

-- Enable basic auto fishing
-- Use the UI toggles to enable:
-- 1. Auto Cast
-- 2. Auto Reel  
-- 3. Auto Shake
```

### Advanced Speed Fishing
```lua
-- Load UI first, then enable:
-- 1. Auto Fishing (Master) - Enables auto fishing loop
-- 2. Super Instant Reel - Ultra fast catching
-- 3. Predictive AutoCast - Zero gap between casts
-- 4. Instant Bobber - No cast animation
```

### Zone Fishing
```lua
-- In UI:
-- 1. Go to Teleport tab
-- 2. Enable "Zone Cast" 
-- 3. Select desired zone from dropdown
-- 4. Enable Auto Cast for automatic zone fishing
```

## 🔧 API Reference (Automation Core Only)

### Flag Management
```lua
-- Set automation flags
AutomationCore.SetFlag("autocast", true)
AutomationCore.SetFlag("superinstantreel", true)
AutomationCore.SetFlag("instantbobber", true)

-- Get flag status
local isActive = AutomationCore.GetFlag("autocast")
```

### Zone Management
```lua
-- Set zone casting
AutomationCore.SetZoneCast("Deep Ocean")
AutomationCore.SetZoneCast("Bluefin Tuna Abundance")

-- Disable zone casting
AutomationCore.SetZoneCast("")
```

### Rod Management
```lua
-- Set preferred rod for auto-equip
AutomationCore.SetPreferredRod("Rod of the Depths")

-- Get available rods
local rods = AutomationCore.GetRodsFromInventory()
for i, rod in pairs(rods) do
    print(i, rod.Name)
end
```

### Emergency Controls
```lua
-- Stop all automation
AutomationCore.Stop()

-- Individual flag disable
AutomationCore.SetFlag("autocast", false)
AutomationCore.SetFlag("autoreel", false)
```

## 🛠️ Available Flags

### Basic Automation
- `autocast` - Enable auto casting
- `autoreel` - Enable auto reeling  
- `autoshake` - Enable auto shake
- `autocastdelay` - Delay between casts (seconds)
- `autoreeldelay` - Delay between reels (seconds)

### Advanced Features
- `superinstantreel` - Ultra-fast fish catching
- `instantbobber` - No animation casting
- `enhancedinstantbobber` - Enhanced boat penetration
- `predictiveautocast` - Zero-gap casting
- `superinstantnoanimation` - Disable all animations

### Auto Systems
- `autofishingloop` - Master auto fishing toggle
- `autoequiprod` - Auto equip fishing rod
- `autoappraise` - Auto appraise fish
- `autozonecast` - Enable zone casting
- `freezechar` - Freeze character position

### Configuration
- `equipdelay` - Delay after equipping rod (seconds)
- `appraisedelay` - Delay between appraisals (seconds)
- `appraisemode` - Appraise mode (1=NPC, 2=Anywhere)
- `freezecharmode` - Freeze mode ("Toggled" or "Rod Equipped")

## ⚠️ Important Notes

1. **Performance**: Automation core has no debug output for better performance
2. **Compatibility**: Works with all major Roblox executors
3. **Updates**: Auto-loads latest version from GitHub
4. **Safety**: Includes emergency stop functions
5. **UI Integration**: Rayfield UI automatically connects to automation core

## 🐛 Troubleshooting

### Common Issues

**UI not loading:**
```lua
-- Try loading individually
local AutomationCore = loadstring(game:HttpGet('https://raw.githubusercontent.com/donitono/bypass/main/automation_core.lua'))()
```

**Features not working:**
```lua
-- Check if features are enabled
print("Auto Cast:", AutomationCore.GetFlag("autocast"))
print("Auto Reel:", AutomationCore.GetFlag("autoreel"))

-- Emergency stop and restart
AutomationCore.Stop()
wait(2)
-- Reload the script
```

**Zone cast not working:**
```lua
-- Ensure you have a rod equipped and cast first
-- Then enable zone cast from UI or:
AutomationCore.SetZoneCast("Deep Ocean")
```

## 📊 System Status

Use the UI "System Status" section to check:
- Current automation states
- Active features
- Emergency stop function

## 🔄 Updates

The system automatically loads the latest version from GitHub. No manual updates needed!

---

**Created by:** donitono  
**Repository:** https://github.com/donitono/bypass  
**UI Library:** Rayfield  
**Last Updated:** September 13, 2025