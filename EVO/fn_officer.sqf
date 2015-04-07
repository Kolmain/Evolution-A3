_officer = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_grp = group _officer;
_officer join _caller;

[[[], {
	if (!isServer || !isMultiplayer) then {
		_msg = format ["Colonel %1 has been found, extract him!", name _officer];
		["TaskUpdated",["OFFICER FOUND", _msg]] call BIS_fnc_showNotification;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

waitUntil {(_officer distance (getMarkerPos det) < 50)};
handle = [] spawn {
	waitUntil {!alive currentTargetOF};
	sleep 1;
	if (!aliveOfficer) then {
		officerTask setTaskState "Failed";
		_msg = format ["Colonel %1 has been killed.", name _officer];
		["TaskFailed",["OFFICER KIA", _msg]] call BIS_fnc_showNotification;
	};
};

_officer join _grp;

[[[], {
	if (!isServer || !isMultiplayer) then {
			officerTask setTaskState "Succeeded";
			_msg = format ["Colonel %1 has been secured.", name _officer];
			["TaskSucceeded",["OFFICER SECURED", _msg]] call BIS_fnc_showNotification;
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

deleteVehicle _officer;
deleteGroup _grp;
