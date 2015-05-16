// Prevent from running in single player
if (!(isMultiplayer)) exitWith {};

private ["_unit", "_killer", "_respawn", "_delay"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_killer = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_respawn = [_this, 2, -1, [-1]] call BIS_fnc_param;
_delay = [_this, 3, -1, [-1]] call BIS_fnc_param;

if (isNil {_unit getVariable "EVO_revive_loadout"}) then {
	// Save loadout
	private ["_loadout"];
	_loadout = [_unit, [_unit, "EVO_revive_loadout"]] call BIS_fnc_saveInventory;
	_unit setVariable ["EVO_revive_loadout", _loadout];
};

// Ensure revive is initialized
if (!(missionNamespace getVariable ["EVO_revive_initialized", false])) exitWith {[] call EVO_fnc_reviveInit};

// Reset variables
EVO_revive_keyPressed = false;
_unit setVariable ["EVO_revive_forceRespawn", false, true];
_unit setVariable ["EVO_revive_dying", false, true];

// Only proceed if revive isn't disabled
if ((isNil "EVO_revive_respawnAllowed" && {getNumber (missionConfigFile >> "respawnOnStart") >= 0}) || {_unit getVariable ["EVO_revive_disableRevive", false]} || {vehicle _unit != _unit}) exitWith {
	_unit call EVO_fnc_reviveExecuteTemplates;
	true
};

if (_unit call EVO_fnc_reviveEnabled) then {
	if (_unit getVariable ["EVO_revive_incapacitated", false]) then {
		// Player was killed while incapacitated
		[_unit, "ALIVE"] call EVO_fnc_reviveSetStatus;

		// Execute respawn templates
		_unit call EVO_fnc_reviveExecuteTemplates;
	} else {
		// Exit if player respawned using pause menu
		private ["_time"];
		_time = missionNamespace getVariable ["RscDisplayMPInterrupt_respawnTime", -1];
		if (time - _time < 1) exitWith {_unit call EVO_fnc_reviveExecuteTemplates};

		// Player was incapacitated
		// Prevent respawn
		setPlayerRespawnTime 10e10;

		// Register the unit as killed
		[_unit, "KILLED"] call EVO_fnc_reviveSetStatus;

		// Disable collisions upon death
		{_unit disableCollisionWith _x; [[_unit, _x], "disableCollisionWith", _x] call BIS_fnc_MP} forEach ((switchableUnits + playableUnits) - [_unit]);

		[] spawn {
			scriptName "EVO_fnc_reviveOnPlayerKilled: fade out";

			sleep 1;

			titleCut ["", "BLACK OUT", 1];

			sleep 1;

			// Respawn player
			setPlayerRespawnTime 0;
		};
	};
};

true