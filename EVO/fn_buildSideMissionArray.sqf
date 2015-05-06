private ["_options","_vehicle","_img","_bool","_pos","_array","_obj","_locationArray","_pos2","_array2","_obj2","_descrip"];


currentSideMission = "none";
currentSideMissionStatus = "ip";
publicVariable "currentSideMission";
publicVariable "currentSideMissionStatus";
//build AA hunt
//as long as there are AAA batteries
_options = [];
{
	_vehicle = _x;
	if (typeOf _vehicle == "O_APC_Tracked_02_AA_F" && alive _vehicle && canMove _vehicle) then {
		_options = _options + [_vehicle];
	};
} forEach vehicles;
_vehicle = _options call BIS_fnc_selectRandom;
if (!isNil "_vehicle") then {
	aaHuntTarget = _vehicle;
	publicVariable "aaHuntTarget";
	_img = getText(configFile >>  "CfgVehicles" >>  (typeOf _vehicle) >> "picture");
	availableSideMissions = availableSideMissions + [
		[getPos aaHuntTarget, EVO_fnc_sm_aaHunt,"Destroy AAA Battery","Eliminate the OPFOR anti-air threat to enable BLUFOR support to continue.","", _img, 1,[]]
	];
};

//base defence
// 1 in 4 chance
//_bool = [true, false, false, false] call BIS_fnc_selectRandom;
_bool = true;
if (_bool) then {
	_img = getText(configFile >>  "CfgTaskTypes" >>  "Defend" >> "icon");
	availableSideMissions = availableSideMissions + [
		[getPos spawnBuilding, EVO_fnc_sm_baseDef,"Defend NATO Staging Base","OPFOR ground units are converging on the staging base. Defeat the enemy counterattack.","",_img,1,[]]
	];
};


//military installation
// 1 in 2 chance
//_bool = [true, false] call BIS_fnc_selectRandom;
_bool = true;
if (_bool) then {
	attackMilTarget = militaryLocations call BIS_fnc_selectRandom;
	_pos = position attackMilTarget;
	_array = nearestObjects [_pos, ["house"], 200];
	_obj = _array select 0;
	_img = getText(configFile >>  "CfgTaskTypes" >>  "Attack" >> "icon");
	availableSideMissions = availableSideMissions + [
		[getPos _obj, EVO_fnc_sm_attackMil,"Attack Installation","We discovered an OPFOR installation with fortified defences. Seize it to weaken their foothold.","",_img,1,[]]
	];
};

//convoy
// 1 in 2 chance
//_bool = [true, false] call BIS_fnc_selectRandom;
_bool = true;
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

//reinforce defense
// 1 in 2 chance
//_bool = [true, false] call BIS_fnc_selectRandom;
_bool = true;
if (_bool) then {
	defendTarget = militaryLocations call BIS_fnc_selectRandom;
	_pos = locationPosition defendTarget;
	_img = getText(configFile >>  "CfgTaskTypes" >>  "Defend" >> "icon");
	availableSideMissions = availableSideMissions + [
		[_pos, EVO_fnc_sm_attackMil,"Reinforce NATO Recon Element","OPFOR squads have discovered our forward recon units. They're sending squads to seek and destroy our men, get out there and help them!","",_img,1,[]]
	];
};

publicVariable "availableSideMissions";
