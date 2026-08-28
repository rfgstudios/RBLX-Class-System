local Players = game:GetService("Players")
local Config = require(script:WaitForChild("Configuration"))

local SUBCLASSES = Config.SubClasses or {}
local DEFAULT_CLASS = Config.DefaultClass or "None"
local DEFAULT_SUBCLASS = Config.DefaultSubClass or "None"
local DEFAULT_COLOR_TABLE = Config.DefaultColor or {255, 255, 255}

local ATTR_CLASS = Config.Attributes.Class
local ATTR_SUBCLASS = Config.Attributes.SubClass
local ATTR_COLOR = Config.Attributes.Color

local function parseColor(rgbTable)
	if type(rgbTable) ~= "table" or #rgbTable ~= 3 then
		return Color3.fromRGB(255, 255, 255)
	end
	local r, g, b = tonumber(rgbTable[1]), tonumber(rgbTable[2]), tonumber(rgbTable[3])
	if not r or not g or not b then
		return Color3.fromRGB(255, 255, 255)
	end
	return Color3.fromRGB(r, g, b)
end

local DEFAULT_COLOR = parseColor(DEFAULT_COLOR_TABLE)

local ClassSystem = {}

local function normalizeName(value)
	value = tostring(value or "")
	return value:gsub("^%s+", ""):gsub("%s+$", ""):gsub('^"', ""):gsub('"$', ""):gsub("^'", ""):gsub("'$", "")
end

local function normalizeLookup(value)
	return string.lower(normalizeName(value))
end

local function isPlayer(player)
	return typeof(player) == "Instance" and player:IsA("Player")
end

local function setSecureAttribute(player, attrName, value)
	player:SetAttribute(attrName, value)
	local character = player.Character
	if character then
		character:SetAttribute(attrName, value)
	end
end

function ClassSystem.validateIdentity(className, subClassName)
	className = normalizeName(className)
	subClassName = normalizeName(subClassName)

	local matchedClass = nil
	local classData = nil

	for name, data in pairs(SUBCLASSES) do
		if normalizeLookup(name) == normalizeLookup(className) then
			matchedClass = name
			classData = data
			break
		end
	end

	if not matchedClass or not classData then
		return DEFAULT_CLASS, DEFAULT_SUBCLASS, DEFAULT_COLOR
	end

	local classColor = parseColor(classData.Color)
	local subClassList = classData.SubClass or {}

	if subClassName == "" or #subClassList == 0 or normalizeLookup(subClassName) == normalizeLookup(DEFAULT_SUBCLASS) then
		return matchedClass, DEFAULT_SUBCLASS, classColor
	end

	for _, subName in ipairs(subClassList) do
		if normalizeLookup(subName) == normalizeLookup(subClassName) then
			return matchedClass, subName, classColor
		end
	end

	return matchedClass, DEFAULT_SUBCLASS, classColor
end

function ClassSystem.setClass(player, className, subClassName)
	if not isPlayer(player) then return false end

	local validClass, validSubClass, activeColor = ClassSystem.validateIdentity(className, subClassName)

	setSecureAttribute(player, ATTR_CLASS, validClass)
	setSecureAttribute(player, ATTR_SUBCLASS, validSubClass)
	setSecureAttribute(player, ATTR_COLOR, activeColor)

	return true
end

function ClassSystem.getClass(player)
	if not isPlayer(player) then return DEFAULT_CLASS end
	return player:GetAttribute(ATTR_CLASS) or DEFAULT_CLASS
end

function ClassSystem.getSubclass(player)
	if not isPlayer(player) then return DEFAULT_SUBCLASS end
	return player:GetAttribute(ATTR_SUBCLASS) or DEFAULT_SUBCLASS
end

function ClassSystem.getColor(player)
	if not isPlayer(player) then return DEFAULT_COLOR end
	local color = player:GetAttribute(ATTR_COLOR)
	return typeof(color) == "Color3" and color or DEFAULT_COLOR
end

local function initializePlayer(player)
	player:GetAttributeChangedSignal(ATTR_CLASS):Connect(function()
		local currentClass = player:GetAttribute(ATTR_CLASS) or DEFAULT_CLASS
		local currentSubClass = player:GetAttribute(ATTR_SUBCLASS) or DEFAULT_SUBCLASS
		ClassSystem.setClass(player, currentClass, currentSubClass)
	end)

	player.CharacterAdded:Connect(function()
		task.defer(function()
			local currentClass = player:GetAttribute(ATTR_CLASS) or DEFAULT_CLASS
			local currentSubClass = player:GetAttribute(ATTR_SUBCLASS) or DEFAULT_SUBCLASS
			ClassSystem.setClass(player, currentClass, currentSubClass)
		end)
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	initializePlayer(player)
end
Players.PlayerAdded:Connect(initializePlayer)

warn("ClassSystem is developed by RFG Studio's")

return ClassSystem
