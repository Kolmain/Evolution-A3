private ["_currentTarget","_grp","_null","_ret","_tank","_eastUnits","_allUnits"];

_currentTarget = currentTarget;
currentTarget setMarkerAlpha 1;
"opforair" setMarkerPos (getMarkerPos currentTarget);
currentTargetRT addEventHandler ["Killed", {_this call EVO_fnc_RToffline}];




_grp = [getPos currentTargetRT, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
_null = [(leader _grp), currentTarget, "Fortify", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";

_grp = [getPos currentTargetOF, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
_null = [(leader _grp), currentTarget, "Fortify", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";

for "_i" from 1 to paraSquads do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { _currentTarget == currentTarget } do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad_Weapons")] call BIS_fnc_spawnGroup;
		    _spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _ret = [_spawnPos, (floor (random 360)), "O_Heli_Light_02_unarmed_F", EAST] call bis_fnc_spawnvehicle;
		    _heli = _ret select 0;
		    _heliGrp = _ret select 2;
		    {
		    	_x assignAsCargo _heli;
		    	_x moveInCargo _heli;
		    } forEach units _grp;
		    _heli doMove (getMarkerPos currentTarget);
		    _heli flyInHeight 150;
		    waitUntil {(_heli distance (getMarkerPos currentTarget)) < 500};
		    handle = [_heli] call EVO_fnc_paradrop;
		    _heli doMove (getPos server);
		    handle = [_heli] spawn {
		    	_heli = _this select 0;
		    	waitUntil {(_heli distance server) < 1000};
		    	{
		    		deleteVehicle _x;
		    	} forEach units group driver _heli;
		    	deleteVehicle _heli;
			};
			_null = [(leader _grp), currentTarget, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			waitUntil {({alive _x} count units _grp) < 3};
			sleep 300;
		};
	};

};

for "_i" from 1 to infSquads do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { RTonline && _currentTarget == currentTarget } do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
			_null = [(leader _grp), currentTarget, "RANDOM", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			waitUntil {({alive _x} count units _grp) < 3};
		};
	};

};

for "_i" from 1 to mechSquads do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { RTonline && _currentTarget == currentTarget } do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Mechanized" >> "OIA_MechInfSquad")] call BIS_fnc_spawnGroup;
			_null = [(leader _grp), currentTarget, "RANDOM", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			waitUntil {({alive _x} count units _grp) < 3};
		};
	};

};

for "_i" from 1 to armorSquads do {
	_null = [_currentTarget] spawn {
		_currentTarget = _this select 0;
		while { RTonline && _currentTarget == currentTarget } do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _ret = [_spawnPos, (floor (random 360)), "O_MBT_02_cannon_F", EAST] call bis_fnc_spawnvehicle;
		    _tank = _ret select 0;
		    _grp = _ret select 2;
			_null = [(leader _grp), currentTarget, "RANDOM", "ONROAD", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			waitUntil {(({alive _x} count units _grp) == 0) || !alive _tank || !canMove _tank};
		};
	};

};

[CROSSROADS, format ["We've received our next target, all forces converge on %1!", currentTarget]] call EVO_fnc_globalSideChat;
_tskName = format ["Clear %1", currentTarget];
attackTask = player createSimpleTask [_tskName];
attackTask setTaskState "Created";
attackTask setSimpleTaskDestination (getMarkerPos currentTarget);
_tskName = format ["Destroy Radio Tower"];
towerTask = player createSimpleTask [_tskName, attackTask];
towerTask setTaskState "Assigned";
_tskName = format ["Secure Col. %1", name currentTargetOF];
officerTask = player createSimpleTask [_tskName, attackTask];
officerTask setTaskState "Created";
_tskName = format ["Clear the city of %1.", currentTarget];
["TaskAssigned",["",_tskName]] call BIS_fnc_showNotification;

waitUntil {!RTonline};
towerTask setTaskState "Succeeded";
_tskName = format ["Radio Tower Destroyed"];
["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
sleep 5;
[CROSSROADS, format ["We've received confirmation that the OPFOR communications tower has been destroyed, %1 will no longer be reinforced by OPFOR.", currentTarget]] call EVO_fnc_globalSideChat;
_eastUnits = 100;
while {_eastUnits > 10} do {
	_allUnits = (getMarkerPos _currentTarget) nearEntities [["Man", "Car", "Tank"], 1000];
	{
		if (side _x == EAST) then {
			_eastUnits = _eastUnits + 1;
		}
	} count _allUnits;
	sleep 15;
};
[CROSSROADS, format ["OPFOR are retreating from %1. Nice job men!", currentTarget]] call EVO_fnc_globalSideChat;
attackTask setTaskState "Succeeded";
_tskName = format ["%1 Cleared", currentTarget];
["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
sleep 30;
currentTarget = activetargets select 0;
activetargets = activetargets - [currentTarget];
publicVariable "activetargets";
currentTargetRT = currentTargetRT select 0;
publicVariable "currentTargetRT";
activetargetsRT = activetargetsRT - [currentTargetRT];
publicVariable "currentTargetOF";
currentTargetOF = activetargetsOF select 0;
publicVariable "currentTargetOF";
activetargetsOF = currentTargetOF - [currentTargetOF];
publicVariable "activetargetsOF";
RTonline = true;
publicVariable "RTonline";
handle = [] spawn EVO_fnc_initTarget;


