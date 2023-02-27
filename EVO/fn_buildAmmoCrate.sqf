_crate = _this select 0;
_EVOrank = _this select 1;

switch (_EVOrank) do {
    case "PRIVATE": {
        availableWeapons = availableWeapons + rank1weapons;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
        availableItems = availableItems + rank1items;

    };
    case "CORPORAL": {
            availableWeapons = availableWeapons + rank1weapons + rank2weapons;
        availableItems = availableItems + rank1items + rank2items;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;

    };
    case "SERGEANT": {
        availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons;
        availableItems = availableItems + rank1items + rank2items + rank3items;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "LIEUTENANT": {
            availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons;
            availableItems = availableItems + rank1items + rank2items + rank3items + rank4items;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "CAPTAIN": {
            availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons;
        availableItems = availableItems + rank1items + rank2items + rank3items + rank4items + rank5items;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "MAJOR": {
            availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons + rank6weapons;
        availableItems = availableItems + rank1items + rank2items + rank3items + rank4items + rank5items + rank6items;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "COLONEL": {
            availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons + rank6weapons + rank7weapons;
        availableItems = availableItems + rank1items + rank2items + rank3items + rank4items + rank5items + rank6items;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    default {
        availableWeapons = availableWeapons + rank1weapons;
        availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
        availableItems = availableItems + rank1items;
    };
};


[_crate, ([_crate] call BIS_fnc_getVirtualWeaponCargo) , false] call BIS_fnc_removeVirtualWeaponCargo;
[_crate, ([_crate] call BIS_fnc_getVirtualMagazineCargo) , false] call BIS_fnc_removeVirtualMagazineCargo;
[_crate, ([_crate] call BIS_fnc_getVirtualBackpackCargo) , false] call BIS_fnc_removeVirtualBackpackCargo;
[_crate, ([_crate] call BIS_fnc_getVirtualItemCargo) , false] call BIS_fnc_removeVirtualItemCargo;

{
	_crate addMagazineCargo [_x, 100];
} forEach availableMagazines;

{
	_crate addWeaponCargo [_x, 5];
} forEach availableWeapons;

availableItems = availableItems + availableHeadgear + availableGoggles + availableUniforms + availableVests;

[_crate, availableWeapons, false, true] call BIS_fnc_addVirtualWeaponCargo;
[_crate, availableBackpacks, false, true] call BIS_fnc_addVirtualBackpackCargo;
[_crate, availableItems, false, true] call BIS_fnc_addVirtualItemCargo;
[_crate, availableMagazines, false, true] call BIS_fnc_addVirtualMagazineCargo;
