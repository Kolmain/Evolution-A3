_type = _this select 0;
_activator = _this select 1;
rtype="none";

_grp = group player;
_count = (count units _grp);
_ainum = 0;
_ap = player;
_i = 0;
while {_i < _count} do
{
	_ap = (units _grp select _i);
	if (not (isPlayer _ap)) then
	{
		_ainum = _ainum +1;
	};
	_i = _i + 1;
};

if (player != (leader group player)) exitwith {hint "You must be a leader to recruit"};

if (_type == "B_soldier_LAT_F") then
{
	if (score player < rank1) exitwith {handle = [player,rank1] execVM "scripts\req.sqf";};
	rtype = "B_soldier_LAT_F";
};
if (_type == "B_Soldier_GL_F") then
{
	if (score player < rank1) exitwith {handle = [player,rank1] execVM "scripts\req.sqf";};
	rtype = "B_Soldier_GL_F";
};
if (_type == "B_medic_F") then
{
	if (score player < rank2) exitwith {handle = [player,rank2] execVM "scripts\req.sqf";};
	rtype = "B_medic_F";
};
if (_type == "B_soldier_AR_F") then
{
	if (score player < rank3) exitwith {handle = [player,rank3] execVM "scripts\req.sqf";};
	rtype = "B_soldier_AR_F";
};
if (_type == "B_soldier_AA_F") then
{
	if (score player < rank3) exitwith {handle = [player,rank3] execVM "scripts\req.sqf";};
	rtype = "B_soldier_AA_F";
};
if (_type == "B_engineer_F") then
{
	if (score player < rank4) exitwith {handle = [player,rank4] execVM "scripts\req.sqf";};
	rtype = "B_engineer_F";
};
if (_type == "B_soldier_M_F") then
{
	if (score player < rank5) exitwith {handle = [player,rank5] execVM "scripts\req.sqf";};
	rtype = "B_soldier_M_F";
};
if (_type == "B_recon_exp_F") then
{
	if (score player < rank6) exitwith {handle = [player,rank6] execVM "scripts\req.sqf";};
	rtype = "B_recon_exp_F";
};

if (score player < rank1) exitwith {handle = [player,rank1] execVM "scripts\req.sqf";};
if (score player < rank2 and _ainum >= 1) exitwith {hint "You have reached your current ranks capacity";};
if (score player < rank3 and _ainum >= 2) exitwith {hint "You have reached your current ranks capacity";};
if (score player < rank4 and _ainum >= 3) exitwith {hint "You have reached your current ranks capacity";};
if (score player < rank5 and _ainum >= 4) exitwith {hint "You have reached your current ranks capacity";};
if (score player < rank6 and _ainum >= 5) exitwith {hint "You have reached your current ranks capacity";};
if (score player >= rank6 and _ainum >= 6) exitwith {hint "You have reached your current ranks capacity";};

_units = (count units group player);

if (rtype != "none") then
{
	runit = player;
	publicVariable "rtype";
	publicVariable "runit";
};

WaitUntil {not (Isnull runit) and not(isPlayer runit)};
_vecpro = [runit] execVM "scripts\aivec.sqf";