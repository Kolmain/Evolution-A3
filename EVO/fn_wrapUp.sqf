private ["_obj","_loop","_players","_veh"];
_obj = _this select 0;
_loop = true;
while {_loop} do {
    _players = [_obj, 1000] call EVO_fnc_playersNearby;
    if (!_players || !(alive _obj)) then {
        _loop = false;
    };
};

_veh = vehicle _obj;
sleep 30;
deleteVehicle _obj;
{
	deleteVehicle _x;
} forEach crew _veh;
deleteVehicle _veh;