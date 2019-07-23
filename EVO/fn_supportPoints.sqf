private ["_unit","_score","_rank","_minimum","_pointsToSpend"];

_unit = player;
_score = score _unit;
_rank = rank _unit;
_minimum = 0;
switch (_rank) do {
    case "PRIVATE": {
    	_minimum = 0;
    };
    case "CORPORAL": {
    	_minimum = rank1;
    };
    case "SERGEANT": {
    	_minimum = rank2;
    };
    case "LIEUTENANT": {
    	_minimum = rank3;
    };
    case "CAPTAIN": {
    	_minimum = rank4;
    };
    case "MAJOR": {
    	_minimum = rank5;
    };
    case "COLONEL": {
    	_minimum = rank6;
    };
    default {
     	_minimum = 0;
    };
};
_pointsToSpend = _score - _minimum;
if (_pointsToSpend < 0) then { _pointsToSpend = 0};
_pointsToSpend;