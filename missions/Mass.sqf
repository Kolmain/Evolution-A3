_user = _this select 0; //change
_var = _this select 1;
_usergroup = (group _user);
_starts = [];
_allobj = [];
_pos = [0,0,0];
placetag = "AMBU";

if (_user != leader _usergroup) exitwith {hint localize "EVO_000"};
//if (local _user and onmission) exitwith {hint localize "EVO_001"};
if (local _user) then {sobj1=false;sobj2=false}; //change back
mgroupa = grpNull;
//publicVariable "mgroupa";

EVO_deleteass =
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
[_usergroup, 1] setWaypointDescription localize "EVO_034";
[_usergroup, 1] setWaypointStatements ["true", "{[_x,""EVO_027""] execVM ""missions\brief.sqf""} forEach (units group this)"];
[_usergroup, 1] setWaypointPosition [position player, 0];
_usergroup setCurrentWaypoint [_usergroup, 1];

[1800] execVM "missions\timer.sqf";
_trgobj1 = createTrigger ["EmptyDetector", position player ];
_trgobj1 setTriggerText "AMBU Mission Brief";
_trgobj1 setTriggerActivation ["ALPHA", "PRESENT", true];
_trgobj1 setTriggerStatements ["this", "hint localize ""EVO_027""",""];

_trgobj2 = createTrigger ["EmptyDetector", position player ];
_trgobj2 setTriggerText "Abandon Mission";
_trgobj2 setTriggerActivation ["CHARLIE", "PRESENT", true];
_trgobj2 setTriggerStatements ["this", "if (score player > 0) then {player addscore -2};onmission=false;hint localize ""EVO_049""",""];


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
	_pos2 = [(_pos select 0),(_pos select 1) - 15,(_pos select 2)];
	_pos3 = [(_pos select 0),(_pos select 1) - 30,(_pos select 2)];
	_pos4 = [(_pos select 0),(_pos select 1) - 45,(_pos select 2)];

	_allvecA = ["UAZ_AGS30","UAZMG"];
	_allvecB = ["BRDM2","BMP2"];
	_allvecC = ["UralRepair","UralReammo","UralRefuel"];

	if(_var == 20) then
	{
		_allvecA = ["BRDM2","BMP2"];_allvecB = ["BRDM2","BMP2"];
	};

	_maxA = count _allvecA;
	_maxB = count _allvecB;
	_maxC = count _allvecC;

	_heli = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 0, "NONE"];[_heli] call EVO_Lock;
	_heli1 = createVehicle [(_allvecC select round random (_maxC - 1)), _pos2, [], 0, "NONE"];[_heli1] call EVO_Lock;
	_heli2 = createVehicle [(_allvecC select round random (_maxC - 1)), _pos3, [], 0, "NONE"];[_heli2] call EVO_Lock;
	_heli3 = createVehicle [(_allvecB select round random (_maxB - 1)), _pos4, [], 0, "NONE"];[_heli3] call EVO_Lock;
	_heli addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli1 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_heli3 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	_allunits = ["SoldierESaboteurPipe","SoldierESaboteurMarksman","SoldierESaboteurBizon"];
	_max = count _allunits;

	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];

	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];

	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];
	"SoldierEAA" createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];
	(_allunits select round random (_max - 1)) createUnit [_pos, _guard];

	(units _guard select 0) assignAsDriver _heli;
	(units _guard select 0) moveInDriver _heli;
	(units _guard select 1) assignAsGunner _heli;
	(units _guard select 1) moveInGunner _heli;

	(units _guard select 2) assignAsDriver _heli1;
	(units _guard select 2) moveInDriver _heli1;
	(units _guard select 3) assignAsDriver _heli2;
	(units _guard select 3) moveInDriver _heli2;

	(units _guard select 4) assignAsDriver _heli3;
	(units _guard select 4) moveInDriver _heli3;
	(units _guard select 5) assignAsGunner _heli3;
	(units _guard select 5) moveInGunner _heli3;
	(units _guard select 6) assignAsCargo _heli3;
	(units _guard select 6) moveInCargo _heli3;
	(units _guard select 7) assignAsCargo _heli3;
	(units _guard select 7) moveInCargo _heli3;

	_guard setFormation "COLUMN";
	_guard setSpeedMode "LIMITED";
	_guard setBehaviour "SAFE";
	{_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guard);
	_allobj = ["mobj1","mobj2","mobj3","mobj4","mobj5","mobj6","mobj7","mobj8","mobj9","mobj10","mobj11"];
	_currentobj = [];
	_max = count _allobj;
	_rand =  _allobj select (round random (_max - 1));
	_wp = _guard addWaypoint [_pos2, 10];
	_pos = getMarkerPos _rand;
	_wp2 = _guard addWaypoint [_pos, 10];
	_wp3 = _guard addWaypoint [_pos, 10];
	[_guard, 3] setWaypointType "CYCLE";
	sleep 1.0;
	mgroupa = _guard;
	publicVariable "mgroupa";
};

if ((local server) and not(local _user)) exitWith {};

waitUntil {(not (isNull mgroupa)) or not onmission};
if (not onmission) exitwith {[] call EVO_deleteass};
sleep 1.0;

_guard = mgroupa;
_pos = position (leader _guard);

_search = createMarkerLocal ["look", _pos];
_search setMarkerTypeLocal "mil_destroy";
_search setMarkerTextLocal localize "EVO_034";
_search setMarkerColorLocal "ColorYellow";
_search setMarkerSizeLocal [0.5, 0.5];

_mapview = [_pos,2] execVM "scripts\mismap.sqf";

if(_var == 10) then
{
	[_usergroup, 1] setWaypointStatements ["sobj1", "{[_x,10] execVM ""missions\reward.sqf""} forEach (units group this)"];
};
if(_var == 20) then
{
	[_usergroup, 1] setWaypointStatements ["sobj1", "{[_x,20] execVM ""missions\reward.sqf""} forEach (units group this)"];
};
_usergroup setCurrentWaypoint [_usergroup, 1];


for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	sleep 1.001;
	[_usergroup, 1] setWaypointPosition [position (leader _guard), 0];
	//[_usergroup, 1] waypointAttachVehicle (vehicle (leader _guard));
	_search setMarkerPosLocal position (leader _guard);
	if ((count units _guard) == 0 or _usergroup != (group player) or not onmission) then {_loop=1;};
};
//_debug = [] execVM format["%1 %2 %3",(count units _guard),(_usergroup != (group player)),(not onmission)];

if (_usergroup != (group player) or not onmission) exitwith
{

	[] call EVO_deleteass
};

{if(isPlayer _x) then {_x doFollow leader _x}} foreach units (group player);
sleep 1.0;

[_usergroup, 1] setWaypointPosition [position player, 0];
_usergroup setCurrentWaypoint [_usergroup, 1];
sobj1=true;


sleep 2.0;
[] call EVO_deleteass;
