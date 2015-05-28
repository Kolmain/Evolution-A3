_currentTarget = [_this, 0, objNull] call BIS_fnc_param;
_type = [_this, 1, "error"] call BIS_fnc_param;
if (_unit == objNull || _type == "error") exitWith {["EVO_fnc_sendToAO called without parameters."] call BIS_fnc_error};
if (!RTonline && !_currentTarget == currentTarget) exitWith {["EVO_fnc_sendToAO called after AO change."] call BIS_fnc_error};
_nextAO = targetLocations select (targetCounter + 1);

switch (_type) do {
    case "infantry": {
    	_spawnPos = [position _nextAO, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		_grp = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		{
			if (HCconnected) then {
				handle = [_x] call EVO_fnc_sendToHC;
			};
			currentAOunits pushBack _x;
			publicVariable "currentAOunits";
			_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
			_x AddMPEventHandler ["mpkilled", {currentAOunits = currentAOunits - [_this select 1]}];
		} forEach units _grp;

		if ([true, true, false] call bis_fnc_selectRandom) then {
			//insert via land
			// TODO

		} else {
			//paradrop
			_spawnPos = [getPos server, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _ret = [_spawnPos, (floor (random 360)), (["O_Heli_Transport_04_bench_F", "O_Heli_Attack_02_black_F", "O_Heli_Attack_02_F","O_Heli_Light_02_v2_F", "O_Heli_Light_02_unarmed_F", "O_Heli_Light_02_F"] call BIS_fnc_selectRandom), EAST] call bis_fnc_spawnvehicle;
		    _heli = _ret select 0;
		    _heliGrp = _ret select 2;
		    _heli AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
		    {
				if (HCconnected) then {
					handle = [_x] call EVO_fnc_sendToHC;
				};
				_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
			} forEach units _heliGrp;
		    {
		    	_x assignAsCargo _heli;
		    	_x moveInCargo _heli;
		    } forEach units _grp;
		    _heli doMove (getMarkerPos currentTargetMarkerName);
		    _heli flyInHeight 150;
		    waitUntil {([_heli, currentTarget] call BIS_fnc_distance2D < 200)};
		    handle = [_heli] spawn EVO_fnc_paradrop;
		    doStop _heli;
		    waitUntil {count (assignedCargo _heli) == 0};
		    doStop _heli;
		    _heli doMove _spawnPos;
		    handle = [_heli, _spawnPos] spawn {
		    	_spawnPos = _this select 1;
		    	_heli = _this select 0;
		    	waitUntil {(_heli distance _spawnPos) < 1000};
		    	{
		    		deleteVehicle _x;
		    	} forEach units group driver _heli;
		    	deleteVehicle _heli;
			};
			_null = [(leader _grp), currentTargetMarkerName, "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";

		};
    };
    case "armor": {
    		_spawnPos = [position _nextAO, 10, 500, 10, 0, 2, 0] call BIS_fnc_findSafePos;
		    _ret = [_spawnPos, (floor (random 360)), (["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F", "O_UGV_01_rcws_F","O_APC_Tracked_02_cannon_F", "O_MBT_02_cannon_F", "O_APC_Wheeled_02_rcws_F"] call BIS_fnc_selectRandom), EAST] call bis_fnc_spawnvehicle;
		    _tank = _ret select 0;
		    _grp = _ret select 2;
		    {
				if (HCconnected) then {
					handle = [_x] call EVO_fnc_sendToHC;
				};
				currentAOunits pushBack _x;
				publicVariable "currentAOunits";
				_x AddMPEventHandler ["mpkilled", {_this spawn EVO_fnc_onUnitKilled}];
				_x AddMPEventHandler ["mpkilled", {currentAOunits = currentAOunits - [_this select 1]}];
			} forEach units _grp;
			_null = [(leader _grp), currentTargetMarkerName, "ONROAD", "NOSMOKE", "DELETE:", 80, "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
			_grp setSpeedMode "LIMITED";
    };
    case "motorized": {


	};

    default {
     	["EVO_fnc_sendToAO threw DEFAULT switch."] call BIS_fnc_error;
    };
};

_grp

