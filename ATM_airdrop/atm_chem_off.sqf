_target = _this select 0;
_caller = _this select 1;
_id = _this select 2;

_ltcolor = (_this select 3) select 0;

_caller removeAction _id;



deletevehicle (_caller getvariable "lgtarray"); _caller setvariable ["lgtarray",nil,true];