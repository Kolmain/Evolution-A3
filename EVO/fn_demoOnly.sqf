private ["_radio"];

_radio = _this select 0;

_radio addEventHandler [ "HandleDamage", {
    _tower = _this select 0;
    _projectile = _this select 4;
    
    if !( _projectile isKindOf "PipeBombBase" ) then {
        damage _tower;
    };
}];  
