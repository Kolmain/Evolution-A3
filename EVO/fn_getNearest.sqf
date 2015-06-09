private ["_pos","_list","_closest","_closestdist"];

_pos = _this select 0;
_list = _this select 1;
_closest = [];
_closestdist = 100000;
{
  if (_x distance _pos < _closestdist) then {
	_closest = getPos _x;
	_closestdist = _x distance _pos;
  };
} forEach _list;

_closest;