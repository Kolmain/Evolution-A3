/*
	Author: Thomas Ryan

	Description:
	Manage the adding, removing, and effects applied to 3D icons used for visualizing incapacitated units.

	Parameters:
		_this select 0: STRING - Mode to be executed.
		_this select 1 (Optional): OBJECT - Unit to execute effects on.

	Returns:
	True if successful, false if not.
*/

private ["_mode", "_unit"];
_mode = [_this, 0, "", [""]] call BIS_fnc_param;
_unit = [_this, 1, objNull, [objNull]] call BIS_fnc_param;

private ["_modes"];
_modes = ["INIT", "ADD", "REMOVE", "DOWN", "REVIVE", "DYING", "DEAD"];
if (!((toUpper _mode) in _modes)) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message

// Synchronize icons
if (isNil "EVO_revive_iconsGlobal") then {
	if (isServer) then {
		// Create array on server
		EVO_revive_iconsGlobal = [];
		publicVariable "EVO_revive_iconsGlobal";
	} else {
		// Wait for array to transfer to client
		waitUntil {!(isNil "EVO_revive_iconsGlobal")};
	};
};

if (!(isDedicated)) then {
	// Client takes over control
	if (isNil "EVO_revive_icons") then {EVO_revive_icons = EVO_revive_iconsGlobal};

	// Local global variables
	EVO_revive_fakeIcon = [1,1,1,0] call BIS_fnc_colorRGBAtoTexture;

	EVO_revive_iconRange = 150;
	EVO_revive_iconThresh = 25;
	EVO_revive_iconLimit = EVO_revive_iconRange + EVO_revive_iconThresh;

	EVO_revive_iconText = toUpper (localize "STR_A3_Revive_Icon_text");

	// Main draw eventhandler
	if (isNil "EVO_revive_iconEH") then {
		EVO_revive_iconEH = addMissionEventHandler [
			"Draw3D",
			{
				// Do not show icons if disabled
				if (!(alive player) || {!(difficultyEnabled "HUDGroupInfo")}) exitWith {};

				// Store player's group
				private ["_group"];
				_group = group player;

				if (!(player getVariable ["EVO_revive_incapacitated", false])) then {
					// Show incapacitated units
					{
						private ["_unit"];
						_unit = _x;

						// Only proceed if the icons are enabled
						if (_unit getVariable ["EVO_revive_iconVisible", false]) then {
							private ["_sidePlayer", "_sideUnit"];
							_sidePlayer = player call BIS_fnc_objectSide;
							_sideUnit = _unit call BIS_fnc_objectSide;

							// Only show friendly units
							if (_sidePlayer getFriend _sideUnit > 0 && {_sideUnit getFriend _sidePlayer > 0}) then {
								private ["_isGroup"];
								_isGroup = call {group _unit == _group};

								// Determine the icon's position
								private ["_pos"];
								_pos = if (vehicle _unit != _unit) then {
									// Unit is in a vehicle
									getPosATL _unit
								} else {
									// Unit is on foot
									private ["_selectionPos"];
									_selectionPos = _unit selectionPosition "Spine3";
									_unit modelToWorldVisual _selectionPos
								};

								// Store position
								_unit setVariable ["EVO_revive_iconPos", _pos];

								// Determine the alphas
								private ["_incapAlpha", "_deathAlpha"];
								_incapAlpha = _unit getVariable ["EVO_revive_incapAlpha", 0];
								_deathAlpha = _unit getVariable ["EVO_revive_deathAlpha", 0];

								// Calculate the alpha modifier
								private ["_modifyAlpha"];
								_modifyAlpha = if (_isGroup) then {
									// Unit is a member of the player's group
									0.75
								} else {
									if (_unit getVariable ["EVO_revive_inRange", false]) then {
										// Unit is in range of being selected
										_unit getVariable ["EVO_revive_selectAlpha", 0.45]
									} else {
										// Unit isn't in the player's group
										private ["_distAlpha"];
										_distAlpha = _unit getVariable ["EVO_revive_distAlpha", 0];
										_distAlpha * 0.45
									};
								};

								// Adjust alphas
								_incapAlpha = _incapAlpha * _modifyAlpha;
								_deathAlpha = _deathAlpha * _modifyAlpha;




								// INCAPACITATED ICON
								// Grab the color
								private ["_color"];
								_color = _unit getVariable ["EVO_revive_incapColor", [0,0,0]];

								// Compose the incapacitated color
								private ["_colorIncap"];
								_colorIncap = _color + [_incapAlpha];

								// Grab the size
								private ["_sizeIncap"];
								_sizeIncap = _unit getVariable ["EVO_revive_incapSize", 0];

								// Draw the incapacitated icon
								drawIcon3D [
									"a3\ui_f_mp_mark\data\revive\revive_ca.paa",
									_colorIncap,
									_pos,
									_sizeIncap,
									_sizeIncap,
									0,
									"",
									1
								];




								// MEDIKIT INDICATOR
								if ("Medikit" in items player) then {
									drawIcon3D [
										"a3\ui_f_mp_mark\data\revive\revive_medikit_ca.paa",
										([1,1,1] + [_incapAlpha]),
										_pos,
										_sizeIncap,
										_sizeIncap,
										0,
										"",
										0
									];
								};




								// REVIVE TEXT
								// Determine the alpha
								private ["_alphaText"];
								_alphaText = _unit getVariable ["EVO_revive_textAlpha", 0];

								// Draw the text
								drawIcon3D [
									EVO_revive_fakeIcon,
									([1,1,1] + [_alphaText]),
									_pos,
									1,
									1,
									0,
									EVO_revive_iconText,
									2
								];




								// INCAPACITATED ARROW
								if (_isGroup) then {
									drawIcon3D [
										EVO_revive_fakeIcon,
										_colorIncap,
										_pos,
										_sizeIncap,
										_sizeIncap,
										0,
										"",
										2,
										0.03, "PuristaMedium", "center",	// Redundant font params, required to make the arrow work
										true
									];
								};




								// DEATH ICON
								// Grab the color, add alpha
								private ["_colorDeath"];
								_colorDeath = _unit getVariable ["EVO_revive_deathColor", [0,0,0]];
								_colorDeath set [3, _deathAlpha];

								// Grab the size
								private ["_sizeDeath"];
								_sizeDeath = _unit getVariable ["EVO_revive_deathSize", 0];

								// Draw the icon
								drawIcon3D [
									"a3\ui_f_curator\data\cfgmarkers\kia_ca.paa",
									_colorDeath,
									_pos,
									_sizeDeath,
									_sizeDeath,
									0,
									"",
									1
								];
							};
						};
					} forEach EVO_revive_icons;
				} else {
					// Show squad member names
					private ["_units"];
					_units = units _group - [player];
					{if (!(alive _x) || {_x getVariable ["EVO_revive_incapacitated", false]}) then {_units = _units - [_x]}} forEach _units;

					{
						if (!(isPlayer _x)) exitWith {};

						private ["_vehicle", "_dist"];
						_vehicle = vehicle _x;
						_dist = round (player distance _vehicle);

						// Only draw vehicle icons on one unit
						private ["_first"];
						_first = objNull;
						{if (vehicle _x == _vehicle) exitWith {_first = _x}} forEach _units;
						if (_first != _x) exitWith {};

						// Compose string
						private ["_string"];
						_string = name _x;
						{if (vehicle _x == _vehicle) then {_string = _string + (", " + name _x)}} forEach (_units - [_x]);

						// Find icon position
						private ["_pos"];
						_pos = getPosVisual _vehicle;

						if (_vehicle == _x) then {
							private ["_selectionPos"];
							_selectionPos = _x selectionPosition "Spine3";
							_pos = _x modelToWorldVisual _selectionPos;
						};

						// Draw the unit's name and distance
						drawIcon3D [
							EVO_revive_fakeIcon,
							[1,1,1,1],
							_pos,
							1,
							1,
							0,
							_string,
							2
						];
					} forEach _units;
				};
			}
		];
	};

	EVO_revive_transformIcon = {
		private ["_transformation"];
		_transformation = _this;

		scriptName (format ["EVO_fnc_reviveIconControl: EVO_revive_transformIcon - %1", _transformation]);

		// Find details
		private ["_unit", "_delay"];
		_unit = _transformation select 0;
		_delay = _transformation select 1;
		{_transformation set [_x, -1]} forEach [0,1];
		_transformation = _transformation - [-1];

		private ["_transformations"];
		_transformations = [];

		{
			private ["_details", "_var", "_start", "_end", "_merge"];
			_details = _x;
			_var = _details select 0;
			_start = _details select 1;
			_end = _details select 2;
			_merge = if (count _details > 3) then {_details select 3} else {false};

			// Determine the effect's current layer
			private ["_layerVar", "_layer"];
			_layerVar = (_var + "_currentLayer");
			_layer = (_unit getVariable [_layerVar, -1]) + 1;
			_unit setVariable [_layerVar, _layer];

			// Smoothly transition from current state
			if (_merge) then {_start = _unit getVariable [_var, _start]};

			// Calculate transformation differences
			private ["_diff"];
			_diff = if (typeName _start != typeName []) then {
				// NOT COLOR
				_end - _start
			} else {
				// COLOR
				private ["_rStart", "_gStart", "_bStart"];
				_rStart = _start select 0;
				_gStart = _start select 1;
				_bStart = _start select 2;

				private ["_rEnd", "_gEnd", "_bEnd"];
				_rEnd = _end select 0;
				_gEnd = _end select 1;
				_bEnd = _end select 2;

				// Calculate differences
				private ["_rDiff", "_gDiff", "_bDiff"];
				_rDiff = _rEnd - _rStart;
				_gDiff = _gEnd - _gStart;
				_bDiff = _bEnd - _bStart;

				[_rDiff, _gDiff, _bDiff]
			};

			// Add differences
			_transformations = _transformations + [[_var, _start, _end, _diff, _layerVar, _layer, _merge]];
		} forEach _transformation;

		if (_delay == 0) exitWith {
			// Instantly set end state
			{_unit setVariable [_x select 0, _x select 2]} forEach _transformations;
			true
		};

		// Apply start state
		{if (!(_x select 6)) then {_unit setVariable [_x select 0, _x select 1]}} forEach _transformations;

		// Apply transformation
		private ["_timeEnd"];
		_timeEnd = time + _delay;

		while {time <= _timeEnd} do {
			// Calculate how far along the transformation it is
			private ["_timeRemaining", "_percent"];
			_timeRemaining = _timeEnd - time;
			_percent = 1 - (_timeRemaining / _delay);

			{
				private ["_var", "_start", "_end", "_diff", "_layerVar", "_layer"];
				_var = _x select 0;
				_start = _x select 1;
				_end = _x select 2;
				_diff = _x select 3;
				_layerVar = _x select 4;
				_layer = _x select 5;

				if (_unit getVariable _layerVar != _layer) then {
					// Disable effect
					_transformations set [_forEachIndex, -1];
					_transformations = _transformations - [-1];
				} else {
					// Play effect
					private ["_now"];
					_now = -1;

					if (typeName _diff != typeName []) then {
						// NOT COLOR
						// Calculate change
						_now = _start + (_diff * _percent);
					} else {
						// COLOR
						private ["_rStart", "_gStart", "_bStart"];
						_rStart = _start select 0;
						_gStart = _start select 1;
						_bStart = _start select 2;

						private ["_rDiff", "_gDiff", "_bDiff"];
						_rDiff = _diff select 0;
						_gDiff = _diff select 1;
						_bDiff = _diff select 2;

						// Calculate changes
						private ["_r", "_g", "_b"];
						_r = _rStart + (_rDiff * _percent);
						_g = _gStart + (_gDiff * _percent);
						_b = _bStart + (_bDiff * _percent);

						// Apply change
						_now = [_r, _g, _b];
					};

					// Apply transformation
					_unit setVariable [_var, _now];
				};
			} forEach _transformations;

			if (time < _timeEnd) then {sleep 0.01};
		};

		// Apply final state
		if (count _transformations > 0) then {{_unit setVariable [_x select 0, _x select 2]} forEach _transformations};

		true
	};

	EVO_revive_controlIconVisibility = {
		private ["_unit"];
		_unit = _this;

		scriptName (format ["EVO_fnc_reviveIconControl: EVO_revive_controlIconVisibility - [%1]", _unit]);

		// Wait for the unit to meet condition
		waitUntil {sleep 0.05; (group _unit == group player || {vehicle _unit distance vehicle player <= EVO_revive_iconLimit}) || !(_unit in EVO_revive_icons)};

		if (_unit in EVO_revive_icons) then {
			// Show icon
			_unit setVariable ["EVO_revive_iconVisible", true];
			waitUntil {sleep 0.05; !(_unit in EVO_revive_icons)};
		};

		// Disable icon
		_unit setVariable ["EVO_revive_iconVisible", false];
		_unit setVariable ["EVO_revive_iconEnabled", false];

		true
	};

	EVO_revive_iconDistControl = {
		private ["_unit"];
		_unit = _this;

		scriptName (format ["EVO_fnc_reviveIconControl: EVO_revive_iconDistControl - [%1]", _unit]);

		// Wait for the icon to be allowed
		waitUntil {_unit getVariable ["EVO_revive_iconVisible", false] || !(_unit getVariable ["EVO_revive_iconEnabled", true])};

		while {_unit getVariable "EVO_revive_iconEnabled"} do {
			private ["_dist"];
			_dist = vehicle _unit distance vehicle player;

			if (_dist > EVO_revive_iconLimit) then {
				// Wait for the unit to come back into range
				_unit setVariable ["EVO_revive_outRange", true];
				_unit setVariable ["EVO_revive_inRange", false];
				_unit setVariable ["EVO_revive_distAlpha", 0];
				waitUntil {sleep 0.05; vehicle _unit distance vehicle player <= EVO_revive_iconLimit || {!(_unit getVariable "EVO_revive_iconEnabled")}};
			} else {
				// Unit is in range
				_unit setVariable ["EVO_revive_outRange", false];

				if (_dist <= EVO_revive_iconRange) then {
					// Wait for the unit to start going out of range
					_unit setVariable ["EVO_revive_inRange", true];
					_unit setVariable ["EVO_revive_distAlpha", 1];
					waitUntil {sleep 0.05; vehicle _unit distance vehicle player > EVO_revive_iconRange || {!(_unit getVariable "EVO_revive_iconEnabled")}};
				} else {
					// Unit is going out of range
					_unit setVariable ["EVO_revive_inRange", false];

					// Alpha is how far the distance is along the threshold
					private ["_diff", "_alpha"];
					_diff = EVO_revive_iconLimit - _dist;
					_alpha = _diff / EVO_revive_iconThresh;

					// Set the alpha
					_unit setVariable ["EVO_revive_distAlpha", _alpha];

					sleep 0.05;
				};
			};
		};

		true
	};

	EVO_revive_iconSelectControl = {
		private ["_unit"];
		_unit = _this;

		scriptName (format ["EVO_fnc_reviveIconControl: EVO_revive_iconSelectControl - [%1]", _unit]);

		// Wait for the icon to be allowed
		waitUntil {_unit getVariable ["EVO_revive_iconVisible", false] || !(_unit getVariable ["EVO_revive_iconEnabled", true])};

		while {_unit getVariable "EVO_revive_iconEnabled"} do {
			// Wait for the unit to be selected
			waitUntil {sleep 0.05; (missionNamespace getVariable ["EVO_revive_selected", objNull]) == _unit || {!(_unit getVariable "EVO_revive_iconEnabled")}};

			if (_unit getVariable "EVO_revive_iconEnabled") then {
				// Fade icon and text
				[_unit, 0.35, ["EVO_revive_selectAlpha", 0.45, 0.75, true], ["EVO_revive_textAlpha", 0, 1, true]] spawn EVO_revive_transformIcon;

				// Wait for the unit to be deselected
				waitUntil {sleep 0.05; (missionNamespace getVariable ["EVO_revive_selected", objNull]) != _unit || {!(_unit getVariable "EVO_revive_iconEnabled")}};

				if (_unit getVariable "EVO_revive_iconEnabled") then {
					// Remove icon and text
					[_unit, 0.35, ["EVO_revive_selectAlpha", 0.75, 0.45, true], ["EVO_revive_textAlpha", 1, 0, true]] spawn EVO_revive_transformIcon;
				};
			};
		};

		true
	};

	// Ensure synchronization
	if (_mode == "INIT") then {{["ADD", _x] call EVO_fnc_reviveIconControl} forEach EVO_revive_icons};
};

switch (_mode) do {
	case "ADD": {
		if (isServer) then {
			// Synchronize icons across clients
			if (!(_unit in EVO_revive_iconsGlobal)) then {
				EVO_revive_iconsGlobal = EVO_revive_iconsGlobal + [_unit];
				publicVariable "EVO_revive_iconsGlobal";
			};
		};

		if (isDedicated) exitWith {};
		if (_unit == player) exitWith {};

		// Manage unit's icon
		if (!(_unit in EVO_revive_icons)) then {EVO_revive_icons = EVO_revive_icons + [_unit]};
		_unit call EVO_fnc_reviveIconManager;

		// Reset icons
		[
			_unit,
			0,
			["EVO_revive_selectAlpha", 0.45, 0.45],
			["EVO_revive_incapSize", 0, 0],
			["EVO_revive_incapAlpha", 0, 0],
			["EVO_revive_deathSize", 0, 0],
			["EVO_revive_deathAlpha", 0, 0],
			["EVO_revive_textAlpha", 0, 0],
			["EVO_revive_incapColor", [0,0,0], [0,0,0]],
			["EVO_revive_deathColor", [0,0,0], [0,0,0]]
		] call EVO_revive_transformIcon;

		// Allow icon
		_unit setVariable ["EVO_revive_iconEnabled", true];
		_unit setVariable ["EVO_revive_iconVisible", true];
		if (group _unit != group player && {vehicle _unit distance vehicle player > EVO_revive_iconLimit}) then {_unit setVariable ["EVO_revive_iconVisible", false]};

		// Track whether the unit is selected, and their distance
		_unit spawn EVO_revive_iconSelectControl;
		_unit spawn EVO_revive_iconDistControl;
		_unit spawn EVO_revive_controlIconVisibility;
	};

	case "REMOVE": {
		if (isServer) then {
			// Synchronize icons across clients
			if (_unit in EVO_revive_iconsGlobal) then {
				EVO_revive_iconsGlobal = EVO_revive_icons - [_unit];
				publicVariable "EVO_revive_iconsGlobal";
			};
		};

		if (isDedicated) exitWith {};
		if (_unit == player) exitWith {};

		EVO_revive_icons = EVO_revive_icons - [_unit];

		// Remove icons
		[
			_unit,
			0,
			["EVO_revive_selectAlpha", 0.45, 0.45],
			["EVO_revive_incapSize", 0, 0],
			["EVO_revive_incapAlpha", 0, 0],
			["EVO_revive_deathSize", 0, 0],
			["EVO_revive_deathAlpha", 0, 0],
			["EVO_revive_textAlpha", 0, 0],
			["EVO_revive_incapColor", [0,0,0], [0,0,0]],
			["EVO_revive_deathColor", [0,0,0], [0,0,0]]
		] call EVO_revive_transformIcon;
	};

	case "DOWN": {
		if (isDedicated) exitWith {};
		if (_unit == player) exitWith {};

		scriptName (format ["EVO_fnc_reviveIconControl - [%1, %2]", _mode, _unit]);

		if (!(_unit getVariable ["EVO_revive_iconVisible", false])) exitWith {
			// Set up icon
			[
				_unit,
				0,
				["EVO_revive_incapColor", [0,0,0], [0.75,0,0]],
				["EVO_revive_incapSize", 0, 1],
				["EVO_revive_incapAlpha", 0, 1]
			] call EVO_revive_transformIcon;
		};

		// Fade in and resize
		[_unit, 0.1, ["EVO_revive_incapColor", [0.75,0,0], [0.4,0,0]], ["EVO_revive_incapAlpha", 0, 1], ["EVO_revive_incapSize", 0.4, 1.3]] call EVO_revive_transformIcon;
		[_unit, 0.2, ["EVO_revive_incapColor", [0.4,0,0], [0.75,0,0]], ["EVO_revive_incapSize", 1.3, 1]] call EVO_revive_transformIcon;
	};

	case "REVIVE": {
		if (isDedicated) exitWith {};
		if (_unit == player) exitWith {};

		scriptName (format ["EVO_fnc_reviveIconControl - [%1, %2]", _mode, _unit]);

		if (_unit getVariable ["EVO_revive_iconVisible", false]) then {
			// Set up skull icon
			[_unit, 0.2, ["EVO_revive_deathAlpha", 1, 0, true]] spawn EVO_revive_transformIcon;
		} else {
			// Hide skull icon
			[_unit, 0, ["EVO_revive_deathAlpha", 0, 0]] call EVO_revive_transformIcon;

			// Wait for the icon to be allowed
			waitUntil {_unit getVariable ["EVO_revive_iconVisible", false]};
		};

		private ["_inverse"];
		_inverse = false;

		while {!(isNull (_unit getVariable ["EVO_revive_helper", objNull]))} do {
			// Make the icon pulse
			private ["_alphaStart", "_alphaEnd"];
			_alphaStart = if (_inverse) then {0.4} else {1};
			_alphaEnd = if (_inverse) then {1} else {0.4};

			[_unit, 0.6, ["EVO_revive_incapAlpha", _alphaStart, _alphaEnd, true]] call EVO_revive_transformIcon;

			_inverse = if (_inverse) then {false} else {true};
		};

		// Bring icon to normal
		[_unit, 0.2, ["EVO_revive_incapAlpha", 0, 1, true]] call EVO_revive_transformIcon;
	};

	case "DYING": {
		if (isDedicated) exitWith {};
		if (_unit == player) exitWith {};

		scriptName (format ["EVO_fnc_reviveIconControl - [%1, %2]", _mode, _unit]);

		if (_unit getVariable ["EVO_revive_iconVisible", false]) then {
			// Set up incapacitated icon
			[_unit, 0.2, ["EVO_revive_incapAlpha", 0, 1, true]] spawn EVO_revive_transformIcon;
		} else {
			// Make sure incapacitated icon is visible
			[_unit, 0, ["EVO_revive_incapAlpha", 0, 1]] call EVO_revive_transformIcon;

			// Wait for the icon to be allowed
			waitUntil {_unit getVariable ["EVO_revive_iconVisible", false]};
		};

		private ["_inverse"];
		_inverse = false;

		// Set up skull icon
		[_unit, 0, ["EVO_revive_deathColor", [0,0,0], [1,1,1]], ["EVO_revive_deathSize", 0, 0.75]] call EVO_revive_transformIcon;

		while {_unit getVariable ["EVO_revive_forceRespawn", false] || _unit getVariable ["EVO_revive_dying", false]} do {
			// Make the skull icon pulse
			private ["_alphaStart", "_alphaEnd"];
			_alphaStart = if (_inverse) then {1} else {0};
			_alphaEnd = if (_inverse) then {0} else {1};

			[_unit, 0.5, ["EVO_revive_deathAlpha", _alphaStart, _alphaEnd]] call EVO_revive_transformIcon;

			_inverse = if (_inverse) then {false} else {true};
		};

		// Bring icon to normal
		[_unit, 0.2, ["EVO_revive_deathAlpha", 1, 0, true]] call EVO_revive_transformIcon;
	};

	case "DEAD": {
		if (isDedicated) exitWith {};
		if (_unit == player) exitWith {};

		scriptName (format ["EVO_fnc_reviveIconControl - [%1, %2]", _mode, _unit]);

		if (!(_unit getVariable ["EVO_revive_iconVisible", false])) exitWith {
			// Remove incapacitated icon and skull icon
			[_unit, 0, ["EVO_revive_incapAlpha", 0, 0], ["EVO_revive_deathSize", 0, 0], ["EVO_revive_deathColor", [0,0,0], [1,1,1]]] call EVO_revive_transformIcon;

			// Only show death icon if unit becomes a member of player's group
			waitUntil {sleep 0.05; group _unit == group player};
			[_unit, 0, ["EVO_revive_deathSize", 0, 0.7]] call EVO_revive_transformIcon;
		};

		// Fade out incapacitated icon
		[_unit, 0.2, ["EVO_revive_incapAlpha", 1, 0, true]] spawn EVO_revive_transformIcon;

		private ["_delay"];
		_delay = time + 0.1;
		waitUntil {sleep 0.05; time >= _delay};

		// Bring in dead icon
		[_unit, 0.1, ["EVO_revive_deathColor", [0,0,0], [1,0,0]], ["EVO_revive_deathAlpha", 0, 1], ["EVO_revive_deathSize", 0.4, 0.9]] call EVO_revive_transformIcon;
		[_unit, 0.2, ["EVO_revive_deathColor", [1,0,0], [1,1,1]], ["EVO_revive_deathSize", 0.9, 0.7]] call EVO_revive_transformIcon;

		_delay = time + 30;

		while {true} do {
			waitUntil {sleep 0.05; (time >= _delay || _unit getVariable ["EVO_revive_outRange", false]) || group _unit == group player};

			if (group _unit == group player) then {
				// Show dead icon
				[_unit, 0, ["EVO_revive_deathAlpha", 0, 1]] call EVO_revive_transformIcon;
				waitUntil {sleep 0.05; group _unit != group player};
			} else {
				if (time < (_delay + 1)) then {
					// Smoothly remove icon
					[_unit, 3, ["EVO_revive_deathAlpha", 1, 0, true]] spawn EVO_revive_transformIcon;
				} else {
					// Remove dead icon
					[_unit, 0, ["EVO_revive_deathAlpha", 0, 0]] call EVO_revive_transformIcon;
				};

				waitUntil {sleep 0.05; group _unit == group player};
			};
		};
	};
};

true