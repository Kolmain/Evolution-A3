private ["_player","_score","_newScore","_rank","_EVOrank","_scoreToAdd","_msg","_txt","_pic"];


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
		_msg = format ["You've been promoted to the rank of %1.", rank _player];
		if (_newScore < rank1 and _EVOrank != "PRIVATE")  then {
			_player setUnitRank "PRIVATE";
			_player setVariable ["EVOrank", "PRIVATE", true];
			if (!isNil "hqbox") then {
				deleteVehicle hqbox;
			};
			bon_max_units_allowed = 2;
			hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
			availableWeapons = availableWeapons + rank1weapons;
			availableMagazines = availableMagazines + rank1magazines;
			["promoted",["img\pvt.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
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


		};
		if (_newScore < rank2 and _newScore >= rank1 and _EVOrank != "CORPORAL")  then	{
			_player setUnitRank "CORPORAL";
			_player setVariable ["EVOrank", "CORPORAL", true];
			if (!isNil "hqbox") then {
				deleteVehicle hqbox;
			};
			bon_max_units_allowed = 4;
			hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
			availableWeapons = availableWeapons + rank1weapons + rank2weapons;
			availableItems = availableItems + rank2items;
			availableMagazines = availableMagazines + rank1magazines;
			["promoted",["img\corp.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
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

		};
		if (_newScore < rank3 and _newScore >= rank2 and _EVOrank != "SERGEANT")  then	{
			_player setUnitRank "SERGEANT";
			_player setVariable ["EVOrank", "SERGEANT", true];
			if (!isNil "hqbox") then {
				deleteVehicle hqbox;
			};
			bon_max_units_allowed = 6;
			hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons;
			availableItems = availableItems + rank2items + rank3items;
			availableMagazines = availableMagazines + rank1magazines;
			["promoted",["img\sgt.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
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
		};
		if (_newScore < rank4 and _newScore >= rank3 and _EVOrank != "LIEUTENANT")  then {
			_player setUnitRank "LIEUTENANT";
			_player setVariable ["EVOrank", "LIEUTENANT", true];
			if (!isNil "hqbox") then {
				deleteVehicle hqbox;
			};
			bon_max_units_allowed = 8;
			hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons;
			["promoted",["img\ltn.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
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
		};
		if (_newScore < rank5 and _newScore >= rank4 and _EVOrank != "CAPTAIN")  then {
			_player setUnitRank "CAPTAIN";
			_player setVariable ["EVOrank", "CAPTAIN", true];
			if (!isNil "hqbox") then {
				deleteVehicle hqbox;
			};
			bon_max_units_allowed = 10;
			hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons;
			["promoted",["img\cpt.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
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
		};
		if (_newScore < rank6 and _newScore >= rank5 and _EVOrank != "MAJOR")  then {
			_player setUnitRank "MAJOR";
			_player setVariable ["EVOrank", "MAJOR", true];
			if (!isNil "hqbox") then {
				deleteVehicle hqbox;
			};
			bon_max_units_allowed = 12;
			hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank6weapons;
			["promoted",["img\mjr.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
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
		};
		if (_newScore >= rank6 and _EVOrank != "COLONEL")  then {
			_player setUnitRank "COLONEL";
			_player setVariable ["EVOrank", "COLONEL", true];
			if (!isNil "hqbox") then {
				deleteVehicle hqbox;
			};
			bon_max_units_allowed = 14;
			hqbox = "CargoNet_01_box_F" createVehicleLocal (getMarkerPos "ammobox");
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank7weapons;
			["promoted",["img\col.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
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

		};
