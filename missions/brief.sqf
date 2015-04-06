_unit = _this select 0;
_brief = _this select 1;

if (not (local _unit) or not (isPlayer _unit)) exitWith {};
//hint localize _brief;
[west,"HQ"] sideradio "UNIV_rcoy";