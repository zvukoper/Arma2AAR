/// update function
MHL_global_buffer set [count MHL_global_buffer, "MHL_AAR_update_mrk = {"];

MHL_global_buffer set [count MHL_global_buffer, "_frame = this select 6;"];
MHL_global_buffer set [count MHL_global_buffer, "_vrema = this select 7;"];
MHL_global_buffer set [count MHL_global_buffer, "_mtype = this select 8;"];

MHL_global_buffer set [count MHL_global_buffer, "_unit = this select 0;"];
MHL_global_buffer set [count MHL_global_buffer, "_upos = this select 1;"];
MHL_global_buffer set [count MHL_global_buffer, "_uname = this select 2;"];
MHL_global_buffer set [count MHL_global_buffer, "_ucrew = this select 3;"];
MHL_global_buffer set [count MHL_global_buffer, "_udir = this select 4;"];
MHL_global_buffer set [count MHL_global_buffer, "_udamage = this select 5;"];

MHL_global_buffer set [count MHL_global_buffer, "_unit setMarkerPos %2; _unit setMarkerDir _udir; _unit setMarkerText format[""%1 (%2) d:%3"",_uname, _ucrew, _udamage];_unit setMarkerType _mtype; sleep MHL_fps};"];

MHL_global_buffer set [count MHL_global_buffer, "};"];
/// update function

/// create function
MHL_global_buffer set [count MHL_global_buffer, "MHL_AAR_create_mrk = {"];

MHL_global_buffer set [count MHL_global_buffer, "_unit = this select 0;"];

MHL_global_buffer set [count MHL_global_buffer, "_unit = createMarker [""%2"",[0,0,0]]; _unit setMarkerType ""dot""; _unit setMarkerText ""_unit"";"];

MHL_global_buffer set [count MHL_global_buffer, "};"];
/// create function

/// delete function
MHL_global_buffer set [count MHL_global_buffer, "MHL_AAR_delete_mrk = {"];

MHL_global_buffer set [count MHL_global_buffer, "_unit = this select 0;"];

MHL_global_buffer set [count MHL_global_buffer, "_unit = deleteMarker _unit;"];

MHL_global_buffer set [count MHL_global_buffer, "};"];
/// delete function

private ["_unitArray"];

Arma_AAR_Stop = false;
_unitArray = [];

///builds sides unit array with unit names a strings "E1" to "E60" . 
///These are the names of the units in the mission editor
_side = "e";
for "_i" from 1 to 60 do
{	
	///formats the name into  string
	_unit = format ["%1%2", _side, _i];		
	///sets the unit name s string in to the sides array
	_unitArray set [_i - 1, _unit];
MHL_global_buffer set [count MHL_global_buffer, format["[%1] call MHL_AAR_create_mrk", _unit];
	sleep 0.15;
	hintsilent format ["AAR Script Init %1",_unit];
};

hint"Script Intialized";
_oneMinuteTimer = time;
JO_Seconds = 0;
JO_Minutes = 0;
JO_Hours = 0;
// on kill set a dead marker somewhere and write who killed whom with what
private ["_unit","_soldier", "_veh"];
while {!MHL_aartimer} do
{
	{	
		///current element of the sides array
		_unit = _x;
		//convert string to object
		_soldier = call compile _unit;		
		if(!isNil "_soldier")then 
		{
			if (Alive _soldier) then
			{
				_veh = vehicle _soldier;			
				///checks to see if unit is in a vehicle
				if (_veh != _soldier) then 
				{
					///checks if unit is driver, if not marker is hidden
					if (_soldier == ((crew _veh) select 0)) then 
					{
						
MHL_global_buffer set [count MHL_MHL_global_buffer, format["[%1] call MHL_AAR_update_mrk", _unit,position _soldier,getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName"),	count crew _veh,getDir _soldier,damage _soldier,time,MHL_vrema, "mil_start"	];
						sleep 0.14;
						//hintsilent format ["_unit veh %1",_unit];
					}
					else
					{
MHL_global_buffer set [count MHL_MHL_global_buffer, format["[%1] call MHL_AAR_update_mrk", _unit,position _soldier,getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName"),	count crew _veh,getDir _soldier,damage _soldier,time,MHL_vrema, "EMPTY"	];
						//hintsilent format ["_unit veh %1",_unit];
						sleep 0.14;
					};
				}
				else 
				{

					//hintsilent format ["_unit foot %1",_unit];
MHL_global_buffer set [count MHL_MHL_global_buffer, format["[%1] call MHL_AAR_update_mrk", _unit,position _soldier,getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName"),	count crew _veh,getDir _soldier,damage _soldier,time,MHL_vrema, "mil_marker"	];
					sleep 0.14;
				};
			};
		};
	} forEach _unitArray;
			///time conversions
	
	///write scores every 1 minute
	if ( (time - _oneMinuteTimer ) > 60) then 
	{
		JO_seconds = time;
		if(JO_Seconds >= 60)then{JO_Minutes = round (JO_Seconds / 60);};
		//code format to set mission marker text
		//copyToClipBoard format  ["Arma_message = { ""AAR_time_Mark"" setMarkerText ""Minutes: %1"";}; call Arma_message;",JO_Minutes];
		sleep 0.14;
		//copyToClipBoard format  ["Arma_message = { ""AAR_Score_Mark"" setMarkerText ""Score RS(%1)Score SI(%2)"";}; call Arma_message;",blueDifference,opforDifference];
		_oneMinuteTimer = time;
	};
	sleep 0.15; 
	                                        
};	
////clean up code for markers, so when the output file runs it will be formated to 
for "_i" from 1 to 60 do
{	
	///formats the name into  string
	_unit = format ["%1%2", _side, _i];		
	///sets the unit name s string in to the sides array
	_unitArray set [_i - 1, _unit];
	MHL_global_buffer set [count MHL_global_buffer, format["[%1] call MHL_AAR_delete_mrk", _unit];
	sleep 0.14;
	hintsilent format ["AAR Script Ending %1",_unit];
	
};
hint "Script Done";