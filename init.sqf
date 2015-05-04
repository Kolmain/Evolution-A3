
debug=false;
EVO_sessionID = format["EVO_%1_%2", (floor(random 1000) + floor(random 1000)), floor(random 1000)];
//Init UPSMON script
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
handle = [] execVM "scripts\randomWeather2.sqf";
handle = [] execVM "scripts\clean.sqf";
handle = [] execVM "bon_recruit_units\init.sqf";
if (isServer) then {
	[] spawn EVO_fnc_initEVO;
};

enableSaving [false, false];
CHHQ_showMarkers = true;

militaryInstallations = [];
rank1 = 10;
rank2 = 30;
rank3 = 60;
rank4 = 100;
rank5 = 150;
rank6 = 200;
rank1vehicles = ["b_mrap_01_f","nonsteerable_parachute_f","steerable_parachute_f","b_boat_transport_01_f","b_g_boat_transport_01_f"];
rank2vehicles = ["b_heli_light_01_f","b_sdv_01_f","b_mrap_01_hmg_f","b_truck_01_covered_f","b_truck_01_mover_f","b_truck_01_box_f","b_truck_01_transport_f"];
rank3vehicles = ["b_heli_light_01_armed_f","b_heli_transport_01_f","b_heli_transport_01_camo_f","b_mrap_01_gmg_f","b_apc_wheeled_01_cannon_f"];
rank4vehicles = ["b_apc_tracked_01_rcws_f","b_apc_tracked_01_crv_f","b_boat_armed_01_minigun_f"];
rank5vehicles = ["b_apc_tracked_01_aa_f","b_mbt_01_cannon_f","b_mbt_01_tusk_f"];
rank6vehicles = ["b_heli_attack_01_f","b_mbt_01_arty_f","b_mbt_01_mlrs_f"];
rank7vehicles = ["b_plane_cas_01_f"];
rank1weapons = ["arifle_MX_F"];
//rank1magazines = ["HandGrenade", "SmokeShell", "SmokeShellBlue", "Chemlight_blue", "B_IR_Grenade", "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag_Tracer","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","20Rnd_556x45_UW_mag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Red","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","Titan_AA","Titan_AT","Titan_AP","9Rnd_45ACP_Mag","30Rnd_9x21_Mag","30Rnd_45ACP_Mag_SMG_01","10Rnd_762x51_Mag","20Rnd_762x51_Mag","6Rnd_45ACP_Cylinder","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","7Rnd_408_Mag"];
rank2weapons = ["arifle_MXC_F","arifle_MX_GL_F","launch_B_Titan_short_F","hgun_ACPC2_F","arifle_MXC_Black_F"];
rank2items = ["optic_Arco","optic_Hamr","optic_Aco","optic_Holosight","optic_Holosight_smg","optic_SOS","acc_flashlight","acc_pointer_IR","optic_MRCO"];
rank3weapons = ["arifle_MX_SW_F","arifle_MXM_F","arifle_SDAR_F","launch_B_Titan_F","arifle_MX_Black_F"];
rank3items = ["B_UavTerminal","Laserdesignator","muzzle_snds_B","muzzle_snds_M","muzzle_snds_L","muzzle_snds_H","muzzle_snds_acp","optic_DMS","optic_LRPS","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg"];
rank4weapons = ["arifle_TRG21_F","arifle_TRG20_F","SMG_01_F","arifle_MX_GL_Black_F","arifle_MX_SW_Black_F","hgun_PDW2000_F"];
rank5weapons = ["arifle_TRG21_GL_F","hgun_ACPC2_snds_F","SMG_02_F","arifle_MXM_Black_F"];
rank6weapons = ["arifle_Mk20_plain_F","srifle_DMR_01_SOS_F","srifle_EBR_DMS_F"];
rank7weapons = ["arifle_Mk20_GL_plain_F","hgun_Pistol_heavy_02_F","srifle_GM6_LRPS_F","srifle_LRR_LRPS_F"];
//Lists of items to include
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

CHVD_allowNoGrass = true;
CHVD_maxView = 2500;
CHVD_maxObj = 2500;
//HC_uid = getPlayerUID headlessClient;

if (("mhqParam" call BIS_fnc_getParamValue) == 1) then {
	null = [firstMHQ, WEST] execVM "CHHQ.sqf";
	MHQ = firstMHQ;
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
HCconnected = false;
if (!(isServer) && !(hasInterface)) then {
	HCconnected = true;
	publicVariable "HCconnected";
};
/*
if (HC_uid == getPlayerUID server) then {
	HC_uid = nil;
	HCconnected = false;
	publicVariable "HCconnected";
} else {
	HCconnected = true;
	publicVariable "HCconnected";
};
*/

	//[] spawn EVO_fnc_initEVO;
	/*
	onplayerconnected "
	if (owner headlessClient == _uid) then {
		HC_uid = _uid;
		publicVariable 'HC_uid';
		HCconnected = true;
		publicVariable 'HCconnected';
	}
	if (_uid == HC_uid) then {
		{
			if (owner _x == owner server && !isPlayer _x && side _x == EAST) then {
				handle = [_x] EVO_fnc_sendToHC;
				systemChat 'WARNING: Headless Client connected, sending all units to Headless Client.';
			};
		} forEach allUnits;
	};
	";
	onPlayerDisconnected "
	dunit = _name;
	_mark = format[""%1mash"",dunit];
	deleteMarker _mark;
	_mark = format[""%1farp"",dunit];
	deleteMarker _mark;
	if (_uid == HC_uid) then {
		HCconnected = false;
		publicVariable 'HCconnected';
		{
			if (owner _x == owner headlessClient && !isPlayer _x) then {
				handle = [_x] EVO_fnc_sendToServer;
				systemChat 'WARNING: Headless Client lost connection, sending all units back to Server.';
			};
		} forEach allUnits;
	};
	";
	*/


if (isDedicated || !hasInterface) exitWith {};
//Client
intro = true;
nul = player execVM "scripts\intro.sqf";
0 = [] execVM "scripts\player_markers.sqf";
//WaitUntil{scriptDone _intro};
playsound "Recall";
if (("bisJukebox" call BIS_fnc_getParamValue) == 1) then {
	_mus = [] spawn BIS_fnc_jukebox;
};
_amb = [] spawn EVO_fnc_amb;
[hqbox, "PRIVATE"] call EVO_fnc_buildAmmoCrate;
recruitComm = [player, "recruit"] call BIS_fnc_addCommMenuItem;
handle = [] spawn {
	//loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
	while {true} do {
		waitUntil {player distance hqbox < 5};
	   	waitUntil {player distance hqbox > 5};
	   	if (isTouchingGround player) then {
			loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
			systemChat "Loadout saved...";
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
		systemChat "Setting player loadout...";
		handle = [player, _lastLoadout] execVM "scripts\setloadout.sqf";
		loadout = _lastLoadout;
	} else {
		_profileSessionID = EVO_sessionID;
		profileNamespace setVariable ["EVO_sessionID", _profileSessionID];
		saveProfileNamespace;
	};
};

if (!isNil "loadout") then {
	handle = [player, loadout] execVM "scripts\setloadout.sqf";
} else {
	handle = [player,
	[["ItemMap","ItemCompass","ItemWatch","ItemRadio","H_HelmetB"],"arifle_MX_F",["","","",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_CombatUniform_mcam",["FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","Chemlight_green"],"V_PlateCarrier1_rgr",["FirstAidKit","FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","SmokeShell","SmokeShellGreen","HandGrenade","HandGrenade"],"B_AssaultPack_mcamo",[],[["30Rnd_65x39_caseless_mag"],["16Rnd_9x21_Mag"],[],[]],"arifle_MX_F","FullAuto"]] execVM "scripts\setloadout.sqf";
	loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
};
_index = player addMPEventHandler ["MPRespawn", {
 	_newPlayer = _this select 0;
 	_oldPlayer = _this select 1;
 	_newPlayer setVariable ["EVOrank", (_oldPlayer getVariable "EVOrank"), true];
 	_newPlayer setUnitRank (_oldPlayer getVariable "EVOrank");
 	_nil = [] spawn EVO_fnc_pinit;
 	if (!(_newPlayer getVariable "BIS_revive_incapacitated")) then {handle = [player, loadout] execVM "scripts\setloadout.sqf"};
}];

if (isMultiplayer) then { _nil = [] spawn EVO_fnc_pinit};