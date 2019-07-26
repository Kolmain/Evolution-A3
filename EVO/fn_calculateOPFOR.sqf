private ["_type","_mission","_qty","_weight"];

//////////////////////////////////////
//Calculate Number of Active Squads in a Given AO
//////////////////////////////////////
_type = _this select 0;
_mission = _this select 1;
if (isNil "_type") exitWith {};
_qty = 0;
_weight = targetCounter;
if (_weight > 10) then {
    _weight = 10;
};
switch (_mission) do {
    //////////////////////////////////////
    //MAIN AO QTY
    //////////////////////////////////////
    case "Main": {
       switch (_type) do {
                case "Sniper": {
                    switch (EVO_difficulty) do {
                        case 1: {
                            //////////////////////////////////////
                            //EASY
                            //////////////////////////////////////
                            _qty = floor(random(1));
                        };
                        case 2: {
                            //////////////////////////////////////
                            //NORMAL
                            //////////////////////////////////////
                            _qty = ((floor(random(2))) + floor(random(targetCounter)));
                            if (_qty > 5) then {_qty = 5};
                        };
                        case 3: {
                            //////////////////////////////////////
                            //HARD
                            //////////////////////////////////////
                            _qty = ((floor(random(2))) + floor(random(targetCounter)));
                            if (_qty > 6) then {_qty = 6};
                        };
                        case 4: {
                            //////////////////////////////////////
                            //ALTIS ON FIRE
                            //////////////////////////////////////
                            _qty = ((floor(random(1))) + floor(random(targetCounter)));
                            if (_qty > 7) then {_qty = 7};
                        };
                    };
                };
            case "Comps": {
                    switch (EVO_difficulty) do {
                        case 1: {
                            //////////////////////////////////////
                            //EASY
                            //////////////////////////////////////
                            _qty = floor(random(3));
                        };
                        case 2: {
                            //////////////////////////////////////
                            //NORMAL
                            //////////////////////////////////////
                            _qty = floor(random(6));
                        };
                        case 3: {
                            //////////////////////////////////////
                            //HARD
                            //////////////////////////////////////
                            _qty = floor(random(7));
                        };
                        case 4: {
                            //////////////////////////////////////
                            //ALTIS ON FIRE
                            //////////////////////////////////////
                            _qty = floor(random(10));
                        };
                    };
                };
            case "Minefield_AT": {
                    switch (EVO_difficulty) do {
                        case 1: {
                            //////////////////////////////////////
                            //EASY
                            //////////////////////////////////////
                            _qty = floor(random(1));
                        };
                        case 2: {
                            //////////////////////////////////////
                            //NORMAL
                            //////////////////////////////////////
                            _qty = ((floor(random(1))) + floor(random(targetCounter)));
                            if (_qty > 3) then {_qty = 3};
                        };
                        case 3: {
                            //////////////////////////////////////
                            //HARD
                            //////////////////////////////////////
                            _qty = ((floor(random(2))) + floor(random(targetCounter)));
                            if (_qty > 4) then {_qty = 4};
                        };
                        case 4: {
                            //////////////////////////////////////
                            //ALTIS ON FIRE
                            //////////////////////////////////////
                            _qty = ((floor(random(1))) + floor(random(targetCounter)));
                            if (_qty > 5) then {_qty = 5};
                        };
                    };
                };
           case "Minefield_Inf": {
                    switch (EVO_difficulty) do {
                        case 1: {
                            //////////////////////////////////////
                            //EASY
                            //////////////////////////////////////
                            _qty = floor(random(1));
                        };
                        case 2: {
                            //////////////////////////////////////
                            //NORMAL
                            //////////////////////////////////////
                            _qty = ((floor(random(2))) + floor(random(targetCounter)));
                            if (_qty > 5) then {_qty = 5};
                        };
                        case 3: {
                            //////////////////////////////////////
                            //HARD
                            //////////////////////////////////////
                            _qty = ((floor(random(2))) + floor(random(targetCounter)));
                            if (_qty > 6) then {_qty = 6};
                        };
                        case 4: {
                            //////////////////////////////////////
                            //ALTIS ON FIRE
                            //////////////////////////////////////
                            _qty = ((floor(random(1))) + floor(random(targetCounter)));
                            if (_qty > 7) then {_qty = 7};
                        };
                    };
                };
           case "Mortar": {
                    switch (EVO_difficulty) do {
                        case 1: {
                            //////////////////////////////////////
                            //EASY
                            //////////////////////////////////////
                            _qty = floor(random(1));
                        };
                        case 2: {
                            //////////////////////////////////////
                            //NORMAL
                            //////////////////////////////////////
                            _qty = ((floor(random(1))) + floor(random(targetCounter)));
                            if (_qty > 3) then {_qty = 3};
                        };
                        case 3: {
                            //////////////////////////////////////
                            //HARD
                            //////////////////////////////////////
                            _qty = ((floor(random(2))) + floor(random(targetCounter)));
                            if (_qty > 4) then {_qty = 4};
                        };
                        case 4: {
                            //////////////////////////////////////
                            //ALTIS ON FIRE
                            //////////////////////////////////////
                            _qty = ((floor(random(1))) + floor(random(targetCounter)));
                            if (_qty > 5) then {_qty = 5};
                        };
                    };
                };
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
    };
    //////////////////////////////////////
    //RAID TOWER QTY
    //////////////////////////////////////
    case "Radio": {
       switch (_type) do {
            case "Infantry": {
                switch (EVO_difficulty) do {
                    case 1: {
                        //////////////////////////////////////
                        //EASY
                        //////////////////////////////////////
                        _qty = 1;
                        _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                        _qty = _qty + random(floor(3));
                        _qty = _qty + random(floor(_weight / 2));
                    };
                    case 2: {
                        //////////////////////////////////////
                        //NORMAL
                        //////////////////////////////////////
                        _qty = 3;
                        _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                        _qty = _qty + random(floor(3));
                        _qty = _qty + random(floor(_weight));
                    };
                    case 3: {
                        //////////////////////////////////////
                        //HARD
                        //////////////////////////////////////
                        _qty = 4;
                        _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                        _qty = _qty + random(floor(3));
                        _qty = _qty + random(floor(_weight));
                    };
                    case 4: {
                        //////////////////////////////////////
                        //ALTIS ON FIRE
                        //////////////////////////////////////
                        _qty = 5;
                        _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                        _qty = _qty + random(floor(3));
                        _qty = _qty + random(floor(_weight));
                    };
                };
            };
        };
    };
    //////////////////////////////////////
    //SIDE MISSION QTY
    //////////////////////////////////////
    case "Side": {
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
                        _qty = 1;
                        _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                        _qty = _qty + random(floor(3));
                        _qty = _qty + random(floor(_weight / 2));
                    };
                    case 2: {
                        //////////////////////////////////////
                        //NORMAL
                        //////////////////////////////////////
                        _qty = 2;
                        _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                        _qty = _qty + random(floor(3));
                        _qty = _qty + random(floor(_weight));
                    };
                    case 3: {
                        //////////////////////////////////////
                        //HARD
                        //////////////////////////////////////
                        _qty = 3;
                        _qty = _qty + (random(floor(2 * currentTargetSqkm)));
                        _qty = _qty + random(floor(3));
                        _qty = _qty + random(floor(_weight));
                    };
                    case 4: {
                        //////////////////////////////////////
                        //ALTIS ON FIRE
                        //////////////////////////////////////
                        _qty = 4;
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
                        _qty = 1;
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
    };
};



_qty;
