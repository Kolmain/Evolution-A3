private ["_caller","_pos","_is3D","_ID","_grpSide","_arty","_busy","_isInRange","_eta","_newartyStrike"];
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
_arty = _caller;


_arty = arty_west;
_busy = false;
_busy = _arty getVariable ["EVO_support_busy", false];
_score = player getVariable "EVO_score";
_score = _score - 6;
player setVariable ["EVO_score", _score, true];
["PointsRemoved",["Artillery support initiated.", 6]] call BIS_fnc_showNotification;
if(!_busy || isNil "_busy") then {

	_arty setVariable ["EVO_support_busy", true, true];
	[_caller, format["%1, this is %2, adjust fire, over.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[_arty, format["%2 this is %1, adjust fire, out.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[_caller, format["Grid %1, over.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
	sleep 3;

	_isInRange = _pos inRangeOfArtillery [[_arty], currentMagazine _arty];
	if (_isInRange) then {
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
		_arty doArtilleryFire [_pos, currentMagazine _arty, 3];
		_eta = _arty getArtilleryETA [_pos, currentMagazine _arty];
		[_caller, "Shot, out."] call EVO_fnc_globalSideChat;
		sleep 3.5;
		_arty setVariable ["EVO_support_busy", false, true];
		[_arty, format["Splash in %1 seconds, over.", _eta]] call EVO_fnc_globalSideChat;
		sleep _eta;
		[_caller, "Splash, over."] call EVO_fnc_globalSideChat;
		sleep 3.5;
		[_arty, "Splash, out."] call EVO_fnc_globalSideChat;
	} else {
		[_arty, format["%2 this is %1, specified map grid is out of range, out.", groupID (group _arty), groupID (group _caller)]] call KOL_fnc_globalSideChat;
		_newartyStrike = [_caller, "artyStrike"] call BIS_fnc_addCommMenuItem;
	};

	} else {
		[_caller, format["%1, this is %2, adjust fire, over.", groupID (group _arty), groupID (group _caller)]] call KOL_fnc_globalSideChat;
		sleep 3.5;
		[_arty, format["%2 this is %1, we are already servicing a request, out.", groupID (group _arty), groupID (group _caller)]] call KOL_fnc_globalSideChat;
		_newartyStrike = [_caller, "artyStrike"] call BIS_fnc_addCommMenuItem;
		_score = player getVariable "EVO_score";
		_score = _score + 6;
		player setVariable ["EVO_score", _score, true];
		["PointsAdded",["Artillery support canceled.", 6]] call BIS_fnc_showNotification;

};
