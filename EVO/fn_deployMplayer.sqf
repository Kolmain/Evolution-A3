if (player distance spawnBuilding < 1000) exitWith {
	_msg = format ["You can't deploy a MASH in the base."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};
_truck = nearestObject [player, "B_Truck_01_medical_F"];
if (isNil "_truck" || (player distance _truck > 25)) exitWith {
	_msg = format ["You can't deploy a MASH without a HEMTT Medical Truck."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};






//check for flat land from CHHQ
_composition = call (compile (preprocessFileLineNumbers "Comps\mash.sqf"));
_sortedByDist = [_composition,[],{
	_frstNum = abs (_x select 1 select 0);
	_secNum = abs (_x select 1 select 1);
	if (_frstNum > _secNum) then {_frstNum} else {_secNum}
},"DESCEND"] call BIS_fnc_sortBy;
_biggestOffset = (_sortedByDist select 0) select 1;
_biggestOffsetAbs = if (abs (_biggestOffset select 0) > abs (_biggestOffset select 1)) then {abs (_biggestOffset select 0)} else {abs (_biggestOffset select 1)};
_boundingSize = [_sortedByDist select 0 select 0] call _checkBoundingSize;
_radius = _biggestOffsetAbs + _boundingSize;
_sortedBySize = [_composition,[],{sizeOf (_x select 0)},"DESCEND"] call BIS_fnc_sortBy;
_boundingSize = [_sortedBySize select 0 select 0] call _checkBoundingSize;
if (_boundingSize > _radius) then {
	_radius = _boundingSize;
};
_flatPos = (getPosASL _veh) isFlatEmpty [
	_radius,	//--- Minimal distance from another object
	0,				//--- If 0, just check position. If >0, select new one
	0.4,			//--- Max gradient
	_radius max 5,	//--- Gradient area
	0,				//--- 0 for restricted water, 2 for required water,
	false,			//--- Has to have shore nearby!
	objNull			//--- Ignored object
];

if (count _flatPos isEqualTo 0) exitWith {
	_msg = format ["You can't deploy a MASH on uneven terrain."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};







player playMove "Acts_carFixingWheel";
mashRespawn call BIS_fnc_removeRespawnPosition;
{
	deleteVehicle _x;
} forEach playerStructures;
sleep 3.0;

WaitUntil {animationState player != "Acts_carFixingWheel"};

_mark = format["%1mash",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), "Comps\mash.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
mashRespawn = [(side player), getPos player] spawn BIS_fnc_addRespawnPosition;
_mssg = format["%1's MASH",(name player)];
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition player];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;
