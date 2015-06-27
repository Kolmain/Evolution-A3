_gun = _this select 0;
_pos = _this select 1;
_rounds = _this select 2;

_gun setVehicleAmmoDef 1;
_magazine = currentMagazine _gun;
_gun doArtilleryFire [_pos, _magazine, _rounds];
true;
