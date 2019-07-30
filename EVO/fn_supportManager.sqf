private ["_spendable","_lastSpendable"];
hasCas = false;
hasArty = false;
hasMortar = false;
hasRocket = false;
hasRessuply = false;
hasUAV = false;
spendable = 0;
lastSpendable = 0;
  spendable = [player] call EVO_fnc_supportPoints;
  if (spendable != lastSpendable) then {
    if (spendable >= 4 && !hasMortar) then {
      uavComm = [player, "uavRequest"] call BIS_fnc_addCommMenuItem;
      hasUAV = true;
    };
    if (spendable >= 5 && !hasMortar) then {
      mortarStrikeComm = [player, "mortarStrike"] call BIS_fnc_addCommMenuItem;
      hasMortar = true;
    };

    if (spendable >= 6 && !hasArty) then {
      artyStrikeComm = [player, "artyStrike"] call BIS_fnc_addCommMenuItem;
      hasArty = true;
    };

    if (spendable >= 7 && !hasCas) then {
      casStrikeComm = [player, "fixedCasStrike"] call BIS_fnc_addCommMenuItem;
      hasCas = true;
    };

    if (spendable >= 8 && !hasRocket) then {
      rocketStrikeComm = [player, "rocketStrike"] call BIS_fnc_addCommMenuItem;
      hasRocket = true;
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
      hasMortar = false;
    };

    if (_spendable < 6) then {
      [player, artyStrikeComm] call BIS_fnc_removeCommMenuItem;
      hasArty = false;
    };

    if (_spendable < 7) then {
      [player, casStrikeComm] call BIS_fnc_removeCommMenuItem;
      hasCas = false;
    };

    if (_spendable < 8) then {
      [player, rocketStrikeComm] call BIS_fnc_removeCommMenuItem;
      hasRocket = false;
    };

    if (_spendable < 9) then {

    };

    if (_spendable < 10) then {

    };

    lastSpendable = spendable;
  };
