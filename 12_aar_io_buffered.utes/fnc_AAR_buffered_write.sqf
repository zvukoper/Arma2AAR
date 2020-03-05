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


//==============================
// everything below is not used, it's for future type block writing to ext app

		  _state = 0;
		  
		  _driver = 0;
		  _gunner = 0;
		  _commander = 0;
		  _animate = "0";
		  _CPos = [0,0,0]; _CDir = 0;
		  _Vd = [0,0,0];
		  _Vu = [0,0,0];
		  _Vdir = [];

// --------------- UNIT
//_unit_array = [0_the_unit,1_Cpos,2_CDir,3_animate,4_state, 5_vehicle, 6_driver, 7_gunner,8_commander];
if(_data select 0 == "unit") then {
_data_array = _data select 3;
_the_time = _data select 2;
_frame = _data select 1;
_the_unit = _data_array select 0;
	
			  [_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "state", _state]] spawn jayarma2lib_fnc_writePipe;
				_state = _data_array select 4;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "state", _state]] spawn jayarma2lib_fnc_writePipe;
				_vehicle = _data_array select 5;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "vehicle", _vehicle]] spawn jayarma2lib_fnc_writePipe;
				_gunner =_data_array select 7;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "gunner", _gunner]] spawn jayarma2lib_fnc_writePipe;
				_driver = _data_array select 6;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "driver", _driver]] spawn jayarma2lib_fnc_writePipe;
				_commander = _data_array select 8;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "commander", _commander]] spawn jayarma2lib_fnc_writePipe;
				_state = _data_array select 4;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "state", _state]] spawn jayarma2lib_fnc_writePipe;
				_animate = _data_array select 3;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "animation", _animate]] spawn jayarma2lib_fnc_writePipe;
				_CPos = _data_array select 1;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "pos", _CPos]] spawn jayarma2lib_fnc_writePipe;
				_CDir = _data_array select 2;
				[_handle, format["%1;%2;%3;%4;%5;unit",_frame, time, _the_unit, "dir", _CDir]] spawn jayarma2lib_fnc_writePipe;
		};
		
if(_data select 0 == "vehicle") then {
_data_array = _data select 3;
_the_time = _data select 2;
_frame = _data select 1;
_the_unit = _data_array select 0;

// --------------- VEHICLE		  
//_unit_array = [0_the_unit,1_Cpos,2_Vd, 3_Vu,4_engine,5 1,6_state];
			_state = _data_array select 6;
			[_handle, format["%1;%2;%3;%4;%5;vehicle",_frame, time, _the_unit, "state", _state]] spawn jayarma2lib_fnc_writePipe;
			_CPos = _data_array select 1;
			[_handle, format["%1;%2;%3;%4;%5;vehicle",_frame, time, _the_unit, "pos", _CPos]] spawn jayarma2lib_fnc_writePipe;
			_Vd = _data_array select 2;
			[_handle, format["%1;%2;%3;%4;%5;vehicle",_frame, time, _the_unit, "vd", _Vd]] spawn jayarma2lib_fnc_writePipe;
			_Vu = _data_array select 3;
			[_handle, format["%1;%2;%3;%4;%5;vehicle",_frame, time, _the_unit, "Vu", _Vu]] spawn jayarma2lib_fnc_writePipe;

	};
//hint format["(%1): %2", _handle, _data];

//[_handle, format["%1", _data]] spawn jayarma2lib_fnc_writePipe;