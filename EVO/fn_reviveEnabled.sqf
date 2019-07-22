/*
	Author: Thomas Ryan

	Description:
	Return whether Revive is enabled for a specific unit.

	Parameters:
		_this (Optional):
			OBJECT - Enabled for a specific unit (pass objNull to check if enabled for anyone (default))
			SIDE - Enabled for a specific side

	Returns:
	True if enabled, false if not.
*/

private ["_unit"];
_unit = [_this, 0, objNull, [objNull, WEST]] call BIS_fnc_param;

if (isNil "EVO_revive_enabled") then {
	// Determine how revive is enabled
	EVO_revive_enabled = false;
	EVO_revive_sides = [WEST, EAST, RESISTANCE, CIVILIAN];

	{
		private ["_var", "_templates"];
		_var = "EVO_revive_templates" + _x;
		_templates = getArray (missionConfigFile >> ("respawnTemplates" + _x));

		// Store array of defined side templates
		missionNamespace setVariable [_var, getArray (missionConfigFile >> ("respawnTemplates" + _x))];

		private ["_side"];
		_side = switch (_x) do {
			case "West": {WEST};
			case "East": {EAST};
			case "Guer": {RESISTANCE};
			case "Civ": {CIVILIAN};
		};

		// Check if revive is enabled for the side
		private ["_enabled"];
		_enabled = false;
		{if (_x == "Revive") exitWith {_enabled = true}} forEach _templates;
		if (!(_enabled)) then {EVO_revive_sides = EVO_revive_sides - [_side]};
	} forEach ["West", "East", "Guer", "Civ"];

	// Store array of global templates
	EVO_revive_templates = getArray (missionConfigFile >> "respawnTemplates");

	// Determine if revive is enabled at all
	{if (_x == "Revive") exitWith {EVO_revive_enabled = true}} forEach (EVO_revive_templates + EVO_revive_templatesWest + EVO_revive_templatesEast + EVO_revive_templatesGuer + EVO_revive_templatesCiv);
};

if (typeName _unit == typeName objNull && {isNull _unit}) then {
	// Return if it's enabled
	EVO_revive_enabled
} else {
	if (typeName _unit != typeName objNull) then {
		// Check if it's enabled for a specific side
		_unit in EVO_revive_sides
	} else {
		// Check if revive is enabled for a specific unit
		private ["_global"];
		_global = false;
		{if (_x == "Revive") exitWith {_global = true}} forEach EVO_revive_templates;
		if ((_unit call BIS_fnc_objectSide) in EVO_revive_sides) then {true} else {_global};
	};
};