#ifndef MCI_STATUS_H
#define MCI_STATUS_H

namespace mci
{
	class status
	{
	public:
		enum item
		{
			length = MCI_STATUS_LENGTH,
			current_track = MCI_STATUS_CURRENT_TRACK
		};
		enum status_ready
		{
			ready = MCI_STATUS_READY,
		};
		enum other_status
		{
			number_of_tracks = MCI_STATUS_NUMBER_OF_TRACKS,
			position = MCI_STATUS_POSITION,
			mode = MCI_STATUS_MODE,
			time_format = MCI_STATUS_TIME_FORMAT,
			status_position = MCI_STATUS_POSITION
		};
	};
	
	enum class mode
	{
		not_ready = MCI_MODE_NOT_READY,
		pause = MCI_MODE_PAUSE,
		play = MCI_MODE_PLAY,
		stop = MCI_MODE_STOP,
		open = MCI_MODE_OPEN,
		record = MCI_MODE_RECORD,
		seek = MCI_MODE_SEEK
	};
	enum class time_format
	{
		bytes = MCI_FORMAT_BYTES,
		frames = MCI_FORMAT_FRAMES,
		hms = MCI_FORMAT_HMS,
		milliseconds = MCI_FORMAT_MILLISECONDS,
		msf = MCI_FORMAT_MSF,
		samples = MCI_FORMAT_SAMPLES,
		tmsf = MCI_FORMAT_TMSF
	};
}
#endif
