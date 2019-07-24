_pos = _this select 0;
_overwatchPos = [_pos, 600, 200] call BIS_fnc_findOverwatch;
if (isNil "_overwatchPos") exitWith {};
_grp = createGroup EAST;
_class = EVO_opforSnipers call BIS_fnc_selectRandom;
_sniper = _grp createUnit [_class, _overwatchPos, [], 0, "NONE"];
_sniper doWatch _pos;
_grp setBehaviour "STEALTH";
_grp setCombatMode "RED";

{
	_x setSkill ["spotdistance", 1];
	_x setSkill ["aimingspeed", 1];
	_x setSkill ["aimingaccuracy", 0.9];
	_x setSkill ["aimingshake", 1];
	_x setSkill ["spottime", 0.8];
	_x setSkill ["commanding",1];
	_x setSkill ["general", 1];
	if (HCconnected) then {
		handle = [_x] call EVO_fnc_sendToHC;
	};
} foreach units _grp;