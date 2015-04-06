_user = _this select 0;
_usergroup = (group _user);
placetag = "LPAT";

if (_user != leader _usergroup) exitwith {hint localize "EVO_000"};
//if (local _user and onmission) exitwith {hint localize "EVO_001"};
if (local _user) then {sobj1=false;sobj2=false};
mgroupa = grpNull;
mgroupb = grpNull;
//publicVariable "mgroupa";
//publicVariable "mgroupb";


EVO_deletemlpat =
{
	deleteMarkerLocal _search;
	deleteVehicle _trgobj1;
	deleteVehicle _trgobj2;
	deleteWaypoint [group player, 1];
	_handle = [_guard] execVM "scripts\delete.sqf";
	_handle = [_guardb] execVM "scripts\delete.sqf";
	hint "mission failed";
	onmission=false;
};

deleteWaypoint [group player, 1];
_wp1 = group player addWaypoint [position mresc, 0];
[group player, 1] showWaypoint "NEVER";
[_usergroup, 1] setWaypointType "LEADER";
[_usergroup, 1] setWaypointPosition [position player, 0];
[_usergroup, 1] setWaypointDescription "BRIEFING";
[_usergroup, 1] setWaypointStatements ["true", "{[_x,""EVO_048""] execVM ""missions\brief.sqf""} forEach (units group this)"];
//sleep 1.0;
_usergroup setCurrentWaypoint [_usergroup, 1];

[1800] execVM "missions\timer.sqf";
_trgobj1 = createTrigger ["EmptyDetector", position player ];
_trgobj1 setTriggerText "LPAT Mission Brief";
_trgobj1 setTriggerActivation ["ALPHA", "PRESENT", true];
_trgobj1 setTriggerStatements ["this", "hint localize ""EVO_031""",""];

_trgobj2 = createTrigger ["EmptyDetector", position player ];
_trgobj2 setTriggerText "Abandon Mission";
_trgobj2 setTriggerActivation ["CHARLIE", "PRESENT", true];
_trgobj2 setTriggerStatements ["this", "if (score player > 1) then {player addscore -2};onmission=false;hint localize ""EVO_049""",""];

if (local server) then
{
	_guard = createGroup (east);
	_guardb = createGroup (east);
	_pos = position swpoint;
	_allvecA = ["UAZ_AGS30","UAZMG","BRDM2","BMP2"];
	_maxA = count _allvecA;

	_heli = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 1000, "NONE"];[_heli] call EVO_Lock;
	_pos1 = position _heli;
	_heli1 = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 1000, "NONE"];[_heli1] call EVO_Lock;
	_pos2 = position _heli1;
	_heli2 = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 1000, "NONE"];[_heli2] call EVO_Lock;
	_pos3 = position _heli2;
	_heli3 = createVehicle ["Camp", _pos3, [], 0, "NONE"];
	_heli4 = createVehicle ["FlagCarrierNorth", _pos3, [], 20, "NONE"];
	_heli5 = createVehicle ["FireLit", _pos3, [], 20, "NONE"];
	_recy = [_user,_heli3] execVM "scripts\recycle.sqf";
	_recy = [_user,_heli4] execVM "scripts\recycle.sqf";
	_recy = [_user,_heli5] execVM "scripts\recycle.sqf";

	_starts = [_pos1,_pos2,_pos3];

	_pos = (_starts select (round random 2));

	_heli addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli1 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	//sleep 1.0;

	"SoldierEB" createUnit [_pos1, _guard];
	"SoldierEB" createUnit [_pos1, _guard];
	"SoldierEB" createUnit [_pos2, _guard];
	"SoldierEB" createUnit [_pos2, _guard];
	"SoldierEB" createUnit [_pos3, _guard];
	"SoldierEB" createUnit [_pos3, _guard];

	_allunits = ["SquadLeaderE","SoldierEAA","SoldierEMG","SoldierEAT","SoldierESniper","SoldierEMedic","SoldierEG","SoldierEB"];
	_max = count _allunits;

	_allunits select (round random (_max - 1)) createUnit [_pos3, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos3, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos3, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos3, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos3, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos3, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos3, _guardb];

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

	{_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guard);
	{_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guardb);
	_recy = [_user,_guard] execVM "scripts\grecycle.sqf";
	_recy = [_user,_guardb] execVM "scripts\grecycle.sqf";
	//[_usergroup, 1] setWaypointStatements ["sobj1", "[west,""HQ""] sideradio ""UNIV_mcom"";player addscore 10;not onmission"];
	//[_usergroup, 1] setWaypointPosition [_pos1, 0];
	//_usergroup setCurrentWaypoint [_usergroup, 1];
	//sleep 1.0;

	_wp1 = _guard addWaypoint [_pos1, 10];
	_wp2 = _guard addWaypoint [_pos2, 10];
	_wp3 = _guard addWaypoint [_pos3, 10];
	_wp4 = _guard addWaypoint [_pos1, 10];
	[_guard, 4] setWaypointType "CYCLE";
	sleep 1.0;
	mgroupa = _guard;
	mgroupb = _guardb;
	publicVariable "mgroupa";
	publicVariable "mgroupb";

};
if ((local server) and not(local _user)) exitWith {};
waitUntil {(not (isNull mgroupa) and not (isNull mgroupb)) or not onmission};
if (not onmission) exitwith {[] call EVO_deletemlpat};
sleep 1.0;
_guard = mgroupa;
_guardb = mgroupb;

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

	Waituntil {sobj1 or ((count units _guard) == 0 and (count units _guardb) == 0) or (_usergroup != (group player)) or (not onmission)}; //or if pilots dead

	sobj1 = false;
	_i = _i + 1;
	if (_usergroup != (group player)) then {_i=100};
	if (not onmission) then {_i=100};
	if (((count units _guard) == 0 and (count units _guardb) == 0)) then {_i=100};
	if (_i == 3 and (count units _guard)  > 0) then {_i=0;};
};

if (_usergroup != (group player)) exitwith {[] call EVO_deletemlpat};
if (not onmission) exitwith {[] call EVO_deletemlpat};
{if(isPlayer _x) then {_x doFollow leader _x}} foreach units (group player);
sleep 1.0;


[_usergroup, 1] setWaypointStatements ["true", "{[_x,20] execVM ""missions\reward.sqf""} forEach (units group this)"];
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