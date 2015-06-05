private ["_locTypes","_locs","_mil","_counter","_markerName","_aaMarker","_vehicle","_null","_grp","_driver","_commander","_gunner","_ret","_plane"];

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
handle = [] spawn EVO_fnc_buildSideMissionArray;
handle = [] spawn EVO_fnc_endgame;

{
	_vehicle = _x;
	if (faction _vehicle == "BLU_F") then {
		if (!(_vehicle isKindOf "Plane") && ((typeOf _vehicle) != "B_MRAP_01_F")) then {
			_null = [_vehicle] spawn EVO_fnc_respawnRepair;
		} else {
			_null = [_vehicle] spawn EVO_fnc_basicRespawn;
		};
	};
	if (typeOf _vehicle == "O_APC_Tracked_02_AA_F") then {
		_markerName = format ["aa_%1", markerCounter];
		_aaMarker = createMarker [_markerName, position _x ];
		_markerName setMarkerShape "ELLIPSE";
		_markerName setMarkerBrush "Cross";
		_markerName setMarkerSize [1200, 1200];
		_markerName setMarkerColor "ColorEAST";
		_markerName setMarkerPos (GetPos _vehicle);
		markerCounter = markerCounter + 1;
		//O_crew_F
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

		} forEach units _grp;
		_vehicle addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
		_vehicle addEventHandler ["Killed", {deleteMarker _markerName}];
	};
} forEach vehicles;

handle = [] spawn {
	while {true} do {
		_ret = [(getPos server), (floor (random 360)), (["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_Plane_CAS_02_F","O_UAV_02_CAS_F","O_Plane_CAS_02_F"] call bis_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
		_plane = _ret select 0;
		_grp = _ret select 2;
		//_plane flyInHeight 400;
		_null = [(leader _grp), currentTargetMarkerName, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
		waitUntil {!canMove _plane || !alive _plane};
		sleep 400;
	};
};

handle = [] spawn EVO_fnc_initTarget;



