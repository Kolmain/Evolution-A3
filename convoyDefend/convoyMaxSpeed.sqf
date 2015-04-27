// convoyMaxSpeed.sqf 
// © APRIL 2013 - norrin
private ["_vcl","_markerArray","_convoyArray","_c","_count","_vcl2","_vcl3","_dir"]; 
_vcl 			= _this select 0;
_markerArray 	= _this select 1;
_convoyArray	= _this select 2;
_c 				= _this select 3;
_count 			= count _convoyArray;
_vcl2 			= objNull;
_vcl3 			= objNull; 
if (!local _vcl) exitWith {};
//added to halt convoy at destination
_destinationEnd = _markerArray select ((count _markerArray) -1);
if (_c < (_count -2)) then {_vcl2 = _convoyArray select (_c + 1)};
if (_c > 0) then {_vcl3 = _convoyArray select (_c - 1)};    		
while {alive _vcl && !(_vcl getVariable "NORRN_convoyDestination")} do { 	
	if (_vcl distance getMarkerPos _destinationEnd < 10) then {_vcl setVariable ["NORRN_convoyDestination",true, false]};
	_aliveConvoy	= [];
	{if (canMove _x && isNull (_x findNearestEnemy (getPos _x))) then {_aliveConvoy = _aliveConvoy + [_x]}} forEach _convoyArray;
	if ((count _aliveConvoy) < _count) exitWith {_vcl setVariable ["NORRN_convoyDestination",true, false]};
	if (!isNull _vcl2) then {	
		if (speed _vcl > 50) then {	
			_vcl setVelocity [(11 * (sin getDir _vcl)), (11 * (cos getDir _vcl)), velocity _vcl select 2];
		};
		while {_vcl distance _vcl2 > 60} do {	
			_dir = getDir _vcl;
			if (_vcl distance _vcl2 <= 100) then {
				if (((sin _dir) * (velocity _vcl select 0)) > 3) then {_vcl setVelocity [(velocity _vcl select 0) - (1 * (sin _dir)), (velocity _vcl select 1), velocity _vcl select 2]};
				if (((cos _dir) * (velocity _vcl select 1)) > 3) then {_vcl setVelocity [(velocity _vcl select 0), (velocity _vcl select 1) - (1 * (cos _dir)), velocity _vcl select 2]};
			} else {
				if (((sin _dir) * (velocity _vcl select 0)) > 1) then {_vcl setVelocity [(velocity _vcl select 0) - (2 * (sin _dir)), (velocity _vcl select 1), velocity _vcl select 2]};
				if (((cos _dir) * (velocity _vcl select 1)) > 1) then {_vcl setVelocity [(velocity _vcl select 0), (velocity _vcl select 1) - (2 * (cos _dir)), velocity _vcl select 2]};
			};
			sleep 0.1;
		};
	};
	if (!isNull _vcl3) then	{
		while {_vcl distance _vcl3 < 40} do {	
			_dir = getDir _vcl;
			if (((sin _dir) * (velocity _vcl select 0)) > 1) then {_vcl setVelocity [(velocity _vcl select 0) - (2 * (sin _dir)), (velocity _vcl select 1), velocity _vcl select 2]};
			if (((cos _dir) * (velocity _vcl select 1)) > 1) then {_vcl setVelocity [(velocity _vcl select 0), (velocity _vcl select 1) - (2 * (cos _dir)), velocity _vcl select 2]};
			sleep 0.1;
		};
	};
	sleep 0.1;
};
_vcl doMove getPos _vcl; 
//_vcl stop true;
sleep 4;
_dir = getDir _vcl;
_vcl setVariable ["NORRN_convoy_restartPos", [(getPos _vcl), (getDir _vcl)], false];
sleep 1;
//_vcl stop false;