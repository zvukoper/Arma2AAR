_handle = armaData; // the name of the pipe handle

//--------------- merged timer
vrema = 0; // initial var
player sidechat "timer started";
player sidechat "Starting buffer RW"; // Buffered Write
//--------------- merged timer

while{true} do { // main loop

	_cached_buffer = global_buffer; // grab current buffer state
	global_buffer = []; // purge global buffer
			{	// here starts foreach lopp for every record in the grabbed buffer
				
				// for debug sometimes I check it with clipboard write to be sure jlib is not freaking out
				//copyToClipboard ( str ( format["%1",_x] ) );
				
				//here what makes external app dump it all to a file
				[_handle, format["%1",_x]] call jayarma2lib_fnc_writePipe;
				
				sleep fps; // just to debug, but theoretically not needed and must be super fast
				//player sidechat format["BW: %1", _x];
			} foreach _cached_buffer;
			_cached_buffer = []; // purge grabbed buffer
	//};
//--------------- merged timer
	//titleText [format["%1 (at %2 FPS)",vrema, fps], "PLAIN DOWN", 0.5]; // current timecode in the middle of the screen
	//hintSilent format["%1", global_buffer]; // debug to see what's captured to global buffer
	if (!aartimer) exitWith {titleText [format["timer stopped at %1, write ended", vrema], "PLAIN DOWN"]; vrema = 0; }; // when global timer condition or stop turns false we exit
	vrema = vrema + 1; // increment timestamp by one fps
	sleep fps; // main fps for syncing
//--------------- merged timer

};
if (true) exitWith {player sidechat "END BUFFER FUNCTION"; }; 