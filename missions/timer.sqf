_time = _this select 0;

while {_time >= 0} do 
{
	sleep 1.00;
	if (_time == 300) then {hint "WARNING: You have only five minutes left to complete your mission"};
	if (_time == 0) then {onmission = false};	
	if (not onmission) then {_time = 0};
	_time = _time - 1;
};