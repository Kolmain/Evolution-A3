private ["_caller","_pos","_is3D","_ID","_grpSide","_grp","_score","_newUaVrequest","_spawnPos","_retArray","_uav","_vehicle"];

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
["PointsRemoved",["UAV request initiated.", 10]] call BIS_fnc_showNotification;
if ("B_UavTerminal" in (assignedItems _caller)) exitWith {
	[_caller, format["Crossroads, this is %1, requesting UAV support, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[Crossroads, format["%1, this is Crossroads, you're not deployed with a UAV terminal, RTB and pick it up at the staging base, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
	_newUaVrequest = [_caller, "uavRequest"] call BIS_fnc_addCommMenuItem;
	_score = _caller getVariable "EVO_score";
	_score = _score + 10;
	_caller setVariable ["EVO_score", _score, true];
	[_caller, 10] call bis_fnc_addScore;
	["PointsAdded",["UAV request canceled.", 10]] call BIS_fnc_showNotification;
};
_spawnPos = [(getMarkerPos "arespawn_west"), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
_retArray = [_spawnPos, 0, "B_UAV_02_CAS_F", WEST] call EVO_fnc_spawnvehicle;
_uav = _retArray select 0;
[_caller, format["Crossroads, this is %1, requesting a UAV, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
sleep 3;
[Crossroads, format["%1, this is Crossroads, copy your last. Send arrival grid, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
sleep 3;
["supportMapClickEH", "onMapSingleClick", {
		supportMapClick = _pos;
		["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}] call BIS_fnc_addStackedEventHandler;
	openMap true;
	hint "Designate coordinates by left-clicking on the map.";
	waitUntil {supportMapClick != [0,0,0] || !(visiblemap)};
	_pos = supportMapClick;
	if (!visiblemap) exitWith {
		[_caller, format["Crossroads, this is %1, scratch that last request, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
		sleep 3.5;
		[Crossroads, format["Copy that %1, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
		sleep 3.5;
		_newUaVrequest = [_caller, "uavRequest"] call BIS_fnc_addCommMenuItem;
	_score = _caller getVariable "EVO_score";
	_score = _score + 10;
	_caller setVariable ["EVO_score", _score, true];
	[_caller, 10] call bis_fnc_addScore;
	["PointsAdded",["UAV request canceled.", 10]] call BIS_fnc_showNotification;
	};
	openMap false;
[_caller, format["Grid %1, over.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
sleep 3;
[Crossroads, format["Copy that %1, dispatching to requested coordinates, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
sleep 3;
supportMapClick = [0,0,0];
waitUntil {([_uav, _pos] call BIS_fnc_distance2D < 250)};
_caller connectTerminalToUAV _vehicle;
supportMapClick = [0,0,0];


