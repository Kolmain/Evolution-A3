private ["_score","_player","_respawnPos","_ret","_vehicle","_displayName","_txt","_hitID","_handleHealID","_string","_currentLoadout"];

//////////////////////////////////////
//Setup Player Actions
//////////////////////////////////////
player addaction ["<t color='#CCCC00'>View Distance Settings</t>", CHVD_fnc_openDialog, nil,1,false,true,"","(player distance spawnBuilding) < 10"];
//player addaction ["<t color='#CCCC00'>Select Side Mission</t>","[] spawn EVO_fnc_osm;",nil,1,false,true,"","(player distance spawnBuilding) < 10 && currentSideMission == 'none'"];
player addaction ["<t color='#CCCC00'>Recruit Infantry</t>","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 10 && ((leader group player) == player)"];
player addaction ["<t color='#CCCC00'>HALO Drop</t>", EVO_fnc_paraInsert, nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player addaction ["<t color='#CCCC00'>Group Management</t>","disableserialization; ([] call BIS_fnc_displayMission) createDisplay 'RscDisplayDynamicGroups'",nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player setUnitLoadout loadout;
[hqbox, (rank player)] call EVO_fnc_buildAmmoCrate;
call EVO_fnc_rank;
					group player setVariable ["VCM_NOFLANK",true]; //This command will stop the AI squad from executing advanced movement maneuvers.
					group player setVariable ["VCM_NORESCUE",true]; //This command will stop the AI squad from responding to calls for backup.
					group player setVariable ["VCM_TOUGHSQUAD",true]; //This command will stop the AI squad from calling for backup.
					group player setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
					group player setVariable ["VCM_DisableForm",true]; //This command will disable AI group from changing formations.	
					group player setVariable ["VCM_Skilldisable",true]; //This command will disable an AI group from being impacted by Vcom AI skill changes
//////////////////////////////////////
//Setup Player-centric Parameters
//////////////////////////////////////
if (("pfatigue" call BIS_fnc_getParamValue) == 0) then {
	player enableFatigue false;
} else {
	player enableFatigue true;
};

//////////////////////////////////////
//Add MASH/FARP to Player
//////////////////////////////////////
if (typeOf player == "B_medic_F") then {
	player addaction ["<t color='#CCCC00'>Build MASH</t>","[] call EVO_fnc_deployMplayer",nil,1,false,true,"","player distance spawnBuilding > 800 && isTouchingGround player && speed player < 1 && vehicle player == player && animationState player != 'Acts_carFixingWheel'"];
	[["Gamemode","MASH"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};
if (typeOf player == "B_soldier_repair_F") then {
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
			_score =  score player;
			_score = _score + 1;
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
				if (_LOS && isTouchingGround player) then {
					currentTargetRT setVariable ["EVO_seen", true, true];
					[player, format["Crossroads, be advised we have eyes on objective at %1, over.", currentTargetName]] call EVO_fnc_globalSideChat;
					sleep 4;
					[CROSSROADS, format ["Copy %1, updating map location now. Good luck, out.", groupID group player]] call EVO_fnc_globalSideChat;
					[[[], {
						["towerTask", getPos currentTargetRT] call BIS_fnc_taskSetDestination;
						
					}], "BIS_fnc_spawn"] call BIS_fnc_MP;
					["PointsAdded",["Objective Located", 3]] call BIS_fnc_showNotification;
					
					[player, 3] call BIS_fnc_addScore;
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
				if (_LOS && isTouchingGround player) then {
					currentTargetOF setVariable ["EVO_seen", true, true];
					[player, format["Crossroads, be advised we have eyes on HVT at %1, over.", currentTargetName]] call EVO_fnc_globalSideChat;
					sleep 4;
					[CROSSROADS, format ["Copy %1, updating map location now. Good luck, out.", groupID group player]] call EVO_fnc_globalSideChat;
					[[[], {
						["officerTask", getPos currentTargetOF] call BIS_fnc_taskSetDestination;
						
					}], "BIS_fnc_spawn"] call BIS_fnc_MP;
					["PointsAdded",["Objective Located", 3]] call BIS_fnc_showNotification;
					[player, 3] call BIS_fnc_addScore;
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
