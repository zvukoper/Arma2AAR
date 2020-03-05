//disableUserInput true;

{_x disableAI "AUTOTARGET";
_x disableAI "MOVE";
_x disableAI "TARGET";
_x disableAI "AUTOTARGET";
_x disableAI "ANIM";
_x allowDamage false;
_x setDamage 0;
} forEach allUnits;


aartimer = true;
player sidechat "Let's try PLAYBACKING!";
player sidechat "Trying to open pipes";
if(isNil("delphiData")) then {
	player sidechat "NO CLIENT PIPE!!";

			};
			
if(isNil("armaData")) then {
	player sidechat "NO AAR PIPE!!";

			};	

[armaCom, "PLAYBACK"] call jayarma2lib_fnc_writePipe;
while{true} do
   {if (playbackMode) exitWith {player sidechat "Client confirmed playback. Proceeding."; };};    
_timer = [] execVM "timer.sqf";
player sidechat "playback while cycle starting";	

while {true} do {
_ddata = [delphiData] call jayarma2lib_fnc_readPipe;

					/* ERROR CHECK AND RECONNECT */
						if (_ddata == "_JERR_PIPE_INVALID" || _ddata == "_JERR_FALSE") then {
							player sidechat "reconnecting in 3 sec";
							sleep 3;
							delphiData = ["\\.\pipe\delphiPipe"] call jayarma2lib_fnc_openPipe;
							_ddata = [delphiData] call jayarma2lib_fnc_readpipe;
							
						};
					/* ERROR CHECK AND RECONNECT */

if(!isNil("_ddata")) then {
//compile th read data
_xdata = call compile format["%1",_ddata];

//catch fired event
//fire [muzzle, mode, magazine]
//[unit, weapon, muzzle, mode, ammo]
//["fired", recorder, "AK_107_pso", "AK_107_pso", "FullAuto", "B_545x39_Ball"]
_type = format["%1",(_xdata select 0)];
if(_type == "fired") then {
//_muzzle = format["%1",(_xdata select 3)];
shoot action ["useWeapon",(_xdata select 1),(_xdata select 1),0]; 

//recorder action ["useWeapon",recorder,recorder,0]; 
(_xdata select 1) fire _muzzle;
//(_xdata select 1) fire [_xdata select 3, _xdata select 4, _xdata select 5];
player sidechat format["%1 fires %2", _xdata select 1, _xdata select 2];
};

//catch hit event
//hit [unit, causedBy, damage]
if(_type == "hit") then {
//(_xdata select 1) fire [_xdata select 3, _xdata select 4, _xdata select 5];
(_xdata select 2) doTarget (_xdata select 1);
player sidechat format["%1 hit by %2", _xdata select 1, _xdata select 2];
};

if(_type == "damage") then {
//[type,unit, selectionName, damage, source, projectile]
//setHit ["motor", 1]
_dpart = format["%1", _x select 2];
if(_dpart != "") then {
(_xdata select 1) setHit [_dpart, (_xdata select 3)];
} else {(_xdata select 1) setDamage (_xdata select 3);};
player sidechat format["%1 damaged by %4 inflicting %3 damage (%2)", _xdata select 1, _dpart, _xdata select 3, _xdata select 4];
};

if(_type == "reload") then {
reload (_xdata select 1);
player sidechat format["%1 reloading", _xdata select 1];
};

if(_type == "engine") then {
(_xdata select 1) engineOn (_xdata select 2);
player sidechat format["%1 engine is %2", _xdata select 1, _xdata select 2 ];
};
				////!!!!!!!!!UNITS
if(_type == "data") then {
				{//hintSilent format["PLAY: %1. Current time: %2", _xdata select 0, vrema];
waitUntil {vrema >= _xdata select 2};
//player sidechat format["%1", (_xdata select 1) select 0];

if((_x select 4) != 1) then {


if((_x select 5) != (_x select 0)) then { // in vehicle!
	  // [0_x,1_Cpos,2_CDir,3_animate,4_state, 5_vehicle, 6_driver, 7_gunner,8_commander]
	   if((_x select 6) == 1) then {(_x select 0) moveInDriver (_x select 5);};
	   if((_x select 7) == 1) then {(_x select 0) moveInGunner (_x select 5);};
	   if((_x select 8) == 1) then {(_x select 0) moveInCommander (_x select 5);};
	   if(((_x select 6) != 0) && ((_x select 7) != 0) && ((_x select 8) != 0)) then {(_x select 0) moveInCargo (_x select 5);};
				  
	  } else { //not in vehicle
_anim = format["%1", _x select 3];
			_curanim = animationState (_x select 0);
			if (_anim != _curanim ) then {(_x select 0) playMoveNow _anim;};
			(_x select 0) setPosATL [(_x select 1) select 0,(_x select 1) select 1,(_x select 1) select 2]; 
			(_x select 0) setDir (_x select 2);
			_ammos = (_x select 0) ammo (primaryWeapon (_x select 0));
			(_x select 0) setVehicleAmmo 1;
	  if (_ammos <= 1) then { reload (_x select 0);};
	   };
	  
							};
//							else {(_x select 0) setDamage (_x select 4);};
				} forEach (_xdata select 1);
				
								////!!!!!!!!!VEHICLES

				{//hintSilent format["PLAY: %1. Current time: %2", _xdata select 0, vrema];
waitUntil {vrema >= _xdata select 2};
//player sidechat format["%1", (_xdata select 1) select 0];
//_unit_array = _unit_array + [[_x,_Cpos,_CDir,_animate,_state, _engine]];
if((_x select 4) != 1) then {
			(_x select 0) setPosATL [(_x select 1) select 0,(_x select 1) select 1,(_x select 1) select 2];
//object setVectorDir [x, z, y] ;			
_Vdir = (_x select 2);
			(_x select 0) setVectorDirAndUp [_Vdir select 0, _Vdir select 1],;

	 
	  
							} ;
							//else {(_x select 0) setDamage (_x select 4);};
				} forEach (_xdata select 3);
				////!!!!!!!!!VEHICLES
				
				};
				////!!!!!!!!!UNITS

}; //main empty check 

   if (!playbackMode) exitWith {player sidechat "Reading ended"; };
   if (_ddata == "EOF") exitWith {player sidechat "Reading ended"; vrema = 0; playbackMode = false; aartimer = false;};
   }; //main while
//disableUserInput false;