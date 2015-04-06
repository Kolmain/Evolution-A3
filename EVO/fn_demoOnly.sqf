_radio = _this select 0;
_radio allowDamage false;
while {alive _radio} do
{
	sleep 3.0;
	_bomb = (_radio nearObjects ["SatchelCharge_Remote_Mag", 20]) select 0;

	if(!isNull _bomb) then
	{
		_radio allowDamage true;
	};
};