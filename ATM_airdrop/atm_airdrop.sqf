private ["_position","_cut","_dialog","_s_alt","_s_alt_text","_sound","_sound2","_soundPath"];
	waitUntil { !isNull player };
[] execVM "ATM_airdrop\functions.sqf";

		_position = GetPos player;
		_z = _position select 2;
		Altitude = 500;


	openMap true;
	hint "SELECT DROP LOCATION VIA SINGLE LEFT CLICK.";
	ATM_Jump_mapclick = false;
	["atmMapClickEH", "onMapSingleClick", {
		ATM_Jump_clickpos = _pos;
		ATM_Jump_mapclick = true;
		["atmMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}] call BIS_fnc_addStackedEventHandler;
	waitUntil {ATM_Jump_mapclick or !(visiblemap)};
		if (!visiblemap) exitWith {
		["atmMapClickEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		if (player getVariable "EVOrank" != "PRIVATE") then {
			[player, 3] call bis_fnc_addScore;
			["PointsAdded",["HALO insertion canceled.", 3]] call BIS_fnc_showNotification;
		} else {
			["PointsAdded",["HALO insertion canceled.", 0]] call BIS_fnc_showNotification;
		};
		breakOut "main";
	};
	_pos = ATM_Jump_clickpos;
	ATM_Jump_mapclick = if(true) then{
	call compile format ['
	mkr_halo = createmarker ["mkr_halo", ATM_Jump_Clickpos];
	"mkr_halo" setMarkerTypeLocal "hd_dot";
	"mkr_halo" setMarkerColorLocal "ColorGreen";
	"mkr_halo" setMarkerTextLocal "Jump";'];
	};

	_target = player;

		_loadout=[_target] call Getloadout;

		_posJump = getMarkerPos "mkr_halo";
		_x = _posJump select 0;
		_y = _posJump select 1;
		_z = _posJump select 2;
		_target setPos [_x,_y,_z+1000];

	openMap false;
	deleteMarker "mkr_halo";

	0=[_target] call Frontpack;

	removeBackpack _target;
	sleep 0,5;
	_target addBackpack "B_Parachute";
if ((getPos _target select 2) >= 8000) then{
	removeHeadgear _target;
	_target addHeadgear "H_CrewHelmetHeli_B";
	sleep 0,5;
};

_height = getPos _target select 2;

while {(getPos _target select 2) > 2} do {
	if(isTouchingGround _target and player == vehicle player) then{
	}
	else{
	playSound "Vent";
	playSound "Vent2";
	sleep 5;

	};
	if (getPos _target select 2 < 150) then {
		_target action ["OpenParachute", _target];
	};
	if(!alive _target) then {
	_target setPos [getPos _target select 0, getPos _target select 1, 0];
	0=[_target,_loadout] call Setloadout;
	};
};

		deletevehicle (_target getvariable "frontpack"); _target setvariable ["frontpack",nil,true];
		deletevehicle (_target getvariable "lgtarray"); _target setvariable ["lgtarray",nil,true];

sleep 3;
//hintsilent "";
sleep 1;

	0=[_target,_loadout] call Setloadout;

if (true) exitWith {};
