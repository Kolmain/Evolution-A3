if (player in list AirportIn) exitWith {
	_msg = format ["You can't deploy a MASH in the base."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};

deletevehicle mtent;
player playMove "Acts_carFixingWheel";
sleep 3.0;

WaitUntil {animationState player != "Acts_carFixingWheel"};

_mark = format["%1mash",(name player)];
deleteMarker _mark;
mtent = "MASH" createVehicle (position player);
_respawnPos = [(side player), mtent] spawn BIS_fnc_addRespawnPosition;
_pos = position mtent;
_mssg = format["%1's MASH",(name player)];
_medmark = createMarker [_mark, _pos];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition mtent];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;