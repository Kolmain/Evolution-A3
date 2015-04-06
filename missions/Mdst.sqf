_user = _this select 0;
_var = _this select 1;
_usergroup = (group _user);
_allobj = [];
placetag = "DSTR";
if (_user != leader _usergroup) exitwith {hint localize "EVO_000"};
//if (local _user and onmission) exitwith {hint localize "EVO_001"};
if (local _user) then {sobj1=false;sobj2=false};
mgroupa = grpNull;
//publicVariable "mgroupa";

EVO_deletemdst =
{
	deleteWaypoint [group player, 1];
	deleteVehicle _trgobj1;
	deleteVehicle _trgobj2;
	deleteMarkerLocal _search;
	_handle = [_guard] execVM "scripts\delete.sqf";
	onmission=false;
};


deleteWaypoint [group player, 1];
_wp1 = group player addWaypoint [position mresc, 0];
[group player, 1] showWaypoint "NEVER";
[_usergroup, 1] setWaypointType "LEADER";
[_usergroup, 1] setWaypointDescription "mil_destroy ARMOUR";
[_usergroup, 1] setWaypointStatements ["true", "{[_x,""EVO_029""] execVM ""missions\brief.sqf""} forEach (units group this)"];
[_usergroup, 1] setWaypointPosition [position player, 0];
_usergroup setCurrentWaypoint [_usergroup, 1];

[1800] execVM "missions\timer.sqf";
_trgobj1 = createTrigger ["EmptyDetector", position player ];
_trgobj1 setTriggerText "TERM Mission Brief";
_trgobj1 setTriggerActivation ["ALPHA", "PRESENT", true];
_trgobj1 setTriggerStatements ["this", "hint localize ""EVO_029""",""];

_trgobj2 = createTrigger ["EmptyDetector", position player ];
_trgobj2 setTriggerText "Abandon Mission";
_trgobj2 setTriggerActivation ["CHARLIE", "PRESENT", true];
_trgobj2 setTriggerStatements ["this", "if (score player > 1) then {player addscore -2};onmission=false;hint localize ""EVO_049""",""];

if (local server) then
{
	_guard = createGroup (east);


	_recy = [_user,_guard] execVM "scripts\grecycle.sqf";
	if(_var == 10) then
	{
		_allobj = ["mrnd2","mrnd10","mrnd1","mrnd9"];
	};
	if(_var == 20) then
	{
		_allobj = ["mrnd11","mrnd12","mrnd13","mrnd14","mrnd15","mrnd20","mrnd19","mrnd18","mrnd16","mrnd7","mrnd6","mrnd5","mrnd4","mrnd3"];
	};
	_max = count _allobj;
	_r = round random (_max - 1);
	_rand =  _allobj select _r;
	_pos = getMarkerPos _rand;

	_allvecA = ["T72","ZSU"];
	_allvecB = ["BRDM2","BMP2"];
	if(_var == 10) then
	{
		_allvecA = ["BRDM2","BMP2"];
	};
	if(_var == 20) then
	{
		_allvecA = ["T72","ZSU"];
	};

	_maxA = count _allvecA;
	_maxB = count _allvecB;

	_heli = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 200, "NONE"];[_heli] call EVO_Lock;
	_pos = position _heli;
	_heli1 = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 200, "NONE"];[_heli1] call EVO_Lock;
	_heli2 = createVehicle [(_allvecB select round random (_maxB - 1)), _pos, [], 200, "NONE"];[_heli2] call EVO_Lock;
	_heli addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli1 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_allunits = ["SquadLeaderE","SoldierEAA","SoldierEMG","SoldierEAT","SoldierESniper","SoldierEMedic","SoldierEG","SoldierEB"];
	_max = count _allunits;

	"SoldierECrew" createUnit [_pos, _guard];
	"SoldierECrew" createUnit [_pos, _guard];
	"SoldierECrew" createUnit [_pos, _guard];

	"SoldierECrew" createUnit [_pos, _guard];
	"SoldierECrew" createUnit [_pos, _guard];
	"SoldierECrew" createUnit [_pos, _guard];

	"SoldierECrew" createUnit [_pos, _guard];
	"SoldierECrew" createUnit [_pos, _guard];
	"SoldierECrew" createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];

	{_x addEventHandler ["killed", {_x setCombatMode "RED";commandStop _x;handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guard);
	//sleep 1.0;


	if(_var == 10) then
	{
		(units _guard select 0) assignAsGunner _heli;
		(units _guard select 1) assignAsDriver _heli;
		(units _guard select 2) assignAsCargo _heli;

		(units _guard select 3) assignAsGunner _heli1;
		(units _guard select 4) assignAsDriver _heli1;
		(units _guard select 5) assignAsCargo _heli1;

		(units _guard select 6) assignAsGunner _heli2;
		(units _guard select 7) assignAsDriver _heli2;
		(units _guard select 8) assignAsCargo _heli2;

		(units _guard select 0) moveInGunner _heli;
		(units _guard select 1) moveInDriver _heli;
		(units _guard select 2) moveInCargo _heli;

		(units _guard select 3) moveInGunner _heli1;
		(units _guard select 4) moveInDriver _heli1;
		(units _guard select 5) moveInCargo _heli1;

		(units _guard select 6) moveInGunner _heli2;
		(units _guard select 7) moveInDriver _heli2;
		(units _guard select 8) moveInCargo _heli2;

	};
	if(_var == 20) then
	{
		(units _guard select 0) assignAsCommander _heli;
		(units _guard select 1) assignAsDriver _heli;
		(units _guard select 2) assignAsGunner _heli;

		(units _guard select 3) assignAsCommander _heli1;
		(units _guard select 4) assignAsDriver _heli1;
		(units _guard select 5) assignAsGunner _heli1;

		(units _guard select 6) assignAsCommander _heli2;
		(units _guard select 7) assignAsDriver _heli2;
		(units _guard select 8) assignAsGunner _heli2;

		(units _guard select 0) moveInCommander _heli;
		(units _guard select 1) moveInDriver _heli;
		(units _guard select 2) moveInGunner _heli;

		(units _guard select 3) moveInCommander _heli1;
		(units _guard select 4) moveInDriver _heli1;
		(units _guard select 5) moveInGunner _heli1;

		(units _guard select 6) moveInCommander _heli2;
		(units _guard select 7) moveInDriver _heli2;
		(units _guard select 8) moveInGunner _heli2;
	};
	//[units _guard] orderGetIn true;
	//player setCaptive true;
	//[player] join _guard;
	//player setpos position (leader _guard);
	sleep 1.0;
	mgroupa = _guard;
	publicVariable "mgroupa";
};

if ((local server) and not(local _user)) exitWith {};
waitUntil {(not (isNull mgroupa)) or not onmission};
if (not onmission) exitwith {[] call EVO_deletemdst};
sleep 1.0;

_guard = mgroupa;
_pos = position vehicle (leader _guard);
_heli = assignedVehicle (units _guard select 0);
_heli1 = assignedVehicle (units _guard select 3);
_heli2 = assignedVehicle (units _guard select 6);

//_dd = [] execVM format["_guard %1, _heli %2 _heli1 %3 _heli2 %4",_guard,_heli,_heli1,_heli2];




//{_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guard);
//_heli addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
//_heli1 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
//_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];

_search = createMarkerLocal ["look", _pos];
_search setMarkerTypeLocal "mil_destroy";
_search setMarkerTextLocal localize "EVO_038";
_search setMarkerColorLocal "ColorYellow";
_search setMarkerSizeLocal [0.5, 0.5];

//map
_mapview = [GetMarkerPos _search,2] execVM "scripts\mismap.sqf";

if(_var == 10) then
{
	[_usergroup, 1] setWaypointStatements ["sobj1", "{[_x,10] execVM ""missions\reward.sqf""} forEach (units group this)"];
};
if(_var == 20) then
{
	[_usergroup, 1] setWaypointStatements ["sobj1", "{[_x,20] execVM ""missions\reward.sqf""} forEach (units group this)"];
};

[_usergroup, 1] setWaypointPosition [_pos, 0];
_usergroup setCurrentWaypoint [_usergroup, 1];


//Waituntil {(not (alive _heli) and not (alive _heli1) and not (alive _heli2)) or (_usergroup != group player) or (not onmission)};
//Waituntil {(not onmission) or (_usergroup != group player) or (not (alive _heli) and not (alive _heli1) and not (alive _heli2))};


for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	sleep 1.001;
	[_usergroup, 1] setWaypointPosition [position (leader _guard), 0];
	//[_usergroup, 1] waypointAttachVehicle (vehicle (leader _guard));
	_search setMarkerPosLocal position (leader _guard);
	if ((count units _guard) == 0 or _usergroup != (group player) or not onmission) then {_loop=1;};
};


if (_usergroup != (group player) or not onmission) exitwith
{

	[] call EVO_deletemdst
};


{if(isPlayer _x) then {_x doFollow leader _x}} foreach units (group player);
sleep 1.0;
sobj1=true;
[_usergroup, 1] setWaypointPosition [position player, 0];


sleep 2.0;
[] call EVO_deletemdst