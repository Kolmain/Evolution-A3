_pos = getPos player;

//Land_Medevac_house_V1_F

player playMove "Acts_carFixingWheel";

if (!isNil "playerStructures") then {
	{
		deleteVehicle _x;
	} forEach playerStructures;
	_msg = format ["Your previous MASH has been removed."];
	["deployed",["MASH REMOVED", _msg]] call BIS_fnc_showNotification;
};

if (!isNil "playerRespawnPoint") then {
	playerRespawnPoint call BIS_fnc_removeRespawnPosition;
};



WaitUntil {animationState player != "Acts_carFixingWheel"};
if (!alive player || player distance _pos > 1) exitWith {};


[[_pos, _radius],"EVO_fnc_healNearMen",false] call BIS_fnc_MP;  

_mark = format["%1mash",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), "Comps\mash.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
playerRespawnPoint = [(group player), (getPos player)] call BIS_fnc_addRespawnPosition;
_mssg = format["%1's MASH",(name player)];
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition player];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;
