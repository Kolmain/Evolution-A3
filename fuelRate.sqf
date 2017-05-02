_unit = _this select 0;
_rate = _this select 1;

while {alive _unit} do { 
	if (isengineon _unit and (fuel _unit > 0)) then {
		_unit setFuel ( Fuel _unit - 0.0001* _rate * (_unit getSoundController "thrust"));
	};
	sleep 1;
};