/*
	Author: Thomas Ryan

	Description:
	Make a unit bleed out over time while incapacitated.

	Parameters:
		_this select 0: OBJECT - Unit that is bleeding out
		_this select 1 (Optional): NUMBER - Mode (0: normal (default), 1: add damage EH, 2: remove damage EH)

	Returns:
	True if successful, false if not.
*/

private ["_unit", "_mode"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_mode = [_this, 1, 0, [0]] call BIS_fnc_param;

if (isNull _unit) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message
if (!(_mode in [0,1,2])) exitWith {"" call BIS_fnc_error; false};	// ToDo: Add error message

switch (_mode) do {
	case 0: {
		// Store blood and damage
		_unit setVariable ["EVO_revive_blood", 1];
		_unit setVariable ["EVO_revive_damage", 0, true];

		// Add damage eventhandler
		[[_unit, 1], "EVO_fnc_reviveBleedOut"] call BIS_fnc_MP;

		// Reset damage
		_unit setDamage 0;

		// Bleed out
		_unit spawn {
			private ["_unit"];
			_unit = _this;

			scriptName (format ["EVO_fnc_reviveBleedOut: bleeding out - [%1]", _unit]);

			// Define the bleed out time
			private ["_cfg", "_time"];
			_cfg = missionConfigFile >> "reviveBleedOutDelay";
			_time = if (isClass _cfg) then {getNumber _cfg} else {EVO_revive_reviveBleedOutDelayDefault};

			private ["_timeBefore", "_total", "_blood"];
			_timeBefore = time;
			_total = _time;
			_blood = _unit getVariable "EVO_revive_blood";

			// Add post process effects
			if (!(isDedicated) && {_unit == player}) then {
				// Create effects
				if (isNil "EVO_revive_ppColor") then {EVO_revive_ppColor = ppEffectCreate ["ColorCorrections", 1632]};
				if (isNil "EVO_revive_ppVig") then {EVO_revive_ppVig = ppEffectCreate ["ColorCorrections", 1633]};
				if (isNil "EVO_revive_ppBlur") then {EVO_revive_ppBlur = ppEffectCreate ["DynamicBlur", 525]};

				// Set start points
				EVO_revive_ppColor ppEffectAdjust [1,1,0.15,[0.3,0.3,0.3,0],[0.3,0.3,0.3,0.3],[1,1,1,1]];
				EVO_revive_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[1,1,0,0,0,0.2,1]];
				EVO_revive_ppBlur ppEffectAdjust [0];
				{_x ppEffectCommit 0; _x ppEffectEnable true} forEach [EVO_revive_ppColor, EVO_revive_ppVig, EVO_revive_ppBlur];

				[] spawn {
					scriptName "EVO_fnc_reviveBleedOut: PP effect control";

					while {player getVariable ["EVO_revive_incapacitated", true]} do {
						sleep 1;

						if (player getVariable ["EVO_revive_incapacitated", true]) then {
							// Grab blood level
							private ["_blood"];
							_blood = player getVariable ["EVO_revive_blood", 1];

							// Calculate desaturation
							private ["_bright"];
							_bright = 0.2 + (0.1 * _blood);
							EVO_revive_ppColor ppEffectAdjust [1,1, 0.15 * _blood,[0.3,0.3,0.3,0],[_bright,_bright,_bright,_bright],[1,1,1,1]];

							// Calculate intensity of vignette
							private ["_intense"];
							_intense = 0.6 + (0.4 * _blood);
							EVO_revive_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[_intense,_intense,0,0,0,0.2,1]];

							// Calculate intensity of blur
							private ["_blur"];
							_blur = 0.7 * (1 - _blood);
							EVO_revive_ppBlur ppEffectAdjust [_blur];

							// Smoothly transition
							{_x ppEffectCommit 1} forEach [EVO_revive_ppColor, EVO_revive_ppVig, EVO_revive_ppBlur];
						};
					};

					// Set end state
					EVO_revive_ppColor ppEffectAdjust [1,1,0,[0.3,0.3,0.3,0],[0.2,0.2,0.2,0.2],[1,1,1,1]];
					EVO_revive_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[0.6,0.6,0,0,0,0.2,1]];
					EVO_revive_ppBlur ppEffectAdjust [0.7];
					{_x ppEffectCommit 1} forEach [EVO_revive_ppColor, EVO_revive_ppVig, EVO_revive_ppBlur];
				};

				// Terminate effects when player respawns or is revived
				[] spawn {
					scriptName "EVO_fnc_reviveBleedOut: PP effect terminate";
					waitUntil {alive player && !(player getVariable ["EVO_revive_incapacitated", true])};
					{_x ppEffectEnable false} forEach [EVO_revive_ppColor, EVO_revive_ppVig, EVO_revive_ppBlur];
				};
			};

			waitUntil {
				sleep 0.01;

				// Only count down if the unit is bleeding out
				if (isNull (_unit getVariable ["EVO_revive_helper", objNull])) then {
					_time = _time - (time - _timeBefore);
				};

				_timeBefore = time;

				private ["_damage", "_timePassed"];
				_damage = _unit getVariable ["EVO_revive_damage", 0];

				// Calculate blood
				_blood = ((_time / _total) - _damage);
				_unit setVariable ["EVO_revive_blood", _blood];

				// Warn others of players about to die
				if (_blood < 0.25 && {!(_unit getVariable ["EVO_revive_dying", false])}) then {_unit setVariable ["EVO_revive_dying", true, true]};

				if (isNull (_unit getVariable ["EVO_revive_helper", objNull])) then {
					// Unit is bleeding out
					_blood <= 0 || _damage >= 1 || !(_unit getVariable "EVO_revive_incapacitated") || !(alive _unit)
				} else {
					// Wait for unit to stop being revived
					isNull (_unit getVariable "EVO_revive_helper") || _blood <=0 || _damage >= 1 || !(_unit getVariable "EVO_revive_incapacitated") || !(alive _unit)
				};
			};

			// Remove damage eventhandlers
			[[_unit, 2], "EVO_fnc_reviveBleedOut"] call BIS_fnc_MP;

			// Kill unit if it bled out
			if (_unit getVariable "EVO_revive_incapacitated") then {forceRespawn _unit};
		};
	};

	case 1: {
		// Track damage
		private ["_damageEH"];
		_damageEH = _unit addEventHandler [
			"HandleDamage",
			{
				private ["_unit", "_selection", "_damage"];
				_unit = _this select 0;
				_selection = _this select 1;
				_damage = _this select 2;

				// Store damage dealt
				if (local _unit && {(toUpper _selection) in ["", "HEAD"]}) then {_unit setVariable ["EVO_revive_damage", (_unit getVariable "EVO_revive_damage") + _damage, true]};

				// Prevent damage
				0
			}
		];

		// Store damage eventhandler
		_unit setVariable ["EVO_revive_damageEH", _damageEH];
	};

	case 2: {
		// Reset blood and damage
		_unit setVariable ["EVO_revive_blood", 1];
		_unit setVariable ["EVO_revive_damage", 0];

		if (!(isNil {_unit getVariable "EVO_revive_damageEH"})) then {
			// Unit has a damage eventhandler assigned
			_unit removeEventHandler ["HandleDamage", _unit getVariable "EVO_revive_damageEH"];
			_unit setVariable ["EVO_revive_damageEH", nil];
		};
	};
};

true