[{
	titleCut ["","BLACK IN", 0];
	currentSideMission = "baseDef";
	publicVariable "currentSideMission";
	attackingUnits = 0;
	if (isServer) then {
	//server
		_spawnLocations = [(targetLocations select 0), (targetLocations select 1)];


		for "_i" from 1 to 4 do {
			_spawnLocation = _spawnLocations call BIS_fnc_selectRandom;
			_spawnPos = [position _spawnLocation, 10, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
			if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{
				_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
				_x addEventHandler ["Killed", {attackingUnits = attackingUnits - 1}];
				attackingUnits = attackingUnits + 1;
			}  forEach units _grp;
			handle = [_grp, getPos spawnBuilding] call BIS_fnc_taskAttack;
		};
		for "_i" from 1 to 2 do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad_Weapons")] call BIS_fnc_spawnGroup;
			if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{
				_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
				_x addEventHandler ["Killed", {attackingUnits = attackingUnits - 1}];
				attackingUnits = attackingUnits + 1;
			}  forEach units _grp;
			   _spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			   _ret = [_spawnPos, (floor (random 360)), "O_Heli_Light_02_unarmed_F", EAST] call bis_fnc_spawnvehicle;
			   _heli = _ret select 0;
			   _heliGrp = _ret select 2;
			   if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _heliGrp;
			};
			{
			_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			}  forEach units _heliGrp;
			   {
			   		_x assignAsCargo _heli;
			   		_x moveInCargo _heli;
			   } forEach units _grp;
			   _heli doMove (getPos spawnBuilding);
			   _heli flyInHeight 150;
			   waitUntil {(_heli distance (getPos spawnBuilding)) < 500};
			   sleep random 10;
			   handle = [_heli] call EVO_fnc_paradrop;
			   sleep 5;
			   _heli doMove (getPos server);
			   handle = [_heli] spawn {
			   	_heli = _this select 0;
			   	waitUntil {(_heli distance server) < 1000};
			   	{
			   		deleteVehicle _x;
			   	} forEach units group driver _heli;
			   	deleteVehicle _heli;
			};
			handle = [_grp, getPos spawnBuilding] call BIS_fnc_taskAttack;
		};

		handle = [] spawn {
			waitUntil {attackingUnits < 5};
			sleep (random 15);
			currentSideMission = "none";
			publicVariable "currentSideMission";
			handle = [] spawn EVO_fnc_buildSideMissionArray;
		};
	};
	if (!isServer || !isMultiplayer) then {
	//client
		baseDefTask = player createSimpleTask ["Defend NATO Staging Base"];
		baseDefTask setTaskState "Created";
		baseDefTask setSimpleTaskDestination (getPos spawnBuilding);
		["TaskAssigned",["","Defend NATO Staging Base"]] call BIS_fnc_showNotification;
		handle = [] spawn {
			waitUntil {attackingUnits < 5};
			if (player distance spawnBuilding < 1000) then {
				playsound "goodjob";
				_score = player getVariable "EVO_score";
				_score = _score + 10;
				player setVariable ["EVO_score", _score, true];
				["PointsAdded",["BLUFOR completed a sidemission.", 10]] call BIS_fnc_showNotification;
			};
			sleep (random 15);
			baseDefTask setTaskState "Succeeded";
			["TaskSucceeded",["","OPFOR Counterattack Defeated"]] call BIS_fnc_showNotification;
			currentSideMission = "none";
			publicVariable "currentSideMission";
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;