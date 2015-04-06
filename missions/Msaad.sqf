_user = _this select 0;
_usergroup = (group _user);


if (_user != leader _usergroup) exitwith {hint localize "EVO_000"};
//if (local _user and onmission) exitwith {hint localize "EVO_001"};
if (local _user) then {sobj1=false;sobj2=false};

EVO_deletemsaad =
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
[_usergroup, 1] setWaypointStatements ["true", "{[_x,""EVO_030""] execVM ""missions\brief.sqf""} forEach (units group this)"];
//sleep 1.0;
_usergroup setCurrentWaypoint [_usergroup, 1];

[1800] execVM "missions\timer.sqf";
_trgobj1 = createTrigger ["EmptyDetector", position player ];
_trgobj1 setTriggerText "SAAD Mission Brief";
_trgobj1 setTriggerActivation ["ALPHA", "PRESENT", true];
_trgobj1 setTriggerStatements ["this", "hint localize ""EVO_030""",""];

_trgobj2 = createTrigger ["EmptyDetector", position player ];
_trgobj2 setTriggerText "Abandon Mission";
_trgobj2 setTriggerActivation ["CHARLIE", "PRESENT", true];
_trgobj2 setTriggerStatements ["this", "if (score player > 1) then {player addscore -2};onmission=false;hint localize ""EVO_049""",""];

if (local server) then
{
	_guard = createGroup (east);
	_guardb = createGroup (east);
	_pilot = createGroup (civilian);
	mgroupa = _pilot;
	mgroupb = _guard;
	mgroupc = _guardb;


	_allobj = ["mobj1","mobj2","mobj3","mobj4","mobj5","mobj6","mobj7","mobj8","mobj9","mobj10","mobj11"];
	_currentobj = [];
	_max = count _allobj;
	_i = 0;
	while {_i < _max} do
	{
		_marker = (_allobj select _i);
		_pos = getMarkerPos _marker;
		if ((_pos select 0) != 0) then
		{
			_currentobj = _currentobj + [_marker];

		};
		_i = _i + 1;
	};
	_max = count _currentobj;
	_r = round random (_max - 1);
	_rand =  _currentobj select _r;
	_mpos = getMarkerPos _rand;



	sleep 1.0;

	//[_usergroup, 1] setWaypointStatements ["sobj1", "player addscore 10;not onmission;hint ""----MISSION COMPLETE----\n10 Points Awarded\nGood job!"""];




	//_heli = createVehicle ["BlackhawkWreck", _pos, [], 0, "NONE"];
	_poser = createVehicle ["RoadCone", _mpos, [], 50, "NONE"];
	_civpos = position _poser;
	deleteVehicle _poser;

	_allunits = ["Civilian3","Civilian6","Civilian9","Civilian12","Civilian15","Civilian18"];
	_max = count _allunits;

	_allunits select (round random (_max - 1)) createUnit [_civpos, _pilot];
	_sara = (units _pilot select 0);
	{_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _pilot);
	_sara disableAI "MOVE";_sara allowfleeing 0;_sara setBehaviour "Careless";commandStop _sara;
	_rnd = round random 1;
	_randpos = [0,0,0];
	if(_rnd == 0) then
	{
		_randpos = [8039.371582,16462.736328,0];
	}
	else
	{
		_randpos = [9830.457031,15646.099609,0];
	};

	_camp = createVehicle ["Land_podlejzacka", _randpos, [], 900, "NONE"];
	_newpos = position _camp;
	_camp2 = createVehicle ["Land_prolejzacka", _newpos, [], 100, "NONE"];
	_newpos2 = position _camp2;
	_camp3 = createVehicle ["Land_prebehlavka", _newpos, [], 100, "NONE"];
	_camp4 = createVehicle ["Land_obihacka", _newpos, [], 100, "NONE"];

	_allunits = ["Civilian19","Civilian20","Civilian21"];
	_max = count _allunits;

	_allunits select (round random (_max - 1)) createUnit [_newpos, _guard];
	_allunits select (round random (_max - 1)) createUnit [_newpos, _guard];
	_allunits select (round random (_max - 1)) createUnit [_newpos, _guard];
	_allunits select (round random (_max - 1)) createUnit [_newpos, _guard];

	_allunits select (round random (_max - 1)) createUnit [_newpos2, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_newpos2, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_newpos2, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_newpos2, _guardb];

	_allcom = ["YELLOW","RED"];
	_max = (count _allcom)-1;
	_guard setCombatMode (_allcom select (round random _max));
	_guardb setCombatMode (_allcom select (round random _max));

	_allform = ["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE"];
	_max = (count _allform)-1;
	_guard setFormation (_allform select (round random _max));
	_guardb setFormation (_allform select (round random _max));

	_wp1 = _guardb addWaypoint [position _camp, 0];
	_wp2 = _guardb addWaypoint [position _camp2, 0];
	_wp3 = _guardb addWaypoint [position _camp3, 0];
	_wp4 = _guardb addWaypoint [position _camp, 0];
	[_guard, 4] setWaypointType "CYCLE";

	_allvecA = ["DSHKM","AGS"];
	_maxA = count _allvecA;
	_heli2 = createVehicle [(_allvecA select round random (_maxA - 1)), _newpos2, [], 10, "NONE"];
	[_heli2] call EVO_Lock;_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
	(units _guard select 2) assignAsGunner _heli2;
	(units _guard select 2) moveInGunner _heli2;

	{_x setUnitPos "up";_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];_x addMagazine "30Rnd_545x39_AK";_x addMagazine "30Rnd_545x39_AK";_x addMagazine "30Rnd_545x39_AK";_x addweapon "AK74"} forEach (units _guard);
	{_x setUnitPos "up";_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];_x addMagazine "30Rnd_545x39_AK";_x addMagazine "30Rnd_545x39_AK";_x addMagazine "30Rnd_545x39_AK";_x addweapon "AK74"} forEach (units _guardb);
	publicVariable "mgroupa";
	publicVariable "mgroupb";
	publicVariable "mgroupc";
};
//hint format["%1",(count units _guard)];
if ((local server) and not(local _user)) exitWith {};
sleep 1.0;

_pilot = mgroupa;
_guard = mgroupb;
_guardb = mgroupc;
_mpos = position (units _pilot select 0);
_newpos = position (units _guard select 0);
_sara = (units _pilot select 0);
_actionId1 = _sara addaction [localize "EVO_023","scripts\Msaada.sqf",0,1, true, true,"test2"];

[_usergroup, 1] setWaypointDescription localize "EVO_039";
[_usergroup, 1] setWaypointStatements ["sobj1", "[west,""HQ""] sideradio ""UNIV_meet"""];
_usergroup setCurrentWaypoint [_usergroup, 1];
[_usergroup, 1] setWaypointPosition [position _sara, 0];

_start = createMarkerLocal ["BHD", _mpos];
_start setMarkerColorLocal "ColorYellow";
_start setMarkerTypeLocal "Warning";
_start setMarkerTextLocal localize "EVO_039";

//map
_mapview = [GetMarkerPos _start,0] execVM "scripts\mismap.sqf";


Waituntil {sobj1 or not (alive _sara) or _usergroup != (group player) or not onmission}; //or if pilots dead
sleep 1.0;
if (_usergroup != (group player)) exitwith {[] call EVO_deletemsaar};
if (not onmission) exitwith {[] call EVO_deletemsaar};
if (not alive _sara) exitwith {[] call EVO_deletemsaar};

deleteMarkerLocal _start;


[_usergroup, 1] setWaypointDescription localize "EVO_040";
[_usergroup, 1] setWaypointStatements ["sobj2", "{[_x,20] execVM ""missions\reward.sqf""} forEach (units group this)"];
_usergroup setCurrentWaypoint [_usergroup, 1];
[_usergroup, 1] setWaypointPosition [_newpos, 0];

_trgobj3 = createTrigger ["EmptyDetector", _newpos ];
_trgobj3 setTriggerActivation ["EAST", "NOT PRESENT", false];
_trgobj3 setTriggerArea [200, 200, 0, true];
_trgobj3 setTriggerStatements ["this", "sobj2 = true", ""];
_trgobj3 setTriggerTimeout [5, 10, 7, true ];

_search = createMarkerLocal ["look", _newpos];
_search setMarkerColorLocal "ColorGreen";
_search setMarkerShapeLocal "ELLIPSE";
_search setMarkerSizeLocal [200, 200];
_search setMarkerBrushLocal "FDiagonal";

_end = createMarkerLocal ["SAFE", _newpos];
_end setMarkerColorLocal "ColorYellow";
_end setMarkerTypeLocal "mil_destroy";
_end setMarkerTextLocal localize "EVO_040";

Waituntil {sobj2 or _usergroup != (group player) or not onmission}; //or if pilots dead
sleep 1.0;
if (_usergroup != (group player)) exitwith {[] call EVO_deletemsaar};
if (not onmission) exitwith {[] call EVO_deletemsaar};



[_usergroup, 1] setWaypointPosition [position player, 0];


deleteVehicle _trgobj1;
deleteVehicle _trgobj2;
deleteVehicle _trgobj3;
deleteMarkerLocal _search;
deleteMarkerLocal _end;
[_usergroup, 1] setWaypointDescription "MOVE";
sleep 60.0;

sleep 1.0;
_handle = [_guard] execVM "scripts\delete.sqf";
_handle = [_guardb] execVM "scripts\delete.sqf";
_handle = [_pilot] execVM "scripts\delete.sqf";