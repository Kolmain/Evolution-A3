private ["_hc","_unit","_hcID"];


if (!isServer || !isMultiplayer || isNull _hc) exitWith {};

waitUntil {time > 2};

_unit = this select 0;
_hc = headlessClient;

_hcID = owner headlessClient;

{	_x setOwner _hcID;	} count units group _unit;

group _unit setGroupOwner _hcID;