_pos = _this select 0;
_overwatchPos = [_pos, 600, 200] call BIS_fnc_findOverwatch;
if (isNil "_overwatchPos") exitWith {};
_grp = createGroup EAST;
_class = ["O_sniper_F", "O_ghillie_lsh_F", "O_ghillie_sard_F", "O_ghillie_ard_F"] call BIS_fnc_selectRandom;
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
	_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
	if (("hitFX" call BIS_fnc_getParamValue) == 1) then {
		_x addEventHandler ["killed", {
			//_this spawn EVO_fnc_deathFX;
			[_this,"EVO_fnc_deathFX", true] call BIS_fnc_MP;
		}];
		_x addEventHandler ["hit", {
			//_this spawn EVO_fnc_hitFX;
			[_this,"EVO_fnc_hitFX", true] call BIS_fnc_MP;
		}];
	};
	if (HCconnected) then {
		handle = [_x] call EVO_fnc_sendToHC;
	};
} foreach units _grp;