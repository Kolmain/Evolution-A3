_verb = _this select 0;
_veh = _this select 1;

if (_verb == "add") then {
	_NSLVR_actionID = _veh addAction ["set NSLVR position", { (_this select 0) setVariable ["NSLVR_respawnPos", [getPosATL (_this select 0), getDir (_this select 0)], true] },[],0,true,true,"","_this == driver _target"];
	_veh setVariable ["NSLVR_actionID", _NSLVR_actionID];
};

if (_verb == "remove") then {
	_veh removeAction (_veh getVariable "NSLVR_actionID");
};