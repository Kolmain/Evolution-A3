private ["_pow","_capturer","_msg","_score"];
_pow = _this select 0;
_capturer = _this select 1;
_id = _this select 2;
[_pow] join _capturer;
_pow enableAI "ANIM";
_pow enableAI "FSM";
[[[_pow], {_this select 0 switchMove ""}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

if (_pow == currentTargetOF) then {
	[[[], {
		if (!isDedicated) then {
			_msg = format ["Colonel %1 has been found, extract him!", name currentTargetOF];
			["TaskUpdated",["OFFICER FOUND", _msg]] call BIS_fnc_showNotification;
			waitUntil {(currentTargetOF distance hqBox < 50)};
			_msg = format ["Colonel %1 has been secured.", name currentTargetOF];
			["TaskSucceeded",["OFFICER SECURED", _msg]] call BIS_fnc_showNotification;
			playsound "goodjob";
			[player, 5] call bis_fnc_addScore;
			["PointsAdded",["BLUFOR completed a mission objective.", 5]] call BIS_fnc_showNotification;
			if (leader group currentTargetOF == player) then {
				[player, 5] call bis_fnc_addScore;
				["PointsAdded",[format["You captured Colonel %1.", name currentTargetOF], 5]] call BIS_fnc_showNotification;
			};
		};
		if (isServer) then {
			[officerTask, "Succeeded", false] call bis_fnc_taskSetState;
			waitUntil {(currentTargetOF distance hqBox < 50)};
			sleep 5;
			deleteVehicle currentTargetOF;
		};
	}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
};

