private ["_vehicle","_msg","_mhq"];
if (!isServer) exitWith {};

_vehicle = [_this, 0, objNull] call BIS_fnc_param;

if (_vehicle == objNull) exitWith {["_vehicle can't be objNull."] call BIS_fnc_error};
MHQ = _vehicle;
publicVariable "MHQ";
[[],{
  MHQ addaction ["<t color='#CCCC00'>Go to HQ</t>", "[_this select 1, spawnBuilding] call BIS_fnc_moveToRespawnPosition", nil,1,false,true,"","alive MHQ && isTouchingGround MHQ && canMove MHQ"];
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
waitUntil {canMove MHQ; sleep 5;};
[WEST, MHQ, "Mobile HQ"] call BIS_fnc_addRespawnPosition;
"mhqMarker" setMarkerAlpha 0.75;
[[],{
  sleep 5;
  _msg = format ["The MHQ is available at map grid %1.", mapGridPosition MHQ];
  ["deployed",["MHQ AVAILABLE", _msg]] call BIS_fnc_showNotification;
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
[MHQ] spawn {
  _mhq = _this select 0;
  while {alive _mhq} do {
    "mhqMarker" setMarkerPos (getPos _mhq);
    sleep 1;
  };
  "mhqMarker" setMarkerAlpha 0;
  [[],{
    sleep 5;
    _msg = format ["The MHQ has been destroyed at map grid %1.", mapGridPosition MHQ];
    ["deployed",["MHQ DESTROYED", _msg]] call BIS_fnc_showNotification;
  },"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
};
