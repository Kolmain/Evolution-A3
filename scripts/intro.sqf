// set side colors
private ["_colorWest", "_colorEast"];
_colorWest = WEST call BIS_fnc_sideColor;
_colorEast = EAST call BIS_fnc_sideColor;
// set transparency for colors
{_x set [3, 0.73]} forEach [_colorWest, _colorEast];
[
    markerPos "respawn_west", // Target position (replace MARKERNAME)
    "", // SITREP text
    400,                    // 400m altitude
    200,                    // 200m radius
    0,                      // 0 degrees viewing angle
    1,                      // Clockwise movement
    [   // add Icon at player's position
        ["\a3\ui_f\data\map\markers\nato\b_inf.paa", _colorWest, getPos player, 1, 1, 0, "Staging Area", 0],
    ]