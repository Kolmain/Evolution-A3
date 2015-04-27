// convoyRestart.sqf
// © APRIL 2013 - norrin
private ["_markerArray","_convoyArray","_groups","_restartConvoy","_onboardUnits","_group","_units","_vcl","_unit","_vclPosMrkr","_vclPosMrkrPos","_wp","_wp1","_wp2",
		 "_loop","_x"];
// Passed vars
_markerArray  	= _this select 0;
_convoyArray  	= _this select 1;
_groups		  	= _this select 2;
_restartConvoy	= _this select 3;
// Other vars
_onboardUnits	= [];
// Set behaviour chilled
{_x setBehaviour "SAFE"}forEach _groups;
// Foot units return to their vehicles
hintSilent "Rejoin convoy";
for [{_loop = 0},{_loop < (count _groups)},{_loop = _loop + 1}] do {
	_group = _groups select _loop;
	if (count units _group > 0) then {
		_units = units _group;
		{unAssignVehicle _x; [_x] allowGetIn false; doStop _x}forEach _units;
		sleep 1;
		_unit = (units _group) select 0;
		_vcl = _unit getVariable "Norrn_convoyVclPos";
		if (canMove _vcl) then {
			_vcl lockDriver false;
			_vclPosMrkr = createMarkerLocal [format ["mrkr_%1",_vcl],getPos _vcl];
			_vclPosMrkr setMarkerTypeLocal "Empty"; 
			_vclPosMrkrPos = getMarkerPos _vclPosMrkr;
			_wp = _group addWayPoint [_vclPosMrkrPos,20];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "FULL"; 
			_wp1 = _group addWayPoint [_vclPosMrkrPos,20];
			_wp1 setWaypointType "GETIN NEAREST";
			_wp1 setWaypointSpeed "FULL"; 
			_wp2 = _group addWayPoint [_vclPosMrkrPos,20];
			_wp2 setWaypointType "HOLD";
			_wp2 setWaypointSpeed "LIMITED";
			{if (alive _x and canMove _x) then {_onboardUnits = _onboardUnits + [_x]}}forEach _units;
			_units allowGetIn true;
		};
	};
	sleep 0.1;
};
hintSilent "";
_c = count _onboardUnits;
if (_c > 0) then {
	// WaitUntil all units have boarded
	while {_c > 0} do {
		_c = 0;
		{if (vehicle _x == _x) then {_c = _c + 1}} forEach _onboardUnits;
		{doStop _x; _x setSpeedMode "LIMITED"} forEach _convoyArray;
		sleep 3;
	};
};
hintSilent "Move out";
// If vehicles still alive then restart convoy 
if (count _convoyArray > 0) then {	
	[_markerArray,_convoyArray,_restartConvoy] spawn Norrn_convoyMove;
};
sleep 5;
hintSilent "";