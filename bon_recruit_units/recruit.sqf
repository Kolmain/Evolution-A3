// by Bon_Inf*

if(not local player) exitWith{};
_count = 0;
{
	if (!isPlayer _x) then {
		_count = _count + 1;
	};
} forEach units group player;
_count = _count + count bon_recruit_queue;
//_precount = count units group player + count bon_recruit_queue;
//if (_precount >= bon_max_units_allowed) exitWith {hint "You've reached the max allowed group size."};
if (_count >= bon_max_units_allowed) exitWith {hint "You've reached the maximum allowed group size for your rank."};


#include "dialog\definitions.sqf"
disableSerialization;


_update_queue = {
	_display = findDisplay BON_RECRUITING_DIALOG;
	_queuelist = _display displayCtrl BON_RECRUITING_QUEUE;
	_queuelist ctrlSetText format["Units queued: %1",count bon_recruit_queue];
};


_display = findDisplay BON_RECRUITING_DIALOG;
_listbox = _display displayCtrl BON_RECRUITING_UNITLIST;
_sel = lbCurSel _listbox; if(_sel < 0) exitWith{};

_unittype = bon_recruit_recruitableunits select _sel;
_typename = lbtext [BON_RECRUITING_UNITLIST,_sel];

_queuepos = 0;
_queuecount = count bon_recruit_queue;
if(_queuecount > 0) then {
	_queuepos = (bon_recruit_queue select (_queuecount - 1)) + 1;
	hint parseText format["%1 added to queue.",_typename];
};
bon_recruit_queue = bon_recruit_queue + [_queuepos];

[] call _update_queue;


WaitUntil{_queuepos == bon_recruit_queue select 0};
sleep (1.5 * (_queuepos min 1));
hint parseText format["Processing your %1.",_typename];

sleep 8.5;




/********************* UNIT CREATION ********************/
_unit = objNull;

if (player distance SpawnBuilding < 500) then {
	//_spawnPos = [getPos player, 10, 10, 10, 0, 2, 0] call BIS_fnc_findSafePos;
	_spawnPos = getPos SpawnBuilding;
	_unit = group player createUnit [_unittype, _spawnPos, [], 0, "FORM"];
	_unit addEventHandler ["GetInMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
		handle = [_unit] call EVO_fnc_vehicleCheck;
	}];
} else {
    _spawnPos = [((getPos player) select 0), ((getPos player) select 1), (((getPos player) select 2) + 200)];
	_unit = group player createUnit [_unittype, [_spawnPos select 0, _spawnPos select 1, 200], [], 0, "FORM"];
    _unit allowdamage false;
    waitUntil {(position _unit select 2) <= 75};
    _chute = createVehicle ["Steerable_Parachute_F", position _unit, [], (random 10), 'FLY'];
    _chute setPos (getPos _unit);
    _unit assignAsDriver _chute;
    _unit moveIndriver _chute;
    _unit DoMove (getPos leader group _unit);
    _unit allowdamage true;
	_unit addEventHandler ["GetInMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
		handle = [_unit] call EVO_fnc_vehicleCheck;
	}];
	[_unit] spawn {
	    _unit = _this select 0;
	    (vehicle _unit) allowDamage false;// Set parachute invincible to prevent exploding if it hits buildings
	    waitUntil {isTouchingGround _unit || (position _unit select 2) < 1 };
	    _unit allowDamage false;
	    _unit action ["EJECT", vehicle _unit];
	    _unit setvelocity [0,0,0];
	    sleep 1;// Para Units sometimes get damaged on landing. Wait to prevent this.
	    _unit allowDamage true;
	};
};
//set unit loadout 
switch (typeOf _unit) do {
	case "CUP_B_US_Soldier_Backpack": { 
		comment "Remove existing items";
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_TwoKnee";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 10 do {_unit addItemToVest "CUP_30Rnd_556x45_Stanag";};
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		_unit addBackpack "B_AssaultPack_rgr";
		_unit addHeadgear "CUP_H_USArmy_HelmetMICH";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_arifle_M16A4_Base";
		_unit addPrimaryWeaponItem "acc_flashlight";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
	};
	case "CUP_B_US_Soldier_GL": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_TwoKnee";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		for "_i" from 1 to 8 do {_unit addItemToVest "CUP_30Rnd_556x45_Stanag";};
		for "_i" from 1 to 3 do {_unit addItemToVest "CUP_1Rnd_HE_M203";};
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_1Rnd_StarCluster_White_M203";};
		_unit addBackpack "B_AssaultPack_rgr";
		_unit addHeadgear "CUP_H_USArmy_HelmetMICH";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_arifle_M16A4_GL";
		_unit addPrimaryWeaponItem "acc_flashlight";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
	};
	case "CUP_B_US_Soldier_AR": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_TwoKnee";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_1Rnd_HE_M203";};
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_1Rnd_StarCluster_White_M203";};
		for "_i" from 1 to 9 do {_unit addItemToVest "CUP_30Rnd_556x45_PMAG_QP";};
		_unit addBackpack "B_AssaultPack_rgr";
		_unit addHeadgear "CUP_H_USArmy_HelmetMICH";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_arifle_HK_M27";
		_unit addPrimaryWeaponItem "CUP_muzzle_mfsup_Flashhider_556x45_Black";
		_unit addPrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Black_L";
		_unit addPrimaryWeaponItem "CUP_optic_Eotech553_Black";
		_unit addPrimaryWeaponItem "bipod_01_F_blk";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
	};
	case "CUP_B_US_Soldier_MG": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_TwoKnee";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_1Rnd_HE_M203";};
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_1Rnd_StarCluster_White_M203";};
		_unit addItemToVest "CUP_100Rnd_TE4_LRT4_Red_Tracer_762x51_Belt_M";
		_unit addBackpack "B_AssaultPack_rgr";
		for "_i" from 1 to 2 do {_unit addItemToBackpack "CUP_100Rnd_TE4_LRT4_Red_Tracer_762x51_Belt_M";};
		_unit addHeadgear "CUP_H_USArmy_HelmetMICH";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_lmg_M240";
		_unit addPrimaryWeaponItem "CUP_optic_ACOG";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
	};
	case "CUP_B_US_Soldier_AT": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_TwoKnee";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		for "_i" from 1 to 8 do {_unit addItemToVest "CUP_30Rnd_556x45_Stanag";};
		_unit addBackpack "B_AssaultPack_rgr";
		_unit addItemToBackpack "CUP_SMAW_HEAA_M";
		_unit addHeadgear "CUP_H_USArmy_HelmetMICH";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_arifle_M4A3_black";
		_unit addPrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Black_L";
		_unit addPrimaryWeaponItem "CUP_optic_MicroT1";
		_unit addWeapon "CUP_launch_Mk153Mod0";
		_unit addSecondaryWeaponItem "CUP_optic_SMAW_Scope";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
 };
	case "CUP_B_US_Medic": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_TwoKnee";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		for "_i" from 1 to 8 do {_unit addItemToVest "CUP_30Rnd_556x45_Stanag";};
		_unit addBackpack "B_AssaultPack_khk";
		_unit addItemToBackpack "Medikit";
		for "_i" from 1 to 7 do {_unit addItemToBackpack "FirstAidKit";};
		_unit addHeadgear "CUP_H_USArmy_HelmetMICH";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_arifle_M4A3_black";
		_unit addPrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Black_L";
		_unit addPrimaryWeaponItem "CUP_optic_MicroT1";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
	};
	case "CUP_B_US_Soldier_Engineer": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_TwoKnee";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		for "_i" from 1 to 8 do {_unit addItemToVest "CUP_30Rnd_556x45_Stanag";};
		_unit addBackpack "B_AssaultPack_khk";
		_unit addItemToBackpack "ToolKit";
		_unit addItemToBackpack "MineDetector";
		for "_i" from 1 to 2 do {_unit addItemToBackpack "DemoCharge_Remote_Mag";};
		_unit addItemToBackpack "APERSBoundingMine_Range_Mag";
		_unit addHeadgear "CUP_H_USArmy_HelmetMICH";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_arifle_M4A3_black";
		_unit addPrimaryWeaponItem "CUP_acc_ANPEQ_15_Flashlight_Black_L";
		_unit addPrimaryWeaponItem "CUP_optic_MicroT1";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
	};
	case "CUP_B_US_Pilot_Light": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USMC_PilotOverall";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "CUP_V_B_Eagle_SPC_Crew";
		for "_i" from 1 to 3 do {_unit addItemToVest "CUP_30Rnd_556x45_Stanag";};
		_unit addBackpack "B_Parachute";
		_unit addHeadgear "CUP_H_USMC_Helmet_Pilot";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_arifle_M4A1";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
 };
	case "CUP_B_US_Sniper": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_CZ_WDL_Ghillie";
		for "_i" from 1 to 2 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 5 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_TacChestrig_oli_F";
		for "_i" from 1 to 10 do {_unit addItemToVest "CUP_5Rnd_762x51_M24";};
		for "_i" from 1 to 7 do {_unit addItemToVest "CUP_15Rnd_9x19_M9";};
		_unit addHeadgear "CUP_H_FR_Headband_Headset";
		_unit addGoggles "CUP_G_PMC_RadioHeadset_Glasses_Dark";
		_unit addWeapon "CUP_srifle_M24_wdl";
		_unit addPrimaryWeaponItem "CUP_Mxx_camo";
		_unit addPrimaryWeaponItem "CUP_optic_LeupoldMk4_10x40_LRT_Woodland";
		_unit addPrimaryWeaponItem "CUP_bipod_Harris_1A2_L";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
	};
	case "CUP_B_US_SpecOps_SD": { 
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "CUP_U_B_USArmy_UBACS";
		for "_i" from 1 to 3 do {_unit addItemToUniform "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToUniform "CUP_15Rnd_9x19_M9";};
		_unit addVest "V_PlateCarrier1_rgr";
		for "_i" from 1 to 2 do {_unit addItemToVest "CUP_HandGrenade_M67";};
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellRed";
		for "_i" from 1 to 6 do {_unit addItemToVest "CUP_30Rnd_556x45_PMAG_QP";};
		_unit addBackpack "B_AssaultPack_blk";
		for "_i" from 1 to 2 do {_unit addItemToBackpack "CUP_M136_M";};
		for "_i" from 1 to 2 do {_unit addItemToBackpack "DemoCharge_Remote_Mag";};
		for "_i" from 1 to 2 do {_unit addItemToBackpack "APERSBoundingMine_Range_Mag";};
		_unit addHeadgear "CUP_H_PMC_Beanie_Headphones_Black";
		_unit addGoggles "CUP_G_PMC_Facewrap_Black_Glasses_Dark";
		_unit addWeapon "CUP_arifle_HK416_CQB_M203_Wood";
		_unit addPrimaryWeaponItem "CUP_muzzle_snds_M16";
		_unit addPrimaryWeaponItem "CUP_acc_ANPEQ_15_Black";
		_unit addPrimaryWeaponItem "CUP_optic_Elcan_reflex_OD";
		_unit addWeapon "CUP_launch_M136";
		_unit addWeapon "CUP_hgun_M9";
		_unit addWeapon "Binocular";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
		_unit linkItem "CUP_NVG_PVS15_black";
	};
};
_unit setRank "PRIVATE";
_unit = _this select 0;
_unit addEventHandler ["HandleScore", {
		_ai = _this select 0;
		_source = _this select 1;
		_scoreToAdd = _this select 2;
		_player = leader group _ai;
		[_player, _scoreToAdd] call bis_fnc_addScore;
}];
[_unit] execVM (BON_RECRUIT_PATH+"init_newunit.sqf");
/*******************************************************/




//hint parseText format["Your <t size='1.0' font='PuristaMedium' color='#008aff'>%1</t> %2 has arrived.",_typename,name _unit];
_msg = format["Your %1 %2 has arrived.",_typename,name _unit];
["deployed",["REINFORCEMENTS", _msg]] call BIS_fnc_showNotification;
bon_recruit_queue = bon_recruit_queue - [_queuepos];

[] call _update_queue;
