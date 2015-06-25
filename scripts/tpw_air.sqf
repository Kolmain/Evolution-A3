/* 
TPW AIR - Spawn ambient flybys of helicopters and aircraft
Author: tpw 
Date: 20140611
Version: 1.28
Requires: CBA A3
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_air.sqf
2 - Call it with 0 = [10,300,2,[50,250,500],0] execvm "tpw_air.sqf"; where 10 = delay until flybys start (s), 300 = maximum time between flybys (sec). 0 = disable, 2 = maximum aircraft at a given time,[50,250,500] flying heights to randomly select, 0 = all aircraft (1 = civilian aircraft excluded, 2 = military aircraft excluded)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 5) exitwith {hint "TPW AIR incorrect/no config, exiting."};
if (_this select 1 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// VARIABLES
tpw_air_version = "1.28"; // Version string
tpw_air_delay = _this select 0; // delay until flybys start
tpw_air_time = _this select 1; // maximum time between flybys
tpw_air_max = _this select 2; // maximum number of aircraft at a given time
tpw_air_heights = _this select 3; // flying heights to randomly select
tpw_air_civexclude = _this select 4; // 0 = all aircraft, 1 = civilian aircraft excluded, 2 = military aircraft excluded
tpw_air_active = true; // Global enable/disabled
tpw_air_speeds = ["NORMAL","FULL"]; // speeds for spawned aircraft

// LIST OF AIRCRAFT - Thanks to Larrow for the code
tpw_air_aircraft = [];
_cfg = (configFile >> "CfgVehicles");
for "_i" from 0 to ((count _cfg)-1) do 
	{
	if (isClass ((_cfg select _i) ) ) then 
		{
		_cfgName = configName (_cfg select _i);
		if ( ((_cfgName isKindOf "plane") || (_cfgName isKindOf "helicopter")) && (getNumber ((_cfg select _i) >> "scope") == 2) ) then  
			{
			if (tpw_air_civexclude == 0) then
				{
				tpw_air_aircraft set [count tpw_air_aircraft,_cfgname];
				};
			if (tpw_air_civexclude == 1 && getNumber ((_cfg select _i) >> "side") != 3)	then
				{
				tpw_air_aircraft set [count tpw_air_aircraft,_cfgname];
				};
			if (tpw_air_civexclude == 2 && getNumber ((_cfg select _i) >> "side") == 3)	then
				{
				tpw_air_aircraft set [count tpw_air_aircraft,_cfgname];
				};	
			};	
		};
	};	

// AIRCRAFT SPAWN AND FLYBY
tpw_air_fnc_flyby =
	{
	private ["_pos","_px","_py","_pxoffset","_pyoffset","_dir","_dist","_startx","_endx","_starty","_endy","_startpos","_endpos","_heli","_height","_speed","_aircraft","_aircrafttype","_grp","_time","_pilot","_wp0"];
	_pos = position (_this select 0);
	_px = _pos select 0;
	_py = _pos select 1;
	
	// Timer - aircraft will be removed after 5 minutes if it is still hanging around
	_time = time + 300;
	
	// Offset so that aircraft doesn't necessarily fly straight over the top of whatever called this function
	_pxoffset = random 1000;
	_pyoffset = random 1000;
	
	// Pick a random direction and distance to spawn
	_dir = random 360;
	_dist = 4000 + (random 4000);
	
	// Pick random aircraft, height and speed
	_aircrafttype = tpw_air_aircraft select (floor (random (count tpw_air_aircraft)));
	_height = tpw_air_heights select (floor (random (count tpw_air_heights)));
	_speed = tpw_air_speeds select (floor (random (count tpw_air_speeds)));

	// Calculate start and end positions of flyby
	_startx = _px + (_dist * sin _dir) + _pxoffset;
	_endx = _px - (_dist * sin _dir) + _pxoffset;
	_starty = _py + (_dist * cos _dir) + _pyoffset;
	_endy = _py - (_dist * cos _dir) + _pyoffset;
	_startpos = [_startx,_starty,_height];
	_endpos = [_endx,_endy,_height];
	
	// Create aircraft, make it ignore everyone
	_grp = createGroup civilian; 
	_aircraft = [_startpos,0,_aircrafttype,_grp] call BIS_fnc_spawnVehicle;
	_aircraft = _aircraft select 0;
	_aircraft setvariable ["tpw_air",1];
	_pilot = driver _aircraft;
	_pilot setcaptive true;
	_pilot setskill 0;
	_pilot disableAI "TARGET";
	_pilot disableAI "AUTOTARGET";
	_grp setBehaviour "CARELESS"; 
	_grp setCombatMode "BLUE"; 
	_grp setSpeedMode _speed;  	
	_grp allowfleeing 0;
	
	// Flyby
	_aircraft domove _endpos;
	_aircraft flyinheight _height;
	waitUntil {sleep 2;(_aircraft distance _endpos < 1000 || !alive _aircraft || time > _time )};
	deleteVehicle _aircraft;
	deleteGroup _grp; 
	};

// RUN IT
sleep random tpw_air_delay;
while {true} do 
	{
	private ["_air","_counter"];
	sleep (random tpw_air_time);	
		
	// Count spawned aircraft
	_air = (position player) nearEntities ["Air", 5000];
	_counter = 0;
		{
		if (_x getvariable ["tpw_air",0] == 1) then
			{
			_counter = _counter + 1;
			};
		} foreach _air;
		
	// Spawn new aircraft as necessary	
	if (tpw_air_active && _counter < tpw_air_max) then 
		{
		[player] spawn tpw_air_fnc_flyby;
		};
	};