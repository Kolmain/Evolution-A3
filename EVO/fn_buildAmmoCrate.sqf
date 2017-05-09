private ["_crate","_EVOrank"];
_crate = _this select 0;
_EVOrank = _this select 1;
if (("fullArsenal" call BIS_fnc_getParamValue) == 0) exitWith {};

switch (_EVOrank) do {
  case "PRIVATE": {
    availableBackpacks = bprank0;
    switch (typeOf player) do {
      case "B_medic_F";
      case "B_engineer_F";
      case "B_Soldier_F": {
        availableWeapons = sorank0weap;
        availableItems = commonitems + baserank0items + baserank0gear;
      };
      case "B_soldier_AT_F": {
        availableWeapons = atrank0weap;
        availableItems = commonitems + baserank0items + baserank0gear;
      };
      case "B_sniper_F": {
        availableWeapons = snrank0weap;
        availableItems = commonitems + sniperrank0items + baserank0gear;
      };
      case "B_soldier_AR_F": {
        availableWeapons = arrank0weap;
        availableItems = commonitems + baserank0items + baserank1gear;
      };
      case "B_crew_F": {
        availableWeapons = crank0weap;
        availableItems = commonitems + crewrank0items;
      };
      case "B_Helipilot_F": {
        availableWeapons = prank0weap;
        availableItems = commonitems + pilotrank0items;
      };
    };
  };
  case "CORPORAL": {
    availableBackpacks = bprank0;
    switch (typeOf player) do {
      case "B_medic_F";
      case "B_engineer_F";
      case "B_Soldier_F": {
        availableWeapons = sorank1weap;
        availableItems = commonitems + baserank1items + baserank1gear;
      };
      case "B_soldier_AT_F": {
        availableWeapons = atrank1weap;
        availableItems = commonitems + baserank1items + baserank1gear;
      };
      case "B_sniper_F": {
        availableWeapons = snrank1weap;
        availableItems = commonitems + sniperrank1items + baserank1gear;
      };
      case "B_soldier_AR_F": {
        availableWeapons = arrank1weap;
        availableItems = commonitems + baserank1items + baserank2gear;
      };
      case "B_crew_F": {
        availableWeapons = crank1weap;
        availableItems = commonitems + crewrank0items;
      };
      case "B_Helipilot_F": {
        availableWeapons = prank1weap;
        availableItems = commonitems + pilotrank0items;
      };
    };
  };
  case "SERGEANT": {
    availableBackpacks = bprank0;
    switch (typeOf player) do {
      case "B_medic_F";
      case "B_engineer_F";
      case "B_Soldier_F": {
        availableWeapons = sorank2weap;
        availableItems = commonitems + baserank2items + baserank2gear;
      };
      case "B_soldier_AT_F": {
        availableWeapons = atrank2weap;
        availableItems = commonitems + baserank2items + baserank2gear;
      };
      case "B_sniper_F": {
        availableWeapons = snrank2weap;
        availableItems = commonitems + sniperrank2items + baserank2gear;
      };
      case "B_soldier_AR_F": {
        availableWeapons = arrank2weap;
        availableItems = commonitems + baserank2items + baserank3gear;
      };
      case "B_crew_F": {
        availableWeapons = crank2weap;
        availableItems = commonitems + crewrank0items;
      };
      case "B_Helipilot_F": {
        availableWeapons = prank2weap;
        availableItems = commonitems + pilotrank0items;
      };
    };
  };
  case "LIEUTENANT": {
    availableBackpacks = bprank0 + bprank1;
    switch (typeOf player) do {
      case "B_medic_F";
      case "B_engineer_F";
      case "B_Soldier_F": {
        availableWeapons = sorank3weap;
        availableItems = commonitems + baserank3items + baserank3gear;
      };
      case "B_soldier_AT_F": {
        availableWeapons = atrank3weap;
        availableItems = commonitems + baserank3items + baserank3gear;
      };
      case "B_sniper_F": {
        availableWeapons = snrank3weap;
        availableItems = commonitems + sniperrank3items + baserank3gear;
      };
      case "B_soldier_AR_F": {
        availableWeapons = arrank3weap;
        availableItems = commonitems + baserank3items + baserank4gear;
      };
      case "B_crew_F": {
        availableWeapons = crank3weap;
        availableItems = commonitems + crewrank0items;
      };
      case "B_Helipilot_F": {
        availableWeapons = prank3weap;
        availableItems = commonitems + pilotrank0items;
      };
    };
  };
  case "CAPTAIN": {
    availableBackpacks = bprank0 + bprank1;
    switch (typeOf player) do {
      case "B_medic_F";
      case "B_engineer_F";
      case "B_Soldier_F": {
        availableWeapons = sorank4weap;
        availableItems = commonitems + baserank4items + baserank4gear;
      };
      case "B_soldier_AT_F": {
        availableWeapons = atrank4weap;
        availableItems = commonitems + baserank4items + baserank4gear;
      };
      case "B_sniper_F": {
        availableWeapons = snrank4weap;
        availableItems = commonitems + sniperrank4items + baserank4gear;
      };
      case "B_soldier_AR_F": {
        availableWeapons = arrank4weap;
        availableItems = commonitems + baserank4items + baserank5gear;
      };
      case "B_crew_F": {
        availableWeapons = crank4weap;
        availableItems = commonitems + crewrank0items;
      };
      case "B_Helipilot_F": {
        availableWeapons = prank4weap;
        availableItems = commonitems + pilotrank0items;
      };
    };
  };
  case "MAJOR": {
    availableBackpacks = bprank0 + bprank1;
    switch (typeOf player) do {
      case "B_medic_F";
      case "B_engineer_F";
      case "B_Soldier_F": {
        availableWeapons = sorank5weap;
        availableItems = commonitems + baserank5items + baserank5gear;
      };
      case "B_soldier_AT_F": {
        availableWeapons = atrank5weap;
        availableItems = commonitems + baserank5items + baserank5gear;
      };
      case "B_sniper_F": {
        availableWeapons = snrank5weap;
        availableItems = commonitems + sniperrank5items + baserank5gear;
      };
      case "B_soldier_AR_F": {
        availableWeapons = arrank5weap;
        availableItems = commonitems + baserank5items + baserank6gear;
      };
      case "B_crew_F": {
        availableWeapons = crank5weap;
        availableItems = commonitems + crewrank0items;
      };
      case "B_Helipilot_F": {
        availableWeapons = prank5weap;
        availableItems = commonitems + pilotrank0items;
      };
    };
  };
  case "COLONEL": {
    availableBackpacks = bprank0 + bprank1 + bprank2;
    switch (typeOf player) do {
      case "B_medic_F";
      case "B_engineer_F";
      case "B_Soldier_F": {
        availableWeapons = sorank6weap;
        availableItems = commonitems + baserank6items + baserank6gear;
      };
      case "B_soldier_AT_F": {
        availableWeapons = atrank6weap;
        availableItems = commonitems + baserank6items + baserank6gear;
      };
      case "B_sniper_F": {
        availableWeapons = snrank6weap;
        availableItems = commonitems + sniperrank6items + baserank6gear;
      };
      case "B_soldier_AR_F": {
        availableWeapons = arrank6weap;
        availableItems = commonitems + baserank6items + baserank6gear;
      };
      case "B_crew_F": {
        availableWeapons = crank6weap;
        availableItems = commonitems + crewrank0items;
      };
      case "B_Helipilot_F": {
        availableWeapons = prank6weap;
        availableItems = commonitems + pilotrank0items;
      };
    };
  };
};
availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;

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

[_crate, availableWeapons, false, true] call BIS_fnc_addVirtualWeaponCargo;
[_crate, availableBackpacks, false, true] call BIS_fnc_addVirtualBackpackCargo;
[_crate, availableItems, false, true] call BIS_fnc_addVirtualItemCargo;
[_crate, availableMagazines, false, true] call BIS_fnc_addVirtualMagazineCargo;
