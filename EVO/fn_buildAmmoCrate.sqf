_crate = _this select 0;
_EVOrank = _this select 1;

rank1weapons = ["arifle_MX_F","launch_NLAW_F","launch_RPG32_F"];
rank1items = ["optic_Aco","optic_ACO_grn","acc_flashlight"];

rank2weapons = ["launch_B_Titan_short_F","launch_B_Titan_F","hgun_ACPC2_F","arifle_MXC_F","arifle_MX_GL_F","arifle_MX_SW_F"];
rank2items = ["optic_Hamr","optic_Hamr","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp"];

rank3weapons = ["arifle_MXM_F","arifle_Mk20C_F","arifle_Mk20C_plain_F","arifle_Mk20_GL_F","hgun_Pistol_heavy_02_F","LMG_Mk200_F"];
rank3items = ["B_UavTerminal","Laserdesignator","acc_pointer_IR","optic_MRCO","NVGoggles"];

rank4weapons = ["hgun_ACPC2_snds_F","arifle_MXM_Black_F","arifle_TRG21_F","arifle_TRG21_GL_F","arifle_TRG20_F","SMG_01_F","arifle_MX_GL_Black_F","arifle_MX_SW_Black_F","hgun_PDW2000_F","SMG_01_F","SMG_02_F"];
rank4items = ["muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_H_SW","muzzle_snds_acp","muzzle_snds_338_black","muzzle_snds_338_green","muzzle_snds_338_sand","muzzle_snds_93mmg","muzzle_snds_93mmg_tan"];

rank5weapons = ["srifle_EBR_F","srifle_DMR_02_F","srifle_DMR_02_camo_F","srifle_DMR_02_sniper_F","srifle_DMR_03_F","srifle_DMR_03_khaki_F","srifle_DMR_03_tan_F","srifle_DMR_03_multicam_F","srifle_DMR_03_woodland_F","srifle_DMR_06_camo_F","srifle_DMR_06_olive_F","srifle_DMR_06_camo_khs_F","MMG_02_camo_F","MMG_02_black_F","MMG_02_sand_F"];
rank5items = ["optic_SOS","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg","optic_Yorris","optic_MRD","optic_DMS","optic_LRPS"];

rank6weapons = ["srifle_LRR_F","srifle_GM6_F","srifle_LRR_camo_F"];
rank6items = ["optic_AMS","optic_AMS_khk","optic_AMS_snd"];

rank7weapons = [];
availableHeadgear = [
    "H_HelmetB",
    "H_HelmetB_camo",
    "H_HelmetB_paint",
    "H_HelmetB_light",
    "H_HelmetSpecB",
    "H_Booniehat_mcamo",
    "H_Booniehat_khk_hs",
    "H_MilCap_mcamo",
    "H_Cap_tan_specops_US",
    "H_Cap_khaki_specops_UK",
    "H_Cap_headphones",
    "H_Bandanna_mcamo",
    "H_Bandanna_khk_hs",
    "H_Shemag_khk",
    "H_ShemagOpen_khk",
    "H_Watchcap_blk",
    "H_PilotHelmetHeli_B",
    "H_CrewHelmetHeli_B",
    "H_PilotHelmetFighter_B",
    "H_HelmetCrew_B"
];
availableGoggles = [
    "G_Combat",
    "G_Lowprofile",
    "G_Shades_Black",
    "G_Shades_Blue",
    "G_Shades_Green",
    "G_Shades_Red",
    "G_Sport_Blackred",
    "G_Sport_Blackyellow",
    "G_Squares_Tinted",
    "G_Tactical_Black",
    "G_Tactical_Clear",
    "G_Bandanna_blk"
];
availableUniforms = [
    "U_B_CombatUniform_mcam",
    "U_B_CombatUniform_mcam_tshirt",
    "U_B_CombatUniform_mcam_vest",
    "U_B_HeliPilotCoveralls",
    "U_B_CTRG_1",
    "U_B_CTRG_2",
    "U_B_CTRG_3"
];
availableVests = [
    "V_BandollierB_khk",
    "V_BandollierB_blk",
    "V_PlateCarrier1_rgr",
    "V_PlateCarrier2_rgr",
    "V_PlateCarrierGL_rgr",
    "V_PlateCarrierSpec_rgr",
    "V_PlateCarrierL_CTRG",
    "V_PlateCarrierH_CTRG"
];
availableItems = [
    "ItemWatch",
    "ItemCompass",
    "ItemGPS",
    "ItemRadio",
    "ItemMap",
    "MineDetector",
    "Binocular",
    "NVGoggles",
    "FirstAidKit",
    "Medikit",
    "ToolKit"
];
availableBackpacks = [
    "B_AssaultPack_rgr",
    "B_AssaultPack_mcamo",
    "B_Kitbag_rgr",
    "B_Kitbag_mcamo",
    "B_TacticalPack_blk",
    "B_TacticalPack_mcamo"
    ];
availableWeapons = [];
availableMagazines = [];

switch (_EVOrank) do {
    case "PRIVATE": {
   		availableWeapons = availableWeapons + rank1weapons;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;

    };
    case "CORPORAL": {
    		availableWeapons = availableWeapons + rank1weapons + rank2weapons;
		availableItems = availableItems + rank2items;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;

    };
    case "SERGEANT": {
		availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons;
		availableItems = availableItems + rank2items + rank3items;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "LIEUTENANT": {
    		availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons;
    		availableItems = availableItems + rank2items + rank3items + rank4items;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "CAPTAIN": {
    		availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons;
		availableItems = availableItems + rank2items + rank3items + rank4items + rank5items;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "MAJOR": {
    		availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank6weapons;
		availableItems = availableItems + rank2items + rank3items + rank4items + rank5items + rank6items;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
    };
    case "COLONEL": {
    		availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank7weapons;
		availableItems = availableItems + rank2items + rank3items + rank4items + rank5items + rank6items;
		availableMagazines = availableWeapons call EVO_fnc_buildMagazineArray;
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
