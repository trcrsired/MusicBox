local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
local PlayMusic = PlayMusic
local StopMusic = StopMusic
local type = type
local LoadAddOn = LoadAddOn

function MusicBox:PlayMusic(music)
	if self.db.profile.playing == true and music then
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
		end
		local length = 0.1
		local toplay
		if type(music) == "table" then
			length = music[2]
			toplay = music[1]
		elseif type(music) == "number" then
			local listfile_music = self.listfile_music
			if listfile_music == nil then
				LoadAddOn("MusicBox_GameMusic")
				listfile_music = self.listfile_music
			end
			local listfile_music_prefix = self.listfile_music_prefix
			local musicinfo = listfile_music[music]
			length = musicinfo[3]
			if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
				toplay = music
			else
				toplay = format("%s/%s",self.listfile_music_prefix[musicinfo[1]],musicinfo[2])
			end
		end
		if 2 < length then
			self.now_playing = music
			PlayMusic(toplay)
			self.timer = self:ScheduleTimer("TimerFeedBack",length-2)
		else
			StopMusic()
			self.timer = self:ScheduleTimer("TimerFeedBack",0.1)
		end
	end
end

function MusicBox:StopMusic()
	if self.timer then
		self:CancelTimer(self.timer)
		self.timer = nil
		self.now_playing = nil
		StopMusic()
	end
end


local shuffle_order = {}
local order_pos = 0
local random = random
local wipe = wipe
local function shuffle_order_playlist(pl)
	wipe(shuffle_order)
	order_pos = 0
	local i
	for i = 1,#pl do
		shuffle_order[i] = i;
	end
	for i = #shuffle_order,2,-1 do
		local r = random(1,i)
		local t = shuffle_order[r]
		shuffle_order[r] = shuffle_order[i]
		shuffle_order[i] = t
	end
end

local current_playlist
local await_playlist

function MusicBox:NextMusic()
	if self.db.profile.playing and current_playlist then
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			self.now_playing = nil
		end
		self:TimerFeedBack()
	end
end
function MusicBox:TimerFeedBack()
	if await_playlist then
		current_playlist = await_playlist
		await_playlist = nil
		shuffle_order_playlist(current_playlist)
	end
	if current_playlist == nil or #current_playlist == 0 then
		self:StopMusic()
		return
	end
	if #current_playlist ~= #shuffle_order or order_pos==#shuffle_order  then
		shuffle_order_playlist(current_playlist)
	end
	order_pos = order_pos + 1
	self:PlayMusic(current_playlist[shuffle_order[order_pos]])
end

function MusicBox:Stop()
	self:StopMusic()
	current_playlist = nil
end

local cvar_sound_enablemusic

local function feedback()
	if cvar_sound_enablemusic ~= nil then
		SetCVar("Sound_EnableMusic",cvar_sound_enablemusic)
		cvar_sound_enablemusic = nil
	end
end

function MusicBox:GetCurrentPlayList()
	return current_playlist
end

function MusicBox:PlayPlaylist(pl)
	if current_playlist ~= pl then
		current_playlist = pl
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			self.now_playing = nil
			self:TimerFeedBack()
		else
			if cvar_sound_enablemusic == nil then
				cvar_sound_enablemusic = GetCVar("Sound_EnableMusic")
				SetCVar("Sound_EnableMusic",false)
				C_Timer.After(1,feedback)
			end
		end
	end
end

function MusicBox:SetAwaitPlayList(pl)
	if current_playlist == pl then
		return
	end
	if current_playlist == nil then
		self:PlayPlaylist(pl)
		await_playlist = nil
	else
		await_playlist = pl
	end
end

function MusicBox:Start()
	local music_enable = GetCVar("Sound_EnableMusic")
	if music_enable==true or music_enable==1 or music_enable == "1" then
		music_enable = true
	end
	if music_enable and self.db.profile.playing == true and current_playlist then
		shuffle_order_playlist(current_playlist)
		self:TimerFeedBack()
	else
		self:StopMusic()
	end
end

function MusicBox:HookPlayMusic(music)
	self:StopMusic()
	PlayMusic(music)
end

function MusicBox:HookStopMusic()
	self:Start()
end

function MusicBox:HookPlayMusic()
	if self.timer then
		self:CancelTimer(self.timer)
		self.timer = nil
		self.now_playing = nil
	end
end

function MusicBox:HookStopMusic()
	self:Start()
end

function MusicBox:SetCVar(name, val)
	if name == "Sound_EnableMusic" then
		self:Start()
	end
end
