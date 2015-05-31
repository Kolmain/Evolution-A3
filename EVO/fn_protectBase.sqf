while {true} do {
    sleep 30;
    if (!(currentSideMission == "baseDef")) then {
	    _list = (getPos spawnBuilding) nearEntities [["Man", "Car", "Motorcycle", "Tank"], 800];
	    {
	    	if (side _x == EAST && !isPlayer leader group _x) then {
		    	[_x] spawn {
			    	_this select 0 setDamage 1;
			    	sleep 30;
			    	deleteVehicle _this select 0;
			    };
			};
		} forEach _list;
	};
};