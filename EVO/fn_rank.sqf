private ["_player","_score","_newScore","_rank",_EVOrank,"_scoreToAdd","_msg","_txt","_pic"];


_player = player;
//_score = score _player;
_score = player getVariable "EVO_score";
_newScore = _score;
_rank = rank _player;
_EVOrank = _player getVariable "EVOrank";
if (isNil "_EVOrank") then {
	_player setVariable ["EVOrank", "none", true];
	_EVOrank = _player getVariable "EVOrank";
};
		//_newScore = _score + _scoreToAdd;
		//_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
		if (_newScore < rank1 and _EVOrank != "PRIVATE")  then {
			_player setUnitRank "PRIVATE";
			_player setVariable ["EVOrank", "PRIVATE", true];


			bon_max_units_allowed = 2;
			bon_recruit_recruitableunits = ["B_Soldier_F"];

			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;
			_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
			["promoted",["img\pvt.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
			{
				_dn = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank1weapons;
			{
				_dn = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgVehicles" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank1vehicles;
			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;


		};
		if (_newScore < rank2 and _newScore >= rank1 and _EVOrank != "CORPORAL")  then	{
			_player setUnitRank "CORPORAL";
			_player setVariable ["EVOrank", "CORPORAL", true];
			bon_max_units_allowed = 4;
			bon_recruit_recruitableunits = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_exp_F"];

			_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
			["promoted",["img\corp.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
			{
				_dn = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank2weapons;
			{
				_dn = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgVehicles" >>  _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank2vehicles;
			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;

		};
		if (_newScore < rank3 and _newScore >= rank2 and _EVOrank != "SERGEANT")  then	{
			_player setUnitRank "SERGEANT";
			_player setVariable ["EVOrank", "SERGEANT", true];

			bon_max_units_allowed = 6;
			bon_recruit_recruitableunits = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F","B_soldier_repair_F"];

			_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
			["promoted",["img\sgt.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
			{
				_dn = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank3weapons;
			{
				_dn = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgVehicles" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank3vehicles;
			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;
		};
		if (_newScore < rank4 and _newScore >= rank3 and _EVOrank != "LIEUTENANT")  then {
			_player setUnitRank "LIEUTENANT";
			_player setVariable ["EVOrank", "LIEUTENANT", true];
			bon_max_units_allowed = 8;
			bon_recruit_recruitableunits = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F","B_soldier_repair_F","B_Helipilot_F","B_soldier_AT_F","B_soldier_AA_F","B_engineer_F","B_helicrew_F"];

			_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
			["promoted",["img\ltn.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
			{
				_dn = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank4weapons;
			{
				_dn = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgVehicles" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank4vehicles;
			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;
		};
		if (_newScore < rank5 and _newScore >= rank4 and _EVOrank != "CAPTAIN")  then {
			_player setUnitRank "CAPTAIN";
			_player setVariable ["EVOrank", "CAPTAIN", true];
			bon_max_units_allowed = 10;
			bon_recruit_recruitableunits = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F","B_soldier_repair_F","B_Helipilot_F","B_soldier_AT_F","B_soldier_AA_F","B_engineer_F","B_helicrew_F","B_soldier_UAV_F"];

			_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
			["promoted",["img\cpt.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
			{
				_dn = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank5weapons;
			{
				_dn = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgVehicles" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank5vehicles;
			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;
		};
		if (_newScore < rank6 and _newScore >= rank5 and _EVOrank != "MAJOR")  then {
			_player setUnitRank "MAJOR";
			_player setVariable ["EVOrank", "MAJOR", true];
			bon_max_units_allowed = 12;
			bon_recruit_recruitableunits = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F","B_soldier_repair_F","B_Helipilot_F","B_soldier_AT_F","B_soldier_AA_F","B_engineer_F","B_helicrew_F","B_soldier_UAV_F","B_spotter_F","B_sniper_F"];

			_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
			["promoted",["img\mjr.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall"; {
				_dn = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank6weapons;
			{
				_dn = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgVehicles" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank6vehicles;
			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;
		};
		if (_newScore >= rank6 and _EVOrank != "COLONEL")  then {
			_player setUnitRank "COLONEL";
			_player setVariable ["EVOrank", "COLONEL", true];
			bon_max_units_allowed = 14;
			bon_recruit_recruitableunits = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F","B_soldier_repair_F","B_Helipilot_F","B_soldier_AT_F","B_soldier_AA_F","B_engineer_F","B_helicrew_F","B_soldier_UAV_F","B_spotter_F","B_sniper_F","B_ghillie_lsh_F","B_Recon_Sharpshooter_F","B_HeavyGunner_F","B_recon_JTAC_F","B_recon_M_F","B_recon_medic_F","B_recon_exp_F","B_recon_LAT_F","B_recon_F"];

			_msg = format ["You've been promoted to the rank of %1.", player getVariable "EVOrank"];
			["promoted",["img\col.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall"; {
				_dn = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank7weapons;
			{
				_dn = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
				_txt = format["You now have access to the %1.", _dn];
				_pic = getText(configFile >> "CfgVehicles" >> _x >> "picture");
				["unlocked",[_pic, _txt]] call BIS_fnc_showNotification;
			} forEach rank7vehicles;
			[hqbox, _EVOrank] call EVO_fnc_buildAmmoCrate;

		};
