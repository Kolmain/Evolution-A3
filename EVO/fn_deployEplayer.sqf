_truck = objNull;
_truck = (nearestObject [vehicle player, "B_Truck_01_Repair_F"]);
if(isNull _truck) exitWith {	_msg = format ["There is no repair truck nearby."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;};

if (player in list AirportIn) exitWith {
	_msg = format ["You can't deploy a FARP in the base."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;};
deletevehicle etent;
deletevehicle epad;
deletevehicle ebox;
_mark = format["%1farp",(name player)];
deleteMarker _mark;

player playMove "Acts_carFixingWheel";
sleep 3.0;
WaitUntil {animationState player != "Acts_carFixingWheel"};

epad = "Land_HelipadSquare_F" createVehicle (position player);
_pos = position epad;

_pos2 = [_pos select 0,(_pos select 1) - 18,_pos select 2];
etent = "Land_BagBunker_Tower_F" createVehicle _pos2;
_pos3 = [_pos2 select 0,(_pos2 select 1)+3,_pos2 select 2];
ebox = "Box_Ammo_F" createVehicle _pos3;
_respawnPos = [(side player), etent] spawn BIS_fnc_addRespawnPosition;
/*
ebox addWeaponCargo ["Laserdesignator",40];
ebox addMagazineCargo ["HandGrenadeTimed",40];
ebox addMagazineCargo ["m136",40];
ebox addMagazineCargo ["Stinger",40];
ebox addMagazineCargo ["JAVELIN",40];
ebox addMagazineCargo ["1rnd_HE_M203",40];
ebox addMagazineCargo ["FlareWhite_M203",40];
ebox addMagazineCargo ["FlareRed_M203",40];
ebox addMagazineCargo ["FlareGreen_M203",40];
ebox addMagazineCargo ["FlareYellow_M203",40];
ebox addMagazineCargo ["SmokeShell",40];
ebox addMagazineCargo ["SmokeShellRed",40];
ebox addMagazineCargo ["SmokeShellGreen",40];
ebox addmagazinecargo ["15rnd_9x19_m9sd", 40];
ebox addmagazinecargo ["15rnd_9x19_m9", 40];
ebox addmagazinecargo ["30Rnd_9x19_MP5SD", 40];
ebox addmagazinecargo ["30Rnd_9x19_MP5", 40];
ebox addmagazinecargo ["30Rnd_556x45_StanagSD", 40];
ebox addmagazinecargo ["30rnd_556x45_Stanag", 40];
ebox addmagazinecargo ["30Rnd_556x45_G36",40];
ebox addmagazinecargo ["200Rnd_556x45_M249", 40];
ebox addmagazinecargo ["100Rnd_762x51_M240", 40];
ebox addmagazinecargo ["5Rnd_762x51_M24", 40];
ebox addmagazinecargo ["10Rnd_127x99_m107", 40];
ebox addMagazineCargo ["Laserbatteries",40];
ebox addWeaponCargo ["Binocular",40];
ebox addWeaponCargo ["NVGoggles",40];
*/

_mssg = format["%1's FARP",(name player)];
_medmark = createMarker [_mark, _pos];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_service";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your FARP has been deployed at map grid %1.", mapGridPosition etent];
["deployed",["FARP DEPLOYED", _msg]] call BIS_fnc_showNotification;