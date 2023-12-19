/******************************************************************************

The MIT License (MIT)

Copyright (c) 2018 cqwrteur

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

******************************************************************************/

#ifndef MCI_H
#define MCI_H
#include<cstdint>
#define WIN32_LEAN_AND_MEAN
#include<windows.h>
#include<mmsystem.h>
#include<chrono>

#include"mci_api_wrapper.h"
#include"status.h"
#include"play.h"

#pragma comment(lib,"winmm.lib")
namespace mci
{
	class mci
	{
		MCIDEVICEID id;
		
		void close() noexcept
		{
			if(id)
				mciSendCommand(id, MCI_CLOSE, 0, 0);
		}
	public:
		MCIDEVICEID native_handle() noexcept
		{
			return id;
		}
		mci(const std::string& device,const std::string &name)
		{
			MCI_OPEN_PARMS open{};
			open.lpstrDeviceType = device.c_str();
			open.lpstrElementName = name.c_str();
			send_command(0, MCI_OPEN, MCI_OPEN_ELEMENT, reinterpret_cast<std::size_t>(&open));
			id = open.wDeviceID;
		}
		mci(const mci&) = delete;
		mci& operator=(const mci&) = delete;
		mci(mci&& b) noexcept : id(b.id)
		{
			b.id = 0;
		}
		mci& operator=(mci&& b) noexcept
		{
			if(this!=&b)
			{
				close();
				id=b.id;
				b.id=0;
			}
			return *this;
		}
		template<typename... Args>
		void send(Args&& ...args)
		{
			send_command(id,std::forward<Args>(args)...);
		}
	private:	
		template<typename T>
		std::uint32_t mcistatus(const T& s,MCI_STATUS_PARMS &parms)
		{
			send(MCI_STATUS,s,reinterpret_cast<std::size_t>(&parms));
			return parms.dwReturn;
		}
		template<typename T>
		void mciplay(const T& s,MCI_PLAY_PARMS &parms)
		{
			send(MCI_PLAY,s,reinterpret_cast<std::size_t>(&parms));
		}
	public:
		std::uint32_t send(status::other_status e)
		{
			MCI_STATUS_PARMS parms{};
			return mcistatus(e,parms);
		}
		std::uint32_t send(status::item e)
		{
			MCI_STATUS_PARMS parms{};
			parms.dwItem = static_cast<std::size_t>(e);
			return mcistatus(MCI_STATUS_ITEM,parms);
		}
		
		bool send(status::status_ready e)
		{
			MCI_STATUS_PARMS parms{};
			return mcistatus(e,parms);
		}
		void send(play::other_play e)
		{
			MCI_PLAY_PARMS parms{};
			mciplay(e,parms);
		}
		std::chrono::milliseconds duration()
		{
			return static_cast<std::chrono::milliseconds>(send(status::length));
		}
		~mci()
		{
			close();
		}
	};
	
}

#endif
