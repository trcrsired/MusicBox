struct UiMapAssignmentEntrySimple
{
::std::string Region_0,Region_1,Region_2,Region_3,Region_4,Region_5,ID;
::std::uint_least64_t areaid;
};

namespace dataparser
{

inline void add_uimapassignment_csv_to_tb(auto &uitablecsv,auto& assignments,auto& uimapsidtb)
{
	for(auto& row : uitablecsv)
	{
		auto uimapid{row["UiMapID"].template get<::std::uint_least64_t>()};
		auto areaid{row["AreaID"].template get<::std::uint_least64_t>()};
		if(uimapid!=0&&areaid!=0)
		{
			uimapsidtb[uimapid].push_back(::std::ranges::size(assignments));
			assignments.push_back(
				UiMapAssignmentEntrySimple{
						std::string{row["Region_0"].get_sv()},
						std::string{row["Region_1"].get_sv()},
						std::string{row["Region_2"].get_sv()},
						std::string{row["Region_3"].get_sv()},
						std::string{row["Region_4"].get_sv()},
						std::string{row["Region_5"].get_sv()},
						std::string{row["ID"].get_sv()},
						areaid});
		}
	}	
}
}

int main()
{
	using namespace ::fast_io::io;
	using namespace ::std::string_view_literals;
	::fast_io::dir_file retaildir(u8"retail");
	::std::map<::std::uint_least64_t,::fast_io::vector<::std::size_t>> uimapsidtb;
	{
	::std::vector<UiMapAssignmentEntrySimple> assignments;
	{
	::csv::CSVReader tablecsv("UiMapAssignment.csv");
	dataparser::add_uimapassignment_csv_to_tb(tablecsv,assignments,uimapsidtb);
	}
	{
	::csv::CSVReader tablecsv("UiMapAssignment_Classic.csv");
	dataparser::add_uimapassignment_csv_to_tb(tablecsv,assignments,uimapsidtb);
	}
	::fast_io::obuf_file tablelua(at(retaildir),u8"UiMapIDToAreaInfos.lua");
	print(tablelua,R"(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MusicBox.UiMapIDToAreaInfos=
{)");

	for(auto const & e : uimapsidtb)
	{
		print(tablelua ,"[",e.first,"]={\n");
		::std::unordered_set<::std::uint_least64_t> areaids;
		for(auto const & e1 : e.second)
		{
			auto &ref{assignments[e1]};
			auto areaid{ref.areaid};
			if(!areaids.count(areaid))
			{
				print(tablelua,"{",
					areaid,",",
					ref.Region_0,",",
					ref.Region_1,",",
					ref.Region_2,",",
					ref.Region_3,",",
					ref.Region_4,",",
					ref.Region_5,",",
					ref.ID,"},\n");
				areaids.insert(areaid);
			}
		}
		print(tablelua ,"}\n");
	}
print(tablelua,"}\n");
	}
	::std::unordered_set<::std::uint_least64_t> zonesoundkits;
	{
	::fast_io::obuf_file tablelua(at(retaildir),u8"AreaIDMusicInfo.lua");
	::csv::CSVReader tablecsv("AreaTable.csv");
	print(tablelua,R"(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MusicBox.AreaIDMusicInfo=
{)");
	for(auto const & row : tablecsv)
	{
		{
		auto ZoneMusicid = row["ZoneMusic"].get<::std::uint_least64_t>();
		if(ZoneMusicid)
		{
			zonesoundkits.insert(ZoneMusicid);
		}
		}
		{
		auto ZoneMusicid = row["UwZoneMusic"].get<::std::uint_least64_t>();
		if(ZoneMusicid)
		{
			zonesoundkits.insert(ZoneMusicid);
		}
		}
		print(tablelua,"[",row["ID"].get_sv(),"]={\"",
		row["ZoneName"].get_sv(),"\",\"",
		row["AreaName_lang"].get_sv(),"\",",
		row["ZoneMusic"].get_sv(),",",
		row["UwZoneMusic"].get_sv(),",",
		row["IntroSound"].get_sv(),",",
		row["UwIntroSound"].get_sv(),"},\n");
	}
print(tablelua,"}\n");
	}
	{
	::fast_io::obuf_file tablelua(at(retaildir),u8"ZoneIntroMusicTable.lua");
	::csv::CSVReader tablecsv("ZoneIntroMusicTable.csv");
	print(tablelua,R"(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MusicBox.ZoneIntroMusicTable=
{)");
	for(auto & row : tablecsv)
	{
		auto soundkitid = row["SoundID"].get<::std::uint_least64_t>();
		zonesoundkits.insert(soundkitid);
		print(tablelua,"[",row["ID"].get_sv(),"]={\"",
		row["Name"].get_sv(),"\",",
		row["SoundID"].get_sv(),",",
		row["Priority"].get_sv(),",",
		row["MinDelayMinutes"].get_sv(),"},\n");
	}
print(tablelua,"}\n");
	}

	{
	::fast_io::obuf_file tablelua(at(retaildir),u8"ZoneSoundKitIDToFiledataIDs.lua");
	::csv::CSVReader tablecsv("SoundKitEntry.csv");
	print(tablelua,R"(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MusicBox.ZoneSoundKitIDToFiledataIDs=
{)");
	::std::map<::std::uint_least64_t,::fast_io::vector<::std::uint_least64_t>> mp;
	for(auto const & row : tablecsv)
	{
		auto soundkitid = row["SoundKitID"].get<::std::uint_least64_t>();
		if(zonesoundkits.contains(soundkitid))
		{
			auto filedataid = row["FileDataID"].get<::std::uint_least64_t>();
			mp[soundkitid].push_back(filedataid);
		}
	}

	for(auto const & e : mp)
	{
		print(tablelua,"[",e.first,"]=");
		if(e.second.size()==1)
		{
			print(tablelua,e.second.front(),",\n");
		}
		else
		{
			print(tablelua,"{");
			for(auto const &e1 : e.second)
			{
				print(tablelua,e1,",");
			}
			print(tablelua,"},\n");
		}
	}
print(tablelua,"}\n");
	}
}
