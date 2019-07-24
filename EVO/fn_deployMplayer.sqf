private ["_pos","_msg","_mark","_mssg","_medmark","_crate"];
_pos = getPos player;
// Check for nearby enemies
_enemyArray = (getPos player) nearEntities [["Man"], 15];
{
	if (side _x == EAST) then {
		exitWith {
			_msg = format ["You can't deploy a MASH near hostiles."];
			["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
		};
} forEach _enemyArray;
player playMoveNow "Acts_carFixingWheel";

if (!isNil "MASH") then {
	{
		deleteVehicle _x;
	} forEach playerStructures;
	deleteVehicle MASH;
	_msg = format ["Your previous MASH has been removed."];
	["deployed",["MASH REMOVED", _msg]] call BIS_fnc_showNotification;
};

if (!isNil "playerRespawnPoint") then {
	playerRespawnPoint call BIS_fnc_removeRespawnPosition;
};



WaitUntil {animationState player != "Acts_carFixingWheel"};
if (!alive player || player distance _pos > 1) exitWith {};


[[_pos, 25],"EVO_fnc_healMen"] call BIS_fnc_MP;

_mark = format["%1mash",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), call (compile (preprocessFileLineNumbers ("Comps\mash.sqf")))] call BIS_fnc_ObjectsMapper;
_mssg = format["%2 %1's MASH",(name player), (rank player)];
playerRespawnPoint = [(side player), (getPos player), _mssg] call BIS_fnc_addRespawnPosition;
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
sleep 5;
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition player];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;