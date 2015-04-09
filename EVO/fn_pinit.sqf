waitUntil {!isNull player};
handle = [player, loadout] execVM "set_loadout.sqf";
_mus = [] spawn BIS_fnc_jukebox;
_amb = [] call EVO_fnc_amb;
//_brief = [] execVM "briefing.sqf";
player addaction ["Modify Loadout","['Open',true] spawn BIS_fnc_arsenal;",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
player addaction ["Recruit Infantry","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
player addaction ["<t color='#ff9900'>HALO Insertion</t>","ATM_airdrop\atm_airdrop.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25"];

if (!isNull hqbox) then {deleteVehicle hqbox};

hqbox = "Box_Ammo_F" createVehicleLocal (getMarkerPos "ammob1");
["AmmoboxInit",[hqbox, false, {true}]] spawn BIS_fnc_arsenal;

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
		if (player == (_this select 1)) then {
			_score = player getVariable "KOL_score";
			_score = _score + 1;
			player setVariable ["KOL_score", _score, true];
			["PointsAdded",["Applied FAK to Friendly Unit.", 1]] call BIS_fnc_showNotification;
			[player, 1] call BIS_fnc_addScore;
		};
	}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
}];

handle = [] spawn {
	waitUntil {player distance spawnBuilding > 25};
	loadout = [player] call compile preprocessFileLineNumbers "get_loadout.sqf";
	systemChat "Loadout saved...";
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
		handle = [player] call EVO_fnc_vehicleCheck;
		if (leader group player == player) then {
			{
				if (!isPlayer _x) then {
					//_x setUnitRank (rank player);
					handle = [_x] call EVO_fnc_vehicleCheck;
				};
			} forEach units group player;
		};
		handle = [] call EVO_fnc_rank;
		sleep 3;
	};
};





