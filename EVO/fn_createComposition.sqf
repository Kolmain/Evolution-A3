private ["_pos","_composition","_sortedByDist","_frstNum","_secNum","_biggestOffset","_biggestOffsetAbs","_boundingSize","_type","_bbdummy","_boundingBox","_radius","_sortedBySize","_flatPos"];

_pos = _this select 0;
_composition = call (compile (preprocessFileLineNumbers (_this select 1)));
_sortedByDist = [_composition,[],{
	_frstNum = abs (_x select 1 select 0);
	_secNum = abs (_x select 1 select 1);
	if (_frstNum > _secNum) then {_frstNum} else {_secNum}
},"DESCEND"] call BIS_fnc_sortBy;
_biggestOffset = (_sortedByDist select 0) select 1;
_biggestOffsetAbs = if (abs (_biggestOffset select 0) > abs (_biggestOffset select 1)) then {abs (_biggestOffset select 0)} else {abs (_biggestOffset select 1)};
_boundingSize = [_sortedByDist select 0 select 0] call {
	_type = _this select 0;
	_bbdummy = _type createVehicleLocal [0,0,0];
	_boundingBox = (boundingBox _bbdummy) select 1;
	deleteVehicle _bbdummy;
	_boundingSize = if (_boundingBox select 0 > _boundingBox select 1) then {_boundingBox select 0} else {_boundingBox select 1};
	_boundingSize
};
_radius = _biggestOffsetAbs + _boundingSize;
_sortedBySize = [_composition,[],{sizeOf (_x select 0)},"DESCEND"] call BIS_fnc_sortBy;
_boundingSize = [_sortedBySize select 0 select 0] call {
	_type = _this select 0;
	_bbdummy = _type createVehicleLocal [0,0,0];
	_boundingBox = (boundingBox _bbdummy) select 1;
	deleteVehicle _bbdummy;
	_boundingSize = if (_boundingBox select 0 > _boundingBox select 1) then {_boundingBox select 0} else {_boundingBox select 1};
	_boundingSize
};
if (_boundingSize > _radius) then {
	_radius = _boundingSize;
};


_safePosition = [_pos, 1, 100, _radius, 0, 3, 0] call BIS_fnc_findSafePos;
_compComplete = [_pos, random 360, _composition] call BIS_fnc_ObjectsMapper;

_compComplete;