_tskName = format ["Clear %1", currentTargetName];
attackTask = player createSimpleTask [_tskName];
attackTask setTaskState "Created";
attackTask setSimpleTaskDestination (getMarkerPos currentTargetMarkerName);
_tskName = format ["Destroy Radio Tower"];
towerTask = player createSimpleTask [_tskName, attackTask];
towerTask setTaskState "Assigned";
_tskName = format ["Secure Col. %1", name currentTargetOF];
officerTask = player createSimpleTask [_tskName, attackTask];
officerTask setTaskState "Created";
_type = "";
if (currentTargetType == "NameVillage") then {
	_type = "village";
} else {
	_type = "city";
};
_tskName = format ["Clear the %1 of %2.", _type, currentTargetName];
["TaskAssigned",["",_tskName]] call BIS_fnc_showNotification;
_tskName = format ["Capture Colonel %1.", name currentTargetOF];
["TaskAssigned",["",_tskName]] call BIS_fnc_showNotification;
_tskName = format ["Destroy %1's Radio Tower.", currentTargetName];
["TaskAssigned",["",_tskName]] call BIS_fnc_showNotification;