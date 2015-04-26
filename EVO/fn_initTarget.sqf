private ["_currentTarget","_grp","_null","_ret","_tank","_eastUnits","_allUnits"];

currentTargetName = text currentTarget;
_currentTarget = currentTarget;
_targetType = type currentTarget;
currentTargetMarkerName = format ["%1_ao", currentTargetName];
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
"opforair" setMarkerPos (getMarkerPos currentTargetMarkerName);

_towerClass = "Land_Communication_F";
//_towerClass = ["Land_Communication_F", "Land_TTowerBig_2_F", "Land_TTowerBig_1_F"] call BIS_fnc_selectRandom;
_center = [ getMarkerPos currentTargetMarkerName, random 80 , random 360 ] call BIS_fnc_relPos;
_spawnPos = [];
_max_distance = 100;
while{ count _spawnPos < 1 } do
{
	_spawnPos = _center findEmptyPosition[ 30 , _max_distance , _towerClass ];
	_max_distance = _max_distance + 50;
};
currentTargetRT = _towerClass createVehicle _spawnPos;
handle = [currentTargetRT] spawn EVO_fnc_demoOnly;
currentTargetRT addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
currentTargetRT addEventHandler ["Killed", {_this call EVO_fnc_RToffline}];
RTonline = true;


_center = [ getMarkerPos currentTargetMarkerName, (600 + random 500) , random 360 ] call BIS_fnc_relPos;
_spawnPos = [];
_max_distance = 100;
while{ count _spawnPos < 1 } do
{
	_spawnPos = _center findEmptyPosition[ 30 , _max_distance , "Land_Cargo_Patrol_V3_F" ];
	_max_distance = _max_distance + 50;
};
_dir = [_spawnPos, position currentTarget] call BIS_fnc_dirTo;
_comp = ["comps\mortar.sqf", "comps\mortar_50.sqf", "comps\mortar_50_2.sqf", "comps\mortar_50_tower.sqf"] call BIS_fnc_selectRandom;
_grp = createGroup EAST;
_mortarGunner = _grp createUnit ["O_crew_F", _spawnPos, [], 0, "FORM"];
_newComp = [_spawnPos, _dir, _comp, false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
_mortar = nearestObject [_spawnPos, "O_Mortar_01_F"];
_mortarGunner assignAsGunner _mortar;
_mortarGunner moveInGunner _mortar;


nul = [_mortar] execVM "scripts\UPSMON\MON_artillery_add.sqf";
_grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
if (HCconnected) then {
	{
		handle = [_x] call EVO_fnc_sendToHC;
	} forEach units _grp;
};

{
	_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
}  forEach units _grp;
[_grp, _spawnPos] call bis_fnc_taskDefend;




_center = [ getMarkerPos currentTargetMarkerName, random 150 , random 360 ] call BIS_fnc_relPos;
_spawnPos = [];
_max_distance = 100;
while{ count _spawnPos < 1 } do
{
	_spawnPos = _center findEmptyPosition[ 30 , _max_distance , _towerClass ];
	_max_distance = _max_distance + 50;
};
_grp = createGroup east;
currentTargetOF = _grp createUnit ["O_officer_F", _spawnPos, [], 0, "FORM"];
currentTargetOF addEventHandler ["Killed", {officerAlive = false; publicVariable officerAlive;}];
_officer = currentTargetOF;
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
[[[_officer], {(_this select 0) addAction [ "Capture Officer", "[] call EVO_fnc_officer;"];}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
//_officer addAction [ "Capture Officer", "[] call EVO_fnc_officer;"];
doStop _officer;

_grp = [getPos currentTargetRT, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
if (HCconnected) then {
	{
		handle = [_x] call EVO_fnc_sendToHC;
	} forEach units _grp;
};

{
	_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
}  forEach units _grp;

[_grp, getPos currentTargetRT] call bis_fnc_taskDefend;

_grp = [getPos currentTargetOF, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
if (HCconnected) then {
	{
		handle = [_x] call EVO_fnc_sendToHC;
	} forEach units _grp;
};

{
	_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
}  forEach units _grp;

[_grp, getPos currentTargetOF] call bis_fnc_taskDefend;

for "_i" from 1 to paraSquads do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { _currentTarget == currentTarget } do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad_Weapons")] call BIS_fnc_spawnGroup;
		    if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{
				_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			}  forEach units _grp;
		    _spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _ret = [_spawnPos, (floor (random 360)), "O_Heli_Light_02_unarmed_F", EAST] call bis_fnc_spawnvehicle;
		    _heli = _ret select 0;
		    _heliGrp = _ret select 2;
		    if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _heliGrp;
			};
			{
			_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			}  forEach units _heliGrp;
		    {
		    	_x assignAsCargo _heli;
		    	_x moveInCargo _heli;
		    } forEach units _grp;
		    _heli doMove (getMarkerPos currentTargetMarkerName);
		    _heli flyInHeight 150;
		    waitUntil {(_heli distance (getMarkerPos currentTargetMarkerName)) < 500};
		    handle = [_heli] call EVO_fnc_paradrop;
		    sleep 5;
		    _heli doMove (getPos server);
		    handle = [_heli] spawn {
		    	_heli = _this select 0;
		    	waitUntil {(_heli distance server) < 1000};
		    	{
		    		deleteVehicle _x;
		    	} forEach units group driver _heli;
		    	deleteVehicle _heli;
			};
			_null = [(leader _grp), currentTargetMarkerName, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			//waitUntil {({alive _x} count units _grp) < 3};
			sleep 600;
		};
	};
};

for "_i" from 1 to infSquads do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { RTonline && _currentTarget == currentTarget } do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		    if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{
				_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			}  forEach units _grp;
			_null = [(leader _grp), currentTargetMarkerName, "RANDOM", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			waitUntil {({alive _x} count units _grp) < 2};
		};
	};
};

for "_i" from 1 to (mechSquads) do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { RTonline && _currentTarget == currentTarget } do {
			_spawnPos = [getMarkerPos currentTargetMarkerName, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			//_class = ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F"] select (random floor(1));
			_class = ["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F", "O_UGV_01_rcws_F","O_APC_Wheeled_02_rcws_F"] call BIS_fnc_selectRandom; //returns one of the variables
		    _ret = [_spawnPos, (floor (random 360)), _class, EAST] call bis_fnc_spawnvehicle;
		    _tank = _ret select 0;
		    _grp = _ret select 2;
		    if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{
				_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			}  forEach units _grp;
			_null = [(leader _grp), currentTargetMarkerName, "ONROAD", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			_grp setSpeedMode "NORMAL";
			waitUntil {!canMove _tank || !alive _tank};
		};
	};
};

for "_i" from 1 to armorSquads do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { RTonline && _currentTarget == currentTarget } do {
			_spawnPos = [getMarkerPos currentTargetMarkerName, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _ret = [_spawnPos, (floor (random 360)), "O_MBT_02_cannon_F", EAST] call bis_fnc_spawnvehicle;
		    _tank = _ret select 0;
		    _grp = _ret select 2;
		    if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{
				_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			}  forEach units _grp;
			_null = [(leader _grp), currentTargetMarkerName, "ONROAD", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			_grp setSpeedMode "LIMITED";
			waitUntil {(({alive _x} count units _grp) == 0) || !alive _tank || !canMove _tank};
		};
	};
};

[CROSSROADS, format ["We've received our next target, all forces converge on %1!", currentTargetName]] call EVO_fnc_globalSideChat;
_sound = ["opforCaptured_2", "opforCaptured_1", "opforCaptured_0"] call BIS_fnc_selectRandom;
playSound _sound;
[[[], {
	if (!isServer || !isMultiplayer) then {
		_tskName = format ["Clear %1", currentTargetName];
		attackTask = player createSimpleTask [_tskName];
		attackTask setTaskState "Created";
		attackTask setSimpleTaskDestination (getMarkerPos currentTargetMarkerName);
		_tskName = format ["Destroy Radio Tower"];
		towerTask = player createSimpleTask [_tskName, attackTask];
		towerTask setTaskState "Assigned";
		//towerTask setSimpleTaskDestination (getPos currentTargetRT);
		_tskName = format ["Secure Col. %1", name currentTargetOF];
		officerTask = player createSimpleTask [_tskName, attackTask];
		officerTask setTaskState "Created";
		_tskName = format ["Clear the city of %1.", currentTargetName];
		["TaskAssigned",["",_tskName]] call BIS_fnc_showNotification;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

waitUntil {!RTonline};

[[[], {
	if (!isServer || !isMultiplayer) then {
		towerTask setTaskState "Succeeded";
		_tskName = format ["Radio Tower Destroyed"];
		["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

sleep (random 15);
[CROSSROADS, format ["We've received confirmation that the OPFOR communications tower has been destroyed, %1 will no longer be reinforced by OPFOR.", currentTargetName]] call EVO_fnc_globalSideChat;
_sound = ["capturing_2", "capturing_1", "capturing_0"] call BIS_fnc_selectRandom;
playSound _sound;
_eastUnits = 100;
while {_eastUnits > 10} do {
	_allUnits = (position _currentTarget) nearEntities [["Man", "Car", "Tank"], 500];
	{
		if (side _x == EAST && alive _x) then {
			_eastUnits = _eastUnits + 1;
		}
	} count _allUnits;
	sleep 15;
};

_sound = ["sectorCaptured_2", "sectorCaptured_1", "sectorCaptured_0"] call BIS_fnc_selectRandom;
playSound _sound;
[CROSSROADS, format ["OPFOR are retreating from %1. Nice job men!", currentTargetName]] call EVO_fnc_globalSideChat;
[[[], {
	if (!isServer || !isMultiplayer) then {
		attackTask setTaskState "Succeeded";
		_tskName = format ["%1 Cleared", currentTarget];
		["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
deleteMarker currentTargetMarkerName;
sleep 30;
targetCounter = targetCounter + 1;
currentTarget = targetLocations select targetCounter;
currentTargetName = text currentTarget;
RTonline = true;
publicVariable "RTonline";
handle = [] spawn EVO_fnc_initTarget;


