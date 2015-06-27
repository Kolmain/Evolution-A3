private ["_loop"];
_loop = true;
while {_loop} do {
  sleep 30;
  if (targetCounter == totalTargets) then {
   	_loop = false;
	if (("persistentEVO" call BIS_fnc_getParamValue) == 1) then {
		profileNamespace setVariable ["EVO_currentTargetCounter", 2];
		_scoreArray = [];
		profileNamespace setVariable ["EVO_scoreArray", _scoreArray];
		profileNamespace setVariable ["EVO_world", "nil"];
		saveProfileNamespace;
	};
    ["complete", true, true] call BIS_fnc_endMission;
  };
};
