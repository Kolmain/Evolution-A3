// convoyMove.sqf
// © APRIL 2013 - norrin
private ["_vcl","_markerArray","_convoyArray","_restartConvoy","_marker","_leadVcl","_groups","_markersRemaining","_aliveConvoy","_b","_c","_x","_convoyVclDestroyed","_loop","_loop1","_unit","_crew"];
_markerArray 		 	= _this select 0;
_convoyArray 		 	= _this select 1;
_restartConvoy			= _this select 2;
_convoyVclDestroyed  	= false;
_marker 			 	= _markerArray select 0;
_leadVcl 			 	= _convoyArray select 0;
_markersRemaining 	 	= _markerArray;
_groups 			 	= [];
_aliveConvoy 		 	= [];
_b 					 	= 0;
_c 					 	= 0;
{_x setVariable ["NORRN_convoyDestination",false,false];
 _x setSpeedMode "LIMITED";
 _x setBehaviour "CARELESS";
 _x doMove (getMarkerPos _marker);
 [_x, _markerArray, _convoyArray, _c] spawn Norrn_convoyMaxSpeed; 
 _c = _c + 1;
 _x setVariable ["Norrn_convoyMarkers",_markerArray, false];
} forEach _convoyArray;
_convoyVclDestroyed = false;
_c = 0;
while {!_convoyVclDestroyed} do {
  {if (!alive _x || !canMove _x || !isNull (_x findNearestEnemy (getPos _x)) || isNull driver _x || (_x getVariable "NORRN_convoyDestination")) then {_convoyVclDestroyed = true}} forEach _convoyArray;
	if (_convoyVclDestroyed) exitWith {};
	if (_leadVcl distance getMarkerPos _marker < 15) then {
		sleep 1;
		{_x doMove (getPos _x)} forEach _convoyArray;
		if (_b < (count _markerArray - 1)) then {		
			_markersRemaining - [_b];
			_b = _b + 1;
			_marker = _markerArray select _b;
			{_x doMove getMarkerPos _marker} forEach _convoyArray;
			_c = 0;
		};
	} else {
		if (_c == 0) then {
			{_x doMove getMarkerPos _marker} forEach _convoyArray;
		};
	};
	if (_c == 10) then {_c = 0} else {_c = _c + 1};
	sleep 0.5;
};
{if (canMove _x) then {_x setVariable ["NORRN_convoyDestination",true,false];_x doMove (getPos _x)}} forEach _convoyArray;
{if (alive _x && canMove _x) then {_aliveConvoy = _aliveConvoy + [_x]}} forEach _convoyArray;
sleep 2;
//If vehicle is not armoured then crew disembarks
for [{ _loop = 0 },{ _loop < count  _convoyArray},{ _loop = _loop + 1}] do {
	_vcl = _convoyArray select _loop;
	_groups = _groups + [(group _vcl)];
	_crew = crew _vcl;
	if (alive _vcl && !(_vcl isKindOf "Tank") && !(_vcl isKindOf "Helicopter")) then {
		while {speed _vcl > 2} do {sleep 0.5};
		for [{ _loop1 = 0 },{ _loop1 < count _crew},{ _loop1 = _loop1 + 1}] do {
			_unit = _crew select _loop1;
			_unit setVariable ["Norrn_convoyVclPos", (assignedVehicle _unit), false];
			if !((group _unit) in _groups) then {_groups = _groups + [(group _unit)]};
			if (_unit != gunner _vcl) then {
				_unit action ["GetOut", _vcl];
				[_unit] allowGetIn false;
			} else {
				_unit assignAsGunner _vcl;
			};
			sleep 0.1;
		};
		_vcl lockDriver true; 
	};
	sleep 0.1;
};
sleep 1;
{_x setBehaviour "Combat"} forEach _groups;
// Added for restarting the convoy once attack is over
[_markersRemaining,_aliveConvoy,_groups,_restartConvoy] spawn Norrn_convoyAmbush;