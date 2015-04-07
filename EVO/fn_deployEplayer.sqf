_truck = objNull;
_truck = (nearestObject [vehicle player, "B_Truck_01_Repair_F"]);

if(isNull _truck) exitWith
	{
	_msg = format ["There is no repair truck nearby."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

if (player in list AirportIn) exitWith {
	_msg = format ["You can't deploy a FARP in the base."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

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
_respawnPos = [(side player), etent] spawn BIS_fnc_addRespawnPosition;
_mssg = format["%1's FARP",(name player)];
_medmark = createMarker [_mark, _pos];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_service";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your FARP has been deployed at map grid %1.", mapGridPosition etent];
["deployed",["FARP DEPLOYED", _msg]] call BIS_fnc_showNotification;