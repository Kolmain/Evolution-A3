//by Bon_Inf*
//Modified by Moser 07/20/2014

BON_RECRUIT_PATH = "bon_recruit_units\";

bon_max_units_allowed = 12;
bon_recruit_recruitableunits = ["B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F","B_soldier_repair_F","B_soldier_exp_F","B_Helipilot_F","B_engineer_F","B_soldier_AT_F","B_soldier_AA_F","B_helicrew_F"];
bon_recruit_queue = [];

//Select false if you want to use a a static unit list
//You can customize static lists in recruitable_units_static.sqf
bon_dynamic_list = false;

if(isServer) then{
	"bon_recruit_newunit" addPublicVariableEventHandler {
		_newunit = _this select 1;
		[_newunit] execFSM (BON_RECRUIT_PATH+"unit_lifecycle.fsm");
	};
};
if(isDedicated) exitWith{};


// Client stuff...
