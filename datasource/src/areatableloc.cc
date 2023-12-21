int main(int argc,char **argv)
{
	if(argc < 3)
	{
		if(argc==0)
		{
			return 1;
		}
		perr("Usage:",::fast_io::mnp::os_c_str(*argv)," <AreaTable CSV Dir> <AreaTable Lua Output Dir>\n");
		return 1;
	}
	using namespace ::fast_io::io;
	using namespace ::std::string_view_literals;
	::fast_io::dir_file csvdir(::fast_io::mnp::os_c_str(argv[1]));
	::fast_io::dir_file luadir(::fast_io::mnp::os_c_str(argv[2]));
	for(auto ent : current(at(csvdir)))
	{
		if(type(ent)!=::fast_io::file_type::regular)
		{
			continue;
		}
		if(::std::u8string_view(u8extension(ent))==u8".csv"sv)
		{
			::csv::CSVReader tablecsv(::fast_io::concat(::fast_io::mnp::os_c_str(argv[1]),"/",ent));
			::std::map<::std::uint_least64_t,::std::map<::std::string,::std::uint_least64_t>> mp;
			for(auto & row : tablecsv)
			{
				::std::uint_least64_t parentareaid{row["ParentAreaID"].get<::std::uint_least64_t>()};
				if(!parentareaid)
				{
					continue;
				}
				mp[parentareaid][::std::string(row["AreaName_lang"].get_sv())]=row["ID"].get<::std::uint_least64_t>();
			}
			::fast_io::obuf_file obf(at(luadir),::fast_io::u8concat(u8stem(ent),u8".lua"));
			::std::u8string_view localename{u8stem(ent)};
			bool isenus{localename == u8"enUS"sv};
			print(::fast_io::u8c_stdout(),u8"AreaTableSubZoneLocale/",localename,u8".lua\n");
			if(!isenus)
			{
				print(obf,"if GetLocale() != \"",::fast_io::mnp::code_cvt(localename),"\" then return end\n");
			}
			print(obf,R"abc(local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
)abc");
			if(isenus)
			{
				print(obf,"if MusicBox.AreaTableSubZoneLocale then return end\n");
			}
			print(obf,"MusicBox.AreaTableSubZoneLocale =\n{\n");
			for(auto const & e : mp)
			{
				print(obf,"[",e.first,"] = {");
				bool first{true};
				for(auto const & e1 : e.second)
				{
					if(first)
					{
						first=false;
					}
					else
					{
						print(obf,",");
					}
					print(obf,"[\"",e1.first,"\"] = ",e1.second);
				}
				print(obf,"},\n");
			}
			print(obf,"}\n");
		}
	}
}
