private ["_pos","_msg","_mark","_mssg","_medmark","_crate"];
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


[[_pos, 25, player],"EVO_fnc_healMen",false] call BIS_fnc_MP;

_mark = format["%1mash",(name player)];
deleteMarker _mark;
//playerStructures = [(getPos player), (getDir player), "Comps\mash.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
playerStructures = [(getPos player), (getDir player), call (compile (preprocessFileLineNumbers "Comps\mash.sqf"))] call BIS_fnc_objectMapper;
_mssg = format["%1's MASH",(name player)];
playerRespawnPoint = [(group player), (getPos player), _mssg] call BIS_fnc_addRespawnPosition;
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
sleep 5;
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition player];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;
_crate = nearestObject [_pos, "CargoNet_01_box_F"];
[[_crate],{
	if (!isDedicated) then {
		[(_this select 0), rank player] call EVO_fnc_buildAmmoCrate;
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;

_mash = nearestObject [_pos, "Land_Medevac_house_V1_F"];
while {alive _mash} do {
	_pts = _player getVariable ["EVO_healingPts", 0];
	if (_pts >= 1) then {
		player setVariable ["EVO_healingPts", 0, true];
		[player, 1] call bis_fnc_addScore;
		["PointsAdded",["Your MASH healed a BLUFOR unit.", 1]] call BIS_fnc_showNotification;
	};
	sleep 1;
};
