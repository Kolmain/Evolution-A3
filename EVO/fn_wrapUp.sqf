private ["_obj","_currentTarget","_loop2","_loop","_start","_players","_allPlayers","_surrender"];



_obj = _this select 0;
//_currentTarget = _this select 1;

/*
_loop2 = true;
while {_loop2} do {
    sleep 5;
    if (currentTarget != _currentTarget) then {
    	_loop2 = false;
    }
    if (!alive _obj) exitWith {};
};
*/
_loop = true;
_start = true;
while {_loop && alive _obj} do {
	sleep 5;
	_players = 0;
    _allPlayers = [];
	{
		if (isPlayer _x) then
		{
			_allPlayers pushBack _x;
		};
	} forEach playableUnits;
    {
    	if (_x distance _obj) then {
    		_players = _players + 1;
    	};
    } forEach _allPlayers;
    if (_players == 0) then {
    	_loop = false;
    } else {
    	if (_start && _obj isKindOf "Man") then {
    		_start = false;
    		_surrender = [true, false] call BIS_fnc_selectRandom;
    		if (_surrender) then {
    			//surrender unit

    		};
    	};
	};
};

deleteVehicle _obj;