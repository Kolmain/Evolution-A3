private ["_caller","_pos","_is3D","_ID","_grpSide","_grp","_ugvArray","_ugv","_pos2","_spawnPos","_retArray","_retArray2","_vehicle","_crew","_heli","_heliCrew","_heliGrp","_heliDriver","_dis","_newQrf","_pos","_distanceToLz","_shortestDistance"];

_caller = _this select 0;
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
if (_grpSide == independent) then {_grpSide = RESISTANCE;};
_grp = group _caller;
_score = _caller getVariable "EVO_score";
_score = _score - 10;
_caller setVariable ["EVO_score", _score, true];
[_caller, -10] call bis_fnc_addScore;
["PointsRemoved",["UGV request canceled.", 10]] call BIS_fnc_showNotification;
if ("B_UavTerminal" in (assignedItems _caller)) exitWith {
	[_caller, format["Crossroads, this is %1, requesting UGV support, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[_caller, format["%1, this is Crossroads, you're not deployed with a UAV terminal, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
	_newUGVrequest = [_caller, "ugvRequest"] call BIS_fnc_addCommMenuItem;
	_score = _caller getVariable "EVO_score";
	_score = _score + 10;
	_caller setVariable ["EVO_score", _score, true];
	[_caller, 10] call bis_fnc_addScore;
	["PointsAdded",["UGV request canceled.", 10]] call BIS_fnc_showNotification;
};
_spawnPos = [(getMarkerPos "arespawn_west"), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
_pos2 = getMarkerPos "arespawn_west";
_retArray = [_spawnPos, 0, "B_UGV_01_rcws_F", WEST] call EVO_fnc_spawnvehicle;
_spawnPos = [(getMarkerPos "arespawn_west"), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
_retArray2 = [_spawnPos, 180, "B_Heli_Transport_03_F", WEST] call EVO_fnc_spawnvehicle;
_vehicle = _retArray select 0;
//_crew = _retArray select 1;
_grp = _retArray select 2;
_heli = _retArray2 select 0;
_heliCrew = _retArray2 select 1;
_heliGrp = _retArray2 select 2;
_heliDriver = driver _heli;

[_caller, format["%2, this is %1, requesting a UGV, over.", groupID (group _caller), groupID _grp]] call EVO_fnc_globalSideChat;
sleep 3;
[(leader _grp), format["%1, this is %2, copy your last. Send landing grid, over.", groupID (group _caller), groupID _grp]] call EVO_fnc_globalSideChat;
sleep 3;
[_caller, format["Grid %1, over.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
sleep 3;
[(leader _grp), format["Copy that %1, dispatching to requested coordinates, out.", groupID (group _caller), groupID _grp]] call EVO_fnc_globalSideChat;
sleep 3;

_heli setSlingLoad _vehicle;

_heliDriver disableAI "FSM";
_heliDriver disableAI "TARGET";
_heliDriver disableAI "AUTOTARGET";
_heliGrp setBehaviour "AWARE";
_heliGrp setCombatMode "RED";
_heliGrp setSpeedMode "NORMAL";
_heliDriver doMove _pos;
_heli flyInHeight 50;
_heli lock 3;
_heli allowDamage false;
_vehicle allowDamage false;
waitUntil {([_heli, _pos] call BIS_fnc_distance2D < 150)};
_heli flyInHeight 0;
_heli land "LAND";
waitUntil {(isTouchingGround _vehicle)};
{
	ropeCut [ _x, 5];
} forEach ropes _heli;
_heli allowDamage true;
_vehicle allowDamage true;
_caller connectTerminalToUAV _vehicle;
[(leader _grp), format["Be advised, UGV %1 is in the AO, out.", groupID _grp]] call EVO_fnc_globalSideChat;
_heli land "NONE";
_heliDriver doMove _spawnPos;
_heli flyInHeight 50;
waitUntil {([_heli, _pos] call BIS_fnc_distance2D < 200)};
{
	deleteVehicle _x;
} forEach _heliCrew;
deleteVehicle _heli;
deleteGroup _heliGrp;



