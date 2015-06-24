private ["_spendable","_lastSpendable"];
_hasCas = false;
_hasArty = false;
_hasMortar = false;
_hasRocket = false;
_hasRessuply = false;
_hasUAV = false;
_hasUGV = false;
_spendable = 0;
_lastSpendable = 0;
while {true} do {
  sleep 10;
  _spendable = [player] call EVO_fnc_supportPoints;
  if (_spendable != _lastSpendable) then {
    if (_spendable >= 5 && !_hasMortar) then {
      resupplyComm = [player, "resupply"] call BIS_fnc_addCommMenuItem;
      _hasRessuply = true;
      //transport?
      mortarStrikeComm = [player, "mortarStrike"] call BIS_fnc_addCommMenuItem;
      _hasMortar = true;
    };

    if (_spendable >= 6 && !_hasArty) then {
      //mortar?
      uavComm = [player, "uavRequest"] call BIS_fnc_addCommMenuItem;
      _hasUAV = true;
      artyStrikeComm = [player, "artyStrike"] call BIS_fnc_addCommMenuItem;
      _hasArty = true;
    };

    if (_spendable >= 7 && !_hasCas) then {
      //cas?
      ugvComm = [player, "ugvRequest"] call BIS_fnc_addCommMenuItem;
      _hasUGV = true;
      casStrikeComm = [player, "fixedCasStrike"] call BIS_fnc_addCommMenuItem;
      _hasCas = true;
    };

    if (_spendable >= 8 && !_hasRocket) then {
      rocketStrikeComm = [player, "rocketStrike"] call BIS_fnc_addCommMenuItem;
      _hasRocket = true;
    };

    if (_spendable >= 9) then {
      //arty?
    };

    if (_spendable >= 10) then {
      //icbm?
    };

    //
    //
    //

    if (_spendable < 5) then {
      [player, mortarStrikeComm] call BIS_fnc_removeCommMenuItem;
      _hasMortar = false;
      [player, resupplyComm] call BIS_fnc_removeCommMenuItem;
      _hasRessuply = false;
    };

    if (_spendable < 6) then {
      [player, uavComm] call BIS_fnc_removeCommMenuItem;
      _hasUAV = false;
      [player, artyStrikeComm] call BIS_fnc_removeCommMenuItem;
      _hasArty = false;
    };

    if (_spendable < 7) then {
      [player, ugvComm] call BIS_fnc_removeCommMenuItem;
      _hasUGV = false;
      [player, casStrikeComm] call BIS_fnc_removeCommMenuItem;
      _hasCas = false;
    };

    if (_spendable < 8) then {
      [player, rocketStrikeComm] call BIS_fnc_removeCommMenuItem;
      _hasRocket = false;
    };

    if (_spendable < 9) then {

    };

    if (_spendable < 10) then {

    };

    _lastSpendable = _spendable;
  };
};
