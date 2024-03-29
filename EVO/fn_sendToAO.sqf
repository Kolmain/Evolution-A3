private ["_currentTarget","_type","_init","_grp","_spawnPos","_null","_spawnPos2","_veh","_ret","_transport","_transGrp","_goTo","_heli","_heliGrp","_tank","_lz"];
//Declare variables and parameters
_currentTarget = [_this, 0, objNull] call BIS_fnc_param;
_type = [_this, 1, "error"] call BIS_fnc_param;
_init = [_this, 2, false] call BIS_fnc_param;
//If we started too late and the AO is over, error out
if (!RTonline && !(_currentTarget == currentTarget)) exitWith {["EVO_fnc_sendToAO called after AO change."] call BIS_fnc_error};
_grp = grpNull;
_spawnPos = position (targetLocations select (targetCounter + 1));
//Decide if we are workign with infantry or armor
switch (_type) do {
    case "infantry": {
		//working with infantry
    	if (_init) then {
			//if were starting the AO, spawn everything already there at a safe loc
    		_spawnPos = [position currentTarget, 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos;
    	} else {
			//if the ao is already started, spawn everything at a safe loc at the next AO
    		_spawnPos = [position (targetLocations select (targetCounter + 1)), 0, 1000, 10, 0, 2, 0, [], [position (targetLocations select (targetCounter + 1)), position (targetLocations select (targetCounter + 1))]] call BIS_fnc_findSafePos;
			while { _spawnPos distance position (targetLocations select (targetCounter + 1)) > 1000} do { _spawnPos = [position (targetLocations select (targetCounter + 1)), 0, 1000, 10, 0, 2, 0, [], [position (targetLocations select (targetCounter + 1)), position (targetLocations select (targetCounter + 1))]] call BIS_fnc_findSafePos; };
    	};
		//spawn the grp
		_grp = [_spawnPos, EAST, (EVO_opforInfantry call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;
		{
			if (HCconnected) then {
				//handoff to HC if needed
				handle = [_x] call EVO_fnc_sendToHC;
			};
			//add all units to currentAOUnits array for safe keeping
			currentAOunits pushBack _x;
			publicVariable "currentAOunits";
			//remove from current AO units on death
			_x AddMPEventHandler ["mpkilled", {
				currentAOunits = currentAOunits - [_this select 1];
				publicVariable "currentAOunits";
			}];
		} forEach units _grp;
		if (_init) then {
				//if starting ao then decide weather to hunker down or patrol. more patrol than defend
				if ([true, true, true, false, false, false, false, false, false, false, false] call bis_fnc_selectRandom) then {
					[_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskDefend;
				} else {
					[_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;
				};
		} else {
			//were not starting an ao, so we need to deliver units from the next ao to the current ao
			[_grp] spawn {
				_grp = _this select 0;
				if ([true, true, true, true, false] call bis_fnc_selectRandom) then {
					//insert via land
					//spawn pos near grp
					_spawnPos2 = [getPos leader _grp, 10, 25, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					while { _spawnPos2 distance getPos leader _grp > 100 } do { _spawnPos2 = [getPos leader _grp, 10, 100, 10, 0, 2, 0] call BIS_fnc_findSafePos; };
					//spawn the vehicle and declare trans var
					_ret = [_spawnPos2, (floor (random 360)), (EVO_opforGroundTrans call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
				    _transport = _ret select 0;
				    _transGrp = _ret select 2;
					//find nearest road and put the transport on it
				    _roads = _transport nearRoads 100;
				    _nearestRoad = [getPos _transport, _roads] call EVO_fnc_getNearest;
				    _transport setPos getPos _nearestRoad;
					_transport setDir (getDir _nearestRoad);
					{
						if (HCconnected) then {
							//send to HC if available
							handle = [_x] call EVO_fnc_sendToHC;
						};
						_x AddMPEventHandler ["mpkilled", {
							currentAOunits = currentAOunits - [_this select 1];
							publicVariable "currentAOunits";
						}];
					} forEach units _grp;
					//assign groups as cargo of trans
					{
				    	_x assignAsCargo _transport;
				    	_x moveInCargo _transport;
				    } forEach units _grp;
					//send trans into AO and deliver units
				    _goTo = [position currentTarget, 100, 250, 10, 0, 2, 0] call BIS_fnc_findSafePos;
				    _transport doMove _goTo;
				    waitUntil {_transport distance (position currentTarget) < 500};
				    doStop _transport;
				    {
				    	unassignVehicle  _x;
				    } forEach units _grp;
				    _grp leaveVehicle _transport;
				    waitUntil {count crew _transport == count units _transGrp};

						if ([true, true, true, false, false, false, false, false, false, false, false] call bis_fnc_selectRandom) then {
							[this, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskDefend;
						} else {
							[_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;
						};

				    doStop _transport;
				    _transport doMove _spawnPos2;
				    handle = [_transport, _spawnPos2] spawn {
				    	_spawnPos = _this select 1;
				    	_transport = _this select 0;
				    	waitUntil {(_transport distance _spawnPos) < 500};
				    	{
				    		deleteVehicle _x;
				    	} forEach units group driver _transport;
				    	deleteVehicle _transport;
					};
				} else {
					//insert via air
					_spawnPos2 = [position (targetLocations select (targetCounter + 1)), 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					while { _spawnPos2 distance (targetLocations select (targetCounter + 1)) > 1000 } do { _spawnPos2 = [position (targetLocations select (targetCounter + 1)), 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos; };
				    _ret = [_spawnPos2, (floor (random 360)), (EVO_opforAirTrans call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
				    _heli = _ret select 0;
				    _heliGrp = _ret select 2;
				    {
						if (HCconnected) then {
							handle = [_x] call EVO_fnc_sendToHC;
						};
					} forEach units _heliGrp;
				    {
				    	_x assignAsCargo _heli;
				    	_x moveInCargo _heli;
				    } forEach units _grp;
				    if ([true, false, false] call bis_fnc_selectRandom) then {
				    	//paradrop
					    _goTo = [position currentTarget, 100, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					    _heli doMove _goTo;
					    _heli flyInHeight 150;
					    waitUntil {([_heli, _goTo] call BIS_fnc_distance2D < 200)};
					    handle = [_heli] spawn EVO_fnc_paradrop;
					    doStop _heli;
					    _heli doMove getPos server;
					    handle = [_heli] spawn {
					    	_heli = _this select 0;
					    	waitUntil {(_heli distance server) < 1000};
					    	deleteVehicleCrew _heli;
					    	deleteVehicle _heli;
						};

			    		[_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;

					} else {
						//land
						_lz = current_landing_zones call bis_fnc_selectRandom;
						_goTo = position _lz;
						_heli flyInHeight 50;
						[group _heli, _goTo, _lz] spawn BIS_fnc_wpLand;
					    waitUntil {([_heli, _goTo] call BIS_fnc_distance2D < 300) || !alive _heli};
					    {
					    	unassignVehicle  _x;
					    	doGetOut _x
					    } forEach units _grp;
					    _grp leaveVehicle _heli;
					    waitUntil {count crew _heli == count units _heliGrp};
					    _heli doMove getPos server;
					    handle = [_heli] spawn {
					    	_heli = _this select 0;
					    	waitUntil {(_heli distance server) < 1000};
					    	deleteVehicleCrew _heli;
					    	deleteVehicle _heli;
						};

			    		[_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;

					};
				};
			};
		};
    };
	case "radio": {
		//working with infantry
    	if (_init) then {
			//if were starting the AO, spawn everything already there at a safe loc
    		_spawnPos = [getPos currentTargetRT, 10, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
    	} else {
			//if the ao is already started, spawn everything at a safe loc at the next AO
    		_spawnPos = [position (targetLocations select (targetCounter + 1)), 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos;
    	};
		//spawn the grp
		_grp = [_spawnPos, EAST, (EVO_opforInfantry call BIS_fnc_selectRandom)] call EVO_fnc_spawnGroup;
		{
			if (HCconnected) then {
				//handoff to HC if needed
				handle = [_x] call EVO_fnc_sendToHC;
			};
			//add all units to currentAOUnits array for safe keeping
			currentAOunits pushBack _x;
			publicVariable "currentAOunits";
			//remove from current AO units on death
			_x AddMPEventHandler ["mpkilled", {
				currentAOunits = currentAOunits - [_this select 1];
				publicVariable "currentAOunits";
			}];
		} forEach units _grp;
		if (_init) then {
				//if starting ao then decide weather to hunker down or patrol. more patrol than defend
				if ([true, true, true, false, false, false, false, false, false, false, false] call bis_fnc_selectRandom) then {
					[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskDefend;
				} else {
					[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskPatrol;
				};
		} else {
			//were not starting an ao, so we need to deliver units from the next ao to the current ao
			[_grp] spawn {
				_grp = _this select 0;
				if ([true, true, true, true, false] call bis_fnc_selectRandom) then {
					//insert via land
					//spawn pos near grp
					_spawnPos2 = [getPos leader _grp, 10, 25, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					while { _spawnPos2 distance getPos leader _grp > 100 } do { _spawnPos2 = [getPos leader _grp, 10, 100, 10, 0, 2, 0] call BIS_fnc_findSafePos; };
					//spawn the vehicle and declare trans var
					_ret = [_spawnPos2, (floor (random 360)), (EVO_opforGroundTrans call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
				    _transport = _ret select 0;
				    _transGrp = _ret select 2;
					//find nearest road and put the transport on it
				    _roads = _transport nearRoads 100;
				    _nearestRoad = [getPos _transport, _roads] call EVO_fnc_getNearest;
				    _transport setPos getPos _nearestRoad;
					{
						if (HCconnected) then {
							//send to HC if available
							handle = [_x] call EVO_fnc_sendToHC;
						};
						_x AddMPEventHandler ["mpkilled", {
							currentAOunits = currentAOunits - [_this select 1];
							publicVariable "currentAOunits";
						}];
					} forEach units _grp;
					//assign groups as cargo of trans
					{
				    	_x assignAsCargo _transport;
				    	_x moveInCargo _transport;
				    } forEach units _grp;
					//send trans into AO and deliver units
				    _goTo = [getPos currentTargetRT, 100, 250, 10, 0, 2, 0] call BIS_fnc_findSafePos;
				    _transport doMove _goTo;
				    waitUntil {_transport distance _goTo < 100};
				    doStop _transport;
				    {
				    	unassignVehicle  _x;
				    } forEach units _grp;
				    _grp leaveVehicle _transport;
						if ([true, true, true, false, false, false, false, false, false, false, false] call bis_fnc_selectRandom) then {
							[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskDefend;
						} else {
							[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskPatrol;
						};
				    _transport doMove _spawnPos2;
				    handle = [_transport, _spawnPos2] spawn {
				    	_spawnPos = _this select 1;
				    	_transport = _this select 0;
					    	waitUntil {{_x distance _heli < 1500} count allPlayers < 1};
				    	{
				    		deleteVehicle _x;
				    	} forEach units group driver _transport;
				    	deleteVehicle _transport;
					};
				} else {
					//insert via air
					_spawnPos2 = [position (targetLocations select (targetCounter + 1)), 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					while { _spawnPos2 distance (targetLocations select (targetCounter + 1)) > 1000 } do { _spawnPos2 = [position (targetLocations select (targetCounter + 1)), 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos; };
				    _ret = [_spawnPos2, (floor (random 360)), (EVO_opforAirTrans call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
				    _heli = _ret select 0;
				    _heliGrp = _ret select 2;
				    {
						if (HCconnected) then {
							handle = [_x] call EVO_fnc_sendToHC;
						};
					} forEach units _heliGrp;
				    {
				    	_x assignAsCargo _heli;
				    	_x moveInCargo _heli;
				    } forEach units _grp;
				    if ([true, false, false] call bis_fnc_selectRandom) then {
				    	//paradrop
					    _goTo = [getPos currentTargetRT, 100, 300, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					    _heli doMove _goTo;
					    _heli flyInHeight 150;
					    waitUntil {([_heli, _goTo] call BIS_fnc_distance2D < 200)};
					    handle = [_heli] spawn EVO_fnc_paradrop;
					    doStop _heli;
					    _heli doMove getPos server;
					    handle = [_heli] spawn {
					    	_heli = _this select 0;
					    	waitUntil {(_heli distance server) < 1000};
					    	{
					    		deleteVehicle _x;
					    	} forEach units group driver _heli;
					    	deleteVehicle _heli;
						};

			    		if ([true, true, true, false, false, false, false, false, false, false, false] call bis_fnc_selectRandom) then {
							[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskDefend;
						} else {
							[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskPatrol;
						};

					} else {
						//land
						_lz = current_landing_zones call bis_fnc_selectRandom;
						_goTo = position _lz;
						_heli flyInHeight 50;
						[group _heli, _goTo, _lz] spawn BIS_fnc_wpLand;
					    waitUntil {([_heli, _goTo] call BIS_fnc_distance2D < 300)};
					    {
					    	unassignVehicle  _x;
					    	doGetOut _x
					    } forEach units _grp;
					    _grp leaveVehicle _heli;
					    _heli doMove getPos server;
					    handle = [_heli] spawn {
					    	_heli = _this select 0;
					    	waitUntil {{_x distance _heli < 1500} count allPlayers < 1};
					    	deleteVehicleCrew _heli;
					    	deleteVehicle _heli;
						};

			    		if ([true, true, true, false, false, false, false, false, false, false, false] call bis_fnc_selectRandom) then {
							[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskDefend;
						} else {
							[_grp, getPos currentTargetRT, 100] call CBA_fnc_taskPatrol;
						};

					};
				};
			};
		};
    };
    case "armor": {
    		if (_init) then {
	    		_spawnPos = [position currentTarget, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
	    	} else {
	    		_spawnPos = [position (targetLocations select (targetCounter + 1)), 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos;
	    	};
			_ret = [_spawnPos, (floor (random 360)), (EVO_opforVehicles call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
			_tank = _ret select 0;
			_grp = _ret select 2;
			{
				if (HCconnected) then {
					handle = [_x] call EVO_fnc_sendToHC;
				};
				currentAOunits pushBack _x;
				publicVariable "currentAOunits";
				_x AddMPEventHandler ["mpkilled", {
					currentAOunits = currentAOunits - [_this select 1];
					publicVariable "currentAOunits";
				}];
			} forEach units _grp;
			_heavylift = [false, true] call BIS_fnc_selectRandom;
			if (_heavylift && !_init) then {
				_spawnPos = [position (targetLocations select (targetCounter + 1)), 10, 1000, 10, 0, 2, 0] call BIS_fnc_findSafePos;
				_ret = [_spawnPos, (floor (random 360)), EVO_opforHeavyLift, EAST] call EVO_fnc_spawnvehicle;
				_heli = _ret select 0;
				[_heli, _tank] spawn {
					_heli = _this select 0;
					_tank = _this select 1;
					_heli setSlingLoad _tank;
					driver _heli disableAI "FSM";
					driver _heli disableAI "TARGET";
					driver _heli disableAI "AUTOTARGET";
					group driver _heli setBehaviour "CARELESS";
					group driver _heli setCombatMode "BLUE";
					group driver _heli setSpeedMode "FULL";
					_lz = [position currentTarget, 150, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					driver _heli doMove _lz;
					_heli flyInHeight 50;
					_heli lock 3;
					waitUntil {([_heli, _lz] call BIS_fnc_distance2D < 100)};
					_heli flyInHeight 0;
					waitUntil {(isTouchingGround _tank)};
					{
						ropeCut [ _x, 5];
					} forEach ropes _heli;

			    	[group driver _tank, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;
					_heli setSpeedMode "LIMITED";
					_heli land "NONE";
					driver _heli doMove getPos server;
					_heli flyInHeight 50;
					[_heli] spawn {
						_heli = _this select 0;
					    waitUntil {{_x distance _heli < 1500} count allPlayers < 1};
						{
							deleteVehicle _x;
						} forEach crew _heli;
						deleteVehicle _heli;
					};
				};
			} else {

			    [_grp, getmarkerpos currentTargetMarkerName, 300] call CBA_fnc_taskPatrol;
				_grp setSpeedMode "FULL";
				[_grp] spawn {
					_grp = _this select 0;
					waitUntil {leader _grp distance getMarkerPos currentTargetMarkerName < 800 || !alive leader _grp};
					_grp setSpeedMode "LIMITED";
				};
			};

    };
    default {
     	["EVO_fnc_sendToAO threw DEFAULT switch."] call BIS_fnc_error;
    };
};

_grp;

