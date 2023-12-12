local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")

--[[
Todo: Revamp this system
]]

local zoneid_music_map =
{
[1429] = -- Elwynn Forest
{
{
{53492,55.802,"dayforest01.mp3","sound/music/zonemusic/forest"},
{53493,72.625,"dayforest02.mp3","sound/music/zonemusic/forest"},
{53494,64.814,"dayforest03.mp3","sound/music/zonemusic/forest"},
{441849,122.732,"mus_westfall_gu02.mp3","sound/music/cataclysm"}}
},
[1453] = --Stormwind
{
{{53202,54.911,"stormwind01-moment.mp3","sound/music/citymusic/stormwind"},
{53203,35.658,"stormwind02-moment.mp3","sound/music/citymusic/stormwind"},
{53204,70.016,"stormwind03-moment.mp3","sound/music/citymusic/stormwind"},
{53205,62.408,"stormwind04-zone.mp3","sound/music/citymusic/stormwind"},
{53206,61.108,"stormwind05-zone.mp3","sound/music/citymusic/stormwind"},
{53207,53.761,"stormwind06-zone.mp3","sound/music/citymusic/stormwind"},
{53208,87.094,"stormwind07-zone.mp3","sound/music/citymusic/stormwind"},
{53209,77.369,"stormwind08-zone.mp3","sound/music/citymusic/stormwind"},
{53210,133.174,"stormwind_highseas-moment.mp3","sound/music/citymusic/stormwind"},
{53211,66.855,"stormwind_intro-moment.mp3","sound/music/citymusic/stormwind"},
{53250,16.358,"sacred01.mp3","sound/music/musical moments/sacred"},
{53251,19.154,"sacred02.mp3","sound/music/musical moments/sacred"},
{53184,85.075,"darnassus walking 1.mp3","sound/music/citymusic/darnassus"},
{53185,69.558,"darnassus walking 2.mp3","sound/music/citymusic/darnassus"},
{53186,67.703,"darnassus walking 3.mp3","sound/music/citymusic/darnassus"},
{53236,64.083,"magic01-moment.mp3","sound/music/musical moments/magic"},
{53237,33.337,"magic01-zone1.mp3","sound/music/musical moments/magic"},
{53238,39.450,"magic01-zone2.mp3","sound/music/musical moments/magic"},
{441764,73.262,"mus_stormwind_gu01.mp3","sound/music/cataclysm"},
{441765,38.342,"mus_stormwind_gu02.mp3","sound/music/cataclysm"},
{441766,116.342,"mus_stormwind_gu03.mp3","sound/music/cataclysm"},
{441767,66.158,"mus_stormwind_gu04.mp3","sound/music/cataclysm"},
{443295,111.668,"mus_cataclysm_ud07.mp3","sound/music/cataclysm"},
{443296,111.668,"mus_cataclysm_un08.mp3","sound/music/cataclysm"},
{443297,111.668,"mus_cataclysm_un09.mp3","sound/music/cataclysm"},
{772726,119.441,"mus_51_alliancebattlemarch_01.mp3","sound/music/pandaria"},
{772727,119.057,"mus_51_alliancebattlemarch_02.mp3","sound/music/pandaria"},
{772728,119.681,"mus_51_alliancebattlemarch_hero_01.mp3","sound/music/pandaria"},
{772729,128.419,"mus_51_forthealliance_01.mp3","sound/music/pandaria"},
{772730,100.507,"mus_51_forthealliance_02.mp3","sound/music/pandaria"},
{772731,66.883,"mus_51_forthealliance_03.mp3","sound/music/pandaria"},
{772732,67.363,"mus_51_forthealliance_04.mp3","sound/music/pandaria"},
{772733,67.675,"mus_51_forthealliance_05.mp3","sound/music/pandaria"},
{772734,128.035,"mus_51_forthealliance_hero_01.mp3","sound/music/pandaria"},
{772741,107.369,"mus_51_jainahomeland_lyrical_01.mp3","sound/music/pandaria"},
{772742,107.009,"mus_51_jainahomeland_lyrical_02.mp3","sound/music/pandaria"},
{772743,107.657,"mus_51_jainahomeland_lyrical_hero_01.mp3","sound/music/pandaria"},
{772744,102.881,"mus_51_jainahomeland_military_01.mp3","sound/music/pandaria"},
{772745,103.745,"mus_51_jainahomeland_military_02.mp3","sound/music/pandaria"},
{772746,41.993,"mus_51_jainahomeland_military_03.mp3","sound/music/pandaria"},
{772747,104.033,"mus_51_jainahomeland_military_hero_01.mp3","sound/music/pandaria"},
{1417240,75.194,"mus_70_anduinpt1_a1.mp3","sound/music/legion"},
{1417241,113.247,"mus_70_anduinpt1_a2.mp3","sound/music/legion"},
{1417242,140.992,"mus_70_anduinpt1_b.mp3","sound/music/legion"},
{1417243,137.964,"mus_70_anduinpt1_c.mp3","sound/music/legion"},
{1417244,90.436,"mus_70_anduinpt1_d.mp3","sound/music/legion"},
{1417245,71.096,"mus_70_anduinpt1_e.mp3","sound/music/legion"},
{1417246,88.061,"mus_70_anduinpt1_h1.mp3","sound/music/legion"},
{1417247,115.962,"mus_70_anduinpt1_h2.mp3","sound/music/legion"},
{1417248,111.629,"mus_70_anduinpt2_b.mp3","sound/music/legion"},
{1417249,54.418,"mus_70_anduinpt2_c.mp3","sound/music/legion"},
{1417250,123.426,"mus_70_anduinpt2_h.mp3","sound/music/legion"}}
},
[1454] = --orgrimmar
{
{{53197,68.991,"orgrimmar01-moment.mp3","sound/music/citymusic/orgrimmar"},
{53198,68.943,"orgrimmar01-zone.mp3","sound/music/citymusic/orgrimmar"},
{53199,62.386,"orgrimmar02-moment.mp3","sound/music/citymusic/orgrimmar"},
{53200,62.386,"orgrimmar02-zone.mp3","sound/music/citymusic/orgrimmar"},
{53201,40.288,"orgrimmar_intro-moment.mp3","sound/music/citymusic/orgrimmar"},
{441578,124.765,"mus_durotara_gu01.mp3","sound/music/cataclysm"},
{441579,101.701,"mus_durotara_gu02.mp3","sound/music/cataclysm"},
{441580,101.701,"mus_durotara_gu03.mp3","sound/music/cataclysm"},
{441581,72.877,"mus_durotarb_gu01.mp3","sound/music/cataclysm"},
{441582,72.181,"mus_durotarb_gu02.mp3","sound/music/cataclysm"},
{441583,95.269,"mus_durotarb_gu03.mp3","sound/music/cataclysm"},
{441584,95.269,"mus_durotarb_gu04.mp3","sound/music/cataclysm"},
{441585,85.501,"mus_durotarc_gu01.mp3","sound/music/cataclysm"},
{441586,85.501,"mus_durotarc_gu02.mp3","sound/music/cataclysm"},
{441587,61.429,"mus_durotarc_gu03.mp3","sound/music/cataclysm"},
{441588,61.357,"mus_durotarc_gu04.mp3","sound/music/cataclysm"},
{441589,84.877,"mus_durotard_gu01.mp3","sound/music/cataclysm"},
{441590,84.973,"mus_durotard_gu02.mp3","sound/music/cataclysm"},
{772735,163.913,"mus_51_garroshtheme_a_01.mp3","sound/music/pandaria"},
{772736,166.193,"mus_51_garroshtheme_a_02.mp3","sound/music/pandaria"},
{772737,166.889,"mus_51_garroshtheme_a_hero_01.mp3","sound/music/pandaria"},
{772738,175.409,"mus_51_garroshtheme_b_01.mp3","sound/music/pandaria"},
{772739,174.305,"mus_51_garroshtheme_b_02.mp3","sound/music/pandaria"},
{772740,175.121,"mus_51_garroshtheme_b_hero_01.mp3","sound/music/pandaria"},
{791703,123.420,"mus_51_garroshtheme_big_divinebellfinale.mp3","sound/music/pandaria"},
{2145688,121.972,"mus_80_vulpera_1_b.mp3","sound/music/battleforazeroth"},
{2145689,95.794,"mus_80_vulpera_1_c.mp3","sound/music/battleforazeroth"},
{2145690,123.956,"mus_80_vulpera_1_h.mp3","sound/music/battleforazeroth"},
{2179161,39.026,"mus_80_vulpera_2_d.mp3","sound/music/battleforazeroth"},
{2145694,75.801,"mus_80_vulpera_2_h.mp3","sound/music/battleforazeroth"}}
}
}

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime

function MusicBox.mainlinefunction()
	local mapID = C_Map_GetBestMapForUnit("player")
	if mapID == nil then
		return
	end
	local zonemusic = zoneid_music_map[mapID]
	if zonemusic == nil then
		return
	end
	local zonemusictp = zonemusic[1]
	if C_DateAndTime_GetCurrentCalendarTime and zonemusic[2] then
		local currentCalenderTime = C_DateAndTime.GetCurrentCalendarTime()
		if currentCalenderTime then
			local hour = currentCalenderTime.hour
			if hour < 6 or 18 <= hour then -- isnight
				zonemusictp = zonemusic[2]
			end
		end
	end
	MusicBox:PlayPlaylist(zonemusictp)
	return true
end
