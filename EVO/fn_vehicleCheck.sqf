private ["_player","_vehicle","_class","_classname","_displayName","_txt"];



_player = _this select 0;
_vehicle = vehicle _player;
_class = typeOf _vehicle;
_classname = toLower(_class);
if (_vehicle != _player && (driver _vehicle == _player)) then {
	switch (rank player) do {
		case "PRIVATE": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles)) then {
				_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
				_txt = format["You are not qualified to operate this %1", _displayName];
				["notQualified",[_txt]] call BIS_fnc_showNotification; _player action ["engineOff", vehicle _player];

				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
				sleep 10;
			};
		};
		case "CORPORAL": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles)) then {
				_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
				_txt = format["You are not qualified to operate this %1", _displayName];
				["notQualified",[_txt]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];

				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
				sleep 10;
			};
		};
		case "SERGEANT": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles)) then {
				_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
				_txt = format["You are not qualified to operate this %1", _displayName];
				["notQualified",[_txt]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];

				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
				sleep 10;
			};
		};
		case "LIEUTENANT": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles)) then {
				_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
				_txt = format["You are not qualified to operate this %1", _displayName];
				["notQualified",[_txt]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];

				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
				sleep 10;
		};
	};
		case "CAPTAIN": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles) && !(_classname in rank5vehicles)) then {
				_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
				_txt = format["You are not qualified to operate this %1", _displayName];
				["notQualified",[_txt]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];

				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
				sleep 10;
			};
		};
		case "MAJOR": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles) && !(_classname in rank5vehicles) && !(_classname in rank6vehicles)) then {
				_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
				_txt = format["You are not qualified to operate this %1", _displayName];
				["notQualified",[_txt]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];

				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
				sleep 10;
			};
		};
		case "COLONEL": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles) && !(_classname in rank5vehicles) && !(_classname in rank6vehicles) && !(_classname in rank7vehicles)) then {
				_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
				_txt = format["You are not qualified to operate this %1", _displayName];
				["notQualified",[_txt]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];

				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
				sleep 10;
			};
		};
	};
};