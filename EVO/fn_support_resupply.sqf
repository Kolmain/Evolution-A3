private ["_caller","_pos","_is3D","_ID","_grpSide","_grp","_score","_spawnPos","_pos2","_vehicle","_retArray2","_heli","_heliCrew","_heliGrp","_heliDriver","_newResupply","_chute"];

_caller = _this select 0;
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
_grp = group _caller;
_score = _caller getVariable "EVO_score";
_score = _score - 5;
_caller setVariable ["EVO_score", _score, true];
[_caller, -5] call bis_fnc_addScore;
["PointsRemoved",["Resupply request canceled.", 5]] call BIS_fnc_showNotification;

_spawnPos = [(getMarkerPos "arespawn_west"), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
_pos2 = getMarkerPos "arespawn_west";
_vehicle = createVehicle ["CargoNet_01_box_F", _spawnPos, [], 0, "NONE"]
_spawnPos = [(getMarkerPos "arespawn_west"), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
_retArray2 = [_spawnPos, 180, "B_Heli_Transport_03_F", WEST] call EVO_fnc_spawnvehicle;
_heli = _retArray2 select 0;
_heliCrew = _retArray2 select 1;
_heliGrp = _retArray2 select 2;
_heliDriver = driver _heli;

[_caller, format["%2, this is %1, requesting a supply drop, over.", groupID (group _caller), groupID _heliGrp]] call EVO_fnc_globalSideChat;
sleep 3;
[(leader _heliGrp), format["%1, this is %2, copy your last. Send target grid, over.", groupID (group _caller), groupID _heliGrp]] call EVO_fnc_globalSideChat;
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
		[_caller, format["%1, this is %2, scratch that last request, out.", groupID (group _heliGrp), groupID (group _caller)]] call EVO_fnc_globalSideChat;
		sleep 3.5;
		[_heliGrp, format["Copy that %2, out.", groupID (group _heliGrp), groupID (group _caller)]] call EVO_fnc_globalSideChat;
		sleep 3.5;
		_newResupply = [_caller, "resupply"] call BIS_fnc_addCommMenuItem;
		_score = player getVariable ["EVO_score", 0];
		_score = _score + 5;
		player setVariable ["EVO_score", _score, true];
		[player, 5] call bis_fnc_addScore;
		["PointsAdded",["Ammo drop canceled.", 5]] call BIS_fnc_showNotification;
	};
	openMap false;
[_caller, format["Grid %1, over.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
sleep 3;
[(leader _heliGrp), format["Copy that %1, dispatching to requested coordinates, out.", groupID (group _caller), groupID _heliGrp]] call EVO_fnc_globalSideChat;
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
supportMapClick = [0,0,0];
waitUntil {([_heli, _pos] call BIS_fnc_distance2D < 10)};
{
	ropeCut [ _x, 5];
} forEach ropes _heli;
_chute = createVehicle ["B_Parachute_02_F", [100, 100, 200], [], 0, 'FLY'];
_chute setPos [position _heli select 0, position _heli select 1, (position _heli select 2) - 50];
_vehicle attachTo [_chute, [0, 0, -1.3]];
_heli allowDamage true;
_vehicle allowDamage true;
[(leader _grp), format["Be advised, supply drop complete, out."]] call EVO_fnc_globalSideChat;
_heliDriver doMove _spawnPos;

waitUntil {position _vehicle select 2 < 0.5 || isNull _chute};
detach _vehicle;
_vehicle setPos [position _vehicle select 0, position _vehicle select 1, 0];
[[_vehicle, _caller getVariable ["EVO_rank", "PRIVATE"]],{
	if (!isDedicated) then {
		[(_this select 0), _this select 1] call EVO_fnc_buildAmmoCrate;
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
_heli flyInHeight 50;
waitUntil {([_heli, _pos] call BIS_fnc_distance2D < 200)};
{
	deleteVehicle _x;
} forEach _heliCrew;
deleteVehicle _heli;
deleteGroup _heliGrp;



