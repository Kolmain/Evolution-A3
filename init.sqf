//////////////////////////////////////
//Init EVO_Debug
//////////////////////////////////////
if (("evo_debug" call BIS_fnc_getParamValue) == 1) then {
    EVO_Debug = true;
    publicVariable "EVO_Debug";
    NSLVR_DEBUG = true;
} else {
    EVO_Debug = false;
    publicVariable "EVO_Debug";
    NSLVR_DEBUG = false;
};
//////////////////////////////////////
//Init Third Party Scripts
//////////////////////////////////////
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
[] execVM "scripts\randomWeather2.sqf";
[] execVM "scripts\clean.sqf";
[] execVM "bon_recruit_units\init.sqf";
CHVD_allowNoGrass = true;
CHVD_maxView = 2500;
CHVD_maxObj = 2500;
if (("hitFX" call BIS_fnc_getParamValue) == 1) then {
    // Bodyfall SFX
    mrg_unit_sfx_bodyfall_concrete = [
        "MRG_bodyfall_concrete_1",
        "MRG_bodyfall_concrete_2",
        "MRG_bodyfall_concrete_3"
    ];
    mrg_unit_sfx_bodyfall_grass = [
        "MRG_bodyfall_grass_1",
        "MRG_bodyfall_grass_2",
        "MRG_bodyfall_grass_3"
    ];
    mrg_unit_sfx_bodyfall_drygrass = [
        "MRG_bodyfall_drygrass_1",
        "MRG_bodyfall_drygrass_2",
        "MRG_bodyfall_drygrass_3"
    ];
    mrg_unit_sfx_bodyfall_sand = [
        "MRG_bodyfall_sand_1",
        "MRG_bodyfall_sand_2",
        "MRG_bodyfall_sand_3"
    ];

    // Hit scream SFX
    mrg_unit_sfx_scream = [
        "MRG_scream_1",
        "MRG_scream_2",
        "MRG_scream_3",
        "MRG_scream_4",
        "MRG_scream_5",
        "MRG_scream_6",
        "MRG_scream_7",
        "MRG_scream_8",
        "MRG_scream_9",
        "MRG_scream_10",
        "MRG_scream_11",
        "MRG_scream_12",
        "MRG_scream_13",
        "MRG_scream_14",
        "MRG_scream_15"
    ];
    mrg_unit_sfx_deathScream = [
        "MRG_deathScream_1",
        "MRG_deathScream_2",
        "MRG_deathScream_3",
        "MRG_deathScream_4",
        "MRG_deathScream_5",
        "MRG_deathScream_6",
        "MRG_deathScream_7",
        "MRG_deathScream_8",
        "MRG_deathScream_9",
        "MRG_deathScream_10"
    ];
    // Array sizes (saves having to calculate them later)
    mrg_unit_sfx_bodyfall_concrete_size = count mrg_unit_sfx_bodyfall_concrete;
    mrg_unit_sfx_bodyfall_grass_size = count mrg_unit_sfx_bodyfall_grass;
    mrg_unit_sfx_bodyfall_drygrass_size = count mrg_unit_sfx_bodyfall_drygrass;
    mrg_unit_sfx_bodyfall_sand_size = count mrg_unit_sfx_bodyfall_sand;
    mrg_unit_sfx_scream_size = count mrg_unit_sfx_scream;
    mrg_unit_sfx_deathScream_size = count mrg_unit_sfx_deathScream;
};


if (("r3fParam" call BIS_fnc_getParamValue) == 1) then {
    execVM "R3F_LOG\init.sqf";
};
//////////////////////////////////////
//Init OPFOR AI System
//////////////////////////////////////
if (("aiSystem" call BIS_fnc_getParamValue) == 2) then {
    if (isServer) then
    {
        // From what range away from closest player should units be cached (in meters or what every metric system arma uses)?
        // To test this set it to 20 meters. Then make sure you get that close and move away.
        // You will notice 2 levels of caching 1 all but leader, 2 completely away
        // Stage 2 is 2 x GAIA_CACHE_STAGE_1. So default 2000, namely 2 x 1000
        GAIA_CACHE_STAGE_1             = 1000;
        // The follow 3 influence how close troops should be to known conflict to be used. (so they wont travel all the map to support)
        // How far should footmobiles be called in to support attacks.
        // This is also the range that is used by the transport system. If futher then the below setting from a zone, they can get transport.
        MCC_GAIA_MAX_SLOW_SPEED_RANGE  = 600;
        // How far should vehicles be called in to support attacks. (including boats)
        MCC_GAIA_MAX_MEDIUM_SPEED_RANGE= 4500;
        // How far should air units be called in to support attacks.
        MCC_GAIA_MAX_FAST_SPEED_RANGE  = 80000;
        // How logn should mortars and artillery wait (in seconds) between fire support missions.
        MCC_GAIA_MORTAR_TIMEOUT        = 120;
        // DANGEROUS SETTING!!!
        // If set to TRUE gaia will even send units that she does NOT control into attacks. Be aware ONLy for attacks.
        // They will not suddenly patrol if set to true.
        MCC_GAIA_ATTACKS_FOR_NONGAIA     = false;

        // If set to false, ai will not use smoke and flares (during night)
        MCC_GAIA_AMBIANT                 = true;

        // Influence how high the chance is (when applicaple) that units do smokes and flare (so not robotic style)
        // Default is 20 that is a chance of 1 out of 20 when they are applicable to use smokes and flares
        MCC_GAIA_AMBIANT_CHANCE          = 20;
        // The seconds of rest a transporter takes after STARTING his last order
        MCC_GAIA_TRANSPORT_RESTTIME     = 40;
        call compile preprocessfile "gaia\gaia_init.sqf";
        [] spawn {
            _gaia_respawn = [];
            while {true} do
            {
                //player globalchat "Deleting started..............";

                {
                    _gaia_respawn = (missionNamespace getVariable [ "GAIA_RESPAWN_" + str(_x),[] ]);
                    //Store ALL original group setups
                    if (count(_gaia_respawn)==0) then {[(_x)] call fn_cache_original_group;};

                    if ((({alive _x} count units _x) == 0) ) then
                    {
                        //Before we send him to heaven check if he should be reincarnated
                        if (count(_gaia_respawn)==2) then { [_gaia_respawn,(_x getVariable  ["MCC_GAIA_RESPAWN",-1]),(_x getVariable  ["MCC_GAIA_CACHE",false]),(_x getVariable  ["GAIA_zone_intend",[]])] call fn_uncache_original_group;};

                        //Remove the respawn group content before the group is re-used
                        missionNamespace setVariable ["GAIA_RESPAWN_" + str(_x), nil];

                        deleteGroup _x;
                    };

                    sleep .1;

                } foreach allGroups;

                sleep 2;
            };
        };
    };
} else {
    call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
};





//////////////////////////////////////
//Init Common Variables
//////////////////////////////////////
EVOp_scoreArray = [];
EVO_difficulty = "EvoDifficulty" call BIS_fnc_getParamValue;
enableSaving [false, false];
arsenalCrates = [];
militaryInstallations = [];
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
                            //ALTIS ON FIRE
                            //////////////////////////////////////
                            rank1 = 20;
                            rank2 = 40;
                            rank3 = 75;
                            rank4 = 120;
                            rank5 = 175;
                            rank6 = 225;
                        };
                    };
HCconnected = false;
CROSSROADS = [West,"HQ"];
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
availableWeapons = [];
availableMagazines = [];
EVO_vaCrates = [];

//////////////////////////////////////
//Init Headless Client
//////////////////////////////////////

if (!(isServer) && !(hasInterface)) then {
	HCconnected = true;
	publicVariable "HCconnected";
};

if (("persistentEVO" call BIS_fnc_getParamValue) == 1) then {
    _lastWorld = profileNamespace getVariable ["EVO_world", "nil"];
    if (_lastWorld == "nil") then {

    } else {
        if (_lastWorld == worldName) then {
            targetCounter = profileNamespace getVariable ["EVO_currentTargetCounter", 2];
            EVOp_scoreArray = profileNamespace getVariable ["EVO_scoreArray", []];
            publicVariable "EVOp_scoreArray";
        };

    };

};
//////////////////////////////////////
//Init Server
//////////////////////////////////////
if (isServer) then {
    if (!isNil "MHQ") then {
        _null = [MHQ] spawn EVO_fnc_mhq;
    } else {
        MHQ = objNull;
        "mhqMarker" setMarkerAlpha 0;
    };
	[] spawn EVO_fnc_initEVO;
	EVO_sessionID = format["EVO_%1_%2", (floor(random 1000) + floor(random 1000)), floor(random 1000)];
	publicVariable "EVO_sessionID";
    [] spawn EVO_fnc_protectBase;
    [WEST, spawnBuilding, "Staging Base"] call BIS_fnc_addRespawnPosition;
	["Initialize"] call BIS_fnc_dynamicGroups;
};

//////////////////////////////////////
//Init Clients
//////////////////////////////////////

if (isDedicated || !hasInterface) exitWith {};
if (("persistentEVO" call BIS_fnc_getParamValue) == 1 && score player == 0) then {
    {
        _playerData = _x;
        _puid = player getPlayerUID;
        if (_puid == (_playerData select 0)) then {
            [player, (_playerData select 1)] call BIS_fnc_addScore;
        };
    } forEach EVOp_scoreArray;
};
_brief = [] execVM "briefing.sqf";
"EVO_vaCrates" addPublicVariableEventHandler {
    {
        if (alive (_x select 0)) then {
            [(_x select 0), rank (_x select 1)] call EVO_fnc_buildAmmoCrate;
        };
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
//////////////////////////////////////
//EVO Sector Markers
//////////////////////////////////////
if (("gridMarkersParam" call BIS_fnc_getParamValue) == 1) then {
    _mrkrs = [] spawn EVO_fnc_gridMarkers;
};
recruitComm = [player, "recruit"] call BIS_fnc_addCommMenuItem;
_nil = [] spawn EVO_fnc_supportManager;
handle = [] spawn {
	while {true} do {
		waitUntil {player distance hqbox < 5};
	   	waitUntil {player distance hqbox > 5};
   		if (isTouchingGround player) then {
            loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
            profileNamespace setVariable ["EVO_loadout", loadout];
            saveProfileNamespace;
            systemChat "Loadout saved to profile...";
        };
	};
};

handle = [player,
[["ItemMap","ItemCompass","ItemWatch","ItemRadio","H_HelmetB"],"arifle_MX_F",["","","",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_CombatUniform_mcam",["FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","Chemlight_green"],"V_PlateCarrier1_rgr",["FirstAidKit","FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","SmokeShell","SmokeShellGreen","HandGrenade","HandGrenade"],"B_AssaultPack_mcamo",[],[["30Rnd_65x39_caseless_mag"],["16Rnd_9x21_Mag"],[],[]],"arifle_MX_F","FullAuto"]] execVM "scripts\setloadout.sqf";
loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
profileNamespace setVariable ["EVO_loadout", loadout];
saveProfileNamespace;
deadloadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
player addEventHandler ["Killed",{
    _player = _this select 0;
    _killer = _this select 1;
    deadloadout = [_player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
}];

_index = player addMPEventHandler ["MPRespawn", {
 	_newPlayer = _this select 0;
 	_oldPlayer = _this select 1;
 	_newPlayer setVariable ["EVOrank", (_oldPlayer getVariable "EVOrank"), true];
 	_newPlayer setUnitRank (_oldPlayer getVariable "EVOrank");
 	_nil = [] spawn EVO_fnc_pinit;
 	if (!(_newPlayer getVariable "BIS_revive_incapacitated")) then {
 		handle = [player, (profileNamespace getVariable "EVO_loadout")] execVM "scripts\setloadout.sqf";
 	} else {
 	    _newPlayer setDamage 0.5;
 		handle = [player, deadloadout] execVM "scripts\setloadout.sqf";
 		removeBackpack player;
 	};
}];

if (isMultiplayer) then { _nil = [] spawn EVO_fnc_pinit};
