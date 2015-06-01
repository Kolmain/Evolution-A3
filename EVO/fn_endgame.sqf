while (true) do {
  sleep 30;
  if (targetCounter == totalTargets) then {
    ["complete", true, true] call BIS_fnc_endMission;
  };
};
