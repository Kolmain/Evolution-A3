[{
	currentSideMission = "reinforce";
	publicVariable "currentSideMission";
	attackingUnits = 100;
	currentSideMissionStatus = "ip";
	publicVariable "currentSideMissionStatus";
	if (isServer) then {
		attackingUnits = 0;
         	//server
         	reinforceSquad = [locationPosition defendTarget, WEST, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfTeam_AT")] call EVO_fnc_spawnGroup;
         	handle = [reinforceSquad, locationPosition defendTarget] call BIS_fnc_taskDefend;
		for "_i" from 1 to 4 do {
			_spawnPos = [locationPosition defendTarget, 500, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_grp = [_spawnPos, EAST, (EVO_opforInfantry call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;
			if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{

				_x AddMPEventHandler ["mpkilled", {
					attackingUnits = attackingUnits - 1;
				}];
				attackingUnits = attackingUnits + 1;
			}  forEach units _grp;
			handle = [_grp, locationPosition defendTarget] call BIS_fnc_taskAttack;
		};
		for "_i" from 1 to 2 do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			
			_grp = [_spawnPos, EAST, (EVO_opforInfantry call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;
			if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{

				_x AddMPEventHandler ["mpkilled", {
					attackingUnits = attackingUnits - 1;
				}];
				attackingUnits = attackingUnits + 1;
			}  forEach units _grp;
			   _spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			   _ret = [_spawnPos, (floor (random 360)), "CUP_O_MI8_SLA_1", EAST] call EVO_fnc_spawnvehicle;
			   _heli = _ret select 0;
			   _heliGrp = _ret select 2;
			   if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _heliGrp;
			};
			{

			}  forEach units _heliGrp;
			   {
			   		_x assignAsCargo _heli;
			   		_x moveInCargo _heli;
			   } forEach units _grp;
			   _heli doMove (locationPosition defendTarget);
			   _heli flyInHeight 150;
			   waitUntil {(_heli distance (locationPosition defendTarget)) < 500};
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
			handle = [_grp, locationPosition defendTarget] call BIS_fnc_taskAttack;
		};

		handle = [] spawn {
			waitUntil {attackingUnits < 5 || {alive _x} count units reinforceSquad < 1};
			sleep (random 15);
			if ({alive _x} count units reinforceSquad > 0) then {
				currentSideMissionStatus = "success";
				publicVariable "currentSideMissionStatus";
				[reinforceTask, "Succeeded", false] call bis_fnc_taskSetState;
			} else {
				currentSideMissionStatus = "failed";
				publicVariable "currentSideMissionStatus";
				[reinforceTask, "Failed", false] call bis_fnc_taskSetState;
			};
			currentSideMission = "none";
			publicVariable "currentSideMission";

			handle = [] spawn EVO_fnc_buildSideMissionArray;
		};
		_tskDisplayName = format ["Reinforce NATO Recon Units"];
		reinforceTask = format ["reinforceTask%1", floor(random(1000))];
		[WEST, [reinforceTask], [_tskDisplayName, _tskDisplayName, ""], (locationPosition defendTarget), 1, 2, true] call BIS_fnc_taskCreate;
	};
	if (!isDedicated) then {
	//client
		CROSSROADS sideChat "All units be advised, SLA ground assets are moving to engage our recon elements. All available teams move to reinforce them!";
		["TaskAssigned",["","Reinforce Recon Units"]] call BIS_fnc_showNotification;
		handle = [] spawn {
			waitUntil {currentSideMissionStatus != "ip"};
			if (currentSideMissionStatus == "success") then {
				if (player distance defendTarget < 1000) then {
					playsound "goodjob";
					[player, 10] call BIS_fnc_addScore;
					["PointsAdded",["You completed a sidemission.", 10]] call BIS_fnc_showNotification;
				};
				sleep (random 15);
				CROSSROADS sideChat "The SLA advance on our recon element has been defeated. Nice job men!";
				["TaskSucceeded",["","Recon Units Survived"]] call BIS_fnc_showNotification;

			} else {
				CROSSROADS sideChat "We've lost communications with our recon element, all units RTB and rearm.";
				["TaskFailed",["","Recon Units Killed"]] call BIS_fnc_showNotification;
			};
			currentSideMission = "none";
			publicVariable "currentSideMission";
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
