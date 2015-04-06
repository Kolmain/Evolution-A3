/*=================================================================================================================
  Config Lookup by Jacmac

  Version History:
  A - Initial Release 10/13/2013

  Features:
  -Simple sound helper functions. GVS is currently only using 3D functions.

  Use in init.sqf:
  call compile preProcessFile "sounds.sqf";

=================================================================================================================*/

Sound_Loop = 
{
	_sound = _this select 0;
	_duration = _this select 1;
	_position = _this select 2;
	
	_trigger = createTrigger["EmptyDetector" , _position];
	_trigger setTriggerStatements ["true" , "" , ""];
	_trigger setSoundEffect["$NONE$" , "" , "" , _sound];
	
	while {_duration > 0} do
	{
		sleep 0.1;
		_duration = _duration - 0.1;
	};
	_trigger setSoundEffect["NoSound" , "" , "" , ""];
	deleteVehicle _trigger;
};

Sound_LoopSay3D = 
{
	_sound = _this select 0;
	_duration = _this select 1;
	_soundsourceobject = _this select 2;
	_soundfileduration = _this select 3;
	_d = _soundfileduration;
	
	_soundsourceobject say3D _sound;
	while {_duration > 0} do
	{
		sleep 0.1;
		_duration = _duration - 0.1;
		_d = _d - 0.1;
		if (_d < 0.1 and _loopduration > _soundfileduration) then
		{	
			_soundsourceobject say3D _sound;
			_d = _soundfileduration;
		};
	};
	_soundsourceobject say3D "NoSound";
};

Sound_Loop3D = 
{	
	_soundfile = GVS_Path + (_this select 0);
	_soundfileduration = _this select 1;
	_incidencedelay = _this select 2;
	_loopduration = _this select 3;
	_soundsourceobject = _this select 4;
	_volume = 	[_this, 5, 10] call Param;
	_pitch = 	[_this, 6, 1.0] call Param;
	_distance = [_this, 7, 30] call Param;
	_inside = 	[_this, 8, false] call Param;
	_soundposition = getPos _soundsourceobject;
	
	playSound3D [_soundfile, _soundsourceobject, _inside, _soundposition, _volume, _pitch, _distance];
	_d = _soundfileduration;
	while {_loopduration > _soundfileduration} do
	{
		_loopduration = _loopduration - 0.1;
		_d = _d - _incidencedelay;
		if (_d < 0.1) then
		{
			playSound3D [_soundfile, _soundsourceobject, _inside, _soundposition, _volume, _pitch, _distance];
			_d = _soundfileduration;
		};
		sleep 0.1;
	};
};

Sound_Once3D =
{
	private ["_soundfile","_soundsourceobject","_volume","_pitch","_distance","_inside","_soundposition"];
	_soundfile = GVS_Path + (_this select 0);
	_soundsourceobject = _this select 1;
	_volume = [_this, 2, 10] call Param;
	_pitch = [_this, 3, 1.0] call Param;
	_distance = [_this, 4, 30] call Param;
	_inside = [_this, 5, false] call Param;
	_soundposition = getPos _soundsourceobject;
	playSound3D [_soundfile, _soundsourceobject, _inside, _soundposition, _volume, _pitch, _distance];
}


