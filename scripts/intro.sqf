
 _colorWest = WEST call BIS_fnc_sideColor;
 _markers =  [["\A3\ui_f\data\map\markers\nato\b_hq.paa", _colorWest, getPos spawnBuilding, 1, 1, 0, "HQ", 0]];

  [
        getPos spawnBuilding,
        "US Base", // SITREP text
        100, // altitude
        100, // radius
        120, // viewing angle
        1, // movement
        _markers
    ] call BIS_fnc_establishingShot;

intro = false;

