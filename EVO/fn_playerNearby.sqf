_object = _this select 0;
_distance = _this select 1;
_return = false;
_players = [];
{
  if (isPlayer _x && _x distance _object < _distance) then {
    _players pushback _x;
  };
} forEach playableUnits;

if (count _players > 0) then {
  _return = true;
};

_return
