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
[] execVM "scripts\randomWeather2.sqf";
[] execVM "scripts\clean.sqf";
[] execVM "bon_recruit_units\init.sqf";
0 = [] execvm "scripts\tpw_core.sqf";
0 = [0,1,60] execvm "scripts\tpw_radio.sqf";
CHVD_allowNoGrass = true;
CHVD_maxView = 2500;
CHVD_maxObj = 2500;
setTimeMultiplier ("timemultiplier" call BIS_fnc_getParamValue);


//////////////////////////////////////
//Init OPFOR AI System
//////////////////////////////////////
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
rank1vehicles = ["B_Truck_01_Repair_F","B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_medical_F","nonsteerable_parachute_f","steerable_parachute_f","CUP_B_HMMWV_Unarmed_USMC"];
rank2vehicles = ["b_truck_01_covered_f","b_truck_01_transport_f"];
rank3vehicles = ["CUP_B_HMMWV_MK19_USMC","CUP_B_HMMWV_M2_USMC","CUP_B_HMMWV_TOW_USMC","CUP_B_MH6J_USA"];
rank4vehicles = ["CUP_B_M1126_ICV_M2_Woodland_Slat","CUP_B_M113_USA","CUP_B_M1135_ATGMV_Woodland_Slat"];
rank5vehicles = ["CUP_B_M1126_ICV_MK19_Woodland","CUP_B_M163_USA","CUP_B_UH60L_US"];
rank6vehicles = ["CUP_B_AH6J_MP_USA","CUP_B_M1A2_TUSK_MG_USMC"];
rank7vehicles = ["CUP_B_AV8B_GBU12_USMC","CUP_B_AH1Z"];

{_x = toUpper(_x)} forEach rank1vehicles + rank2vehicles + rank3vehicles + rank4vehicles + rank5vehicles + rank6vehicles + rank7vehicles;

rank1weapons = ["CUP_arifle_M16A2","CUP_arifle_M16A4","CUP_launch_M136","CUP_hgun_M9","CUP_MP5A5"];
rank1items = ["acc_flashlight"];

rank2weapons = ["CUP_arifle_M16A2_GL","CUP_arifle_M16A4_GL","CUP_lmg_M240"];
rank2items = ["CUP_optic_CompM2_Black","CUP_Laserdesignator"];

rank3weapons = ["CUP_srifle_M24_wdl","CUP_arifle_M4A1"];
rank3items = ["B_UavTerminal","acc_pointer_IR","CUP_optic_RCO","NVGoggles"];

rank4weapons = ["CUP_arifle_M4A1_BUIS_GL","CUP_lmg_M249_E2","CUP_launch_FIM92Stinger"];
rank4items = ["CUP_optic_HoloBlack","CUP_acc_ANPEQ_2"];

rank5weapons = ["CUP_srifle_Mk12SPR","CUP_launch_Javelin"];
rank5items = ["CUP_optic_LeupoldMk4"];

rank6weapons = ["CUP_arifle_G36K","CUP_arifle_G36C","CUP_arifle_G36K"];
rank6items = ["CUP_optic_CWS"];

rank7weapons = ["CUP_srifle_M107_Base"];
rank7items = ["CUP_optic_ZDDot","CUP_optic_LeupoldM3LR"];

availableHeadgear = [];
availableGoggles = [];
availableUniforms = [];
availableVests = [];
availableItems = [
    "ItemWatch",
    "ItemCompass",
    "ItemGPS",
    "ItemRadio",
    "ItemMap",
    "MineDetector",
    "Binocular",
    "FirstAidKit",
    "Medikit",
    "ToolKit",
    "Item_MineDetector"
];
availableBackpacks = ["B_AssaultPack_rgr"];


EVO_opforGroundTrans = ["CUP_O_Ural_SLA",  "CUP_O_Ural_Open_SLA"];
EVO_opforAirTrans = ["CUP_O_Mi8_SLA_1","CUP_O_Mi8_SLA_2","CUP_O_UH1H_SLA"];
EVO_opforInfantry = [
    (configFile >> "CfgGroups" >> "EAST" >> "" >> "Infantry" >> "CUP_O_SLA_InfantrySquad"),
    (configFile >> "CfgGroups" >> "EAST" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_SpecialPurposeSquad")
];
EVO_opforVehicles = ["CUP_O_BRDM2_SLA","CUP_O_BRDM2_ATGM_SLA","CUP_O_BTR60_SLA","CUP_O_UAZ_Unarmed_SLA","CUP_O_UAZ_AGS30_SLA","CUP_O_UAZ_MG_SLA","CUP_O_UAZ_Open_SLA","CUP_O_Ural_ZU23_SLA","CUP_O_T72_SLA"];
EVO_opforAAA = "CUP_O_ZSU23_SLA";
EVO_opforCrew = "CUP_O_sla_Crew";
EVO_opforOfficer = "CUP_O_sla_Officer";
EVO_opforHeavyLift = "CUP_O_Mi8_SLA_1";
EVO_opforSnipers = ["CUP_O_SLA_Sniper_KSVK"];
EVO_opforCAS = ["CUP_O_Ka50_SLA","CUP_O_Su25_SLA","CUP_O_SU34_LGB_SLA","CUP_O_SU34_AGM_SLA"];
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
    //[WEST, spawnBuilding, "Staging Base"] call BIS_fnc_addRespawnPosition;
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
//_nil = [] spawn EVO_fnc_supportManager;
handle = [] spawn {
	while {true} do {
		waitUntil {player distance hqbox < 5};
	   	waitUntil {player distance hqbox > 5};
   		if (isTouchingGround player) then {
            loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
            [player, [missionNamespace, "LAST LOADOUT"]] call BIS_fnc_saveInventory ;
            profileNamespace setVariable ["EVO_loadout", loadout];
            saveProfileNamespace;
            //systemChat "Loadout saved to profile...";
        };
	};
};

handle = [player,
[["ItemMap","ItemCompass","ItemWatch","ItemRadio","Binocular","CUP_H_USArmy_HelmetMICH","G_Tactical_Black"],"CUP_arifle_M16A4_Base",["","","",""],"CUP_hgun_M9",["","","",""],"",["","","",""],"CUP_U_B_USArmy_TwoKnee",["FirstAidKit","FirstAidKit","FirstAidKit","CUP_15Rnd_9x19_M9","CUP_15Rnd_9x19_M9"],"V_PlateCarrier1_rgr",["CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_Stanag","CUP_HandGrenade_M67","CUP_HandGrenade_M67","SmokeShellBlue","SmokeShellRed"],"B_AssaultPack_rgr",[],[["CUP_30Rnd_556x45_Stanag"],["CUP_15Rnd_9x19_M9"],[],[]],"CUP_arifle_M16A4_Base","Single"]
] execVM "scripts\setloadout.sqf";
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
