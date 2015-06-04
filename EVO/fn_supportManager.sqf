_spendable = 0;
while {true} do {
  sleep 10;
  _spendable = [player] call EVO_fnc_supportPoints;
  
  if (_spendable >= 5) then {
    //ammo?
    //transport?
  };
  
  if (_spendable >= 6) then {
    //mortar?
  };
  
  if (_spendable >= 7) then {
    //cas?
  };
  
  if (_spendable >= 8) then {
    //rocket?
  };
  
  if (_spendable >= 9) then {
    //arty?
  };
  
  if (_spendable >= 10) then {
    //icbm?
  };
};
