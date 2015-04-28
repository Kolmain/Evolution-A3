[{
	titleCut ["","BLACK IN", 0];
	currentSideMission = "attackMil";
	publicVariable "currentSideMission";
	if (isServer) then {
	//server
		_location = attackMilTarget;
		currentSideMissionMarker = format ["sidemission_%1", markerCounter];
		_aaMarker = createMarker [currentSideMissionMarker, position _location ];
		currentTargetMarkerName setMarkerShape "ELLIPSE";
		currentTargetMarkerName setMarkerBrush "Border";
		currentSideMissionMarker setMarkerSize [250, 250];
		currentSideMissionMarker setMarkerColor "ColorEAST";
		currentSideMissionMarker setMarkerPos (position _location);
		markerCounter = markerCounter + 1;
		publicVariable "currentSideMissionMarker";
		for "_i" from 1 to 5 do {
			_spawnPos = [position _location, 10, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
			if (HCconnected) then {
				{
					handle = [_x] call EVO_fnc_sendToHC;
				} forEach units _grp;
			};
			{
				_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			}  forEach units _grp;
			_null = [(leader _grp), currentSideMissionMarker, "RANDOM", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
		};
		handle = [] spawn {
			_eastUnits = 100;
			while {_eastUnits > 8} do {
				_allUnits = (position attackMilTarget) nearEntities [["Man", "Car", "Tank"], 300];
				{
					if ((side _x == EAST || side _x == independent) && alive _x) then {
						_eastUnits = _eastUnits + 1;
					}
				} forEach _allUnits;
				sleep 15;
			};
			sleep (random 15);
			currentSideMission = "none";
			publicVariable "currentSideMission";
			handle = [] spawn EVO_fnc_buildSideMissionArray;
			deleteMarker currentSideMissionMarker;
		};
	};
	if (!isServer || !isMultiplayer) then {
	//client
		milTask = player createSimpleTask ["Attack OPFOR Installation"];
		milTask setTaskState "Created";
		milTask setSimpleTaskDestination (getMarkerPos currentSideMissionMarker);
		["TaskAssigned",["","Attack OPFOR Installation"]] call BIS_fnc_showNotification;
		handle = [] spawn {
			waitUntil {currentSideMission == "none";};
			if (player distance attackMilTarget < 1000) then {
				playsound "goodjob";
				_score = player getVariable "EVO_score";
				_score = _score + 10;
				player setVariable ["EVO_score", _score, true];
				["PointsAdded",["BLUFOR completed a sidemission.", 10]] call BIS_fnc_showNotification;
			};
			sleep (random 15);
			milTask setTaskState "Succeeded";
			["TaskSucceeded",["","OPFOR Installation Seized"]] call BIS_fnc_showNotification;
			currentSideMission = "none";
			publicVariable "currentSideMission";
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;