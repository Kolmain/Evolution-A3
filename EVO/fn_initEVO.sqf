//////////////////////////////////////
//Init Global EVO Variables
//////////////////////////////////////
_locTypes = ["NameCity", "NameCityCapital", "NameVillage"];
targetLocations = nearestLocations [ (getPos spawnBuilding), _locTypes, [] call BIS_fnc_mapSize];
_locs = nearestLocations [spawnBuilding, ["NameLocal"], [] call BIS_fnc_mapSize];
sideLocations = _locs;
publicVariable "sideLocations";
_mil = [];
{
	if ((tolower (text _x)) in ["military"]) then {
		_mil set [(count _mil),_x]
	};
} foreach _locs;
militaryLocations = _mil;
if (isNil "targetCounter") then {
	targetCounter = 2;
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
//targetCounter = 2;
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
currentAOunits = [];
publicVariable "currentAOunits";

//////////////////////////////////////
//Check All Vehicles on Map
//////////////////////////////////////
{
	_vehicle = _x;
	//////////////////////////////////////
	//Setup BLUFOR Vehicle Respawn/Repair Systems
	//////////////////////////////////////
	if (faction _vehicle == "CUP_B_USMC" || faction _vehicle == "CUP_B_US_Army" || faction _vehicle == "BLU_F") then {
		if (toUpper(typeOf _vehicle) == "CUP_B_M1151_USMC")	then {
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
		_vehicle setVariable ["EVO_markerName", _markerName, true];
		_vehicle AddEventHandler ["Killed", {deleteMarker ((_this select 0) getVariable "EVO_markerName")}];
		_vehicle allowCrewInImmobile true;
		_vehicle setDir (random 360);
	};
} forEach vehicles;

//////////////////////////////////////
//Init First Target
//////////////////////////////////////
if (("numberOfAOs" call BIS_fnc_getParamValue) > 0) then {
	if (("persistentEVO" call BIS_fnc_getParamValue) == 1) then {
		profileNamespace setVariable ["EVO_currentTargetCounter", targetCounter];
		profileNamespace setVariable ["EVO_world", worldName];
		_scoreArray = [];
		{
			if (isPlayer _x) then
			{
				_push = [];
				_push pushBack (getPlayerUID _x);
				_push pushBack (score _x);
				_scoreArray pushBack _push;
			};
		} forEach playableUnits;
		profileNamespace setVariable ["EVO_scoreArray", _scoreArray];
		saveProfileNamespace;
	};
	handle = [] spawn EVO_fnc_initTarget;
};




