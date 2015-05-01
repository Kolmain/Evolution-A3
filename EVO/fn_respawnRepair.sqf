private ["_veh","_displayName","_markerName","_vehMarker","_vehicle","_killer","_mhq","_classname","_dir","_pos","_vehPos","_posDriverExit","_posCommanderExit","_posCargoExit","_posDriver","_posCommander","_posCargo","_driverExitOffset","_deadPos","_deadExitPos","_newVehicle","_null"];


_veh = _this select 0;
while {alive _veh} do {
				if (!canMove _veh) then {
					_displayName = getText(configFile >>  "CfgVehicles" >>  (typeOf _veh) >> "displayName");
					_markerName = format ["immobil_%1", markerCounter];
					_vehMarker = createMarker [_markerName, position _veh ];
					_markerName setMarkerShape "ICON";
					_markerName setMarkerType "b_maint";
					_markerName setMarkerColor "ColorWEST";
					_markerName setMarkerPos (GetPos _veh);
					_markerName setMarkerText format ["Immobilized %1", _displayName];
					markerCounter = markerCounter + 1;
					waitUntil {canMove _veh || !alive _veh};
					deleteMarker _markerName;
				};
				sleep 15;
			};
_veh addEventHandler ["Killed", {
	handle = _this spawn {
		_vehicle = _this select 0;
		_killer = _this select 1;
		_mhq = false;
		if (_vehicle == MHQ) then {_mhq = true};
		_classname = typeOf _vehicle;
		_dir = getDir _vehicle;
		_pos = getPosASL _vehicle;
		_veh = _vehicle;
		_vehPos = getPos _veh;
		_posDriverExit = _veh selectionPosition ("pos driver");
		_posCommanderExit = _veh selectionPosition ("pos codriver");
		_posCargoExit = _veh selectionPosition ("pos driver");
		_posDriver = (driver _veh) worldToModel _vehPos;
		_posCommander = (commander _veh) worldToModel _vehPos;
		_posCargo = ((crew _veh ) select 0) worldToModel _vehPos;
		_driverExitOffset = (_posDriverExit select 0) - (_posDriver select 0);
		{
			if !(alive _x) then	{
				_deadPos = _x worldToModel _vehPos;
				if ((_deadPos select 0) > 0) then	{
					_deadPos set [0, (_deadPos select 0) + (abs _driverExitOffset)];
				} else {
				_deadPos set [0, (_deadPos select 0) + (_driverExitOffset)];
				};
			_deadExitPos = _x modelToWorld _deadPos;
			_deadExitPos set [1, (getPos _x) select 1];
			_x setPos _deadExitPos;
			};
		} forEach (crew _veh);
		sleep 10;
		deleteVehicle _vehicle;
		sleep 0.5;
		_newVehicle = _classname createVehicle _pos;
		if (_mhq) then {
			handle= [_newVehicle, WEST] execVM "CHHQ.sqf";
			MHQ = _newVehicle;
		};
		_newVehicle setDir _dir;
		_newVehicle setDamage 0.8;
		_newVehicle setFuel 0;
		//_newVehicle setAmmo 0.5;
		_newVehicle setPosASL _pos;
		_null = [_newVehicle] spawn EVO_fnc_respawnRepair;
		handle = [_newVehicle] spawn {
			_newVehicle = _this select 0;
			_displayName = getText(configFile >>  "CfgVehicles" >>  (typeOf _newVehicle) >> "displayName");
			_markerName = format ["damaged_%1", markerCounter];
			_vehMarker = createMarker [_markerName, position _newVehicle ];
			_markerName setMarkerShape "ICON";
			_markerName setMarkerType "b_maint";
			_markerName setMarkerColor "ColorWEST";
			_markerName setMarkerPos (GetPos _newVehicle);
			_markerName setMarkerText format ["Damaged %1", _displayName];
			markerCounter = markerCounter + 1;
			waitUntil {canMove _newVehicle || !alive _newVehicle};
			deleteMarker _markerName;
		};
	};
}];
