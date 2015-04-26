// convoyAmbush.sqf
// © APRIL 2013 - norrin
private ["_markerArray","_convoyArray","_groups","_convoyUnits","_restartConvoy","_noEnemy","_leader","_enemy","_d","_groupsNotNull","_aliveConvoy","_posEnemy",
		 "_units","_grpNoTarget","_grpNoTarget2","_loop","_group","_x"];
if (!isServer) exitWith {};
_markerArray  	= _this select 0;
_convoyArray  	= _this select 1;
_groups		  	= _this select 2;
_restartConvoy	= _this select 3;
_noEnemy 	  	= false;
_leader 		= objNull;
_enemy 			= objNull; 
_d				= 0;
_groupsNotNull	= [];
_aliveConvoy	= [];
_posEnemy   	= [];
_units			= [];
_convoyUnits 	= [];
for [{_loop = 0},{_loop < count _groups},{_loop = _loop + 1}] do {
	_group = _groups select _loop;
	{doStop _x; _convoyUnits = _convoyUnits + [_x]}forEach units _group;
};
{_x setVariable ["NORRN_convoy_enemyDetected", [objNull, []], false]}forEach _convoyUnits;
_grpNoTarget 	= _groups;
_grpNoTarget2 	= _groups;
// While enemy units are detected
while {!_noEnemy} do {
	for [{_loop = 0},{_loop < count _grpNoTarget},{_loop = _loop + 1}] do {
		_group = _grpNoTarget select _loop;
		// if group detects enemy then SAD 
		if (_group != grpNull) then {	
			_leader = leader _group;
			_units  = units _group; 
			if (!isNull (_leader findNearestEnemy (getPos _leader))) then {	
				_enemy = _leader findNearestEnemy (getPos _leader);
				_posEnemy = getPos _enemy;
				{_x doMove _posEnemy} forEach _units;
				_grpNoTarget2 = _grpNoTarget2 - [_group];
				{_x setVariable ["NORRN_convoy_enemyDetected", [_enemy,_posEnemy], false]}forEach _units;
			};
			if (isNull ((_leader getVariable "NORRN_convoy_enemyDetected") select 0) && _d > 20) then {
				_grpNoTarget2 = _grpNoTarget2 - [_group];
			};
		} else {_grpNoTarget2 = _grpNoTarget2 - [_group]};
		sleep 0.01;
	};
	_grpNoTarget = _grpNoTarget2;
	_groupsNotNull = _groups;
	// if all groups do not detect any enemies then exit loop
	if (_d > 120) then {
		if (isNull _enemy) exitWith {_noEnemy = true};
		for [{_loop = 0},{_loop < count _groups},{_loop = _loop + 1}] do {
			_group = _groups select _loop;
			if (_group != grpNull) then {	
				_leader = leader _group;
				if (isNull(_leader findNearestEnemy (getPos _leader))) then {_groupsNotNull = _groupsNotNull - [_group]};
			} else {_groupsNotNull = _groupsNotNull - [_group]};
			sleep 0.01;
		};
	};
	if (count _groupsNotNull == 0) then {_noEnemy = true};
	_d = _d + 1;
	sleep 0.5;
};
if (!_restartConvoy) exitWith {};
{if (alive _x && canMove _x) then {_aliveConvoy = _aliveConvoy + [_x]}} forEach _convoyArray;
_groupsNotNull = [];
{if (_x != grpNull) then {_groupsNotNull = _groupsNotNull + [_x]}} forEach _groups;
[_markerArray,_aliveConvoy,_groupsNotNull,_restartConvoy] spawn Norrn_convoyRestart;









