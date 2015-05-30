_unit = _this select 0;

[[[_unit], {
	_unit = _this select 0;
	_unit playMoveNow "AmovPercMstpSsurWnonDnon";
	_unit addAction [format["<t color='#CCCC00'>Capture %2 %1</t>", name _unit, rank _unit],"_this spawn EVO_fnc_capture",nil,1,false,true,"","true"];
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
_unit disableAI "ANIM";
_unit disableAI "FSM";
_unit removeWeapon primaryWeapon _unit;
_unit removeWeapon secondaryWeapon _unit;
_unit removeWeapon handgunWeapon _unit;
_unit setCaptive true;
_grp = createGroup side _unit;
[_unit] joinSilent _grp;

_loop = true;
while {_loop} do {
	_players = [_unit, 1000] call EVO_fnc_playersNearby;
	if (!_players || !alive _unit || (_unit distance spawnBuilding < 50)) then {
		_loop = false;
	};
};
[[[_unit], {
	_unit = _this select 0;
	if (leader group _unit == player) then {
		_msg = format ["%2 %1 has been secured.", name _unit, rank _unit];
		playsound "goodjob";
		_score = player getVariable "EVO_score";
		_score = _score + 3;
		player setVariable ["EVO_score", _score, true];
		["PointsAdded",["You captured a POW.", 3]] call BIS_fnc_showNotification;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
deleteVehicle _unit;