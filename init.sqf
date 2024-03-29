//////////////////////////////////////
//Init Third Party Scripts
//////////////////////////////////////
[] execVM "scripts\randomWeather2.sqf";
[] execVM "bon_recruit_units\init.sqf";
NSLVR_DEBUG = false;
CHVD_allowNoGrass = true;
CHVD_maxView = 2500; 
CHVD_maxObj = 2500;
setTimeMultiplier ("timemultiplier" call BIS_fnc_getParamValue);

//////////////////////////////////////
//Init OPFOR AI System
//////////////////////////////////////
//[] execVM "Vcom\VcomInit.sqf";

//////////////////////////////////////
//Init Common Variables
//////////////////////////////////////
EVO_difficulty = "EvoDifficulty" call BIS_fnc_getParamValue;
enableSaving [false, false];
militaryInstallations = [];
HCconnected = false;
CROSSROADS = [West,"HQ"];
availableWeapons = [];
availableMagazines = [];
EVO_vaCrates = [hqbox];
landing_zones = [];
//////////////////////////////////////
//Set Ranks and Unlocks
//////////////////////////////////////
rank1 = 10;
rank2 = 30;
rank3 = 60;
rank4 = 100;
rank5 = 150;
rank6 = 200;
switch (EVO_difficulty) do {
    case 1: {
        //////////////////////////////////////
        //EASY
        //////////////////////////////////////
        rank1 = 5;
        rank2 = 15;
        rank3 = 30;
        rank4 = 50;
        rank5 = 75;
        rank6 = 100;
    };
    case 2: {
        //////////////////////////////////////
        //NORMAL
        //////////////////////////////////////
        rank1 = 10;
        rank2 = 30;
        rank3 = 60;
        rank4 = 100;
        rank5 = 150;
        rank6 = 200;
    };
    case 3: {
        //////////////////////////////////////
        //HARD
        //////////////////////////////////////
        rank1 = 15;
        rank2 = 35;
        rank3 = 65;
        rank4 = 105;
        rank5 = 155;
        rank6 = 205;
    };
    case 4: {
        //////////////////////////////////////
        //INSANE
        //////////////////////////////////////
        rank1 = 20;
        rank2 = 40;
        rank3 = 75;
        rank4 = 120;
        rank5 = 175;
        rank6 = 225;
    };
 };
rank1vehicles = ["B_Truck_01_Repair_F","B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_medical_F","b_mrap_01_f","nonsteerable_parachute_f","steerable_parachute_f","b_boat_transport_01_f","b_g_boat_transport_01_f"];
rank2vehicles = ["b_heli_light_01_f","b_sdv_01_f","b_mrap_01_hmg_f","b_truck_01_covered_f","b_truck_01_mover_f","b_truck_01_box_f","b_truck_01_transport_f"];
rank3vehicles = ["b_heli_light_01_armed_f","b_heli_transport_01_f","b_heli_transport_01_camo_f","b_mrap_01_gmg_f","b_apc_wheeled_01_cannon_f"];
rank4vehicles = ["b_apc_tracked_01_rcws_f","b_apc_tracked_01_crv_f","b_boat_armed_01_minigun_f"];
rank5vehicles = ["b_apc_tracked_01_aa_f","b_mbt_01_cannon_f","b_mbt_01_tusk_f"];
rank6vehicles = ["b_heli_attack_01_f","b_mbt_01_arty_f","b_mbt_01_mlrs_f"];
rank7vehicles = ["b_plane_cas_01_f"];
rank1weapons = ["arifle_MX_F","launch_NLAW_F","launch_RPG32_F"];
rank1items = ["optic_Aco","optic_ACO_grn","acc_flashlight"];
rank2weapons = ["launch_B_Titan_short_F","launch_B_Titan_F","hgun_ACPC2_F","arifle_MXC_F","arifle_MX_GL_F","arifle_MX_SW_F"];
rank2items = ["optic_Hamr","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp"];
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
    "H_HelmetCrew_B",
    "H_Cap_marshal",
    "H_Watchcap_sgg",
    "H_Watchcap_camo",
    "H_Watchcap_khk",
    "H_Watchcap_cbr",
    "H_Beret_02",
    "H_BandMask_demon",
    "H_BandMask_reaper",
    "H_HelmetB_light_snakeskin"
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
    "U_B_CTRG_3",
    "V_PlateCarrierIAGL_oli",
    "V_PlateCarrierSpec_mtp",
    "V_PlateCarrierSpec_blk",
    "V_PlateCarrierGL_mtp",
    "V_PlateCarrierGL_blk",
    "U_B_FullGhillie_ard",
    "U_B_FullGhillie_sard",
    "U_B_FullGhillie_lsh",
    "U_BG_Guerilla2_1"
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
    "ToolKit",
    "Item_MineDetector"
];
availableBackpacks = [
    "B_AssaultPack_rgr",
    "B_AssaultPack_mcamo",
    "B_Kitbag_rgr",
    "B_Kitbag_mcamo",
    "B_TacticalPack_blk",
    "B_TacticalPack_mcamo"
];

EVO_opforGroundTrans = ["O_Truck_02_covered_F","O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F"];
EVO_opforAirTrans = ["O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_covered_F","O_Heli_Light_02_v2_F", "O_Heli_Light_02_unarmed_F", "O_Heli_Light_02_F"];
EVO_opforHeavyLift = "O_Heli_Transport_04_F";
EVO_opforInfantry = [
    (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")
];
evo_opforofficer = "O_Officer_Parade_Veteran_F";
EVO_opforVehicles = ["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F", "O_UGV_01_rcws_F","O_APC_Tracked_02_cannon_F", "O_MBT_02_cannon_F", "O_APC_Wheeled_02_rcws_F"];
EVO_opforAAA = "O_APC_Tracked_02_AA_F";
EVO_opforSnipers = ["O_sniper_F", "O_ghillie_lsh_F", "O_ghillie_sard_F", "O_ghillie_ard_F"];
EVO_opforCAS = ["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_Plane_CAS_02_F","O_UAV_02_CAS_F","O_Plane_CAS_02_F"];
//////////////////////////////////////
//Init Headless Client
//////////////////////////////////////
if (!(isServer) && !(hasInterface)) then {
	HCconnected = true;
	publicVariable "HCconnected";
};

//////////////////////////////////////
//Init Server
//////////////////////////////////////
if (isServer) then {
	[] spawn EVO_fnc_initEVO;
    [] spawn EVO_fnc_protectBase;
    [] spawn EVO_fnc_pickSideMission;
	["Initialize"] call BIS_fnc_dynamicGroups;
};

//////////////////////////////////////
//Init Clients
//////////////////////////////////////
if (isDedicated || !hasInterface) exitWith {};

loadout = getUnitLoadout player;

handle = [] spawn {
	while {true} do {
        waitUntil {player distance hqbox < 10};
	   	waitUntil {player distance hqbox > 10};
   		if (isTouchingGround player) then {
            loadout = getUnitLoadout player;
        };
	};
};
_brief = [] execVM "briefing.sqf";
"EVO_vaCrates" addPublicVariableEventHandler {
    {
            [_x, rank player] call EVO_fnc_buildAmmoCrate;
    } forEach EVO_vaCrates;
};
intro = true;
supportMapClick = [0,0,0];
supportClicked = false;
player execVM "scripts\intro.sqf";
[] execVM "scripts\player_markers.sqf";
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
WaitUntil{!intro};
playsound "Recall";
//////////////////////////////////////
//BIS Jukebox
//////////////////////////////////////
if (("bisJukebox" call BIS_fnc_getParamValue) == 1) then {
	_mus = [] spawn BIS_fnc_jukebox;
};
//////////////////////////////////////
//BIS Ambient Combat Sounds
//////////////////////////////////////
if (("bisAmbientCombatSounds" call BIS_fnc_getParamValue) == 1) then {
    _amb = [] spawn EVO_fnc_amb;
};

recruitComm = [player, "recruit"] call BIS_fnc_addCommMenuItem;

_index = player addMPEventHandler ["MPRespawn", {
 	_newPlayer = _this select 0;
 	_oldPlayer = _this select 1;
 	_nil = [] spawn EVO_fnc_pinit;
}];

	player setUnitRank "PRIVATE";
	bon_max_units_allowed = 2;
	bon_recruit_recruitableunits = ["B_Soldier_F"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	[hqbox, (rank player)] call EVO_fnc_buildAmmoCrate;
    _nil = [] spawn EVO_fnc_pinit;