private ["_score","_player","_respawnPos","_ret","_vehicle","_displayName","_txt","_hitID","_handleHealID","_string","_currentLoadout"];
//////////////////////////////////////
//Catch Player Score
//////////////////////////////////////
_score = 0;
if (isMultiplayer) Then {
	_score = score player;
} else {
	_score = player getVariable ["EVO_score", 0];
	if (isNil "_score") then {
	_score = 0;
	}
};
player setVariable ["EVO_score", _score, true];

//////////////////////////////////////
//Setup Player Actions
//////////////////////////////////////
player addaction ["<t color='#CCCC00'>View Distance Settings</t>", CHVD_fnc_openDialog, nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player addaction ["<t color='#CCCC00'>Select Side Mission</t>","[] spawn EVO_fnc_osm;",nil,1,false,true,"","(player distance spawnBuilding) < 10 && currentSideMission == 'none'"];
player addaction ["<t color='#CCCC00'>Recruit Infantry</t>","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 10 && ((leader group player) == player)"];
player addaction ["<t color='#CCCC00'>HALO Drop</t>", EVO_fnc_paraInsert, nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player addaction ["<t color='#CCCC00'>Group Management</t>","disableserialization; ([] call BIS_fnc_displayMission) createDisplay 'RscDisplayDynamicGroups'",nil,1,false,true,"","(player distance spawnBuilding) < 10"];
if (("mhqParam" call BIS_fnc_getParamValue) == 1) then {
	player addaction ["<t color='#CCCC00'>Go to MHQ</t>", "[player, MHQ] call BIS_fnc_moveToRespawnPosition", nil,1,false,true,"","(player distance spawnBuilding) < 10 && alive MHQ && isTouchingGround MHQ && canMove MHQ && fuel MHQ > 0"];
	player addaction ["<t color='#CCCC00'>Go to HQ</t>", "[player, spawnBuilding] call BIS_fnc_moveToRespawnPosition", nil,1,false,true,"","(player distance MHQ) < 10 && alive MHQ && isTouchingGround MHQ && canMove MHQ && fuel MHQ > 0"];
};

//////////////////////////////////////
//Setup Player-centric Parameters
//////////////////////////////////////
if (("fullArsenal" call BIS_fnc_getParamValue) == 0) then {
	//player addaction ["Arsenal","['Open',true] spawn BIS_fnc_arsenal;",nil,1,false,true,"","(player distance hqbox) < 10"];
	0 = ["AmmoboxInit",[hqbox, true]] spawn BIS_fnc_arsenal;
};

if (("pfatigue" call BIS_fnc_getParamValue) == 0) then {
	player enableFatigue false;
} else {
	player enableFatigue true;
};

if (("pRespawnPoints" call BIS_fnc_getParamValue) == 1) then {
	_respawnPos = [(group player), player] spawn BIS_fnc_addRespawnPosition;
};
/*
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
*/
//////////////////////////////////////
//Add MASH/FARP to Player
//////////////////////////////////////
if (typeOf player == "B_medic_F") then {
	//player addAction ["<t color='#CCCC00'>Build MASH</t>", "[] call EVO_fnc_deployMplayer;"];
	player addaction ["<t color='#CCCC00'>Build MASH</t>","[] call EVO_fnc_deployMplayer",nil,1,false,true,"","player distance spawnBuilding > 800 && isTouchingGround player && speed player < 1 && vehicle player == player && animationState player != 'Acts_carFixingWheel'"];
	[["Gamemode","MASH"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};
if (typeOf player == "B_soldier_repair_F") then {
	//player addAction ["<t color='#CCCC00'>Build FARP</t>", "[] call EVO_fnc_deployEplayer;"];
	player addaction ["<t color='#CCCC00'>Build FARP</t>","[] call EVO_fnc_deployEplayer",nil,1,false,true,"","player distance spawnBuilding > 800 && isTouchingGround player && speed player < 1 && vehicle player == player && animationState player != 'Acts_carFixingWheel'"];
	[["Gamemode","FARP"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};



//////////////////////////////////////
//Player Hint Inits
//////////////////////////////////////
_ret = [] spawn {
	_hitID = player addEventHandler ["Hit",{
		if (alive player) then {
			player setVariable ["hint_hit", true, true];
		};
	}];
	waitUntil {(player getVariable ["hint_hit", false])};
	player removeEventHandler ["Hit", _hitID];
	[["damage","fak"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

//////////////////////////////////////
//Player Healing Points
//////////////////////////////////////
_handleHealID = player addEventHandler ["HandleHeal",{
	[[[_this select 1, _this select 0], {
		if (player == (_this select 0) && player != _this select 1) then {
			_score = player getVariable ["EVO_score", 0];
			_score = _score + 1;
			player setVariable ["EVO_score", _score, true];
			_string = format["Applied FAK to %1.", (getText(configFile >>  "CfgVehicles" >>  (typeOf _this select 2) >> "displayName"))];
			["PointsAdded",[_string, 1]] call BIS_fnc_showNotification;
			[player, 1] call BIS_fnc_addScore;
		};
	}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
}];

//////////////////////////////////////
//Player RT/OF LOS Check
//////////////////////////////////////
handle = [] spawn {
	_LOS = false;
	_seen = false;
	while {alive player} do {
		sleep 10;
		if (!alive currentTargetRT) then {
			//
		} else {
			_LOS = [player, currentTargetRT, 800, 100] call EVO_fnc_hasLOS;
			_seen = currentTargetRT getVariable ["EVO_seen", false];
			if (_seen) then {
				//
			} else {
				if (_LOS) then {
					currentTargetRT setVariable ["EVO_seen", true, true];
					[player, format["Crossroads, be advised we have eyes on objective at %1, over.", currentTargetName]] call EVO_fnc_globalSideChat;
					sleep 4;
					[CROSSROADS, format ["Copy %1, updating map location now. Good luck, out.", groupID group player]] call EVO_fnc_globalSideChat;
					["towerTask", currentTargetRT] call BIS_fnc_taskSetDestination
				};
			};
		};
		if (!alive currentTargetOF) then {
			//
		} else {
			_LOS = [player, currentTargetOF, 800, 100] call EVO_fnc_hasLOS;
			_seen = currentTargetOF getVariable ["EVO_seen", false];
			if (_seen) then {
				//
			} else {
				if (_LOS) then {
					currentTargetOF setVariable ["EVO_seen", true, true];
					[player, format["Crossroads, be advised we have eyes on HVT at %1, over.", currentTargetName]] call EVO_fnc_globalSideChat;
					sleep 4;
					[CROSSROADS, format ["Copy %1, updating map location now. Good luck, out.", groupID group player]] call EVO_fnc_globalSideChat;
					["officerTask", currentTargetOF] call BIS_fnc_taskSetDestination
				};
			};
		};

	};
};

//////////////////////////////////////
//Player Rank/Vehicle Loop
//////////////////////////////////////

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
		if (("fullArsenal" call BIS_fnc_getParamValue) == 1) then {
			handle = [] call EVO_fnc_rank;
		};
		sleep 1;
	};
};

//////////////////////////////////////
//Add Handle Score to Server
//////////////////////////////////////


[[[player], {
	_unit = _this select 0;
	if (isServer) then {
		_unit addEventHandler ["HandleScore", {_this call EVO_fnc_handleScore}];
	};
}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
