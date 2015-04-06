_user = _this select 0;
_usergroup = (group _user);
_pos = (position abase1);
_base = objNull;
mbase = objNull;
if (_user != leader _usergroup) exitwith {hint localize "EVO_000"};
//sleep 10.0;
placetag = "DEFN";

//if (local _user and onmission) exitwith {hint localize "EVO_001"};
if (local _user) then {sobj1=false;sobj2=false};
_guard = grpNull;
_guardb = grpNull;
_pilot = grpNull;

mgroupa = grpNull;
mgroupb = grpNull;
mgroupc = grpNull;

//publicVariable "mgroupa";
//publicVariable "mgroupb";
//publicVariable "mgroupc";

EVO_deletemdef = 
{
	deleteVehicle _trgobj1;
	deleteVehicle _trgobj2;
	deleteVehicle _trgobj3;
	deleteMarkerLocal _start;
	hint "DEFN: Mission Failed\nSquad dead";
	_handle = [_pilot] execVM "scripts\delete.sqf";
	deleteWaypoint [group player, 1];
	onmission=false;
};

EVO_makeDg =
{
	_bases = [abase1,abase2,abase3,abase4,abase5,abase6];
	_max = count _bases;
	_i = 0;
	while {_i < _max} do 
	{
		if (_i == 5) then
		{
			cbase = abase1;
			//_i = 100;
			//hint format["cbase %1 : %2",cbase,_i];
		};
		if (cbase == (_bases select _i) and _i < 5) then
		{
			_i = _i + 1;
			cbase = (_bases select _i);
			//hint format["cbase %1 : %2",cbase,_i];
			_i = 100;
		};
	_i = _i + 1;
	};
	
	//debug = [] execVM format["cbase %1 : %2",cbase,_i];
	mbase = cbase;
	_pos = position mbase;
	_base = mbase;
	_pilot = createGroup (west);	
	mgroupa = _pilot;
	_recy = [_user,_pilot] execVM "scripts\grecycle.sqf";

	_allunits = ["SquadLeaderW","SoldierWMG","SoldierWAT","SoldierWSniper","SoldierWMedic","SoldierWG","SoldierWB"];
	_max = count _allunits;	
	_allunits select (round random (_max - 1)) createUnit [_pos, _pilot];
	_allunits select (round random (_max - 1)) createUnit [_pos, _pilot];
	_allunits select (round random (_max - 1)) createUnit [_pos, _pilot];
	_allunits select (round random (_max - 1)) createUnit [_pos, _pilot];
	_allunits select (round random (_max - 1)) createUnit [_pos, _pilot];
	_allunits select (round random (_max - 1)) createUnit [_pos, _pilot];

	_allvecA = ["HMMWV50","M113"];
	_maxA = count _allvecA;
	_heli2 = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 0, "NONE"];
	[_heli2] call EVO_Lock;
	_heli2 setFuel 0.0;
	_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	(units _pilot select 0) assignAsDriver _heli2;
	(units _pilot select 0) moveInDriver _heli2;
	(units _pilot select 1) assignAsGunner _heli2;
	(units _pilot select 1) moveInGunner _heli2;
	{commandStop _x;_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];_x commandFollow (leader _x)} forEach (units _pilot);
	sleep 1.0;
	publicVariable "mgroupa";
	publicVariable "mbase";
};


deleteWaypoint [group player, 1];
_wp1 = group player addWaypoint [position mresc, 0];
[group player, 1] showWaypoint "NEVER";
[_usergroup, 1] setWaypointType "LEADER";
[_usergroup, 1] setWaypointPosition [position player, 0];
//[_usergroup, 1] setWaypointDescription localize "EVO_035";
[_usergroup, 1] setWaypointDescription "DEFEND";
[_usergroup, 1] setWaypointStatements ["true", "{[_x,""EVO_028""] execVM ""missions\brief.sqf""} forEach (units group this)"];
_usergroup setCurrentWaypoint [_usergroup, 1];
sleep 1.0;

_trgobj1 = createTrigger ["EmptyDetector", position player ];
_trgobj1 setTriggerText "DEFN Mission Brief";
_trgobj1 setTriggerActivation ["ALPHA", "PRESENT", true];
_trgobj1 setTriggerStatements ["this", "hint localize ""EVO_050""",""];

_trgobj2 = createTrigger ["EmptyDetector", position player ];
_trgobj2 setTriggerText "Abandon Mission";
_trgobj2 setTriggerActivation ["CHARLIE", "PRESENT", true];
_trgobj2 setTriggerStatements ["this", "if (score player > 1) then {player addscore -2};onmission=false;hint localize ""EVO_049""",""];


if (local server) then 
{

	[] call EVO_makeDg;
};

//if ((local server) and not(local _user)) exitWith {}; 

if (local player) then 
{
/*
	for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
	{
		hint format["mgroupa :%1 mbase :%2",mgroupa,mbase];
		if (not (isNull mgroupa) and not (isNull mbase)) then {_loop=1};
		if (not onmission) then {_loop=1};
		sleep 1.0;
		hint "";
	};
*/	[1800] execVM "missions\timer.sqf";
	waitUntil {not onmission or (not (isNull mgroupa) and not (isNull mbase))};//stuck
	if (not onmission) exitwith {[] call EVO_deletemdef};
	_pilot = mgroupa;
	_base = mbase;
	_pos = position mbase;
	//map
	[_usergroup, 1] setWaypointStatements ["sobj2", "{[_x,30] execVM ""missions\reward.sqf""} forEach (units group this)"];
	_usergroup setCurrentWaypoint [_usergroup, 1];
	[_usergroup, 1] setWaypointPosition [_pos, 0];	
};

sleep 1.0;

_start = createMarkerLocal ["BHD", _pos];
_start setMarkerColorLocal "ColorYellow";
_start setMarkerTypeLocal "Start";
//_start setMarkerTextLocal localize "EVO_035";
_start setMarkerTextLocal "Defend";
//hint format["%1 %2 %3 %4",_pilot,_guard,_guardb,_pos];
_mapview = [_pos,1] execVM "scripts\mismap.sqf";//debug	

//player setpos (position _base);
/*
for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	hint format["%1",list _base];
	sleep 1.0;
	hint "";
};
*/

if (local server) then 
{
	[_user,_base,_pilot] execVM "missions\bAttack.sqf";
	[_user,_base,_pilot] execVM "missions\bAttack.sqf";
};

if (local server and not (local player)) exitwith {};

waitUntil {player in list _base or not onmission};
if (not onmission) exitwith {[] call EVO_deletemdef};
_count = 0;
for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	sleep 1.001;
	if ((vehicle player) in list _base) then {_count = _count +1} else {hint "Take position inside the base"};
	if (_count == 240) then 
	{
		_trgobj3 = createTrigger ["EmptyDetector", _pos ];
		_trgobj3 setTriggerActivation ["EAST", "NOT PRESENT", false];
		_trgobj3 setTriggerArea [200, 200, 0, true];
		_trgobj3 setTriggerStatements ["this", "sobj1 = true", ""];
		_trgobj3 setTriggerTimeout [20, 20, 20, true ];	
		//hint "made trigger";
	};
	if (sobj1) then {_loop=1;};
	if (_usergroup != (group player)) then {_loop=1;};
	if (not onmission) then {_loop=1;};
	if (count units _pilot == 0) then {_loop=1};
};

if (_usergroup != (group player)) exitwith {[] call EVO_deletemdef};
if (not onmission) exitwith {[] call EVO_deletemdef};
if(count units _pilot == 0) exitwith {[] call EVO_deletemdef};
[_usergroup, 1] setWaypointPosition [position player, 0];
{if(isPlayer _x) then {_x doFollow leader _x}} foreach units (group player);
sleep 1.0;
sobj2=true;

deleteMarkerLocal _start;
deleteVehicle _trgobj1;
deleteVehicle _trgobj2;
deleteVehicle _trgobj3;
sleep 60.0;
_handle = [_pilot] execVM "scripts\delete.sqf";

