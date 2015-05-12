private ["_msg","_truck","_pos","_composition","_sortedByDist","_frstNum","_secNum","_biggestOffset","_biggestOffsetAbs","_boundingSize","_checkBoundingSize","_radius","_sortedBySize","_flatPos","_nearMen","_mash","_damage","_obj","_mark","_mssg","_medmark"];


if (player distance spawnBuilding < 1000) exitWith {
	_msg = format ["You can't deploy a MASH in the base."];
	["deployed",["MASH NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
};





_pos = getPos player;
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
_flatPos = _pos isFlatEmpty [
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





//Land_Medevac_house_V1_F

player playMove "Acts_carFixingWheel";
_respawnPoint = player getVariable "EVO_mashRespawn";
_respawnPoint call BIS_fnc_removeRespawnPosition;

{
	deleteVehicle _x;
} forEach playerStructures;
sleep 3.0;

WaitUntil {animationState player != "Acts_carFixingWheel"};
if (!alive player || player distance _pos > 4) exitWith {};


[[_pos],{
	_pos = _this select 0;
	if (isServer) then
	{
		_nearMen = [];
		_mash = nearestObject [_pos, "Land_Medevac_house_V1_F"];
		while {alive _mash} do
		{
			{
				if (alive _x && side _x == WEST && damage _x != 0) then
				{
					_damage = damage _x;
					_damage = _damage - 0.01;
					if (_damage < 0) then
					{
						_damage = 0;
					};
					_x setDamage _damage;
				};
			}
			forEach ((getPos _obj) nearEntities [["Man"], _radius]);
			sleep 2;
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;



_mark = format["%1mash",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), "Comps\mash.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
mashRespawn = [(side player), getPos player] spawn BIS_fnc_addRespawnPosition;
player setVariable ["EVO_mashRespawn", mashRespawn, true];
_mssg = format["%1's MASH",(name player)];
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition player];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;
