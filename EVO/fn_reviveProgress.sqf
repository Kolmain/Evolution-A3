/*
	Author: Thomas Ryan

	Description:
	Control the progress of revive or bleeding out.

	Parameters:
		_this: STRING - Mode ("REVIVE" (default), "INCAPACITATED")

	Returns:
	True if successful, false if not.
*/

#include "\a3\ui_f_mp_mark\ui\defineresincldesign.inc"
#include "\a3\ui_f_mp_mark\ui\definecommongrids.inc"

private ["_mode"];
_mode = [_this, 0, "", [""]] call BIS_fnc_param;

// Ensure the correct mode is defined
_mode = toUpper _mode;
if (!(_mode in ["REVIVE", "INCAPACITATED"])) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message

// Ensure loading is handled
EVO_revive_UIActive = _mode;
if (isNil "EVO_revive_UILoad") then {EVO_revive_UILoad = addMissionEventHandler ["Loaded", {EVO_revive_UIActive call EVO_fnc_reviveProgress}]};

// Add UI
if (!(isNil "EVO_revive_UIControl")) then {terminate EVO_revive_UIControl};
EVO_revive_UIControl = _mode spawn {
	disableSerialization;

	private ["_mode"];
	_mode = _this;

	scriptName (format ["EVO_fnc_reviveProgress: EVO_revive_UIControl - [%1]", _mode]);

	// Create display
	private ["_layer"];
	_layer = "EVO_revive_progress" call BIS_fnc_rscLayer;
	_layer cutText ["", "PLAIN"];
	_layer cutRsc ["RscRevive", "PLAIN"];
	waitUntil {!(isNull (uiNamespace getVariable ["EVO_revive_progress_display", displayNull]))};

	// Grab display
	private ["_display"];
	_display = uiNamespace getVariable "EVO_revive_progress_display";

	// Grab controls
	private ["_ctrlBar", "_ctrlBackground", "_ctrlKeyBackground", "_ctrlKey", "_ctrlKeyProgress", "_ctrlProgress", "_ctrlText", "_ctrlDeath", "_ctrlText", "_ctrlCountdown", "_ctrlInfo", "_ctrlMedikit", "_ctrlMedikitProgress"];
	_ctrlBar = _display displayCtrl IDC_RSCREVIVE_REVIVEBAR;
	_ctrlBackground = _display displayCtrl IDC_RSCREVIVE_REVIVEPROGRESSBACKGROUND;
	_ctrlKeyBackground = _display displayCtrl IDC_RSCREVIVE_REVIVEKEYBACKGROUND;
	_ctrlKey = _display displayCtrl IDC_RSCREVIVE_REVIVEKEY;
	_ctrlKeyProgress = _display displayCtrl IDC_RSCREVIVE_REVIVEKEYPROGRESS;
	_ctrlProgress = _display displayCtrl IDC_RSCREVIVE_REVIVEPROGRESS;
	_ctrlDeath = _display displayCtrl IDC_RSCREVIVE_REVIVEDEATH;
	_ctrlText = _display displayCtrl IDC_RSCREVIVE_REVIVETEXT;
	_ctrlCountdown = _display displayCtrl IDC_RSCREVIVE_REVIVECOUNTDOWN;
	_ctrlInfo = _display displayCtrl IDC_RSCREVIVE_REVIVEINFO;
	_ctrlMedikit = _display displayCtrl IDC_RSCREVIVE_REVIVEMEDIKIT;
	_ctrlMedikitProgress = _display displayCtrl IDC_RSCREVIVE_REVIVEMEDIKITPROGRESS;

	// Grab UI highlight color
	private ["_color", "_colorHTML"];
	_color = ["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet;
	_color set [3,1];
	_colorHTML = _color call BIS_fnc_colorRGBAtoHTML;

	// Hide elements
	{
		_x ctrlSetFade 1;
		_x ctrlCommit 0;
	} forEach [_ctrlBackground, _ctrlKey, _ctrlProgress, _ctrlText, _ctrlDeath, _ctrlText, _ctrlCountdown, _ctrlInfo, _ctrlMedikit];

	// Set up background
	_ctrlBackground ctrlSetBackgroundColor [0,0,0,0.5];
	_ctrlBackground ctrlCommit 0;

	if (_mode == "REVIVE") then {
		// Revive
		// Set up background
		private ["_posBackgroundMax", "_posBackgroundMin"];
		_posBackgroundMax = ctrlPosition _ctrlBackground;
		_posBackgroundMin = ctrlPosition _ctrlKeyBackground;
		_ctrlBackground ctrlSetPosition _posBackgroundMin;
		_ctrlBackground ctrlCommit 0;

		// Set up key text
		private ["_string", "_parsed"];
		_string = format ["<t align = 'center' color = '%1'>%2</t>", _colorHTML, "SPACE"];
		_parsed = parseText _string;
		_ctrlKey ctrlSetStructuredText _parsed;
		_ctrlKey ctrlCommit 0;

		// Set up progress bar
		private ["_posProgressMax", "_posProgressMin"];
		_posProgressMax = ctrlPosition _ctrlProgress;
		_posProgressMin = ctrlPosition _ctrlKeyProgress;
		_ctrlProgress ctrlSetPosition  _posProgressMin;
		_ctrlProgress ctrlSetTextColor _color;
		_ctrlProgress ctrlCommit 0;

		// Set up medikit icon
		private ["_posMedikitMax", "_posMedikitMin"];
		_posMedikitMax = ctrlPosition _ctrlMedikit;
		_posMedikitMin = ctrlPosition _ctrlMedikitProgress;
		_ctrlMedikit ctrlSetPosition _posMedikitMin;
		_ctrlMedikit ctrlCommit 0;

		private ["_rePositioned"];
		_rePositioned = false;

		while {true} do {
			// Wait for player to approach target
			waitUntil {EVO_revive_selected getVariable ["EVO_revive_incapacitated", false] && {player distance EVO_revive_selected <= 3.5}};

			if (!(_rePositioned)) then {
				// Reposition elements
				_ctrlProgress ctrlSetPosition _posProgressMin;
				_ctrlBackground ctrlSetPosition _posBackgroundMin;
				_ctrlMedikit ctrlSetPosition _posMedikitMin;
				{_x ctrlSetFade 1} forEach [_ctrlText, _ctrlMedikit];
				{_x ctrlCommit 0} forEach [_ctrlProgress, _ctrlBackground, _ctrlText, _ctrlMedikit];
			};

			_rePositioned = false;

			// Show key press
			{
				_x ctrlSetFade 0;
				_x ctrlCommit 0.2;
			} forEach [_ctrlKey, _ctrlBackground];

			// Wait for player to start reviving the unit
			waitUntil {player distance EVO_revive_selected > 3.5 || !(isNull EVO_revive_target)};

			if (!(isNull EVO_revive_target)) then {
				private ["_target"];
				_target = EVO_revive_target;

				// Update revive text
				private ["_string", "_parsed"];
				_string = format [toUpper (localize "STR_A3_Revive_Info_Target"), "<t align = 'center'>", "", name _target, "</t></t>"];
				_parsed = parseText _string;
				_ctrlText ctrlSetStructuredText _parsed;
				_ctrlText ctrlCommit 0;

				// Show progress bar
				_ctrlBackground ctrlSetPosition _posBackgroundMax;
				_ctrlProgress ctrlSetPosition _posProgressMax;

				// Reposition medikit icon
				_ctrlMedikit ctrlSetPosition _posMedikitMax;

				// Show medikit icon if necessary
				if ("Medikit" in items player) then {
					_ctrlMedikit ctrlSetFade 0;
					_ctrlMedikit ctrlCommit 0.2;
				} else {
					_ctrlMedikit ctrlSetFade 1;
					_ctrlMedikit ctrlCommit 0;
				};

				_ctrlKey ctrlSetFade 1;
				{_x ctrlSetFade 0} forEach [_ctrlProgress, _ctrlText];
				{_x ctrlCommit 0.2} forEach [_ctrlKey, _ctrlBackground, _ctrlProgress, _ctrlText];

				// Define the revive time
				private ["_cfg", "_time"];
				_cfg = missionConfigFile >> "reviveDelay";
				_time = if (isClass _cfg) then {getNumber _cfg} else {EVO_revive_reviveDelayDefault};

				private ["_timeBefore", "_total", "_revive"];
				_timeBefore = time;
				_total = _time;
				_revive = 0;

				private ["_simulation"];
				waitUntil {
					sleep 0.01;

					// Determine whether player has a medikit
					private ["_medikit"];
					_medikit = call {"Medikit" in items player};

					// Show or hide the indicator
					if (_medikit) then {_ctrlMedikit ctrlSetFade 0} else {_ctrlMedikit ctrlSetFade 1};
					_ctrlMedikit ctrlCommit 0.2;

					// Progress revival
					private ["_timeDiff"];
					_timeDiff = time - _timeBefore;
					if (_medikit) then {_timeDiff = _timeDiff * EVO_revive_medikitMultiplier};
					_time = _time - _timeDiff;
					_timeBefore = time;
					_revive = 1 - (_time / _total);
					_ctrlProgress progressSetPosition _revive;

					_revive >= 1 || isNull EVO_revive_target || !(alive EVO_revive_target)
				};

				if (_revive >= 1) then {
					// Revive target
					_target setVariable ["EVO_revive_incapacitated", false, true];
				};
			};

			// Reset controls
			{_x ctrlSetFade 1} forEach [_ctrlText, _ctrlProgress];
			_ctrlText ctrlCommit 0.2;

			if (EVO_revive_selected getVariable ["EVO_revive_incapacitated", false] && {player distance EVO_revive_selected <= 3.5}) then {
				// Register that they were repositioned
				_rePositioned = true;

				// Player has another unit selected
				_ctrlProgress ctrlSetPosition _posProgressMin;
				_ctrlBackground ctrlSetPosition _posBackgroundMin;
				_ctrlMedikit ctrlSetPosition _posMedikitMin;
			} else {
				// Player has no other unit selected
				{_x ctrlSetFade 1} forEach [_ctrlKey, _ctrlProgress, _ctrlBackground];
				{_x ctrlCommit 0.2} forEach [_ctrlKey, _ctrlBackground];
			};

			if (ctrlFade _ctrlMedikit < 1) then {
				_ctrlMedikit ctrlSetFade 1;
				if ("Medikit" in items player) then {_ctrlMedikit ctrlCommit 0.2} else {_ctrlMedikit ctrlCommit 0};
			};

			_ctrlProgress ctrlCommit 0.2;
		};
	} else {
		// Set up background
		_ctrlBar ctrlSetBackgroundColor [0, 0, 0, 0.25];
		_ctrlBar ctrlCommit 0;

		// Set up progress bar
		_ctrlProgress ctrlSetTextColor [0.75, 0, 0, 1];
		_ctrlProgress ctrlCommit 0;

		// Compose & parse strings
		private ["_stringIncapacitated", "_stringHold", "_stringRespawn", "_stringRevive", "_parsedIncapacitated", "_parsedHold", "_parsedRespawn", "_parsedRevive"];
		_stringIncapacitated = format ["<t align = 'center'>%1</t>", toUpper (localize "STR_A3_Revive_Status_Incapacitated")];
		_stringHold = format [toUpper (localize "STR_A3_Revive_Info_Respawn"), "<t align = 'center' size = '0.75'>", format ["<t color = '%1'>", _colorHTML], "SPACE", "</t>", "</t>"];
		_stringRespawn = format ["<t align = 'center' size = '0.75'>%1</t>", toUpper (localize "STR_A3_Revive_Status_Respawning")];
		_stringRevive = format ["<t align = 'center'>%1</t>", toUpper (localize "STR_A3_Revive_Status_Reviving")];
		_parsedIncapacitated = parseText _stringIncapacitated;
		_parsedHold = parseText _stringHold;
		_parsedRespawn = parseText _stringRespawn;
		_parsedRevive = parseText _stringRevive;

		// Set up status
		_ctrlText ctrlSetStructuredText _parsedIncapacitated;
		_ctrlText ctrlCommit 0;

		// Set up info
		_ctrlInfo ctrlSetStructuredText _parsedHold;
		_ctrlInfo ctrlCommit 0;

		// Fade in elements
		{
			_x ctrlSetFade 0;
			_x ctrlCommit 1;
		} forEach [_ctrlBar, _ctrlBackground, _ctrlProgress, _ctrlDeath, _ctrlText, _ctrlInfo, _ctrlCountdown];

		// Define the respawn time
		private ["_cfg", "_respawnTime"];
		_cfg = missionConfigFile >> "reviveForceRespawnDelay";
		_respawnTime = if (isClass _cfg) then {getNumber _cfg} else {EVO_revive_reviveForceRespawnDelayDefault};

		private ["_timeBefore", "_original"];
		_timeBefore = time;
		_original = _respawnTime;

		waitUntil {
			sleep 0.01;

			if (!(alive player) || !(player getVariable ["EVO_revive_incapacitated", false])) then {
				true
			} else {
				// Get player's blood level
				private ["_blood"];
				_blood = player getVariable ["EVO_revive_blood", 1];
				_ctrlProgress progressSetPosition _blood;

				if (!(player getVariable ["EVO_revive_forceRespawn", false])) then {
					// Player is not forcing respawn
					_ctrlInfo ctrlSetStructuredText _parsedHold;
					_ctrlCountdown ctrlSetStructuredText parseText "";

					_respawnTime = _original;
				} else {
					// Player is forcing respawn
					_respawnTime = _respawnTime - (time - _timeBefore);
					if (_respawnTime <= 0) then {forceRespawn player};

					_ctrlInfo ctrlSetStructuredText _parsedRespawn;

					private ["_string", "_parsed"];
					_string = format ["<t align = 'center'>%1</t>", (ceil _respawnTime) max 0];
					_parsed = parseText _string;
					_ctrlCountdown ctrlSetStructuredText _parsed;
				};

				{_x ctrlCommit 0} forEach [_ctrlInfo, _ctrlCountdown];

				_timeBefore = time;

				private ["_helper"];
				_helper = player getVariable ["EVO_revive_helper", objNull];

				if (isNull _helper) then {
					// Player is bleeding out
					_ctrlText ctrlSetStructuredText _parsedIncapacitated;
					_ctrlText ctrlCommit 0;

					_ctrlProgress ctrlSetTextColor [0.75,0,0,1];
				} else {
					// Player is being revived
					private ["_string", "_parsed"];
					_string = format [toUpper (localize "STR_A3_Revive_Info_Helper"), "<t align = 'center'>", name _helper, "", "</t>"];
					_parsed = parseText _string;
					_ctrlText ctrlSetStructuredText _parsed;
					_ctrlText ctrlCommit 0;

					_ctrlProgress ctrlSetTextColor [0.4,0.4,0.4,1];
				};

				!(alive player) || !(player getVariable "EVO_revive_incapacitated")
			};
		};

		// Fade out elements
		{
			_x ctrlSetFade 1;
			_x ctrlCommit 1;
		} forEach [_ctrlBar, _ctrlBackground, _ctrlProgress, _ctrlDeath, _ctrlText, _ctrlInfo, _ctrlCountdown];
	};
};

true