/*
	Author: Thomas Ryan

	Description:
	Move a unit into the incapacitated state.

	Parameters:
		_this: OBJECT - Incapacitated unit.

	Returns:
	True if successful, false if not.
*/

private ["_unit"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _unit || !(alive _unit)) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message

// Ensure Revive is initialized
[] call EVO_fnc_reviveInit;

// Do not run if the unit is already incapacitated
if (_unit getVariable ["EVO_revive_incapacitated", false]) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message

// Move into incapacitated state
[_unit, "INCAPACITATED"] call EVO_fnc_reviveSetStatus;
[_unit, [_unit, "EVO_revive_loadout"]] call BIS_fnc_saveInventory;
[_unit, _unit] call EVO_fnc_reviveOnPlayerRespawn;

true