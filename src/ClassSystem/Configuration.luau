local Configuration = {}

Configuration.SubClasses = {
	["Paramedics"] = {
		["Color"] = {255, 85, 85},
		SubClass = {}
	},
	["Police"] = {
		["Color"] = {255, 85, 85},
		SubClass = {}
	},
	["QQQ"] = {
		["Color"] = {255, 85, 85},
		SubClass = {}
	},
}

Configuration.DefaultClass = "None"
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
