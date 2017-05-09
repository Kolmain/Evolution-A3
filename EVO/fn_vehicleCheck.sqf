private ["_player","_vehicle","_class","_classname","_displayName","_txt"];

checkPlayer = {
	params ["_vehicle", "_player", "_classname", "_vlist"];
  if ((faction _vehicle == "BLU_F") && !(_classname in _vlist)) then {
		{
			player globalchat _x;
		}foreach _vlist;
		player globalchat _classname;
		_displayName = getText(configFile >>  "CfgVehicles" >> typeOf _vehicle >> "displayName");
		_txt = format["You are not qualified to operate this %1", _displayName];
		["notQualified",[_txt]] call BIS_fnc_showNotification; _player action ["engineOff", vehicle _player];

		_player action ["getOut", vehicle _player];
		_player action ["Eject", vehicle _player];
		sleep 10;
	};
};

_player = _this select 0;
_vehicle = vehicle _player;
_class = typeOf _vehicle;
if (_vehicle != _player && (driver _vehicle == _player)) then {
	switch (rank player) do {
		case "PRIVATE": {
			switch (typeOf player) do {
				case "B_Soldier_F";
				case "B_soldier_AT_F";
				case "B_sniper_F";
				case "B_soldier_AR_F";
				case "B_medic_F";
				case "B_engineer_F": {
					[_vehicle, _player, _class, srank0vehicles] call checkPlayer;
				};
				case "B_crew_F": {
					[_vehicle, _player, _class, crank0vehicles] call checkPlayer;
				};
				case "B_Helipilot_F": {
					[_vehicle, _player, _class, prank0vehicles] call checkPlayer;
				};
			};
		};
		case "CORPORAL": {
			switch (typeOf player) do {
				case "B_Soldier_F";
				case "B_soldier_AT_F";
				case "B_sniper_F";
				case "B_soldier_AR_F";
				case "B_medic_F";
				case "B_engineer_F": {
					[_vehicle, _player, _class, srank1vehicles] call checkPlayer;
				};
				case "B_crew_F": {
					[_vehicle, _player, _class, crank1vehicles] call checkPlayer;
				};
				case "B_Helipilot_F": {
					[_vehicle, _player, _class, prank1vehicles] call checkPlayer;
				};
			};
		};
		case "SERGEANT": {
			switch (typeOf player) do {
				case "B_Soldier_F";
				case "B_soldier_AT_F";
				case "B_sniper_F";
				case "B_soldier_AR_F";
				case "B_medic_F";
				case "B_engineer_F": {
					[_vehicle, _player, _class, srank2vehicles] call checkPlayer;
				};
				case "B_crew_F": {
					[_vehicle, _player, _class, crank2vehicles] call checkPlayer;
				};
				case "B_Helipilot_F": {
					[_vehicle, _player, _class, prank2vehicles] call checkPlayer;
				};
			};
		};
		case "LIEUTENANT": {
			switch (typeOf player) do {
				case "B_Soldier_F";
				case "B_soldier_AT_F";
				case "B_sniper_F";
				case "B_soldier_AR_F";
				case "B_medic_F";
				case "B_engineer_F": {
					[_vehicle, _player, _class, srank3vehicles] call checkPlayer;
				};
				case "B_crew_F": {
					[_vehicle, _player, _class, crank3vehicles] call checkPlayer;
				};
				case "B_Helipilot_F": {
					[_vehicle, _player, _class, prank3vehicles] call checkPlayer;
				};
			};
	};
		case "CAPTAIN": {
			switch (typeOf player) do {
				case "B_Soldier_F";
				case "B_soldier_AT_F";
				case "B_sniper_F";
				case "B_soldier_AR_F";
				case "B_medic_F";
				case "B_engineer_F": {
					[_vehicle, _player, _class, srank4vehicles] call checkPlayer;
				};
				case "B_crew_F": {
					[_vehicle, _player, _class, crank4vehicles] call checkPlayer;
				};
				case "B_Helipilot_F": {
					[_vehicle, _player, _class, prank4vehicles] call checkPlayer;
				};
			};
		};
		case "MAJOR": {
			switch (typeOf player) do {
				case "B_Soldier_F";
				case "B_soldier_AT_F";
				case "B_sniper_F";
				case "B_soldier_AR_F";
				case "B_medic_F";
				case "B_engineer_F": {
					[_vehicle, _player, _class, srank5vehicles] call checkPlayer;
				};
				case "B_crew_F": {
					[_vehicle, _player, _class, crank5vehicles] call checkPlayer;
				};
				case "B_Helipilot_F": {
					[_vehicle, _player, _class, prank5vehicles] call checkPlayer;
				};
			};
		};
		case "COLONEL": {
			switch (typeOf player) do {
				case "B_Soldier_F";
				case "B_soldier_AT_F";
				case "B_sniper_F";
				case "B_soldier_AR_F";
				case "B_medic_F";
				case "B_engineer_F": {
					[_vehicle, _player, _class, srank6vehicles] call checkPlayer;
				};
				case "B_crew_F": {
					[_vehicle, _player, _class, crank6vehicles] call checkPlayer;
				};
				case "B_Helipilot_F": {
					[_vehicle, _player, _class, prank6vehicles] call checkPlayer;
				};
			};
		};
	};
};
