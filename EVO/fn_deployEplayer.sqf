
_truck = nearestObject [player, "B_Truck_01_Repair_F"];
if (isNil "_truck" || (player distance _truck > 25)) exitWith {
	_msg = format ["You can't deploy a FARP without a Repair Truck."];
	["deployed",["FARP NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

_pos = getPos player;

_h = nearestObject [_pos, "Land_HelipadSquare_F"];
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
			forEach ((getPos _h) nearEntities [["Car", "Tank", "Helicopter"], 2]);
			sleep 2;
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;



player playMove "Acts_carFixingWheel";
if (!isNil "playerStructures") then {
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
_mark = format["%1FARP",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), "Comps\farp.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
_mssg = format["%1's FARP",(name player)];
playerRespawnPoint = [(group player), (getPos player), _mssg] call BIS_fnc_addRespawnPosition;
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
sleep 5;
_msg = format ["Your FARP has been deployed at map grid %1.", mapGridPosition player];
["deployed",["FARP DEPLOYED", _msg]] call BIS_fnc_showNotification;
_crate = nearestObject [_pos, "CargoNet_01_box_F"];
[[_crate],{
	if (!isDedicated) then {
		[_this select 0, rank player] call EVO_fnc_buildAmmoCrate;
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
