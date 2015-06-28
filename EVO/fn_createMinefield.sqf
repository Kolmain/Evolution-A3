_startPos = _this select 0;
_mineClass = _this select 1;

if (_mineClass == "ATMine") then {
//Place AT On Roads

	_roads = _startPos nearRoads 250;
	_nearestRoad = [_startPos, _roads] call EVO_fnc_getNearest;
	_startPos = getPos _nearestRoad;
	_lastPos = _startPos;
	for "_i" from 1 to (10 + random(10)) step 1 do {
		_dir = (((getDir _nearestRoad) - 90) + (random 90) - (random 90));
		_minePos = [_lastPos, ((random 3) + 3) , _dir] call BIS_fnc_relPos;
	  	_mine = createMine [_mineClass, [_minePos select 0, _minePos select 1, 0.2], [], 0];
		EAST revealMine _mine;
		_mine setDir (random 360);
		_lastPos = getPos _mine;
	};
	for "_i" from 1 to 3 step 1 do {
		_signPos = [_startPos, 15, random 360 ] call BIS_fnc_relPos;
		_sign = createVehicle ["Land_Sign_Mines_F", _signPos, [], 0, "NONE"];
		_sign setDir (random 360);
	};

} else {
//Place AI Anywhere
	_lastPos = _startPos;
	for "_i" from 1 to (10 + (random 10)) step 1 do {
		_minePos = [_lastPos, ((random 8) + 3) , (random 360)] call BIS_fnc_relPos;
		_mine = createMine [_mineClass, [_minePos select 0, _minePos select 1, 0.2], [], 0];
		EAST revealMine _mine;
		//_mine = createVehicle [_mineClass, _minePos, [], 0, "NONE"];
		_mine setDir (random 360);
		_lastPos = getPos _mine;
	};
	for "_i" from 1 to 3 step 1 do {
		_signPos = [_startPos, 15, random 360 ] call BIS_fnc_relPos;
		_sign = createVehicle ["Land_Sign_Mines_F", _signPos, [], 0, "NONE"];
		_sign setDir (random 360);
	};
};
true;