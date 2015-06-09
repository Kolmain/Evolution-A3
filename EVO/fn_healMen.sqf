private ["_pos","_radius","_nearMen","_mash","_damage"];
_pos = _this select 0;
_radius = _this select 1;
_player = _this select 2;
_pts = 0;
_nearMen = [];
_mash = nearestObject [_pos, "Land_Medevac_house_V1_F"];
while {alive _mash} do {
  {
    _pts = _player getVariable ["EVO_healingPts", 0];
    if (alive _x && side _x == west && damage _x != 0) then    {
      _damage = damage _x;
      _damage = _damage - 0.01;
      if (_damage < 0) then {
        _damage = 0;
      };
      _x setDamage _damage;
      _pts = _pts + 0.01;
      player setVariable ["EVO_healingPts", _pts, true];
    };
  } forEach ((getPos _mash) nearEntities [["Man"], _radius]);
  sleep 2;
};
