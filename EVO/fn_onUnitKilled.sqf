private ["_killed","_killer","_scoreToAdd","_score","_notify","_vis","_displayName","_fLetter","_pre","_string"];
_killed = _this select 0;
_killer = _this select 1;
_scoreToAdd = 0;
_score = 0;
_notify = true;
_vis = lineIntersects [eyePos _killer, eyePos _killed, _killer, _killed];
_string = "";
if (("killNotificationParam " call BIS_fnc_getParamValue) == 0) then {
	_notify = false;
} else {
	_notify = true;
};
if (isPlayer _killer || isPlayer (leader group _killer)) then {
	if (isPlayer _killer && vehicle _killer != _killer && isPlayer driver vehicle _killer) then {
		[_killed, driver vehicle _killer] spawn EVO_fnc_onUnitKilled;
	};
	if (isPlayer _killer && vehicle _killer != _killer && isPlayer commander vehicle _killer) then {
		[_killed, commander vehicle _killer] spawn EVO_fnc_onUnitKilled;
	};
	if (!isPlayer _killer) then {_killer = leader group _killer};
	_score = _killer getVariable "EVO_score";
	if (true) then {
		if ((side _killed) != (side _killer) && (side _killed != civilian)) then {
				if (_killed isKindOf "Man" && toLower(typeOf _killed) != toLower("O_officer_F")) then {
					//npc kill
					_score = _score + 1;
					_scoreToAdd = 1;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
						_displayName = (getText(configFile >>  "CfgVehicles" >>  (typeOf _killed) >> "displayName"));
						_fLetter = _displayName select [0,1];
						_fLetter = toUpper(_fLetter);
						_pre = if (_fLetter in ["A", "E", "I", "O", "U"]) then {"an"} else {"a"};
						_string = format["You killed %1 %2.", _pre, _displayName];
						if (_notify) then {
						    [[[_string, _scoreToAdd, _killer], {
						        if (player == _this select 2) then {["PointsAdded",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
						    }], "BIS_fnc_spawn", true] call BIS_fnc_MP;
						};
					};
				};
				if (_killed isKindOf "Car") then {
					//support car
					_scoreToAdd = 5;
					_score = _score + 5;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
						_displayName = (getText(configFile >>  "CfgVehicles" >>  (typeOf _killed) >> "displayName"));
						_fLetter = _displayName select [0,1];
						_fLetter = toUpper(_fLetter);
						_pre = if (_fLetter in ["A", "E", "I", "O", "U"]) then {"an"} else {"a"};
						_string = format["You killed %1 %2.", _pre, _displayName];
						if (_notify) then {
						    [[[_string, _scoreToAdd, _killer], {
						        if (player == _this select 2) then {["PointsAdded",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
						    }], "BIS_fnc_spawn", true] call BIS_fnc_MP;
						};
					};
				};
				if (_killed isKindOf "Tank") then {
					//support car
					_scoreToAdd = 7;
					_score = _score + 7;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
						_displayName = (getText(configFile >>  "CfgVehicles" >>  (typeOf _killed) >> "displayName"));
						_fLetter = _displayName select [0,1];
						_fLetter = toUpper(_fLetter);
						_pre = if (_fLetter in ["A", "E", "I", "O", "U"]) then {"an"} else {"a"};
						_string = format["You killed %1 %2.", _pre, _displayName];
						if (_notify) then {
						    [[[_string, _scoreToAdd, _killer], {
						        if (player == _this select 2) then {["PointsAdded",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
						    }], "BIS_fnc_spawn", true] call BIS_fnc_MP;
						};
					};
				};
				if (_killed isKindOf "Helicopter") then {
					//transport kill
					_scoreToAdd = 7;
					_score = _score + 7;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
						_displayName = (getText(configFile >>  "CfgVehicles" >>  (typeOf _killed) >> "displayName"));
						_fLetter = _displayName select [0,1];
						_fLetter = toUpper(_fLetter);
						_pre = if (_fLetter in ["A", "E", "I", "O", "U"]) then {"an"} else {"a"};
						_string = format["You killed %1 %2.", _pre, _displayName];
						if (_notify) then {
						    [[[_string, _scoreToAdd, _killer], {
						        if (player == _this select 2) then {["PointsAdded",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
						    }], "BIS_fnc_spawn", true] call BIS_fnc_MP;
						};
					};
				};
				if (_killed isKindOf "Plane") then {
					//support car
					_scoreToAdd = 8;
					_score = _score + 8;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
						_displayName = (getText(configFile >>  "CfgVehicles" >>  (typeOf _killed) >> "displayName"));
						_fLetter = _displayName select [0,1];
						_fLetter = toUpper(_fLetter);
						_pre = if (_fLetter in ["A", "E", "I", "O", "U"]) then {"an"} else {"a"};
						_string = format["You killed %1 %2.", _pre, _displayName];
						if (_notify) then {
						    [[[_string, _scoreToAdd, _killer], {
						        if (player == _this select 2) then {["PointsAdded",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
						    }], "BIS_fnc_spawn", true] call BIS_fnc_MP;
						};
					};
				};
				if (toLower(typeOf _killed) == toLower("O_officer_F")) then {
					//support car
					_scoreToAdd = -5;
					_score = _score - 5;
					_killer setVariable ["EVO_score", _score, true];
					[[[], {
						if (player == _killer) then {["PointsRemoved",["You killed the OPFOR Officer.", 5]] call BIS_fnc_showNotification};
					}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
				};
				if (toLower(typeOf _killed) == toLower("Land_Communication_F")) then {
					//support car
					_scoreToAdd = 8;
					_score = _score + 8;
					_killer setVariable ["EVO_score", _score, true];
					_string = format["You destroyed the %1.", (getText(configFile >>  "CfgVehicles" >>  (typeOf _killed) >> "displayName"))];
					[[[_string, _scoreToAdd, _killer], {
							if (player == _this select 2) then {["PointsAdded",[(_this select 0), (_this select 1)]] call BIS_fnc_showNotification};
					}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
				};
		} else {
			[[[_string, _scoreToAdd, _killer], {
				if (player == _killer) then {["PointsRemoved",["Friendly Fire Kill", 7]] call BIS_fnc_showNotification};
			}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
			_score = _score - 7;
			_scoreToAdd = -7;
			if (_score < 0) then {
				_subScore = 0 - _score;
				_scoreToAdd = _scoreToAdd + _subScore;
				_score = 0;
			};
			_killer setVariable ["EVO_score", _score, true];
		};
	} ;
};

[_killer, _scoreToAdd] call BIS_fnc_addScore;

false
