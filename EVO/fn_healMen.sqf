private ["_pos","_radius","_nearMen","_mash","_damage"];
_pos = _this select 0;
_radius = _this select 1;
_pts = 0;
_nearMen = [];
_mash = nearestObject [_pos, "MASH_EP1"];
while {alive _mash} do {
  {
    if (alive _x && side _x == west && damage _x != 0) then    {
      _damage = damage _x;
      _damage = _damage - 0.01;
      if (_damage < 0) then {
        _damage = 0;
      };
      _x setDamage _damage;
    };
  } forEach ((getPos _mash) nearEntities [["Man"], _radius]);
  sleep 2;
};
