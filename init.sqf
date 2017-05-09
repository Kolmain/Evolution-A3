//////////////////////////////////////
//Init EVO_Debug
//////////////////////////////////////
if (("evo_debug" call BIS_fnc_getParamValue) == 1) then {
    EVO_Debug = true;
    publicVariable "EVO_Debug";
} else {
    EVO_Debug = false;
    publicVariable "EVO_Debug";
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
setTimeMultiplier ("timemultiplier" call BIS_fnc_getParamValue);
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

HCconnected = false;
CROSSROADS = [West,"HQ"];
availableWeapons = [];
availableMagazines = [];
EVO_vaCrates = [];

//////////////////////////////////////
//Customize Variables
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

srank0vehicles = ["B_Quadbike_01_F", 	"B_LSV_01_unarmed_F"];
srank1vehicles = srank0vehicles + ["B_MRAP_01_F", "B_Boat_Transport_01_F", "B_Truck_01_transport_F", "B_Truck_01_Repair_F", "B_Truck_01_ammo_F", "B_Truck_01_fuel_F", "B_Truck_01_medical_F"];
srank2vehicles = srank1vehicles + ["B_LSV_01_armed_F"];
srank3vehicles = srank2vehicles + ["B_MRAP_01_hmg_F"];
srank4vehicles = srank3vehicles + ["B_MRAP_01_gmg_F"];
srank5vehicles = srank4vehicles + ["B_APC_Tracked_01_rcws_F"];
srank6vehicles = srank5vehicles + ["B_Heli_Light_01_F"];

prank0vehicles = srank0vehicles + ["B_Heli_Light_01_F"];
prank1vehicles = prank0vehicles + ["I_Heli_light_03_unarmed_F"];
prank2vehicles = prank1vehicles + ["B_Heli_Light_01_armed_F"];
prank3vehicles = prank2vehicles + ["I_Heli_light_03_F"];
prank4vehicles = prank3vehicles + ["B_Heli_Transport_03_F"];
prank5vehicles = prank4vehicles + ["B_T_VTOL_01_vehicle_F"];
prank6vehicles = prank5vehicles + ["I_Plane_Fighter_03_CAS_F"];

crank0vehicles = srank4vehicles;
crank1vehicles = crank0vehicles + ["B_APC_Tracked_01_rcws_F"];
crank2vehicles = crank1vehicles + ["B_APC_Tracked_01_AA_F", "B_APC_Wheeled_01_cannon_F"];
crank3vehicles = crank2vehicles + ["I_APC_Wheeled_03_cannon_F"];
crank4vehicles = crank3vehicles + ["I_APC_tracked_03_cannon_F"];
crank5vehicles = crank4vehicles + ["B_MBT_01_cannon_F"];
crank6vehicles = crank5vehicles + ["B_MBT_01_TUSK_F"];

////Pistols
pistoltier0 = ["hgun_P07_F"];
pistoltier1 = ["hgun_ACPC2_F"];
pistoltier2 = ["hgun_Pistol_heavy_01_F"];
////Launchers
launchertier0 = ["launch_NLAW_F"];
launchertier1 = ["launch_B_Titan_short_F"];
launchertier2 = ["launch_B_Titan_F"];
////Rifles
rifletier0 = ["arifle_TRG21_F"];
rifletier1 = ["arifle_MX_F"];
rifletier2 = ["arifle_SPAR_01_blk_F", "arifle_SPAR_01_snd_F", "arifle_SDAR_F"];
rifletier3 = ["arifle_ARX_blk_F"];
////Grenade Launchers
gltier0 = ["arifle_TRG21_GL_F"];
gltier1 = ["arifle_MX_GL_F"];
gltier2 = ["arifle_SPAR_01_GL_blk_F", "arifle_SPAR_01_GL_snd_F"];
////Sniper Rifles
srtier0 = ["arifle_MXM_F"];
srtier1 = ["srifle_DMR_06_camo_F"];
srtier2 = ["srifle_EBR_F"];
srtier3 = ["arifle_SPAR_03_blk_F", "arifle_SPAR_03_snd_F"];
srtier4 = ["srifle_DMR_03_F", "srifle_DMR_03_tan_F"];
srtier5 = ["srifle_DMR_02_F", "srifle_DMR_02_sniper_F"];
srtier6 = ["srifle_LRR_F", "srifle_LRR_camo_F", "srifle_GM6_F"];
////Auto Rifles
artier0 = ["arifle_MX_SW_F"];
artier1 = ["LMG_03_F"];
artier2 = ["arifle_SPAR_02_blk_F", "arifle_SPAR_02_snd_F"];
artier3 = ["LMG_Mk200_F"];
artier4 = ["LMG_Zafir_F"];
artier5 = ["MMG_01_tan_F", "MMG_02_black_F", "MMG_02_sand_F"];
////SMGs
smgtier0 = ["hgun_PDW2000_F", "SMG_02_F", "SMG_05_F"];
smgtier1 = ["SMG_01_F"];
smgtier2 = ["arifle_MXC_F", "arifle_SPAR_01_blk_F"];

////Soldier
sorank0weap = rifletier0 + pistoltier0;
sorank1weap = sorank0weap + rifletier1 + gltier0;
sorank2weap = sorank1weap + rifletier2 + gltier1;
sorank3weap = sorank2weap + pistoltier1 + gltier2;
sorank4weap = sorank3weap + srtier1 + pistoltier2;
sorank5weap = sorank4weap + srtier2 + srtier3;
sorank6weap = sorank5weap + rifletier3 + launchertier0;
////Anti Tank
atrank0weap = rifletier0 + pistoltier0 + launchertier0;
atrank1weap = atrank0weap + rifletier1;
atrank2weap = atrank1weap + rifletier2;
atrank3weap = atrank2weap + pistoltier1 + launchertier1;
atrank4weap = atrank3weap + srtier1 + pistoltier2;
atrank5weap = atrank4weap + srtier2 + srtier3 + launchertier2;
atrank6weap = atrank5weap + rifletier3;
////Sniper
snrank0weap = srtier0 + pistoltier0;
snrank1weap = snrank0weap + srtier1 + pistoltier1;
snrank2weap = snrank1weap + srtier2 + pistoltier2;
snrank3weap = snrank2weap + srtier3 + smgtier0;
snrank4weap = snrank3weap + srtier4 + smgtier1;
snrank5weap = snrank4weap + srtier5 + smgtier2;
snrank6weap = snrank5weap + srtier6;
////Autorifle
arrank0weap = artier0;
arrank1weap = arrank0weap + artier1;
arrank2weap = arrank0weap + artier2;
arrank3weap = arrank0weap + artier3;
arrank4weap = arrank0weap + artier4;
arrank5weap = arrank0weap + artier5;
arrank6weap = arrank0weap + launchertier0;
////Crew
crank0weap = pistoltier0 + smgtier0;
crank1weap = crank0weap + pistoltier1;
crank2weap = crank1weap + smgtier1;
crank3weap = crank2weap + pistoltier2;
crank4weap = crank3weap + smgtier2;
crank5weap = crank4weap + rifletier0;
crank6weap = crank5weap + rifletier1;
////Pilot
prank0weap = pistoltier0;
prank1weap = prank0weap + pistoltier1;
prank2weap = prank1weap + pistoltier2;
prank3weap = prank2weap + smgtier0;
prank4weap = prank3weap + smgtier1;
prank5weap = prank4weap + smgtier2;
prank6weap = prank5weap + rifletier0;

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
////Basic items
commonitems = availableItems + availableGoggles;
baserank0items = ["acc_flashlight"];
baserank1items = baserank0items + ["optic_Aco","optic_ACO_grn"];
baserank2items = baserank1items + ["optic_Holosight_smg","bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp"];
baserank3items = baserank2items + ["optic_Hamr","Laserdesignator","acc_pointer_IR","optic_MRCO","optic_ERCO_blk_F","optic_Arco"];
baserank4items = baserank3items + ["muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_H_SW","muzzle_snds_acp"];
baserank5items = baserank4items + ["Laserdesignator"];
baserank6items = baserank5items + ["optic_NVS","optic_DMS"];
////Basic gear
baserank0gear = ["U_B_CombatUniform_mcam","V_Chestrig_rgr","H_HelmetB_light"];
baserank1gear = baserank0gear + ["V_TacVest_oli","H_HelmetB"];
baserank2gear = baserank1gear + ["V_PlateCarrier1_rgr","U_B_Wetsuit","V_RebreatherB"];
baserank3gear = baserank2gear + ["V_PlateCarrier2_rgr","V_PlateCarrierGL_rgr"];
baserank4gear = baserank3gear + ["U_B_GhillieSuit","H_Booniehat_mcamo","H_HelmetB_camo"];
baserank5gear = baserank4gear + ["V_PlateCarrierSpec_rgr","H_HelmetSpecB"];
baserank6gear = baserank5gear + ["U_B_CombatUniform_mcam_tshirt"];
////Backpacks
bprank0 = ["B_AssaultPack_rgr"];
bprank1 = ["B_Kitbag_rgr"];
bprank2 = ["B_Carryall_mcamo"];
////Sniper items
sniperrank0items = ["optic_Hamr","optic_Arco","optic_ERCO_blk_F","optic_MRCO"];
sniperrank1items = sniperrank0items + ["Rangefinder","bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp"];
sniperrank2items = sniperrank1items + ["acc_pointer_IR","optic_DMS"];
sniperrank3items = sniperrank2items + ["optic_SOS","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_H_SW","muzzle_snds_acp"];
sniperrank4items = sniperrank3items + ["Laserdesignator","optic_AMS","optic_AMS_snd"];
sniperrank5items = sniperrank4items + ["optic_NVS"];
sniperrank6items = sniperrank5items + ["optic_LRPS"];
////Crew items
crewrank0items = ["H_HelmetCrew_B","U_B_CombatUniform_mcam_vest","V_TacVest_oli"];
////Pilot items
pilotrank0items = ["H_PilotHelmetHeli_B", "H_CrewHelmetHeli_B","U_B_HeliPilotCoveralls","V_TacVest_oli"];

EVO_opforGroundTrans = ["O_Truck_02_covered_F","O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F"];
EVO_opforAirTrans = ["O_Heli_Attack_02_black_F", "O_Heli_Attack_02_F","O_Heli_Light_02_v2_F", "O_Heli_Light_02_unarmed_F", "O_Heli_Light_02_F"];
EVO_opforInfantry = [
    (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")
];
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
	["Initialize"] call BIS_fnc_dynamicGroups;
};

//////////////////////////////////////
//Init Clients
//////////////////////////////////////

if (isDedicated || !hasInterface) exitWith {};
if (("persistentEVO" call BIS_fnc_getParamValue) == 1 && score player == 0) then {
    {
        _playerData = _x;
        _puid = getPlayerUID player;
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
    sleep 1;
  };
};

//handle = [player,
//[["ItemMap","ItemCompass","ItemWatch","ItemRadio","H_HelmetB"],"arifle_MX_F",["","","",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_CombatUniform_mcam",["FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","Chemlight_green"],"V_PlateCarrier1_rgr",["FirstAidKit","FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","SmokeShell","SmokeShellGreen","HandGrenade","HandGrenade"],"B_AssaultPack_mcamo",[],[["30Rnd_65x39_caseless_mag"],["16Rnd_9x21_Mag"],[],[]],"arifle_MX_F","FullAuto"]] execVM "scripts\setloadout.sqf";
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
