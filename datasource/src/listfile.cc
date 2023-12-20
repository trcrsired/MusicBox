#include<exception>
#include<string>
#include<string>
#include<algorithm>
#include<vector>
#include<tuple>
#include<string_view>
#include<chrono>
#include"mci/mci.h"
#include<fast_io.h>
#include<fast_io_device.h>
#include<fast_io_dsal/vector.h>
#include<map>

int main(int argc,char **argv) 
try
{
	using namespace ::fast_io::io;
	fast_io::ibuf_file ibf(u8"listfile.csv");
	using namespace std::literals;
	auto const prefix(";sound/music/"s);
	fast_io::vector<std::pair<::std::size_t,::std::uint_least64_t>> vec;
	fast_io::obuf_file obf2(u8"listfile_music.lua");
	print(obf2,
R"acef(local MB=LibStub("AceAddon-3.0"):GetAddon("MusicBox")
MB.listfile_music={
)acef");
	::fast_io::vector<::std::string> prefixes;
	::std::map<::std::string,::std::size_t> prefixesmp;
	for(std::string line;scan<true>(ibf,::fast_io::mnp::line_get(line));)
	{
		std::size_t const prefix_pos(line.find(prefix));
		if(prefix_pos!=std::string::npos)
			try
			{
				auto mline(line.substr(prefix_pos+1));
				mci::mci p("mpegaudio"s,mline);
				auto pos(line.rfind('/'));
				constexpr
					::std::uint_least64_t con{::fast_io::uint_least64_subseconds_per_second/1000u};
				::std::chrono::milliseconds millisec{p.duration()};
				std::uint_least64_t v{static_cast<std::uint_least64_t>(millisec.count())};
				fast_io::unix_timestamp ts{static_cast<std::int_least64_t>(v/UINT64_C(1000)),(v%UINT64_C(1000))*con};
				auto prefixstrvw(line.substr(prefix_pos+1,pos-prefix_pos-1));
				::std::size_t prefixval{};
				auto iter{prefixesmp.find(prefixstrvw)};
				if(iter==prefixesmp.cend())
				{
					prefixval=prefixes.size();
					prefixesmp[prefixstrvw]=prefixes.size();
					prefixes.emplace_back(prefixstrvw);
				}
				else
				{
					prefixval=iter->second;
				}
				auto filedataid = line.substr(0,prefix_pos);
				vec.emplace_back(prefixval,
					::fast_io::to<::std::uint_least64_t>(filedataid));
				print(obf2,"[",filedataid,"]={",prefixval+1u,",\"",line.substr(pos+1),"\",",ts,"},\n");
			}
			catch(std::exception const& e)
			{
				perrln(line,":\t\t",fast_io::mnp::os_c_str(e.what()));
			}
	}
print(obf2,"}\n\nMB.listfile_music_prefix={\n");
	for(auto const &ele : prefixes)
	{
		print(obf2,"\"",ele,"\",\n");
	}
print(obf2,"}\n");
	::std::ranges::sort(vec);
	fast_io::obuf_file obf(u8"GameMusic.lua");
	print(obf,
R"acef(local MB=LibStub("AceAddon-3.0"):GetAddon("MusicBox")
local atp=MB.AddTempPlaylist
)acef");
	::std::size_t s{SIZE_MAX};
	for(const auto &ele : vec)
	{
		if(ele.first!=s)
		{
			if(s!=SIZE_MAX)
				print(obf,"})\n");
			s=ele.first;
			print(obf,"atp(MB,",ele.first+1u,",{");
		}
		print(obf,ele.second,",");
	}
	if(s!=SIZE_MAX)
	{
		print(obf,"})\n");
	}
}
catch(std::exception const &e)
{
	perrln(fast_io::mnp::os_c_str(e.what()));
	return 1;
}