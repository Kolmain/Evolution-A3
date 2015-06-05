private ["_currentTarget","_type","_init","_grp","_spawnPos","_null","_spawnPos2","_veh","_ret","_transport","_transGrp","_goTo","_heli","_heliGrp","_tank","_lz"];
_currentTarget = [_this, 0, objNull] call BIS_fnc_param;
_type = [_this, 1, "error"] call BIS_fnc_param;
_init = [_this, 2, false] call BIS_fnc_param;
if (!RTonline && !(_currentTarget == currentTarget)) exitWith {["EVO_fnc_sendToAO called after AO change."] call BIS_fnc_error};
_grp = grpNull;
_spawnPos = getPos server;
switch (_type) do {
    case "infantry": {
    	if (_init) then {
    		_spawnPos = [position currentTarget, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
    	} else {
    		_spawnPos = [position (targetLocations select (targetCounter + 1)), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
    	};
		_grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call EVO_fnc_spawnGroup;
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
		if (_init) then {
			_null = [(leader _grp), currentTargetMarkerName, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
		} else {
			[_grp] spawn {
				_grp = _this select 0;
				if ([true, true, false] call bis_fnc_selectRandom) then {
					//insert via land
					_spawnPos2 = [getPos leader _grp, 10, 25, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					//_veh = createVehicle [ call bis_fnc_selectRandom, _spawnPos2, [], 0, "NONE"];
					_ret = [_spawnPos2, (floor (random 360)), (["O_Truck_02_covered_F","O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_03_covered_F"] call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
				    _transport = _ret select 0;
				    _transGrp = _ret select 2;
					{
						if (HCconnected) then {
							handle = [_x] call EVO_fnc_sendToHC;
						};
						_x AddMPEventHandler ["mpkilled", {
							currentAOunits = currentAOunits - [_this select 1];
							publicVariable "currentAOunits";
						}];
					} forEach units _grp;
					{
				    	_x assignAsCargo _transport;
				    	_x moveInCargo _transport;
				    } forEach units _grp;
				    _goTo = [position currentTarget, 100, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
				    _transport doMove _goTo;
				    waitUntil {_transport distance _goTo < 100};
				    doStop _transport;
				    {
				    	unassignVehicle  _x;
				    } forEach units _grp;
				    _grp leaveVehicle _transport;
				    waitUntil {count crew _transport == count units _transGrp};
				    _null = [(leader _grp), currentTargetMarkerName, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
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
					_spawnPos2 = [position (targetLocations select (targetCounter + 1)), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
				    _ret = [_spawnPos2, (floor (random 360)), (["O_Heli_Attack_02_black_F", "O_Heli_Attack_02_F","O_Heli_Light_02_v2_F", "O_Heli_Light_02_unarmed_F", "O_Heli_Light_02_F"] call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
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
				    if ([true, false] call bis_fnc_selectRandom) then {
				    	//paradrop
					    _goTo = [position currentTarget, 100, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					    _heli doMove _goTo;
					    _heli flyInHeight 150;
					    waitUntil {([_heli, _goTo] call BIS_fnc_distance2D < 200)};
					    handle = [_heli] spawn EVO_fnc_paradrop;
					    _heli doMove getPos server;
					    //waitUntil {count crew _heli == count units _heliGrp};
					    _heli doMove getPos server;
					    handle = [_heli] spawn {
					    	_heli = _this select 0;
					    	waitUntil {(_heli distance server) < 1000};
					    	{
					    		deleteVehicle _x;
					    	} forEach units group driver _heli;
					    	deleteVehicle _heli;
						};
						_null = [(leader _grp), currentTargetMarkerName, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
					} else {
						//land
						 _goTo = [position currentTarget, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
					    _heli doMove _goTo;
					    _heli flyInHeight 50;
					    waitUntil {([_heli, _goTo] call BIS_fnc_distance2D < 300)};
					    {
					    	unassignVehicle  _x;
					    } forEach units _grp;
					    _grp leaveVehicle _heli;
					    waitUntil {count crew _heli == count units _heliGrp};
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
						_null = [(leader _grp), currentTargetMarkerName, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
					};
				};
			};
		};
    };
    case "armor": {
    		if (_init) then {
	    		_spawnPos = [position currentTarget, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
	    	} else {
	    		_spawnPos = [position (targetLocations select (targetCounter + 1)), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
	    	};
		    	_ret = [_spawnPos, (floor (random 360)), (["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F", "O_UGV_01_rcws_F","O_APC_Tracked_02_cannon_F", "O_MBT_02_cannon_F", "O_APC_Wheeled_02_rcws_F"] call BIS_fnc_selectRandom), EAST] call EVO_fnc_spawnvehicle;
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
			if ((typeOf _tank == "O_MRAP_02_gmg_F" || typeOf _tank == "O_MRAP_02_hmg_F" || typeOf _tank == "O_UGV_01_rcws_F") && !_init) then {
				_spawnPos = [position (targetLocations select (targetCounter + 1)), 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
				_ret = [_spawnPos, (floor (random 360)), "O_Heli_Transport_04_F", EAST] call EVO_fnc_spawnvehicle;
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
					_heli land "LAND";
					waitUntil {(isTouchingGround _tank)};
					{
						ropeCut [ _x, 5];
					} forEach ropes _heli;
					_null = [(leader group driver _tank), currentTargetMarkerName, "ONROAD", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
					group driver _tank setSpeedMode "LIMITED";
					_heli land "NONE";
					driver _heli doMove getPos server;
					_heli flyInHeight 50;
					[_heli] spawn {
						_heli = _this select 0;
						waitUntil {([_heli, getPos server] call BIS_fnc_distance2D < 500)};
						{
							deleteVehicle _x;
						} forEach crew _heli;
						deleteVehicle _heli;
					};
				};
			} else {
				_null = [(leader _grp), currentTargetMarkerName, "ONROAD", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
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

