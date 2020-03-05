//--------------- merged timer
//vrema = 0; // initial var
//player sidechat "timer started";
//player sidechat "Starting buffer RW";
//_nilly = [] execVM "fnc_AAR_buffered_write.sqf"; // activate buffered write to ext app

//While {true} do { // main loop
	//titleText [format["%1 (at %2 FPS)",vrema, fps], "PLAIN DOWN", 0.5]; // current timecode in the middle of the screen
	//hintSilent format["%1", global_buffer]; // debug to see what's captured to global buffer
//		if (!aartimer) exitWith {titleText [format["timer stopped at %1", vrema], "PLAIN DOWN"]; vrema = 0; }; // when global timer condition or stop turns false we exit
//	vrema = vrema + 1; // increment timestamp by one fps
//	sleep fps; // main fps for syncing
//};
//--------------- merged timer