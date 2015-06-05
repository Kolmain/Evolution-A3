private ["_caller","_pos","_is3D","_ID","_grpSide","_planeClass","_pilot","_dis","_center","_cas","_newCasStrike"];
/*[caller,pos,target,is3D,ID]
caller: Object - unit which called the item, usually player
pos: Array in format Position - cursor position
target: Object - cursor target
is3D: Boolean - true when in 3D scene, false when in map
ID: String - item ID as returned by BIS_fnc_addCommMenuItem function*/

_caller = _this select 0;
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
_planeClass = "B_Plane_CAS_01_F";
_pilot = _caller;

_planeClass = "B_Plane_CAS_01_F";
_pilot = pilot_west;

_dis = _pos distance _pilot;
[_caller, format["%2, this is %1, requesting immediate fixed wing CAS support, over.", groupID (group _caller), groupID (group _pilot)]] call EVO_fnc_globalSideChat;
sleep 3.5;
[_pilot, format["%1, this is %2, send grid coordinates, over.", groupID (group _caller), groupID (group _pilot)]] call EVO_fnc_globalSideChat;
sleep 3.5;
[_caller, format["Grid %3, over.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call KOL_fnc_globalSideChat;
sleep 3.5;

if ( _dis > 1000) then {

	[_pilot, format["Grid %3 confirmed, en route, over.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	_center = createCenter sideLogic;
	_group = createGroup _center;
	_cas = _group createUnit ["ModuleCAS_F", _pos , [], 0, ""];
	_cas setDir 0;
	_cas setVariable ["vehicle", _planeClass , true];
	_cas setVariable ["type", 2, true];
	waituntil {isnull _cas};
	[_pilot, format["Fixed wing CAS support request completed, %2 out.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;

} else {

	[_pilot, format["Grid %3 is too close to friendly forces, request denied, out.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;
	sleep 5;
	_newCasStrike = [_caller, "fixedCasStrike"] call BIS_fnc_addCommMenuItem;
};
