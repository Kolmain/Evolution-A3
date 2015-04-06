waitUntil {!isNull player};
_mus = [] spawn BIS_fnc_jukebox;
_amb = [] call EVO_fnc_amb;
//_brief = [] execVM "briefing.sqf";
player addaction ["Modify Loadout","['Open',true] spawn BIS_fnc_arsenal;",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
player addaction ["Recruit Infantry","bon_recruit_units\open_dialog.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
player addaction ["<t color='#ff9900'>HALO Insertion</t>","ATM_airdrop\atm_airdrop.sqf",nil,1,false,true,"","(player distance spawnBuilding) < 25"];
if (!isNull hqbox) then {deleteVehicle hqbox};
hqbox = "Box_Ammo_F" createVehicleLocal (getMarkerPos "ammob1");
["AmmoboxInit",[hqbox, false, {true}]] spawn BIS_fnc_arsenal;
if (("pfatigue" call BIS_fnc_getParamValue) == 0) then {
	player enableFatigue false;
} else {
	player enableFatigue true;
};

if (("pRespawnPoints" call BIS_fnc_getParamValue) == 1) then {
	_respawnPos = [(side player), player] spawn BIS_fnc_addRespawnPosition;
};

if (typeOf player == "B_medic_F") then {
	player addAction ["<t color='#CCCC00'>Build MASH</t>", "[] call EVO_fnc_deployMplayer;"];
};

if (typeOf player == "B_soldier_repair_F") then {
	player addAction ["<t color='#CCCC00'>Build FARP</t>", "[] call EVO_fnc_deployEplayer;"];
};



handle = [] spawn {
	_firstRun = true;
	if (_firstRun) then {
		sleep 10;
	};
	//Lists of items to include
	_availableHeadgear = [
	"H_HelmetB",
	"H_HelmetB_camo",
	"H_HelmetB_paint",
	"H_HelmetB_light",
	"H_HelmetSpecB",
	"H_Booniehat_mcamo",
	"H_Booniehat_khk_hs",
	"H_MilCap_mcamo",
	"H_Cap_tan_specops_US",
	"H_Cap_khaki_specops_UK",
	"H_Cap_headphones",
	"H_Bandanna_mcamo",
	"H_Bandanna_khk_hs",
	"H_Shemag_khk",
	"H_ShemagOpen_khk",
	"H_Watchcap_blk",
	"H_PilotHelmetHeli_B",
	"H_CrewHelmetHeli_B",
	"H_PilotHelmetFighter_B",
	"H_HelmetCrew_B"
	];

	_availableGoggles = [
	"G_Combat",
	"G_Lowprofile",
	"G_Shades_Black",
	"G_Shades_Blue",
	"G_Shades_Green",
	"G_Shades_Red",
	"G_Sport_Blackred",
	"G_Sport_Blackyellow",
	"G_Squares_Tinted",
	"G_Tactical_Black",
	"G_Tactical_Clear",
	"G_Bandanna_blk"
	];

	_availableUniforms = [
	"U_B_CombatUniform_mcam",
	"U_B_CombatUniform_mcam_tshirt",
	"U_B_CombatUniform_mcam_vest",
	"U_B_HeliPilotCoveralls",
	"U_B_CTRG_1",
	"U_B_CTRG_2",
	"U_B_CTRG_3"
	];

	_availableVests = [
	"V_BandollierB_khk",
	"V_BandollierB_blk",
	"V_PlateCarrier1_rgr",
	"V_PlateCarrier2_rgr",
	"V_PlateCarrierGL_rgr",
	"V_PlateCarrierSpec_rgr",
	"V_PlateCarrierL_CTRG",
	"V_PlateCarrierH_CTRG"
	];

	_availableItems = [
	"ItemWatch",
	"ItemCompass",
	"ItemGPS",
	"ItemRadio",
	"ItemMap",
	"MineDetector",
	"Binocular",
	"NVGoggles",
	"FirstAidKit",
	"Medikit",
	"ToolKit"
	];

	_availableBackpacks = [
	"B_AssaultPack_rgr",
	"B_AssaultPack_mcamo",
	"B_Kitbag_rgr",
	"B_Kitbag_mcamo",
	"B_TacticalPack_blk",
	"B_TacticalPack_mcamo"
	];

	_availableWeapons = [];

	_availableMagazines = [];

	while {alive player} do {
		_player = player;
		_vehicle = vehicle player;
		_class = typeOf _vehicle;
		_classname = toLower(_class);
		if (_vehicle != _player && (driver _vehicle == _player)) then {
			switch (rank _player) do {
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
		//_object = _this select 1;
		//_scoreToAdd = _this select 2;
		_score = score _player;
		_newScore = _score;
		_rank = rank _player;
		//_newScore = _score + _scoreToAdd;
		_msg = format ["You've been promoted to the rank of %1.", rank _player];
		if (_newScore < rank1 and _rank != "PRIVATE")  then {
			_player setUnitRank "PRIVATE";
			_availableWeapons = _availableWeapons + rank1weapons;
			_availableMagazines = _availableMagazines + rank1magazines;
			["promoted",["img\pvt.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
		};
		if (_newScore < rank2 and _newScore >= rank1 and _rank != "CORPORAL")  then	{
			_player setUnitRank "CORPORAL";
			_availableWeapons = _availableWeapons + rank1weapons + rank2weapons;
			_availableItems = _availableItems + rank2items;
			_availableMagazines = _availableMagazines + rank1magazines;
			["promoted",["img\corp.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
		};
		if (_newScore < rank3 and _newScore >= rank2 and _rank != "SERGEANT")  then	{
			_player setUnitRank "SERGEANT";
			_availableWeapons = _availableWeapons + rank1weapons + rank2weapons + rank3weapons;
			_availableItems = _availableItems + rank2items + rank3items;
			_availableMagazines = _availableMagazines + rank1magazines;
			["promoted",["img\sgt.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
		};
		if (_newScore < rank4 and _newScore >= rank3 and _rank != "LIEUTENANT")  then {
			_player setUnitRank "LIEUTENANT";
			_availableWeapons = _availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons;
			["promoted",["img\ltn.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
		};
		if (_newScore < rank5 and _newScore >= rank4 and _rank != "CAPTAIN")  then {
			_player setUnitRank "CAPTAIN";
			_availableWeapons = _availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank5weapons;
			["promoted",["img\cpt.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
		};
		if (_newScore < rank6 and _newScore >= rank5 and _rank != "MAJOR")  then {
			_player setUnitRank "MAJOR";
			_availableWeapons = _availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank6weapons;
			["promoted",["img\mjr.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
		};
		if (_newScore >= rank6 and _rank != "COLONEL")  then {
			_player setUnitRank "COLONEL";
			_availableWeapons = _availableWeapons + rank1weapons + rank2weapons + rank3weapons + rank4weapons + rank7weapons;
			["promoted",["img\col.paa", _msg]] call BIS_fnc_showNotification;
			playsound "Paycall";
		};
		_firstRun = false;
		[hqbox, (_availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
		[hqbox, (_availableHeadgear + _availableGoggles + _availableItems + _availableUniforms + _availableVests)] call BIS_fnc_addVirtualItemCargo;
		[hqbox, (_availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
		[hqbox, (_availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
		sleep 3;
	};





