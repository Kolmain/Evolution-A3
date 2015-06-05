private ["_grp"];
_grp = _this call BIS_fnc_spawnGroup;
{
	_x setSkill ["aimingspeed", 0.15];
	_x setSkill ["spotdistance", 0.15];
	_x setSkill ["aimingaccuracy", 0.15];
	_x setSkill ["aimingshake", 0.1];
	_x setSkill ["spottime", 0.5];
	_x setSkill ["spotdistance", 0.5];
	_x setSkill ["commanding", 0.5];
	_x setSkill ["general", 0.6];
	_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
	if (HCconnected) then {
		handle = [_x] call EVO_fnc_sendToHC;
	};
} foreach units _grp;

_grp;

