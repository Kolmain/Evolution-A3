_pos = getPos player;

//Land_Medevac_house_V1_F

player playMove "Acts_carFixingWheel";

if (!isNil "playerStructures") then {
	{
		deleteVehicle _x;
	} forEach playerStructures;
	_msg = format ["Your previous MASH has been removed."];
	["deployed",["MASH REMOVED", _msg]] call BIS_fnc_showNotification;
};

if (!isNil "playerRespawnPoint") then {
	//playerRespawnPoint call BIS_fnc_removeRespawnPosition;
};



WaitUntil {animationState player != "Acts_carFixingWheel"};
if (!alive player || player distance _pos > 1) exitWith {};


[[_pos],{
	_pos = _this select 0;
	if (isServer) then
	{
		_nearMen = [];
		_mash = nearestObject [_pos, "Land_Medevac_house_V1_F"];
		while {alive _mash} do
		{
			{
				if (alive _x && side _x == WEST && damage _x != 0) then
				{
					_damage = damage _x;
					_damage = _damage - 0.01;
					if (_damage < 0) then
					{
						_damage = 0;
					};
					_x setDamage _damage;
				};
			}
			forEach ((getPos _obj) nearEntities [["Man"], _radius]);
			sleep 2;
		};
	};
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;
_mark = format["%1mash",(name player)];
deleteMarker _mark;
playerStructures = [(getPos player), (getDir player), "Comps\mash.sqf", false] call (compile (preprocessFileLineNumbers "scripts\otl7_Mapper.sqf"));
//playerRespawnPoint = [(group player), (getPos player)] spawn BIS_fnc_addRespawnPosition;
_mssg = format["%1's MASH",(name player)];
_medmark = createMarker [_mark, getPos player];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_med";
_medmark setMarkerColor "ColorBlue";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [1, 1];
_msg = format ["Your MASH has been deployed at map grid %1.", mapGridPosition player];
["deployed",["MASH DEPLOYED", _msg]] call BIS_fnc_showNotification;
