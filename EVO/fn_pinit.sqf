private ["_profileSessionID","_lastPos","_lastLoadout","_score","_mus","_amb","_brief","_respawnPos","_ret","_player","_vehicle","_hitID","_handleHealID","_string"];


waitUntil {!isNull player};
0 = [] execVM "scripts\player_markers.sqf";
_lastPos = [];
[hqbox, "PRIVATE"] call EVO_fnc_buildAmmoCrate;
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



//_brief = [] execVM "briefing.sqf";

player addaction ["<t color='#CCCC00'>Select Side Mission</t>","[] spawn EVO_fnc_osm;",nil,1,false,true,"","(player distance spawnBuilding) < 25 && currentSideMission == 'none'"];
player addaction ["<t color='#CCCC00'>Recruit Infantry</t>","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25 && ((leader group player) == player)"];
player addaction ["<t color='#CCCC00'>HALO Drop</t>","ATM_airdrop\atm_airdrop.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
player addEventHandler ["HandleScore", {[] spawn EVO_fnc_handleScore}];

if (("fullArsenal" call BIS_fnc_getParamValue) == 0) then {
	player addaction ["Modify Loadout","['Open',true] spawn BIS_fnc_arsenal;",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
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
	//player addAction ["<t color='#CCCC00'>Build MASH</t>", "[] call EVO_fnc_deployMplayer;"];
	player addaction ["<t color='#CCCC00'>Build MASH</t>","[] call EVO_fnc_deployMplayer",nil,1,false,true,"","(player getVariable 'EVO_rank' != 'PRIVATE' && player distance spawnBuilding > 800)"];
	[["Gamemode","MASH"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

if (typeOf player == "B_soldier_repair_F") then {
	//player addAction ["<t color='#CCCC00'>Build FARP</t>", "[] call EVO_fnc_deployEplayer;"];
		player addaction ["<t color='#CCCC00'>Build FARP</t>","[] call EVO_fnc_deployEplayer",nil,1,false,true,"","(player getVariable 'EVO_rank' != 'PRIVATE' && player distance spawnBuilding > 800)"];
	[["Gamemode","FARP"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

if (("pilotDressRequired" call BIS_fnc_getParamValue) == 1) then {
	_ret = [] spawn {
		while {alive player} do {
			sleep 1;
			_player = player;
			_vehicle = vehicle _player;
			if (_vehicle != _player) then {
				if (_vehicle isKindOf "Helicopter" && typeOf _vehicle != "nonsteerable_parachute_f" && typeOf _vehicle != "steerable_parachute_f" && headgear _player != "H_PilotHelmetHeli_B" && (driver _vehicle == player || gunner _vehicle == player) && isTouchingGround _vehicle) then {
					if (player distance spawnBuilding < 1000) then {
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
					} else {
						_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
						_txt = format["You are not equipped to operate this %1. You require pilot gear.", _displayName];
						["notQualified",[_txt]] call BIS_fnc_showNotification;
						_player action ["engineOff", vehicle _player];
						sleep 1;
						_player action ["getOut", vehicle _player];
						_player action ["Eject", vehicle _player];
					};
				};
				if (_vehicle isKindOf "Plane" && typeOf _vehicle != "nonsteerable_parachute_f" && typeOf _vehicle != "steerable_parachute_f" && headgear _player != "H_PilotHelmetFighter_B" && driver _vehicle == player) then {
					if (player distance spawnBuilding < 1000) then {
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
					} else {
						_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
						_txt = format["You are not equipped to operate this %1. You require pilot gear.", _displayName];
						["notQualified",[_txt]] call BIS_fnc_showNotification;
						_player action ["engineOff", vehicle _player];
						sleep 1;
						_player action ["getOut", vehicle _player];
						_player action ["Eject", vehicle _player];
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





