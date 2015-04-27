// getIn.sqf
// © OCTOBER 2010 - norrin

private ["_vcl","_unit","_vclPos","_aliveVcls","_c","_emptyDriver","_emptyGunner","_emptyCargo"];

_vcl 		= _this select 0;
_unit		= _this select 1;
_vclPos		= _this select 2;
_aliveVcls	= _this select 3;
_c			= -1;

_unit doMove getPos _vcl; 

while {(_unit distance _vcl) > 10 && !(_unit getVariable "NORRN_convoy_restart")} do
{	
	_c = _c + 1;
	if (_c == 5) then {_c = 0; _unit doMove getPos _vcl}; 
	sleep 2;
};

if (_unit getVariable "NORRN_convoy_restart") exitWith {_unit doFollow (_aliveVcls select 0)};

[_unit] allowGetIn true;
if ("driver" in _vclPos && _unit == (_vcl getVariable "Norrn_Convoy_Driver")) then {_unit assignAsDriver _vcl; [_unit] orderGetIn true};
if ("cargo" in _vclPos)  then {_unit assignAsCargo _vcl; [_unit] orderGetIn true};
if ("gunner" in _vclPos && _unit == (_vcl getVariable "Norrn_Convoy_Gunner"))  then {_unit assignAsGunner _vcl; [_unit] orderGetIn true};

sleep 30;

if (vehicle _unit != _unit) exitWith {};
for [{ _loop = 0 },{ _loop < count  _aliveVcls},{ _loop = _loop + 1}] do
{	
	_vcl = _aliveVcls select _loop;
	while {!(_vcl getVariable "NORRN_convoy_allIn")} do {sleep 1};
	sleep (random 5);
	_emptyDriver  = _vcl emptyPositions "Driver";
	_emptyGunner  = _vcl emptyPositions "Gunner";
	_emptyCargo	  = _vcl emptyPositions "Cargo";
	if (_emptyDriver > 0 || _emptyGunner > 0 || _emptyCargo > 0) then 
	{
		if (_emptyDriver == 1) then {[_vcl, _unit, ["driver"],_aliveVcls] spawn Norrn_convoyGetIn};
		if (_emptyDriver == 0 && _emptyGunner == 1) then {[_vcl, _unit, ["gunner"],_aliveVcls] spawn Norrn_convoyGetIn};
		if (_emptyDriver == 0 && _emptyGunner == 0 && _emptyCargo > 0) then {[_vcl, _unit, ["cargo"],_aliveVcls] spawn Norrn_convoyGetIn};
	};
	sleep 0.1;
};
if(true) exitWith {};