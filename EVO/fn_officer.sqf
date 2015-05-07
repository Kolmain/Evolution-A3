private ["_officer","_caller","_grp","_msg","_score"];


_officer = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_grp = group currentTargetOF;
[currentTargetOF] join _caller;

[[[_grp], {
	if (!isDedicated) then {
		_msg = format ["Colonel %1 has been found, extract him!", name currentTargetOF];
		["TaskUpdated",["OFFICER FOUND", _msg]] call BIS_fnc_showNotification;
		waitUntil {(currentTargetOF distance spawnBuilding < 50)};
		officerTask setTaskState "Succeeded";
		_msg = format ["Colonel %1 has been secured.", name currentTargetOF];
		["TaskSucceeded",["OFFICER SECURED", _msg]] call BIS_fnc_showNotification;
		playsound "goodjob";
		_score = player getVariable "EVO_score";
		_score = _score + 5;
		player setVariable ["EVO_score", _score, true];
		["PointsAdded",["BLUFOR completed a mission objective.", 5]] call BIS_fnc_showNotification;
		if (leader group currentTargetOF == player) then {
			_score = player getVariable "EVO_score";
			_score = _score + 5;
			player setVariable ["EVO_score", _score, true];
			["PointsAdded",[format["You captured Colonel %1.", name currentTargetOF], 5]] call BIS_fnc_showNotification;
		};
	};
	if (isServer) then {
		waitUntil {(currentTargetOF distance spawnBuilding < 50)};
		sleep 5;
		deleteVehicle currentTargetOF;
		deleteGroup _this select 0;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;


