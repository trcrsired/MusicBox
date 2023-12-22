local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local GetSubZoneText = GetSubZoneText

local function add_soundentries_filedataids(soundentryid, mainlineplaylist, iswinterveil)
	if type(soundentryid) == "table" then
		for i=1,#soundentryid do
			mainlineplaylist[#mainlineplaylist+1] = soundentryid[i]
		end
		return
	end
	local fileids = MusicBox.SoundEntries[soundentryid]
	if fileids == nil then
		return
	end
	if type(fileids) == "number" then
		mainlineplaylist[#mainlineplaylist+1] = fileids
	else
		for i=1,#fileids do
			mainlineplaylist[#mainlineplaylist+1] = fileids[i]
		end
	end
end

local function add_area_songs(areaid,mainlineplaylist,isnight,iswinterveil)
	if areaid == nil then
		return
	end
	local areamusicinfo = MusicBox.AreaIDMusicInfo[areaid]
	if areamusicinfo == nil then
		return
	end
	local zonemusic = 0
	local zoneintro = 0
	if isnight then
		zonemusic = areamusicinfo[4]
		zoneintro = areamusicinfo[6]
	end
	if zonemusic == 0 then
		zonemusic = areamusicinfo[3]
	end
	if zoneintro == 0 then
		zoneintro = areamusicinfo[5]
	end
	local ZoneMusic = MusicBox.ZoneMusic

	if type(zonemusic) == "number" then
		local zm = ZoneMusic[zonemusic]
		if zm then
			add_soundentries_filedataids(zm[1], mainlineplaylist, iswinterveil)
		end
	elseif type(zonemusic) == "table" then
		for _,v in pairs(zonemusic) do
			local zm = ZoneMusic[v]
			if zm then
				add_soundentries_filedataids(zm[1], mainlineplaylist, iswinterveil)
			end
		end
	end
	if zoneintro ~= 0 then
		if type(zoneintro) == "number" then
			local introinfo = MusicBox.ZoneIntroMusicTable[zoneintro]
			if introinfo then
				local introzm = introinfo[2]
				if introzm then
					add_soundentries_filedataids(introzm, mainlineplaylist, iswinterveil)
				end
			end
		elseif type(zonemusic) == "table" then
			for _,v in pairs(zonemusic) do
				local introinfo = MusicBox.ZoneIntroMusicTable[v]
				if introinfo then
					local introzm = introinfo[2]
					if introzm then
						add_soundentries_filedataids(introzm, mainlineplaylist, iswinterveil)
					end
				end
			end
		end
	end
	local manualtweaks = MusicBox.zonefixup[areaid]
	if manualtweaks then
		--Zones needs sometweaks
		for i=1,#manualtweaks do
			add_soundentries_filedataids(manualtweaks[i], mainlineplaylist, iswinterveil)
		end
	end
	if iswinterveil then
		if areaid == 1637 or areaid == 1537 or areaid == 36 then -- Orgrimmar or Ironforge or Alterac Mountains
			for i=1530323,1530334 do
				mainlineplaylist[#mainlineplaylist+1] = i   --winterveil
			end
		end
	end
end

function MusicBox.mainlinefunction(subzonechanged)
	local mapID = C_Map_GetBestMapForUnit("player")
	if mapID == nil then
		return
	end
	local isnight
	local iswinterveil
	local currentCalenderTime = C_DateAndTime_GetCurrentCalendarTime()
	if currentCalenderTime then
		local hour = currentCalenderTime.hour
		isnight = hour < 6 or 18 <= hour
		local month = currentCalenderTime.month
		if month == 12 then
			local monthday = currentCalenderTime.monthDay
			iswinterveil = monthday and 15 <= monthday and monthday <= 31
		end
	end
	local areainfo = MusicBox.UiMapIDToAreaInfos[mapID]
	local mainlineplaylist = {}
	if areainfo then
		local a1 = areainfo[1]
		if a1 == nil then
			return
		end
		local areaid = a1[1]
		local subzonetext = GetSubZoneText()
		local subzoneareaid
		if subzonetext then
			local AreaTableSubZoneLocale = MusicBox.AreaTableSubZoneLocale
			local localesub = AreaTableSubZoneLocale[areaid]
			if localesub then
				subzoneareaid = localesub[subzonetext]
				if subzoneareaid == 8411 then -- Lion's Rest
					subzoneareaid = 5157 -- The Park
				end
			end
		end
		add_area_songs(areaid,mainlineplaylist,isnight,iswinterveil)
		add_area_songs(subzoneareaid,mainlineplaylist,isnight,iswinterveil)
	else
		local mpidfixup = MusicBox.mapidfixup[mapID]
		if mpidfixup == nil then
			return
		end
		for i=1,#mpidfixup do
			add_soundentries_filedataids(mpidfixup[i], mainlineplaylist, iswinterveil)
		end
	end
	if #mainlineplaylist ~= 0 then
		if subzonechanged then
			MusicBox:SetAwaitPlayList(mainlineplaylist)
		else
			MusicBox:PlayPlaylist(mainlineplaylist)
		end
		return mainlineplaylist
	end
end
