private ["_caller","_pos","_is3D","_ID","_grpSide","_planeClass","_pilot","_score","_dis","_newCasStrike","_center","_cas","_loop","_plane","_supportAsset","_source","_scoreToAdd","_player"];

_caller = _this select 0;
_caller playMoveNow "Acts_listeningToRadio_Loop";
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
_planeClass = "B_Plane_CAS_01_F";
_pilot = pilot_west;
_score = player getVariable ["EVO_score", 0];
_score = _score - 7;
player setVariable ["EVO_score", _score, true];
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
	sleep 3.5;
	[_pilot, format["Copy that %2, out.", groupID (group _pilot), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	_newCasStrike = [_caller, "fixedCasStrike"] call BIS_fnc_addCommMenuItem;
	_score = player getVariable ["EVO_score", 0];
	_score = _score + 7;
	player setVariable ["EVO_score", _score, true];
	[player, 7] call bis_fnc_addScore;
	["PointsAdded",["CAS support canceled.", 7]] call BIS_fnc_showNotification;
};
openMap false;
[_caller, format["Grid %3, over.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;
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
	_loop = true;
	_plane = objNull;
	while {_loop} do {
		sleep 1;
		_plane = nearestObject [_pos, "B_Plane_CAS_01_F"];
		if (!isPlayer driver _plane) then {
			_loop = false;
			driver _plane setVariable ["EVO_playerRequester", player, true];
			[[[_plane], {
			driver (_this select 0) addEventHandler ["HandleScore", {
			_supportAsset = _this select 0;
			_source = _this select 1;
			_scoreToAdd = _this select 2;
			_player = _supportAsset getVariable ["EVO_playerRequester", objNull];
			_score = _player getVariable ["EVO_score", 0];
			_score = _score + _scoreToAdd;
			_player setVariable ["EVO_score", _score, true];
			[_player, _scoreToAdd] call bis_fnc_addScore;
			if (EVO_Debug) then {
				systemChat format ["%1 got points from %2. Sending points to %3.", _supportAsset, _source, _player];
			};
		}];
	}], "BIS_fnc_spawn", false] call BIS_fnc_MP;
};
};
waituntil {isnull _cas};
[_pilot, format["Fixed wing CAS support request completed, %2 out.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;

} else {

[_pilot, format["Grid %3 is too close to friendly forces, request denied, out.", groupID (group _caller), groupID (group _pilot), mapGridPosition _pos]] call EVO_fnc_globalSideChat;
sleep 5;
_newCasStrike = [_caller, "fixedCasStrike"] call BIS_fnc_addCommMenuItem;
_score = player getVariable ["EVO_score", 0];
_score = _score + 7;
player setVariable ["EVO_score", _score, true];
[player, 7] call bis_fnc_addScore;
["PointsAdded",["CAS support canceled.", 7]] call BIS_fnc_showNotification;
};
supportMapClick = [0,0,0];
supportClicked = false;
["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;