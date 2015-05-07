_unit = player;
_score = _unit getVariable "EVO_score";
_rank = _unit getVariable "EVOrank";
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
if (!(_pointsToSpend > -1)) then { _pointsToSpend = 0};
_pointsToSpend