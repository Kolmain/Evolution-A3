_type = "";
if (currentTargetType == "NameVillage") then {
	_type = "village";
} else {
	_type = "city";
};
_tskDisplayName = format ["Clear %1", currentTargetName];
attackTask = format ["%1_task", currentTargetName];
_tskDescription = format ["Clear the %1 of %2", _type, currentTargetName];
[WEST, [attackTask], [_tskDescription, _tskDescription, currentTargetMarkerName], (getMarkerPos currentTargetMarkerName), 1, 2, true] call BIS_fnc_taskCreate;

_tskDisplayName = format ["Destroy %1's Radio Tower", currentTargetName];
towerTask = format ["%1_RTtask", currentTargetName];
[WEST, [towerTask, attackTask], [_tskDisplayName, _tskDisplayName, currentTargetMarkerName], (getMarkerPos currentTargetMarkerName), 1, 1, true] call BIS_fnc_taskCreate;

_tskDisplayName = format ["Capture Colonel %1", name currentTargetOF];
officerTask = format ["%1_OFtask", currentTargetName];
[WEST, [officerTask, attackTask], [_tskDisplayName, _tskDisplayName, currentTargetMarkerName], (getMarkerPos currentTargetMarkerName), 1, 2, true] call BIS_fnc_taskCreate;