private ["_caller","_pos","_is3D","_ID","_grpSide","_grp","_score","_newUaVrequest","_spawnPos","_retArray","_uav","_vehicle"];

_caller = _this select 0;
_caller playMoveNow "Acts_listeningToRadio_Loop";
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
_uav = uav_west;
_busy = _uav getVariable ["EVO_support_busy", false];
if (_busy) exitWith {
	[_caller, format["Crossroads, this is %1, requesting UAV support, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[Crossroads, format["%1, this is Crossroads, UAV is unavailable, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
};
_grp = group _caller;
[_caller, -10] call bis_fnc_addScore;
["PointsRemoved",["UAV request initiated.", 10]] call BIS_fnc_showNotification;
if (!("B_UavTerminal" in (assignedItems _caller))) exitWith {
	[_caller, format["Crossroads, this is %1, requesting UAV support, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[Crossroads, format["%1, this is Crossroads, you're not deployed with a UAV terminal, RTB and pick it up at the staging base, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
	_newUaVrequest = [_caller, "uavRequest"] call BIS_fnc_addCommMenuItem;
	[_caller, 10] call bis_fnc_addScore;
	["PointsAdded",["UAV request canceled.", 10]] call BIS_fnc_showNotification;
};
_uav setVariable ["EVO_support_busy", true, true];
[_caller, format["Crossroads, this is %1, requesting a UAV, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
sleep 3;
[Crossroads, format["%1, this is Crossroads, copy your last. Wait one, over.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
sleep 10;
_caller connectTerminalToUAV _uav;
_uav setFuel 1;
_uav setVehicleAmmo 1;
_uav setDamage 0;
[_caller, _uav] spawn {
	_caller = _this select 0;
	_uav = _this select 1;
	sleep 300;
	_caller connectTerminalToUAV objNull; //disconnect
	_uav setVariable ["EVO_support_busy", false, true];
	[Crossroads, format["%1, this is Crossroads. UAV is needed elsewhere, we're reallocating support, out.", groupID (group _caller)]] call EVO_fnc_globalSideChat;
}


