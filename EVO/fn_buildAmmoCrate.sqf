_crate = _this select 0;
_EVOrank = _this select 1;

switch (_EVOrank) do {
    case "PRIVATE": {
   		availableWeapons = availableWeapons + rank1weapons;
		//availableMagazines = availableMagazines + rank1magazines;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;

    };
    case "CORPORAL": {
    	availableWeapons = availableWeapons + rank1weapons + rank2weapons;
		availableItems = availableItems + rank2items;
		//availableMagazines = availableMagazines + rank1magazines;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;

    };
    case "SERGEANT": {
		availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons;
		availableItems = availableItems + rank2items + rank3items;
		//availableMagazines = availableMagazines + rank1magazines;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "LIEUTENANT": {
    	availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "CAPTAIN": {
    	availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "MAJOR": {
    	availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank6weapons;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "COLONEL": {
    	availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank7weapons;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
};

[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;

{
	hqbox addBackpackCargo [_x, 1];
} forEach availableBackpacks;

[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;

{
	hqbox addItemCargo [_x, 1];
} forEach (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests);

[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;

{
	hqbox addMagazineCargo [_x, 100];
} forEach availableMagazines;

[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;

{
	hqbox addWeaponCargo [_x, 10];
} forEach availableWeapons;