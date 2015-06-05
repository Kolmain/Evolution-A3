private ["_vehicle","_classname","_pos","_dir","_loop","_newVehicle","_null"];

_vehicle = [_this, 0, objNull] call BIS_fnc_param;
_mhq = [_this, 1, false] call BIS_fnc_param;
if (isNull "_vehicle") exitWith {["_vehicle can't be objNull."] call BIS_fnc_error};
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
deleteVehicle _vehicle;
_newVehicle = _classname createVehicle _pos;
_newVehicle setDir _dir;
if (_mhq) then {
	MHQ = _newVehicle;
	publicVariable "MHQ";
	_null = [_newVehicle] spawn EVO_fnc_mhq;
};
[_newVehicle] spawn EVO_fnc_basicRespawn;