// Load Virtual Arsenal into Respawn Inventory
_arsenalNames = [];
_arsenalDataLocal = [];
_arsenalData = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];

for "_i" from 0 to (count _arsenalData - 1) step 2 do {
    _name = _arsenalData select _i;
    _arsenalDataLocal = _arsenalDataLocal + [_name,_arsenalData select (_i + 1)];
    _nul = _arsenalNames pushBack ( format[ "missionnamespace:%1", _name ] );
};
missionnamespace setvariable ["bis_fnc_saveInventory_data",_arsenalDataLocal];
[player,_arsenalNames] call bis_fnc_setrespawninventory;