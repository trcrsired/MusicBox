#pragma once

#include<string>
#include<stdexcept>
#include<array>
#include<system_error>

namespace mci
{
	template<typename T>
	std::string get_error_string(T const& v)
	{
		std::array<char,129> c_style_string_buffer;
		if(!mciGetErrorString(v,c_style_string_buffer.data(),c_style_string_buffer.size()))
			throw std::runtime_error("mciGetErrorString failed");
		return c_style_string_buffer.data();
	}
}
