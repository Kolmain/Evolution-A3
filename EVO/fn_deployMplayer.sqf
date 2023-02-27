_truck = nearestObject [player, "B_Truck_01_medical_F"];
if (isNil "_truck" || (player distance _truck > 25)) exitWith {
	_msg = format ["You can't deploy a MASH without an ambulance."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

_enemyArray = (getPos player) nearEntities [["Man"], 15];
{
	if (side _x == EAST) exitWith {
			_msg = format ["You can't deploy a MASH near hostiles."];
			["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
		};
} forEach _enemyArray;
player playMoveNow "Acts_carFixingWheel";

if (!isNil "MASH") then {
	deleteVehicle MASH;
	_msg = format ["Your previous MASH has been removed."];
	["deployed",["MASH REMOVED", _msg]] call BIS_fnc_showNotification;
};

if (!isNil "playerRespawnPoint") then {
	playerRespawnPoint call BIS_fnc_removeRespawnPosition;
};

_mark = format["%1mash",(name player)];
deleteMarker _mark;
_pos = [position player, 10, 15, 10, 0, 2, 0] call BIS_fnc_findSafePos;
MASH = "USMC_WarfareBFieldhHospital" createVehicle _pos;
MASH allowDamage false;
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