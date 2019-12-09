private ["_type","_delay"];

//////////////////////////////////////
//Calculate Delay of Reinforcements
//////////////////////////////////////
_type = _this select 0;
if (isNil "_type") exitWith {};
_delay = 0;
switch (_type) do {
    case "CAS": {
    	switch (EVO_difficulty) do {
    	    case 1: {
    	    	//////////////////////////////////////
				//EASY
				//////////////////////////////////////
				_delay = 600 + (floor(random(100)));
    	    };
    	    case 2: {
    	    	//////////////////////////////////////
				//NORMAL
				//////////////////////////////////////
				_delay = 600 + (floor(random(50)));
				_delay = _delay - (floor(random(50)));
    	    };
    	    case 3: {
    	    	//////////////////////////////////////
				//HARD
				//////////////////////////////////////
				_delay = 600 + (floor(random(30)));
				_delay = _delay - (floor(random(50)));
    	    };
    	    case 4: {
    	    	//////////////////////////////////////
				//ALTIS ON FIRE
				//////////////////////////////////////
				_delay = 600 - (floor(random(100)));
    	    };
    	};
    };
    case "Infantry": {
    	switch (EVO_difficulty) do {
    	    case 1: {
    	    	//////////////////////////////////////
				//EASY
				//////////////////////////////////////
				_delay = 45 + (floor(random(30)));
    	    };
    	    case 2: {
    	    	//////////////////////////////////////
				//NORMAL
				//////////////////////////////////////
				_delay = 45 + (floor(random(30)));
				_delay = _delay - (floor(random(30)));
    	    };
    	    case 3: {
    	    	//////////////////////////////////////
				//HARD
				//////////////////////////////////////
				_delay = 45 + (floor(random(30)));
				_delay = _delay - (floor(random(50)));
    	    };
    	    case 4: {
    	    	//////////////////////////////////////
				//ALTIS ON FIRE
				//////////////////////////////////////
				_delay = 60 - (floor(random(60)));
    	    };
    	};
    };
    case "Armor": {
    	switch (EVO_difficulty) do {
    	    case 1: {
    	    	//////////////////////////////////////
				//EASY
				//////////////////////////////////////
				_delay = 60 + (floor(random(30)));
    	    };
    	    case 2: {
    	    	//////////////////////////////////////
				//NORMAL
				//////////////////////////////////////
				_delay = 60 + (floor(random(30)));
				_delay = _delay - (floor(random(30)));
    	    };
    	    case 3: {
    	    	//////////////////////////////////////
				//HARD
				//////////////////////////////////////
				_delay = 60 + (floor(random(30)));
				_delay = _delay - (floor(random(50)));
    	    };
    	    case 4: {
    	    	//////////////////////////////////////
				//ALTIS ON FIRE
				//////////////////////////////////////
				_delay = 60 - (floor(random(60)));
    	    };
    	};
    };
};


_delay;