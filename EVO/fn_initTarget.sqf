private ["_currentTarget","_targetType","_currentTargetMarker","_aoSize","_x1","_y1","_towerClass","_center","_spawnPos","_max_distance","_dir","_comp","_grp","_mortarGunner","_loop2","_obj","_newComp","_mortar","_officer","_pos","_pass","_msg","_null","_ret","_heli","_heliGrp","_class","_tank","_sound","_tskName","_locationType","_type","_nearUnits","_unit","_score"];

currentTargetRT = nil;
currentTargetOF = nil;
if (isNil "currentAOunits") then {
	currentAOunits = [];
	publicVariable "currentAOunits";
};
lastAOunits = currentAOunits;
publicVariable "lastAOunits";
currentAOunits = [];
publicVariable "currentAOunits";
RTonline = true;
officerAlive = true;
currentTargetName = text currentTarget;
publicVariable "currentTargetName";
_currentTarget = currentTarget;
currentTargetType = type currentTarget;
publicVariable "currentTargetType";
currentTargetMarkerName = format ["%1_ao", currentTargetName];
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

_towerClass = "Land_Communication_F";
//_towerClass = ["Land_Communication_F", "Land_TTowerBig_2_F", "Land_TTowerBig_1_F"] call BIS_fnc_selectRandom;
/*
_center = [ getMarkerPos currentTargetMarkerName, random 80 , random 360 ] call BIS_fnc_relPos;
_spawnPos = [];
_max_distance = 100;
while{ count _spawnPos < 1 } do
{
	_spawnPos = _center findEmptyPosition[ 30 , _max_distance , _towerClass ];
	_max_distance = _max_distance + 50;
};
*/
_spawnPos = [position currentTarget , 50, 300, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
currentTargetRT = _towerClass createVehicle _spawnPos;
publicVariable "currentTargetRT";
handle = [currentTargetRT] spawn EVO_fnc_demoOnly;
currentTargetRT addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
currentTargetRT addEventHandler ["Killed", {_this call EVO_fnc_RToffline}];
RTonline = true;
publicVariable "RTonline";


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


{
			if (HCconnected) then {
				handle = [_x] call EVO_fnc_sendToHC;
			};
			currentAOunits pushBack _x;
			publicVariable "currentAOunits";
			_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
			_x AddMPEventHandler ["mpkilled", {currentAOunits = currentAOunits - [_this select 1]}];
		} forEach units _grp;
[_grp, _spawnPos] call bis_fnc_taskDefend;



/*
_center = [ getMarkerPos currentTargetMarkerName, random 150 , random 360 ] call BIS_fnc_relPos;
_spawnPos = [];
_max_distance = 100;
while{ count _spawnPos < 1 } do
{
	_spawnPos = _center findEmptyPosition[ 30 , _max_distance , _towerClass ];
	_max_distance = _max_distance + 50;
};
*/
_spawnPos = [position currentTarget , 50, 300, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
_grp = createGroup east;
currentTargetOF = _grp createUnit ["O_officer_F", _spawnPos, [], 0, "FORM"];
publicVariable "currentTargetOF";
currentTargetOF addEventHandler ["Killed", {officerAlive = false; publicVariable "officerAlive";}];
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
doStop _officer;

handle = [currentTargetOF, currentTarget] spawn {
	_OF = _this select 0;
	_currentTarget = _this select 1;
	_loop = true;
	while {_loop} do {
		if (_currentTarget != currentTarget) exitWith {_loop = false};
		if (!alive _OF) then {
	    		[officerTask, "Failed", false] call bis_fnc_taskSetState;
	    		[[[_OF], {
	    			_msg = format ["Colonel %1 has been killed.", name (_this select 0)];
				["TaskFailed",["OFFICER KIA", _msg]] call BIS_fnc_showNotification;
	    		}], "BIS_fnc_spawn", true] call BIS_fnc_MP;


			_loop = false;
		};
		sleep 10;
	};
};


_grp = [getPos currentTargetRT, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
{
			if (HCconnected) then {
				handle = [_x] call EVO_fnc_sendToHC;
			};
			currentAOunits pushBack _x;
			publicVariable "currentAOunits";
			_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
			_x AddMPEventHandler ["mpkilled", {currentAOunits = currentAOunits - [_this select 1]}];
		} forEach units _grp;

[_grp, getPos currentTargetRT] call bis_fnc_taskDefend;

_grp = [getPos currentTargetOF, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
{
			if (HCconnected) then {
				handle = [_x] call EVO_fnc_sendToHC;
			};
			currentAOunits pushBack _x;
			publicVariable "currentAOunits";
			_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
			_x AddMPEventHandler ["mpkilled", {currentAOunits = currentAOunits - [_this select 1]}];
		} forEach units _grp;

[_grp, getPos currentTargetOF] call bis_fnc_taskDefend;

for "_i" from 1 to infSquads do {
	_null = [_currentTarget] spawn {
			_grp = [_this select 0, "infantry"] call EVO_fnc_sendToAO;
			waitUntil {({alive _x} count units _grp) < 5};
	};
};

for "_i" from 1 to armorSquads do {
	_null = [_currentTarget] spawn {
			_grp = [_this select 0, "armor"] call EVO_fnc_sendToAO;
			_tank = vehicle leader _grp;
			waitUntil {({alive _x} count units _grp) < 1 || !canMove _tank || !alive _tank};
	};
};

sleep 1;

[CROSSROADS, format ["We've received our next target, all forces converge on %1!", currentTargetName]] call EVO_fnc_globalSideChat;
[[[], {
	if (!isDedicated) then {
		_sound = ["opforCaptured_2", "opforCaptured_1", "opforCaptured_0"] call BIS_fnc_selectRandom;
		playSound _sound;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

[] call EVO_fnc_newTargetTasks;



waitUntil {!RTonline};

[[[], {
	if (!isDedicated) then {
		_tskName = format ["Radio Tower Destroyed at %1", currentTargetName];
		["Succeeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
[towerTask, "Succeeded", false] call bis_fnc_taskSetState;
sleep (random 15);
[CROSSROADS, format ["We've received confirmation that the OPFOR communications tower has been destroyed, %1 will no longer be reinforced by OPFOR.", currentTargetName]] call EVO_fnc_globalSideChat;
_sound = ["capturing_2", "capturing_1", "capturing_0"] call BIS_fnc_selectRandom;
playSound _sound;


while {count currentAOunits > 9} do {
	sleep 10;
};

_sound = ["sectorCaptured_2", "sectorCaptured_1", "sectorCaptured_0"] call BIS_fnc_selectRandom;
playSound _sound;
[CROSSROADS, format ["OPFOR are retreating from %1. Nice job men!", currentTargetName]] call EVO_fnc_globalSideChat;
[attackTask, "Succeeded", false] call bis_fnc_taskSetState;


if ([officerTask] call bis_fnc_taskState != "Succeeded" || [officerTask] call bis_fnc_taskState != "Failed") then {
	[officerTask, "Failed", false] call bis_fnc_taskSetState;
	_tskName = format ["Colonel %1 Escaped.", name currentTargetOF];
	["TaskFailed",["",_tskName]] call BIS_fnc_showNotification;
};
[[[], {
	if (!isServer || !isMultiplayer) then {
		_tskName = format ["%1 Secured.", currentTargetName];
		_score = player getVariable "EVO_score";
		_score = _score + 5;
		player setVariable ["EVO_score", _score, true];
		["PointsAdded",["BLUFOR completed a mission objective.", 5]] call BIS_fnc_showNotification;
		["Succeeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
deleteMarker currentTargetMarkerName;
sleep random 30;
deleteVehicle currentTargetOF;
targetCounter = targetCounter + 1;
publicVariable "targetCounter";
currentTarget = targetLocations select targetCounter;
publicVariable "currentTarget";
currentTargetName = text currentTarget;
publicVariable "currentTargetName";
RTonline = true;
publicVariable "RTonline";
handle = [] spawn EVO_fnc_initTarget;


