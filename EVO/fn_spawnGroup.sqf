private ["_grp"];
_grp = _this call BIS_fnc_spawnGroup;
{
	_x setSkill ["spotdistance", 0.7];
	_x setSkill ["aimingspeed", 0.2];
	_x setSkill ["aimingaccuracy", 0.3];
	_x setSkill ["aimingshake", 0.15];
	_x setSkill ["spottime", 0.4];
	_x setSkill ["commanding", 0.8];
	_x setSkill ["general", 0.8];
	_x addPrimaryWeaponItem "acc_flashlight";
	if (HCconnected) then {
		handle = [_x] call EVO_fnc_sendToHC;
	};
} foreach units _grp;

_grp;

