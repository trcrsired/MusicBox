local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local MusicBox = AceAddon:GetAddon("MusicBox")
local MusicBox_Icon = AceAddon:NewAddon("MusicBox_Icon","AceTimer-3.0")
local math_floor = math.floor
local string_format = string.format
local IsControlKeyDown = IsControlKeyDown

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("MusicBox",{
	type = "data source",
	label = "MusicBox",
	text = "MusicBox",
	icon = 133876
})

function LDB:OnClick(b)
	if b== "RightButton" then
		local profile = MusicBox.db.profile
		profile.playing = not profile.playing
		MusicBox:Start()
	elseif b=="LeftButton" then
		MusicBox:NextMusic()
	elseif b=="MiddleButton" then
		if not AceConfigDialog:Close("MusicBox") then
			MusicBox:ChatCommand()
		end
	end
end

function LDB:OnScroll(d)
	local cvar
	if IsControlKeyDown() then
		cvar = "Sound_MasterVolume"
	elseif IsShiftKeyDown() then
		cvar = "Sound_SFXVolume"	
	else
		cvar = "Sound_MusicVolume"
	end
	local music_vol = GetCVar(cvar)
	if d==-1 then
		music_vol = music_vol - 0.1
		if music_vol < 0 then
			music_vol = 0
		end
	else
		music_vol = music_vol + 0.1
		if 1<music_vol then
			music_vol = 1
		end
	end
	SetCVar(cvar,music_vol)
end

local function convert_sec_to_xx_xx_xx(value)
	local hour = value / 3600
	local min_sec = value % 3600
	local minute = min_sec / 60
	local sec = min_sec % 60
	return string_format("%02d:%02d:%02d",hour,minute,sec)
end

local expansion_names =
{
"Vanilla",
"The Burning Crusade",
"Wrath of the Lich King",
"Cataclysm",
"Mists of Pandaria",
"Warlords of Draenor",
"Legion",
"Battle For Azeroth",
"Shadowlands",
"Dragonflight",
}

local expansion_list = 
{
["sound/music/cataclysm"] = 4,
["sound/music/pandaria"] = 5,
["sound/music/draenor"] = 6,
["sound/music/legion"] = 7,
["sound/music/battleforazeroth"] = 8,
["sound/music/shadowlands"] = 9,
["sound/music/dragonflight"] = 10,
}

function MusicBox_Icon:TimerFeedback()
	GameTooltip:ClearLines()
	GameTooltip:AddLine("MusicBox",1,1,1)
	local now_playing = MusicBox.now_playing
	if now_playing then
		local nowplaying1 = now_playing[1]
		local nowplaying3 = now_playing[3]
		if nowplaying3 then
			GameTooltip:AddDoubleLine(nowplaying1,nowplaying3,nil,nil,nil,0.5,0.5,0.8,true)
		else
			GameTooltip:AddLine(nowplaying1,0.5,0.5,0.8,true)
		end
		local nowplaying4 = now_playing[4]
		if nowplaying4 then
			local expansion_version = expansion_list[nowplaying4]
			if expansion_version == nil then
				GameTooltip:AddDoubleLine(" ",nowplaying4)
			else
				local expansion_name = expansion_names[expansion_version]
				GameTooltip:AddDoubleLine(expansion_version,expansion_name,nil,nil,nil,0.5,0.5,0.8,true)
			end
		end
		if MusicBox.timer then
			local tleft = MusicBox:TimeLeft(MusicBox.timer)
			local tt = now_playing[2]
			GameTooltip:AddDoubleLine(convert_sec_to_xx_xx_xx(math_floor(tt-tleft)-2),convert_sec_to_xx_xx_xx(math_floor(tt)),0,1,1)
		end
	end
	GameTooltip:Show()
end

function LDB:OnEnter()
	self:EnableMouseWheel(1)
	self:SetScript("OnMouseWheel", LDB.OnScroll)
	GameTooltip:SetOwner(self)
	if MusicBox_Icon.timer then
		MusicBox_Icon:CancelTimer(MusicBox_Icon.timer)
	else
		MusicBox_Icon.timer = MusicBox_Icon:ScheduleRepeatingTimer("TimerFeedback", 1)
	end
	MusicBox_Icon:TimerFeedback()
end

function LDB:OnLeave(...)
	if MusicBox_Icon.timer then
		MusicBox_Icon:CancelTimer(MusicBox_Icon.timer)
		MusicBox_Icon.timer = nil
	end
	GameTooltip:Hide()
end

function MusicBox_Icon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MusicBox_IconCharacterDB", {profile = {}})
	self.ldb = LDB
	if not MusicBox.db.profile.disable_icon then
		self.icon = LibStub("LibDBIcon-1.0"):Register("MusicBox",self.ldb,self.db.profile)
	end
end
