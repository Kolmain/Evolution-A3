//Init Third Party Scripts
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
[] execVM "scripts\randomWeather2.sqf";
[] execVM "scripts\clean.sqf";
[] execVM "bon_recruit_units\init.sqf";
CHHQ_showMarkers = true;
CHVD_allowNoGrass = true;
CHVD_maxView = 2500;
CHVD_maxObj = 2500;

if (isMultiplayer) then {enableSaving [false, false]};

//Init Common Variables
debug=false;
arsenalCrates = [];
militaryInstallations = [];
rank1 = 10;
rank2 = 30;
rank3 = 60;
rank4 = 100;
rank5 = 150;
rank6 = 200;
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

if (("mhqParam" call BIS_fnc_getParamValue) == 1) then {
	null = [firstMHQ, WEST] execVM "CHHQ.sqf";
	MHQ = firstMHQ;
} else {
	MHQ = objNull;
};

if (("r3fParam" call BIS_fnc_getParamValue) == 1) then {
	execVM "R3F_LOG\init.sqf";
};

if (!isMultiplayer) then {
	_nearUnits = nearestObjects [spawnBuilding, ["Man"], 100];
	{
		_unit = _x;
		if (!isPlayer _unit) then {
			deleteVehicle _unit;
		};
	} foreach _nearUnits;
};

if (!(isServer) && !(hasInterface)) then {
	HCconnected = true;
	publicVariable "HCconnected";
};


//init Server
if (isServer) then {
	[] spawn EVO_fnc_initEVO;
	EVO_sessionID = format["EVO_%1_%2", (floor(random 1000) + floor(random 1000)), floor(random 1000)];
	publicVariable "EVO_sessionID";
    [] spawn EVO_fnc_protectBase;
	["Initialize"] call BIS_fnc_dynamicGroups;
};

//init Client
if (isDedicated || !hasInterface) exitWith {};
_brief = [] execVM "briefing.sqf";
intro = true;
player execVM "scripts\intro.sqf";
[] execVM "scripts\player_markers.sqf";
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
WaitUntil{!intro};
playsound "Recall";
if (("bisJukebox" call BIS_fnc_getParamValue) == 1) then {
	_mus = [] spawn BIS_fnc_jukebox;
};
_amb = [] spawn EVO_fnc_amb;
//[hqbox, "PRIVATE"] call EVO_fnc_buildAmmoCrate;
recruitComm = [player, "recruit"] call BIS_fnc_addCommMenuItem;
if (!isNil "currentTargetOF") then {
    currentTargetOF addAction [format["<t color='#CCCC00'>Capture COLONEL %1</t>", name currentTargetOF],"_this spawn EVO_fnc_capture",nil,1,false,true,"","true"];
};
handle = [] spawn {
	while {true} do {
		waitUntil {player distance hqbox < 5};
	   	waitUntil {player distance hqbox > 5};
	   	if (isTouchingGround player) then {
	   		sleep 5;
			loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
			profileNamespace setVariable ["EVO_loadout", loadout];
			saveProfileNamespace;
			systemChat "Loadout saved to profile...";
		};
	};
};
_lastPos = [];
_profileSessionID = profileNamespace getVariable "EVO_sessionID";
if (isNil "_profileSessionID") then {
	_profileSessionID = EVO_sessionID;
	profileNamespace setVariable ["EVO_sessionID", _profileSessionID];
} else {
	if (_profileSessionID == EVO_sessionID) then {
		systemChat "PERSISTENT EVOLUTION DETECTED.";
		systemChat "Moving player to last location...";
		_lastPos = profileNamespace getVariable "EVO_lastPos";
		if (isNIl "_lastPos") then {
			_lastPos = getPos player;
			profileNamespace setVariable ["EVO_lastPos", _lastPos];
			saveProfileNamespace;
		};
		//player setPos ((_lastPos select 0), (_lastPos select 1), 0);
		player setPos _lastPos;
		_lastLoadout = profileNamespace getVariable "EVO_lastLoadout";
		systemChat "Setting player loadout to last known loadout...";
		handle = [player, _lastLoadout] execVM "scripts\setloadout.sqf";
		//loadout = _lastLoadout;
	} else {
		_profileSessionID = EVO_sessionID;
		profileNamespace setVariable ["EVO_sessionID", _profileSessionID];
		saveProfileNamespace;
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
