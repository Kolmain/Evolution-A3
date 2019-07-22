private ["_new", "_old", "_respawn", "_delay"];
_new = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_old = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_respawn = [_this, 2, -1, [-1]] call BIS_fnc_param;
_delay = [_this, 3, -1, [-1]] call BIS_fnc_param;

// Ensure revive is initialized
if (!(missionNamespace getVariable ["EVO_revive_initialized", false])) exitWith {true};

private ["_isPlayer"];
_isPlayer = call {!(isDedicated) && {_new == player}};

// Only proceed if revive isn't disabled
if ((_isPlayer && {(isNil "EVO_revive_respawnAllowed" && {getNumber (missionConfigFile >> "respawnOnStart") >= 0})}) || {_new getVariable ["EVO_revive_disableRevive", false]}) exitWith {
	EVO_revive_respawnAllowed = true;
	_new call EVO_fnc_reviveExecuteTemplates;
	true
};

// Only proceed if revive is enabled for the unit
if (_new != _old && {!(_new call EVO_fnc_reviveEnabled)}) exitWith {true};

// Reset respawn time
if (_isPlayer && {_delay >= 0}) then {setPlayerRespawnTime _delay};

// Handle if the unit is AI and it gets killed
if (!(_isPlayer)) then {
	if (isNil {_new getVariable "EVO_revive_killedEH"}) then {
		// Add eventhandler
		private ["_killedEH"];
		_killedEH = _new addMPEventHandler [
			"MPKilled",
			{
				if (isServer) then {
					private ["_unit"];
					_unit = _this select 0;

					// Remove from global array
					[_unit, "ALIVE"] call EVO_fnc_reviveSetStatus;
				};
			}
		];

		// Store eventhandler
		_new setVariable ["EVO_revive_killedEH", _killedEH, true];
	};
};

if (_new getVariable ["EVO_revive_incapacitated", false]) then {
	// Unit was incapacitated
	// Copy loadout of dead unit to new unit
	[_new, [_old, "EVO_revive_loadout"]] call BIS_fnc_loadInventory;
	{_x setVariable ["EVO_revive_loadout", nil]} forEach [_new, _old];

	// Keep collisions disabled
	{_new disableCollisionWith _x; [[_new, _x], "disableCollisionWith", _x] call BIS_fnc_MP} forEach ((switchableUnits + playableUnits) - [_new]);

	// Position new unit at corpse
	_new setPosASL (getPosASL _old);
	_new setDir (direction _old);

	// Move into animation
	[[_new, "acts_InjuredLyingRifle02"], "switchMove"] call BIS_fnc_MP;

	// Delete the corpse
	if (_new != _old) then {deleteVehicle _old};

	// Register the unit as incapacitated
	if (_new != _old) then {[_new, "INCAPACITATED"] call EVO_fnc_reviveSetStatus};

	// Add icon
	[["ADD", _new], "EVO_fnc_reviveIconControl"] call BIS_fnc_MP;

	// Prevent unit from entering a vehicle
	_new spawn {
		private ["_unit"];
		_unit = _this;

		scriptName (format ["EVO_fnc_reviveOnPlayerRespawn: vehicle control - [%1]", _unit]);

		while {_unit getVariable ["EVO_revive_incapacitated", false]} do {
			// Wait for incapacitated unit to enter a vehicle
			waitUntil {!(_unit getVariable ["EVO_revive_incapacitated", false]) || {vehicle _unit != _unit}};

			if (_unit getVariable ["EVO_revive_incapacitated", false]) then {
				// Kick the unit out of the vehicle
				[
					[
						[_unit],
						{
							private ["_unit"];
							_unit = _this select 0;
							unassignVehicle _unit;
							_unit action ["Eject", vehicle _unit];
						}
					],
					"EVO_fnc_spawn",
					_unit
				] call BIS_fnc_MP;

				// Wait for the unit to be kicked out
				waitUntil {!(_unit getVariable ["EVO_revive_incapacitated", false]) || {vehicle _unit == _unit}};

				if (_unit getVariable ["EVO_revive_incapacitated", false]) then {
					// Move back into animation
					[[_unit, "acts_InjuredLyingRifle02"], "switchMove"] call BIS_fnc_MP
				};
			};
		};
	};

	[_isPlayer, _new, _old] spawn {
		scriptName (format ["EVO_fnc_reviveOnPlayerRespawn: incapacitated - %1", _this]);

		private ["_isPlayer", "_new", "_old"];
		_isPlayer = _this select 0;
		_new = _this select 1;
		_old = _this select 2;

		if (_isPlayer && _new != _old) then {
			private ["_time"];
			_time = time + 2;
			waitUntil {time > _time || !(_new getVariable ["EVO_revive_incapacitated", false])};

			// Fade in
			titleCut ["", "BLACK IN", 1];
		};

		// Start bleeding out
		_new call EVO_fnc_reviveBleedOut;
		if (_isPlayer) then {"INCAPACITATED" call EVO_fnc_reviveProgress};

		// Wait for player to be revived
		waitUntil {!(_new getVariable ["EVO_revive_incapacitated", false])};

		if (alive _new) then {
			// Unit was revived
			// Enable collisions
			{_new enableCollisionWith _x; [[_new, _x], "enableCollisionWith", _x] call BIS_fnc_MP} forEach ((switchableUnits + playableUnits) - [_new]);

			// Add Revive UI
			if (_isPlayer) then {"REVIVE" call EVO_fnc_reviveProgress};
		};

		// Reset status
		[_new, "ALIVE"] call EVO_fnc_reviveSetStatus;
	};
} else {
	// Unit respawned
	[_new, "ALIVE"] call EVO_fnc_reviveSetStatus;
	_new call EVO_fnc_reviveExecuteTemplates;
	if (_isPlayer) then {"REVIVE" call EVO_fnc_reviveProgress};

	[["REMOVE", _old], "EVO_fnc_reviveIconControl"] call BIS_fnc_MP;
};

true