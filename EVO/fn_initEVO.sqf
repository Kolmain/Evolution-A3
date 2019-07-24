private ["_locTypes","_locs","_mil","_counter","_markerName","_aaMarker","_vehicle","_null","_grp","_driver","_commander","_gunner","_ret","_plane"];
//////////////////////////////////////
//Init Global EVO Variables
//////////////////////////////////////


_locs = nearestLocations [spawnBuilding, ["NameLocal","NameCity", "NameCityCapital", "NameVillage"], [] call BIS_fnc_mapSize];
sideLocations = _locs;
publicVariable "sideLocations";
//LocationBase_F
militaryLocations = nearestObjects [spawnBuilding, ["LocationBase_F"], [] call BIS_fnc_mapSize];
targetLocations = [];
targetObjects = [obj, obj_1, obj_2, obj_3, obj_4, obj_5, obj_6, obj_7, obj_8, obj_9, obj_10];
{
	_closesttown = (nearestLocations [(getPos _x),["NameCityCapital","NameCity","NameVillage"],10000]) select 0;
	targetLocations = targetLocations + [_closesttown];
} forEach targetObjects;
totalTargets = count targetLocations;
if (isNil "targetCounter") then {
	targetCounter = 0;
} else {
	for "_i" from 3 to targetCounter step 1 do {
		_marker = format ["%1", _i];
		_currentTarget = targetLocations select _i;
		_mrkr = createMarker [_marker, position _currentTarget];
		_marker setMarkerPos (position _currentTarget);
		_marker setMarkerSize [(((size _currentTarget) select 0) + 200), (((size _currentTarget) select 1) + 200)];
		_marker setMarkerDir direction _currentTarget;
		_marker setMarkerShape "ELLIPSE";
	  	_marker setMarkerBrush "SOLID";
		_marker setMarkerColor "ColorWEST";
	};
};



currentTarget = targetLocations select targetCounter;
currentTargetName = text currentTarget;
currentTargetRT = nil;
currentTargetOF = nil;
RTonline = true;
officerAlive = true;
markerCounter = 0;
"opforair" setMarkerAlpha 0;
"counter" setMarkerAlpha 0;
"counter_1" setMarkerAlpha 0;
currentSideMission = "none";
currentSideMissionMarker = "nil";
nextTargetMarkerName = "nil";
availableSideMissions = [];
currentSideMissionStatus = "ip";
//EVO_supportUnits = [arty_west, mortar_west, rocket_west];
currentAOunits = [];
publicVariable "currentAOunits";
/*
{
	gunner _x addEventHandler ["HandleScore", {
		_supportAsset = _this select 0;
		_source = _this select 1;
		_scoreToAdd = _this select 2;
		_player = _supportAsset getVariable ["EVO_playerRequester", objNull];
		[_player, _scoreToAdd] call bis_fnc_addScore;
		if (EVO_Debug) then {
			systemChat format ["%1 got points from %2. Sending points to %3.", _supportAsset, _source, _player];
		};
	}];
} forEach EVO_supportUnits;
*/
if (EVO_Debug) then {
	systemChat format["EVO_init found %1 AO's.", count targetLocations];
	_counter = 1;
	{
		_markerName = format ["debug_ao_%1", markerCounter];
		_aaMarker = createMarker [_markerName, position _x ];
		_markerName setMarkerShape "ICON";
		_markerName setMarkerType "mil_dot";
		_markerName setMarkerColor "ColorWEST";
		_markerName setMarkerPos (position _x);
		_markerName setMarkerText format["AO %1", _counter];
		markerCounter = markerCounter + 1;
		_counter = _counter + 1;
	} forEach targetLocations
};
//////////////////////////////////////
//Spawn End Game Loop
//////////////////////////////////////
handle = [] spawn EVO_fnc_endgame;

//////////////////////////////////////
//Build Available Side Missions
//////////////////////////////////////
//handle = [] spawn EVO_fnc_buildSideMissionArray;

//////////////////////////////////////
//Check All Vehicles on Map
//////////////////////////////////////
{
	_vehicle = _x;
	//////////////////////////////////////
	//Setup BLUFOR Vehicle Respawn/Repair Systems
	//////////////////////////////////////
	if (faction _vehicle == "CUP_B_USMC" || faction _vehicle == "CUP_B_US_Army" || faction _vehicle == "BLU_F") then {
		if (toUpper(typeOf _vehicle) == "CUP_B_HMMWV_UNARMED_USMC")	then {
			_null = [_vehicle] spawn EVO_fnc_basicRespawn;
		} else {
			if (!(_vehicle isKindOf "Plane") && !(_vehicle isKindOf "Man")) then {
				_null = [_vehicle] spawn EVO_fnc_respawnRepair;
			} else {
				if (_vehicle isKindOf "Plane") then {
					_null = [_vehicle] spawn EVO_fnc_basicRespawn;
				};
			};
		};
	};
	//////////////////////////////////////
	//Setup OPFOR AAA
	//////////////////////////////////////
	if (typeOf _vehicle == EVO_opforAAA) then {
		_markerName = format ["aa_%1", markerCounter];
		_aaMarker = createMarker [_markerName, position _x ];
		_markerName setMarkerShape "ELLIPSE";
		_markerName setMarkerBrush "Cross";
		_markerName setMarkerSize [1200, 1200];
		_markerName setMarkerColor "ColorEAST";
		_markerName setMarkerPos (GetPos _vehicle);
		markerCounter = markerCounter + 1;
		_grp = createGroup east;
		_driver = _grp createUnit [EVO_opforCrew, getPos server, [], 0, "FORM"];
		_commander = _grp createUnit [EVO_opforCrew, getPos server, [], 0, "FORM"];
		_gunner = _grp createUnit [EVO_opforCrew, getPos server, [], 0, "FORM"];
		_driver moveInDriver _vehicle;
		_driver assignAsDriver _vehicle;
		doStop _driver;
		_driver disableAI "MOVE";
		_commander moveInCommander _vehicle;
		_commander assignAsCommander _vehicle;
		_gunner moveInGunner _vehicle;
		_gunner assignAsGunner _vehicle;
		_vehicle lock true;
		{
			_x setSkill ["spotdistance", 1.0];
			_x setSkill ["aimingspeed", 0.15];
			_x setSkill ["aimingaccuracy", 0.1];
			_x setSkill ["aimingshake", 0.15];
			_x setSkill ["spottime", 0.5];
			_x setSkill ["commanding", 0.8];
			_x setSkill ["general", 0.8];
			if (HCconnected) then {
				handle = [_x] call EVO_fnc_sendToHC;
			};
		} forEach units _grp;
		_vehicle addEventHandler ["Killed", {deleteMarker _markerName}];
		_vehicle allowCrewInImmobile true;
	};
} forEach vehicles;

//////////////////////////////////////
//Init First Target
//////////////////////////////////////
	handle = [] spawn EVO_fnc_initTarget;




