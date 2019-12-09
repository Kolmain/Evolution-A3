_vehicle = [_this, 0, objNull] call BIS_fnc_param;
if (_vehicle == objNull) exitWith {};
if (isNil ("casMarker")) then {
  casMarker = createMarker ["casMarker", position _vehicle];
  "casMarker" setMarkerShape "ICON";
  "casMarker" setMarkerColor "ColorOPFOR";
  "casMarker" setMarkerType "o_plane";
  "casMarker" setMarkerDir 0;
  "casMarker" setMarkerPos (getPos _vehicle);
  "casMarker" setMarkerText "OPFOR CAS";
  publicVariable "casMarker";
};
while {alive _vehicle && canMove _vehicle} do {
  "casMarker" setMarkerPos (getPos _vehicle);
  sleep 1;
};

