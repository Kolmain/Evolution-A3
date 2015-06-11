_player = _this select 0;
_source = _this select 1;
_scoreToAdd = _this select 2;
_score = (score _player) + _scoreToAdd;
_player setVariable ["EVO_score", _score, true];
_vis = lineIntersects [eyePos _player, eyePos _source, _player, _source];
_notify = true;
if (vehicle _player != _player && isPlayer driver vehicle _player) then {
	[driver vehicle _player, _scoreToAdd] call BIS_fnc_addScore;
};
if (vehicle _player != _player && isPlayer commander vehicle _player) then {
	[commander vehicle _player, _scoreToAdd] call BIS_fnc_addScore;
};
if (("killNotificationParam " call BIS_fnc_getParamValue) == 0) then {
	_notify = false;
} else {
	_notify = true;
};
if(!_vis) then {
	_displayName = (getText(configFile >>  "CfgVehicles" >>  (typeOf _killed) >> "displayName"));
	_fLetter = _displayName select [0,1];
	_fLetter = toUpper(_fLetter);
	_pre = if (_fLetter in ["A", "E", "I", "O", "U"]) then {"an"} else {"a"};
	_string = format["You killed %1 %2.", _pre, _displayName];
	if (_notify) then {
		[[[_string, _scoreToAdd, _killer], {
			if (_this select 1 > 0) then {
				if (player == _this select 2) then {["PointsAdded",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
			} else {
				if (player == _this select 2) then {["PointsRemoved",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
			};
		}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
	};
};