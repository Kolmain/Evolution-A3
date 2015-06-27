/* 
TPW BOATS - Ambient civilian boats
Author: tpw 
Additional code suggestions: LordPrimate
Date: 20141111
Version: 1.29
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_boats.sqf
2 - Call it with 0 = [5,1000,15,2] execvm "tpw_boats.sqf"; where 5 = start delay, 1000 = radius, 15 = number of waypoints, 2 = max boats

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 4) exitwith {hint "TPW CARS incorrect/no config, exiting."};
if (_this select 3 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// READ IN VARIABLES
tpw_boat_version = "1.29"; // Version string
tpw_boat_sleep = _this select 0;
tpw_boat_radius = _this select 1;
tpw_boat_waypoints = _this select 2;
tpw_boat_maxnum = _this select 3;

// DEFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_boat_sleep = 5;
	tpw_boat_radius = 1000;
	tpw_boat_waypoints = 15;
	tpw_boat_num =2;
	};

tpw_boat_active = true; // Global enable/disable
tpw_boat_debug = false; // Debugging
tpw_boat_boatarray = []; // Player's array of boats
tpw_boat_mindist = 200; // Don't remove boats closer than this
tpw_boat_slowdist = 100; // Boats slow down when this close 
tpw_boat_spawnradius = tpw_boat_radius / 2; // Boats will spawn this far from player
tpw_boat_num = tpw_boat_maxnum;
tpw_boat_time = time + random 120;

_boatlist = [
"C_Boat_Civil_01_F",
"C_Boat_Civil_01_police_F",
"C_Boat_Civil_01_rescue_F",
"C_rubberboat"];

// DELAY
sleep tpw_boat_sleep;

// CREATE AI CENTRE
_centerC = createCenter civilian;

//FIND WATER NEAR PLAYER
tpw_boat_fnc_findwater = 
	{
	private ["_pos","_posx","_posy","_dir"];
	_pos = position player;
	_dir = random 360;;
	for "_i" from 1 to 10 do
		{
		_posx = (_pos select 0) + (tpw_boat_spawnradius * sin _dir);
		_posy = (_pos select 1) +  (tpw_boat_spawnradius * cos _dir);
		tpw_boat_waterpos = [_posx,_posy,0]; 
		if (surfaceIsWater tpw_boat_waterpos) exitwith {[] call tpw_boat_fnc_spawnboat};
		_dir = _dir + 30; 
		if (_dir > 360) then 
			{
			_dir = _dir - 360
			};
		};
	};
	
// SPAWN BOAT/DRIVER IN THE WATER
tpw_boat_fnc_spawnboat =
	{
	private ["_boat","_spawnboat"];
	
	//Random boat
	_sqname = creategroup civilian;
	_boat = _boatlist select (floor (random (count _boatlist)));
	_spawnboat = _boat createVehicle tpw_boat_waterpos;
	
	// Random civ
	_civ = tpw_core_civs select (floor (random (count tpw_core_civs)));
	_civ createunit [tpw_boat_waterpos,_sqname,"this moveindriver _spawnboat;this setskill 0;this disableAI 'TARGET';this disableAI 'AUTOTARGET';this setbehaviour 'CARELESS'; this setSpeaker format ['Male0%1GRE',ceil (random 4)]"]; 
	
	//Add killed/hit eventhandlers to driver
	(leader _sqname) addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
	(leader _sqname) addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];
	
	//Passenger - thanks LordPrimate
	if (random 10 < 5) then
		{
		_civtype = tpw_core_civs select (floor (random (count tpw_core_civs)));
		_passenger = _sqname createUnit [_civtype,tpw_boat_waterpos, [], 0, "FORM"];
		_passenger setSpeaker format ["Male0%1GRE",ceil (random 4)];
		_passenger setSkill 0;
		_passenger disableAI "TARGET";
		_passenger disableAI "AUTOTARGET";
		_passenger moveInCargo _spawnboat;
		_passenger addEventHandler ["Hit",{_this call tpw_civ_fnc_casualty}];
		_passenger addEventHandler ["Killed",{_this call tpw_civ_fnc_casualty}];
		};
	
	// Assign waypoints
	[_sqname] call tpw_boat_fnc_waypoints;
	
	//Mark it as owned by this player
	_spawnboat setvariable ["tpw_boat_owner",[player],true];

	//Mark boat's driver
	_spawnboat setvariable ["tpw_boat_driver",(leader _sqname),true];
	
	// Add it to player's boat array
	tpw_boat_boatarray set [count tpw_boat_boatarray,_spawnboat];
	};	
	
// SEE IF ANY BOATS OWNED BY OTHER PLAYERS ARE WITHIN RANGE, USE THESE INSTEAD OF SPAWNING A NEW BOAT (MP)
tpw_boat_fnc_nearboat =
	{
	private ["_owner","_nearboats","_shareflag","_i","_boat"];
	_spawnflag = 1;
	if (isMultiplayer) then 
		{
		// Array of near boats
		_nearboats = (position player) nearEntities [["Ship"], tpw_boat_radius];

			// Live boats within range
		for "_i" from 0 to (count _nearboats - 1) do	
			{
			_boat = _nearboats select _i;	
			if (_boat distance vehicle player < tpw_boat_radius && alive _boat) then   
				{
				_owner = _boat getvariable ["tpw_boat_owner",[]];

				//Units with owners, but not this player
				if ((count _owner > 0) && !(player in _owner)) exitwith
					{
					_spawnflag = 0;
					_owner set [count _owner,player]; // add player as another owner of this car
					_boat setvariable ["tpw_boat_owner",_owner,true]; // update ownership
					tpw_boat_boatarray set [count tpw_boat_boatarray,_boat]; // add this boat to the array of boats for this player
					};
				} 
			};
		};
	//Otherwise, spawn a new boat
	if (_spawnflag == 1) then 
		{
		[] call tpw_boat_fnc_findwater;    
		};
	};  	

// WATER WAYPOINTS
tpw_boat_fnc_waypoints =
	{
	private ["_grp","_posx","_posy","_wp","_wppos"];
	_grp = _this select 0;
	for "_i" from 1 to tpw_boat_waypoints do
		{
		waituntil 
			{
			sleep 0.2;
			_dir = random 360;
			_dist = 100 + (random tpw_boat_radius);
			_posx = (tpw_boat_waterpos select 0) + (_dist * sin _dir);
			_posy = (tpw_boat_waterpos select 1) + (_dist * cos _dir);
			_wppos = [_posx,_posy,0]; 
			(surfaceIsWater _wppos);
			};
		_wp = _grp addWaypoint [_wppos, 50];
		
		if (_i == tpw_boat_waypoints) then 
			{
			_wp setwaypointtype "CYCLE";
			};
		};
	};

// MAIN LOOP - ADD AND REMOVE BOATS AS NECESSARY, CHECK IF OTHER PLAYERS HAVE DIED (MP)
while {true} do 
	{
	if (tpw_boat_active) then
		{
		private ["_driver","_boatarray","_deadplayer","_group","_boat","_i","_index"];
		tpw_boat_removearray = [];

		// Debugging	
		if (tpw_boat_debug) then {hintsilent format ["boats: %1",count tpw_boat_boatarray]};
		
		// Add boats if daytime
		if (count tpw_boat_boatarray == 0) then 
			{
			tpw_boat_num = ceil (random tpw_boat_maxnum);
			};
		
		if (count tpw_boat_boatarray < tpw_boat_num  && {daytime > 5 && daytime < 20} && {time > tpw_boat_time}) then 
			{
			tpw_boat_time = time + random 120;
			0 = [] call tpw_boat_fnc_nearboat;
			};
			
		for "_i" from 0 to (count tpw_boat_boatarray - 1) do	
			{
			_boat = tpw_boat_boatarray select _i;
			
			// Slow down near player
			if (_boat distance player < tpw_boat_slowdist) then 
				{
				_boat setSpeedMode "LIMITED";
				} else
				{
				_boat setSpeedMode "NORMAL";
				};
			//Conditions for removing boat
			if (
			_boat distance vehicle player > tpw_boat_radius || //boat out of range
			(speed _boat < 1 && (_boat getvariable ["tpw_boat_lastspeed",500]) < 1) || // boat hasn't moved
			(damage _boat > 0.2 && damage _boat < 1) // boat damaged, but not destroyed
			) then
				{
				// If player can't see the boat
				if (lineintersects [eyepos player,getposasl _boat,player,_boat] || terrainintersectasl [eyepos player,getposasl _boat]) then
					{
					// Don't remove a close boat even if it's supposedly not visible
					if (_boat distance vehicle player > tpw_boat_mindist) then 
						{
						//  Remove player as owner, remove from player's boat array
						_boat setvariable ["tpw_boat_owner", (_boat getvariable "tpw_boat_owner") - [player],true];            
						tpw_boat_removearray set [count tpw_boat_removearray,_boat];    
						};		
					};
				};

			// Delete the boat, driver and waypoints if it's not owned by anyone    
			if (count (_boat getvariable ["tpw_boat_owner",[]]) == 0) then    
				{
				_driver = _boat getvariable "tpw_boat_driver";
				_group = group _driver;	
				for "_i" from count (waypoints _group) to 1 step -1 do
					{
					deleteWaypoint ((waypoints _group) select _i);
					};
					{
					moveout _x;
					deletevehicle _x;
					} foreach units _group;		
				deletevehicle _boat;
				deletegroup _group;
				};
			_boat setvariable ["tpw_boat_lastspeed",(speed _boat)];	
			};

		// Update player's boat array    
		tpw_boat_boatarray = tpw_boat_boatarray - tpw_boat_removearray;
		player setvariable ["tpw_boatarray",tpw_boat_boatarray,true];

		// If MP, check if any other players have been killed and disown their boats
		if (isMultiplayer) then 
			{
				{
				if ((isplayer _x) && !(alive _x)) then
					{
					_deadplayer = _x;
					_boatarray = _x getvariable ["tpw_boatarray"];
						{
						_x setvariable ["tpw_boat_owner",(_x getvariable "tpw_boat_owner") - [_deadplayer],true];
						} foreach _boatarray;
					};
				} foreach allunits;    
			};
		};	
	sleep random 10;    
	};  
	
