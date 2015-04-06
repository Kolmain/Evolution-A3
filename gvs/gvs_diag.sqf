while {true} do
{
	{
		systemChat str (_x isKindOf "UAV");
		//_checkControl = [str ((uavControl _x) select 0), str player] call String_Search;
		if (([str ((uavControl _x) select 0), str player] call String_Search) != -1) then
		{
			systemChat str ((uavControl _x) select 0);
			systemChat ((uavControl _x) select 1);
		};
	}forEach allUnitsUav;
	sleep 5;
};