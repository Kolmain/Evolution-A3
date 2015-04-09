_player = _this select 0;
_vehicle = vehicle _player;
_class = typeOf _vehicle;
_classname = toLower(_class);
if (_vehicle != _player && (driver _vehicle == _player)) then {
	switch (rank player) do {
		case "PRIVATE": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles)) then {
				["notQualified",["You are not qualified to operate this vehicle."]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];
				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
			};
		};
		case "CORPORAL": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles)) then {
				["notQualified",["You are not qualified to operate this vehicle."]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];
				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
			};
		};
		case "SERGEANT": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles)) then {
				["notQualified",["You are not qualified to operate this vehicle."]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];
				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
			};
		};
		case "LIEUTENANT": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles)) then {
				["notQualified",["You are not qualified to operate this vehicle."]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];
				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
		};
	};
		case "CAPTAIN": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles) && !(_classname in rank5vehicles)) then {
				["notQualified",["You are not qualified to operate this vehicle."]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];
				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
			};
		};
		case "MAJOR": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles) && !(_classname in rank5vehicles) && !(_classname in rank6vehicles)) then {
				["notQualified",["You are not qualified to operate this vehicle."]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];
				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
			};
		};
		case "COLONEL": {
			if ((faction _vehicle == "BLU_F") && !(_classname in rank1vehicles) && !(_classname in rank2vehicles) && !(_classname in rank3vehicles) && !(_classname in rank4vehicles) && !(_classname in rank5vehicles) && !(_classname in rank6vehicles) && !(_classname in rank7vehicles)) then {
				["notQualified",["You are not qualified to operate this vehicle."]] call BIS_fnc_showNotification;
				_player action ["engineOff", vehicle _player];
				_player action ["getOut", vehicle _player];
				_player action ["Eject", vehicle _player];
			};
		};
	};
};