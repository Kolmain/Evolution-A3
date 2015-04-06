_user = _this select 0;
_username = name _user;
_center = _this select 1;
_ggroup = _this select 2;
_pos = position _center;
_guardb = grpNull;
_usergroup = group _user;
_rndx = 0;
_rndy = 0;

waitUntil {_user in list _center or _username == dunit};

EVO_makeGb =
{

	_dir = round (random 3);
	if (_dir == 0) then //north
	{
		_rndx = random 400;
		_rndy = 400;
	};
	if (_dir == 1) then //south
	{
		_rndx = random 400;
		_rndy = 0;
		if (_center == abase3) then {hint"mad";_rndx = 0+(random 200);_rndy = 400};
	};	
	if (_dir == 2) then //east
	{
		_rndx = 400;
		_rndy = random 400;
		if (_center == abase3) then {hint"mad2";_rndx = 0;_rndy = 200+(random 200);};
	};
	if (_dir == 3) then //west
	{
		_rndx = 0;
		_rndy = random 400;		
	};

	_ppos = [(_pos select 0)-200 +_rndx,(_pos select 1)-200+_rndy,0];
	_guardb = createGroup (east);	
	_recy = [_user,_guardb] execVM "scripts\grecycle.sqf";
	
	_allunits = ["SquadLeaderE","SoldierEMG","SoldierEAT","SoldierESniper","SoldierEMedic","SoldierEB"];
	_max = count _allunits;	
	_allunits select (round random (_max - 1)) createUnit [_ppos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_ppos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_ppos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_ppos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_ppos, _guardb];
	_allunits select (round random (_max - 1)) createUnit [_ppos, _guardb];
	
	_wp1 = _guardb addWaypoint [_pos, 0];
	_dice = round (random 1);
	if (_dice == 1) then
	{
		_allvecA = ["UAZMG","BRDM2"];
		_maxA = count _allvecA;
		_heli2 = createVehicle [(_allvecA select round random (_maxA - 1)), _ppos, [], 0, "NONE"];
		[_heli2] call EVO_Lock;
		_heli2 addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}];
		(units _guardb select 0) assignAsDriver _heli2;
		(units _guardb select 0) moveInDriver _heli2;
		(units _guardb select 1) assignAsGunner _heli2;
		(units _guardb select 1) moveInGunner _heli2;	
	};
	{_x setCombatMode "RED";_x addEventHandler ["killed", {handle = [_this select 0] execVM "scripts\bury.sqf"}]} forEach (units _guardb);
};

[] call EVO_makeGb;

_count = 0;

for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	_lcount = 0;
	{if(alive _x) then {_lcount = _lcount +1}} forEach units _guardb;
	if ((vehicle _user) in list _center) then {_count = _count +1};
	if (_count == 240) then {_loop=1};
	//hint format["_guard %1",_lcount];
	sleep 1.001;
	//hint "";
	if(_lcount == 0) then {[] call EVO_makeGb};
	//if (_usergroup != (group _user)) then {_loop=1;};
	if (count units _ggroup == 0) then {_loop=1};
};

sleep 30.0;
_handle = [_guardb] execVM "scripts\delete.sqf";