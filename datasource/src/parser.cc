struct UiMapAssignmentEntrySimple
{
::std::string Region_0,Region_1,Region_2,Region_3,Region_4,Region_5,ID;
::std::uint_least64_t areaid;
};

struct AreaTableEntry_Classic
{
::std::uint_least64_t zonemusic,uwzonemusic,introsound,uwintrosound;
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
		print(tablelua ,"},\n");
	}
print(tablelua,"}\n");
	}
	::std::unordered_set<::std::uint_least64_t> zonesoundkits;
	{
	::csv::CSVReader tablecsv_classic("AreaTable_Classic.csv");
	::std::unordered_map<::std::uint_least64_t,AreaTableEntry_Classic> areatbclassic;
	for(auto const & row : tablecsv_classic)
	{
		auto id = row["ID"].get<::std::uint_least64_t>();
		auto zonemusic = row["ZoneMusic"].get<::std::uint_least64_t>();
		auto uwzonemusic = row["UwZoneMusic"].get<::std::uint_least64_t>();
		auto introsound = row["IntroSound"].get<::std::uint_least64_t>();
		auto uwintrosound = row["UwIntroSound"].get<::std::uint_least64_t>();
		areatbclassic[id]=AreaTableEntry_Classic{zonemusic,uwzonemusic,introsound,uwintrosound};
	}

	::fast_io::obuf_file tablelua(at(retaildir),u8"AreaIDMusicInfo.lua");
	::csv::CSVReader tablecsv("AreaTable.csv");
	
	print(tablelua,R"(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MusicBox.AreaIDMusicInfo=
{)");
	for(auto const & row : tablecsv)
	{
		auto id = row["ID"].get<::std::uint_least64_t>();
		auto ZoneMusicid = row["ZoneMusic"].get<::std::uint_least64_t>();
		{
		
		if(ZoneMusicid)
		{
			zonesoundkits.insert(ZoneMusicid);
		}
		}
		auto UwZoneMusicid = row["UwZoneMusic"].get<::std::uint_least64_t>();
		{
		if(UwZoneMusicid)
		{
			zonesoundkits.insert(UwZoneMusicid);
		}
		}
		print(tablelua,"[",row["ID"].get_sv(),"]={\"",
		row["ZoneName"].get_sv(),"\",\"",
		row["AreaName_lang"].get_sv(),"\",");

		auto introsound = row["IntroSound"].get<::std::uint_least64_t>();
		auto uwintrosound = row["UwIntroSound"].get<::std::uint_least64_t>();
		auto fdcl{areatbclassic.find(id)};
		if(fdcl!=areatbclassic.cend())
		{
			auto const& classicentry{fdcl->second};
			auto test_with_p([&](::std::uint_least64_t val,::std::uint_least64_t classicval)
			{
				if(val!=classicval)
				{
					print(tablelua,"{");
				}
				print(tablelua,val);
				if(val!=classicval)
				{
					print(tablelua,classicval,"}");
				}
				print(tablelua,",");
			});
			test_with_p(ZoneMusicid,classicentry.zonemusic);
			test_with_p(UwZoneMusicid,classicentry.uwzonemusic);
			test_with_p(introsound,classicentry.introsound);
			test_with_p(uwintrosound,classicentry.uwintrosound);
		}
		else
		{
			print(tablelua,ZoneMusicid,",",
			UwZoneMusicid,",",
			introsound,",",
			uwintrosound,"},\n");
		}
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
	::fast_io::obuf_file tablelua(at(retaildir),u8"ZoneMusic.lua");
	::csv::CSVReader tablecsv("ZoneMusic.csv");
	print(tablelua,R"(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MusicBox.ZoneMusic=
{)");
	::std::map<::std::uint_least64_t,::fast_io::vector<::std::uint_least64_t>> mp;
	for(auto const & row : tablecsv)
	{
		print(tablelua,"[",row["ID"].get_sv(),"]={",
		row["Sounds_0"].get_sv(),",",
		row["Sounds_1"].get_sv(),"},\n");
	}
print(tablelua,"}\n");
	}
}
