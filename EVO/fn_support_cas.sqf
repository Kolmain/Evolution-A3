private ["_caller","_pos","_is3D","_ID","_grpSide","_planeClass","_pilot","_score","_dis","_newCasStrike","_center","_cas","_loop","_plane","_supportAsset","_source","_scoreToAdd","_player"];

_caller = _this select 0;
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
_planeClass = "B_Plane_CAS_01_dynamicLoadout_F";
_pilot = pilot_west;
_score = _score - 7;
[player, -7] call bis_fnc_addScore;
["PointsRemoved",["CAS support initiated.", 7]] call BIS_fnc_showNotification;
_dis = _pos distance _pilot;
[_caller, format["%2, this is %1, requesting immediate fixed wing CAS support, over.", groupID (group _caller), groupID (group _pilot)]] call EVO_fnc_globalSideChat;
sleep 3.5;
[_pilot, format["%1, this is %2, send grid coordinates, over.", groupID (group _caller), groupID (group _pilot)]] call EVO_fnc_globalSideChat;
sleep 3.5;
openMap true;
sleep 3;
["supportMapClickEH", "onMapSingleClick", {
	supportMapClick = _pos;
	supportClicked = true;
	["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
}] call BIS_fnc_addStackedEventHandler;
["deployed",["DESIGNATE TARGET", "Left click on your target."]] call BIS_fnc_showNotification;
waitUntil {supportClicked || !(visiblemap)};
_pos = supportMapClick;
if (!visiblemap) exitWith {
	["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	[_caller, format["%1, this is %2, scratch that last request, out.", groupID (group _pilot), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	_pilot setVariable ["EVO_support_busy", false, true];
	sleep 3.5;
	[_pilot, format["Copy that %2, out.", groupID (group _pilot), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	_newCasStrike = [_caller, "fixedCasStrike"] call BIS_fnc_addCommMenuItem;
	[player, 7] call bis_fnc_addScore;
	["PointsAdded",["CAS support canceled.", 7]] call BIS_fnc_showNotification;
};
openMap false;
[_caller, format["Grid %3, over.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;
sleep 3.5;

if ( _dis > 1000) then {

	[_pilot, format["Grid %3 confirmed, en route, over.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;
	sleep 3.5;
		_logic = "Logic" createVehicleLocal _pos;
		_logic setDir (random 360);
		_logic setVariable ["vehicle", _planeClass];
		_logic setVariable ["type", 2];
		[_logic,nil,true] call BIS_fnc_moduleCAS;
		deleteVehicle _logic;
		_loop = true;

} else {
	[_pilot, format["Grid %3 is too close to friendly forces, request denied, out.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;
	sleep 5;
	_newCasStrike = [_caller, "fixedCasStrike"] call BIS_fnc_addCommMenuItem;
	[player, 7] call bis_fnc_addScore;
	["PointsAdded",["CAS support canceled.", 7]] call BIS_fnc_showNotification;
};
supportMapClick = [0,0,0];
supportClicked = false;
["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;