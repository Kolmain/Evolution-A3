private ["_type","_qty","_weight"];

//////////////////////////////////////
//Calculate Number of Active Squads in a Given AO
//////////////////////////////////////
_type = _this select 0;
if (isNull "_type") exitWith {};
_qty = 0;
_weight = targetCounter;
if (_weight > 10) then {
    _weight = 10;
};
switch (_type) do {
    case "CAS": {
    	switch (EVO_difficulty) do {
    	    case 1: {
                //////////////////////////////////////
                //EASY
                //////////////////////////////////////
    	    	_qty = [1,1,0] call bis_fnc_selectRandom;
    	    };
    	    case 2: {
    	    	//////////////////////////////////////
				//NORMAL
				//////////////////////////////////////
                _qty = 1;
    	    };
    	    case 3: {
    	    	//////////////////////////////////////
				//HARD
				//////////////////////////////////////
				_qty = 1 + (floor(random(2)));
    	    };
    	    case 4: {
    	    	//////////////////////////////////////
				//ALTIS ON FIRE
				//////////////////////////////////////
				_qty = 1 + (floor(random(2)));
    	    };
    	};
    };
    case "Infantry": {
    	switch (EVO_difficulty) do {
    	    case 1: {
    	    	//////////////////////////////////////
				//EASY
				//////////////////////////////////////
				_qty = 4;
                _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                _qty = _qty + random(floor(3));
                _qty = _qty + random(floor(_weight / 2));
    	    };
    	    case 2: {
    	    	//////////////////////////////////////
				//NORMAL
				//////////////////////////////////////
                _qty = 6;
                _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                _qty = _qty + random(floor(3));
                _qty = _qty + random(floor(_weight));
    	    };
    	    case 3: {
    	    	//////////////////////////////////////
				//HARD
				//////////////////////////////////////
                _qty = 7;
                _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                _qty = _qty + random(floor(3));
                _qty = _qty + random(floor(_weight));
    	    };
    	    case 4: {
    	    	//////////////////////////////////////
				//ALTIS ON FIRE
				//////////////////////////////////////
                _qty = 8;
                _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                _qty = _qty + random(floor(3));
                _qty = _qty + random(floor(_weight));
    	    };
    	};
    };
    case "Armor": {
    	switch (EVO_difficulty) do {
    	    case 1: {
    	    	//////////////////////////////////////
				//EASY
				//////////////////////////////////////
                _qty = 1;
                _qty = _qty + (random(floor(1 * currentTargetSqkm)));
                _qty = _qty + random(floor(_weight / 2));
                _qty = _qty - random(floor(1));

    	    };
    	    case 2: {
    	    	//////////////////////////////////////
				//NORMAL
				//////////////////////////////////////
                _qty = 2;
                _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                _qty = _qty + random(floor(_weight / 2));
    	    };
    	    case 3: {
    	    	//////////////////////////////////////
				//HARD
				//////////////////////////////////////
                _qty = 2;
                _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                _qty = _qty + random(floor(_weight / 2));
    	    };
    	    case 4: {
    	    	//////////////////////////////////////
				//ALTIS ON FIRE
				//////////////////////////////////////
                _qty = 2;
                _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                _qty = _qty + random(floor(_weight / 2));
    	    };
    	};
    };
};


_qty;