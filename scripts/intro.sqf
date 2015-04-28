
 _colorWest = WEST call BIS_fnc_sideColor;
  [
        getPos spawnBuilding,
        "NATO Staging Area", // SITREP text
        100, // altitude
        100, // radius
        120, // viewing angle
        1, // movement
        [
            ["\A3\ui_f\data\map\markers\nato\b_hq.paa", _colorWest, getPos spawnBuilding, 1, 1, 0, "HQ", 0],
            ["\A3\ui_f\data\map\markers\nato\respawn_motor_ca.paa", _colorWest, getPos firstMHQ, 1, 1, 0, "Mobile HQ", 0]
        ]
    ] call BIS_fnc_establishingShot;


