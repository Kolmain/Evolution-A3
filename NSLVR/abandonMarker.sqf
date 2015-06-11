_veh = _this select 0;
_timeout = _this select 1;
_group = _this select 2;


_vehIcon = getText (configFile >> "cfgvehicles" >> typeOf _veh >> "icon");
["vehDesertion",[_timeout,_vehIcon,_group]] call BIS_fnc_showNotification;

_markerName = format ["NSLVR_%1", _veh];
_abandondMarker = createMarkerLocal[ _markerName , getPosATL _veh];
_abandondMarker setMarkerShapeLocal "ICON";
_abandondMarker setMarkerTypeLocal "respawn_motor";
_abandondMarker setMarkerTextLocal "Abandond Vehicle";

_timeout = _timeout + time;
while {time < _timeout} do {
	_abandondMarker setMarkerAlphaLocal (time mod 2);
	sleep 0.1;
};

deleteMarkerLocal _abandondMarker;
