waitUntil {!isNull player};


_profileSessionID = profileNamespace getVariable "EVO_sessionID";
if (isNil "_profileSessionID") then {
	_profileSessionID = EVO_sessionID;
	profileNamespace setVariable ["EVO_sessionID", _profileSessionID];
} else {
	if (_profileSessionID == EVO_sessionID) then {
		systemChat "PERSISTENT EVOLUTION DETECTED.";
		systemChat "Moving player to last location...";
		_lastPos = profileNamespace getVariable "EVO_lastPos";
		player setPos (_lastPos select 0, _lastPos select 1, 0);
		_lastLoadout = profileNamespace getVariable "EVO_lastLoadout";
		systemChat "Setting player loadout...";
		handle = [player, _lastLoadout] execVM "scripts\setloadout.sqf";
	} else {
		_profileSessionID = EVO_sessionID;
		profileNamespace setVariable ["EVO_sessionID", _profileSessionID];
	};
};


if (!isNil "loadout") then {
	handle = [player, loadout] execVM "scripts\setloadout.sqf";
} else {
	handle = [player,
	[["ItemMap","ItemCompass","ItemWatch","ItemRadio","H_HelmetB"],"arifle_MX_F",["","","",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_CombatUniform_mcam",["FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","Chemlight_green"],"V_PlateCarrier1_rgr",["FirstAidKit","FirstAidKit","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","SmokeShell","SmokeShellGreen","HandGrenade","HandGrenade"],"B_AssaultPack_mcamo",[],[["30Rnd_65x39_caseless_mag"],["16Rnd_9x21_Mag"],[],[]],"arifle_MX_F","FullAuto"]] execVM "scripts\setloadout.sqf";
	loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
};
_score = 0;
if (isMultiplayer) Then {
	_score = score player;
} else {
	_score = player getVariable "EVO_score";
	if (isNil "_score") then {
	_score = 0;
	}
};
player setVariable ["EVO_score", _score, true];

if (("bisJukebox" call BIS_fnc_getParamValue) == 1) then {
	_mus = [] spawn BIS_fnc_jukebox;
};

_amb = [] call EVO_fnc_amb;
//_brief = [] execVM "briefing.sqf";

player addaction ["Side Mission Selection","[] spawn EVO_fnc_osm;",nil,1,false,true,"","(player distance spawnBuilding) < 25 && currentSideMission == 'none'"];
player addaction ["Recruit Infantry","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25 && ((leader group player) == player)"];
player addaction ["HALO Insertion","ATM_airdrop\atm_airdrop.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
player addEventHandler ["HandleScore", {[] spawn EVO_fnc_handleScore}];

if (("fullArsenal" call BIS_fnc_getParamValue) == 0) then {
	player addaction ["Modify Loadout","['Open',true] spawn BIS_fnc_arsenal;",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
} else {
	if (!isNil "hqbox") then {
		deleteVehicle hqbox;
	};
	hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
};

if (("pfatigue" call BIS_fnc_getParamValue) == 0) then {
	player enableFatigue false;
} else {
	player enableFatigue true;
};

if (("pRespawnPoints" call BIS_fnc_getParamValue) == 1) then {
	_respawnPos = [(side player), player] spawn BIS_fnc_addRespawnPosition;
};

if (typeOf player == "B_medic_F") then {
	player addAction ["<t color='#CCCC00'>Build MASH</t>", "[] call EVO_fnc_deployMplayer;"];
	[["Gamemode","MASH"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

if (typeOf player == "B_soldier_repair_F") then {
	player addAction ["<t color='#CCCC00'>Build FARP</t>", "[] call EVO_fnc_deployEplayer;"];
	[["Gamemode","FARP"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

//[player, recruitComm] call BIS_fnc_removeCommMenuItem;
recruitComm = [player, "recruit"] call BIS_fnc_addCommMenuItem;
[["Gamemode","recruiting"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;

if (("pilotDressRequired" call BIS_fnc_getParamValue) == 1) then {
	_ret = [] spawn {
		while {alive player} do {
			sleep 1;
			_player = player;
			_vehicle = vehicle _player;
			if (_vehicle != _player) then {
				if (_vehicle isKindOf "Helicopter" && typeOf _vehicle != "nonsteerable_parachute_f" && typeOf _vehicle != "steerable_parachute_f" && headgear _player != "H_PilotHelmetHeli_B" && (driver _vehicle == player || gunner _vehicle == player)) then {
					loadout = [_player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
					handle = [_player, [["ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","H_PilotHelmetHeli_B","G_Tactical_Black"],"SMG_01_Holo_F",["","","optic_Holosight_smg",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_HeliPilotCoveralls",["FirstAidKit","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01","Chemlight_green"],"V_TacVest_oli",["FirstAidKit","FirstAidKit","FirstAidKit","30Rnd_45ACP_Mag_SMG_01","SmokeShellGreen","SmokeShellBlue","SmokeShellOrange","Chemlight_green","Chemlight_blue","B_IR_Grenade","30Rnd_45ACP_Mag_SMG_01","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag"],"",[],[["30Rnd_45ACP_Mag_SMG_01"],["16Rnd_9x21_Mag"],[],[]],"SMG_01_Holo_F","Single"]] execVM "scripts\setloadout.sqf";
					systemChat "Auto-switching loadout to helicopter pilot loadout...";
					handle = [_player, _vehicle] spawn {
						_player = _this select 0;
						_vehicle = _this select 1;
						waitUntil {driver _vehicle != _player};
						if (_player distance spawnBuilding < 1000) then {
							handle = [_player, loadout] execVM "scripts\setloadout.sqf";
							systemChat "Auto-switching back to previous loadout...";
						};
					};
				};
				if (_vehicle isKindOf "Plane" && typeOf _vehicle != "nonsteerable_parachute_f" && typeOf _vehicle != "steerable_parachute_f" && headgear _player != "H_PilotHelmetFighter_B" && driver _vehicle == player) then {
					loadout = [_player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
					handle = [_player, [["ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","H_PilotHelmetFighter_B","G_Tactical_Black"],"SMG_01_Holo_F",["","","optic_Holosight_smg",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_PilotCoveralls",["FirstAidKit","30Rnd_45ACP_Mag_SMG_01","SmokeShell","SmokeShellBlue","Chemlight_green","Chemlight_blue","B_IR_Grenade","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag"],"",[],"B_Parachute",[],[["30Rnd_45ACP_Mag_SMG_01"],["16Rnd_9x21_Mag"],[],[]],"SMG_01_Holo_F","Single"]] execVM "scripts\setloadout.sqf";
					systemChat "Auto-switching loadout to pilot loadout...";
					handle = [_player, _vehicle] spawn {
						_player = _this select 0;
						_vehicle = _this select 1;
						waitUntil {driver _vehicle != _player};
						if (_player distance spawnBuilding < 1000) then {
							handle = [_player, loadout] execVM "scripts\setloadout.sqf";
							systemChat "Auto-switching back to previous loadout...";
						};
					};
				};
			};
		};
	};
};
_ret = [] spawn {
	_hitID = player addEventHandler ["Hit",{
		if (alive player) then {
			player setVariable ["hint_hit", true, true];
		};
	}];
	waitUntil {(player getVariable "hint_hit")};
	player removeEventHandler ["Hit", _hitID];
	[["damage","fak"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

_handleHealID = player addEventHandler ["HandleHeal",{
	[[[_this select 1], {
		if (player == (_this select 0)) then {
			_score = player getVariable "KOL_score";
			_score = _score + 1;
			player setVariable ["KOL_score", _score, true];
			_string = format["Applied FAK to %1.", (getText(configFile >>  "CfgVehicles" >>  (typeOf _this select 2) >> "displayName"))];
			["PointsAdded",[_string, 1]] call BIS_fnc_showNotification;
			[player, 1] call BIS_fnc_addScore;
		};
	}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
}];

handle = [] spawn {
	while {alive player} do {
		waitUntil {player distance spawnBuilding < 25};
	   	waitUntil {player distance spawnBuilding > 25};
		loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
		systemChat "Loadout saved...";
	};
};

handle = [] spawn {
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

	while {alive player} do {
		if (("rankVehicles" call BIS_fnc_getParamValue) == 1) then {
			handle = [player] call EVO_fnc_vehicleCheck;
			if (leader group player == player) then {
				{
					if (!isPlayer _x) then {
						//_x setUnitRank (rank player);
						handle = [_x] call EVO_fnc_vehicleCheck;
					};
				} forEach units group player;
			};
		};
		handle = [] call EVO_fnc_rank;
		sleep 1;
	};
};





