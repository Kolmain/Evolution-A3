/* ---------------------------------------------------------------------------------------------------

File: vehRespawn.sqf
Author: Iceman77

Description:
Respawn destroyed and abandoned vehicles
//[this, 0.25,10,grpNull,5,0.5,true,2,{hint "vehicle respawned";},true,["safezone1","safezone2"]
Parameter(s):
_this select 0: vehicle
_this select 1: abandoned respawn delay in minute(s) - Default 0.25 minute - OPTIONAL
_this select 2: abandoned distance in meters - Default 50 meters - OPTIONAL
_this select 3: abandoned notification - Default true - OPTIONAL
_this select 4: move distance in meters - Default 5 meters - OPTIONAL
_this select 5: destroyed respawn delay in minute(s) - Default 0.25 minute - OPTIONAL
_this select 6: whether vehicle respawns at start location else respawns where it died - Default true - OPTIONAL
_this select 7: number of respawn lives (abandoned does not use a life) - Default -1 (unlimited) - OPTIONAL
_this select 8: code to call for respawned vehicle (for custom loadouts etc) - OPTIONAL
_this select 9: init code on first run (saves having repeat code in vehicle inits - execute here instead) - Default false - OPTIONAL
_this select 10: Array of safeZones, can be any of [ "marker", trigger, [OBJ, radius], [pos, radius] ] - Default [] - OPTIONAL

How to use - Vehicle Init Line:
_nul = [this, 2, 1] execVM "vehrespawn.sqf"; // standard method
_nul = [this, 2, 1, {TAG_FNC_HunterHMGInit}, true] execVM "vehrespawn.sqf"; // "advanced" method - setting a pseudo vehicle init on the newly respawned vehicle

---------------------------------------------------------------------------------------------------- */

if (isServer) then {

private ["_veh", "_abandonDelay", "_abandonDistance", "_abandonNotification", "_moveDistance", "_deadDelay", "_startLocation",
			"_respawnCount", "_vehInit", "_safeZones", "_dir", "_pos", "_vehtype", "_vehName", "_lastDriver", "_abandonTime", "_deadTime",
			"_originalStartPosition", "_originalStartDirection", "_vehSide", "_notify", "_notifyUnits", "_notifyGroup" ];

_veh = [_this, 0, objNull, [objNull] ] call BIS_fnc_param;
_abandonDelay = ( [_this, 1, 0.25, [0] ] call BIS_fnc_param ) * 60;
_abandonDistance = [_this, 2, 50, [0] ] call BIS_fnc_param;
_abandonNotification = [_this, 3, false, [ false, objNull, grpNull, sideUnknown ] ] call BIS_fnc_param;		//(group), person, side
_moveDistance = [_this, 4, 5, [0] ] call BIS_fnc_param;
_deadDelay = ( [_this, 5, 0.25, [0] ] call BIS_fnc_param ) * 60;
_startLocation = [_this, 6, true, [true] ] call BIS_fnc_param;
_respawnCount = [_this, 7, -1, [0] ] call BIS_fnc_param;
_vehInit = [_this, 8, {}, [{}] ] call BIS_fnc_param;
if ( [_this, 9, false, [true] ] call BIS_fnc_param ) then {
	_veh call _vehInit;
};
_safeZones = [_this, 10, [], [ [] ] ] call BIS_fnc_param;  // marker, trigger, [obj, radius]

_dir = getDir _veh;
_originalStartPosition = _dir;
_pos = getPosATL _veh;
_originalStartPosition = _pos;
_vehtype = typeOf _veh;
_vehName = vehicleVarName _veh;
_vehSide = (getNumber (configFile >> "CFGVehicles" >> typeOf _veh >> "side")) call BIS_fnc_sideType;

_lastDriver = objNull;
_notify = grpNull;
_notifyGroup = "group";
_notifyUnits = [];
if ( typeName _abandonNotification != typeName false) then {
	_notify = _abandonNotification;
	_abandonNotification = true;
};

_abandonTime = nil;
_deadTime = nil;

_fnc_debug = {
	_htext = "";
	{
		_htext = _htext + format _x;
	}forEach (_this);
	hintSilent _htext;
};

_monitor = true;

	while {_monitor} do {

		sleep 1;

		//Get any position changes from safeZone actions
		if ( _startLocation && { !(isNil {_veh getVariable ["NSLVR_respawnPos",nil] }) } ) then {

			//TODO: Need to add safe check for position here, like !_startLocation check
			_pos = (_veh getVariable "NSLVR_respawnPos") select 0;
			_originalStartPosition = (_veh getVariable "NSLVR_respawnPos") select 0;

			_dir = (_veh getVariable "NSLVR_respawnPos") select 1;
			_originalStartDirection = (_veh getVariable "NSLVR_respawnPos") select 1;

			_veh setVariable ["NSLVR_respawnPos",nil];
		};

		//Allow driver to set a new respawn position when in a safe zone
		if ( _startLocation && { (count _safeZones > 0) } ) then {

			_inZone = false;
			{
				//marker, trigger, [obj, radius], [pos, radius]
				switch ( typeName _x) do {
					case (typeName "") : {
						if ( !( [ getMarkerPos _x, [0,0,0] ] call BIS_fnc_arrayCompare ) ) then {
							if ( [ _x,  getPosATL _veh ] call BIS_fnc_inTrigger ) then {
								_inZone = true;
							};
						};
					};
					case (typeName objNull) : {
						if ( typeOf _x == "EmptyDetector" ) then {
							if ( [ _x, getPosATL _veh ] call BIS_fnc_inTrigger ) then {
								_inZone = true;
							};
						};
					};
					case (typeName []) : {
						if ( ( _veh distance (_x select 0) ) < (_x select 1) ) then {
							_inZone = true;
						};
					};
				};

			}forEach _safeZones;


			if ( _inzone && { (isNil {_veh getVariable ["NSLVR_zoneAction",nil]} ) } ) then {

				_veh setVariable ["NSLVR_zoneAction", true];
				[ ["add",_veh], "NSLVR_fnc_actionMP", _vehSide, false] call BIS_fnc_MP;

			}else{

				if ( !(_inzone) && { !(isNil {_veh getVariable ["NSLVR_zoneAction",nil] } ) } ) then {

					_veh setVariable ["NSLVR_zoneAction", nil];
					[ ["remove",_veh], "NSLVR_fnc_actionMP", _vehSide, false] call BIS_fnc_MP;
				};

			};

		};

		//Keep a record of the last person to drive the vehicle so we can notifiy their group on abandonment
		if ( _abandonNotification ) then {

			//If we dont yet have a last Driver and there is currently a driver and they are not the person we already know about
			if ( (isNull _lastDriver) && { !(isNull (driver _veh)) && { ((driver _veh) != _lastDriver) }} ) then {
				_lastDriver = driver _veh;
			};
		};


		//Check if vehicle is dead or disabled
		if ( (_deadDelay >= 0) && {( (!alive _veh) || ( !canMove _veh && { ({alive _x} count crew _veh == 0) } ) )} ) then {

			//If not already flagged for respawn
			if (isNil "_deadTime") then {

				//Cancel any abandoned state, dead/disabled takes precedence
				_abandonTime = nil;

				//set time to respawn vehicle
				_deadTime = time + _deadDelay;
			};

		}else{

			//Reset flag if vehicle is no longer dead/disabled (may have had a wheel fixed)
			_deadTime = nil;
		};


		//Has the vehicle been abandoned
		if ( ( (_startlocation) && (_abandonDelay >= 0) ) && { ( (isNil "_deadTime") ) && { ((_veh distance _pos) > _moveDistance) && { ({alive _x} count (crew _veh) == 0) && { ({((_x distance _veh) < _abandonDistance)}count (units (group _lastDriver)) == 0) }}}} ) then {

			//If not already flagged for abandoned
			if (isNil "_abandonTime") then {

				//Set time to move vehicle
				_abandonTime = time + _abandonDelay;

				//Do abandoned notification
				if ( _abandonNotification && { !(isNull _lastDriver) } ) then {

					//Sort units for notification dependant on notifiy type
					//[grpNull, objNull, sideUnknown
					switch (typeName _notify) do {
						case (typeName grpNull) : {
							_notifyUnits = units (group _lastDriver);
							_notifyGroup = "group";
						};
						case (typeName objNull) : {
							if ( !(isPlayer _lastDriver) ) then {
								_notifyUnits = units (group _lastDriver);
							}else{
								_notifyUnits = [_lastDriver];
							};
							_notifyGroup = "player";
						};
						case (typeName sideUnknown) : {
							_side = _lastDriver call BIS_fnc_objectSide;
							{
								if (side _x == _side) then {
									_notifyUnits set [count _notifyUnits, _x];
								};
							}forEach (playableUnits + switchableUnits);
							_notifyGroup = "side";
						};
					};


					{

						//Send notification & marker to clients who are a friendly side to the type of vehicle
						//(e.g an opfor driving a NATO hunter will not get notification
						// neither will some one on the same side whos score is low due to TKing or Vehicle killing
						if (isPlayer _x && { ((side _x) getFriend _vehSide) > 0.6 } ) then {

							//Send notification if player is within a reasonable distance to be able to stop abandoment (100m)
							if ( (_x distance _veh) < (_abandonDistance + ( (20 * _abandonDelay) min 100 ) ) ) then {
								[ [ [_veh, _abandonDelay, _notifyGroup], NSLVR_fnc_abandonMarker ], "BIS_fnc_spawn", _x, false] call BIS_fnc_MP;
							};

						};

					//Only for people in the same notify type as the last driver (themselves, group, side)
					}forEach _notifyUnits;
				};
			};

		}else{

			//Reset flag if vehicle is no longer abandoned
			_abandonTime = nil;
		};


		//If dead or abandoned delay time is reached
		if ( ( !(isNil "_abandonTime") && { (time > _abandonTime) } ) || ( !(isNil "_deadTime") && { (time > _deadTime) } ) ) then {

			//Get current vehicle pos and direction if we are respawning where it died
			if (!(_startLocation)) then {
				_isWater = surfaceIsWater (getPosATL _veh);  //TODO: this check needs to be function so we can do it on zone pos aswell

				//If vehicle is a car in water or a ship on land then respawn at start instead
				if ( (_isWater && { (_vehtype isKindOf "SHIP") } ) || ( !(_iswater) && { ( {_vehtype isKindOf _x} count ["LANDVEHICLE", "AIR"] > 0 ) } ) ) then {
					_pos = getPosATL _veh;
					_dir = getDir _veh;
				}else{
					_pos = _originalStartPosition;
					_dir = _originalStartDirection;
				};
			};

			//If we are here due to dead/disabled
			if (!(isNil "_deadTime")) then {

				//If we have no lives left and we are not monitoring for abandonment
				//OR somehow we are not monitoring for either dead and abandoned then exit script
				if ( (_respawnCount == 0) || ((_deadDelay < 0) && (_abandonDelay < 0)) ) then {

					_monitor = false

				}else{

					//Reduce lives count
					_respawnCount = _respawnCount - 1;

					//Delete the vehicle, make a new one
					deleteVehicle _veh;
					sleep 1;
					_veh = createVehicle [_vehtype, _pos, [], 0, "NONE"];

					//If the old vehicle had a name transfer it to the new vehicle
					if (_vehName != "") then {
						missionNamespace setVariable [_vehName, _veh];
						publicVariable _vehName;
					};
				};

			}else{

				//Abandoned so give it some health back ????? (simulates picked up by salvage truck and repaired lol)
				if (damage _veh > 0.2) then {_veh setDamage 0.2};
			};

			if ( _monitor ) then {

				//Either way, set direction and pos
				_veh setDir _dir;
				_veh setPosATL _pos;

				//Only call pseudo init on respawned vehicles
				if (!(isNil "_deadTime")) then {
					_veh call _vehInit;
				};

			};

		};

		//Debug viewable as HOST only!!
		if (NSLVR_DEBUG) then {
			[
				["Last Driver : %1\n",_lastDriver],
				["Game Time : %1\n",time],
				["Abandon Time : %1\n",if (isNil "_abandonTime") then {"-"} else {_abandonTime}],
				["Dead Time : %1\n",if (isNil "_deadTime") then {"-"} else {_deadTime}],
				["lives : %1\n",_respawnCount],
				["Driver > veh : %1\n",_lastDriver distance _veh],
				["Pos > veh : %1\n",_pos distance _veh]
			] call _fnc_debug;
		};

	};

	//Debug - should only ever get here if respawn lives are depleted and there is no abandonment monitoring
	if (NSLVR_DEBUG) then { hint "NSLVR respawn script terminated" };

};

