_vehicle = [_this, 0, objNull] call BIS_fnc_param;
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;
_nul = [_vehicle, 2, 200, 2, true] execVM "NSLVR\vehrespawn.sqf";