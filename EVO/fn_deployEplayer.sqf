if (player distance spawnBuilding < 1000) exitWith {
	_msg = format ["You can't deploy a FARP in the base."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};


player playMove "Acts_carFixingWheel";
FARPRespawn call BIS_fnc_removeRespawnPosition;
{
	deleteVehicle _x;
} forEach playerStructures;
sleep 3.0;

WaitUntil {animationState player != "Acts_carFixingWheel"};

_mark = format["%1FARP",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), "Comps\farp.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
FARPRespawn = [(side player), getPos player] spawn BIS_fnc_addRespawnPosition;
_mssg = format["%1's FARP",(name player)];
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your FARP has been deployed at map grid %1.", mapGridPosition player];
["deployed",["FARP DEPLOYED", _msg]] call BIS_fnc_showNotification;