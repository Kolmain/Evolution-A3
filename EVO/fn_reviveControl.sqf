/*%FSM<COMPILE "C:\EVO\FSMEditor\scriptedFSM.cfg, EVO_fnc_reviveControl">*/
/*%FSM<HEAD>*/
/*
item0[] = {"Revive_Control",0,250,-75.000000,-125.000000,25.000000,-75.000000,0.000000,"Revive" \n "Control"};
item1[] = {"Revive_allowed",4,218,-75.000000,-50.000000,25.000000,0.000000,0.000000,"Revive allowed"};
item2[] = {"Add_ability",2,250,-75.000000,25.000000,25.000000,75.000000,0.000000,"Add ability"};
item3[] = {"Incapacitated",4,218,175.000000,-125.000000,275.000000,-75.000000,0.000000,"Incapacitated"};
item4[] = {"Add_force_respaw",2,250,175.000000,-50.000000,275.000000,0.000000,0.000000,"Add force" \n "respawn"};
item5[] = {"Target_selected",4,218,-75.000000,100.000000,25.000000,150.000000,0.000000,"Target selected"};
item6[] = {"Reviving",2,250,-75.000000,175.000000,25.000000,225.000000,0.000000,"Reviving"};
item7[] = {"Respawn_started",4,218,175.000000,25.000000,275.000000,75.000000,0.000000,"Respawn" \n "started"};
item8[] = {"Revive_disabled",4,218,-200.000000,25.000000,-100.000000,75.000000,0.000000,"Revive disabled"};
item9[] = {"Stopped_reviving",4,218,-325.000000,175.000000,-225.000000,225.000000,0.000000,"Stopped" \n "reviving"};
item10[] = {"Remove_ability",2,250,-200.000000,-50.000000,-100.000000,0.000000,0.000000,"Remove ability"};
item11[] = {"Respawning",2,250,175.000000,100.000000,275.000000,150.000000,0.000000,"Respawning"};
item12[] = {"Respawned",4,218,175.000000,175.000000,275.000000,225.000000,1.000000,"Respawned"};
item13[] = {"Interrupted",2,250,-325.000000,100.000000,-225.000000,150.000000,0.000000,"Interrupted"};
item14[] = {"_",8,218,-325.000000,-50.000000,-225.000000,0.000000,0.000000,""};
item15[] = {"Time_passed",4,218,-75.000000,250.000000,25.000000,300.000000,1.000000,"Time passed"};
item16[] = {"Revived",2,250,-75.000000,325.000000,25.000000,375.000000,0.000000,"Revived"};
item17[] = {"",7,210,-354.000000,346.000061,-346.000000,353.999969,0.000000,""};
item18[] = {"",7,210,-354.000000,-29.000000,-346.000000,-21.000000,0.000000,""};
item19[] = {"Stopped_respawn",4,218,300.000000,100.000000,400.000000,150.000000,0.000000,"Stopped" \n "respawn"};
item20[] = {"",7,210,346.000000,-29.000002,354.000000,-21.000000,0.000000,""};
item21[] = {"",7,210,-354.000000,396.000000,-346.000000,404.000000,0.000000,""};
item22[] = {"",7,210,221.000046,396.000000,228.999939,404.000000,0.000000,""};
item23[] = {"_",8,218,-200.000000,-125.000000,-100.000000,-75.000000,0.000000,""};
item24[] = {"Respawn_disabled",4,218,50.000000,-50.000000,150.000000,0.000000,0.000000,"Respawn" \n "disabled"};
item25[] = {"Remove_force_res",2,250,50.000000,25.000000,150.000000,75.000000,0.000000,"Remove force" \n "respawn"};
item26[] = {"Forced_respawn",2,250,175.000000,250.000000,275.000000,300.000000,0.000000,"Forced respawn"};
item27[] = {"",7,210,96.000000,396.000000,104.000000,404.000000,0.000000,""};
link0[] = {0,1};
link1[] = {0,3};
link2[] = {1,2};
link3[] = {2,5};
link4[] = {2,8};
link5[] = {3,4};
link6[] = {4,7};
link7[] = {4,24};
link8[] = {5,6};
link9[] = {6,9};
link10[] = {6,15};
link11[] = {7,11};
link12[] = {8,10};
link13[] = {9,13};
link14[] = {10,23};
link15[] = {11,12};
link16[] = {11,19};
link17[] = {12,26};
link18[] = {13,14};
link19[] = {14,10};
link20[] = {15,16};
link21[] = {16,17};
link22[] = {17,18};
link23[] = {18,14};
link24[] = {19,20};
link25[] = {20,4};
link26[] = {21,17};
link27[] = {22,27};
link28[] = {23,0};
link29[] = {24,25};
link30[] = {25,27};
link31[] = {26,22};
link32[] = {27,21};
globals[] = {25.000000,1,0,0,0,640,480,1,53,6316128,1,-450.468414,440.884003,500.442902,-202.013641,1209,1071,1};
window[] = {2,-1,-1,-1,-1,1155,275,1669,275,3,1227};
*//*%FSM</HEAD>*/
class FSM
{
        fsmName = "EVO_fnc_reviveControl";
        class States
        {
                /*%FSM<STATE "Revive_Control">*/
                class Revive_Control
                {
                        name = "Revive_Control";
                        itemno = 0;
                        init = /*%FSM<STATEINIT""">*/""/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Incapacitated">*/
                                class Incapacitated
                                {
                                        itemno = 3;
                                        priority = 0.000000;
                                        to="Add_force_respaw";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"player getVariable ""EVO_revive_incapacitated""" \n
                                         "&&" \n
                                         "{alive player}"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Revive_allowed">*/
                                class Revive_allowed
                                {
                                        itemno = 1;
                                        priority = 0.000000;
                                        to="Add_ability";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(player getVariable ""EVO_revive_incapacitated"")" \n
                                         "&&" \n
                                         "{" \n
                                         "	alive player" \n
                                         "	&&" \n
                                         "	{" \n
                                         "		player distance EVO_revive_selected <= 3.5" \n
                                         "	}" \n
                                         "}"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Add_ability">*/
                class Add_ability
                {
                        name = "Add_ability";
                        itemno = 2;
                        init = /*%FSM<STATEINIT""">*/"// Add revive ability" \n
                         """REVIVE_START"" call EVO_fnc_reviveKeys;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Revive_disabled">*/
                                class Revive_disabled
                                {
                                        itemno = 8;
                                        priority = 0.000000;
                                        to="Remove_ability";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"player getVariable ""EVO_revive_incapacitated""" \n
                                         "||" \n
                                         "!(alive player)" \n
                                         "||" \n
                                         "player distance EVO_revive_selected > 3.5"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Target_selected">*/
                                class Target_selected
                                {
                                        itemno = 5;
                                        priority = 0.000000;
                                        to="Reviving";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(isNull EVO_revive_target)"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Add_force_respaw">*/
                class Add_force_respaw
                {
                        name = "Add_force_respaw";
                        itemno = 4;
                        init = /*%FSM<STATEINIT""">*/"// Add ability to force respawn" \n
                         """RESPAWN_START"" call EVO_fnc_reviveKeys;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Respawn_disabled">*/
                                class Respawn_disabled
                                {
                                        itemno = 24;
                                        priority = 0.000000;
                                        to="Remove_force_res";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(player getVariable ""EVO_revive_incapacitated"")" \n
                                         "||" \n
                                         "!(alive player)"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Respawn_started">*/
                                class Respawn_started
                                {
                                        itemno = 7;
                                        priority = 0.000000;
                                        to="Respawning";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"player getVariable [""EVO_revive_forceRespawn"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Reviving">*/
                class Reviving
                {
                        name = "Reviving";
                        itemno = 6;
                        init = /*%FSM<STATEINIT""">*/"private [""_target""];" \n
                         "_target = EVO_revive_target;" \n
                         "" \n
                         "// Allow interrupt" \n
                         """REVIVE_END"" call EVO_fnc_reviveKeys;" \n
                         "" \n
                         "// Register helper" \n
                         "_target setVariable [""EVO_revive_helper"", player, true];"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Time_passed">*/
                                class Time_passed
                                {
                                        itemno = 15;
                                        priority = 1.000000;
                                        to="Revived";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_target getVariable ""EVO_revive_incapacitated"")"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Stopped_reviving">*/
                                class Stopped_reviving
                                {
                                        itemno = 9;
                                        priority = 0.000000;
                                        to="Interrupted";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"player getVariable ""EVO_revive_incapacitated""" \n
                                         "||" \n
                                         "!(alive player)" \n
                                         "||" \n
                                         "isNull EVO_revive_target" \n
                                         "||" \n
                                         "player distance EVO_revive_target > 3.5" \n
                                         "||" \n
                                         "isNull EVO_revive_selected"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Remove_ability">*/
                class Remove_ability
                {
                        name = "Remove_ability";
                        itemno = 10;
                        init = /*%FSM<STATEINIT""">*/"// Remove revive ability" \n
                         """DISABLED"" call EVO_fnc_reviveKeys;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "_">*/
                                class _
                                {
                                        itemno = 23;
                                        priority = 0.000000;
                                        to="Revive_Control";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/""/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Respawning">*/
                class Respawning
                {
                        name = "Respawning";
                        itemno = 11;
                        init = /*%FSM<STATEINIT""">*/"// Allow interrupt" \n
                         """RESPAWN_END"" call EVO_fnc_reviveKeys;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Respawned">*/
                                class Respawned
                                {
                                        itemno = 12;
                                        priority = 1.000000;
                                        to="Forced_respawn";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(alive player)"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Stopped_respawn">*/
                                class Stopped_respawn
                                {
                                        itemno = 19;
                                        priority = 0.000000;
                                        to="Add_force_respaw";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(player getVariable ""EVO_revive_forceRespawn"")" \n
                                         "||" \n
                                         "!(player getVariable ""EVO_revive_incapacitated"")"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Interrupted">*/
                class Interrupted
                {
                        name = "Interrupted";
                        itemno = 13;
                        init = /*%FSM<STATEINIT""">*/"// Reset target and helper" \n
                         "EVO_revive_target = objNull;" \n
                         "_target setVariable [""EVO_revive_helper"", objNull, true];"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "_">*/
                                class _
                                {
                                        itemno = 14;
                                        priority = 0.000000;
                                        to="Remove_ability";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/""/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Revived">*/
                class Revived
                {
                        name = "Revived";
                        itemno = 16;
                        init = /*%FSM<STATEINIT""">*/"// Revive unit" \n
                         "[_target, ""ALIVE""] call EVO_fnc_reviveSetStatus;" \n
                         "" \n
                         "// Reset animation" \n
                         "[[_target, ""AmovPpneMstpSnonWnonDnon""], ""switchMove""] call BIS_fnc_MP;" \n
                         "" \n
                         "// Reset target" \n
                         "EVO_revive_target = objNull;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "_">*/
                                class _
                                {
                                        itemno = 14;
                                        priority = 0.000000;
                                        to="Remove_ability";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/""/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Remove_force_res">*/
                class Remove_force_res
                {
                        name = "Remove_force_res";
                        itemno = 25;
                        init = /*%FSM<STATEINIT""">*/"// Remove force respawn" \n
                         """DISABLED"" call EVO_fnc_reviveKeys;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "_">*/
                                class _
                                {
                                        itemno = 14;
                                        priority = 0.000000;
                                        to="Remove_ability";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/""/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Forced_respawn">*/
                class Forced_respawn
                {
                        name = "Forced_respawn";
                        itemno = 26;
                        init = /*%FSM<STATEINIT""">*/""/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "_">*/
                                class _
                                {
                                        itemno = 14;
                                        priority = 0.000000;
                                        to="Remove_ability";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/""/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
        };
        initState="Revive_Control";
        finalStates[] =
        {
        };
};
/*%FSM</COMPILE>*/