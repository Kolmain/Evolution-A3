/*
	Author: Thomas Ryan

	Description:
	Execute the defined templates for a specific unit.

	Parameters:
		_this: OBJECT - Unit

	Returns:
	True if successful, false if not.
*/

private ["_unit"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _unit) exitWith {"" call BIS_fnc_param; false};	// ToDo: Add error message

[] call EVO_fnc_reviveEnabled;

private ["_executeTemplates"];
_executeTemplates = {
	private ["_unit", "_templates"];
	_unit = _this select 0;
	_templates = _this select 1;

	// Execute supported templates
	if ({_x == "MenuPosition"} count _templates > 0) then {if (alive _unit) then {[_unit, nil, nil, nil, true] call BIS_fnc_respawnMenuPosition} else {[_unit, nil, nil, nil, true] spawn BIS_fnc_respawnMenuInventory}};
	if ({_x == "MenuInventory"} count _templates > 0) then {if (alive _unit) then {[_unit, nil, nil, nil, true] call BIS_fnc_respawnMenuPosition} else {[_unit, nil, nil, nil, true] spawn BIS_fnc_respawnMenuInventory}};

	// Reset respawn time
	setPlayerRespawnTime (missionNamespace getVariable ["EVO_selectRespawnTemplate_delay", getNumber (missionConfigFile >> "respawnDelay")]);
};

// Execute side templates only, if they are defined
private ["_templates"];
_templates = missionNamespace getVariable ("EVO_revive_templates" + (str (_unit call BIS_fnc_objectSide)));
_templates = _templates - ["Revive"];
if (count _templates > 0) exitWith {[_unit, _templates] call _executeTemplates; true};

// Otherwise, execute global templates
private ["_templates"];
_templates = EVO_revive_templates;
_templates = _templates - ["Revive"];
if (count _templates > 0) exitWith {[_unit, _templates] call _executeTemplates; true};

true