if (not (local player)) exitwith {};
_player = player;

removeAllWeapons _player;
{player addmagazine _x} forEach pallammo;
{player addweapon _x} forEach pweapons;
player selectweapon (primaryWeapon player);

//_newaction = (vehicle player) addaction ["My Squad", "TeamStatusDialog\TeamStatusDialog.sqf",[2,2],1, false, true,"test2"];
_player addEventHandler ["killed", {handle = [(_this select 0),(_this select 1)] execVM "scripts\killed.sqf"}];

if (player isKindOf "SoldierWMedic") then {_actionId8 = player addAction ["Build MASH", "actions\mtent.sqf",0,1, false, true,"test2"]};
if (player isKindOf "SoldierWMiner") then {_actionId8 = player addAction ["Build FARP", "actions\etent.sqf",0,1, false, true,"test2"]};















