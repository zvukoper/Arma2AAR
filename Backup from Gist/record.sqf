///AAR_fnc_writePipe = [proc, params] call "fnc_AAR_buffered_write.sqf";
aartimer = true; // global condition for timer working
player sidechat "Let's record!"; 
player sidechat "Trying to open pipes";
//_counted = count allUnits;

//checking communications with exernal app
if(isNil("delphiData")) then { 
	player sidechat "NO CLIENT PIPE!!";
};

if(isNil("armaData")) then {
	player sidechat "NO AAR PIPE!!";
};

player sidechat "Sending RECORDING status";
[armaCom, "RECORDING"] call jayarma2lib_fnc_writePipe; // tell ext app that we are commencing record
player sidechat "Starting while"; // debug

//witing for ping from external app
while{true} do
	{
		player sidechat "Waiting for confirmation from client";
		if (recordMode) exitWith {player sidechat "Client confirmed record. Proceeding."; }; //script received confirmation from external app
	};    

//assign a list of units
recUnits  = allUnits; // collect units
recVeh = vehicles; // collect vehicles
_everyone = allUnits + vehicles; // for common EH

//assign event handlers for all vehicles
{ //engine onn off capturing 
	_x addEventHandler ["Engine", {[armaData, format['["engine", %1, %2]', _this select 0,_this select 1]] spawn AAR_fnc_writePipe; player sidechat "Engine state changed";}];
} forEach recVeh;

{ //register hits
	_x addEventHandler ["Hit", {[armaData, format['["hit", %1, %2]', _this select 0,_this select 1]] spawn AAR_fnc_writePipe; player sidechat "Hit recorded";}];
//reproduce damage
	_x addEventHandler ["HandleDamage", {(_this select 0) setDamage (_this select 2); [armaData, format['["damage", %1, "%2", %3, %4, "%5"]', _this select 0,_this select 1,_this select 2,_this select 3,_this select 4]] spawn AAR_fnc_writePipe; player sidechat "Damage recorded";}];
// register fire
	_x addEventHandler ["Fired", {[armaData, format['["fired", %1, "%2", "%3", "%4", "%5"]', _this select 0,_this select 1,_this select 2,_this select 3,_this select 4]] spawn AAR_fnc_writePipe; player sidechat "Shot recorded";}];
} forEach _everyone;

// CONFIRMED!!! CONTINUE!!!
player sidechat "ROGER received, proceeding";
//LAUNCH TIMER FOR SYNC
//thisko = [] execVM "timer.sqf";   

//--------------- merged timer
thisko = [] execVM "fnc_AAR_buffered_write.sqf";   //merged timer and this script
//--------------- merged timer

_tmr = ( random 1); // dunno what's this, a buddy made timer for me
sleep _tmr;

//////---------MAIN LOOP ================ THAT"S WHERE MAJOR LAGGING STARTS
while{true} do
{
	//startframe
	_frame = vrema; // main timestamp sync

	///=============== GATHER DATA FOR UNITS
	_write_array = [];
	_unit_array = [];
	{ 	//state is dead or not - 1 for dead, 0 for alive
		_state = 0;
		_vehicle = _x;
		_driver = 0;
		_gunner = 0;
		_commander = 0;
		_animate = "0";
		_CPos = [0,0,0]; _CDir = 0;
		
		if(!alive _x) then {
			_state = 1; // status is checked every frame on playback and kills unit when it reads 1
		} else {
		//if in vehicle
		if(vehicle _x != _x) then { 
			_state = damage _x;
			//vehicle var
			_vehicle = vehicle _x; 
			//what position?
			if(gunner _vehicle == _x) then {_gunner = 0;};
			if(driver _vehicle == _x) then {_driver = 1;};
			if(commander _vehicle == _x) then {_commander = 0;};
		} else {
			// not in vehicle
			_state = damage _x;
			_animate = animationState _x; //capture animation
			_CPos = getPosATL _x; 
			_CDir = getDir _x;
		};
		};
		_unit_array = [_x,_Cpos,_CDir,_animate,_state, _vehicle, _driver, _gunner,_commander]; // gather data array
		_write_array = ["unit", _frame, time, _unit_array]; // extend the data array with data type, time sync and frame info
		global_buffer set [count global_buffer, _write_array]; // push the data to global buffer
	} forEach recUnits;
	
	///!!!!!!!!!!!!!!!UNITS END
	
	_write_array = [];
	_unit_array = [];
	///!!!!!!!!!!!!!!!VEHICLES
	
	//_iko = 0;
	{	//Now process vehicles
		//state is dead or not - 1 for dead, 0 for alive
		_state = 0;
		_CPos = [0,0,0];
		_CDir = 0;
		_Vd = [0,0,0];
		_Vu = [0,0,0];
		_Vdir = [];
		if(!alive _x) then {
			_state = 1;
			//_unit_array = _unit_array + [[_x,_Cpos,_CDir,_animate,_state,_vehicle, _driver, _gunner, _commander]];
		} else {
			_state = 0;
			_engine = 0;
			_CPos = getPosATL _x; //_CDir = getDir _x;
			_Vd = vectorDir _x;
			_Vu = vectorUp _x;
			
		};
		_unit_array = [_x,_Cpos,_Vd, _Vu,_engine,1,_state];
		_write_array = ["vehicle", _frame, time, _unit_array];
		global_buffer set [count global_buffer, _write_array];
		
		
	} forEach recVeh;
	//!!!!!!!!!!!!!!!VEHICLES
	//endframe

	if (!recordMode) exitWith {player sidechat "Stop received. Reinitiating."; }; 
	//STOP RECEIVED!!! BREAK! 
	sleep fps; // main pause for the loop
};
