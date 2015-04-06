/*=================================================================================================================	
  GVS Watcher by Jacmac	
  
  Version History:
  A	- Initial Release 3/23/2013
  B - Heavily revised, runs on server only, prevents vehicles from reentry after service instead of preventing
  	the player from reentry. 4/21/2013
  
  Description:
  Executed at startup. Prevents a vehicle from being reserviced for a specified	period after using a service point
  successfully by checking it against the Public_Banned_Vehicle_Service_List array. The script sleeps on a 10 
  second loop. 	
  
  Default wait is 200 seconds (20 passes * 10 seconds).	
  
  It is	recommended	to not lower the sleep time	of 10 seconds to keep the execution	to a minimum.
  
  Adjust _gvs_reset_count as desired.
  
  Requirements:	
	See	generic_vehicle_service.sqf	
  
=================================================================================================================*/	

#define	RESET_COUNT	20
#define	LOOP_SLEEP	10

Public_GVS_Delay = (RESET_COUNT * LOOP_SLEEP);
publicVariable "Public_GVS_Delay";
_current_banned_list = [];
_countdown_list = [];

_fnc_array_Pop =
{
	private["_element", "_size", "_array"];
	
	_array = _this;
	_size = count _array;
	_element = _array select (_size - 1);
	_array resize (_size - 1);
	
	_element
};

while {true} do
{
	scopeName "mainloop";
	if (!([_current_banned_list,Public_Banned_Vehicle_Service_List] call BIS_fnc_arrayCompare)) then
	{
		publicVariable "Public_GVS_Delay";
		if (count _current_banned_list < count Public_Banned_Vehicle_Service_List) then
		{
			_elements = [];
			for "_i" from count _current_banned_list to ((count Public_Banned_Vehicle_Service_List) - 1) do
			{
				_elements = _elements + [(Public_Banned_Vehicle_Service_List call _fnc_array_Pop)];
			};
			for "_i" from 0 to ((count _elements) - 1) do
			{
				[Public_Banned_Vehicle_Service_List, (_elements select _i)] call BIS_fnc_arrayPush;
				[_current_banned_list, (_elements select _i)] call BIS_fnc_arrayPush;
				[_countdown_list, RESET_COUNT] call BIS_fnc_arrayPush;
			};
			publicVariable "Public_Banned_Vehicle_Service_List";
			sleep 0.1;
		} else
		{
			systemChat "Generic vehicle Service array is out of sync!";
		};
	};
	_countdowns_to_remove = [];
	_i = 0;
	{
		_x = _x - 1;
		if (_x < 1) then
		{
			Public_Banned_Vehicle_Service_List = [Public_Banned_Vehicle_Service_List, _i] call BIS_fnc_removeIndex;
			publicVariable "Public_Banned_Vehicle_Service_List";
			sleep 0.1;
			_current_banned_list = [_current_banned_list, _i] call BIS_fnc_removeIndex;
			[_countdowns_to_remove, _i] call BIS_fnc_arrayPush;
			breakTo "mainloop";
		} else
		{
			_countdown_list set [_i, _x];
		};
		_i = _i + 1;
	}forEach _countdown_list;
	{
		_countdown_list = [_countdown_list, _x] call BIS_fnc_removeIndex;
	}forEach _countdowns_to_remove;
	sleep LOOP_SLEEP;
};