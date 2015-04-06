/*

	AUTHOR: aeroson
	NAME: group_manager.sqf
	VERSION: 1.6

	DOWNLOAD & PARTICIPATE:
	https://github.com/aeroson/a3-misc
	http://forums.bistudio.com/showthread.php?163206-Group-Manager

	DESCRIPTION:
	Hold T and use scrollwheel to see squad manager menu
	You can invite others, request to join, or join squad based on squad options
	You can also leave squad, kick members or take leadership if you have better score than current squad leader
	Potential targets is either cursorTrager and/or everyone within 5m range

	USAGE:
	in (client's) init:
	0 = [] execVM 'group_manager.sqf';

*/

if(isDedicated) exitWith {}; // is server
waitUntil{!isNull findDisplay 46};


// SETTINGS
#define KEY 0x14 // T // http://community.bistudio.com/wiki/DIK_KeyCodes
#define TIMEOUT 120 // seconds

// SQUAD JOIN
#define JOIN_FREE 0 // squad is open, anyone can join
#define JOIN_INVITE_BY_SQUAD 1 // squad is invite only, everyone from squad can invite
#define JOIN_INVITE_BY_LEADER 2 // squad is invite only, only leader can invite
#define JOIN_DISABLED 3 // none can invite
#define JOIN_DEFAULT JOIN_FREE

// SQUAD ACCEPT JOINT REQUEST PERMISSION (WHO CAN ACCEPT REQUEST) ONLY IF SQUAD JOIN IS 1, 2 OR 3
#define ACCEPT_BY_SQUAD 0 // everyone from squad can accept join requests
#define ACCEPT_BY_LEADER 1 // only leader can accept join requests
#define ACCEPT_DISABLED 2 // disable join requests
#define ACCEPT_DEFAULT ACCEPT_BY_LEADER




#define PREFIX aero
#define COMPONENT gm
//#define DEBUG_MODE


#define DOUBLES(A,B) ##A##_##B
#define TRIPLES(A,B,C) ##A##_##B##_##C
#define QUOTE(A) #A
#define CONCAT(A,B) A####B

#define GVAR(A) TRIPLES(PREFIX,COMPONENT,A)
#define QGVAR(A) QUOTE(GVAR(A))

#define INC(A) A=(A)+1
#define DEC(A) A=(A)-1
#define ADD(A,B) A=(A)+(B)
#define SUB(A,B) A=(A)-(B)
#define REM(A,B) A=A-[B]
#define PUSH(A,B) A set [count (A),B]
#define EL(A,B) ((A) select (B))

#define PUSH_START(A) A set[count (A),
#define PUSH_END ];
#define PARAM_START private ["_PARAM_INDEX"]; _PARAM_INDEX=0;
#define PARAM_REQ(A) private #A; if(count _this<=_PARAM_INDEX)exitWith{ systemChat format["required param '%1' not supplied in file:'%2' at line:%3", #A ,__FILE__,__LINE__]; }; A=_this select _PARAM_INDEX; _PARAM_INDEX=_PARAM_INDEX+1;
#define PARAM(A,B) private #A; A = (B); if(count _this>_PARAM_INDEX)then{ A=_this select _PARAM_INDEX; }; _PARAM_INDEX=_PARAM_INDEX+1;

#define THIS(A) EL(this,A)
#define _THIS(A) EL(_this,A)

#ifdef DEBUG_MODE
	#define LOG(A) systemChat format[QUOTE(%1|%2(%3:%4)=%5),time,QUOTE(COMPONENT),__FILE__,__LINE__,A];
#else
	#define LOG(A)
#endif

#define TRACE_1(MSG,A) LOG(format['%1: A=%2',MSG,(A)])
#define TRACE_2(MSG,A,B) LOG(format['%1: A=%2, B=%3',MSG,(A),(B)])
#define TRACE_3(MSG,A,B,C) LOG(format['%1: A=%2, B=%3, C=%4',MSG,(A),(B),(C)])
#define TRACE_4(MSG,A,B,C,D) LOG(format['%1: A=%2, B=%3, C=%4, D=%5',MSG,(A),(B),(C),(D)])
#define TRACE_5(MSG,A,B,C,D,E) LOG(format['%1: A=%2, B=%3, C=%4, D=%5, E=%6',MSG,(A),(B),(C),(D),(E)])
#define TRACE_6(MSG,A,B,C,D,E,F) LOG(format['%1: A=%2, B=%3, C=%4, D=%5, E=%6, F=%7',MSG,(A),(B),(C),(D),(E),(F)])




GVAR(possibleTargets) = [];
GVAR(actions_custom) = [];
GVAR(actions_add) = {
	GVAR(actions_custom) set [count GVAR(actions_custom), _this];
};
GVAR(opened) = false;

GVAR(invites) = [];
GVAR(requests) = [];

GVAR(msg) = {
	//hint _this;
	systemChat _this;
};


GVAR(playersOnly) = {
	private ["_out"];
	_out = [];
	{
		if(isPlayer _x) then {
			PUSH_START(_out)
				_x
			PUSH_END
		};
	} forEach _THIS(0);
	_out;
};

GVAR(actions_ids) = [];
GVAR(actions_addId) = {
	GVAR(actions_ids) set [count GVAR(actions_ids), _this];
};
GVAR(actions_remove) = {
	{
		player removeAction _x;
	} forEach GVAR(actions_ids);
	GVAR(actions_ids) = [];
};
GVAR(actions_addBack) = {
	player addAction [
		"<t color='#cccccc'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_sidebar_show.paa' size='0.7' /> ... Back</t>",
		([_this,0,{[] call GVAR(menu_main);}] call BIS_fnc_param),
		([_this,1,[]] call BIS_fnc_param),
		1000
	] call GVAR(actions_addId);
};


// [unit1] // you have joined unit1's group
GVAR(join) = {
	if(([group _THIS(0)] call GVAR(options_getJoin))!=JOIN_FREE) exitWith {
		format["%1's group (led by %2) is no longer free to join", name _THIS(0), name leader _THIS(0)] call GVAR(msg);
	};
	[
		format["%1 has joined your squad", name player],
		QGVAR(msg),
		[(units group _THIS(0))-[player]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	format["You have joined %1's squad led by %2", name _THIS(0), name leader _THIS(0)] call GVAR(msg);
	[player] joinSilent group _THIS(0);
	waitUntil{group player==group _THIS(0)};
	[] call GVAR(menu_main);
};

// you left your group
GVAR(leaveGroup) = {
	LOG(QGVAR(leaveGroup))
	[
		format["%1 has left your squad", name player],
		QGVAR(msg),
		[(units group player)-[player]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	"You have left squad" call GVAR(msg);
	[player] joinSilent createGroup (side player);
	[] call GVAR(menu_main);
};


// [unit1] // you have invited unit1 to join your group
GVAR(invite) = {
	private ["_myJoin"];
	_myJoin = [group player] call GVAR(options_getJoin);
	if(!(
		(_myJoin==JOIN_FREE) ||
		(_myJoin==JOIN_INVITE_BY_SQUAD && player in units group player) ||
		(_myJoin==JOIN_INVITE_BY_LEADER && leader player == player)
	)) exitWith {
		"You no longer haver permission to invite" call GVAR(msg);
	};
	format["You have invited %1 into your squad", name _THIS(0)] call GVAR(msg);
	[
		format["%1 has invited %2 into your squad", name player, name _THIS(0)],
		QGVAR(msg),
		[(units group player)-[player]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[
		[
			player,
			group player
		],
		QGVAR(invited),
		[[_THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[] call GVAR(menu_main);
};

// [unit1, group1] // you got invited by unit1 to join a unit1's group1
GVAR(invited) = {
	if(_THIS(0) in units _THIS(1)) then {
		format["%1 has invited you to join his/her squad (led by %2)", name _THIS(0), name leader _THIS(1)] call GVAR(msg);
		{
			if((_x select 1)==_THIS(0) && (_x select 2)==_THIS(1)) then {
				GVAR(invites) set[_forEachIndex, 0];
			};
		} forEach GVAR(invites);

		PUSH_START(GVAR(invites))
			[time, _THIS(0), _THIS(1)]
		PUSH_END
	};
	[] call GVAR(menu_main);
};

// [unit1, forEachIndex] // you have accepted invite by unit1 to unit1's group, forEachIndex in GVAR(invites)
GVAR(invite_accepted) = {
	format["Invite by %1 (led by %2) accepted", name _THIS(0), name leader _THIS(0)] call GVAR(msg),
	[
		format["%1 has accepted your invite", name player],
		QGVAR(msg),
		[[_THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[
		format["%1 joined your group, invited by %2", name player, name _THIS(0)],
		QGVAR(msg),
		[(units group _THIS(0))-[_THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[player] joinSilent group _THIS(0);
	GVAR(invites) set[_THIS(1), 0];
	[] call GVAR(menu_main);
};

// [unit1, forEachIndex] // you have declined invite by unit1 to unit1's group, forEachIndex in GVAR(invites)
GVAR(invite_declined) = {
	format["Invite by %1 (led by %2) declined", name _THIS(0), name leader _THIS(0)] call GVAR(msg),
	[
		format["%1 has declined your invite", name player],
		QGVAR(msg),
		[[_THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	GVAR(invites) set[_THIS(1), 0];
	[] call GVAR(menu_main);
};




// [unit1, unit2, accept:int] // unit1 is requesting to join unit2's group, accept is either ACCEPT_BY_SQUAD or ACCEPT_BY_LEADER
GVAR(request) = {
	private ["_accept"];
	_accept = [group _THIS(1)] call GVAR(options_getAccept);
	if(!(
		(_accept==ACCEPT_BY_SQUAD && ({isPlayer _x} count units group unit2>0)) ||
		(_accept==ACCEPT_BY_LEADER && isPlayer leader group unit2)
	)) exitWith {
		format["You are no longer able to request join to %1's group (led by %2)", name _THIS(1), name leader _THIS(1)] call GVAR(msg);
	};
	format["You have requested to join %1's squad (led by %2)", name _THIS(1), name leader _THIS(1)] call GVAR(msg);
	[
		[
			_THIS(0),
			group _THIS(1)
		],
		QGVAR(requested),
		[
			if(_accept==ACCEPT_BY_SQUAD) then { units group _THIS(1) } else { [leader _THIS(1)] }
		] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[] call GVAR(menu_main);
};

// [unit1, group1] // unit1 requested to join yours group1
GVAR(requested) = {
	if(player in units _THIS(1)) then {
		format["%1 has requested to join your squad", name _THIS(0), name leader _THIS(1)] call GVAR(msg);
		{
			if((_x select 1)==_THIS(0) && (_x select 2)==_THIS(1)) then {
				GVAR(requests) set[_forEachIndex, 0];
			};
		} forEach GVAR(requests);
		PUSH_START(GVAR(requests))
			[time, _THIS(0), _THIS(1)]
		PUSH_END
	};
	[] call GVAR(menu_main);
};

// [unit1, forEachIndex] // you have accepted request from unit1 to join your group, forEachIndex in GVAR(requests)
GVAR(request_accepted) = {
	format["Join request by %1 accepted", name _THIS(0)] call GVAR(msg),
	[
		format["%1 (led by %2) has accepted your join request", name player, name leader player],
		QGVAR(msg),
		[[_THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[
		format["%1 has joined your squad (accepted by %2)", name _THIS(0), name player],
		QGVAR(msg),
		[(units group player)-[player]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[_THIS(0)] joinSilent group player;
	GVAR(requests) set[_THIS(1), 0];
	[] call GVAR(menu_main);
};

// [unit1, forEachIndex] // you have declined request from unit1 to join your group, forEachIndex in GVAR(requests)
GVAR(request_declined) = {
	format["Join request by %1 declined", name _THIS(0)] call GVAR(msg),
	[
		format["%1 (led by %2) has declined your join request", name player, name leader player],
		QGVAR(msg),
		[[_THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	GVAR(requests) set[_THIS(1), 0];
	[] call GVAR(menu_main);
};



// you are taking leadership of your squad
GVAR(takeLeaderShip) = {
	LOG(QGVAR(takeLeaderShip))
	if(!([player] call GVAR(canTakeLeadership))) exitWith {
		"You can't take leadership anymore" call GVAR(msg);
		[] call GVAR(menu_main);
	};
	"You took leadership" call GVAR(msg);
	[
		format["%1 has taken leadership", name player],
		QGVAR(msg),
		[(units group player)-[player, leader player]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	_oldLeader = leader player;
	[
		[player],
		QGVAR(takeLeaderShip_remote),
		leader player
	] spawn BIS_fnc_MP;
	waitUntil{_oldLeader!=leader player};
	[] call GVAR(menu_main);
};

// [unit1] // unit1 takes leadership of his+yours group
GVAR(takeLeaderShip_remote) = {
	if(group _THIS(0) == group player) then {
		if(isPlayer leader player) then {
			format["%1 took leadership from you", name _THIS(0)] call GVAR(msg);
		};
		(group player) selectLeader _THIS(0);
		[] call GVAR(menu_main);
	};
};


// [unit1] // returns true if unit1 can take leadership of his group, false if can't
GVAR(canTakeLeadership) = {
	private["_out"];
	_out = true;
	if(count units group _THIS(0) == 1) then {
		_out = false;
	};
	if(leader _THIS(0) == _THIS(0)) then {
		_out = false;
	};
	if(isNil{aero_playtime_get}) then {
		if(rating leader _THIS(0) + 10 > rating _THIS(0)) then {
			_out = false;
		};
	} else {
		if(leader _THIS(0) call aero_playtime_get > ARG0 call aero_playtime_get) then {
			_out = false;
		};
	};
	_out;
};



// show menu to give leadership
GVAR(menu_giveLeaderShip) = {
	LOG(QGVAR(menu_giveLeaderShip))
	if(leader player!=player) exitWith {
		"You are not leader anymore" call GVAR(msg);
		[] call GVAR(menu_main);
	};
	[] call GVAR(actions_remove);
	{
		PUSH_START(GVAR(actions_ids))
			player addAction [
				format["<t color='#0099ee'><img image='\A3\ui_f\data\gui\Rsc\RscDisplayConfigViewer\bookmark_gs.paa' size='0.7' /> Give leadership to %1</t>", name _x],
				{ _THIS(3) call GVAR(giveLeaderShip); },
				[_x],
				5000-_forEachIndex
			]
		PUSH_END
	} forEach ((units group player)-[player]);
	[]call GVAR(actions_addBack);
};


// [unit1] // you gave group leadership to unit1
GVAR(giveLeaderShip) = {
	format["You gave leadership to %1", name _THIS(0)] call GVAR(msg);
	[
		format["%1 was given leadership by %2", name _THIS(0), name player],
		QGVAR(msg),
		[(units group _THIS(0))-[_THIS(0), player]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[
		format["%1 gave you leadership", name player],
		QGVAR(msg),
		[[_THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	(group _THIS(0)) selectLeader _THIS(0);
	[] call GVAR(menu_main);
};


// show menu for squad options
GVAR(menu_squadOptions) = {
	LOG(QGVAR(menu_squadOptions))
	if(leader player!=player) exitWith {
		"You are not leader anymore" call GVAR(msg);
		[] call GVAR(menu_main);
	};
	[] call GVAR(actions_remove);
	private ["_join","_accept"];
	_join = [group player] call GVAR(options_getJoin);
	{
		PUSH_START(GVAR(actions_ids))
			player addAction [
				format["<t color='#0099ee'>%1 %2</t>", _x, if(_join==_forEachIndex) then {"(Current)"} else {""}],
				{ _args=_THIS(3); (_args select 0) setVariable ["j", (_args select 1), true]; call GVAR(menu_squadOptions); },
				[group player, _forEachIndex],
				6000-_forEachIndex
			]
		PUSH_END
	} forEach ["Anyone can join","Squad members can invite","Squad leader can invite","Disable invite"];
	_accept = [group player] call GVAR(options_getAccept);
	{
		PUSH_START(GVAR(actions_ids))
			player addAction [
				format["<t color='#0077ee'>%1 %2</t>", _x, if(_accept==_forEachIndex) then {"(Current)"} else {""}],
				{ _args=_THIS(3); (_args select 0) setVariable ["a", (_args select 1), true]; call GVAR(menu_squadOptions); },
				[group player, _forEachIndex],
				5000-_forEachIndex
			]
		PUSH_END
	} forEach ["Squad members can accept join request","Squad leader can accept join request","Disable join request"];
	[] call GVAR(actions_addBack);
};

// show menu to kick squad member
GVAR(menu_kickSquadMember) = {
	LOG(QGVAR(menu_kickSquadMember))
	if(leader player!=player) exitWith {
		"You are not leader anymore" call GVAR(msg);
		[] call GVAR(menu_main);
	};
	[] call GVAR(actions_remove);
	{
		PUSH_START(GVAR(actions_ids))
			player addAction [
				format["<t color='#ff8822'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\top_close_gs.paa' size='0.7' /> Kick %1</t>", name _x],
				{ _THIS(3) call GVAR(kickSquadMember); },
				[_x],
				5000-_forEachIndex
			]
		PUSH_END
	} forEach ((units group player)-[player]);
	[]call GVAR(actions_addBack);
};

// [unit1] // you are kicking unit1
GVAR(kickSquadMember) = {
	LOG(QGVAR(kickSquadMember))
	format["You have kicked %1", name _THIS(0)] call GVAR(msg);
	[
		format["%1 was kicked by %2", name _THIS(0), name player],
		QGVAR(msg),
		[(units group _THIS(1))-[player, _THIS(0)]] call GVAR(playersOnly)
	] spawn BIS_fnc_MP;
	[
		[player, _THIS(0)],
		QGVAR(kickSquadMember_remote),
		_THIS(0)
	] spawn BIS_fnc_MP;
	waitUntil{!(_THIS(0) in units group player)};
	[] call GVAR(menu_main);
};

// [unit1, unit2] // unit2 (local) have been kicked by unit1
GVAR(kickSquadMember_remote) = {
	if(isPlayer _THIS(1)) then {
		format["You have been kicked by %1", name _THIS(0)] call GVAR(msg);
	};
	[_THIS(1)] joinSilent createGroup (side _THIS(1));
	[] call GVAR(menu_main);
};


// [group1] // returns JOIN_ option for group1
GVAR(options_getJoin) = {
	private ["_join"];
	_join = _THIS(0) getVariable "j";
	if(isNil{_join}) then {
		_join = JOIN_DEFAULT;
		_THIS(0) setVariable ["j", _join, true];
	};
	_join;
};

// [group1] // returns ACCEPT_ option for group1
GVAR(options_getAccept) = {
	private ["_accept"];
	_accept = _THIS(0) getVariable "a";
	if(isNil{_accept}) then {
		_accept = ACCEPT_DEFAULT;
		_THIS(0) setVariable ["a", _accept, true];
	};
	_accept;
};

// main menu D:
GVAR(menu_main) = {
	[] call GVAR(actions_remove);
	if(!GVAR(opened)) exitWith {};

	{
		PUSH(GVAR(actions_ids), player addAction _x);
	} forEach GVAR(actions_custom);

	if(leader player == player) then {
		if(count units group player > 1)then {
			PUSH_START(GVAR(actions_ids))
				player addAction [
					"<t color='#0099ee'><img image='\A3\ui_f\data\gui\Rsc\RscDisplayConfigViewer\bookmark_gs.paa' size='0.7' /> Give Leadership to ...</t>",
					{ _THIS(3) call GVAR(menu_giveLeaderShip); },
					[],
					9010
				]
			PUSH_END
			PUSH_START(GVAR(actions_ids))
				player addAction [
					"<t color='#ff8822'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\top_close_gs.paa' size='0.7' /> Kick Squad Member ...</t>",
					{ _THIS(3) call GVAR(menu_kickSquadMember); },
					[],
					9030
				]
			PUSH_END
		};
		PUSH_START(GVAR(actions_ids))
			player addAction [
				"<t color='#0088ee'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_config_ca.paa' size='0.7' /> Squad Options ...</t>",
				{ _THIS(3) call GVAR(menu_squadOptions); },
				[],
				9020
			]
		PUSH_END
	} else {
		if([player] call GVAR(canTakeLeadership)) then {
			PUSH_START(GVAR(actions_ids))
				player addAction [
					"<t color='#0099ee'><img image='\A3\ui_f\data\gui\Rsc\RscDisplayConfigViewer\bookmark_gs.paa' size='0.7' /> Take Leadership</t>",
					{ _THIS(3) call GVAR(takeLeaderShip) },
					[],
					9000
				]
			PUSH_END
		};
	};

	if(count units group player > 1)then {
		PUSH_START(GVAR(actions_ids))
			player addAction [
				"<t color='#ff1111'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_sidebar_hide_up.paa' size='0.7' /> Leave squad</t>",
				{ _THIS(3) call GVAR(leaveGroup) },
				[],
				8000
			]
		PUSH_END
	};


	// GVAR(invites) = [[time, unit1, group1], ] // you got invited by unit1 to join a unit1's group1
	GVAR(invites) = GVAR(invites) - [0];
	{
		_unit1 = _x select 1;
		if(_unit1 in units (_x select 2) && (_x select 0) + TIMEOUT > time) then {
			PUSH_START(GVAR(actions_ids))
				player addAction [
					format["<t color='#00cc00'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_continue_ca.paa' size='0.7' /> Accept invite by %1 (led by %2)</t>", name _unit1, name leader _unit1],
					{ _THIS(3) call GVAR(invite_accepted) },
					[_unit1, _forEachIndex],
					7500-_forEachIndex
				]
			PUSH_END
			PUSH_START(GVAR(actions_ids))
				player addAction [
					format["<t color='#ff1111'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\top_close_gs.paa' size='0.7' /> Decline invite by %1 (led by %2)</t>", name _unit1, name leader _unit1],
					{ _THIS(3) call GVAR(invite_declined) },
					[_unit1, _forEachIndex],
					7000-_forEachIndex
				]
			PUSH_END
		} else {
			GVAR(invites) set [_forEachIndex, 0];
		};
	} forEach GVAR(invites);
	GVAR(invites) = GVAR(invites) - [0];


	// GVAR(requests) = [[time, unit1, group1], ] // unit1 requested to join yours group1
	GVAR(requests) = GVAR(requests) - [0];
	{
	  	_unit1 = _x select 1;
	  	if(player in units (_x select 2) && (_x select 0) + TIMEOUT > time) then {
			PUSH_START(GVAR(actions_ids))
				player addAction [
					format["<t color='#00cc00'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_continue_ca.paa' size='0.7' /> Accept join request by %1</t>", name _unit1],
					{ _THIS(3) call GVAR(request_accepted) },
					[_unit1, _forEachIndex],
					6500-_forEachIndex
				]
			PUSH_END
			PUSH_START(GVAR(actions_ids))
				player addAction [
					format["<t color='#ff1111'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\top_close_gs.paa' size='0.7' /> Decline join request by %1</t>", name _unit1],
					{ _THIS(3) call GVAR(request_declined) },
					[_unit1, _forEachIndex],
					6000-_forEachIndex
				]
			PUSH_END
		} else {
			GVAR(requests) set [_forEachIndex, 0];
		};
	} forEach GVAR(requests);
	GVAR(requests) = GVAR(requests) - [0];


	private "_groupsDone";
	_groupsDone = [];
	_myJoin = [group player] call GVAR(options_getJoin);
  	{
  		if(
		  side _x == side player && group _x != group player
		  && alive _x && !(vehicle _x in allUnitsUav)
		) then {

			if(_myJoin!=JOIN_DISABLED && isPlayer _x) then {
				if(
					(_myJoin==JOIN_FREE) ||
					(_myJoin==JOIN_INVITE_BY_SQUAD && player in units group player) ||
					(_myJoin==JOIN_INVITE_BY_LEADER && leader player == player)
				) then {
					PUSH_START(GVAR(actions_ids))
						player addAction [
							format["<t color='#ffcc66'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_toolbox_units_ca.paa' size='0.7' /> Invite %1 into your squad</t>", name _x],
							{ _THIS(3) call GVAR(invite); },
							[_x],
							5600-_forEachIndex
						]
					PUSH_END
				};
			};

			if(!(group _x in _groupsDone)) then {
				PUSH(_groupsDone, group _x);
				_join = [group _x] call GVAR(options_getJoin);

				if(_join==JOIN_FREE) then {
					PUSH_START(GVAR(actions_ids))
						player addAction [
							format["<t color='#ffcc66'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_toolbox_units_ca.paa' size='0.7' /> Join %1's squad (led by %2)</t>", name _x, name leader _x],
							{ _THIS(3) call GVAR(join); },
							[_x],
							5300-_forEachIndex
						]
					PUSH_END
				} else {
					_accept = [group _x] call GVAR(options_getAccept);
					if(
						(_accept==ACCEPT_BY_SQUAD && ({isPlayer _x} count units group _x>0)) ||
						(_accept==ACCEPT_BY_LEADER && isPlayer leader group _x)
					) then {
						PUSH_START(GVAR(actions_ids))
							player addAction [
								format["<t color='#ffcc66'><img image='\A3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_toolbox_units_ca.paa' size='0.7' /> Request to join %1's squad (led by %2)</t>", name _x, name leader _x],
								{ _THIS(3) call GVAR(request); },
								[player, _x, _accept],
								5000-_forEachIndex
							]
						PUSH_END
					};
				};
			};

  		};
  	} forEach GVAR(possibleTargets);

  	LOG(QUOTE(main_menu done))
};


(findDisplay 46) displayAddEventHandler ["keyDown", QUOTE(_this call GVAR(keyDown))];
GVAR(keyDown) = {
	if(_THIS(1)==KEY) then {
		if(!GVAR(opened)) then {
			GVAR(opened) = true;
			GVAR(possibleTargets) = [];
			if(!isNull(group cursorTarget)) then {
				PUSH_START(GVAR(possibleTargets))
					cursorTarget
				PUSH_END
			};
			{
				if(!(_x in GVAR(possibleTargets))) then {
					PUSH_START(GVAR(possibleTargets))
						_x
					PUSH_END
				};
			} forEach nearestObjects [player, ["man"], 5];
			[] call GVAR(menu_main);
		};
	};
	false;
};


(findDisplay 46) displayAddEventHandler ["keyUp", QUOTE(_this call GVAR(keyUp))];
GVAR(keyUp) = {
	if(_THIS(1)==KEY) then {
		if(GVAR(opened)) then {
			GVAR(opened) = false;
			[] call GVAR(actions_remove);
		};
	};
	false;
};


"Squad Manager is active, hold T and use mousewheel to bring it up." call GVAR(msg);