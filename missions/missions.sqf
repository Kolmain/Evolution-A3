
//_array = [unit1, unit2, unit3];
for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	waitUntil {player in list missions};
	_newacts = [];
	_newaction = player addAction ["Request Mission", "missions\MissionSelectionDialog\MissionSelectionDialog.sqf", [ /* params */ ] ];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["Spectate", "spect\specta.sqf",10,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["ViewDistance Up", "actions\settings.sqf",10,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["ViewDistance Down", "actions\settings.sqf",20,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["AirViewDistance Up", "actions\settings.sqf",60,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["AirViewDistance Down", "actions\settings.sqf",70,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["TerrainDetail Low", "actions\settings.sqf",30,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["TerrainDetail Medium", "actions\settings.sqf",40,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addaction ["TerrainDetail High", "actions\settings.sqf",50,1, true, true,"test2"];
	_newacts = _newacts + [_newaction];
	_newaction = player addAction ["Request Transfer", "TeamStatusDialog\TeamStatusDialog.sqf",[1,1]];
	_newacts = _newacts + [_newaction];
	_newaction = player addAction ["Request Halo", "actions\halo.sqf",[1,1]];
	_newacts = _newacts + [_newaction];
	if(0 < 6) then {_newaction = player addAction ["Recruit Soldier", "Dialogs\RecruitSoldierDialog.sqf",[1,1]];_newacts = _newacts + [_newaction];};
	sleep 1.0;
	waitUntil {not (player in list missions)};
	for [{_i=0}, {_i < count _newacts}, {_i=_i+1}] do
	{
		player removeAction (_newacts select _i);
	};
};
