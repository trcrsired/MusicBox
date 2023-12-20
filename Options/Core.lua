local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local MusicBox = AceAddon:GetAddon("MusicBox")
local MusicBox_Options = AceAddon:GetAddon("MusicBox_Options")

local optionsFrames = {}

function MusicBox_Options:OnInitialize()
	local options = MusicBox_Options : get_table()

	options.args.profile = AceDBOptions:GetOptionsTable(MusicBox.db)
	AceConfig:RegisterOptionsTable("MusicBox", options, nil)
	optionsFrames.general = AceConfigDialog:AddToBlizOptions("MusicBox", "MusicBox")
	self.optionsFrames = optionsFrames
	MusicBox.db.RegisterCallback(MusicBox, "OnProfileChanged", "LOADING_SCREEN_DISABLED")
	MusicBox.db.RegisterCallback(MusicBox, "OnProfileCopied", "LOADING_SCREEN_DISABLED")
	MusicBox.db.RegisterCallback(MusicBox, "OnProfileReset", "LOADING_SCREEN_DISABLED")
end
