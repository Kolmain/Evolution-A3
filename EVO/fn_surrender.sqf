private ["_unit","_grp","_players","_loop","_captured","_msg","_score"];

_unit = _this select 0;

[[[_unit], {
	_unit = _this select 0;
	_unit playMoveNow "AmovPercMstpSsurWnonDnon";
	_unit addAction [format["<t color='#CCCC00'>Capture %2 %1</t>", name _unit, rank _unit],"_this spawn EVO_fnc_capture",nil,1,false,true,"","side leader group _unit != WEST"];
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
_unit disableAI "ANIM";
_unit disableAI "FSM";
_result = [_unit, primaryWeapon _unit] call CBA_fnc_dropWeapon
_result = [_unit, secondaryWeapon _unit] call CBA_fnc_dropWeapon
_result = [_unit, handgunWeapon _unit] call CBA_fnc_dropWeapon
_unit setCaptive true;
_grp = createGroup side _unit;
[_unit] joinSilent _grp;
_players = true;
_loop = true;
while {_loop} do {
	_captured = false;
	_players = [_unit, 1000] call EVO_fnc_playersNearby;
	if (!_players || !alive _unit || (_unit distance powCamp < 50)) then {
		_loop = false;
	};
	if (isPlayer(leader group _unit) && !_captured) then {
		[[[_unit], {
			_unit = _this select 0;
			_unit switchMove "";
			_unit enableAI "ANIM";
			_unit enableAI "FSM";
		}], "BIS_fnc_spawn"] call BIS_fnc_MP;
		_captured = true;
	};
};
[[[_unit], {
	_unit = _this select 0;
	if (leader group _unit == player) then {
		_msg = format ["%2 %1 has been secured.", name _unit, rank _unit];
		playsound "goodjob";
		[player, 3] call bis_fnc_addScore;
		["PointsAdded",["You captured a POW.", 3]] call BIS_fnc_showNotification;
	};
}], "BIS_fnc_spawn"] call BIS_fnc_MP;

deleteVehicle _unit;