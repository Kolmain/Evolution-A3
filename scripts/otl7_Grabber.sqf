scriptName "otl7_Grabber.sqf";
/* 
	Author: Joris-Jan van 't Land, modified for ArmA3: Outlawz7

	Description: 
	Converts a set of placed objects to an object array for the Mapper.

	Parameter(s): 
	_this select 0: position of the anchor point 
	_this select 1: size of the covered area 
     
	Example(s):
	0 = [getpos player,100] execvm "dyno_a3\otl7_Grabber.sqf"
*/ 

private ["_anchorPos", "_anchorDim"]; 
_anchorPos = _this select 0; 
_anchorDim = _this select 1; 

private ["_objs"]; 
_objs = nearestObjects [_anchorPos, ["All"], _anchorDim]; 

_dataPile = "";

for "_i" from 0 to ((count _objs) - 1) do 
{ 
    private ["_obj", "_type"]; 
    _obj = _objs select _i; 

    _type = typeOf _obj; 

    //Exclude human objects. 
    private ["_sim"]; 
    _sim = getText (configFile >> "CfgVehicles" >> _type >> "simulation"); 
    if !(_sim in ["soldier"]) then 
    { 
        private ["_objPos", "_dX", "_dY", "_z", "_azimuth", "_fuel", "_damage"]; 
        _objPos = position _obj; 
        _dX = (_objPos select 0) - (_anchorPos select 0); 
        _dY = (_objPos select 1) - (_anchorPos select 1); 
        _z = _objPos select 2; 
        _azimuth = direction _obj; 
        _fuel = fuel _obj; 
        _damage = damage _obj; 

        _dataPile = _dataPile + format ["%1,", [_type, [_dX, _dY, _z], _azimuth, _fuel, _damage]];
    }; 
}; 

copyToClipboard _dataPile;
hint "otl7_Grabber.sqf: Data pile copied to clipboard.";