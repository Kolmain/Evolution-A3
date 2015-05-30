private ["_obj","_currentTarget","_loop2","_loop","_start","_players","_allPlayers","_surrender"];



_obj = _this select 0;
_loop = true;
while {_loop} do {
    _players = [_unit, 1000] call EVO_fnc_playersNearby;
    if (!_players || !alive _unit) then {
        _loop = false;
    };
};

deleteVehicle _obj;