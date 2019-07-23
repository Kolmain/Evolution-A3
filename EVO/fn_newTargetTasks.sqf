private ["_type","_tskDisplayName","_tskDescription","_pos"];
_type = "";
if (currentTargetType == "NameVillage") then {
	_type = "village";
} else {
	_type = "city";
};
_tskDisplayName = format ["Clear %1", currentTargetName];
attackTask = format ["%1_task", currentTargetName];
_tskDescription = format ["Clear the %1 of %2.", _type, currentTargetName];
[WEST, [attackTask], [_tskDescription, _tskDescription, currentTargetMarkerName], (getMarkerPos currentTargetMarkerName), 1, 2, true] call BIS_fnc_taskCreate;

_tskDisplayName = format ["Destroy Radio Tower"];
towerTask = format ["%1_RTtask", currentTargetName];
_pos = [position currentTarget , 100, 300, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
_tskDescription = format ["Destroy %1's communications tower. Until this is completed, SLA reinforcements will continue to arrive from %2.", currentTargetName, text (targetLocations select (targetCounter + 1))];
[WEST, [towerTask, attackTask], [_tskDescription, _tskDisplayName, currentTargetMarkerName], _pos, 1, 2, true] call BIS_fnc_taskCreate;

_tskDisplayName = format ["Capture Colonel %1", name currentTargetOF];
officerTask = format ["%1_OFtask", currentTargetName];
_pos = [position currentTarget , 100, 300, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
_tskDescription = format ["Find and capture Colonel %1. Once he is in custody at the staging base we will gather any intel we can and distribute it to our deployed units.", name currentTargetOF];
[WEST, [officerTask, attackTask], [_tskDescription, _tskDisplayName, currentTargetMarkerName], _pos, 1, 2, true] call BIS_fnc_taskCreate;

publicVariable "attackTask";
publicVariable "towerTask";
publicVariable "officerTask";