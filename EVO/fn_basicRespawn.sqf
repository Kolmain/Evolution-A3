private ["_vehicle","_classname","_pos","_dir","_newVehicle"];
_vehicle = _this select 0;


_classname = typeOf _vehicle;
_vehicle setVariable ["EVO_respawnPos", getPos _vehicle, true];
_vehicle setVariable ["EVO_respawnDir", getDir _vehicle, true];
waitUntil{!alive _vehicle || !canMove _vehicle};
sleep 60;
_pos = _vehicle getVariable "EVO_respawnPos";
_dir = _vehicle getVariable "EVO_respawnDir";
_newVehicle = _classname createVehicle _pos;
_newVehicle setDir _dir;
if (mhq == _vehicle) then {
	mhq = _newVehicle;
	handle= [_newVehicle, WEST] execVM "CHHQ.sqf";
};
if (alive _vehicle) then {_vehicle setDamage 1};
