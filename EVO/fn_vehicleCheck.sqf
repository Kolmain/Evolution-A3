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
	if (_vehicle != _player && (driver _vehicle == _player)) then {
		if (_vehicle isKindOf "Helicopter") then {
			loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
			handle = [player, [["ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","H_PilotHelmetHeli_B","G_Tactical_Black"],"SMG_01_Holo_F",["","","optic_Holosight_smg",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_HeliPilotCoveralls",["FirstAidKit","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01","Chemlight_green"],"V_TacVest_oli",["FirstAidKit","FirstAidKit","FirstAidKit","30Rnd_45ACP_Mag_SMG_01","SmokeShellGreen","SmokeShellBlue","SmokeShellOrange","Chemlight_green","Chemlight_blue","B_IR_Grenade","30Rnd_45ACP_Mag_SMG_01","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag"],"",[],[["30Rnd_45ACP_Mag_SMG_01"],["16Rnd_9x21_Mag"],[],[]],"SMG_01_Holo_F","Single"]] execVM "scripts\setloadout.sqf";
			handle = [] spawn {
				waitUntil {vehicle player == player};
				if (player in list AirportIn) then {
					handle = [player, loadout] execVM "scripts\setloadout.sqf";
				};
			};
		};
		if (_vehicle isKindOf "Plane") then {
			loadout = [player] call compile preprocessFileLineNumbers "scripts\getloadout.sqf";
			handle = [player, [["ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","H_PilotHelmetFighter_B","G_Tactical_Black"],"SMG_01_Holo_F",["","","optic_Holosight_smg",""],"hgun_P07_F",["","","",""],"",["","","",""],"U_B_PilotCoveralls",["FirstAidKit","30Rnd_45ACP_Mag_SMG_01","SmokeShell","SmokeShellBlue","Chemlight_green","Chemlight_blue","B_IR_Grenade","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag"],"",[],"B_Parachute",[],[["30Rnd_45ACP_Mag_SMG_01"],["16Rnd_9x21_Mag"],[],[]],"SMG_01_Holo_F","Single"]] execVM "scripts\setloadout.sqf";
			handle = [] spawn {
				waitUntil {vehicle player == player};
				if (player in list AirportIn) then {
					handle = [player, loadout] execVM "scripts\setloadout.sqf";
				};
			};
		};

	}
};