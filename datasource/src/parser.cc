int main()
{
	using namespace ::fast_io::io;
	using namespace ::std::string_view_literals;
	::fast_io::dir_file retaildir(u8"retail");
	::std::unordered_set<::std::uint_least64_t> uimapsidtb;
	{
	::csv::CSVReader tablecsv("UiMapAssignment.csv");
	::fast_io::obuf_file tablelua(at(retaildir),u8"UiMapIDToAreaID.lua");
	print(tablelua,R"(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MusicBox.UiMapIDToAreaID=
{)");
	for(auto const & row : tablecsv)
	{
		auto uimapid{row["UiMapID"].get<::std::uint_least64_t>()};
		auto areaid{row["AreaID"].get<::std::uint_least64_t>()};
		if(areaid!=0&&uimapid!=0)
		{
			uimapsidtb.insert(uimapid);
			print(tablelua,"[",uimapid,"]=",areaid,",\n");
		}
	}
	::csv::CSVReader tablecsvclassic("UiMapAssignment_Classic.csv");
	for(auto const & row : tablecsvclassic)
	{
		auto uimapid{row["UiMapID"].get<::std::uint_least64_t>()};
		auto areaid{row["AreaID"].get<::std::uint_least64_t>()};
		if(areaid!=0&&uimapid!=0)
		{
			if(!uimapsidtb.contains(uimapid))
			{
				print(tablelua,"[",uimapid,"]=",areaid,",\n");
			}
		}
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
		print(tablelua,"[",row["ID"].get_sv(),"]={",
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
