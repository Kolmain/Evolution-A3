/*=================================================================================================================
  GVS Triggers by Jacmac

  Version History:
  A - Initial Release 10/13/2013
  B - Removed isServer checks on trigger creation 10/13/2013
  C - Added UAV Service Trigger 10/19/2013

  Requirements:
  Called once from gvs_init.sqf on startup.

  Features:
  -Generates GVS Triggers for Ground Vehicles, Helecopters, and Planes
  -Generates Event handlers for display of the trigger locations when a player is within a vehicle
  
  Notes:
  Trigger location display is:
  Null on foot
  500 meters in Ground Vehicles
  1K in Helecopters
  2K in Planes
  
  The trigger variables can be adjusted, but keep in mind that sounds are fixed in duration, so adjusting a
  a setting like _veh_per_fuel_time to some value other than 2 seconds will throw off the sound loop. Sounds
  for ammo or repair ar not so much affected but times that are too low, may cause sounds to play on top of
  each other.

=================================================================================================================*/

//The variables below can be adjusted with caution
_veh_trigger_diameter = 8;
_hel_trigger_diameter = 10;
_pla_trigger_diameter = 12;
_uav_trigger_diameter = 8;

_veh_maxDistance = 6;		//distance from trigger that will cause abort
_veh_maxHeight = 1;			//height above trigger that will cause abort
_veh_serviceStartDelay = 8; //seconds before service starts (can abort in this time)
_veh_per_fuel_time = 2;		//seconds per percent of fuel
_veh_per_repair_time = 6;	//seconds per percent of repair
_veh_per_magazine_time = 8;	//seconds per magazine reload

_hel_maxDistance = 8;
_hel_maxHeight = 4;
_hel_serviceStartDelay = 8;
_hel_per_fuel_time = 2;
_hel_per_repair_time = 6;
_hel_per_magazine_time = 8;

_pla_maxDistance = 8;
_pla_maxHeight = 6;
_pla_serviceStartDelay = 10;
_pla_per_fuel_time = 2;
_pla_per_repair_time = 6;
_pla_per_magazine_time = 8;

_uav_maxDistance = 6;
_uav_maxHeight = 2;
_uav_serviceStartDelay = 8;
_uav_per_fuel_time = 2;
_uav_per_repair_time = 6;
_uav_per_magazine_time = 8;

//Do not adjust below here, unless you know what you're doing...
_veh = 0;
_hel = 0;
_pla = 0;
_uav = 0;

{
	_marker = _x;
	_marPos = getMarkerPos _marker;

	if (([_x, "gvs_veh"] call String_Search) == 0) then
	{
		if (isNil (format ["Public_gvs_veh_%1", _veh])) then {call compile format ["Public_gvs_veh_%1 = 0", _veh]};

        call compile format ["addMissionEventHandler [""Draw3D"", {
            _pos = getMarkerPos ""%1"";
            _distp = player distance _pos;
            if (_distp < 500 and (vehicle player isKindOf ""LandVehicle"")) then {
                _scale = 0.0251 - (_distp / 20000);
                _pos set [2, 2 + (_distp * 0.05)];
                _alpha = _distp / 500;
                _texture = format [""#(rgb,1,1,1)color(0.5,0.5,0.5,%2)"", _alpha];
                _texture = ""\A3\ui_f\data\map\markers\nato\b_armor.paa"";
                if (_distp < 250) then {
                    _alpha = 1.001 - (_distp / 500);
                };
                _color = [0.85,0.65,0.13,_alpha];
                drawIcon3D [_texture, _color, _pos, 0.5, 0.5, 0, ""Ground Vehicle Service"", 1, _scale, ""TahomaB""];
            };
        }];", _marker, "%1"];  

		_con = format ["Public_gvs_veh_%1 == 0 and ({player == driver _x and _x isKindOf ""LandVehicle""} count thislist == 1)", _veh];
		_act = format ["Public_gvs_veh_%1 = 1; publicVariable ""Public_gvs_veh_%1""; _nul = [""Public_gvs_veh_%1"", thislist, getPos thisTrigger, %2, %3, %4, %5, %6, %7] execVM ""gvs\generic_vehicle_service.sqf""", _veh, _veh_maxDistance, _veh_maxHeight, _veh_serviceStartDelay, _veh_per_fuel_time, _veh_per_repair_time, _veh_per_magazine_time];
		_trg = createTrigger["EmptyDetector", _marPos];
		_trg setTriggerArea[_veh_trigger_diameter, _veh_trigger_diameter, 0, false];
		_trg setTriggerActivation["ANY", "PRESENT", true];
		_trg setTriggerStatements[_con, _act, ""];

		_veh = _veh + 1;	
	};

	if (([_x, "gvs_hel"] call String_Search) == 0) then
	{
		if (isNil (format ["Public_gvs_hel_%1", _hel])) then {call compile format ["Public_gvs_hel_%1 = 0", _hel]};

        call compile format ["addMissionEventHandler [""Draw3D"", {
            _pos = getMarkerPos ""%1"";
            _distp = player distance _pos;
            if (_distp < 1000 and (vehicle player isKindOf ""Helicopter"")) then {
                _scale = 0.0201 - (_distp / 50000);
                _pos set [2, 2 + (_distp * 0.05)];
                _alpha = _distp / 500;
                _texture = format [""#(rgb,1,1,1)color(0.5,0.5,0.5,%2)"", _alpha];
                _texture = ""\A3\ui_f\data\map\markers\nato\b_air.paa"";
                if (_distp < 500) then {
                    _alpha = 1.001 - (_distp / 1000);
                };
                _color = [0.25,0.50,0.10,_alpha];
                drawIcon3D [_texture, _color, _pos, 0.5, 0.5, 0, ""Helicopter Service"", 1, _scale, ""TahomaB""];
            };
        }];", _marker, "%1"];  

		_con = format ["Public_gvs_hel_%1 == 0 and ({player == driver _x and _x isKindOf ""Helicopter""} count thislist == 1)", _hel];
		_act = format ["Public_gvs_hel_%1 = 1; publicVariable ""Public_gvs_hel_%1""; _nul = [""Public_gvs_hel_%1"", thislist, getPos thisTrigger, %2, %3, %4, %5, %6, %7] execVM ""gvs\generic_vehicle_service.sqf""", _hel, _hel_maxDistance, _hel_maxHeight, _hel_serviceStartDelay, _hel_per_fuel_time, _hel_per_repair_time, _hel_per_magazine_time];
		_trg = createTrigger["EmptyDetector", _marPos];
		_trg setTriggerArea[_hel_trigger_diameter, _hel_trigger_diameter, 0, false];
		_trg setTriggerActivation["ANY", "PRESENT", true];
		_trg setTriggerStatements[_con, _act, ""];	

		_hel = _hel + 1;	
	};	
	
	if (([_x, "gvs_pla"] call String_Search) == 0) then
	{
		if (isNil (format ["Public_gvs_pla_%1", _pla])) then {call compile format ["Public_gvs_pla_%1 = 0", _pla]};

        call compile format ["addMissionEventHandler [""Draw3D"", {
            _pos = getMarkerPos ""%1"";
            _distp = player distance _pos;
            if (_distp < 2000 and (vehicle player isKindOf ""Plane"")) then {
                _scale = 0.0201 - (_distp / 100000);
                _pos set [2, 2 + (_distp * 0.05)];
                _alpha = _distp / 2000;
                _texture = format [""#(rgb,1,1,1)color(0.5,0.5,0.5,%2)"", _alpha];
                _texture = ""\A3\ui_f\data\map\markers\nato\b_plane.paa"";
                if (_distp < 1000) then {
                    _alpha = 1.001 - (_distp / 2000);
                };
                _color = [0.80,0.20,0.05,_alpha];
                drawIcon3D [_texture, _color, _pos, 0.5, 0.5, 0, ""Plane Service"", 1, _scale, ""TahomaB""];
            };
        }];", _marker, "%1"];  

		_con = format ["Public_gvs_pla_%1 == 0 and ({player == driver _x and _x isKindOf ""Plane""} count thislist == 1)", _pla];
		_act = format ["Public_gvs_pla_%1 = 1; publicVariable ""Public_gvs_pla_%1""; _nul = [""Public_gvs_pla_%1"", thislist, getPos thisTrigger, %2, %3, %4, %5, %6, %7] execVM ""gvs\generic_vehicle_service.sqf""", _pla, _pla_maxDistance, _pla_maxHeight, _pla_serviceStartDelay, _pla_per_fuel_time, _pla_per_repair_time, _pla_per_magazine_time];
		_trg = createTrigger["EmptyDetector", _marPos];
		_trg setTriggerArea[_pla_trigger_diameter, _pla_trigger_diameter, 0, false];
		_trg setTriggerActivation["ANY", "PRESENT", true];
		_trg setTriggerStatements[_con, _act, ""];	
			
		_pla = _pla + 1;	
	};	
	
	if (([_x, "gvs_uav"] call String_Search) == 0) then
	{
		if (isNil (format ["Public_gvs_uav_%1", _uav])) then {call compile format ["Public_gvs_uav_%1 = 0", _uav]};

        call compile format ["addMissionEventHandler [""Draw3D"", { 
            _controlledUAV = vehicle player;
            _inUAV = 0;
            {
            	if (([str ((uavControl _x) select 0), str player] call String_Search) != -1 and (uavControl _x) select 1 == ""DRIVER"") then
				{
					_controlledUAV = _x;
					_inUAV = 1;
				};
            }forEach allUnitsUav;
            _pos = getMarkerPos ""%1"";
            _distp = _controlledUAV distance _pos;

            if (_distp < 2000 and _inUAV == 1) then {
                _scale = 0.0201 - (_distp / 100000);
                _pos set [2, 2 + (_distp * 0.05)];
                _alpha = _distp / 2000;
                _texture = format [""#(rgb,1,1,1)color(0.5,0.5,0.5,%2)"", _alpha];
                _texture = ""\A3\ui_f\data\map\markers\nato\b_uav.paa"";
                if (_distp < 1000) then {
                    _alpha = 1.001 - (_distp / 2000);
                };
                _color = [0.80,0.20,0.85,_alpha];
                drawIcon3D [_texture, _color, _pos, 0.5, 0.5, 0, ""UAV Service"", 1, _scale, ""TahomaB""];
            };
        }];", _marker, "%1"];  

		_con = format ["Public_gvs_uav_%1 == 0 and ({(([str ((uavControl _x) select 0), str player] call String_Search) != -1) and _x isKindOf ""UAV""} count thislist == 1)", _uav];
		_act = format ["Public_gvs_uav_%1 = 1; publicVariable ""Public_gvs_uav_%1""; _nul = [""Public_gvs_uav_%1"", thislist, getPos thisTrigger, %2, %3, %4, %5, %6, %7] execVM ""gvs\generic_vehicle_service.sqf""", _uav, _uav_maxDistance, _uav_maxHeight, _uav_serviceStartDelay, _uav_per_fuel_time, _uav_per_repair_time, _uav_per_magazine_time];
		_trg = createTrigger["EmptyDetector", _marPos];
		_trg setTriggerArea[_uav_trigger_diameter, _uav_trigger_diameter, 0, false];
		_trg setTriggerActivation["ANY", "PRESENT", true];
		_trg setTriggerStatements[_con, _act, ""];	
			
		_uav = _uav + 1;	
	};	
}forEach allMapMarkers;


	{
		if (([str ((uavControl _x) select 0), str player] call String_Search) != -1) then
		{
			systemChat str ((uavControl _x) select 0);
			systemChat ((uavControl _x) select 1);
		};
	}forEach allUnitsUav;