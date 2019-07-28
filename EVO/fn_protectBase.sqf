private ["_list","_ent"];
while {true} do {
    sleep 30;
    if (!(currentSideMission == "baseDef")) then {
	    _list = (getPos spawnBuilding) nearEntities [["Man", "Car", "Motorcycle", "Tank"], 600];
	    {
	    	if (side _x == EAST && !isPlayer leader group _x) then {
		    	[_x] spawn {
		    		_ent = _this select 0;
			    	_ent setDamage 1;
			    	sleep 30;
			    	deleteVehicle _ent;
			    };
			};
		} forEach _list;
	};
};