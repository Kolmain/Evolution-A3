_radio = _this select 0;
_radio allowDamage false;
_loop = true;
_bombs = [];

while {_loop} do
{
	sleep 1;
	_bombs = _radio nearObjects ["satchelcharge_remote_ammo", 20];
	if(count (_bombs) > 0) then
	{
		_radio allowDamage true;
		sleep 5;
		_bombs = _radio nearObjects ["satchelcharge_remote_ammo", 20];
		if(count (_bombs) > 0) then {
			_loop = false;
		};
	};
};