if (isPlayer _killer) then {
	if (_killer == player) then {
		if ((side _killed) != (side _killer)) then {
			_vis = lineIntersects [eyePos player, eyePos _killed, player, _killed];
				if (_killed isKindOf "Man" && typeOf _killed != "O_officer_F") then {
					//npc kill
					_score = _score + 1;
					_scoreToAdd = 1;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
					["PointsAdded",["NPC Kill", 1]] call BIS_fnc_showNotification;
					};
				};
				if (_killed isKindOf "Car") then {
					//support car
					_scoreToAdd = 5;
					_score = _score + 5;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
					["PointsAdded",["Wheeled Kill", 5]] call BIS_fnc_showNotification;
					};
				};
				if (_killed isKindOf "Tank") then {
					//support car
					_scoreToAdd = 7;
					_score = _score + 7;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
					["PointsAdded",["Tank Kill", 7]] call BIS_fnc_showNotification;
					};
				};
				if (_killed isKindOf "Helicopter") then {
					//transport kill
					_scoreToAdd = 7;
					_score = _score + 7;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
					["PointsAdded",["Helicopter Kill", 7]] call BIS_fnc_showNotification;
					};
				};
				if (_killed isKindOf "Plane") then {
					//support car
					_scoreToAdd = 8;
					_score = _score + 8;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
					["PointsAdded",["Wheeled Kill", 8]] call BIS_fnc_showNotification;
					};
				};
				if (typeOf _killed == "O_officer_F") then {
					//support car
					_scoreToAdd = -8;
					_score = _score - 8;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
					["PointsRemoved",["Officer Kill", 8]] call BIS_fnc_showNotification;
					};
				};
				if (typeOf _killed == "Land_Radar") then {
					//support car
					_scoreToAdd = 8;
					_score = _score + 8;
					_killer setVariable ["EVO_score", _score, true];
					if(!_vis) then {
					["PointsAdded",["Radar Tower Destroyed", 8]] call BIS_fnc_showNotification;
					};
				};
		} else {
			["PointsRemoved",["Friendly Fire Kill", 7]] call BIS_fnc_showNotification;
			_score = _score - 7;
			_scoreToAdd = -7;
			_killer setVariable ["EVO_score", _score, true];
		};
	} ;
};

[_killer, _scoreToAdd] call BIS_fnc_addScore;