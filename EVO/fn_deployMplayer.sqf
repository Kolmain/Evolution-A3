if (player distance spawnBuilding < 1000) exitWith {
	_msg = format ["You can't deploy a MASH in the base."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};
_truck = nearestObject [player, "B_Truck_01_medical_F"];
if (isNil "_truck" || (player distance _truck > 25)) exitWith {
	_msg = format ["You can't deploy a MASH without a HEMTT Medical Truck."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

player playMove "Acts_carFixingWheel";
mashRespawn call BIS_fnc_removeRespawnPosition;
{
	deleteVehicle _x;
} forEach playerStructures;
sleep 3.0;

WaitUntil {animationState player != "Acts_carFixingWheel"};

_mark = format["%1mash",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), "Comps\mash.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
mashRespawn = [(side player), getPos player] spawn BIS_fnc_addRespawnPosition;
_mssg = format["%1's MASH",(name player)];
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition player];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;
