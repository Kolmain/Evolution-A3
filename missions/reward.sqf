_unit = _this select 0;
_reward = _this select 1;

//_debug = [] execVM format["misunit = %1 | reward = %2",_unit,_reward];

if (not (local _unit) or not (isPlayer _unit)) exitWith {};
[west,"HQ"] sideradio "UNIV_mcom";
_unit addscore _reward;
onmission = false;