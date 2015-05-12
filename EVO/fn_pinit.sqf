
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
//handle = [_player, loadout] execVM "scripts\setloadout.sqf";


player addaction ["<t color='#CCCC00'>View Distance Settings</t>", CHVD_fnc_openDialog, nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player addaction ["<t color='#CCCC00'>Select Side Mission</t>","[] spawn EVO_fnc_osm;",nil,1,false,true,"","(player distance spawnBuilding) < 10 && currentSideMission == 'none'"];
player addaction ["<t color='#CCCC00'>Recruit Infantry</t>","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 10 && ((leader group player) == player)"];
player addaction ["<t color='#CCCC00'>HALO Drop</t>","ATM_airdrop\atm_airdrop.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player addaction ["<t color='#CCCC00'>Group Management</t>","([] call BIS_fnc_displayMission) createDisplay 'RscDisplayDynamicGroups'",nil,1,false,true,"","(player distance spawnBuilding) < 10"];


if (alive currentTargetOF) then {
	currentTargetOF addAction [format["Capture %1", name currentTargetOF],"_this spawn EVO_fnc_officer",nil,1,false,true,"","alive currentTargetOF"];
} else {
	[] spawn {
		_loop = true;
		while {_loop} do {
		    sleep 10;
		    if (alive currentTargetOF) then {
		    	currentTargetOF addAction [format["Capture Colonel %1", name currentTargetOF],"_this spawn EVO_fnc_officer",nil,1,false,true,"","alive currentTargetOF"];
		    	_loop = false;
		    };
		};
	};
};


[[[player], {
	if (isServer) then {
		_this select 0 addEventHandler ["HandleScore", {[] spawn EVO_fnc_handleScore}];
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;

if (("fullArsenal" call BIS_fnc_getParamValue) == 0) then {
	player addaction ["Modify Loadout","['Open',true] spawn BIS_fnc_arsenal;",nil,1,false,true,"","(player distance spawnBuilding) < 10"];
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
	player addaction ["<t color='#CCCC00'>Build MASH</t>","[] call EVO_fnc_deployMplayer",nil,1,false,true,"","player distance spawnBuilding > 800"];
	[["Gamemode","MASH"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

if (typeOf player == "B_soldier_repair_F") then {
	//player addAction ["<t color='#CCCC00'>Build FARP</t>", "[] call EVO_fnc_deployEplayer;"];
	player addaction ["<t color='#CCCC00'>Build FARP</t>","[] call EVO_fnc_deployEplayer",nil,1,false,true,"","player distance spawnBuilding > 800"];
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
	[[[_this select 1, _this select 0], {
		if (player == (_this select 0) && player != _this select 1) then {
			_score = player getVariable "EVO_score";
			_score = _score + 1;
			player setVariable ["EVO_score", _score, true];
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
						handle = [_x] call EVO_fnc_vehicleCheck;
					};
				} forEach units group player;
			};
		};
		handle = [] call EVO_fnc_rank;
		_currentLoadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
		profileNamespace setVariable ["EVO_lastLoadout", _currentLoadout];
		profileNamespace setVariable ["EVO_score", (player getVariable "EVO_score")];
		profileNamespace setVariable ["EVO_lastPos", getPos player];
		saveProfileNamespace;
		sleep 1;
	};
};





