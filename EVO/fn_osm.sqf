
disableserialization;
_randomMission = availableSideMissions call BIS_fnc_selectRandom;
_parentDisplay 	= [] call bis_fnc_displayMission;
_mapCenter 	= (_randomMission select 0);
_ORBAT 		= [];
_markers 	= [];
_images 	= [];
_overcast 	= overcast;
_isNight 	= !((dayTime > 6) && (dayTime < 20));
_scale		= 100;
_simul		= true;

[
	findDisplay 46,
	_mapCenter,
	availableSideMissions,
	_ORBAT,
	_markers,
	_images,
	_overcast,
	_isNight,
	_scale,
	_simul
] call Bis_fnc_strategicMapOpen;