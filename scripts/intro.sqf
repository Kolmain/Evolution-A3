<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> origin/altis

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
            ["\A3\ui_f\data\map\markers\nato\respawn_inf_ca.paa", _colorWest, getPos ammoOfficer, 1, 1, 0, "Armory", 0],
            ["\A3\ui_f\data\map\markers\nato\respawn_motor_ca.paa", _colorWest, getPos firstMHQ, 1, 1, 0, "Mobile HQ", 0]
        ]
    ] call BIS_fnc_establishingShot;


/*
_RandomAroundMM =
	{
	private ["_pos","_xPos","_yPos","_a","_b","_dir","_angle","_mag","_nX","_nY","_temp"];

	_pos = _this select 0;
	_a = _this select 1;
	_b = _this select 2;

	_b = _b - _a;

	_xPos = _pos select 0;
	_yPos = _pos select 1;

	_dir = random 360;

	_mag = _a + (sqrt ((random _b) * _b));
	_nX = _mag * (sin _dir);
	_nY = _mag * (cos _dir);

	_pos = [_xPos + _nX, _yPos + _nY,0];

	_pos
	};

_mapSize = getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize");
_rds = _mapSize/2;
_mapC = [_rds,_rds];

_locs = nearestLocations [_mapC, ["NameLocal"],_rds * 1.42];

_mil = [];

	{
	if ((tolower (text _x)) in ["military"]) then
		{
		_mil set [(count _mil),_x]
		}
	}
foreach _locs;

	{
	_size = ((size _x) select 0) max ((size _x) select 1);

	_minefieldsAmount = 5;
	_buffor = 50;

	for "_i" from 1 to _minfieldsAmount do
		{
		_randomPosForMinefield = [(position _x),_size + _buffor,_size + 2 * _buffor] call _RandomAroundMM;

		//here code for spawning a minefield at "_randomPosForMinefield" position. Radius of minefield in this example should be lower than buffor value.
		}
	}
foreach _mil;
*/

<<<<<<< HEAD
=======
=======
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
>>>>>>> origin/altis
>>>>>>> origin/altis
