private ["_currentTarget","_currentTargetMarker","_aoSize","_x1","_y1","_nextTargetMarker","_pos","_array","_obj","_towerClass","_spawnPos","_radioTowerComp","_grp","_officer","_max_distance","_OF","_loop","_msg","_null","_center","_dir","_comp","_mortarGunner","_newComp","_mortar","_delay","_tank","_ret","_plane","_sound","_tskName","_count","_unit","_players","_score"];

//////////////////////////////////////
//Init Variables
//////////////////////////////////////
currentTargetRT = nil;
currentTargetOF = nil;
lastAOunits = currentAOunits;
publicVariable "lastAOunits";
currentAOunits = [];
publicVariable "currentAOunits";
RTonline = true;
officerAlive = true;
currentTargetName = toUpper text currentTarget;
publicVariable "currentTargetName";
_currentTarget = currentTarget;
currentTargetType = type currentTarget;
publicVariable "currentTargetType";
currentTargetMarkerName = format ["%1", targetCounter];
publicVariable "currentTargetMarkerName";
_currentTargetMarker = createMarker [currentTargetMarkerName, position _currentTarget];
currentTargetMarkerName setMarkerShape "ELLIPSE";
currentTargetMarkerName setMarkerBrush "Border";
currentTargetMarkerName setMarkerDir direction currentTarget;
_aoSize = [(((size currentTarget) select 0) + 200), (((size currentTarget) select 1) + 200)];
currentTargetMarkerName setMarkerSize _aoSize;
currentTargetMarkerName setMarkerColor "ColorEAST";
currentTargetMarkerName setMarkerPos (position currentTarget);
_x1 = ((size currentTarget) select 0) / 1000;
_y1 = ((size currentTarget) select 1) / 1000;
currentTargetSqkm = (_x1 * _y1);
publicVariable "currentTargetSqkm";
"opforair" setMarkerPos (getMarkerPos currentTargetMarkerName);

_nextTargetMarker = createMarker [nextTargetMarkerName, position _currentTarget];
nextTargetMarkerName setMarkerShape "ELLIPSE";
nextTargetMarkerName setMarkerBrush "FDiagonal";
nextTargetMarkerName setMarkerDir direction (targetLocations select (targetCounter + 1));
_aoSize = [(((size (targetLocations select (targetCounter + 1))) select 0) + 200), (((size (targetLocations select (targetCounter + 1))) select 1) + 200)];
nextTargetMarkerName setMarkerSize _aoSize;
nextTargetMarkerName setMarkerColor "ColorEAST";
nextTargetMarkerName setMarkerPos (position (targetLocations select (targetCounter + 1)));


_pos = (position (targetLocations select (targetCounter + 1)));
_array = nearestObjects [_pos, ["house"], 500];
_obj = _array select 0;
"opforArrow" setMarkerPos (getPos _obj);
"opforArrow" setMarkerDir ([getPos _obj, getMarkerPos currentTargetMarkerName] call bis_fnc_DirTo);

current_landing_zones = [];
{
    if (_x distance currentTarget <= 1000) then {
        current_landing_zones pushBack _x;
    }
} forEach landing_zones;
publicVariable "current_landing_zones";
//////////////////////////////////////
//Set AO on Map
//////////////////////////////////////
current_objective setPos (position currentTarget);
current_objective setVariable ["objectArea",[1000, 1000, 0, false, 0]];
[current_objective, [], true] call BIS_fnc_moduleCoverMap;

//////////////////////////////////////
//Send UAV to AO
//////////////////////////////////////
for "_i" from count waypoints group uav_west - 1 to 0 step -1 do
{
	deleteWaypoint [group uav_west, _i];
};
_wp = group uav_west addWaypoint [position current_objective, 0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType "CIRCLE";
_wp setWaypointLoiterRadius 800;
_wp setWaypointCombatMode "BLUE";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointSpeed "FULL";
uav_west flyInHeight 500;

//////////////////////////////////////
//Target AO Radio Tower
//////////////////////////////////////
_towerClass = "Land_Communication_F";
_spawnPos = [position currentTarget , 10, 200, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
_radioTowerComp = [_spawnPos, (random(floor(360))), call (compile (preprocessFileLineNumbers "Comps\radiotower.sqf"))] call BIS_fnc_ObjectsMapper;
{
	if (toLower(typeOf _x) == toLower(_towerClass)) then {
		currentTargetRT = _x;
		PublicVariable "currentTargetRT";
	};
} forEach _radioTowerComp;
publicVariable "currentTargetRT";
handle = [currentTargetRT] spawn EVO_fnc_demoOnly;
currentTargetRT addEventHandler ["Killed", {_this call EVO_fnc_RToffline}];
RTonline = true;
publicVariable "RTonline";
//Defend Radio Tower 
for "_i" from 1 to (["Infantry", "Radio"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_grp = [_this select 0, "radio", true] call EVO_fnc_sendToAO;
		waitUntil {({alive _x} count units _grp) < 3};
		while {RTonline && (_this select 0 == currentTarget)} do {
			_grp = [_this select 0, "radio"] call EVO_fnc_sendToAO;
			waitUntil {({alive _x} count units _grp) < 4};
			_delay = ["Infantry"] call EVO_fnc_calculateDelay;
			sleep _delay;
		};
	};
};


//////////////////////////////////////
//Target AO Officer
//////////////////////////////////////
_spawnPos = [position currentTarget , 50, 300, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
_grp = createGroup east;
currentTargetOF = _grp createUnit [EVO_opforOfficer, _spawnPos, [], 0, "FORM"];
publicVariable "currentTargetOF";
currentTargetOF addEventHandler ["Killed", {officerAlive = false; publicVariable "officerAlive";}];
currentTargetOFname = str(name currentTargetOF);
publicVariable "currentTargetOFname";
currentTargetOF AddMPEventHandler ["mpkilled", {
	[officerTask, "Failed", false] call bis_fnc_taskSetState;
	[[[currentTargetOFname], {
		_msg = format ["Colonel %1 has been killed.", (_this select 0)];
		["TaskFailed",["OFFICER KIA", _msg]] call BIS_fnc_showNotification;
	}], "BIS_fnc_spawn", true, true] call BIS_fnc_MP;
}];
_officer = currentTargetOF;
group _officer setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
_pos = (getPos _officer);
_spawnPos = [];
_max_distance = 100;
while{ count _spawnPos < 1 } do	{
	_spawnPos = _pos findEmptyPosition[ 30 , _max_distance , (typeOf _officer)];
	_max_distance = _max_distance + 50;
};
_officer setPosASL _spawnPos;
removeAllWeapons _officer;
_officer setCaptive true;
doStop _officer;
[[[currentTargetOF], {
	(_this select 0) addaction [format["<t color='#CCCC00'>Capture COLONEL %1</t>", name currentTargetOF], "_this spawn EVO_fnc_capture", nil,1,false,true,"","!(side leader group currentTargetOF == WEST) && alive currentTargetOF"];
}], "BIS_fnc_spawn", true, true] call BIS_fnc_MP;

_grp = [getPos currentTargetOF, EAST, (EVO_opforInfantry call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;
{
	if (HCconnected) then {
		handle = [_x] call EVO_fnc_sendToHC;
	};
	currentAOunits pushBack _x;
	publicVariable "currentAOunits";

	_x AddMPEventHandler ["mpkilled", {currentAOunits = currentAOunits - [_this select 1]}];
} forEach units _grp;

[_grp, getPos currentTargetOF, 100] call CBA_fnc_taskDefend;
//////////////////////////////////////
//OPFOR MORTAR EMPLACEMENT
//////////////////////////////////////
for "_i" from 1 to (["Mortar", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_center = [ getMarkerPos currentTargetMarkerName, (600 + random 500) , random 360 ] call BIS_fnc_relPos;
		_spawnPos = [];
		_max_distance = 100;
		while{ count _spawnPos < 1 } do {
			_spawnPos = _center findEmptyPosition[ 30 , _max_distance , "Land_Cargo_Patrol_V3_F" ];
			_max_distance = _max_distance + 50;
		};
		_dir = [_spawnPos, position currentTarget] call BIS_fnc_dirTo;
		_comp = ["comps\mortar.sqf"] call BIS_fnc_selectRandom;
		_grp = createGroup EAST;
		_mortarGunner = _grp createUnit ["O_Crew_F", _spawnPos, [], 0, "FORM"];
		//_newComp = [_spawnPos, _dir, call (compile (preprocessFileLineNumbers _comp))] call BIS_fnc_ObjectsMapper;
		_newComp = [_spawnPos, _comp] call EVO_fnc_createComposition;
		//_newComp = [_spawnPos, _dir, _comp, false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
		_mortar = nearestObject [_spawnPos, "O_Mortar_01_F"];
		_mortarGunner assignAsGunner _mortar;
		_mortarGunner moveInGunner _mortar;
		_grp = [_spawnPos, EAST, (EVO_opforInfantry call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;
		{
			if (HCconnected) then {
				handle = [_x] call EVO_fnc_sendToHC;
			};
		} forEach units _grp;
		[_grp, _spawnPos, 100] call CBA_fnc_taskDefend;
	};
};
//////////////////////////////////////
//OPFOR INFANTRY
//////////////////////////////////////
for "_i" from 1 to (["Infantry", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_grp = [_this select 0, "infantry", true] call EVO_fnc_sendToAO;
		waitUntil {({alive _x} count units _grp) < 5};
		while {RTonline && (_this select 0 == currentTarget)} do {
			_grp = [_this select 0, "infantry"] call EVO_fnc_sendToAO;
			waitUntil {({alive _x} count units _grp) < 4};
			_delay = ["Infantry"] call EVO_fnc_calculateDelay;
			sleep _delay;
		};
	};
};
//////////////////////////////////////
//OPFOR ARMOR
//////////////////////////////////////
for "_i" from 1 to (["Armor", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_grp = [_this select 0, "armor", true] call EVO_fnc_sendToAO;
		_tank = vehicle leader _grp;
		waitUntil {({alive _x} count units _grp) < 1 || !canMove _tank || !alive _tank};
		while {RTonline && (_this select 0 == currentTarget)} do {
			_grp = [_this select 0, "armor"] call EVO_fnc_sendToAO;
			_tank = vehicle leader _grp;
			waitUntil {({alive _x} count units _grp) < 1 || !canMove _tank || !alive _tank};
			_delay = ["Armor"] call EVO_fnc_calculateDelay;
			sleep _delay;
		};
	};
};
//////////////////////////////////////
//OPFOR SNIPERS
//////////////////////////////////////
for "_i" from 1 to (["Sniper", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_pos = [position currentTarget , 0, 300, 3, 0, 1, 0] call BIS_fnc_findSafePos;
		[_pos] call EVO_fnc_createSniper;
	};
};
//////////////////////////////////////
//OPFOR CAS
//////////////////////////////////////
for "_i" from 1 to (["CAS", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_ret = [(getPos server), (floor (random 360)), (EVO_opforCAS call bis_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
		_plane = _ret select 0;
		_grp = _ret select 2;
		_plane flyInHeight 500;
		[_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;
		[_plane] spawn EVO_fnc_trackAir;
		while {RTonline && (_this select 0 == currentTarget)} do {
			_ret = [(getPos server), (floor (random 360)), (EVO_opforCAS call bis_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
			_plane = _ret select 0;
			_grp = _ret select 2;
			_plane flyInHeight 500;
			[_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;
			[_plane] spawn EVO_fnc_trackAir;
			waitUntil {({alive _x} count units _grp) < 1 || !canMove _plane || !alive _plane};
			_delay = ["CAS"] call EVO_fnc_calculateDelay;
			sleep _delay;
		};
	};
};
//////////////////////////////////////
//OPFOR Minefield - Infantry
//////////////////////////////////////
for "_i" from 1 to (["Minefield_Inf", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_startPos = [position currentTarget , 50, 300, 3, 0, 1, 0] call BIS_fnc_findSafePos;
		_mineClass = ["APERSBoundingMine","APERSMine"] call BIS_fnc_selectRandom;
		[_startPos, _mineClass] call EVO_fnc_createMinefield;
	};
};
//////////////////////////////////////
//OPFOR Minefield - Roads
//////////////////////////////////////
for "_i" from 1 to (["Minefield_AT", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_startPos = [position currentTarget , 50, 300, 3, 0, 1, 0] call BIS_fnc_findSafePos;
		[_startPos, "ATMine"] call EVO_fnc_createMinefield;
	};
};
//////////////////////////////////////
//OPFOR EMPLACEMENTS
//////////////////////////////////////
for "_i" from 1 to (["Comps", "Main"] call EVO_fnc_calculateOPFOR) do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		_pos = [position _currentTarget, (random 300) , (random 360)] call BIS_fnc_relPos;
		//_newComp = [_pos, ([] call BIS_fnc_selectRandom)] call EVO_fnc_createComposition;
	};
};


sleep 1;

//////////////////////////////////////
//Start Objective & Add Tasks
//////////////////////////////////////
[CROSSROADS, format ["We've received our next target, all forces converge on %1!", currentTargetName]] call EVO_fnc_globalSideChat;
[[[], {
	if (!isDedicated) then {
		_sound = ["opforCaptured_2", "opforCaptured_1", "opforCaptured_0"] call BIS_fnc_selectRandom;
		playSound _sound;
		[] call BIS_fnc_drawMinefields;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

[] call EVO_fnc_newTargetTasks;

//////////////////////////////////////
//Mortar Flare Detection
//////////////////////////////////////
_null = [_currentTarget] spawn {
	_currentTarget = _this select 0;
	while {RTonline && (_currentTarget == currentTarget)} do {
	    sleep 10;
	    _mortar = nearestObject [position currentTarget, "O_Mortar_01_F"];
	    _gunner = gunner _mortar;
	    if (isNil "_gunner" || !alive _gunner || side _gunner != EAST) then {
	    	_mortar setDamage 1;
	    } else {
	    	if (daytime > 20 && daytime < 6) then {
	    		_mortar doArtilleryFire [position _currentTarget, "8Rnd_82mm_Mo_Flare_white", (3 + random(floor(3)))];
	    		_s = 60 + random(floor(30));
	    		sleep _s;
	        };
   	    };
	};
};

//////////////////////////////////////
//Hold Until Radio Tower Offline
//////////////////////////////////////
_loop = true;
_count = 0;
while {_loop} do {
	sleep 10;
	if (!RTonline) then {
		_loop = false;
	};
};

//////////////////////////////////////
//Radio Tower Offline
//////////////////////////////////////
[[[], {
	if (!isDedicated) then {
		_tskName = format ["Radio Tower Destroyed at %1", currentTargetName];
		["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
[towerTask, "Succeeded", false] call bis_fnc_taskSetState;
sleep (random 15);
[CROSSROADS, format ["We've received confirmation that the SLA communications tower has been destroyed, %1 will no longer be reinforced by SLA.", currentTargetName]] call EVO_fnc_globalSideChat;
_sound = ["capturing_2", "capturing_1", "capturing_0"] call BIS_fnc_selectRandom;
playSound _sound;
//////////////////////////////////////
//Hold Until BLUFOR Captures AO
//////////////////////////////////////
_loop = true;
_count = 0;
while {_loop} do {
	_count = 0;
	sleep 10;
	{
		if (alive _x && ([_x, getMarkerPos currentTargetMarkerName] call BIS_fnc_distance2D < 1000)) then {
			_count = _count + 1;
		};
	} forEach currentAOunits;
	if (_count < 9) then {
		_loop = false;
	};
};
//////////////////////////////////////
//Force existing OPFOR to choose to surrender or fight
//////////////////////////////////////
if (_count > 0) then {
	{
		if ([true, false] call bis_fnc_selectRandom) then {
			[_x] spawn EVO_fnc_surrender;
		} else {
			[_x] spawn {
				_unit = _this select 0;
				_loop = true;
				while {_loop} do {
					_players = [_unit, 500] call EVO_fnc_playersNearby;
					if (!_players || !alive _unit) then {
						_loop = false;
					};
				};
				sleep 60;
				sleep (random 60);
				deleteVehicle _unit;
			};
		};
	} forEach currentAOunits;
};
//////////////////////////////////////
//Complete Current AO & Set Tasks
//////////////////////////////////////
_sound = ["sectorCaptured_2", "sectorCaptured_1", "sectorCaptured_0"] call BIS_fnc_selectRandom;
playSound _sound;
[CROSSROADS, format ["OPFOR are retreating from %1. Nice job men!", currentTargetName]] call EVO_fnc_globalSideChat;
[attackTask, "Succeeded", false] call bis_fnc_taskSetState;

if (alive currentTargetOF && side (leader group currentTargetOF) != WEST) then {
	[officerTask, "Failed", false] call bis_fnc_taskSetState;
	_tskName = format ["Colonel %1 Escaped.", name currentTargetOF];
	["TaskFailed",["",_tskName]] call BIS_fnc_showNotification;
};
//////////////////////////////////////
//Give BLUFOR Points
//////////////////////////////////////
[[[], {
	if (!isDedicated) then {
		_tskName = format ["%1 Secured.", currentTargetName];
		["PointsAdded",["BLUFOR completed a mission objective.", 5]] call BIS_fnc_showNotification;
		["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
	};
}], "BIS_fnc_spawn"] call BIS_fnc_MP;
//////////////////////////////////////
//Set Marker Color
//////////////////////////////////////
currentTargetMarkerName setMarkerBrush "SOLID";
currentTargetMarkerName setMarkerColor "ColorWEST";
//deleteMarker currentTargetMarkerName;
//currentTargetMarkerName setMarkerAlpha 0;
sleep random 30;
//////////////////////////////////////
//Reset for Next AO
//////////////////////////////////////
targetCounter = targetCounter + 1;
publicVariable "targetCounter";
currentTarget = targetLocations select targetCounter;
publicVariable "currentTarget";
currentTargetName = text currentTarget;
publicVariable "currentTargetName";
RTonline = true;
publicVariable "RTonline";
//////////////////////////////////////
//Start Next AO
//////////////////////////////////////
handle = [] spawn EVO_fnc_initTarget;


