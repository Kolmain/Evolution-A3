debug=false;
//Init UPSMON script
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
handle = [] execVM "scripts\randomWeather2.sqf";
handle = [] execVM "scripts\clean.sqf";
handle = [] execVM "bon_recruit_units\init.sqf";

enableSaving [false, false];
CHHQ_showMarkers = true;

militaryInstallations = [];
etent = objNull;
epad = objNull;
ebox = objNull;
mtent = objNull;
hqbox = objNull;
rank1 = 10;
rank2 = 30;
rank3 = 60;
rank4 = 100;
rank5 = 150;
rank6 = 200;
rank1vehicles = ["b_boat_transport_01_f","b_g_boat_transport_01_f","b_mrap_01_f","b_truck_01_transport_f","nonsteerable_parachute_f","steerable_parachute_f"];
rank2vehicles = ["b_heli_light_01_f","b_sdv_01_f","b_mrap_01_hmg_f","b_truck_01_covered_f","b_truck_01_mover_f","b_truck_01_box_f"];
rank3vehicles = ["b_heli_light_01_armed_f","b_heli_transport_01_f","b_heli_transport_01_camo_f","b_mrap_01_gmg_f","b_apc_wheeled_01_cannon_f"];
rank4vehicles = ["b_apc_tracked_01_rcws_f","b_apc_tracked_01_crv_f","b_boat_armed_01_minigun_f"];
rank5vehicles = ["b_apc_tracked_01_aa_f","b_mbt_01_cannon_f","b_mbt_01_tusk_f"];
rank6vehicles = ["b_heli_attack_01_f","b_mbt_01_arty_f","b_mbt_01_mlrs_f"];
rank7vehicles = ["b_plane_cas_01_f"];
rank1weapons = ["arifle_MX_F"];
rank1magazines = ["HandGrenade", "SmokeShell", "SmokeShellBlue", "Chemlight_blue", "B_IR_Grenade", "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag_Tracer","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","20Rnd_556x45_UW_mag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Red","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","Titan_AA","Titan_AT","Titan_AP","9Rnd_45ACP_Mag","30Rnd_9x21_Mag","30Rnd_45ACP_Mag_SMG_01","10Rnd_762x51_Mag","20Rnd_762x51_Mag","6Rnd_45ACP_Cylinder","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","7Rnd_408_Mag"];
rank2weapons = ["arifle_MXC_F","arifle_MX_GL_F","launch_B_Titan_short_F","hgun_ACPC2_F","arifle_MXC_Black_F"];
rank2items = ["optic_Arco","optic_Hamr","optic_Aco","optic_Holosight","optic_Holosight_smg","optic_SOS","acc_flashlight","acc_pointer_IR","optic_MRCO"];
rank3weapons = ["arifle_MX_SW_F","arifle_MXM_F","arifle_SDAR_F","launch_B_Titan_F","arifle_MX_Black_F"];
rank3items = ["B_UavTerminal","Laserdesignator","muzzle_snds_B","muzzle_snds_M","muzzle_snds_L","muzzle_snds_H","muzzle_snds_acp","optic_DMS","optic_LRPS","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg"];
rank4weapons = ["arifle_TRG21_F","arifle_TRG20_F","SMG_01_F","arifle_MX_GL_Black_F","arifle_MX_SW_Black_F","hgun_PDW2000_F"];
rank5weapons = ["arifle_TRG21_GL_F","hgun_ACPC2_snds_F","SMG_02_F","arifle_MXM_Black_F"];
rank6weapons = ["arifle_Mk20_plain_F","srifle_DMR_01_SOS_F","srifle_EBR_DMS_F"];
rank7weapons = ["arifle_Mk20_GL_plain_F","hgun_Pistol_heavy_02_F","srifle_GM6_LRPS_F","srifle_LRR_LRPS_F"];


CHVD_allowNoGrass = true;
CHVD_maxView = 2500;
CHVD_maxObj = 2500;
HCconnected = false;
HC_uid = getPlayerUID headlessClient;

if (!isMultiplayer) then {
	_nearUnits = nearestObjects [spawnBuilding, ["Man"], 100];
	{
		_unit = _x;
		if (!isPlayer _unit && _unit != ammoOfficer) then {
			deleteVehicle _unit;
		};
	} foreach _nearUnits;
};

if (HC_uid == getPlayerUID server) then {
	HC_uid = nil;
	HCconnected = false;
	publicVariable "HCconnected";
} else {
	HCconnected = true;
	publicVariable "HCconnected";
};

if (isServer) then
{
	[] spawn EVO_fnc_initEVO;
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
};


if (isServer && isMultiplayer) exitWith {};


//Client
_intro = player execVM "scripts\intro.sqf";
WaitUntil{scriptDone _intro};
playsound "Recall";
//_brief = [] execVM "briefing.sqf";
//titleCut ["","black faded", 0];
//loadout = [player] call compile preprocessFileLineNumbers "get_loadout.sqf";

