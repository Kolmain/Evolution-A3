private ["_vehicle","_classname","_pos","_dir","_newVehicle"];

_vehicle = _this select 0;
_classname = typeOf _vehicle;
_vehicle setVariable ["EVO_respawnPos", getPos _vehicle, true];
_vehicle setVariable ["EVO_respawnDir", getDir _vehicle, true];
_loop = true;
while {_loop} do {
	sleep 60;
	if (!alive _vehicle || !canMove _vehicle) then {
		_loop = false;
	};
};
_pos = _vehicle getVariable "EVO_respawnPos";
_dir = _vehicle getVariable "EVO_respawnDir";
_newVehicle = _classname createVehicle _pos;
_newVehicle setDir _dir;
if (MHQ == _vehicle) then {
	_null = [_newVehicle] call EVO_fnc_mhq;
};
[_newVehicle] spawn EVO_fnc_basicRespawn;
deleteVehicle _vehicle;
