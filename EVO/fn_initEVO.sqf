private ["_targetRadioTower","_pos","_spawnPos","_max_distance","_officer","_vehicle","_null","_markerName","_aaMarker","_ret","_plane","_grp"];

activetargets = ["Pariso", "Somato", "Cayo", "Dolores", "Ortego", "Corazol", "Obregan", "Bagango", "Eponia", "Masbate", "Pita"];
activetargetsRT = [ParisoRT, SomatoRT, CayoRT, DoloresRT, OrtegoRT, CorazolRT, ObreganRT, BagangoRT, EponiaRT, MasbateRT, PitaRT];
activetargetsOF = [ParisoOF, SomatoOF, CayoOF, DoloresOF, OrtegoOF, CorazolOF, ObreganOF, BagangoOF, EponiaOF, MasbateOF, PitaOF];
currentTarget = "empty";
currentTargetRT = nil;
currentTargetOF = nil;
RTonline = true;
paraSquads = 1;
infSquads = (("infSquadsParam" call BIS_fnc_getParamValue) * 2);
mechSquads = ("mechSquadsParam" call BIS_fnc_getParamValue);
armorSquads = ("armorSquadsParam" call BIS_fnc_getParamValue);
infSquadStep = 1;
mechSquadStep = 1;
ArmorSquadStep = 1;
CROSSROADS = [West,"HQ"];
MHQ = firstMHQ;


{ _x setMarkerAlpha 0 } forEach activetargets;
"opforair" setMarkerAlpha 0;

{
	_targetRadioTower = _x;
	/*
	_pos = (getPos _targetRadioTower);
	_spawnPos = [];
	_max_distance = 100;
	while{ count _spawnPos < 1 } do	{
		_spawnPos = _pos findEmptyPosition[ 30 , _max_distance , (typeOf _targetRadioTower)];
		_max_distance = _max_distance + 50;
	};
	_targetRadioTower setPosASL _spawnPos;
	*/
	handle = [_targetRadioTower] spawn EVO_fnc_demoOnly;
} count activetargetsRT;

{
	_officer = _x;
	_pos = (getPos _officer);
	_spawnPos = [];
	_max_distance = 100;
	while{ count _spawnPos < 1 } do	{
		_spawnPos = _pos findEmptyPosition[ 30 , _max_distance , (typeOf _officer)];
		_max_distance = _max_distance + 50;
	};
	_officer setPosASL _spawnPos;
	removeAllWeapons _officer;
	_officer setCaptive true;
	[[[_officer], {(_this select 0) addAction [ "Capture Officer", "[] call EVO_fnc_officer;"];}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
	//_officer addAction [ "Capture Officer", "[] call EVO_fnc_officer;"];
	doStop _officer;
} count activetargetsOF;

_i = 0;
{
	_vehicle = _x;
	if ((faction _vehicle == "BLU_F") && !(_vehicle isKindOf "Plane") && ((typeOf _vehicle) != "B_MRAP_01_F")) then {
		_null = [_vehicle] spawn EVO_fnc_respawnRepair;
	};

	if (typeOf _vehicle == "O_APC_Tracked_02_AA_F") then {
		_markerName = format ["aa_%1", _i];
		_aaMarker = createMarker [_markerName, position _x ];
		_markerName setMarkerShape "ELLIPSE";
		_markerName setMarkerBrush "Cross";
		_markerName setMarkerSize [1200, 1200];
		_markerName setMarkerColor "ColorEAST";
		_markerName setMarkerPos (GetPos _vehicle);
		_i = _i + 1;
	};
} forEach vehicles;

/*
_ret = [(getPos server), (floor (random 360)), "O_Plane_CAS_02_F", EAST] call bis_fnc_spawnvehicle;
_plane = _ret select 0;
_grp = _ret select 2;
_null = [(leader _grp), opforair, "DELETE:", 80] execVM "scripts\UPSMON.sqf";
*/

currentTarget = activetargets select 0;
publicVariable "currentTarget";
activetargets = activetargets - [currentTarget];
publicVariable "activetargets";
currentTargetRT = activetargetsRT select 0;
publicVariable "currentTargetRT";
activetargetsRT = activetargetsRT - [currentTargetRT];
publicVariable "currentTargetOF";
currentTargetOF = activetargetsOF select 0;
publicVariable "currentTargetOF";
activetargetsOF = activetargetsOF - [currentTargetOF];
publicVariable "activetargetsOF";
RTonline = true;
publicVariable "RTonline";
handle = [] spawn EVO_fnc_initTarget;
//if (isMultiplayer) then {handle = [] spawn EVO_fnc_initTarget};



