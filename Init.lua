local LibStub = LibStub
local MusicBox = LibStub("AceAddon-3.0"):NewAddon("MusicBox","AceEvent-3.0","AceConsole-3.0","AceTimer-3.0","AceHook-3.0")

--------------------------------------------------------------------------------------
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigCmd = LibStub("AceConfigCmd-3.0")
--------------------------------------------------------------------------------------

local C_AddOns = C_AddOns
if C_AddOns == nil then
	C_AddOns = _G
end

local LoadAddOn = C_AddOns.LoadAddOn
local GetNumAddOns = C_AddOns.GetNumAddOns
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local GetAddOnInfo = C_AddOns.GetAddOnInfo

function MusicBox:OnInitialize()
	local ismainline = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
	self.db = LibStub("AceDB-3.0"):New("MusicBoxDB",
	{
		profile = 
		{
			playlists = {},
			playing = true,
			game_music = ismainline,
			game_music_use_path = not ismainline
		}
	})
	self.temp_playlist = {}
	self:RegisterChatCommand("MusicBox", "ChatCommand")
	self:RegisterChatCommand("MB", "ChatCommand")
--	self:RegisterEvent("PLAYER_UPDATE_RESTING")
	self:RegisterEvent("PET_BATTLE_CLOSE","LOADING_SCREEN_DISABLED")
	self:RegisterEvent("CINEMATIC_STOP","LOADING_SCREEN_DISABLED")
	self:RegisterEvent("SOUND_DEVICE_UPDATE","LOADING_SCREEN_DISABLED")
	self:SecureHook("SetCVar")
	self:SecureHook("PlayMusic","HookPlayMusic")
	self:SecureHook("StopMusic","HookStopMusic")
end

function MusicBox:ChatCommand(input)
	if IsAddOnLoaded("MusicBox_Options") == false then
		local loaded , reason = LoadAddOn("MusicBox_Options")
		if loaded == false then
			self:Print("MusicBox_Options: "..reason)
			return
		end
	end
	if not input or input:trim() == "" then
		AceConfigDialog:Open("MusicBox")
	else
		AceConfigCmd:HandleCommand("MusicBox", "MusicBox","")
		AceConfigCmd:HandleCommand("MusicBox", "MusicBox",input)
	end
end
