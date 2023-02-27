_truck = nearestObject [player, "B_Truck_01_Repair_F"];
if (isNil "_truck" || (player distance _truck > 25)) exitWith {
	_msg = format ["You can't deploy a FARP without a Repair Truck."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

_enemyArray = (getPos player) nearEntities [["Man"], 15];
{
	if (side _x == EAST) exitWith {
			_msg = format ["You can't deploy a FARP near hostiles."];
			["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
		};
} forEach _enemyArray;

if (!isNil "MASH") then {
	deleteVehicle MASH;
	_msg = format ["Your previous FARP has been removed."];
	["deployed",["FARP REMOVED", _msg]] call BIS_fnc_showNotification;
};

if (!isNil "MASH") then {
	playerRespawnPoint call BIS_fnc_removeRespawnPosition;
};

_pos = [position player, 5, 15, 10, 0, 2, 0] call BIS_fnc_findSafePos;
MASH = "USMC_WarfareBBarracks" createVehicle _pos;
MASH allowDamage false;
EVO_vaCrates pushBack MASH;
publicVariable "EVO_vaCrates";
{
    [_x, rank player] call EVO_fnc_buildAmmoCrate;
} forEach EVO_vaCrates;
player playMoveNow "Acts_carFixingWheel";

_mark = format["%1mash",(name player)];
deleteMarker _mark;

_mssg = format["%2 %1's FARP",(name player), (rank player)];
playerRespawnPoint = [(side player), (getPos player), _mssg] call BIS_fnc_addRespawnPosition;
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_maint";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
sleep 5;
_msg = format ["Your FARP has been deployed at map grid %1.", mapGridPosition player];
["deployed",["FARP DEPLOYED", _msg]] call BIS_fnc_showNotification;