/* 
CORE FUNCTIONS FOR TPW MODS
Author: tpw 
Date: 20150408
Version: 1.13
Requires: CBA A3
Compatibility: N/A

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_core.sqf
2 - Call it with 0 = [] execvm "tpw_core.sqf"; 

TPW MODS WILL NOT FUNCTION WITHOUT THIS SCRIPT RUNNING
*/

tpw_core_active = true;

// MAP SPECIFIC MOD DISABLING

//Maps without roads - no cars
if (worldname in  ["pja307"]) then
	{
	tpw_car_active = false;
	tpw_park_active = false;
	};

// No aircraft
if (worldname in ["mak_Jungle","isladuala"]) then
	{
	tpw_air_active = false;
	};

// GRAB CIVS FROM CONFIG
tpw_core_fnc_grabciv =
	{
	private ["_cfg","_str"];
	tpw_core_civs = [];
	_cfg = (configFile >> "CfgVehicles");
	_str = _this select 0;
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ( (_cfgName isKindOf "camanbase") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_str,str _cfgname] call BIS_fnc_inString}) then 
				{
				tpw_core_civs set [count tpw_core_civs,_cfgname];
				};
			};
		};

		// No pilot, diver, VR civs	
		for "_i" from 0 to (count tpw_core_civs - 1) do	
			{	
			_unit = tpw_core_civs select _i;
			if ((["pilot",str _unit] call BIS_fnc_inString)||(["diver",str _unit] call BIS_fnc_inString)||(["vr",str _unit] call BIS_fnc_inString)) then
				{
				tpw_core_civs set [_i, -1];
				};
			};
		tpw_core_civs = tpw_core_civs - [-1];			
	};

	

//CIVILIANS - REGION SPECIFIC CIVILIANS
tpw_core_fnc_civs =
	{
	private ["_civstring"];
	_civstring = "c_man";
	
	// Switch to region specific civs if CAF Aggressors active
	if (isclass (configfile/"CfgWeapons"/"H_caf_ag_turban")) then 
		{
		// MID EAST
		if (worldname in 
		[
		"MCN_Aliabad",
		"BMFayshkhabur",
		"clafghan",
		"fallujah",
		"fata",
		"hellskitchen",
		"hellskitchens",
		"MCN_HazarKot",
		"praa_av",
		"reshmaan",
		"Shapur_BAF",
		"Takistan",
		"torabora",
		"TUP_Qom",
		"Zargabad",
		"pja307",
		"pja306",
		"Mountains_ACR",
		"tunba",
		"Kunduz"
		]
		) then 
			{
			_civstring = "caf_ag_me_civ";
			};
		// TROPICAL
		if (worldname in 
		[
		"mak_Jungle",
		"pja305",
		"tropica",
		"tigeria",
		"tigeria_se",
		"Sara",
		"SaraLite",
		"Sara_dbe1",
		"Porto",
		"Intro"
		]
		) then 
			{
			_civstring = "caf_ag_afr_civ";
			};
		};

	// Switch to region specific civs if Leight's Opfor  active
	if (isclass (configfile >> "CfgVehicles" >> "LOP_AFR_CIV_01")) then 
		{
		// MID EAST
		if (worldname in 
		[
		"MCN_Aliabad",
		"BMFayshkhabur",
		"clafghan",
		"fallujah",
		"fata",
		"hellskitchen",
		"hellskitchens",
		"MCN_HazarKot",
		"praa_av",
		"reshmaan",
		"Shapur_BAF",
		"Takistan",
		"torabora",
		"TUP_Qom",
		"Zargabad",
		"pja307",
		"pja306",
		"Mountains_ACR",
		"tunba",
		"Kunduz"
		]
		) then 
			{
			_civstring = "lop_afg_civ";
			};
		// TROPICAL
		if (worldname in 
		[
		"mak_Jungle",
		"pja305",
		"tropica",
		"tigeria",
		"tigeria_se",
		"Sara",
		"SaraLite",
		"Sara_dbe1",
		"Porto",
		"Intro"
		]
		) then 
			{
			_civstring = "lop_afr_civ";
			};
		};		
		
		
	// Use RDS civs in European maps
	if (worldname in 
		[
		"Chernarus",
		"Chernarus_Summer",
		"FDF_Isle1_a",
		"mbg_celle2",
		"Woodland_ACR",
		"Bootcamp_ACR",
		"Thirsk",
		"ThirskW",
		"utes",
		"gsep_mosch",
		"gsep_zernovo",
		"Bornholm",
		"anim_helvantis_v2"
		]
	&& (isclass (configfile/"CfgVehicles"/"RDS_Assistant"))) then 
		{
		_civstring = "RDS";	
		};
	
	// Grab appropriate civs 
	[_civstring] call tpw_core_fnc_grabciv;
	
	// Screen out non-Greeks
	if (_civstring == "c_man") then
		{
		for "_i" from 0 to (count tpw_core_civs - 1) do	
			{	
			_civ = tpw_core_civs select _i;
			if ((["unarmed",str _civ] call BIS_fnc_inString) || (["asia",str _civ] call BIS_fnc_inString)||(["afro",str _civ] call BIS_fnc_inString)) then
				{
				tpw_core_civs set [_i, -1];
				};
			};
		tpw_core_civs = tpw_core_civs - [-1];	
		};
	
	// Prespawn to reduce stuttering later
		{
		_temp = _x createvehicle [0,0,1000]; 
		sleep 0.1;
		deletevehicle _temp;
		} foreach tpw_core_civs;
	};	

// HABITABLE HOUSES
tpw_core_habitable = [ // Habitable Greek houses with white walls, red roofs, intact doors and windows
"Land_i_House_Small_01_V1_F",
"Land_i_House_Small_01_V2_F",
"Land_i_House_Small_01_V3_F",
"Land_i_House_Small_02_V1_F",
"Land_i_House_Small_02_V2_F",
"Land_i_House_Small_02_V3_F",
"Land_i_House_Small_03_V1_F",
"Land_i_House_Big_01_V1_F",
"Land_i_House_Big_01_V2_F",
"Land_i_House_Big_01_V3_F",
"Land_i_House_Big_02_V1_F",
"Land_i_House_Big_02_V2_F",
"Land_i_House_Big_02_V3_F",

"Land_House_L_1_EP1", // OA classes - thanks Spliffz
"Land_House_L_3_EP1",
"Land_House_L_4_EP1",
"Land_House_L_6_EP1",
"Land_House_L_7_EP1",
"Land_House_L_8_EP1",
"Land_House_L_9_EP1",
"Land_House_K_1_EP1",
"Land_House_K_3_EP1", 
"Land_House_K_5_EP1", 
"Land_House_K_6_EP1", 
"Land_House_K_7_EP1", 
"Land_House_K_8_EP1", 
"Land_Terrace_K_1_EP1",
"Land_House_C_1_EP1",
"Land_House_C_1_v2_EP1", 
"Land_House_C_2_EP1", 
"Land_House_C_3_EP1",
"Land_House_C_4_EP1", 
"Land_House_C_5_EP1", 
"Land_House_C_5_V1_EP1", 
"Land_House_C_5_V2_EP1", 
"Land_House_C_5_V3_EP1", 
"Land_House_C_9_EP1", 
"Land_House_C_10_EP1", 
"Land_House_C_11_EP1", 
"Land_House_C_12_EP1", 
"Land_A_Villa_EP1",
"Land_A_Mosque_small_1_EP1",
"Land_A_Mosque_small_2_EP1",
//"Land_Ind_FuelStation_Feed_EP1",
"Land_Ind_FuelStation_Build_EP1",
"Land_Ind_FuelStation_Shed_EP1",
"Land_Ind_Garage01_EP1",

"Land_HouseV_1I1",  // A2 classes - thanks Reserve
"Land_HouseV_1I2",
"Land_HouseV_1I3",
"Land_HouseV_1I4",
"Land_HouseV_1L1",
"Land_HouseV_1L2",
"Land_HouseV_1T",
"Land_HouseV_2I",
"Land_HouseV_2L",
"Land_HouseV_2T1",
"Land_HouseV_2T2",
"Land_HouseV_3I1",
"Land_HouseV_3I2",
"Land_HouseV_3I3",
"Land_HouseV_3I4",
"Land_HouseV2_01A",
"Land_HouseV2_01B",
"Land_HouseV2_02",
"Land_HouseV2_03",
"Land_HouseV2_03B",
"Land_HouseV2_04",
"Land_HouseV2_05",
"Land_HouseBlock_A1",
"Land_HouseBlock_A2",
"Land_HouseBlock_A3",
"Land_HouseBlock_B1",
"Land_HouseBlock_B2",
"Land_HouseBlock_B3",
"Land_HouseBlock_C2",
"Land_HouseBlock_C3",
"Land_HouseBlock_C4",
"Land_HouseBlock_C5",
"Land_Church_02",
"Land_Church_02A",
"Land_Church_03",
//"Land_A_FuelStation_Feed",
"Land_A_FuelStation_Build",
"Land_A_FuelStation_Shed",

"Land_dum_istan2",// Fallujah
"Land_dum_istan2b",
"Land_dum_istan2_01",
"Land_dum_istan2_02",
"Land_dum_istan2_03",
"Land_dum_istan2_03a",
"Land_dum_istan2_04a",
"Land_dum_istan3",
"Land_dum_istan3_hromada",
"Land_dum_istan4",
"Land_dum_istan4_big",
"Land_dum_istan4_big_inverse",
"Land_dum_istan4_detaily1",
"Land_dum_istan4_inverse",
"Land_dum_mesto3_istan",
"Land_hotel",
"Land_stanek_1",
"Land_stanek_1b",
"Land_stanek_1c",
"Land_stanek_2",
"Land_stanek_2b",
"Land_stanek_2c",
"Land_stanek_3",
"Land_stanek_3b",
"Land_stanek_3c",

"Land_jbad_house1", // JBAD buildings
"Land_jbad_house3",
"Land_jbad_house5",
"Land_jbad_house6",
"Land_jbad_house7",
"Land_jbad_house8",
"Land_jbad_house1",
"Land_jbad_House_c_1_v2",
"Land_jbad_House_c_2",
"Land_jbad_House_c_3",
"Land_jbad_House_c_4",
"Land_jbad_House_c_5",
"Land_jbad_House_c_9",
"Land_jbad_House_c_10",
"Land_jbad_House_c_11",
"Land_jbad_House_c_12",
"Land_Jbad_Ind_FuelStation_Build",
"Land_jbad_A_GeneralStore_01",
"Land_jbad_A_GeneralStore_01a",
"Land_Jbad_A_Mosque_small_1",
"Land_Jbad_A_Mosque_small_2",
"Land_Jbad_A_Stationhouse",
"Land_Jbad_A_Villa",
"Land_Jbad_Ind_Garage01",
"Land_jbad_House_1_old",
"Land_jbad_House_3_old",
"Land_jbad_House_4_old",
"Land_jbad_House_6_old",
"Land_jbad_House_7_old",
"Land_jbad_House_8_old",
"Land_jbad_House_9_old"
];

tpw_core_fnc_houses =
	{
	private ["_radius","_housearray"];
	_housearray = [];
	if (tpw_core_housescanflag == 0) then
		{
		tpw_core_housescanflag = 1;
		_radius = _this select 0;
		_housearray = nearestObjects [position vehicle player,tpw_core_habitable,_radius]; 
		for "_i" from 0 to (count _housearray - 1) do
			{
			_house = _housearray select _i;
			_housestring = str (typeof _house);
			_uninhab = ["_u_house", _housestring] call BIS_fnc_inString; // uninhabited houses
			if (_uninhab) then 
				{
				_housearray set [_i, -1];
				};
			//sleep 0.05;	
			};
		_housearray = _housearray - [-1];
		tpw_core_housescanflag = 0;
		};
	tpw_core_houses = _housearray;
	};
	
// SUN ANGLE - ORIGINAL CODE BY CARLGUSTAFFA
tpw_core_fnc_sunangle =
	{
	private ["_lat","_day","_hour","_sunangle"];
	while {true} do 
		{
		_lat = -1 * getNumber(configFile >> "CfgWorlds" >> worldName >> "latitude");
		_day = 360 * (dateToNumber date);
		_hour = (daytime / 24) * 360;
		tpw_core_sunangle = ((12 * cos(_day) - 78) * cos(_lat) * cos(_hour)) - (24 * sin(_lat) * cos(_day));  
		sleep 30; 
		};
	};	
	
// DETERMINE UNIT'S WEAPON TYPE 
tpw_core_fnc_weptype =
	{
	private["_unit","_weptype","_cw","_hw","_pw","_sw"];
	_unit = _this select 0;	
	
	// Weapon type
	_cw = currentweapon _unit;
	_hw = handgunweapon _unit;
	_pw = primaryweapon _unit;
	_sw = secondaryweapon _unit;
	 switch _cw do
		{
		case "": 
			{
			_weptype = 0;
			};
		case _hw: 
			{
			_weptype = 1;
			};
		case _pw: 
			{
			_weptype = 2;
			};
		case _sw: 
			{
			_weptype = 3;
			};
		default
			{
			_weptype = 0;
			};	
		};
	_unit setvariable ["tpw_core_weptype",_weptype];
	};	
	
// CALL OR SPAWN APPROPRIATE FUNCTIONS
tpw_core_housescanflag = 0;
[] call tpw_core_fnc_civs;	
0 = [] spawn tpw_core_fnc_sunangle;	

// DUMMY LOOP SO SCRIPT DOESN'T TERMINATE
while {true} do
	{
	
	sleep 10;
	};	