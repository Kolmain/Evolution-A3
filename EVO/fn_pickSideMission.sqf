currentSideMission = "none";
currentSideMissionStatus = "ip";
currentSidemissionUnits = [];
publicVariable "currentSidemissionUnits";
publicVariable "currentSideMission";
publicVariable "currentSideMissionStatus";
_mission = ["aaa", "attack"] call BIS_fnc_selectRandom;
switch (_mission) do {
                case "aaa": {
                    _options = [];
					{
						_vehicle = _x;
						if (typeOf _vehicle == EVO_opforAAA && alive _vehicle && canMove _vehicle) then {
							_options = _options + [_vehicle];
						};
					} forEach vehicles;
					_vehicle = _options call BIS_fnc_selectRandom;
					if (!isNil "_vehicle") then {
						aaHuntTarget = _vehicle;
						publicVariable "aaHuntTarget";
						[] call EVO_fnc_sm_aaHunt;
					} else {
						 [] spawn EVO_fnc_pickSideMission;
					};
                };
				case "basedefend": {
					[] call EVO_fnc_sm_baseDef;
				};
				case "attack": {
					attackMilTarget = militaryLocations call BIS_fnc_selectRandom;
					[] call EVO_fnc_sm_attackMil;
				};
				case "defend": {
					defendTarget = sideLocations call BIS_fnc_selectRandom;
					[] call EVO_fnc_sm_reinforce;
				};
				case "csar": {
					csarLoc = sideLocations call BIS_fnc_selectRandom;
					[] call EVO_fnc_sm_csar;
				};
};

/*
//convoy
// 1 in 2 chance
_bool = false;
if (("randomSideMissions" call BIS_fnc_getParamValue) == 1) then {
	_bool = [true, false] call BIS_fnc_selectRandom;
} else {
	_bool = true;
};
if (_bool) then {
	_locationArray = militaryLocations + targetLocations;
	_locationArray = _locationArray - ([targetLocations select 0]) - ([targetLocations select 1]) - ([targetLocations select 2]);
	convoyStart = _locationArray call BIS_fnc_selectRandom;
	_locationArray = nearestLocations [ (position convoyStart), ["NameCity", "NameCityCapital","NameVillage"], 10000];
	_locationArray= _locationArray - [(_locationArray select 0)] - [(_locationArray select 1)] - [(_locationArray select 2)] - [(_locationArray select 3)] - [(_locationArray select 4)] - [(_locationArray select 5)] - [(_locationArray select 6)];
	convoyEnd = _locationArray call BIS_fnc_selectRandom;
	_pos = position convoyStart;
	_array = nearestObjects [_pos, ["house"], 500];
	_obj = _array select 0;

	_pos2 = position convoyEnd;
	_array2 = nearestObjects [_pos2, ["house"], 500];
	_obj2 = _array2 select 0;
	_descrip = format["We have received intel that an OPFOR convoy with supplies will be departing %1, heading to %2. Ambush them and destroy any supply or support vehicles", text convoyStart, text convoyEnd];
	_img = getText(configFile >>  "CfgTaskTypes" >>  "Destroy" >> "icon");
	availableSideMissions = availableSideMissions + [
		[getPos _obj, EVO_fnc_sm_convoy, "Ambush Convoy Start", _descrip,"",_img,1,[]]
	];
	availableSideMissions = availableSideMissions + [
		[getPos _obj2, EVO_fnc_sm_convoy, "Ambush Convoy End", _descrip,"",_img,1,[]]
	];
};
*/

