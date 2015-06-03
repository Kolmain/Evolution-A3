private ["_vehicle","_classname","_pos","_dir","_newVehicle"];

_vehicle = _this select 0;
_classname = typeOf _vehicle;
_pos = getPos _vehicle;
_dir = getDir _vehicle;
_loop = true;
while {_loop} do {
	sleep 60;
	if (!alive _vehicle || !canMove _vehicle || isNil "_vehicle") then {
		_loop = false;
	};
};

_newVehicle = _classname createVehicle _pos;
_newVehicle setDir _dir;
if (MHQ == _vehicle) then {
	_null = [_newVehicle] call EVO_fnc_mhq;
};
[_newVehicle] spawn EVO_fnc_basicRespawn;
deleteVehicle _vehicle;
