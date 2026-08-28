local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClassSystemFolder = script.Parent
local Config = require(ClassSystemFolder:WaitForChild("Configuration"))
local ClassSystem = require(ClassSystemFolder)

local remoteName = (Config.Remotes and Config.Remotes.ClassEvent) or "ClassSystemEvent"
local ClassEvent = ReplicatedStorage:FindFirstChild(remoteName) or Instance.new("RemoteEvent")
ClassEvent.Name = remoteName
ClassEvent.Parent = ReplicatedStorage

ClassEvent.OnServerEvent:Connect(function(player, action, value)
	if type(action) ~= "string" or type(value) ~= "string" then return end

	if action == "SetClass" then
		local currentSubClass = ClassSystem.getSubclass(player)
		ClassSystem.setClass(player, value, currentSubClass)

	elseif action == "SetSubClass" then
		local currentClass = ClassSystem.getClass(player)
		ClassSystem.setClass(player, currentClass, value)
	end
end)
