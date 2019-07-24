_truck = nearestObject [player, "CUP_B_MTVR_REPAIR_USMC"];
if (isNil "_truck" || (player distance _truck > 25)) exitWith {
	_msg = format ["You can't deploy a FARP without a Repair Truck."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

// Check for nearby enemies
_enemyArray = (getPos player) nearEntities [["Man"], 15];
{
	if (side _x == EAST) then {
		exitWith {
			_msg = format ["You can't deploy a FARP near hostiles."];
			["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
		};
} forEach _enemyArray;


_pos = getPos player;

_h = nearestObject [_pos, "Camp_EP1"];
[[_h],{
	_h = _this select 0;
	if (isServer) then
	{
		_nearVehicles = [];
		while {alive _h} do
		{
			{
				_x call EVO_fnc_rearm;
			}
			forEach ((getPos _h) nearEntities [["Car", "Tank", "Helicopter"], 10]);
			sleep 2;
		};
	};
},"BIS_fnc_spawn"] call BIS_fnc_MP;


_pos = getPos player;
player playMoveNow "Acts_carFixingWheel";

if (!isNil "MASH") then {
	{
		deleteVehicle _x;
	} forEach playerStructures;
	_msg = format ["Your previous FARP has been removed."];
	["deployed",["FARP REMOVED", _msg]] call BIS_fnc_showNotification;
};

if (!isNil "playerRespawnPoint") then {
	playerRespawnPoint call BIS_fnc_removeRespawnPosition;
};



WaitUntil {animationState player != "Acts_carFixingWheel"};
if (!alive player || player distance _pos > 1) exitWith {};


_mark = format["%1mash",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), call (compile (preprocessFileLineNumbers ("Comps\mash.sqf")))] call BIS_fnc_ObjectsMapper;
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