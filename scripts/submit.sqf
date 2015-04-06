//;{cap = [_x] execVM "scripts\submit.sqf"} forEach this list
rscripts=rscripts+1;
_unit = _this select 0;
_wep = weapons _unit;
_wepmax = count _wep;
_i = 0;
_grp = group _unit;

if (_unit distance (getmarkerpos "det") < 10) exitWith {};

//if(not (captive _unit)) then {_tag = _unit addaction ["Capture","actions\capture.sqf",0,1, true, true,"test2"]};
_tag = _unit addaction ["Capture","actions\capture.sqf",0,1, true, true,"test2"];

if(_tag > 0) exitWith {_unit removeaction _tag};//edit

if (local server) then
{
		_unit disableAI "TARGET";
		_unit disableAI "AUTOTARGET";
		_unit setBehaviour "Careless";
		removeallweapons _unit;
		_unit allowFleeing 0;
		commandStop _unit;
		sleep 4.0;
		_unit setCaptive true;
		_unit addEventHandler ["killed", {sop = (_this select 1);sot = (_this select 1);sor = -31;publicVariable "sop";publicVariable "sot";publicVariable "sor";(_this select 0) removealleventhandlers "killed"}]; //edit
};

WaitUntil {side (leader _unit) == west or not (alive _unit)}; //edit
_unit removeaction _tag;

if (local server) then
{
	for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
	{
		sleep 3.001;
		_wep = weapons _unit;
		_wepmax = count _wep;
		if (not alive _unit or (_unit distance getmarkerpos "det") < 10) then {_loop=1};
		if (_wepmax > 0) then {_loop=1};
		if (vehicle _unit distance vehicle leader _unit > 50) then {_loop=1};
	};
	if (count weapons _unit > 0 or vehicle _unit distance vehicle leader _unit > 50) then 
	{
		_grp = creategroup (east);
		[_unit] join _grp;
		_wp = _grp addWaypoint [getMarkerPos "mobj11", 0];
		_unit setCaptive false;
		_unit enableAI "TARGET";
		_unit enableAI "AUTOTARGET";
		_unit setBehaviour "COMBAT";
		_unit removealleventhandlers "killed";
	};
};
rscripts=rscripts-1;
