
 _colorWest = WEST call BIS_fnc_sideColor;
 _markers =  [["\A3\ui_f\data\map\markers\nato\b_hq.paa", _colorWest, getPos spawnBuilding, 1, 1, 0, "HQ", 0]];

if (("mhqParam" call BIS_fnc_getParamValue) == 1) then {
    _markers = _markers + [["\A3\ui_f\data\map\markers\nato\respawn_motor_ca.paa", _colorWest, getPos firstMHQ, 1, 1, 0, "Mobile HQ", 0]];
};

  [
        getPos spawnBuilding,
        "NATO Staging Area", // SITREP text
        100, // altitude
        100, // radius
        120, // viewing angle
        1, // movement
        _markers
    ] call BIS_fnc_establishingShot;

intro = false;

