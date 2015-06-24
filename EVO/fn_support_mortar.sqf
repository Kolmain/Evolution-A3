private ["_caller","_pos","_is3D","_ID","_grpSide","_mortar","_busy","_score","_newMortarStrike","_isInRange","_eta","_arty"];

_caller = _this select 0;
_pos = _this select 1;
_target = _this select 2;
_is3D = _this select 3;
_ID = _this select 4;
_grpSide = side _caller;
_mortar = _caller;
_mortar = mortar_west;
_busy = false;
_busy = _mortar getVariable ["EVO_support_busy", false];
_score = player getVariable ["EVO_score", 0];
_score = _score - 5;
player setVariable ["EVO_score", _score, true];
[player, -5] call bis_fnc_addScore;
["PointsRemoved",["Mortar support initiated.", 5]] call BIS_fnc_showNotification;
if(!_busy || isNil "_busy") then {
	[_caller, format["%1, this is %2, adjust fire, over.", groupID (group _mortar), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	[_mortar, format["%2 this is %1, adjust fire, out.", groupID (group _mortar), groupID (group _caller)]] call EVO_fnc_globalSideChat;
	sleep 3.5;
	["supportMapClickEH", "onMapSingleClick", {
		supportMapClick = _pos;
		supportClicked = true;
		supportClicked = true;
		["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}] call BIS_fnc_addStackedEventHandler;
	openMap true;
	["deployed",["DESIGNATE TARGET", "Left click on your target."]] call BIS_fnc_showNotification;
	waitUntil {supportClicked || !(visiblemap)};
	_pos = supportMapClick;
		if (!visiblemap) exitWith {
		["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		[_caller, format["%1, this is %2, scratch that last request, out.", groupID (group _mortar), groupID (group _caller)]] call EVO_fnc_globalSideChat;
		sleep 3.5;
		[_mortar, format["Copy that %2, out.", groupID (group _mortar), groupID (group _caller)]] call EVO_fnc_globalSideChat;
		sleep 3.5;
		_newMortarStrike = [_caller, "mortarStrike"] call BIS_fnc_addCommMenuItem;
		_score = player getVariable ["EVO_score", 0];
		_score = _score + 5;
		player setVariable ["EVO_score", _score, true];
		[player, 5] call bis_fnc_addScore;
		["PointAdded",["Mortar support canceled.", 5]] call BIS_fnc_showNotification;
	};
	openMap false;
	[_caller, format["Grid %1, over.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
	sleep 3;

	_isInRange = _pos inRangeOfArtillery [[_mortar], currentMagazine _mortar];
	if (_isInRange) then {
		_mortar setVariable ["EVO_playerRequester", player, true];
		[_mortar, format["Grid %1, out.", mapGridPosition _pos]] call EVO_fnc_globalSideChat;
		sleep 3;
		[_caller, "Fire for effect, over."] call EVO_fnc_globalSideChat;
		sleep 3;
		[_mortar, "Fire for effect, out."] call EVO_fnc_globalSideChat;
		sleep 1.5;
		[_mortar, "Firing for effect, five rounds, out."] call EVO_fnc_globalSideChat;
		sleep 3.5;
		[_mortar, "Shot, over."] call EVO_fnc_globalSideChat;
		//fire!
		_eta = 0;
		[[[_mortar, _pos], {
			_gun = _this select 0;
			_pos = _this select 1;
			if (local (gunner _gun)) then {
				_gun setVehicleAmmoDef 1;
				_gun doArtilleryFire [_pos, (currentMagazine _gun), 5];
			};
		}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
		_eta = floor(_mortar getArtilleryETA [_pos, currentMagazine _mortar]);
		[_caller, "Shot, out."] call EVO_fnc_globalSideChat;
		sleep 3.5;
		_mortar setVariable ["EVO_support_busy", false, true];
		[_mortar, format["Splash in %1 seconds, over.", _eta]] call EVO_fnc_globalSideChat;
		sleep (_eta + 10);
		[_caller, "Splash, over."] call EVO_fnc_globalSideChat;
		sleep 3.5;
		[_mortar, "Splash, out."] call EVO_fnc_globalSideChat;
	} else {
		[_mortar, format["%2 this is %1, specified map grid is out of range, out.", groupID (group _mortar), groupID (group _caller)]] call EVO_fnc_globalSideChat;
		_newMortarStrike = [_caller, "mortarStrike"] call BIS_fnc_addCommMenuItem;
		_score = player getVariable ["EVO_score", 0];
		_score = _score + 5;
		player setVariable ["EVO_score", _score, true];
		[player, 5] call bis_fnc_addScore;
	};

	} else {
		[_caller, format["%1, this is %2, adjust fire, over.", groupID (group _mortar), groupID (group _caller)]] call KOL_fnc_globalSideChat;
		sleep 3.5;
		[_mortar, format["%2 this is %1, we are already servicing a request, out.", groupID (group _arty), groupID (group _caller)]] call EVO_fnc_globalSideChat;
		_newMortarStrike = [_caller, "mortarStrike"] call BIS_fnc_addCommMenuItem;
		_score = player getVariable ["EVO_score", 0];
		_score = _score + 5;
		player setVariable ["EVO_score", _score, true];
		[player, 5] call bis_fnc_addScore;
		["PointAdded",["Mortar support canceled.", 5]] call BIS_fnc_showNotification;

};
supportMapClick = [0,0,0];
["supportMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;