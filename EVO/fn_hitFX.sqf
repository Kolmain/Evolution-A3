_unit = _this select 0;
_causedBy = _this select 1;
_damage = _this select 2;
if (player distance _unit > 150) exitWith {};
if (ceil random 2 == 1) exitWith {};

_hitRecently = _unit getVariable ["mrg_unit_sfx_hitRecently", false];

if (!_hitRecently) then {
	_unit setVariable ["mrg_unit_sfx_hitRecently", true]; // Prevents closely repeated sounds
	if (alive _unit) then {
		sleep 0.05 + ((random 1.4)/10);
		_unit say (mrg_unit_sfx_scream select floor random mrg_unit_sfx_scream_size);
	} else {
		_obj = "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];
		_obj attachTo [_unit,[0,0,1]];
		sleep 0.05 + ((random 1.4)/10);
		_obj say (mrg_unit_sfx_scream select floor random mrg_unit_sfx_scream_size);
	};
	_unit setVariable ["mrg_unit_sfx_hitRecently", false];
};