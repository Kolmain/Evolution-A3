private ["_player","_score","_newScore","_rank","_EVOrank","_scoreToAdd","_msg","_dn","_txt","_pic"];

//////////////////////////////////////
//Check Player Rank Against His Score
//////////////////////////////////////
_player = player;
_score = score _player;
_newScore = _score;
_rank = rank _player;
_EVOrank = _rank;
//////////////////////////////////////
//PRIVATE | RANK1
//////////////////////////////////////
if ((_newScore < rank1) and (_EVOrank != "PRIVATE"))  then {
	_player setUnitRank "PRIVATE";
	bon_max_units_allowed = 2;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	[hqbox, (score _player)] call EVO_fnc_buildAmmoCrate;
	_msg = format ["You've been promoted to the rank of %1.", rank player];
	["promoted",["img\pvt.paa", _msg]] call BIS_fnc_showNotification;
	playsound "Paycall";
	{ [_x, (rank _player)] call EVO_fnc_buildAmmoCrate } forEach EVO_vaCrates;
};
//////////////////////////////////////
//CORPORAL | RANK2
//////////////////////////////////////
if (_newScore < rank2 and _newScore >= rank1 and _EVOrank != "CORPORAL")  then	{
	_player setUnitRank "CORPORAL";
	bon_max_units_allowed = 4;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack","CUP_B_US_Soldier_GL","CUP_B_US_Soldier_AR","B_soldier_exp_F"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	_msg = format ["You've been promoted to the rank of %1.", rank player];
	["promoted",["img\corp.paa", _msg]] call BIS_fnc_showNotification;
	playsound "Paycall";
	sleep 5;
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
	{ [_x, (rank _player)] call EVO_fnc_buildAmmoCrate } forEach EVO_vaCrates;
};
//////////////////////////////////////
//SERGEANT | RANK3
//////////////////////////////////////
if (_newScore < rank3 and _newScore >= rank2 and _EVOrank != "SERGEANT")  then	{
	_player setUnitRank "SERGEANT";
	bon_max_units_allowed = 6;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack","CUP_B_US_Soldier_GL","CUP_B_US_Soldier_AR","CUP_B_US_Soldier_MG","CUP_B_US_Soldier_AT","CUP_B_US_Medic"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	_msg = format ["You've been promoted to the rank of %1.", rank player];
	["promoted",["img\sgt.paa", _msg]] call BIS_fnc_showNotification;
	playsound "Paycall";
	sleep 5;
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
	{ [_x, (rank _player)] call EVO_fnc_buildAmmoCrate } forEach EVO_vaCrates;
};
//////////////////////////////////////
//LIEUTENANT | RANK4
//////////////////////////////////////
if (_newScore < rank4 and _newScore >= rank3 and _EVOrank != "LIEUTENANT")  then {
	_player setUnitRank "LIEUTENANT";
	bon_max_units_allowed = 8;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack","CUP_B_US_Soldier_GL","CUP_B_US_Soldier_AR","CUP_B_US_Soldier_MG","CUP_B_US_Soldier_AT","CUP_B_US_Medic","CUP_B_US_Soldier_Engineer","CUP_B_US_Pilot_Light"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	_msg = format ["You've been promoted to the rank of %1.", rank player];
	["promoted",["img\ltn.paa", _msg]] call BIS_fnc_showNotification;
	playsound "Paycall";
	sleep 5;
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
	{ [_x, (rank _player)] call EVO_fnc_buildAmmoCrate } forEach EVO_vaCrates;
};
//////////////////////////////////////
//CAPTAIN | RANK5
//////////////////////////////////////
if (_newScore < rank5 and _newScore >= rank4 and _EVOrank != "CAPTAIN")  then {
	_player setUnitRank "CAPTAIN";
	bon_max_units_allowed = 10;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack","CUP_B_US_Soldier_GL","CUP_B_US_Soldier_AR","CUP_B_US_Soldier_MG","CUP_B_US_Soldier_AT","CUP_B_US_Medic","CUP_B_US_Soldier_Engineer","CUP_B_US_Pilot_Light"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	_msg = format ["You've been promoted to the rank of %1.", rank player];
	["promoted",["img\cpt.paa", _msg]] call BIS_fnc_showNotification;
	playsound "Paycall";
	sleep 5;
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
	{ [_x, (rank _player)] call EVO_fnc_buildAmmoCrate } forEach EVO_vaCrates;
};
//////////////////////////////////////
//MAJOR | RANK6
//////////////////////////////////////
if (_newScore < rank6 and _newScore >= rank5 and _EVOrank != "MAJOR")  then {
	_player setUnitRank "MAJOR";
	bon_max_units_allowed = 12;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack","CUP_B_US_Soldier_GL","CUP_B_US_Soldier_AR","CUP_B_US_Soldier_MG","CUP_B_US_Soldier_AT","CUP_B_US_Medic","CUP_B_US_Soldier_Engineer","CUP_B_US_Pilot_Light","CUP_B_US_Sniper"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	_msg = format ["You've been promoted to the rank of %1.", rank player];
	["promoted",["img\mjr.paa", _msg]] call BIS_fnc_showNotification;
	playsound "Paycall";
	sleep 5;
		{
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
	{ [_x, (rank _player)] call EVO_fnc_buildAmmoCrate } forEach EVO_vaCrates;
//////////////////////////////////////
//COLONEL | RANK7
//////////////////////////////////////
};
if (_newScore >= rank6 and _EVOrank != "COLONEL")  then {
	_player setUnitRank "COLONEL";
	bon_max_units_allowed = 14;
	bon_recruit_recruitableunits = ["CUP_B_US_Soldier_Backpack","CUP_B_US_Soldier_GL","CUP_B_US_Soldier_AR","CUP_B_US_Soldier_MG","CUP_B_US_Soldier_AT","CUP_B_US_Medic","CUP_B_US_Soldier_Engineer","CUP_B_US_Pilot_Light","CUP_B_US_Sniper","CUP_B_US_SpecOps_SD"];
	handle = [] execVM "bon_recruit_units\build_unitlist.sqf";
	_msg = format ["You've been promoted to the rank of %1.", rank player];
	["promoted",["img\col.paa", _msg]] call BIS_fnc_showNotification;
	playsound "Paycall";
	sleep 5;
		{
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
	{ [_x, (rank _player)] call EVO_fnc_buildAmmoCrate } forEach EVO_vaCrates;
};
