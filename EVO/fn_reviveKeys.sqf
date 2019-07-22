/*
	Author: Thomas Ryan

	Description:
	Add the key eventhandlers to detect Revive-specific events.

	Parameters:
		_this select 0: STRING - Key mode
		_this select 1 (Optional): BOOL - Whether the funtion is being executed after loading or not (default: false)

	Returns:
	True if successful, false if not.
*/

private ["_mode", "_loaded"];
_mode = [_this, 0, "", [""]] call BIS_fnc_param;
_loaded = [_this, 1, false, [false]] call BIS_fnc_param;

// Ensure only valid modes are defined
_mode = toUpper _mode;
if (!(_mode in ["DISABLED", "REVIVE_START", "REVIVE_END", "RESPAWN_START", "RESPAWN_END"])) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message

// Ensure the correct mode is loaded
EVO_revive_keyActive = _mode;
if (isNil "EVO_revive_keyLoad") then {EVO_revive_keyLoad = addMissionEventHandler ["Loaded", {[EVO_revive_keyActive, true] call EVO_fnc_reviveKeys}]};

// Track whether key is pressed
if (isNil "EVO_revive_keyPressed") then {EVO_revive_keyPressed = false};

// Add key detection
if (!(isNil "EVO_revive_keyControl")) then {terminate EVO_revive_keyControl};
EVO_revive_keyControl = [_mode, _loaded] spawn {
	disableSerialization;

	private ["_mode", "_loaded"];
	_mode = _this select 0;
	_loaded = _this select 1;

	scriptName (format ["EVO_revive_keyControl - [%1, %2]", _mode, _loaded]);

	waitUntil {!(isNull ([] call BIS_fnc_displayMission))};

	// Grab mission display
	private ["_display"];
	_display = [] call BIS_fnc_displayMission;

	// Prevent eventhandlers from duplicating
	{
		private ["_index"];
		_index = uiNamespace getVariable [_x, -42];

		if (_index != -42) then {
			_display displayRemoveEventHandler [if (_forEachIndex == 0) then {"KeyDown"} else {"KeyUp"}, _index];
			uiNamespace setVariable [_x, nil];
		};
	} forEach ["EVO_revive_keyDownEH", "EVO_revive_keyUpEH"];

	// Reset variables upon load
	if (_loaded) then {
		EVO_revive_target = objNull;
		EVO_revive_keyPressed = false;

		player setVariable ["EVO_revive_forceRespawn", false, true];
	};

	// Detect if Space is pressed
	private ["_keyDownEH"];
	_keyDownEH = _display displayAddEventHandler [
		"KeyDown",
		{
			private ["_key"];
			_key = _this select 1;

			if (_key == 57) then {
				if (EVO_revive_keyActive == "DISABLED") then {
					// Make sure key is released first
					EVO_revive_keyPressed = true;
				} else {
					if (!(EVO_revive_keyPressed)) then {
						// Make sure the key HAS to be released
						EVO_revive_keyPressed = true;

						switch (EVO_revive_keyActive) do {
							case "REVIVE_START": {
								// Select highlighted unit
								EVO_revive_target = EVO_revive_selected;
							};

							case "RESPAWN_START": {
								// Player is forcing respawn
								player setVariable ["EVO_revive_forceRespawn", true, true];
							};
						};

						true
					};
				};
			} else {
				if (!(isDedicated) && {player getVariable ["EVO_revive_incapacitated", false]}) then {
					// Disable grenade throwing while incapacitated
					private ["_keys"];
					_keys = actionKeys "Throw";
					if (_key in _keys) then {true};
				};
			};
		}
	];

	// Detect if Space is released
	private ["_keyUpEH"];
	_keyUpEH = _display displayAddEventHandler [
		"KeyUp",
		{
			private ["_key"];
			_key = _this select 1;

			if (_key == 57) then {
				// Register that the key was released
				EVO_revive_keyPressed = false;

				if (EVO_revive_keyActive != "DISABLED") then {
					switch (EVO_revive_keyActive) do {
						case "REVIVE_END": {
							// Player interrupted their revive
							EVO_revive_target = objNull;
						};

						case "RESPAWN_END": {
							// Player cancelled their forced respawn
							player setVariable ["EVO_revive_forceRespawn", false, true];
						};
					};

					true
				};
			};
		}
	];

	// Store eventhandler indexes
	uiNamespace setVariable ["EVO_revive_keyDownEH", _keyDownEH];
	uiNamespace setVariable ["EVO_revive_keyUpEH", _keyUpEH];
};

true