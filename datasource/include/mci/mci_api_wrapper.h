#pragma once

#include"error.h"

namespace mci
{

	
	template<typename... Args>
	void send_command(Args&& ...args)
	{
		auto ret(mciSendCommand(std::forward<Args>(args)...));
		if(ret)
			throw std::system_error(std::error_code(ret,std::system_category()),get_error_string(ret));
	}
}
