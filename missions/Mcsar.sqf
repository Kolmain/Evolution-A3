_user = _this select 0;
_usergroup = (group _user);
_pos = [0,0,0];
_player = player;
placetag = "CSAR";
if (_user != leader _usergroup) exitwith {hint localize "EVO_000"};
//if (local _user and onmission) exitwith {hint localize "EVO_001"};
if (local _user) then {sobj1=false;sobj2=false};
_pos = [0,0,0];
mgroupa = grpNull;
mgroupb = grpNull;
mgroupc = grpNull;
publicVariable "mgroupa";
publicVariable "mgroupb";
publicVariable "mgroupc";

EVO_deletemsar =
{
	deleteVehicle _trgobj1;
	deleteVehicle _trgobj2;
	deleteVehicle _trgobj3;
	deleteMarkerLocal _start;
	deleteMarkerLocal _end;
	deleteMarkerLocal _search;
	hint "CSAR: Mission Failed\nReporter dead";
	_handle = [_guard] execVM "scripts\delete.sqf";
	_handle = [_guardb] execVM "scripts\delete.sqf";
	_handle = [_pilot] execVM "scripts\delete.sqf";
	deleteWaypoint [group player, 1];
	onmission=false;
};

deleteWaypoint [group player, 1];
_wp1 = group player addWaypoint [position mresc, 0];
[group player, 1] showWaypoint "NEVER";
[_usergroup, 1] setWaypointType "LEADER";
[_usergroup, 1] setWaypointPosition [position player, 0];
[_usergroup, 1] setWaypointDescription localize "EVO_035";
[_usergroup, 1] setWaypointStatements ["true", "{[_x,""EVO_028""] execVM ""missions\brief.sqf""} forEach (units group this)"];
_usergroup setCurrentWaypoint [_usergroup, 1];
sleep 1.0;

[1800] execVM "missions\timer.sqf";
_trgobj1 = createTrigger ["EmptyDetector", position player ];
_trgobj1 setTriggerText "CSAR Mission Brief";
_trgobj1 setTriggerActivation ["ALPHA", "PRESENT", true];
_trgobj1 setTriggerStatements ["this", "hint localize ""EVO_045""",""];

_trgobj2 = createTrigger ["EmptyDetector", position player ];
_trgobj2 setTriggerText "Abandon Mission";
_trgobj2 setTriggerActivation ["CHARLIE", "PRESENT", true];
_trgobj2 setTriggerStatements ["this", "if (score player > 1) then {player addscore -2};onmission=false;hint localize ""EVO_049""",""];
if (local server) then 
{

	_pilot = createGroup (civilian);
	_guard = createGroup (east);
	_guardb = createGroup (east);
	_recy = [_user,_pilot] execVM "scripts\grecycle.sqf";
	_recy = [_user,_guard] execVM "scripts\grecycle.sqf";
	_recy = [_user,_guardb] execVM "scripts\grecycle.sqf";	
	
	_randx = 13446+(random 4457);
	_randy = 9819+(random 2993);
	_rndx = random 400;
	_rndy = random 400;
	_rndbx = random 400;
	_rndby = random 400;
	_pos = [_randx,_randy,0];
	_ppos = [(_pos select 0)-200 +_rndx,(_pos select 1)-200+_rndy,0];
	_pposb = [(_pos select 0)-200 +_rndbx,(_pos select 1)-200+_rndby,0];
	
	_poser = createVehicle ["RoadCone", _pos, [], 1000, "NONE"];
	_pos = position _poser;
	deleteVehicle _poser;
		
	_heli = createVehicle ["BlackhawkWreck", _pos, [], 400, "NONE"];_recy = [_user,_heli] execVM "scripts\recycle.sqf";
	_heil setDir (random 359);
	
	_pos = position _heli;
	_ppos = [(_pos select 0)-200 +_rndx,(_pos select 1)-200+_rndy,0];
	_pposb = [(_pos select 0)-200 +_rndbx,(_pos select 1)-200+_rndby,0];

	"SoldierWPilot" createUnit [_ppos, _pilot];

	_sara = (units _pilot select 0);

	{
	_x disableAI "MOVE";
	_x allowfleeing 0;
	_x setBehaviour "Careless";
	removeallweapons _x;
	_x setCaptive true;
	commandStop _x;
	_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]
	} forEach units _pilot;

	sleep 1.0;

	{
	_x switchMove "AmovPercMstpSsurWnonDnon";
	} forEach units _pilot;

	_allunits = ["SoldierESaboteurPipe","SoldierESaboteurMarksman","SoldierESaboteurBizon"];
	_max = count _allunits;

	_allunits select (round random (_max - 1)) createUnit [_ppos, _guard];
	"SoldierEAA" createUnit [_ppos, _guard];
	
	_allunits select (round random (_max - 1)) createUnit [_pos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_pos, _guardb];
	

	_wp1 = _guardb addWaypoint [_pos, 10];
	_wp2 = _guardb addWaypoint [_ppos, 10];
	_wp3 = _guardb addWaypoint [_pposb, 10];
	_wp4 = _guardb addWaypoint [_ppos, 10];
	[_guardb, 4] setWaypointType "CYCLE";


	_allvecA = ["UAZ_AGS30","UAZMG"];
	_maxA = count _allvecA;
	_heli2 = createVehicle [(_allvecA select round random (_maxA - 1)), _pos, [], 0, "NONE"];
	[_heli2] call EVO_Lock;
	_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	(units _guardb select 0) assignAsDriver _heli2;
	(units _guardb select 0) moveInDriver _heli2;
	(units _guardb select 1) assignAsGunner _heli2;
	(units _guardb select 1) moveInGunner _heli2;

	{_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guard);
	{_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guardb);
	sleep 1.0;
	mgroupa = _pilot;
	mgroupb = _guard;
	mgroupc = _guardb;
	publicVariable "mgroupa";	
	publicVariable "mgroupb";
	publicVariable "mgroupc";	

};

//if (local server) exitWith {};
if ((local server) and not(local _user)) exitWith {}; 
waitUntil {(not (isNull mgroupa) and not (isNull mgroupb) and not (isNull mgroupc)) or not onmission};
if (not onmission) exitwith {[] call EVO_deletemsar};

sleep 1.0;

_pilot = mgroupa;
_guard = mgroupb;
_guardb = mgroupc;
_pos = position vehicle (units _guardb select 0);
//hint format["%1 %2 %3 %4",_pilot,_guard,_guardb,_pos];

_caps = (units _pilot);

_search = createMarkerLocal ["look", _pos];
_search setMarkerColorLocal "ColorGreen";
_search setMarkerShapeLocal "RECTANGLE";
_search setMarkerSizeLocal [200, 200];
_search setMarkerBrushLocal "FDiagonal";

_start = createMarkerLocal ["BHD", _pos];
_start setMarkerColorLocal "ColorYellow";
_start setMarkerTypeLocal "End";
_start setMarkerTextLocal localize "EVO_035";

_end = createMarkerLocal ["SAFE", position dropoff];
_end setMarkerColorLocal "ColorYellow";
_end setMarkerTypeLocal "End";
_end setMarkerTextLocal localize "EVO_036";

//map
_mapview = [getmarkerpos _search,1] execVM "scripts\mismap.sqf";//debug

_trgobj3 = createTrigger ["EmptyDetector", _pos ];
_trgobj3 setTriggerActivation ["EAST", "NOT PRESENT", false];
_trgobj3 setTriggerArea [200, 200, 0, true];
_trgobj3 setTriggerStatements ["this", "sobj1 = true", ""];
_trgobj3 setTriggerTimeout [5, 10, 7, true ];

[_usergroup, 1] setWaypointStatements ["sobj1", "[west,""HQ""] sideradio ""UNIV_asec"";hint ""Objective Complete\nArea secure\nLead the Pilot back to the evac helipad"""];
_usergroup setCurrentWaypoint [_usergroup, 1];
[_usergroup, 1] setWaypointPosition [_pos, 0];

for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	sleep 1.001;
	if (sobj1) then {_loop=1;};
	if (_usergroup != (group player)) then {_loop=1;};
	if (not onmission) then {_loop=1;};
	if (not alive (_caps select 0)) then {_loop=1;};
};
if (_usergroup != (group player)) exitwith {[] call EVO_deletemsar};
if (not onmission) exitwith {[] call EVO_deletemsar};
if (not alive (_caps select 0)) exitwith {[] call EVO_deletemsar};

sleep 1.0;

[_usergroup, 1] setWaypointPosition [position dropoff, 0];
[_usergroup, 1] setWaypointStatements ["sobj2", "{[_x,10] execVM ""missions\reward.sqf""} forEach (units group this)"];
[_usergroup, 1] setWaypointDescription localize "EVO_036";
_usergroup setCurrentWaypoint [_usergroup, 1];


_caps join _usergroup;

{
	_x setdamage 0;
	_x setCaptive false;
	_x enableAI "MOVE";
} forEach _caps;


//hint format["%1 | %2",pilot1,pilot2];
 
for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	sleep 1.001;
	//hint format["caps = %1",_caps];
	if ((_caps select 0) distance dropoff < 20) then {_loop=1};
	if (not alive (_caps select 0)) then {_loop=1};
	if (not onmission) then {_loop=1;};
};
if (not onmission) exitwith {[] call EVO_deletemsar};
if (not alive (_caps select 0)) exitwith {[] call EVO_deletemsar};

{
	_x action ["Eject",(vehicle _x)];	
	unassignVehicle _x;
	_x doMove (position safty);
	
} forEach _caps;

{if(isPlayer _x) then {_x doFollow leader _x}} foreach units (group player);
sleep 1.0;
sobj2=true;



deleteMarkerLocal _start;
deleteMarkerLocal _end;
deleteMarkerLocal _search;
deleteVehicle _trgobj1;
deleteVehicle _trgobj2;
deleteVehicle _trgobj3;
sleep 20.0;

{
	deleteVehicle _x;
} forEach _caps;

