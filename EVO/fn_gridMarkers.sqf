private ["_pos","_px","_py","_nam","_col"];
gridmarkers = [];
startAlpha = 0.2;
changeAlpha = 0.2;
while {true} do {
  {deleteMarkerLocal _x;} count gridmarkers;
  gridmarkers = [];
  {
    if ( !((side _x) isEqualTo civilian) ) then {
      _pos = getPosATL _x;
      _px = floor ( (_pos select 0) / 100);
      _py = floor ( (_pos select 1) / 100);
      _nam = format["grid_%1_%2",_px,_py];
      _col = format["Color%1",side _x];
      if ( (markerShape _nam) isEqualTo "RECTANGLE" ) then {
        if ( ((markerColor _nam) isEqualTo _col) ) then {
          _nam setMarkerAlphaLocal ( (markerAlpha _nam) + changeAlpha);
        } else {
          _nam setMarkerColorLocal "ColorOrange";
          _nam setMarkerAlphaLocal ( (markerAlpha _nam) + changeAlpha);
        };
      } else {
        createMarkerLocal[_nam,[(_px*100)+50,(_py*100)+50,0]];
        _nam setMarkerShapeLocal "RECTANGLE";
        _nam setMarkerSizeLocal [50,50];
        _nam setMarkerColorLocal _col;
        _nam setMarkerAlpha startAlpha;
        gridmarkers pushBack _nam;
      };
    };
    true
  } count currentAOunits;
  sleep 10;
};
