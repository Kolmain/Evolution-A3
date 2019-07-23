private ["_object","_distance","_return","_players"];
_object = _this select 0;
_distance = _this select 1;
_return = false;
_players = [];
{
  if (_x distance _object < _distance) then {
    _players pushback _x;
  };
} forEach ([] call CBA_fnc_players);

if (count _players > 0) then {
  _return = true;
};

_return;
