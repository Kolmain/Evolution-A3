private ["_radio","_loop","_bombs"];


_radio = _this select 0;
_radio allowDamage false;
_loop = true;
_bombs = [];

while {_loop} do
{
	sleep 1;
	_bombs = _radio nearObjects ["DemoCharge_Remote_Mag", 10];
	if(count (_bombs) > 0) then
	{
		_radio allowDamage true;
		_loop = false;
	};
};
