/*
TPW PARK - Parked cars near habitable buildings
Version: 1.12
Author: tpw
Date: 20141111
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client
	
Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as eg tpw_park.sqf
2 - Call it with 0 = [25,300,150,20,10] execvm "tpw_park.sqf"; where 25 = percentage of houses to spawn cars near (0 = no cars, >50 inadvisable), 300 = radius (m) around player to scan for houses to spawn cars, 150 = radius (m) around player beyond which cars are hidden, 20 = player must be closer than this (m) to a car for it to have its simulation enabled, 10 = maximum cars to spawn regardless of settings 

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 5) exitwith {hint "TPW PARK incorrect/no config, exiting."};
if (_this select 0 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// READ IN VARIABLES
tpw_park_version = "1.12"; // version string
tpw_park_perc = _this select 0; // percentage of houses with parked cars.
tpw_park_createdist = _this select 1; // cars created within this distance, completely removed past it.
tpw_park_hidedist = _this select 2; // cars closer than this are shown, further than this are hidden.
tpw_park_simdist = _this select 3; // cars closer than this have simulation enabled.
tpw_park_max = _this select 4; // maximum cars to spawn regardless (not irregardless, that's not a word even if you're American).

tpw_park_active = true; // global enable/disable
tpw_park_cararray = []; // Array of parked cars
tpw_park_oldpos = [0,0,0];

tpw_park_civcarlist = [
"C_Hatchback_01_F",
"C_Hatchback_01_rallye_F",
"C_Hatchback_01_sportF",
"C_Offroad_01_F",
"C_Offroad_01_repair_F",
"C_Offroad_01_sport_F",
"C_SUV_01_F",
"C_SUV_01_sport_F"
];

// ADD CARS FROM RDS CIV PACK IF PRESENT
private ["_cfg"];
_cfg = (configFile >> "CfgVehicles");
for "_i" from 0 to ((count _cfg) -1) do 
	{
	if (isClass ((_cfg select _i) ) ) then 
		{
		_cfgName = configName (_cfg select _i);
		if ( (_cfgName isKindOf "car") && {getNumber ((_cfg select _i) >> "scope") == 2} && {["RDS",str _cfgname] call BIS_fnc_inString}) then 
			{
			tpw_park_civcarlist set [count tpw_park_civcarlist,_cfgname];
			};
		};
	};

// SCAN HOUSES AND ASSIGN PARKED CARS
[] spawn
	{
	while {true} do 
		{
		private ["_houses","_housestring","_uninhab","_house","_car","_nearroads","_road","_connected","_conroad1","_conroad2","_roaddir","_housedir","_roadpos","_posx","_posy","_spawncar","_spawnpos"];
		if (tpw_park_oldpos distance position player > (tpw_park_createdist / 2)) then // only if player has moved more than 1/2 a spawn radius
			{
			tpw_park_oldpos = position player;
			
			// Scan for habitable houses 
			[tpw_park_createdist] call tpw_core_fnc_houses;
			_houses = tpw_core_houses;

			for "_i" from 0 to (count _houses - 1) do
				{
				_house = _houses select _i;
				//_house = _x;
				if (_house getvariable ["tpw_park_assigned",0] == 0) then // if house has not been assigned
					{
					if (random 100 < tpw_park_perc) then // percentage
						{	
						_car = tpw_park_civcarlist  select (floor (random (count tpw_park_civcarlist )));
						_nearRoads = _house nearRoads 20;	
						if(count _nearRoads > 0) then
							{
							_road = _nearRoads select 0;
							if (count (_road nearentities ["car_f",20]) == 0) then // if there is a road near the house
								{
								_connected = roadsConnectedTo _road;
								_conroad1 = _connected select 0;
								_conroad2 = _connected select 1;
								_roaddir = [_road, _conroad1] call BIS_fnc_DirTo;
								_roaddir = _roaddir + (180 * round (random 1));
								_housedir = _roaddir + 90;
								_roadpos = getposasl _road;
								_posx = (_roadpos select 0) + (4 * sin _housedir);
								_posy = (_roadpos select 1) +  (4 * cos _housedir);
								_spawnpos = [_posx,_posy,0];
								_spawncar = _car createVehicle _spawnpos;
								_spawncar allowdamage false;
								_spawncar setfuel random 0.5;
								_spawncar setdir _roaddir;
								_house setvariable ["tpw_park_car",_spawncar];
								_spawncar setvariable ["tpw_park_house",_house];
								_house setvariable ["tpw_park_assigned",1];
								tpw_park_cararray set [count tpw_park_cararray, _spawncar];
								[_spawncar] spawn 
									{
									sleep 1;
									(_this select 0) enablesimulation false; 
									(_this select 0) allowdamage true;
									};
								};
							};
						sleep 0.5;		
						}
					else
						{
						_house setvariable ["tpw_park_assigned",1];
						}				
					};
					 
				if (count tpw_park_cararray > tpw_park_max) exitwith {};		
				} ;
			};	
		sleep 10;		
		};	
	};	
	
// SHOW HIDE PARKED CARS AS APPROPRIATE
while {true} do
	{
	if (tpw_park_active) then
		{
		for "_i" from 0 to (count tpw_park_cararray - 1) do
			{
			_car = tpw_park_cararray select _i;
			if (_car distance player < tpw_park_hidedist) then 
				{
				_car hideobject false; // unhide near car 		
				// Enable simulation only when people nearby
				if (driver _car in units group player || player distance _car < tpw_park_simdist || damage _car > 0.2) then
					{
					_car enablesimulation true; 
					}
				else
					{
					_car enablesimulation false; 
					};
				}
			else
				{
				_car hideobject true; // hide far car
				};

			// delete distant car and unassign its house	
			if (_car distance player > tpw_park_createdist) then 
				{
				(_car getvariable "tpw_park_house") setvariable ["tpw_park_assigned",0];
				deletevehicle _car;
				tpw_park_cararray set [_i,-1];
				};
			};
		tpw_park_cararray = tpw_park_cararray - [-1];		
		sleep 10;		
		};
	};		
