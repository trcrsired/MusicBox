local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local MusicBox = AceAddon:GetAddon("MusicBox")
local MusicBox_Options = AceAddon:GetAddon("MusicBox_Options")
local L = AceLocale:GetLocale("MusicBox_Options")
local wipe = wipe
local pairs = pairs
local MusicBox_RemovePlaylist = MusicBox.RemovePlaylist

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local remove_tb = {}

local mainline_music_option_tb = 
{
	order = get_order(),
	name = L["Play Game Music from Retail WoW"],
	desc = L.Mainline_desc,
	width = "full",
	type = "toggle",
	set = function(_,val)
		if not val then
			val = nil
		end
		MusicBox.db.profile.mainline_music = val
		MusicBox:PLAYER_UPDATE_RESTING()
	end,
	get = function()
		return MusicBox.db.profile.mainline_music
	end
}

local playlist =
{
	name = L["Playlist"],
	type = "group",
	args =
	{
		game =
		{
			order = get_order(),
			name = GAME,
			type = "toggle",
			set = function(_,val)
				MusicBox.db.profile.game_music = val
				if val then
					MusicBox:OnEnable()
				end
			end,
			get = function()
				return MusicBox.db.profile.game_music
			end
		},
		mainline_music = (WOW_PROJECT_MAINLINE~= WOW_PROJECT_ID) and mainline_music_option_tb or nil,
		temp =
		{
			order = get_order(),
			name = ENABLE,
			type = "execute",
			func = function()
				LoadAddOn("MusicBox_GameMusic")
			end
		},
		ingamemusicbypath = 
		{
			order = get_order(),
			name = L["Play Game Music With Path"],
			desc = L.Playgamemusicpath_desc,
			type = "toggle",
			width = "full",
			set = function(_,val)
				MusicBox.db.profile.game_music_use_path = val
				if val then
					MusicBox:OnEnable()
				end
			end,
			get = function()
				return MusicBox.db.profile.game_music_use_path
			end
		},
		Add =
		{
			order = get_order(),
			name = ADD,
			type = "input",
			set = function(info,val)
				if val == "" then
					return
				end
				MusicBox:AddPlaylist(val,{})
			end,
			get = function(info) end,
			width = "full",
		},
		Remove =
		{
			order = get_order(),
			name = REMOVE,
			type = "execute",
			func = function()
				for k,v in pairs(remove_tb) do
					if v then
						MusicBox_RemovePlaylist(MusicBox,k)
					end
				end
			end
		},
		Cancel =
		{
			order = get_order(),
			name = CANCEL,
			type = "execute",
			func = function()
				wipe(remove_tb)
			end
		},
		Playlist =
		{
			order = get_order(),
			name = L["Playlist"],
			type = "multiselect",
			values = MusicBox_Options.GenerateRWPlayListValues,
			set = function(info,key,val)
				remove_tb[key] = val
			end,
			get = function(info,key) return remove_tb[key] end,
			width = "full",
		},
	}
}

MusicBox_Options:push("playlist",playlist)
