private ["_startLocation","_endLocation","_startMarker","_currentTargetMarker","_aoSize","_grp","_lastVehicle","_spawnPos","_dir","_classname","_ret","_vehicle","_road","_lastRoad","_wp","_score"];



[{
	titleCut ["","BLACK IN", 0];
	currentSideMission = "convoy";
	publicVariable "currentSideMission";
	if (isServer) then {
	//server
		_startLocation = convoyStart;
		_endLocation = convoyEnd;

		convoyStartMarker = format ["convoyStart_%1", markerCounter];
		_startMarker = createMarker [convoyStartMarker, position _startLocation ];
		convoyStartMarker setMarkerShape "ICON";
		convoyStartMarker setMarkerType "mil_start";
		convoyStartMarker setMarkerColor "Orange";
		convoyStartMarker setMarkerPos (position _startLocation);
		convoyStartMarker setMarkerText "Convoy Start";
		markerCounter = markerCounter + 1;

		convoyEndMarker = format ["convoyEnd_%1", markerCounter];
		_startMarker = createMarker [convoyEndMarker, position _endLocation ];
		convoyEndMarker setMarkerShape "ICON";
		convoyEndMarker setMarkerType "mil_end";
		convoyEndMarker setMarkerColor "Orange";
		convoyEndMarker setMarkerPos (position _endLocation);
		convoyEndMarker setMarkerText "Convoy End";
		markerCounter = markerCounter + 1;



		convoyStartAoMarker = format ["convoyStartAO_%1", markerCounter];
		_currentTargetMarker = createMarker [convoyStartAoMarker, position _startLocation];
		convoyStartAoMarker setMarkerShape "ELLIPSE";
		convoyStartAoMarker setMarkerBrush "SOLID";
		convoyStartAoMarker setMarkerDir direction _startLocation;
		_aoSize = [(((size _startLocation) select 0) + 500), (((size _startLocation) select 1) + 500)];
		convoyStartAoMarker setMarkerSize (size _startLocation);
		convoyStartAoMarker setMarkerColor "ColorEAST";
		convoyStartAoMarker setMarkerPos (position _startLocation);


		convoyEndAoMarker = format ["convoyEndAO_%1", markerCounter];
		_currentTargetMarker = createMarker [convoyEndAoMarker, position _startLocation];
		convoyEndAoMarker setMarkerShape "ELLIPSE";
		convoyEndAoMarker setMarkerBrush "SOLID";
		convoyEndAoMarker setMarkerDir direction _endLocation;
		_aoSize = [(((size _endLocation) select 0) + 500), (((size _endLocation) select 1) + 500)];
		convoyEndAoMarker setMarkerSize (size _endLocation);
		convoyEndAoMarker setMarkerColor "ColorEAST";
		convoyEndAoMarker setMarkerPos (position _endLocation);




		convoyTargets = [];
		convoyArray = [];
		_grp = createGroup EAST;
		//_lastVehicle = objNull;
		//_spawnPos = [position _startLocation, 10, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		//_spawnPos = getPos (((position convoyStart) nearRoads 100) select 0);
		//_dir = (getDir ((_spawnPos nearRoads 100) select 0) - 90 );
		for "_i" from 1 to 3 do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_classname = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MRAP_02_F","O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_APC_Wheeled_02_rcws_F"] call bis_fnc_selectRandom;
			_ret = [_spawnPos, 0, _classname, _grp] call bis_fnc_spawnvehicle;
			_vehicle = _ret select 0;
			convoyArray = convoyArray + [_vehicle];
		};

		for "_i" from 1 to (1 + (floor(random 3))) do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_classname = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_medical_F","O_Truck_02_box_F","O_Truck_03_device_F","O_Truck_03_medical_F","O_Truck_03_fuel_F","O_Truck_03_ammo_F","O_Truck_03_repair_F","O_MBT_02_arty_F"] call bis_fnc_selectRandom;
			_ret = [_spawnPos, 0, _classname, _grp] call bis_fnc_spawnvehicle;
			_vehicle = _ret select 0;
			convoyTargets = convoyTargets + [_vehicle];
			convoyArray = convoyArray + [_vehicle];
		};

		for "_i" from 1 to (1 + (floor(random 3))) do {
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_classname = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_MRAP_02_F","O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_APC_Wheeled_02_rcws_F"] call bis_fnc_selectRandom;
			_ret = [_spawnPos, 0, _classname, _grp] call bis_fnc_spawnvehicle;
			_vehicle = _ret select 0;
			convoyArray = convoyArray + [_vehicle];
		};
		if (HCconnected) then {
			{
				handle = [_x] call EVO_fnc_sendToHC;
			} forEach units _grp;
		};
		_spawnPos = getPos (((position convoyStart) nearRoads 100) select 0);

		_road = (position convoyStart nearRoads 100) select 0;
		_lastRoad = _road;
		_road = (roadsConnectedTo _lastRoad) select 1;
		_lastRoad = _road;

		{
			_x addEventHandler ["Killed", {_this spawn EVO_fnc_onUnitKilled}];
			if (_x distance position convoyStart > 300) then {

				_lastRoad = _road;
				_road = (roadsConnectedTo _lastRoad) select 1;
				_lastRoad = _road;
				vehicle _x setPos (getPos _road);
				vehicle _x setDir (getDir _road - 90);
				vehicle _x allowDamage false;
			};
		}  forEach units _grp;

		// [[convoyEndMarker], convoyArray, true] execVM "convoyDefend\convoyDefend_init.sqf";
		_wp = _grp addWaypoint [position convoyEnd, 0];
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointFormation "FILE";
		_wp setWaypointPosition [position convoyEnd, 0];
		_wp setWaypointSpeed "NORMAL";
		_wp setWaypointType "MOVE";

		sleep 30;
		{
			vehicle _x allowDamage true;
		}  forEach units _grp;


		handle = [] spawn {
			while {count convoyTargets > 0} do {
				{
					if (!alive _x) then {
						convoyTargets = convoyTargets - [_x];
					}
				} forEach convoyTargets;
				sleep 15;
			};
			sleep (random 15);
			currentSideMission = "none";
			publicVariable "currentSideMission";
			handle = [] spawn EVO_fnc_buildSideMissionArray;
			deleteMarker convoyEndMarker;
			deleteMarker convoyStartMarker;
			deleteMarker convoyStartAoMarker;
			deleteMarker convoyEndAoMarker;
		};
	};
	if (!isServer || !isMultiplayer) then {
	//client
		convoyTask = player createSimpleTask ["Ambush Convoy"];
		convoyTask setTaskState "Created";
		handle = [] spawn {
			while {currentSideMission == "convoy";} do {
			convoyTask setSimpleTaskDestination (getPos (convoyArray select 0));
			sleep 120;
			};
		};

		["TaskAssigned",["","Ambush Convoy"]] call BIS_fnc_showNotification;
		CROSSROADS sideChat "All units be advised, forward scouts report OPFOR convoy activity. Check the map and ambush their supply route!";
		handle = [] spawn {
			waitUntil {currentSideMission == "none";};
			if (player distance (position convoyEnd) < ((position convoyStart) distance (position convoyEnd))) then {
				playsound "goodjob";
				_score = player getVariable "EVO_score";
				_score = _score + 10;
				player setVariable ["EVO_score", _score, true];
				["PointsAdded",["BLUFOR completed a sidemission.", 10]] call BIS_fnc_showNotification;
			};
			sleep (random 15);
			convoyTask setTaskState "Succeeded";
			["TaskSucceeded",["","OPFOR Convoy Destroyed"]] call BIS_fnc_showNotification;
			CROSSROADS sideChat "Forward scouts report the convoy is retreating, nice job men!";
			currentSideMission = "none";
			publicVariable "currentSideMission";
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;