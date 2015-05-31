_obj = _this select 0;
_loop = true;
while {_loop} do {
    _players = [_obj, 1000] call EVO_fnc_playersNearby;
    if (!_players || !(alive _obj)) then {
        _loop = false;
    };
};

_veh = obj
if (vehicle _obj != _obj) then {_veh = vehicle _obj};
deleteVehicle _obj;
deleteVehicle _veh;