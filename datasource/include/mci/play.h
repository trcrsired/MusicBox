#ifndef MCI_PLAY_H
#define MCI_PLAY_H

#include<digitalv.h>
#include<mciavi.h>

namespace mci
{
	class play
	{
	public:
		enum other_play
		{
			dgv_repeat = MCI_DGV_PLAY_REPEAT,
			dgv_reverse = MCI_DGV_PLAY_REVERSE,
			mciavi_window = MCI_MCIAVI_PLAY_WINDOW,
			mciavi_fullscreen = MCI_MCIAVI_PLAY_FULLSCREEN,
		};
	};
}
#endif
