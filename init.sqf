//////////////////////////////////////
//Init EVO_Debug
//////////////////////////////////////
if (("evo_debug" call BIS_fnc_getParamValue) == 1) then {
    EVO_Debug = true;
    publicVariable "EVO_Debug";
    NSLVR_Debug = true;
} else {
    EVO_Debug = false;
    publicVariable "EVO_Debug";
    NSLVR_Debug = false;
};
//////////////////////////////////////
//Init Third Party Scripts
//////////////////////////////////////
[] execVM "scripts\randomWeather2.sqf";
//[] execVM "scripts\clean.sqf";
[] execVM "bon_recruit_units\init.sqf";
CHVD_allowNoGrass = true;
CHVD_maxView = 2500; 
CHVD_maxObj = 2500;
setTimeMultiplier ("timemultiplier" call BIS_fnc_getParamValue);


//////////////////////////////////////
//Init OPFOR AI System
//////////////////////////////////////
[] execVM "Vcom\VcomInit.sqf";

//////////////////////////////////////
//Init Common Variables
//////////////////////////////////////
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
RANK1VEHICLES = ["CUP_B_MTVR_REPAIR_USMC","CUP_B_MTVR_AMMO_USMC","CUP_B_MTVR_FUEL_USMC","CUP_B_HMMWV_AMBULANCE_USMC","NONSTEERABLE_PARACHUTE_F","STEERABLE_PARACHUTE_F","CUP_B_HMMWV_UNARMED_USMC"];
RANK2VEHICLES = ["CUP_B_MTVR_USMC"];
RANK3VEHICLES = ["CUP_B_HMMWV_MK19_USMC","CUP_B_HMMWV_M2_USMC","CUP_B_HMMWV_TOW_USMC","CUP_B_MH6J_USA"];
RANK4VEHICLES = ["CUP_B_M1126_ICV_M2_WOODLAND_SLAT","CUP_B_M113_USA","CUP_B_M1135_ATGMV_WOODLAND_SLAT"];
RANK5VEHICLES = ["CUP_B_M1126_ICV_MK19_WOODLAND","CUP_B_M163_USA","CUP_B_UH60L_US"];
RANK6VEHICLES = ["CUP_B_AH6J_MP_USA","CUP_B_M1A2_TUSK_MG_USMC"];
RANK7VEHICLES = ["CUP_B_AV8B_GBU12_USMC","CUP_B_AH1Z"];

RANK1WEAPONS = ["CUP_ARIFLE_M16A2","CUP_ARIFLE_M16A4","CUP_LAUNCH_M136","CUP_HGUN_M9","CUP_MP5A5"];
RANK1ITEMS = ["ACC_FLASHLIGHT"];

RANK2WEAPONS = ["CUP_ARIFLE_M16A2_GL","CUP_ARIFLE_M16A4_GL","CUP_LMG_M240"];
RANK2ITEMS = ["CUP_OPTIC_COMPM2_BLACK","CUP_LASERDESIGNATOR"];

RANK3WEAPONS = ["CUP_SRIFLE_M24_WDL","CUP_ARIFLE_M4A1"];
RANK3ITEMS = ["B_UAVTERMINAL","ACC_POINTER_IR","CUP_OPTIC_RCO","CUP_NVG_PVS15_black"];

RANK4WEAPONS = ["CUP_ARIFLE_M4A1_BUIS_GL","CUP_LMG_M249_E2","CUP_LAUNCH_FIM92STINGER"];
RANK4ITEMS = ["CUP_OPTIC_HOLOBLACK","CUP_ACC_ANPEQ_2"];

RANK5WEAPONS = ["CUP_SRIFLE_MK12SPR","CUP_LAUNCH_JAVELIN"];
RANK5ITEMS = ["CUP_OPTIC_LEUPOLDMK4"];

RANK6WEAPONS = ["CUP_ARIFLE_G36K","CUP_ARIFLE_G36C","CUP_ARIFLE_G36K"];
RANK6ITEMS = ["CUP_OPTIC_CWS"];

RANK7WEAPONS = ["CUP_SRIFLE_M107_BASE"];
RANK7ITEMS = ["CUP_OPTIC_ZDDOT","CUP_OPTIC_LEUPOLDM3LR"];

AVAILABLEHEADGEAR = ["CUP_H_USArmy_HelmetMICH"];
AVAILABLEGOGGLES = [];
AVAILABLEUNIFORMS = ["CUP_U_B_USArmy_TwoKnee"];
AVAILABLEVESTS = ["V_PlateCarrier1_rgr"];
AVAILABLEITEMS = [
    "ITEMWATCH",
    "ITEMCOMPASS",
    "ITEMGPS",
    "ITEMRADIO",
    "ITEMMAP",
    "MINEDETECTOR",
    "BINOCULAR",
    "FIRSTAIDKIT",
    "MEDIKIT",
    "TOOLKIT",
    "ITEM_MINEDETECTOR"
];
AVAILABLEBACKPACKS = ["B_ASSAULTPACK_RGR", "CUP_B_Kombat_Olive"];



//////////////////////////////////////
//Set OPFOR Classes
//////////////////////////////////////
EVO_OPFORGROUNDTRANS = ["CUP_O_URAL_SLA",  "CUP_O_URAL_OPEN_SLA"];
EVO_OPFORAIRTRANS = ["CUP_O_MI8_SLA_1","CUP_O_MI8_SLA_2","CUP_O_UH1H_SLA"];
EVO_OPFORINFANTRY = [
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySquad"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_SniperTeam"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySection"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionAA"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionAT"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionMG"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry_Militia" >> "CUP_O_SLA_InfantrySquad_Militia"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry_SpecOps" >> "CUP_O_SLA_SpecialPurposeSquad"),
    (configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry_Urban" >> "CUP_O_SLA_InfantrySquad_Urban")
];
EVO_OPFORVEHICLES = ["CUP_O_BRDM2_SLA","CUP_O_BRDM2_ATGM_SLA","CUP_O_BTR60_SLA","CUP_O_UAZ_UNARMED_SLA","CUP_O_UAZ_AGS30_SLA","CUP_O_UAZ_MG_SLA","CUP_O_UAZ_OPEN_SLA","CUP_O_URAL_ZU23_SLA","CUP_O_T72_SLA"];
EVO_OPFORAAA = "CUP_O_ZSU23_SLA";
EVO_OPFORCREW = "CUP_O_SLA_CREW";
EVO_OPFOROFFICER = "CUP_O_SLA_OFFICER";
EVO_OPFORHEAVYLIFT = "CUP_O_MI8_SLA_1";
EVO_OPFORSNIPERS = ["CUP_O_SLA_SNIPER_KSVK"];
EVO_OPFORCAS = ["CUP_O_KA50_SLA","CUP_O_SU25_SLA","CUP_O_SU34_LGB_SLA","CUP_O_SU34_AGM_SLA"];

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

_index = player addMPEventHandler ["MPRespawn", {
 	_newPlayer = _this select 0;
 	_oldPlayer = _this select 1;
 	_nil = [] spawn EVO_fnc_pinit;
}];

	player setUnitRank "PRIVATE";
	bon_max_units_allowed = 2;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	[hqbox, (rank player)] call EVO_fnc_buildAmmoCrate;
    _nil = [] spawn {
        while {true} do {
            call EVO_fnc_rank;
            sleep 20;
        };
    };
    _nil = [] spawn EVO_fnc_pinit;
