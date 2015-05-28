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
[hqbox, "PRIVATE"] call EVO_fnc_buildAmmoCrate;
recruitComm = [player, "recruit"] call BIS_fnc_addCommMenuItem;
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
 	if (!(_newPlayer getVariable "BIS_revive_incapacitated")) then {
 		handle = [player, (profileNamespace getVariable "EVO_loadout")] execVM "scripts\setloadout.sqf";
 	} else {
 		//_newPlayer setDamage 0.5;
 		//handle = [player, (profileNamespace getVariable "EVO_currentLoadout")] execVM "scripts\setloadout.sqf";
 		//removeBackpack player;
 	};
}];

if (isMultiplayer) then { _nil = [] spawn EVO_fnc_pinit};
