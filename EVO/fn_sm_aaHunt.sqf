private ["_vehicle","_aaMarker","_spawnPos","_grp","_null","_tskDisplayName","_score"];
if (currentSideMission != "none") exitWith {systemChat "Sidemission has already been chosen!"};

[{
	titleCut ["","BLACK IN", 0];
	currentSideMission = "aaHunt";
	currentSideMissionStatus = "ip";
	currentSideMissionsUnits = [];
	publicVariable "currentSideMissionsUnits";
	publicVariable "currentSideMissionStatus";
	publicVariable "currentSideMission";
	if (isServer) then {
	//server
		_vehicle = aaHuntTarget;
		currentSideMissionMarker = format ["%1", (markerCounter + 100)];
		publicVariable "currentSideMissionMarker";
		_aaMarker = createMarker [currentSideMissionMarker, position _vehicle ];
		currentTargetMarkerName setMarkerShape "ELLIPSE";
		currentTargetMarkerName setMarkerBrush "Border";
		currentSideMissionMarker setMarkerSize [200, 200];
		currentSideMissionMarker setMarkerColor "ColorEAST";
		currentSideMissionMarker setMarkerPos (GetPos _vehicle);
		markerCounter = markerCounter + 1;
		publicVariable "currentSideMissionMarker";
		for "_i" from 1 to (["Infantry", "Side"] call EVO_fnc_calculateOPFOR) do {
			_spawnPos = [getPos _vehicle, 10, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
			_grp = [_spawnPos, EAST, (EVO_opforInfantry call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;
			[_grp, getPos _vehicle, 100] call CBA_fnc_taskDefend;
			{
				currentSideMissionsUnits pushBack _x;
			} forEach units _grp;
		};
		_tskDisplayName = format ["Destroy AAA Battery"];
		aaHuntTask = format ["aaHuntTask%1", floor(random(1000))];
		[WEST, [aaHuntTask], [_tskDisplayName, _tskDisplayName, ""], (getMarkerPos currentSideMissionMarker), 1, 2, true] call BIS_fnc_taskCreate;
		handle = [] spawn {
			waitUntil {!alive aaHuntTarget};
			sleep (random 15);
			currentSideMissionStatus = "success";
			publicVariable "currentSideMissionStatus";
			[aaHuntTask, "Succeeded", false] call bis_fnc_taskSetState;
			_count = {alive _x} count currentSideMissionsUnits;
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
							deleteVehicle _unit;
						};
					};
				} forEach currentSideMissionsUnits;
			};
			currentSideMission = "none";
			publicVariable "currentSideMission";
			handle = [] spawn EVO_fnc_buildSideMissionArray;
			deleteMarker currentSideMissionMarker;
		};
	};
	if (!isDedicated) then {
	//client
		["TaskAssigned",["","Destroy AAA Battery"]] call BIS_fnc_showNotification;
		CROSSROADS sideChat "All units be advised, forward scouts report an AAA battery and have marked it on the map at HQ. Friendly air assets need that battery destroyed!";
		handle = [] spawn {
			waitUntil {currentSideMissionStatus != "ip"};
			if (player distance aaHuntTarget < 1000) then {
				playsound "goodjob";
				_score = player getVariable ["EVO_score", 0];
				_score = _score + 10;
				player setVariable ["EVO_score", _score, true];
				["PointsAdded",["BLUFOR completed a sidemission.", 10]] call BIS_fnc_showNotification;
			};
			sleep (random 15);
			CROSSROADS sideChat "Forward scouts report the AAA battery was destroyed. Outstanding job men!";
			["TaskSucceeded",["","AAA Battery Destroyed"]] call BIS_fnc_showNotification;
			currentSideMission = "none";
			publicVariable "currentSideMission";
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;