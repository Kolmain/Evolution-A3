private ["_locTypes","_locs","_mil","_counter","_markerName","_aaMarker","_vehicle","_null","_grp","_driver","_commander","_gunner","_ret","_plane"];
//////////////////////////////////////
//Init Global EVO Variables
//////////////////////////////////////
_locTypes = ["NameCity", "NameCityCapital", "NameVillage"];
targetLocations = nearestLocations [ (getPos spawnBuilding), _locTypes, 10000000];
_locs = nearestLocations [spawnBuilding, ["NameLocal"], 100000];
sideLocations = _locs;
publicVariable "sideLocations";
_mil = [];
{
	if ((tolower (text _x)) in ["military"]) then {
		_mil set [(count _mil),_x]
	};
} foreach _locs;
militaryLocations = _mil;
targetCounter = 2;
totalTargets = ("numberOfAOs" call BIS_fnc_getParamValue);
if (totalTargets == 999) then {totalTargets = count targetLocations};
totalTargets = totalTargets + targetCounter;
currentTarget = targetLocations select targetCounter;
currentTargetName = text currentTarget;
currentTargetRT = nil;
currentTargetOF = nil;
RTonline = true;
officerAlive = true;
infSquads = ("infSquadsParam" call BIS_fnc_getParamValue);
armorSquads = ("armorSquadsParam" call BIS_fnc_getParamValue);
markerCounter = 0;
"opforair" setMarkerAlpha 0;
"counter" setMarkerAlpha 0;
"counter_1" setMarkerAlpha 0;
currentSideMission = "none";
currentSideMissionMarker = "nil";
nextTargetMarkerName = "nil";
availableSideMissions = [];
currentSideMissionStatus = "ip";
EVO_supportUnits = [arty_west, mortar_west, rocket_west];
{
	_x addEventHandler ["HandleScore", {
		_supportAsset = _this select 0;
		_source = _this select 1;
		_scoreToAdd = _this select 2;
		_player = _supportAsset getVariable ["EVO_playerRequester", objNull];
		_score = _player getVariable "EVO_score";
		_score = _score + _scoreToAdd;
		_player setVariable ["EVO_score", _score, true];
		[_player, _scoreToAdd] call bis_fnc_addScore;
		if (EVO_Debug) then {
			systemChat format ["%1 got points from %2. Sending points to %3.", _supportAsset, _source, _player];
		};
	}];
} forEach EVO_supportUnits;
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
handle = [] spawn EVO_fnc_buildSideMissionArray;

//////////////////////////////////////
//Check All Vehicles on Map
//////////////////////////////////////
{
	_vehicle = _x;
	//////////////////////////////////////
	//Setup BLUFOR Vehicle Respawn/Repair Systems
	//////////////////////////////////////
	if (faction _vehicle == "BLU_F") then {
		if (!(_vehicle isKindOf "Plane") && !(_vehicle isKindOf "Man")) then {
			_null = [_vehicle] spawn EVO_fnc_respawnRepair;
		} else {
			_null = [_vehicle] spawn EVO_fnc_basicRespawn;
		};
	};
	//////////////////////////////////////
	//Setup OPFOR AAA
	//////////////////////////////////////
	if (typeOf _vehicle == "O_APC_Tracked_02_AA_F") then {
		_markerName = format ["aa_%1", markerCounter];
		_aaMarker = createMarker [_markerName, position _x ];
		_markerName setMarkerShape "ELLIPSE";
		_markerName setMarkerBrush "Cross";
		_markerName setMarkerSize [1200, 1200];
		_markerName setMarkerColor "ColorEAST";
		_markerName setMarkerPos (GetPos _vehicle);
		markerCounter = markerCounter + 1;
		_grp = createGroup east;
		_driver = _grp createUnit ["O_crew_F", getPos server, [], 0, "FORM"];
		_commander = _grp createUnit ["O_crew_F", getPos server, [], 0, "FORM"];
		_gunner = _grp createUnit ["O_crew_F", getPos server, [], 0, "FORM"];
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
			_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
			if (HCconnected) then {
				handle = [_x] call EVO_fnc_sendToHC;
			};
		} forEach units _grp;
		_vehicle addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
		_vehicle addEventHandler ["Killed", {deleteMarker _markerName}];
		_vehicle allowCrewInImmobile true;
	};
} forEach vehicles;

//////////////////////////////////////
//Init First Target
//////////////////////////////////////
handle = [] spawn EVO_fnc_initTarget;



