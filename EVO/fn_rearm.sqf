_veh = vehicle player;

_veh setFuel 0;
[
	[
		["REARMING...", "<t align = 'center' shadow = '1' size = '0.7' font='PuristaBold'>%1</t>"]
	]
] spawn BIS_fnc_typeText;
sleep 6;
_veh setVehicleAmmo 1;
[
	[
		["REPAIRING...", "<t align = 'center' shadow = '1' size = '0.7' font='PuristaBold'>%1</t>"]
	]
] spawn BIS_fnc_typeText;
sleep 8;
_veh setDamage 0;
[
	[
		["REFUELING...", "<t align = 'center' shadow = '1' size = '0.7' font='PuristaBold'>%1</t>"]
	]
] spawn BIS_fnc_typeText;
sleep 7;
_veh setFuel 1;
[
	[
		["VEHICLE READY.", "<t align = 'center' shadow = '1' size = '0.7' font='PuristaBold'>%1</t>"]
	]
] spawn BIS_fnc_typeText;