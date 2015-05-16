/*
	Author: Thomas Ryan

	Description:
	Set the appropriate status of a unit.

	Parameters:
		_this select 0: OBJECT - Unit to set the status for
		_this select 1: STRING - Status. Can be either "KILLED", "INCAPACITATED" or "ALIVE"

	Returns:
	True if successful, false if not.
*/

private ["_unit", "_status"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_status = [_this, 1, "", [""]] call BIS_fnc_param;
_status = toUpper _status;

if (isNull _unit) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message
if (!(_status in ["KILLED", "ALIVE", "INCAPACITATED"])) then {"" call BIS_fnc_error; false};	// ToDo: Add error message

private ["_server"];
_server = call {isServer};

if (_status in ["KILLED", "INCAPACITATED"]) then {
	// Unit was killed or incapacitated
	_unit setVariable ["EVO_revive_incapacitated", true, _server];

	if (_status == "INCAPACITATED") then {
		// Unit is incapacitated
		// Ensure instant local results
		_unit disableAI "MOVE";
		_unit setCaptive true;
		EVO_revive_units = EVO_revive_units + [_unit];

		if (_server) then {
			// Synchronize across clients
			[[[_unit], {(_this select 0) disableAI "MOVE"}], "BIS_fnc_spawn", _unit] call BIS_fnc_MP;
			[[_unit, true], "setCaptive"] call BIS_fnc_MP;
			publicVariable "EVO_revive_units";
		};
	};
} else {
	// Unit is alive or respawned
	// Ensure instant local results
	_unit setVariable ["EVO_revive_incapacitated", false, _server];
	_unit setVariable ["EVO_revive_helper", objNull, _server];

	_unit enableAI "MOVE";
	_unit setCaptive false;
	EVO_revive_units = EVO_revive_units - [_unit];

	if (_server) then {
		// Synchronize across clients
		[[[_unit], {(_this select 0) enableAI "MOVE"}], "BIS_fnc_spawn", _unit] call BIS_fnc_MP;
		[[_unit, false], "setCaptive"] call BIS_fnc_MP;
		publicVariable "EVO_revive_units";
	};
};

// Ensure all sides are synchronized
if (!(_server)) then {[[_unit, _status], "EVO_fnc_reviveSetStatus", false] call BIS_fnc_MP};

true