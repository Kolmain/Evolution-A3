private ["_weaponArray","_return","_weapon","_muzzles","_mags"];
_weaponArray = _this;
_return = [];
{
    _weapon = _x;
    _muzzles = getArray(configfile >> "cfgWeapons" >> (_weapon) >> "muzzles");

    {
        if (_x isEqualTo "this") then
        {
            _mags = getArray(configfile >> "cfgWeapons" >> (_weapon) >> "magazines");
            _return = _return + _mags;
        }
        else
        {
            _mags = getArray(configfile >> "cfgWeapons" >> (_weapon) >> _x >> "magazines");
            _return = _return + _mags;
        };
    } forEach _muzzles;
} forEach _weaponArray;

_return = _return + ["HandGrenade", "SmokeShell", "SmokeShellBlue", "Chemlight_blue", "B_IR_Grenade", "DemoCharge_Remote_Mag"];


_return
