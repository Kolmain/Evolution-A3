/*
    Filename: Simple ParaDrop Script v0.8 Beta eject.sqf
    Author: Beerkan:
    Additional contributions cobra4v320

    Description:
     A simple paradrop script that ejects all units assigned as cargo onboard, including players and AI (excluding crew) regardless of group assignments, side etc.
     If you're in the aircraft you're getting thrown out.

    Parameter(s):
    0: VEHICLE  - vehicle that will be doing the paradrop (object)
    1: ALTITUDE - (optional) the altitude where the group will open their parachute (number)

    Example:
    _drop = [vehicle, altitude] execVM "eject.sqf"
*/

if (!isServer && hasInterface) exitWith {};
private ["_vehicle","_chuteheight","_paras","_dir"];
_vehicle = _this select 0;
_chuteheight = 150;
_paras = assignedcargo _vehicle;
_dir = direction _vehicle;
[_paras] allowGetIn false;

paraLandSafe =
{
    private ["_unit"];
    _unit = _this select 0;
    (vehicle _unit) allowDamage false;// Set parachute invincible to prevent exploding if it hits buildings
    waitUntil {isTouchingGround _unit || (position _unit select 2) < 1 };
    _unit allowDamage false;
    _unit action ["EJECT", vehicle _unit];
    _unit setvelocity [0,0,0];
    sleep 1;// Para Units sometimes get damaged on landing. Wait to prevent this.
    _unit allowDamage true;
};

{
    _x disableCollisionWith _vehicle;
    _x allowdamage false;
    unassignvehicle _x;
    _x action ["GETOUT", _vehicle];
    _x setDir (_dir + 90);
    sleep 0.35;//So units are not too far spread out when they land.
} forEach _paras;

{
    waitUntil {(position _x select 2) <= _chuteheight};
    if (vehicle _x != _x) exitWith {};
    _chute = createVehicle ["Steerable_Parachute_F", position _x, [], ((_dir)- 5 + (random 10)), 'FLY'];
    _chute setPos (getPos _x);
    _x assignAsDriver _chute;
    _x moveIndriver _chute;
    _x allowdamage true;
} forEach _paras;

{
  [_x] spawn paraLandSafe;
} forEach _paras;