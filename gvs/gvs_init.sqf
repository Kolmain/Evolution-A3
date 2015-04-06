/*=================================================================================================================
  GVS Init by Jacmac

  Version History:
  A - Initial Release 10/13/2013
  B - Added public function for turret reloading 3/14/2014

  Requirements:
  Execute from your mission's init.sqf:
  execVM "gvs\gvs_init.sqf";
  
  Features:
  -Initializes GVS

=================================================================================================================*/

#include "colors_include.hpp"

call compile preProcessFile "gvs\cfg_lookup.sqf";
call compile preProcessFile "gvs\simple_text_control.sqf";
call compile preprocessFile "gvs\sounds.sqf";

execVM "gvs\gvs_triggers.sqf";
if (isNil "Public_Banned_Vehicle_Service_List") then {Public_Banned_Vehicle_Service_List = []};
if (isNil "Public_GVS_Delay") then {Public_GVS_Delay = 500};

if (isServer) then {execVM "gvs\gvs_watcher.sqf"};

GVS_Path = str missionConfigFile; 
GVS_Path = [GVS_Path, 0, -15] call BIS_fnc_trimString;
GVS_Path = GVS_Path + "gvs\";

VEHICLE_TURRET_RELOAD = [];
"VEHICLE_TURRET_RELOAD" addPublicVariableEventHandler 
{
	_oVehicle = _this select 1 select 0;
	_turretPlayer = _this select 1 select 1;	
	if (_turretPlayer == player) then {_oVehicle setVehicleAmmo 1}
};

