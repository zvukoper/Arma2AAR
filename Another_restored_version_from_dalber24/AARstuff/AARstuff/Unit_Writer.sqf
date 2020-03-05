copyToClipBoard "Arma_Command = 0;///Module initiated with in ArmA 2///";
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
	copyToClipBoard format  ["Arma_message = {%1 = createMarker [""%2"",[0,0,0]]; %3 setMarkerType ""dot""; %4 setMarkerText ""%5"";}; call Arma_message;",_unit,_unit,_unit,_unit,_unit];
	sleep 0.15;
	hintsilent format ["AAR Script Init %1",_unit];
};

hint"Script Intialized";
_oneMinuteTimer = time;
JO_Seconds = 0;
JO_Minutes = 0;
JO_Hours = 0;

private ["_unit","_soldier", "_veh"];
while {!Arma_AAR_Stop} do
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
						
						copyToClipBoard format  [
						"Arma_message = { ""%1"" setMarkerPos %2; ""%3"" setMarkerText ""%4 (%5)"";""%6"" setMarkerType ""mil_start"";sleep JO_playSpeed;}; call Arma_message;",
						_unit,
						position _soldier,
						_unit,
						getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName"),
						count crew _veh,_unit
						];
						sleep 0.14;
						//hintsilent format ["_unit veh %1",_unit];
					}
					else
					{
						copyToClipBoard format  ["Arma_message = {""%1"" setMarkerType ""EMPTY"";}; call Arma_message;",_unit];
						//hintsilent format ["_unit veh %1",_unit];
						sleep 0.14;
					};
				}
				else 
				{

					//hintsilent format ["_unit foot %1",_unit];
					copyToClipBoard format  [
					"Arma_message = { ""%1"" setMarkerPos %2; ""%3"" setMarkerText ""%4"";""%5"" setMarkerType ""DOT"";sleep JO_playSpeed;}; call Arma_message;",_unit,position _soldier,_unit,name _soldier,_unit];
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
		copyToClipBoard format  ["Arma_message = { ""AAR_time_Mark"" setMarkerText ""Minutes: %1"";}; call Arma_message;",JO_Minutes];
		sleep 0.14;
		copyToClipBoard format  ["Arma_message = { ""AAR_Score_Mark"" setMarkerText ""Score RS(%1)Score SI(%2)"";}; call Arma_message;",blueDifference,opforDifference];
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
	copyToClipBoard format  ["Arma_message = {deleteMarker %1;}; call Arma_message;",_unit];
	sleep 0.14;
	hintsilent format ["AAR Script Ending %1",_unit];
	
};
hint "Script Done";