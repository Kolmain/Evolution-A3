private ["_currentTarget","_targetType","_currentTargetMarker","_aoSize","_x1","_y1","_towerClass","_center","_spawnPos","_max_distance","_dir","_comp","_grp","_mortarGunner","_loop2","_obj","_newComp","_mortar","_officer","_pos","_pass","_msg","_null","_ret","_heli","_heliGrp","_class","_tank","_sound","_tskName","_locationType","_type","_nearUnits","_unit","_score"];


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

handle = [currentTarget, _mortarGunner] spawn {
	_currentTarget = _this select 0;
	_mortarGunner = _this select 1;
	_loop2 = true;
	while {_loop2} do {
	    sleep 5;
	    if (currentTarget != _currentTarget) then {
	    	_loop2 = false;
	    };
	    if (!alive _mortarGunner) exitWith {};
	};
		[_mortarGunner, currentTarget] call EVO_fnc_wrapUp;
};

_newComp = [_spawnPos, _dir, _comp, false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
handle = [currentTarget, _newComp] spawn {
	_currentTarget = _this select 0;
	_newComp = _this select 1;
	_loop2 = true;
	while {_loop2} do {
	    sleep 5;
	    if (currentTarget != _currentTarget) then {
	    	_loop2 = false;
	    };
	};
	{
		[_x, currentTarget] call EVO_fnc_wrapUp;
	} forEach _newComp;
};

_mortar = nearestObject [_spawnPos, "O_Mortar_01_F"];
_mortarGunner assignAsGunner _mortar;
_mortarGunner moveInGunner _mortar;


nul = [_mortar] execVM "scripts\UPSMON\MON_artillery_add.sqf";
_grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;

handle = [currentTarget, _grp] spawn {
	_currentTarget = _this select 0;
	_grp = _this select 1;
	_loop2 = true;
	while {_loop2} do {
	    sleep 5;
	    if (currentTarget != _currentTarget) then {
	    	_loop2 = false;
	    };
	};
	{
		[_x, currentTarget] call EVO_fnc_wrapUp;
	} forEach units _grp;
};

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
[[[], {	currentTargetOF addAction [format["Capture Colonel %1", name currentTargetOF],"_this spawn EVO_fnc_officer",nil,1,false,true,"","alive currentTargetOF"]}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
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
		    //_heli doMove (getMarkerPos currentTargetMarkerName);
		    _wp = _heliGrp addWaypoint [getMarkerPos currentTargetMarkerName, 0];
		    _heli flyInHeight 150;
		    waitUntil {(_heli distance (getMarkerPos currentTargetMarkerName)) < 500};
		    handle = [_heli] call EVO_fnc_paradrop;
		    sleep 5;
		    //_heli doMove (getPos server);
		    _wp = _heliGrp addWaypoint [getPos server, 0];
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

sleep 1;

[CROSSROADS, format ["We've received our next target, all forces converge on %1!", currentTargetName]] call EVO_fnc_globalSideChat;


[[[], {
	if (!isDedicated) then {
		_sound = ["opforCaptured_2", "opforCaptured_1", "opforCaptured_0"] call BIS_fnc_selectRandom;
		playSound _sound;
		waitUntil {!intro};
		[] call EVO_fnc_newTargetTasks;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

waitUntil {!RTonline};

[[[], {
	if (!isServer || !isMultiplayer) then {
		towerTask setTaskState "Succeeded";
		_tskName = format ["Radio Tower Destroyed at %1", currentTargetName];
		["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

sleep (random 15);
[CROSSROADS, format ["We've received confirmation that the OPFOR communications tower has been destroyed, %1 will no longer be reinforced by OPFOR.", currentTargetName]] call EVO_fnc_globalSideChat;
_sound = ["capturing_2", "capturing_1", "capturing_0"] call BIS_fnc_selectRandom;
playSound _sound;


currentTargetLeft = 100;
while {currentTargetLeft > 9} do {
	_nearUnits = nearestObjects [getMarkerPos currentTargetMarkerName, ["Car","Tank","Man"], 500];
	currentTargetLeft = 0;
	{
		_unit = _x;
		if (_unit isKindOf "Man" && side _unit == EAST) then {
			if (alive _unit) then {
				currentTargetLeft = currentTargetLeft + 1
			};
		} else {
			if(canMove _unit && side _unit == EAST) then {
				currentTargetLeft = currentTargetLeft + 1
			};
		};
	} foreach _nearUnits;
	publicVariable "currentTargetLeft";
	sleep 10;
};

_sound = ["sectorCaptured_2", "sectorCaptured_1", "sectorCaptured_0"] call BIS_fnc_selectRandom;
playSound _sound;
[CROSSROADS, format ["OPFOR are retreating from %1. Nice job men!", currentTargetName]] call EVO_fnc_globalSideChat;
[[[], {
	if (!isServer || !isMultiplayer) then {
		attackTask setTaskState "Succeeded";
		_tskName = format ["%1 Secured.", currentTargetName];
		_score = player getVariable "EVO_score";
			_score = _score + 5;
			player setVariable ["EVO_score", _score, true];
			["PointsAdded",["BLUFOR completed a mission objective.", 5]] call BIS_fnc_showNotification;
		["TaskSucceeded",["",_tskName]] call BIS_fnc_showNotification;
		playsound "goodjob";
		if (taskState officerTask != "Succeeded" || taskState officerTask != "Failed") then {
			officerTask setTaskState "Failed";
			_tskName = format ["Colonel %1 Escaped.", name currentTargetOF];
			["TaskFailed",["",_tskName]] call BIS_fnc_showNotification;
		};
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
deleteMarker currentTargetMarkerName;
sleep random 30;
deleteVehicle currentTargetOF;
targetCounter = targetCounter + 1;
currentTarget = targetLocations select targetCounter;
currentTargetName = text currentTarget;
RTonline = true;
publicVariable "RTonline";
handle = [] spawn EVO_fnc_initTarget;


