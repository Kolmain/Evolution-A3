private ["_caller","_pos","_is3D","_ID","_grpSide","_arty","_busy","_score","_newartyStrike","_isInRange","_eta"];

_caller = _this select 0;
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
_arty = _caller;
_caller playMoveNow "Acts_listeningToRadio_Loop";
_arty = arty_west;
_busy = false;
_busy = _arty getVariable ["EVO_support_busy", false];
[player, -6] call bis_fnc_addScore;
["PointsRemoved",["Artillery support initiated.", 6]] call BIS_fnc_showNotification;
if(!_busy) then {

	_arty setVariable ["EVO_support_busy", true, true];
	[_caller, format["%1, this is %2, adjust fire, over.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[_arty, format["%2 this is %1, adjust fire, out.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
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
	[_caller, format["%1, this is %2, scratch that last request, out.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	_arty setVariable ["EVO_support_busy", false, true];
	sleep 3.5;
	[_arty, format["Copy that %2, out.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	_newartyStrike = [_caller, "artyStrike"] call BIS_fnc_addCommMenuItem;
	[player, 6] call bis_fnc_addScore;
	["PointsAdded",["Artillery support canceled.", 6]] call BIS_fnc_showNotification;
};
openMap false;
[_caller, format["Grid %1, over.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
sleep 3;
_isInRange = _pos inRangeOfArtillery [[_arty], currentMagazine _arty];
if (_isInRange) then {
	_arty setVariable ["EVO_playerRequester", player, true];
	[_arty, format["Grid %1, out.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
	sleep 3;
	[_caller, "Fire for effect, over."] call EVO_fnc_globalSideChat;
	sleep 3;
	[_arty, "Fire for effect, out."] call EVO_fnc_globalSideChat;
	sleep 1.5;
	[_arty, "Firing for effect, three rounds, out."] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[_arty, "Shot, over."] call EVO_fnc_globalSideChat;
	//fire!
	_eta = 0;
	[[_arty, _pos, 6],"EVO_fnc_doArtyFire", (owner _arty), false, false] spawn BIS_fnc_MP;
	_eta = floor(_arty getArtilleryETA [_pos, currentMagazine _arty]);
	[_caller, "Shot, out."] call EVO_fnc_globalSideChat;
	sleep 3.5;
	_arty setVariable ["EVO_support_busy", false, true];
	[_arty, format["Splash in %1 seconds, over.", _eta]] call EVO_fnc_globalSideChat;
	sleep (_eta + 10);
	[_caller, "Splash, over."] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[_arty, "Splash, out."] call EVO_fnc_globalSideChat;
} else {
[_arty, format["%2 this is %1, specified map grid is out of range, out.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
_newartyStrike = [_caller, "artyStrike"] call BIS_fnc_addCommMenuItem;
[player, 6] call bis_fnc_addScore;
};

} else {
[_caller, format["%1, this is %2, adjust fire, over.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
sleep 3.5;
[_arty, format["%2 this is %1, we are already servicing a request, out.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
_newartyStrike = [_caller, "artyStrike"] call BIS_fnc_addCommMenuItem;
[player, 6] call bis_fnc_addScore;
["PointsAdded",["Artillery support canceled.", 6]] call BIS_fnc_showNotification;
};
supportMapClick = [0,0,0];
supportClicked = false;
["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;