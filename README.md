# RBLX-Class-System
A lightweight class, subclass management system for Roblox projects. Built to handle primary classes, subclasses across players and characters.

## Setup
Put `ClassSystem` inside **ServerScriptService**.

## Configuration

Edit `Configuration.luau` to define roles, defaults, and custom attribute names:
```lua
local Configuration = {}

Configuration.SubClasses = {
    ["Paramedics"] = {
        ["Color"] = {255, 85, 85},
        ["SubClass"] = {"Doctor", "Rescue"}
    },
    ["Police"] = {
        ["Color"] = {0, 100, 255},
        ["SubClass"] = {"Patrol", "SWAT"}
    }
}

Configuration.DefaultClass = "None"
Configuration.DefaultSubClass = "None"
Configuration.DefaultColor = {255, 255, 255}

Configuration.Attributes = {
    Class = "Class",
    Color = "ClassColor",
    SubClass = "SubClass",
}

Configuration.Remotes = {
    ClassEvent = "ClassSystemEvent",
}

return Configuration

```

## API Reference
### Server Methods

```lua
local ClassSystem = require(path.to.ClassSystem)

-- Set a player's class and subclass
ClassSystem.setClass(player, "Police", "SWAT")

-- Get player data
local currentClass = ClassSystem.getClass(player)
local currentSubClass = ClassSystem.getSubclass(player)
local classColor = ClassSystem.getColor(player)

```

### Client Remote Usage
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClassEvent = ReplicatedStorage:WaitForChild("ClassSystemEvent")

-- Request class or subclass update
ClassEvent:FireServer("SetClass", "Paramedics")
ClassEvent:FireServer("SetSubClass", "Doctor")

```

## License
MIT License. Free to use, modify, and distribute. Developed by RFG Studio's.
