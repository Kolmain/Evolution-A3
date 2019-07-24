[{
	currentSideMission = "attackMil";
	publicVariable "currentSideMission";
	currentSideMissionStatus = "ip";
	publicVariable "currentSideMissionStatus";
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
		for "_i" from 1 to (["Infantry", "Side"] call EVO_fnc_calculateOPFOR) do {
			_spawnPos = [getMarkerPos currentTargetMarkerName, 10, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_grp = [_spawnPos, EAST, (EVO_OPFORINFANTRY call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;

				if ([true, false] call bis_fnc_selectRandom) then {
					[_grp, getmarkerpos currentSideMissionMarker, 100] call CBA_fnc_taskDefend;
				} else {
					[_grp, getmarkerpos currentSideMissionMarker, 300] call CBA_fnc_taskPatrol;
				};
			{
				currentSidemissionUnits pushBack _x;
				publicVariable "currentSidemissionUnits";
				_x AddMPEventHandler ["mpkilled", {
					currentSidemissionUnits = currentSidemissionUnits - [_this select 1];
					publicVariable "currentSidemissionUnits";
				}];
			} forEach units _grp;
		};

		for "_i" from 1 to (["Armor", "Side"] call EVO_fnc_calculateOPFOR) do {
			_spawnPos = [getPos _vehicle, 10, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_ret = [_spawnPos, (floor (random 360)), (EVO_OPFORVEHICLES call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
		    _grp = _ret select 2;
			[_grp, getmarkerpos currentSideMissionMarker, 300] call CBA_fnc_taskPatrol;
		
			{
				currentSidemissionUnits pushBack _x;
				publicVariable "currentSidemissionUnits";
				_x AddMPEventHandler ["mpkilled", {
					currentSidemissionUnits = currentSidemissionUnits - [_this select 1];
					publicVariable "currentSidemissionUnits";
				}];
			} forEach units _grp;
		};


		handle = [] spawn {
			_loop = true;
			_count = 0;
			while {_loop} do {
				_count = 0;
				sleep 10;
				{
					if (alive _x && ([_x, getMarkerPos currentSidemissionUnits] call BIS_fnc_distance2D < 1000)) then {
					_count = _count + 1;
					};
				} forEach currentSidemissionUnits;
				if (_count < 6) then {
					_loop = false;
				};
			};
			if (_count > 0) then {
				{
					if ([true, false] call bis_fnc_selectRandom) then {
						[_x] spawn EVO_fnc_surrender;
					} else {
						[_x] spawn {
							_unit = _this select 0;
							_loop = true;
							while {_loop} do {
								_players = [_unit, 1000] call EVO_fnc_playersNearby;
								if (!_players || !alive _unit) then {
									_loop = false;
								};
							};
						};
					};
				} forEach currentSidemissionUnits;
			};
			sleep (random 15);
			[attackMilTask, "Succeeded", false] call bis_fnc_taskSetState;
			currentSideMissionStatus = "success";
			publicVariable "currentSideMissionStatus";
			currentSideMission = "none";
			publicVariable "currentSideMission";
			handle = [] spawn EVO_fnc_buildSideMissionArray;
			deleteMarker currentSideMissionMarker;
		};
		_tskDisplayName = format ["Attack SLA Installation"];
		attackMilTask = format ["attackMilTask%1", floor(random(1000))];
		[WEST, [attackMilTask], [_tskDisplayName, _tskDisplayName, ""], (position attackMilTarget), 1, 2, true] call BIS_fnc_taskCreate;
	};
	if (!isDedicated) then {
	//client
		["TaskAssigned",["","Attack SLA Installation"]] call BIS_fnc_showNotification;
		CROSSROADS sideChat "All units be advised, forward scouts report SLA activity at this location. Capture the military installation!";
		handle = [] spawn {
			waitUntil {currentSideMissionStatus != "ip"};
			if (player distance attackMilTarget < 1000) then {
				playsound "goodjob";
				[player, 10] call bis_fnc_addScore;
				["PointsAdded",["You completed a sidemission.", 10]] call BIS_fnc_showNotification;
			};
			sleep (random 15);
			CROSSROADS sideChat "Forward scouts report SLA activity at the military installation is declining. Nice job men!";
			["TaskSucceeded",["","OPFOR Installation Seized"]] call BIS_fnc_showNotification;
			currentSideMission = "none";
			publicVariable "currentSideMission";
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
