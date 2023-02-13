local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")

local zoneid_music_map =
{
[1453] = --stormwind
{
{5320,54.911,"stormwind01-moment.mp3","sound/music/citymusic/stormwind"},
{5320,35.658,"stormwind02-moment.mp3","sound/music/citymusic/stormwind"},
{5320,70.016,"stormwind03-moment.mp3","sound/music/citymusic/stormwind"},
{5320,62.408,"stormwind04-zone.mp3","sound/music/citymusic/stormwind"},
{5320,61.108,"stormwind05-zone.mp3","sound/music/citymusic/stormwind"},
{5320,53.761,"stormwind06-zone.mp3","sound/music/citymusic/stormwind"},
{5320,87.094,"stormwind07-zone.mp3","sound/music/citymusic/stormwind"},
{5320,77.369,"stormwind08-zone.mp3","sound/music/citymusic/stormwind"},
{5321,133.174,"stormwind_highseas-moment.mp3","sound/music/citymusic/stormwind"},
{5321,66.855,"stormwind_intro-moment.mp3","sound/music/citymusic/stormwind"},
{5325,16.358,"sacred01.mp3","sound/music/musical moments/sacred"},
{5325,19.154,"sacred02.mp3","sound/music/musical moments/sacred"},
{5318,85.075,"darnassus walking 1.mp3","sound/music/citymusic/darnassus"},
{5318,69.558,"darnassus walking 2.mp3","sound/music/citymusic/darnassus"},
{5318,67.703,"darnassus walking 3.mp3","sound/music/citymusic/darnassus"},
{5323,64.083,"magic01-moment.mp3","sound/music/musical moments/magic"},
{5323,33.337,"magic01-zone1.mp3","sound/music/musical moments/magic"},
{5323,39.450,"magic01-zone2.mp3","sound/music/musical moments/magic"},
{44176,73.262,"mus_stormwind_gu01.mp3","sound/music/cataclysm"},
{44176,38.342,"mus_stormwind_gu02.mp3","sound/music/cataclysm"},
{44176,116.342,"mus_stormwind_gu03.mp3","sound/music/cataclysm"},
{44176,66.158,"mus_stormwind_gu04.mp3","sound/music/cataclysm"},
{44329,111.668,"mus_cataclysm_ud07.mp3","sound/music/cataclysm"},
{44329,111.668,"mus_cataclysm_un08.mp3","sound/music/cataclysm"},
{44329,111.668,"mus_cataclysm_un09.mp3","sound/music/cataclysm"},
{77272,119.441,"mus_51_alliancebattlemarch_01.mp3","sound/music/pandaria"},
{77272,119.057,"mus_51_alliancebattlemarch_02.mp3","sound/music/pandaria"},
{77272,119.681,"mus_51_alliancebattlemarch_hero_01.mp3","sound/music/pandaria"},
{77272,128.419,"mus_51_forthealliance_01.mp3","sound/music/pandaria"},
{77273,100.507,"mus_51_forthealliance_02.mp3","sound/music/pandaria"},
{77273,66.883,"mus_51_forthealliance_03.mp3","sound/music/pandaria"},
{77273,67.363,"mus_51_forthealliance_04.mp3","sound/music/pandaria"},
{77273,67.675,"mus_51_forthealliance_05.mp3","sound/music/pandaria"},
{77273,128.035,"mus_51_forthealliance_hero_01.mp3","sound/music/pandaria"},
{77274,107.369,"mus_51_jainahomeland_lyrical_01.mp3","sound/music/pandaria"},
{77274,107.009,"mus_51_jainahomeland_lyrical_02.mp3","sound/music/pandaria"},
{77274,107.657,"mus_51_jainahomeland_lyrical_hero_01.mp3","sound/music/pandaria"},
{77274,102.881,"mus_51_jainahomeland_military_01.mp3","sound/music/pandaria"},
{77274,103.745,"mus_51_jainahomeland_military_02.mp3","sound/music/pandaria"},
{77274,41.993,"mus_51_jainahomeland_military_03.mp3","sound/music/pandaria"},
{77274,104.033,"mus_51_jainahomeland_military_hero_01.mp3","sound/music/pandaria"},
{141724,75.194,"mus_70_anduinpt1_a1.mp3","sound/music/legion"},
{141724,113.247,"mus_70_anduinpt1_a2.mp3","sound/music/legion"},
{141724,140.992,"mus_70_anduinpt1_b.mp3","sound/music/legion"},
{141724,137.964,"mus_70_anduinpt1_c.mp3","sound/music/legion"},
{141724,90.436,"mus_70_anduinpt1_d.mp3","sound/music/legion"},
{141724,71.096,"mus_70_anduinpt1_e.mp3","sound/music/legion"},
{141724,88.061,"mus_70_anduinpt1_h1.mp3","sound/music/legion"},
{141724,115.962,"mus_70_anduinpt1_h2.mp3","sound/music/legion"},
{141724,111.629,"mus_70_anduinpt2_b.mp3","sound/music/legion"},
{141724,54.418,"mus_70_anduinpt2_c.mp3","sound/music/legion"},
{141725,123.426,"mus_70_anduinpt2_h.mp3","sound/music/legion"},
},
[1454] = --orgrimmar
{
{5319,68.991,"orgrimmar01-moment.mp3","sound/music/citymusic/orgrimmar"},
{5319,68.943,"orgrimmar01-zone.mp3","sound/music/citymusic/orgrimmar"},
{5319,62.386,"orgrimmar02-moment.mp3","sound/music/citymusic/orgrimmar"},
{5320,62.386,"orgrimmar02-zone.mp3","sound/music/citymusic/orgrimmar"},
{5320,40.288,"orgrimmar_intro-moment.mp3","sound/music/citymusic/orgrimmar"},
{44157,124.765,"mus_durotara_gu01.mp3","sound/music/cataclysm"},
{44157,101.701,"mus_durotara_gu02.mp3","sound/music/cataclysm"},
{44158,101.701,"mus_durotara_gu03.mp3","sound/music/cataclysm"},
{44158,72.877,"mus_durotarb_gu01.mp3","sound/music/cataclysm"},
{44158,72.181,"mus_durotarb_gu02.mp3","sound/music/cataclysm"},
{44158,95.269,"mus_durotarb_gu03.mp3","sound/music/cataclysm"},
{44158,95.269,"mus_durotarb_gu04.mp3","sound/music/cataclysm"},
{44158,85.501,"mus_durotarc_gu01.mp3","sound/music/cataclysm"},
{44158,85.501,"mus_durotarc_gu02.mp3","sound/music/cataclysm"},
{44158,61.429,"mus_durotarc_gu03.mp3","sound/music/cataclysm"},
{44158,61.357,"mus_durotarc_gu04.mp3","sound/music/cataclysm"},
{44158,84.877,"mus_durotard_gu01.mp3","sound/music/cataclysm"},
{44159,84.973,"mus_durotard_gu02.mp3","sound/music/cataclysm"},
{77273,163.913,"mus_51_garroshtheme_a_01.mp3","sound/music/pandaria"},
{77273,166.193,"mus_51_garroshtheme_a_02.mp3","sound/music/pandaria"},
{77273,166.889,"mus_51_garroshtheme_a_hero_01.mp3","sound/music/pandaria"},
{77273,175.409,"mus_51_garroshtheme_b_01.mp3","sound/music/pandaria"},
{77273,174.305,"mus_51_garroshtheme_b_02.mp3","sound/music/pandaria"},
{77274,175.121,"mus_51_garroshtheme_b_hero_01.mp3","sound/music/pandaria"},
{79170,123.420,"mus_51_garroshtheme_big_divinebellfinale.mp3","sound/music/pandaria"},
{214568,121.972,"mus_80_vulpera_1_b.mp3","sound/music/battleforazeroth"},
{214568,95.794,"mus_80_vulpera_1_c.mp3","sound/music/battleforazeroth"},
{214569,123.956,"mus_80_vulpera_1_h.mp3","sound/music/battleforazeroth"},
{217916,39.026,"mus_80_vulpera_2_d.mp3","sound/music/battleforazeroth"},
{214569,75.801,"mus_80_vulpera_2_h.mp3","sound/music/battleforazeroth"},
}
}

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit

function MusicBox.mainlinefunction()
	local mapID = C_Map_GetBestMapForUnit("player")
	if mapID == nil then
		return
	end
	local zonemusic = zoneid_music_map[mapID]
	if zonemusic == nil then
		return
	end
	MusicBox:PlayPlaylist(zonemusic)
	return true
end
