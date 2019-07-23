_player = _this select 0;
_source = _this select 1;
_scoreToAdd = _this select 2;
_score = (score _player) + _scoreToAdd;
if (vehicle _player != _player && isPlayer driver vehicle _player) then {
	[driver vehicle _player, _scoreToAdd] call BIS_fnc_addScore;
};
if (vehicle _player != _player && isPlayer commander vehicle _player) then {
	[commander vehicle _player, _scoreToAdd] call BIS_fnc_addScore;
};