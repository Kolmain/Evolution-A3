private ["_locTypes","_locs","_mil","_vehicle","_null","_markerName","_aaMarker","_grp","_driver","_commander","_gunner","_ret","_plane","_wp"];

_locTypes = [
//"CityCenter",
"NameCity",
"NameCityCapital",
//"NameLocal",
//"NameMarine",
"NameVillage"
];
targetLocations = nearestLocations [ (getPos spawnBuilding), _locTypes, 10000000];

_locs = nearestLocations [spawnBuilding, ["NameLocal"], 100000];
_mil = [];
{
	if ((tolower (text _x)) in ["military"]) then {
		_mil set [(count _mil),_x]
	};
} foreach _locs;
militaryLocations = _mil;


targetCounter = 2;
currentTarget = targetLocations select targetCounter;
currentTargetName = text currentTarget;
currentTargetRT = nil;
currentTargetOF = nil;
RTonline = true;
officerAlive = true;
paraSquads = 1;
infSquads = (("infSquadsParam" call BIS_fnc_getParamValue) * 2);
mechSquads = ("mechSquadsParam" call BIS_fnc_getParamValue);
armorSquads = ("armorSquadsParam" call BIS_fnc_getParamValue);
CROSSROADS = [West,"HQ"];
markerCounter = 0;
"opforair" setMarkerAlpha 0;
currentSideMission = "none";
currentSideMissionMarker = "nil";
availableSideMissions = [];

handle = [] spawn EVO_fnc_buildSideMissionArray;

_i = 0;
{
	_vehicle = _x;
	if ((faction _vehicle == "BLU_F") && !(_vehicle isKindOf "Plane") && ((typeOf _vehicle) != "B_MRAP_01_F")) then {
		_null = [_vehicle] spawn EVO_fnc_respawnRepair;
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
		handle = [_vehicle, _markerName] spawn {
			_vehicle = _this select 0;
			_markerName = _this select 1;
			waitUntil {!alive _vehicle};
			deleteMarker _markerName;
		};
	};
} forEach vehicles;

handle = [] spawn {
	while {true} do {
		_ret = [(getPos server), (floor (random 360)), "O_Plane_CAS_02_F", EAST] call bis_fnc_spawnvehicle;
		_plane = _ret select 0;
		_grp = _ret select 2;
		_plane flyInHeight 350;
		{
			_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
		}  forEach units _grp;
		_wp =_grp addWaypoint [getMarkerPos "opforair", 0];
		[_grp, 0] setWaypointBehaviour "COMBAT";
		[_grp, 0] setWaypointCombatMode "RED";
		[_grp, 0] setWaypointSpeed "FULL";
		[_grp, 0] setWaypointType "HOLD";
		[_grp, 0] setWPPos markerPos "opforair";
		waitUntil {!canMove _plane || !alive _plane};
		sleep 400;
	};
};

handle = [] spawn EVO_fnc_initTarget;



