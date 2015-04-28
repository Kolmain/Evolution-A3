CHHQ_fnc_deploy = {
	_veh = _this select 0;
	_caller = _this select 1;
	_side = _this select 3 select 0;
	_cargoInfo = _this select 3 select 1;
	_composition = _this select 3 select 2;
	_cargo = _veh getVariable ["CHHQ_cargo", objNull];

	if (_veh getVariable ["CHHQ_compositionRadius", -1] < 0) then {
		_sortedByDist = [_composition,[],{
			_frstNum = abs (_x select 1 select 0);
			_secNum = abs (_x select 1 select 1);
			if (_frstNum > _secNum) then {_frstNum} else {_secNum}
		},"DESCEND"] call BIS_fnc_sortBy;
		_biggestOffset = (_sortedByDist select 0) select 1;
		_biggestOffsetAbs = if (abs (_biggestOffset select 0) > abs (_biggestOffset select 1)) then {abs (_biggestOffset select 0)} else {abs (_biggestOffset select 1)};

		_boundingSize = [_sortedByDist select 0 select 0] call CHHQ_fnc_boundingSize;
		_radius = _biggestOffsetAbs + _boundingSize;

		_sortedBySize = [_composition,[],{sizeOf (_x select 0)},"DESCEND"] call BIS_fnc_sortBy;
		_boundingSize = [_sortedBySize select 0 select 0] call CHHQ_fnc_boundingSize;

		if (_boundingSize > _radius) then {
			_radius = _boundingSize;
		};
		_veh setVariable ["CHHQ_compositionRadius", _radius, true];
	};
	_radius = _veh getVariable ["CHHQ_compositionRadius", -1];

	_flatPos = (getPosASL _veh) isFlatEmpty [
		_radius,	//--- Minimal distance from another object
		0,				//--- If 0, just check position. If >0, select new one
		0.4,			//--- Max gradient
		_radius max 5,	//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,			//--- Has to have shore nearby!
		objNull			//--- Ignored object
	];

	if (count _flatPos isEqualTo 0) exitWith {
		_msg = format ["You can't deploy a MHQ on uneven terrain."];
		["deployed",["MHQ NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
	};
	if (player distance spawnBuilding < 800) exitWith {
		_msg = format ["You can't deploy a MHQ in the base."];
		["deployed",["MHQ NOT DEPLOYED", _msg]] call BIS_fnc_showNotification;
	};
	if (_veh getVariable ["CHHQ_inProgress", false]) exitWith {};

	_veh setVariable ["CHHQ_inProgress", true, true];

	[[_veh], "CHHQ_fnc_removeAction", _side] call BIS_fnc_MP;
	_nearestPlayers = [];
	{
		if (isPlayer _x && _x distance _veh < 25) then {
			_nearestPlayers pushBack _x
		};
	} forEach (playableUnits + switchableUnits);
	[["CHHQ_deployBlackout"],"BIS_fnc_blackOut",_nearestPlayers,false,true] call BIS_fnc_MP;
	[["DEPLOYING HQ"],"BIS_fnc_dynamicText",_nearestPlayers] call BIS_fnc_MP;
	sleep 3;
	{moveOut _x} forEach crew _veh;
	{_x allowDamage false; _x enableSimulationGlobal false} forEach _nearestPlayers;

	deleteVehicle _cargo;

	_veh enableSimulationGlobal false;
	_veh allowDamage false;

	[[_veh, _side, "HQ"],"CHHQ_fnc_drawMarker",_side] call BIS_fnc_MP;
	_objArray = [];
	{
		_type = _x select 0;
		_offset = _x select 1;
		_newdir = _x select 2;
		_code = [_x, 3, "", ["", {}]] call BIS_fnc_param;

		_obj = createVehicle [_type, [0,0,0], [], 0, "CAN_COLLIDE"];
		_obj allowDamage false;
		[_veh,_obj,_offset,_newdir, true, true] call BIS_fnc_relPosObject;
		_objArray pushBack _obj;

		if !(_code isEqualTo "") then {
			_code = [_code] call CHHQ_fnc_compileCode;
			[[[_obj,_veh], _code],"BIS_fnc_spawn",true] call BIS_fnc_MP;
		};
	} forEach _composition;

	/*
	_grp = createGroup _side;
	_unitType = switch _side do {
		case east: {"O_soldier_F"};
		case west: {"B_soldier_F"};
		case resistance: {"I_soldier_F"};
		default {"C_man_1"};
	};
	_unit = _grp createUnit [_unitType, [0,0,0], [], 0, "NONE"];
	[[_unit,{hideObject _this}],"BIS_fnc_spawn",true] call BIS_fnc_MP;
	_unit moveInCargo _veh;
	_veh setPilotLight false;
	_veh setCollisionLight false;
	_veh engineOn false;
	_grp setBehaviour "CARELESS";
	{_unit disableAI _x} forEach ["MOVE","TARGET","AUTOTARGET","ANIM","FSM"];
	_objArray pushBack _unit;
	*/

	[[_veh, 2],"lock",true] call BIS_fnc_MP;

	_veh enableSimulationGlobal true;
	_veh allowDamage true;
	{_x allowDamage true} forEach _objArray;
	{_x setPos ((getPosASL _x) findEmptyPosition [0, 25, "CAManBase"]); _x allowDamage true; _x enableSimulationGlobal true} forEach _nearestPlayers;

	sleep 3;
	[["CHHQ_deployBlackout"],"BIS_fnc_blackIn",_nearestPlayers,false,true] call BIS_fnc_MP;
	[[_veh, ["Packup HQ", "_this spawn CHHQ_fnc_undeploy", [_side, _cargoInfo, _composition], 0, false, true, "", "[_target, _this] call CHHQ_fnc_actionConditions"]], "CHHQ_fnc_addAction", _side] call BIS_fnc_MP;

	_veh setVariable ["CHHQ_inProgress", false, true];
	_veh setVariable ["CHHQ_deployed", true, true];
	_veh setVariable ["CHHQ_objArray", _objArray, true];
	[[_veh], "CHHQ_fnc_deleteVehicleEH", false] call BIS_fnc_MP;
};
CHHQ_fnc_undeploy = {
	_veh = _this select 0;
	_caller = _this select 1;
	_side = _this select 3 select 0;
	_cargoInfo = _this select 3 select 1;
	_cargoType = _cargoInfo select 0;
	_cargoOffset = _cargoInfo select 1;
	_cargoDir = _cargoInfo select 2;
	_cargoCode = [_cargoInfo, 3, "", ["", {}]] call BIS_fnc_param;
	_composition = _this select 3 select 2;

	if (_veh getVariable ["CHHQ_inProgress", false]) exitWith {};
	_veh setVariable ["CHHQ_inProgress", true, true];

	[[_veh], "CHHQ_fnc_removeAction", _side] call BIS_fnc_MP;

	_nearestPlayers = [];
	{
		if (isPlayer _x && _x distance _veh < 25) then {
			_nearestPlayers pushBack _x
		};
	} forEach (playableUnits + switchableUnits);
	[["CHHQ_deployBlackout"],"BIS_fnc_blackOut",_nearestPlayers,false,true] call BIS_fnc_MP;
	[["UNDEPLOYING HQ"],"BIS_fnc_dynamicText",_nearestPlayers] call BIS_fnc_MP;
	sleep 3;
	{_x allowDamage false; _x enableSimulationGlobal false} forEach _nearestPlayers;

	{deleteVehicle _x} forEach (_veh getVariable ["CHHQ_objArray", []]);
	_veh setVariable ["CHHQ_deployed", false, true];

	[[_veh, _side, "MHQ"],"CHHQ_fnc_drawMarker",_side] call BIS_fnc_MP;
	[[_veh, false],"lock",true] call BIS_fnc_MP;
	[[_veh, true],"lockCargo",true] call BIS_fnc_MP;
	[[_veh, [0,false]],"lockCargo",true] call BIS_fnc_MP;

	_cargo = createVehicle [_cargoType, [0,0,0], [], 0, "CAN_COLLIDE"];
	_cargo attachTo [_veh, _cargoOffset];

	_veh setPos (getPos _veh);
	_veh setDir (getDir _veh);
	_cargo setDir _cargoDir;
	_veh setVariable ["CHHQ_cargo", _cargo, true];

	if !(_cargoCode isEqualTo "") then {
		_cargoCode = [_cargoCode] call CHHQ_fnc_compileCode;
		[[[_cargo,_veh], _cargoCode],"BIS_fnc_spawn",true] call BIS_fnc_MP;
	};

	sleep 3;
	_veh enableSimulationGlobal true;
	_veh allowDamage true;
	{_x setPos ((getPosASL _x) findEmptyPosition [0, 25, "CAManBase"]); _x allowDamage true; _x enableSimulationGlobal true} forEach _nearestPlayers;
	[["CHHQ_deployBlackout"],"BIS_fnc_blackIn",_nearestPlayers,false,true] call BIS_fnc_MP;
	[[_veh,["Deploy HQ", "_this spawn CHHQ_fnc_deploy", [_side, _cargoInfo, _composition], 0, false, true, "", "[_target, _this] call CHHQ_fnc_actionConditions"]], "CHHQ_fnc_addAction", _side] call BIS_fnc_MP;

	_veh setVariable ["CHHQ_inProgress", false, true];
	[[_veh, "cargo"], "CHHQ_fnc_deleteVehicleEH", false] call BIS_fnc_MP;
};
CHHQ_fnc_boundingSize = {
	_type = _this select 0;
	_bbdummy = _type createVehicleLocal [0,0,0];
	_boundingBox = (boundingBox _bbdummy) select 1;
	deleteVehicle _bbdummy;
	_boundingSize = if (_boundingBox select 0 > _boundingBox select 1) then {_boundingBox select 0} else {_boundingBox select 1};
	_boundingSize
};
CHHQ_fnc_compileCode = {
	_code = [_this, 0, "", ["", {}]] call BIS_fnc_param;

	if (toLower typeName _code == "code") then {
		_array = toArray str _code;
		_array deleteAt 0;
		_array deleteAt count _array - 1;
		_code = toString _array;
	};
	if !(_code isEqualTo "") then {
		_prefix = "_target = _this select 1; _this = _this select 0; ";
		_code = _prefix + _code;
	};
	compile _code
};
CHHQ_fnc_deleteVehicleEH = {
	_veh = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
	_type = [_this, 1, "", [""]] call BIS_fnc_param;
	_objArray = _veh getVariable ["CHHQ_objArray", []];
	_cargo = _veh getVariable ["CHHQ_cargo", objNull];

	waitUntil {isNull _veh};
	if (_type isEqualTo "cargo") then {
		deleteVehicle _cargo;
	} else {
		{deleteVehicle _x} forEach _objArray;
	};
};
CHHQ_fnc_arrayUpdateEH = {
	_array = _this select 0;
	_code = _this select 1;

	for "_i" from 0 to 1 step 0 do {
		_countArray = count _array;
		waitUntil {count _array != _countArray};
		call _code;
	};
};
CHHQ_fnc_drawMarker = {
	if !(CHHQ_showMarkers) exitWith {};
	private ["_color","_icon","_mrkName"];
	_veh = _this select 0;
	_side = _this select 1;
	_text = _this select 2;
	terminate (_veh getVariable ["CHHQ_drawMarkerHandle", scriptNull]);

	switch _side do {
		case west: {
			_color = "ColorWEST";
			_icon = "b_hq";
		};
		case east: {
			_color = "ColorEAST";
			_icon = "o_hq";
		};
		case resistance: {
			_color = "ColorGUER";
			_icon = "n_hq";
		};
		default {
			_color = "ColorUNKNOWN";
			_icon = "n_hq";
		};
	};

	if (_veh getVariable ["CHHQ_mrkName", ""] isEqualTo "") then {
		_veh setVariable ["CHHQ_mrkName", format ["CHHQ_%1", [str _veh] call BIS_fnc_filterString]];
	};
	_mrkName = _veh getVariable ["CHHQ_mrkName", format ["CHHQ_%1", [str _veh] call BIS_fnc_filterString]];

	if (getMarkerPos _mrkName isEqualTo [0,0,0]) then {
		createMarkerLocal [_mrkName, getPos _veh];
	} else {
		_mrkName setMarkerPosLocal (getPos _veh);
	};
	_mrkName setMarkerShapeLocal "ICON";
	_mrkName setMarkerTypeLocal _icon;
	//_mrkName setMarkerSizeLocal [0.7,0.7];
	_mrkName setMarkerColorLocal _color;

	_handle = [_veh, _mrkName, _text] spawn {
		_veh = _this select 0;
		_mrkName = _this select 1;
		while {alive _veh} do {
			_text = if (count CHHQ_HQarray > 1) then {format ["%1-%2", _this select 2, _veh getVariable ["CHHQ_index", -1]]} else {_this select 2};
			_mrkName setMarkerTextLocal _text;
			_mrkName setMarkerPosLocal (getPos _veh);
			sleep 1;
		};
		deleteMarkerLocal _mrkName;
	};
	_veh setVariable ["CHHQ_drawMarkerHandle", _handle];
};
CHHQ_fnc_addAction = {
	_veh = _this select 0;
	_settings = _this select 1;

	_id = _veh addAction _settings;
	_veh setVariable ["CHHQ_actionID",_id];
};
CHHQ_fnc_removeAction = {
	_obj = _this select 0;
	_obj removeAction (_obj getVariable ["CHHQ_actionID",-1]);
};
CHHQ_fnc_actionConditions = {
	_target = _this select 0;
	_caller = _this select 1;

	(speed _target isEqualTo 0 && {alive _target} && {_caller distance _target < 8} && {vehicle _caller isEqualTo _caller})
};
CHHQ_fnc_teleportActionConditions = {
	_target = _this select 0;
	_caller = _this select 1;
	_veh = _this select 2;

	(_veh getVariable ["CHHQ_deployed", false] && {!isNil "_veh"} && {alive _veh} && {_caller distance _target < 8} && {vehicle _caller isEqualTo _caller})
};
CHHQ_fnc_teleportToHQ = {
	_obj = _this select 0;
	_caller = _this select 1;
	_veh = _this select 3 select 0;

	["CH_teleportToHQblackout"] call BIS_fnc_blackOut;
	sleep 3;
	_caller setPos ((getPosASL _veh) findEmptyPosition [0, 25, "CAManBase"]);
	["CH_teleportToHQblackout"] call BIS_fnc_blackIn;
	[] call CHHQ_fnc_BISshowOSD;
};
CHHQ_fnc_BISshowOSD = {
	/*
		Author: Jiri Wainar

		Description:
		Display OSD with location, time and possibly some other campaign related info.

		Parameter(s):
		_this select 0: array (optional)	- position (default: player's position)
		_this select 1: array (optional)	- date in format [_year,_month,_day,_hour,_min] (default: current date)

		Example:
		[] call BIS_fnc_camp_showOSD;

		Returns:
		- nothing -
	*/

	if (missionNamespace getVariable ["BIS_fnc_camp_showOSD__running",false]) exitWith {};

	BIS_fnc_camp_showOSD__running = true;

	private["_fn_getSector"];

	_fn_getSector =
	{
		private["_map","_posX","_posY","_gridX","_gridY","_secWidth","_secHeight"];
		private["_bottomLeftX","_bottomLeftY","_topRightX","_topRightY"];

		_map = toLower worldName;

		if !(_map in ["altis","stratis"]) exitWith
		{
			-1
		};

		if (_map == "stratis") then
		{
			_bottomLeftX = 1302;
			_bottomLeftY = 230;
			_topRightX   = 6825;
			_topRightY   = 7810;
		}
		else
		{
			_bottomLeftX = 1765;
			_bottomLeftY = 4639;
			_topRightX   = 28624;
			_topRightY   = 26008;
		};

		_posX = _this select 0;
		_posY = _this select 1;

		//check if player is outside the map grid
		if !(_posX > _bottomLeftX && _posX < _topRightX && _posY > _bottomLeftY && _posY < _topRightY) exitWith
		{
			0
		};

		//offset player pos to [0,0]
		_posX      = _posX - _bottomLeftX;
		_posY      = _posY - _bottomLeftY;

		_secWidth  = (_topRightX - _bottomLeftX)/3;
		_secHeight = (_topRightY - _bottomLeftY)/3;

		_gridX = floor (_posX/_secWidth);
		_gridY = floor (_posY/_secHeight);

		((_gridY * 3) + _gridX + 1)
	};


	private["_position","_date","_output","_showDate","_showLocation","_showMap"];
	private["_tLoc","_tMap","_tDate","_tTime","_tTimeH","_tTimeM","_tDay","_tMonth","_tYear"];

	_showDate 	= true;


	_position  	= [_this, 0, getPos player, [[]]] call BIS_fnc_param;
	_date 	   	= [_this, 1, date, [[]]] call BIS_fnc_param;
	_tMap		= [_this, 2, "auto", [""]] call BIS_fnc_param;
	_tLoc		= [_this, 3, "auto", [""]] call BIS_fnc_param;

	//safecheck _date to make sure no values are out of boundries
	_date = _date call BIS_fnc_fixDate;

	if (_tMap != "") then
	{
		_showMap = true;
	}
	else
	{
		_showMap = false;
	};

	if (_tLoc != "") then
	{
		_showLocation = true;
	}
	else
	{
		_showLocation = false;
	};

	//get map text
	if (_showMap && _tMap == "auto") then
	{
		private["_sector","_map","_template"];

		_sector = _position call _fn_getSector;

		if (_sector == -1) then
		{
			["Map not recognized! Only 'Altis' and 'Stratis' are supported."] call BIS_fnc_error;

			_showMap 	= false;
			_showLocation 	= false;
		};

		_map = gettext (configfile >> "cfgworlds" >> worldname >> "description");

		_template = switch (_sector) do
		{
			case 7: {localize "STR_A3_SectorNorthWest"};
			case 8: {localize "STR_A3_SectorNorth"};
			case 9: {localize "STR_A3_SectorNorthEast"};
			case 4: {localize "STR_A3_SectorWest"};
			case 5: {localize "STR_A3_SectorCentral"};
			case 6: {localize "STR_A3_SectorEast"};
			case 1: {localize "STR_A3_SectorSouthWest"};
			case 2: {localize "STR_A3_SectorSouth"};
			case 3: {localize "STR_A3_SectorSouthEast"};

			default
			{
				_showLocation = false;

				//hardcoded for Stratis and Altis only
				if (worldname == "Stratis") then
				{
					localize "STR_A3_NearStratis"
				}
				else
				{
					localize "STR_A3_NearAltis"
				};
			};
		};

		_tMap = format[_template,_map];
	};

	//get current location text
	if (_showLocation && _tLoc == "auto") then
	{
		private["_locations","_loc"];

		_locations = nearestLocations [getPos player, ["NameCity","NameCityCapital","NameLocal","NameMarine","NameVillage"], 500];

		//filter-out locations without names
		{
			if (text _x == "") then
			{
				locations set [_forEachIndex, objNull];
			};
		}
		forEach _locations; _locations = _locations - [objNull];

		if (count _locations > 0) then
		{
			_loc = _locations select 0;

			if ((getPos player) in _loc) then
			{
				_tLoc  = text _loc;
			}
			else
			{
				_tLoc = format[localize "STR_A3_NearLocation", text _loc];		//tolocalize: "Pobl? lokace %1"
			};
		}
		else
		{
			_tLoc = "";
			_showLocation = false;
		};
	};

	//get daytime data
	_tYear 	= _date select 0;
	_tMonth = _date select 1;
	_tDay 	= _date select 2;

	if (_tMonth < 10) then {_tMonth = format["0%1",_tMonth]};
	if (_tDay < 10) then {_tDay = format["0%1",_tDay]};

	//get date text
	_tDate = format["%1-%2-%3 ",_tYear,_tMonth,_tDay];

	//get time text
	_tTimeH = _date select 3;
	_tTimeM = _date select 4;

	if (_tTimeH < 10) then {_tTimeH = format["0%1",_tTimeH]};
	if (_tTimeM < 10) then {_tTimeM = format["0%1",_tTimeM]};

	_tTime = format["%1:%2",_tTimeH,_tTimeM];

	/*
	A3 fonts:

	PuristaLight
	PuristaMedium
	PuristaSemiBold
	PuristaBold
	*/


	//sum the output params & print it
	_output =
	[
		[_tDate,""],
		[_tTime,"font='PuristaMedium'"],["","<br/>"]
	];

	if (_showLocation) then
	{
		_output = _output + [[toUpper _tLoc,""],["","<br/>"]];
	};

	if (_showMap) then
	{
		_output = _output + [[_tMap,""],["","<br/>"]];
	};

	private["_handle"];

	//vertically align to cinematic border
	_handle = [_output,safezoneX - 0.01,safeZoneY + (1 - 0.125) * safeZoneH,true,"<t align='right' size='1.0' font='PuristaLight'>%1</t>"] spawn BIS_fnc_typeText2;

	waitUntil
	{
		scriptDone _handle;
	};

	BIS_fnc_camp_showOSD__running = false;
};
CHHQ_fnc_startingSetup = {
	private ["_cargo"];
	_veh = _this select 0;
	_side = _this select 1;
	_cargoInfo = _this select 2;
	_cargoType = _cargoInfo select 0;
	_cargoOffset = _cargoInfo select 1;
	_cargoDir = _cargoInfo select 2;
	_cargoCode = [_cargoInfo, 3, "", ["", {}]] call BIS_fnc_param;
	_composition = _this select 3;

	if (_veh getVariable ["CHHQ_deployed",false]) then {
		_veh lock 2;

		if (playerSide isEqualTo _side) then {
			{
				_obj = (_veh getVariable ["CHHQ_objArray", []]) select _forEachIndex;
				_code = [_x, 3, "", ["", {}]] call BIS_fnc_param;

				if !(_code isEqualTo "") then {
					_code = [_code] call CHHQ_fnc_compileCode;
					[_obj, _veh] spawn _code;
				};
			} forEach _composition;

			[_veh, _side, "HQ"] call CHHQ_fnc_drawMarker;

			if (isNil "CHHQ_HQarray") then {
				CHHQ_HQarray = [];
			};
			CHHQ_HQarray pushBack _veh;
			if (_veh getVariable ["CHHQ_index", -1] < 0) then {
				_veh setVariable ["CHHQ_index", (CHHQ_HQarray find _veh) + 1, true];
			};

			_id = _veh addAction ["Undeploy HQ", "_this spawn CHHQ_fnc_undeploy", [_side, _cargoInfo, _composition], 0, false, true, "", "[_target, _this] call CHHQ_fnc_actionConditions"];
			_veh setVariable ["CHHQ_actionID",_id];
		};
	} else {
		_veh lock false;
		_veh lockCargo true;
		_veh lockCargo [0, false];
		if (isServer) then {
			_cargo = createVehicle [_cargoType, [0,0,0], [], 0, "NONE"];
			{_x enableSimulation true} forEach [_veh, _cargo];
			_cargo attachTo [_veh, _cargoOffset];

			_veh setPos (getPos _veh);
			_veh setDir (getDir _veh);
			_cargo setDir _cargoDir;
			_veh setVariable ["CHHQ_cargo", _cargo, true];
		};
		_cargo = _veh getVariable ["CHHQ_cargo", objNull];

		if (playerSide isEqualTo _side) then {
			[_veh, _side, "MHQ"] call CHHQ_fnc_drawMarker;

			if (isNil "CHHQ_HQarray") then {
				CHHQ_HQarray = [];
			};
			CHHQ_HQarray pushBack _veh;
			if (_veh getVariable ["CHHQ_index", -1] < 0) then {
				_veh setVariable ["CHHQ_index", (CHHQ_HQarray find _veh) + 1, true];
			};

			_id = _veh addAction ["Deploy HQ", "_this spawn CHHQ_fnc_deploy", [_side, _cargoInfo, _composition], 0, false, true, "", "[_target, _this] call CHHQ_fnc_actionConditions"];
			_veh setVariable ["CHHQ_actionID",_id];

			[[_veh, "cargo"], "CHHQ_fnc_deleteVehicleEH", false] call BIS_fnc_MP;

			if !(_cargoCode isEqualTo "") then {
				_cargoCode = [_cargoCode] call CHHQ_fnc_compileCode;
				[_cargo, _veh] spawn _cargoCode;
			};
		};
	};
};
CHHQ_fnc_updateTeleportActions = {
	_obj = _this select 0;

	{
		_obj removeAction _x;
	} forEach (_obj getVariable ["CHHQ_actionIDarray",[]]);

	_actionIDarray = [];
	{
		_vehString = "CHHQ_HQarray select " + str _forEachIndex;
		_actionText = if (count CHHQ_HQarray > 1) then {format ["Move to HQ-%1", _x getVariable ["CHHQ_index", -1]]} else {"Move to HQ"};
		_id = _obj addAction [_actionText, "_this spawn CHHQ_fnc_teleportToHQ", [_x], 6, true, true, "", format ["[_target, _this, %1] call CHHQ_fnc_teleportActionConditions", _vehString]];
		_actionIDarray pushBack _id;
	} forEach CHHQ_HQarray;
	_obj setVariable ["CHHQ_actionIDarray", _actionIDarray];
};
CHHQ_fnc_clearNullFromArray = {
	[] spawn {
		waitUntil {!isNil "CHHQ_HQarray"};
		for "_i" from 0 to 1 step 0 do {
			waitUntil {{isNull _x} count CHHQ_HQarray > 0};
			CHHQ_HQarray = CHHQ_HQarray - [objNull];
		};
	};
};

waitUntil {time > 1};
_obj = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_side = [_this, 1, sideUnknown, [sideUnknown]] call BIS_fnc_param;
CHHQ_showMarkers = if (isNil "CHHQ_showMarkers") then {true} else {CHHQ_showMarkers};

if (_side isEqualTo sideUnknown && toLower typeOf _obj != toLower "MapBoard_altis_F") then {
	_sideNum = getNumber (configFile >> "CfgVehicles" >> typeOf _obj >> "side");
	_side = switch _sideNum do {
		case 0: {east};
		case 1: {west};
		case 2: {resistance};
		default {sideUnknown};
	};
};
[] call CHHQ_fnc_clearNullFromArray;
switch (toLower typeOf _obj) do {
	case (toLower "B_Truck_01_transport_F"): {
		_composition = [["Land_PowerGenerator_F",[-2.99756,2.07959,0.0971174],180.556],["CamoNet_BLUFOR_big_F",[0.013916,-0.0551758,0.0971174],337.248],["Land_ToiletBox_F",[3.71655,3.98242,0.097096],181.571],["MapBoard_altis_F",[4.04272,1.50049,0.0449162],359.984],["Land_CampingTable_F",[-3.40649,-1.95361,0.0971169],252.548],["Land_CampingChair_V1_F",[-4.34302,-1.66504,0.100242],253.27],["Land_Cargo20_grey_F",[4.11963,-0.677246,0.0971179],271.612,{_this animate ["Door_1_rot",1]; _this animate ["Door_2_rot",1]}]];
		_cargoInfo = ["Land_Cargo20_grey_F",[0.045,-2.31,1.15],270,{_this setVariable ['bis_disabled_Door_1',1]; _this setVariable ['bis_disabled_Door_2',1]}];
		[_obj, _side, _cargoInfo, _composition] call CHHQ_fnc_startingSetup;
	};
	case (toLower "O_Truck_02_transport_F"): {
		_composition = [["CamoNet_OPFOR_big_F",[0.0947266,-0.0610352,0.0315285],345.578],["Land_PowerGenerator_F",[-2.4873,2.33643,0.0315285],182.122],["Land_WaterTank_F",[3.85596,0.42627,0.0315242],4.92499],["Land_CampingTable_F",[-2.77075,-1.10254,0.031528],276.314],["Land_CampingChair_V1_F",[-3.8562,-0.631348,0.0346532],288.003],["Land_Cargo10_sand_F",[3.70703,-2.79932,0.0315285],274.286]];
		_cargoInfo = ["Land_Cargo10_sand_F",[0.07,-2,0.5],270];
		[_obj, _side, _cargoInfo, _composition] call CHHQ_fnc_startingSetup;
	};
	case (toLower "I_Truck_02_transport_F"): {
		_composition = [["CamoNet_INDP_big_F",[0.0947266,-0.0610352,0.0315285],345.578],["Land_PowerGenerator_F",[-2.4873,2.33643,0.0315285],182.122],["Land_WaterTank_F",[3.85596,0.42627,0.0315242],4.92499],["Land_CampingTable_F",[-2.77075,-1.10254,0.031528],276.314],["Land_CampingChair_V1_F",[-3.8562,-0.631348,0.0346532],288.003],["Land_Cargo10_military_green_F",[3.70703,-2.79932,0.0315285],274.286]];
		_cargoInfo = ["Land_Cargo10_military_green_F",[0.07,-2,0.5],270];
		[_obj, _side, _cargoInfo, _composition] call CHHQ_fnc_startingSetup;
	};
	case (toLower "O_Truck_03_transport_F"): {
		_composition = [["Land_PowerGenerator_F",[-2.74097,0.837891,0.0376329],182.12],["Land_CampingTable_F",[-3.02441,-2.60107,0.0376248],276.309],["Land_CampingChair_V1_F",[-4.10986,-2.13037,0.0407581],288.114],["Land_FieldToilet_F",[4.37451,-0.489258,0.0376129],195.192],["Land_Cargo10_sand_F",[3.79224,-3.17822,0.0376348],285.205],["CamoNet_OPFOR_big_F",[0,-0.568848,0.119837],350.522]];
		_cargoInfo = ["Land_Cargo10_sand_F",[0.07,-3.46,0.8],270];
		[_obj, _side, _cargoInfo, _composition] call CHHQ_fnc_startingSetup;
	};
	case (toLower "B_G_Van_01_transport_F"): {
		_composition = [["CamoNet_BLUFOR_big_F",[0.0947266,-0.0610352,0.0315285],345.578],["Land_Portable_generator_F",[-2.4873,2.33643,0.0315285],182.122],["Land_WaterBarrel_F",[3.85596,0.42627,0.0315242],4.92499],["Land_CampingTable_F",[-2.77075,-1.10254,0.031528],276.314],["Land_CampingChair_V1_F",[-3.8562,-0.631348,0.0346532],288.003],["CargoNet_01_box_F",[3.70703,-2.79932,0.0315285],274.286]];
		_cargoInfo = ["CargoNet_01_box_F",[0,-1.2,0],0];
		[_obj, _side, _cargoInfo, _composition] call CHHQ_fnc_startingSetup;
	};
	default {
		waitUntil {!isNil "CHHQ_HQarray"};
		[_obj] call CHHQ_fnc_updateTeleportActions;
		[CHHQ_HQarray, {[[_obj], "CHHQ_fnc_updateTeleportActions", _side] call BIS_fnc_MP}] call CHHQ_fnc_arrayUpdateEH;
	};
};
