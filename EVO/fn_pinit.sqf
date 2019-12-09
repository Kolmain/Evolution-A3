private ["_score","_player","_respawnPos","_ret","_vehicle","_displayName","_txt","_hitID","_handleHealID","_string","_currentLoadout"];

//////////////////////////////////////
//Setup Player Actions
//////////////////////////////////////
player addaction ["<t color='#CCCC00'>View Distance Settings</t>", CHVD_fnc_openDialog, nil,1,false,true,"","(player distance spawnBuilding) < 10"];
//player addaction ["<t color='#CCCC00'>Select Side Mission</t>","[] spawn EVO_fnc_osm;",nil,1,false,true,"","(player distance spawnBuilding) < 10 && currentSideMission == 'none'"];
player addaction ["<t color='#CCCC00'>Recruit Infantry</t>","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 10 && ((leader group player) == player)"];
player addaction ["<t color='#CCCC00'>HALO Drop</t>", EVO_fnc_paraInsert, nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player addaction ["<t color='#CCCC00'>Group Management</t>","disableserialization; ([] call BIS_fnc_displayMission) createDisplay 'RscDisplayDynamicGroups'",nil,1,false,true,"","(player distance spawnBuilding) < 10"];
player addaction ["<t color='#CCCC00'>Use FARP</t>", EVO_fnc_rearm,nil,1,false,true,"","(player distance (nearestObject [player, 'USMC_WarfareBBarracks']) < 20 && !(vehicle player isKindOf 'Man'))"];
player addaction ["<t color='#CCCC00'>Service Vehicle</t>", EVO_fnc_rearm,nil,1,false,true,"","((player distance hqbox) < 600) && !(vehicle player isKindOf 'Man')"];
player addaction ["<t color='#CCCC00'>Use MASH</t>", "player setDamage 0",nil,1,false,true,"","(player distance (nearestObject [player, 'USMC_WarfareBFieldhHospital']) < 20 && (vehicle player isKindOf 'Man'))"];
player setUnitLoadout loadout;
player enableFatigue false;
group player setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
_nil = [] spawn EVO_fnc_rank;
_nil = [] spawn EVO_fnc_supportManager;

//////////////////////////////////////
//Add MASH/FARP to Player
//////////////////////////////////////
if (typeOf player == "B_medic_F") then {
	player addaction ["<t color='#CCCC00'>Build MASH</t>","[] spawn EVO_fnc_deployMplayer",nil,1,false,true,"","player distance spawnBuilding > 800 && isTouchingGround player && speed player < 1 && vehicle player == player && animationState player != 'Acts_carFixingWheel' &&  (player distance (nearestObject [player, 'USMC_WarfareBFieldhHospital']) > 50)"];
	[["Gamemode","MASH"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};
if (typeOf player == "B_soldier_repair_F") then {
	player addaction ["<t color='#CCCC00'>Build FARP</t>","[] spawn EVO_fnc_deployEplayer",nil,1,false,true,"","player distance spawnBuilding > 800 && isTouchingGround player && speed player < 1 && vehicle player == player && animationState player != 'Acts_carFixingWheel' && (player distance (nearestObject [player, 'USMC_WarfareBBarracks']) > 50)"];
	[["Gamemode","FARP"], 15, "", 35, "", true, true, true, true] call BIS_fnc_advHint;
};

//////////////////////////////////////
//Player Rank/Vehicle Loop
//////////////////////////////////////
player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	handle = [player] call EVO_fnc_vehicleCheck;
}];

//////////////////////////////////////
//Add Handle Score to Server
//////////////////////////////////////
player addEventHandler ["HandleScore", {
	params ["_unit", "_object", "_score"];
	[] remoteExecCall ["EVO_fnc_rank", _unit];
	[] remoteExecCall ["EVO_fnc_supportManager", _unit];
	true
}];

