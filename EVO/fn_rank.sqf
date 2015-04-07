private ["_score","_player","_newScore","_rank","_scoreToAdd","_msg"];

_score = score _player;
_newScore = _score;
_rank = rank _player;
		//_newScore = _score + _scoreToAdd;
		_msg = format ["You've been promoted to the rank of %1.", rank _player];
		if (_newScore < rank1 and _rank != "PRIVATE")  then {
			_player setUnitRank "PRIVATE";
			availableWeapons = availableWeapons + rank1weapons;
			availableMagazines = availableMagazines + rank1magazines;
			["promoted",["img\pvt.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
			playsound "Paycall";
		};
		if (_newScore < rank2 and _newScore >= rank1 and _rank != "CORPORAL")  then	{
			_player setUnitRank "CORPORAL";
			availableWeapons = availableWeapons + rank1weapons + rank2weapons;
			availableItems = availableItems + rank2items;
			availableMagazines = availableMagazines + rank1magazines;
			["promoted",["img\corp.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
			playsound "Paycall";
		};
		if (_newScore < rank3 and _newScore >= rank2 and _rank != "SERGEANT")  then	{
			_player setUnitRank "SERGEANT";
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons;
			availableItems = availableItems + rank2items + rank3items;
			availableMagazines = availableMagazines + rank1magazines;
			["promoted",["img\sgt.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
			playsound "Paycall";
		};
		if (_newScore < rank4 and _newScore >= rank3 and _rank != "LIEUTENANT")  then {
			_player setUnitRank "LIEUTENANT";
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons;
			["promoted",["img\ltn.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
			playsound "Paycall";
		};
		if (_newScore < rank5 and _newScore >= rank4 and _rank != "CAPTAIN")  then {
			_player setUnitRank "CAPTAIN";
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons;
			["promoted",["img\cpt.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
			playsound "Paycall";
		};
		if (_newScore < rank6 and _newScore >= rank5 and _rank != "MAJOR")  then {
			_player setUnitRank "MAJOR";
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank6weapons;
			["promoted",["img\mjr.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
			playsound "Paycall";
		};
		if (_newScore >= rank6 and _rank != "COLONEL")  then {
			_player setUnitRank "COLONEL";
			availableWeapons = availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank7weapons;
			["promoted",["img\col.paa", _msg]] call BIS_fnc_showNotification;
			[hqbox, (availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
			[hqbox, (availableHeadgear + availableGoggles + availableItems + availableUniforms + availableVests)] call BIS_fnc_addVirtualItemCargo;
			[hqbox, (availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
			[hqbox, (availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
			playsound "Paycall";
		};