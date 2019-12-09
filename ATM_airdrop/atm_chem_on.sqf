_target = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_caller removeAction _id;


_ltcolor = (_this select 3) select 0;

            _lgt = _ltcolor createVehicle [0,0,0];
            _lgt attachTo [_caller, [0,-0.03,0.07], "LeftShoulder"];
            _caller setvariable ["lgtarray", _lgt,true];


if (_ltcolor =="Chemlight_Red") then {
        RedOff = _caller addAction["<t color='#B40404'>Chemlight Red OFF</t>", "ATM_airdrop\atm_chem_off.sqf",[_ltcolor],6,false,false,"", "_target == ( player)"];
        _caller removeaction blueon;_caller removeaction yellowon;_caller removeaction greenon;_caller removeaction Iron;
        };
if (_ltcolor =="Chemlight_Blue") then {
        actionBlueOff = _caller addAction["<t color='#68ccf6'>Chemlight Blue OFF</t>", "ATM_airdrop\atm_chem_off.sqf",[_ltcolor],6,false,false,"","_target == ( player)"];
        _caller removeaction redon;_caller removeaction yellowon;_caller removeaction greenon;_caller removeaction Iron;
        };
if (_ltcolor =="Chemlight_Yellow") then {
        actionYellowOff = _caller addAction["<t color='#fcf018'>Chemlight Yellow OFF</t>", "ATM_airdrop\atm_chem_off.sqf",[_ltcolor],6,false,false,"", "_target == (player)"];
        _caller removeaction blueon;_caller removeaction redon;_caller removeaction greenon;_caller removeaction Iron;
        };
if (_ltcolor =="Chemlight_Green") then {
        actionGreenOff = _caller addAction["<t color='#30fd07'>Chemlight Green OFF</t>", "ATM_airdrop\atm_chem_off.sqf",[_ltcolor],6,false,false,"", "_target == ( player)"];
        _caller removeaction blueon;_caller removeaction yellowon;_caller removeaction redon;_caller removeaction Iron;
        };
if (_ltcolor =="NVG_TargetC") then {
        actionIROff = _caller addAction["<t color='#FF00CC'>Strobe IR OFF</t>", "ATM_airdrop\atm_chem_off.sqf",[_ltcolor],6,false,false,"", "_target == ( player)"];
        _caller removeaction blueon;_caller removeaction yellowon;_caller removeaction redon;_caller removeaction greenon;
        };

		while {(getPos _caller select 2) > 2} do {

	if(getPos _caller select 2 < 3) then{
if (_ltcolor =="Chemlight_Red") then {
        _caller removeaction RedOff;
        };
if (_ltcolor =="Chemlight_Blue") then {
        _caller removeaction actionBlueOff;
        };
if (_ltcolor =="Chemlight_Yellow") then {
        _caller removeaction actionYellowOff;
        };
if (_ltcolor =="Chemlight_Green") then {
        _caller removeaction actionGreenOff;
        };
if (_ltcolor =="NVG_TargetC") then {
        _caller removeaction Iron;
        };
	}
	};