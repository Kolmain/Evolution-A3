if (!isServer) exitWith {};

_vehicle = _this select 0;
MHQ = _vehicle;
publicVariable "MHQ";
[WEST, MHQ, "Mobile HQ"] call BIS_fnc_addRespawnPosition;
mhqMarker setMarkerAlpha 1;
[[],{
  sleep 5;
  _msg = format ["The MHQ is available at map grid %1.", mapGridPosition MHQ];
  ["deployed",["MHQ AVAILABLE", _msg]] call BIS_fnc_showNotification;
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
[MHQ] spawn {
  _mhq = _this select 0;
  while {alive _mhq} do {
    mhqMarker setMarkerPos (getPos _mhq);
    sleep 1;
  };
  mhqMarker setMarkerAlpha 0;
  [[],{
    sleep 5;
    _msg = format ["The MHQ has been destroyed at map grid %1.", mapGridPosition MHQ];
    ["deployed",["MHQ DESTROYED", _msg]] call BIS_fnc_showNotification;
  },"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
};
