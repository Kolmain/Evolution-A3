_killed = _this select 0;
_killer = _this select 1;
_unit = _killed;
_unit spawn mrg_fnc_unit_sfx_hit;

if (player distance _unit > 50) exitWith {};

_surfaceType = surfaceType (getPosATL _unit);
_time = time;

_obj = "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];
_obj attachTo [_unit,[0,0,1]];

_sound = switch (_surfaceType) do {
    case "#GdtStratisGreenGrass";
    case "#GdtGrassGreen": {mrg_unit_sfx_bodyfall_grass select floor random mrg_unit_sfx_bodyfall_grass_size};

    case "#GdtStratisThistles";
    case "#GdtStratisDryGrass";
    case "#GdtGrassDry": {mrg_unit_sfx_bodyfall_drygrass select floor random mrg_unit_sfx_bodyfall_drygrass_size};

    case "#GdtStratisDirt";
    case "#GdtDirt";
    case "#GdtStratisConcrete";
    case "#GdtConcrete";
    case default {mrg_unit_sfx_bodyfall_concrete select floor random mrg_unit_sfx_bodyfall_concrete_size};
};

//systemChat format["Killed | Process time: %1s", diag_tickTime - _sT];

waitUntil {(ASLToATL(eyePos _unit) select 2) < 0.8 || time > (_time + 2.5)};
_obj say _sound;

sleep 2;
deleteVehicle _obj;

//systemChat "done";
