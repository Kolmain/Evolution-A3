/*=================================================================================================================
  Generic Vehicle Service by Jacmac

  Version History:
  A - Initial Release 3/22/2013
  B - Updated documentation, no script alterations 3/26/2013
  C - Revised trigger reuse handling, now server controlled 4/21/2013
  D - Major revisions to how GVS works; triggers, sounds, in vehicle signs, & on screen display changes 10/13/2013
  E - Updated gvs_triggers.sqf due to createTriggers and isServer being a fail 10/13/2013
  F - Updated gvs_triggers.sqf with UAV support, mods to generic_vehicle_Service.sqf for UAV detection 10/19/2013
  G - Added crazy work-around for the turret reloading problem until the developers fix the ARMA bug, quieted loop sounds 3/14/2014

  Features:
  -Rearms, Repairs, and Refuels Land, Helecopter, Plane, or UAV as desired
  -Wait times are adjustable and refuel/repair occurs only as needed,
    for example 50% repair is 5x longer than 10% repair. That could be
    50 seconds vs 10 seconds or 5 minutes vs 1 minute.
  -Uses display names where possible rather than type names in messages to players.
  -Use this with a marker placed on the map (see below).
  -Displays live activity in a dialog control rather than messages
    going out through vehicle chat.
  -Diaplay control is now based on layers, so interference with other scripts/mods using RscTitles 
  	should be eliminated, however see below for more information.
  -gvs_watcher disallows a vehicle from re-using any service point for a 
  	specified period.
  -Triggers on player being the driver of the vehicle, but the player 
  	does not need to remain	in the vehicle while it is being serviced.
  -Introducing 3D sounds into this version
  -Greatly simplified the method of trigger creation using markers, it is more or less automatic
   	now instead of a manual process

  Requirements:
  gvs_init.sqf									GVS initialization
  gvs_triggers.sqf								Generates triggers from markers
  gvs_watcher.sqf                       		Delays use (reuse) of service points
  sounds.sqf									Sound utility functions
  cfg_lookup.sqf                        		Utility functions
  simple_text_control.sqf               		Display/Dialog control for structured text
  colors_include.hpp                    		Color definitions
  control_include.hpp							Standard control includes
  stc_include.hpp								Simple text display control definitions
  Misc sound files (.ogg files included)
  
  Add the following into your mission's description.ext:
  #include "gvs\colors_include.hpp"
  #include "gvs\control_include.hpp"
  #include "gvs\stc_include.hpp"
  
  Add the following into your mission's init.sqf:
  execVM "gvs\gvs_init.sqf";

  To use GVS:
  	0. Copy the gvs directory into your mission folder.
    1. Create marker(s) on the map.
    2. Name the marker(s) gvs_veh_x, gvs_hel_x, gvs_uav_x and/or gvs_pla_x where x = some number (e.g. gvs_hel_0 is a helecopter service point).
    3. Uniquely name vehicles as desired.
    4. Run the mission

  Display Information:
  GVS uses RscTitles for the information display. It is very possible that missions you try to integrate GVS into will also
  use RscTitles. By default layer 301 is used for GVS, you can change it if you happen to be using 301 already, numbers in 
  the tens of thousands have been tested successfully. I you intergrate GVS into a mission that is alreading utilizing RscTitles,
  for example "Domination", you will have to integrate the display class definitions. For example, in the Domaination description.ext
  consider the following code:
  
  class RscTitles {
	#include "x_dlg\RscTitles.hpp"
	#include "gvs\stc_include_alt.hpp" //Alterntive display class definitions
	};
  
  The display location and background color can be changed by altering the _display_Settings variable
  Text colors can also be altered by changing the constants through out the code prefixed with 'RGB'
  Colors can be found in colors_include.hpp

  Additional Notes:
  REQUIREMENT: Your vehicles must be uniquely named. GVS uses the names of vehicles to control re-use of a GVS trigger.
  This means if you put 10 Hunters on the map all named "BigHunter1", the first one to use a GVS will lock all of the others out
  until the re-use timer expires for "BigHunter1". For script spawned vehicles you will need to implement something like this if
  you want them to be able to use a GVS trigger:
  
  Example 1:
  	_kh60_Pos = [3962,4618];
  	_veh = "O_Ka60_F" createVehicle _kh60_Pos;
	_varName="ka60_1";							// <----This must be unique per vehicle
	_veh SetVehicleVarName _varName;
	_veh Call Compile Format ["%1=_this ; PublicVariable ""%1""",_varName];
	
  Example 2:
	_xloc = (floor ((random 100) + 3950));
	_yloc = (floor ((random 50) + 4550));
	_veh = "B_Quadbike_F" createVehicle [_xloc,_yloc];
	Global_QUAD = Global_QUAD + 1;
	_varName=("Quadbike_" + (str Global_QUAD)); // <----This must be unique per vehicle
	_veh SetVehicleVarName _varName;
	_veh Call Compile Format ["%1=_this ; PublicVariable ""%1""",_varName];
  
  Long term re-use of a trigger is controlled per vehicle instead of per player, this is a major change from the previous version.
  Each trigger you set up with GVS needs a public variable associated with it and these need to be initialized in init.sqf.
  The public variables prevent the GVS trigger from being immediately used by anyone or any vehicle on the server, while
  it is currently in use. This prevents scenarios where one player triggers GVS, then get out of a vehicle and another
  player gets in the same vehicle and causes a second triggering of the GVS (this was seen to cause problems).
  
  The default time for re-using a trigger has been changed to 200 seconds in gvs_watcher.sqf. A player can possibly trigger
  two or more vehicles to use various GVS triggers for different vehicle if they are all in close proximity, this can mean
  that the display of the information will get a little wonky, but everything will function normally as far as the vehicles
  rearming and repairing.

=================================================================================================================*/

#include "colors_include.hpp"
scopeName "main";

private [   "_vehicleTurretCount",    //Count of turrets on vehicle
            "_vehicleMagazines",        //Array of vehicle magazine names
            "_vehicleMagazinesCount",   //Count of vehicle magazines
            "_turretMagazines",         //Array of turret magazine names
            "_turretMags",				//Array of turret magazine configs
            "_turretMagazinesCount",    //Count of turret magazines
            "_vehicleName",             //Display name of vehicle
            "_oVehicle",                //Vehicle object passed to this script (required)
            "_triggerPos",              //Position of trigger passed to this script (required)
            "_maxDistance",             //Distance from trigger where the script will abort
            "_maxHeight",				//Height above trigger where the script will abort
            "_per_fuel_time",           //Time vehicle must wait per each percentage of fuel
            "_per_repair_time",         //Time vehicle must wait per each percentage of repair
            "_per_magazine_time",       //Time vehicle must wait per magazine for reloading
            "_vehicleType",             //Vehicle type, used for lookups
            "_display_Settings",        //Array containing display control information
            "_triggerVariable", 		//Variable holding the name of a public trigger control variable
            "_vName"					//Vehicle actual name
            ];

sleep 0.5;
_triggerVariable = _this select 0;
_list = [];
_list = _this select 1;
_oVehicle = _list select 0;
_triggerPos = _this select 2;
_maxDistance = if (count _this > 3) then { _this select 3 } else { 6 };
_maxHeight = if (count _this > 4) then { _this select 4 } else { 4 };
_serviceStartDelay = if (count _this > 5) then { _this select 5 } else { 10 };
_per_fuel_time = if (count _this > 6) then { _this select 6 } else { 2 };
_per_repair_time = if (count _this > 7) then { _this select 7 } else { 6 };
_per_magazine_time = if (count _this > 8) then { _this select 8 } else { 8 };

//diag_log format ["vehicle = %1, player = %2", str (vehicle player), str player];
//       [(format ["vehicle = %1, player = %2", str (vehicle player), str player]), "cba_network", [true, false, true]] call CBA_fnc_debug;

{
	if ((player == (driver _x)) or (([str ((uavControl _x) select 0), str player] call String_Search) != -1)) then {_oVehicle = _x};
}forEach _list;
_oVehicleDriver = driver _oVehicle;
if ((([str ((uavControl _oVehicle) select 0), str player] call String_Search) != -1) and (_oVehicle isKindOf "UAV")) then {_oVehicleDriver = player};
_vName = vehicleVarName _oVehicle;
_gtfo = 0;
{
	if (_vName == _x) then {_gtfo = 1};
}forEach Public_Banned_Vehicle_Service_List;
_currentDist = (getPos _oVehicle) distance _triggerPos;
_distanceToExit = str (_maxDistance - _currentDist);
if (_gtfo == 1 or (str _list) == "[]" or _currentDist > _maxDistance or (getPos _oVehicle select 2) > _maxHeight or (str _oVehicle) == "any") exitWith 
{
	sleep 1;
	call compile format ["%1 = 0", _triggerVariable]; 
	call compile format ["publicVariable '%1'", _triggerVariable];	
};

func_GetTurretMagazines =
{
    private ["_config","_magazines","_magcount","_magnames","_mag","_turretnumber","_vtype"];
    _vtype = _this select 0;
    _turretnumber = if (count _this > 1) then {_this select 1} else {0};
    _config = (configFile >> "CfgVehicles" >> _vtype >> "Turrets") select _turretnumber;
    _magazines = getArray(_config >> "magazines");
    _magcount = count _magazines;
    _magnames = [];
    _mag = 0;
    {
        _magnames = _magnames + [(_magazines select _mag) call Cfg_Lookup_Magazine_GetName];
        _mag = _mag + 1;
    } forEach _magazines;
    [_magcount,_magnames,_magazines]
};

func_GetVehicleMagazines =
{
    private ["_magazines","_magcount","_magnames","_mag","_vtype"];
    _vtype = _this;
    _magazines = _vtype call Cfg_Lookup_Vehicle_GetMagazines;
    _magcount = count _magazines;
    _magnames = [];
    _mag = 0;
    {
    	_possible_mag = (_magazines select _mag) call Cfg_Lookup_Magazine_GetName;
    	//_possible_mag = _x call Cfg_Lookup_Magazine_GetName;
    	if (_possible_mag != "") then
    	{
        	_magnames = _magnames + [_possible_mag];
        	_mag = _mag + 1;
    	} else
    	{
    		_magnames = _magnames + [(_magazines select _mag)];
        	_mag = _mag + 1;
    	};
    } forEach _magazines;
    [_magcount,_magnames]
};

func_GenActionMsg =
{
    private ["_action","_genmsg"];
    _action = _this select 0;
    _genmsg = "<br />";
    _genmsg = _genmsg + ([_vehicleName,RGB_GOLDENROD] call stc_Title);
    _genmsg = _genmsg + ([_action,RGB_TAN] call stc_Title);
    _genmsg = _genmsg + (["    Repair Needed: ",RGB_LIGHTSTEELBLUE] call stc_PartLeft);
    _genmsg = _genmsg + ([(str _damageToRepair) + "%",RGB_LIMEGREEN] call stc_LineLeft);
    _genmsg = _genmsg + (["      Fuel Needed: ",RGB_LIGHTSTEELBLUE] call stc_PartLeft);
    _genmsg = _genmsg + ([(str _gasToFill) + "%",RGB_LIMEGREEN] call stc_LineLeft);
    if (_vehicleMagazinesCount > 0 ) then
    {
        _genmsg = _genmsg + ([" Vehicle Magazines: ",RGB_LIGHTSTEELBLUE] call stc_PartLeft);
        _genmsg = _genmsg + ([_vehicleMagazinesCount,RGB_LIMEGREEN] call stc_LineLeft);
        {
            _genmsg = _genmsg + ([_x ,RGB_RED] call stc_LineCenter);
        } forEach _vehicleMagazines;
    };
    if (_turretMagazinesCount > 0 ) then
    {
        _genmsg = _genmsg + ([" Turret Magazines: ",RGB_LIGHTSTEELBLUE] call stc_PartLeft);
        _genmsg = _genmsg + ([_turretMagazinesCount,RGB_LIMEGREEN] call stc_LineLeft);
        {
            _genmsg = _genmsg + ([_x ,RGB_RED] call stc_LineCenter);
        } forEach _turretMagazines;
    };
    _genmsg = _genmsg + (["Total Service Completion ETA: ",RGB_LIGHTSTEELBLUE] call stc_PartLeft);
    _genmsg = _genmsg + ([(str _serviceEta) + " Seconds",RGB_LIMEGREEN] call stc_LineLeft);
    _genmsg
};

func_Abort =
{
    _abort = 1;
    _msg = "<br />";
    _msg = _msg + ([_vehicleName,RGB_GOLDENROD] call stc_Title);
    _msg = _msg + (["Service Point Exited",RGB_KHAKI] call stc_Title);
    _msg = _msg + "<br />";
    _msg = _msg + (["Servicing Aborted...",RGB_RED] call stc_Title);
    [_display_Classname, _display_ControlID, _msg] call stc_DisplayWrite;
    sleep 1;
    call compile format ["%1 = 0", _triggerVariable]; 
	call compile format ["publicVariable '%1'", _triggerVariable];
    [_display_Layer] call stc_DisplayHide;
    sleep 0.1;
};

_abort = 0;
//_oVehicle setDamage 0.02; //for testing
//_oVehicle setFuel 0.8;    //for testing
_gasToFill = round (abs (fuel _oVehicle - 1) * 100);
_damageToRepair = round ((damage _oVehicle) * 100);

_vehicleType = typeOf _oVehicle;
_vehicleName = _vehicleType call Cfg_Lookup_Vehicle_GetName;
_vehicleTurretCount = _vehicleType call Cfg_Lookup_Vehicle_GetTurretCount;
//_vehicleTurrets = _vehicleType call call Cfg_Lookup_Vehicle_GetTurrets;
if (_vehicleTurretCount > 0) then
{
	_returnArray = [_vehicleType] call func_GetTurretMagazines;
	_turretMagazinesCount = _returnArray select 0;
	_turretMagazines = _returnArray select 1;
	_turretMags = _returnArray select 2;
} else
{
	_turretMagazinesCount = 0;
	_turretMagazines = [];
};

_returnArray = _vehicleType call func_GetVehicleMagazines;
_vehicleMagazinesCount = _returnArray select 0;
_vehicleMagazines = _returnArray select 1;

_serviceEta =   (_turretMagazinesCount * _per_magazine_time) +
                (_vehicleMagazinesCount * _per_magazine_time) +
                (_gasToFill * _per_fuel_time) +
                (_damageToRepair * _per_repair_time);

_display_Classname = "UC_ShowText_small";
_display_ControlID = 301;
_display_Layer = 301;
_totalMags = _vehicleMagazinesCount + _turretMagazinesCount;
_heightMod = 0.3 + (_totalMags * 0.02);
if (_heightMod > 0.8) then {_heightMod = 0.8};
_display_Settings = [_display_Layer,_display_Classname,_display_ControlID,ARRAY_PART_DIRT,safeZoneX + 0.33,safeZoneY + 0.05,_heightMod,0.4];

call disableSerialization;
_display_Settings call stc_DisplayShow;

["ServiceEnter.ogg", _oVehicle, 30] spawn Sound_Once3D;
_staticmsg = ["Service Point Entered"] call func_GenActionMsg;
_staticmsg = _staticmsg + "<br />";
_staticmsg = _staticmsg + (["Service will start in: ",RGB_LIGHTSTEELBLUE] call stc_PartLeft);

while { _serviceStartDelay > 0 } do
{
    _startDelay = str (round (_serviceStartDelay)) + " Seconds";
    _currentDist = (getPos _oVehicle) distance _triggerPos;
    _distanceToExit = str (_maxDistance - _currentDist);
    _dynamicmsg = [_startDelay,RGB_LIMEGREEN] call stc_LineCenter;
    if (_currentDist > _maxDistance or (getPos _oVehicle select 2) > _maxHeight) then
    {
        call func_Abort;
        breakTo "main";
    };
    _msg = _staticmsg + _dynamicmsg;
    [_display_Classname, _display_ControlID, _msg] call stc_DisplayWrite;
    sleep 0.1;
    _serviceStartDelay = _serviceStartDelay - 0.1;
};

if (_abort == 0) then
{
    _oVehicle setFuel 0;
    if (_damageToRepair > 0) then
    {
    	["Repair.ogg", 6, 0.05, (_damageToRepair * _per_repair_time), _oVehicle, 15, 0.5, 40, true] spawn Sound_Loop3D;
        _staticmsg = ["Repairing Damage"] call func_GenActionMsg;
        _staticmsg = _staticmsg + "<br />";
        _staticmsg = _staticmsg + (["Repairing: ",RGB_SKYBLUE] call stc_PartLeft);
        for "_crunch" from 1 to _damageToRepair do
        {
            _damagetofix = str (100 - _damageToRepair + _crunch) + "%";
            _dynamicmsg = [_damagetofix,RGB_LIMEGREEN] call stc_LineLeft;
            _msg = _staticmsg + _dynamicmsg;
            [_display_Classname, _display_ControlID, _msg] call stc_DisplayWrite;
            sleep _per_repair_time;
        };
        _serviceEta = _serviceEta - _damageToRepair * _per_repair_time;
        _damageToRepair = 0;
        _oVehicle setDamage 0;
    };
    if (_gasToFill > 0) then
    {
    	["fuel.ogg", 2, 0.1, (_gasToFill * _per_fuel_time), _oVehicle, 10, 1.0, 20, false] spawn Sound_Loop3D;
        _staticmsg = ["Adding Fuel"] call func_GenActionMsg;
        _staticmsg = _staticmsg + "<br />";
        _staticmsg = _staticmsg + (["Fuelling: ",RGB_SKYBLUE] call stc_PartLeft);
        for "_gas" from 1 to _gasToFill do
        {
            _gastoadd = str (100 - _gasToFill + _gas) + "%";
            _dynamicmsg = [_gastoadd,RGB_LIMEGREEN] call stc_LineLeft;
            _msg = _staticmsg + _dynamicmsg;
            [_display_Classname, _display_ControlID, _msg] call stc_DisplayWrite;
            sleep _per_fuel_time;
        };
        _serviceEta = _serviceEta - _gasToFill * _per_fuel_time;
        _gasToFill = 0
    };
    if (_vehicleMagazinesCount > 0 ) then
    {
        _mag = 0;
        {
        	["reload.ogg", 8, 0.02, _per_magazine_time, _oVehicle, 10, 0.5, 25, true] spawn Sound_Loop3D;
            _msg = ["Reloading Vehicle Magazines"] call func_GenActionMsg;
            _msg = _msg + "<br />";
            _msg = _msg + (["Reloading: ",RGB_SKYBLUE] call stc_PartLeft);
            _msg = _msg + ([_x,RGB_RED] call stc_LineLeft);
            _vehicleMagazines set [_mag, " "];
            _serviceEta = _serviceEta - _per_magazine_time;
            _vehicleMagazinesCount = _vehicleMagazinesCount - 1;
            _mag = _mag + 1;
            [_display_Classname, _display_ControlID, _msg] call stc_DisplayWrite;
            sleep _per_magazine_time;
        } forEach _vehicleMagazines;
    };
    if (_turretMagazinesCount > 0 ) then
    {
        _mag = 0;
        {
        	["reload.ogg", 8, 0.02, _per_magazine_time, _oVehicle, 10, 0.5, 25, true] spawn Sound_Loop3D;
            _msg = ["Reloading Turret Magazines"] call func_GenActionMsg;
            _msg = _msg + "<br />";
            _msg = _msg + (["Reloading:",RGB_SKYBLUE] call stc_PartLeft);
            _msg = _msg + ([_x,RGB_RED] call stc_LineLeft);
            _turretMagazines set [_mag, " "];
            _oVehicle addMagazine _turretMags select _mag;
            _serviceEta = _serviceEta - _per_magazine_time;
            _turretMagazinesCount = _turretMagazinesCount - 1;
            _mag = _mag + 1;
            [_display_Classname, _display_ControlID, _msg] call stc_DisplayWrite;
            sleep _per_magazine_time;
        } forEach _turretMagazines;
        
        //nasty work around to current reloading turrets bug in ARMA
        _gunner = false;
        {
        	if (gunner _oVehicle == _x) then
        	{
        		_gunner = true;
        		VEHICLE_TURRET_RELOAD = [_oVehicle,_x];
        		publicVariable "VEHICLE_TURRET_RELOAD";
        	};
    	}forEach playableUnits;
    	if (!_gunner) then
   		{
   			player action ["moveToGunner", _oVehicle];
   			sleep 0.1;
   			_oVehicle setVehicleAmmo 1;
   			sleep 0.1;
   			player action ["moveToDriver", _oVehicle];
   		};

    };
    [Public_Banned_Vehicle_Service_List, _vName] call BIS_fnc_arrayPush;
    publicVariable "Public_Banned_Vehicle_Service_List";
    sleep 0.1;
    _msg = "<br />";
    _msg = _msg + ([_vehicleName,RGB_GOLDENROD] call stc_Title);
    _msg = _msg + "<br />";
    _msg = _msg + (["Servicing Completed!",RGB_LIMEGREEN] call stc_Title);
    _msg = _msg + "<br />";
    _msg = _msg + (["All Service Points Are Now Unavailable To This Vehicle For:", RGB_KHAKI] call stc_Title);
    _msg = _msg + ([(str Public_GVS_Delay) + " Seconds",RGB_RED] call stc_Title);
    [_display_Classname, _display_ControlID, _msg] call stc_DisplayWrite;  
    _oVehicle setFuel 1;
    _oVehicle setVehicleAmmo 1;
    ["ServiceExit.ogg", _oVehicle, 30] spawn Sound_Once3D;
    sleep 10;
    call compile format ["%1 = 0", _triggerVariable]; 
	call compile format ["publicVariable '%1'", _triggerVariable];
    [_display_Layer] call stc_DisplayHide;
    sleep 0.1;
};