private ["_loop"];
_loop = true;
while {_loop} do {
  sleep 300;
  if (targetCounter == totalTargets) then {
   	_loop = false;
    ["complete", true, true] call BIS_fnc_endMission;
  };
};
