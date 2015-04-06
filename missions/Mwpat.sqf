_user = _this select 0;
_usergroup = (group _user);
placetag = "WPAT";

if (_user != leader _usergroup) exitwith {hint localize "EVO_000"};
//if (local _user and onmission) exitwith {hint localize "EVO_001"};
if (local _user) then {sobj1=false;sobj2=false};

mgroupa = grpNull;
//publicVariable "mgroupa";



EVO_deletemwpat =
{
	deleteMarkerLocal _search;
	deleteVehicle _trgobj1;
	deleteVehicle _trgobj2;
	deleteWaypoint [group player, 1];
	_handle = [_guard] execVM "scripts\delete.sqf";
	hint "mission failed";
	onmission=false;
};


deleteWaypoint [group player, 1];
_wp1 = group player addWaypoint [position mresc, 0];
[group player, 1] showWaypoint "NEVER";
[_usergroup, 1] setWaypointType "LEADER";
[_usergroup, 1] setWaypointPosition [position player, 0];
[_usergroup, 1] setWaypointDescription "BRIEFING";
[_usergroup, 1] setWaypointStatements ["true", "{[_x,""EVO_031""] execVM ""missions\brief.sqf""} forEach (units group this)"];
//sleep 1.0;
_usergroup setCurrentWaypoint [_usergroup, 1];

[1800] execVM "missions\timer.sqf";
_trgobj1 = createTrigger ["EmptyDetector", position player ];
_trgobj1 setTriggerText "WPAT Mission Brief";
_trgobj1 setTriggerActivation ["ALPHA", "PRESENT", true];
_trgobj1 setTriggerStatements ["this", "hint localize ""EVO_031""",""];

_trgobj2 = createTrigger ["EmptyDetector", position player ];
_trgobj2 setTriggerText "Abandon Mission";
_trgobj2 setTriggerActivation ["CHARLIE", "PRESENT", true];
_trgobj2 setTriggerStatements ["this", "if (score player > 1) then {player addscore -2};onmission=false;hint localize ""EVO_049""",""];

if (local server) then
{
	_guard = createGroup (east);

	_recy = [_user,_guard] execVM "scripts\grecycle.sqf";
	_randy = 11283+(random 1020);
	_randx = 6616+(random 4360);

	_randya = 11283+(random 1020);
	_randxa = 6616+(random 4360);

	_randyb = 11283+(random 1020);
	_randxb = 6616+(random 4360);

	_pos1 = [_randx,_randy,0];
	_pos2 = [_randxa,_randya,0];
	_pos3 = [_randxb,_randyb,0];

	_starts = [_pos1,_pos2,_pos3];
	_pos = (_starts select (round random 2));


	_heli = createVehicle ["RHIB2Turret", _pos1, [], 100, "NONE"];[_heli] call EVO_Lock;
	_heli1 = createVehicle ["RHIB2Turret", _pos2, [], 100, "NONE"];[_heli1] call EVO_Lock;
	_heli2 = createVehicle ["RHIB2Turret", _pos3, [], 100, "NONE"];[_heli2] call EVO_Lock;

	_heli addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli1 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	//sleep 1.0;


	"SoldierEB" createUnit [_pos, _guard];
	"SoldierEB" createUnit [_pos, _guard];
	"SoldierEB" createUnit [_pos2, _guard];
	"SoldierEB" createUnit [_pos2, _guard];
	"SoldierEB" createUnit [_pos3, _guard];
	"SoldierEB" createUnit [_pos3, _guard];


	//sleep 1.0;
	(units _guard select 1) assignAsDriver _heli;
	(units _guard select 1) moveInDriver _heli;
	(units _guard select 0) assignAsGunner _heli;
	(units _guard select 0) moveInGunner _heli;

	(units _guard select 2) assignAsDriver _heli1;
	(units _guard select 2) moveInDriver _heli1;
	(units _guard select 3) assignAsGunner _heli1;
	(units _guard select 3) moveInGunner _heli1;

	(units _guard select 4) assignAsDriver _heli2;
	(units _guard select 4) moveInDriver _heli2;
	(units _guard select 5) assignAsGunner _heli2;
	(units _guard select 5) moveInGunner _heli2;


	/*
	player setcaptive true;
	[player] join _guard;
	player assignascargo _heli2;
	player moveincargo _heli2;
	*/
	_guard setCombatMode "RED";
	_guard setBehaviour "COMBAT";

	{_x addRating -2000;
	_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]
	} forEach (units _guard);

	//sleep 1.0;

	_wp1 = _guard addWaypoint [_pos1, 10];
	_wp2 = _guard addWaypoint [_pos2, 10];
	_wp3 = _guard addWaypoint [_pos3, 10];
	_wp4 = _guard addWaypoint [_pos1, 10];
	[_guard, 4] setWaypointType "CYCLE";
	sleep 1.0;
	mgroupa = _guard;
	publicVariable "mgroupa";
	//_debug = [] execVM format["mgroupa %1 _pos1 %2",mgroupa,_pos1];
};

if ((local server) and not(local _user)) exitWith {};
waitUntil {(not (isNull mgroupa)) or not onmission};
if (not onmission) exitwith {[] call EVO_deletemwpat};
sleep 1.0;

_guard = mgroupa;

_pos1 = position vehicle (units _guard select 0);
_pos2 = position vehicle (units _guard select 2);
_pos3 = position vehicle (units _guard select 4);

_starts = [_pos1,_pos2,_pos3];

//hint format["%1",_starts];

[_usergroup, 1] setWaypointPosition [_pos1, 0];
[_usergroup, 1] setWaypointStatements ["true","sobj1 = true"];
[_usergroup, 1] setWaypointDescription localize "EVO_041";
_usergroup setCurrentWaypoint [_usergroup, 1];

_search = createMarkerLocal ["look", _pos1];
_search setMarkerTypeLocal "mil_destroy";
_search setMarkerTextLocal localize "EVO_041";
_search setMarkerColorLocal "ColorYellow";
_search setMarkerSizeLocal [0.5, 0.5];

//map

_mapview = [GetMarkerPos _search,0] execVM "scripts\mismap.sqf";


_i=0;
while {_i < count _starts} do
{
	_npos = (_starts select _i);
	[_usergroup, 1] setWaypointPosition [_npos, 0];
	_search setMarkerPosLocal _npos;
	_usergroup setCurrentWaypoint [_usergroup, 1];

	Waituntil {sobj1 or ((count units _guard) == 0) or _usergroup != (group player) or not onmission}; //or if pilots dead

	sobj1 = false;
	_i = _i + 1;
	if (_usergroup != (group player)) then {_i=100};
	if (not onmission) then {_i=100};
	if ((count units _guard) == 0) then {_i=100};
	if (_i == 3 and (count units _guard)  > 0) then {_i=0};
};

if (_usergroup != (group player)) exitwith {[] call EVO_deletemwpat};
if (not onmission) exitwith {[] call EVO_deletemwpat};

{if(isPlayer _x) then {_x doFollow leader _x}} foreach units (group player);
sleep 1.0;

[_usergroup, 1] setWaypointStatements ["true", "{[_x,10] execVM ""missions\reward.sqf""} forEach (units group this)"];
[_usergroup, 1] setWaypointPosition [position player, 0];
_usergroup setCurrentWaypoint [_usergroup, 1];


sleep 2.0;
deleteMarkerLocal _search;
deleteVehicle _trgobj1;
deleteVehicle _trgobj2;
deleteWaypoint [group player, 1];
deleteWaypoint [group player, 2];
deleteWaypoint [group player, 3];
deleteWaypoint [group player, 4];
onmission=false;