_obj = _this select 0;
_loop = true;
while {_loop} do {
    _players = [_obj, 1000] call EVO_fnc_playersNearby;
    if (!_players || !(alive _obj)) then {
        _loop = false;
    };
};

deleteVehicle _obj;