/*%FSM<COMPILE "C:\EVO\FSMEditor\scriptedFSM.cfg, EVO_fnc_reviveIconManager">*/
/*%FSM<HEAD>*/
/*
item0[] = {"Icon_Manager",0,250,-75.000000,-50.000000,25.000000,0.000000,0.000000,"Icon Manager"};
item1[] = {"Incapacitated",4,218,-75.000000,50.000000,25.000000,100.000000,1.000000,"Incapacitated"};
item2[] = {"",7,210,-29.000000,21.000000,-21.000000,29.000000,0.000000,""};
item3[] = {"Dead",4,218,300.000000,50.000000,400.000000,100.000000,2.000000,"Dead"};
item4[] = {"",7,210,96.000000,21.000000,104.000000,29.000000,0.000000,""};
item5[] = {"Dying",4,218,50.000000,50.000000,150.000000,100.000000,0.000000,"Dying"};
item6[] = {"",7,210,221.000000,21.000000,229.000000,29.000000,0.000000,""};
item7[] = {"Being_revived",4,218,175.000000,50.000000,275.000000,100.000000,0.000000,"Being revived"};
item8[] = {"Show_icon",2,250,-75.000000,125.000000,25.000000,175.000000,0.000000,"Show icon"};
item9[] = {"Dead_icon",2,250,300.000000,125.000000,400.000000,175.000000,0.000000,"Dead icon"};
item10[] = {"Pulse_skull",2,250,50.000000,125.000000,150.000000,175.000000,0.000000,"Pulse skull"};
item11[] = {"Pulse_icon",2,250,175.000000,125.000000,275.000000,175.000000,0.000000,"Pulse icon"};
item12[] = {"",7,210,-29.000000,321.000000,-21.000000,329.000000,0.000000,""};
item13[] = {"",7,210,-104.000000,21.000000,-96.000000,29.000000,0.000000,""};
item14[] = {"Not_dying",4,218,50.000000,225.000000,150.000000,275.000000,0.000000,"Not dying"};
item15[] = {"Not_reviving",4,218,175.000000,225.000000,275.000000,275.000000,0.000000,"Not reviving"};
item16[] = {"",7,210,471.000000,21.000000,479.000000,29.000000,0.000000,""};
item17[] = {"Removed",4,218,425.000000,125.000000,525.000000,175.000000,3.000000,"Removed"};
item18[] = {"Terminate",1,250,425.000000,200.000000,525.000000,250.000000,0.000000,"Terminate"};
item19[] = {"Reset",2,250,50.000000,300.000000,150.000000,350.000000,0.000000,"Reset"};
item20[] = {"",7,210,221.000000,321.000000,229.000000,329.000000,0.000000,""};
item21[] = {"",7,210,96.000000,196.000000,104.000000,204.000000,0.000000,""};
item22[] = {"",7,210,221.000000,196.000000,229.000000,204.000000,0.000000,""};
item23[] = {"",7,210,-104.000008,321.000000,-96.000000,329.000000,0.000000,""};
item24[] = {"",7,210,346.000000,21.000000,354.000000,29.000000,0.000000,""};
item25[] = {"",7,210,-29.000000,196.000000,-21.000000,204.000000,0.000000,""};
link0[] = {0,2};
link1[] = {1,8};
link2[] = {2,1};
link3[] = {2,4};
link4[] = {3,9};
link5[] = {4,5};
link6[] = {4,6};
link7[] = {5,10};
link8[] = {6,7};
link9[] = {6,24};
link10[] = {7,11};
link11[] = {8,25};
link12[] = {9,17};
link13[] = {10,21};
link14[] = {11,22};
link15[] = {12,23};
link16[] = {13,2};
link17[] = {14,19};
link18[] = {15,20};
link19[] = {16,17};
link20[] = {17,18};
link21[] = {19,12};
link22[] = {20,19};
link23[] = {21,14};
link24[] = {21,25};
link25[] = {22,15};
link26[] = {22,21};
link27[] = {23,13};
link28[] = {24,3};
link29[] = {24,16};
link30[] = {25,12};
globals[] = {25.000000,1,0,0,0,640,480,1,44,6316128,1,-186.476837,683.198364,341.588715,-298.903503,1054,1071,1};
window[] = {2,-1,-1,-1,-1,955,75,1469,75,3,1072};
*//*%FSM</HEAD>*/
class FSM
{
        fsmName = "EVO_fnc_reviveIconManager";
        class States
        {
                /*%FSM<STATE "Icon_Manager">*/
                class Icon_Manager
                {
                        name = "Icon_Manager";
                        itemno = 0;
                        init = /*%FSM<STATEINIT""">*/"private [""_unit""];" \n
                         "_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;" \n
                         "" \n
                         "private [""_downed"", ""_revive"", ""_state"", ""_active""];" \n
                         "_downed = false;" \n
                         "_revive = false;" \n
                         "_state = """";" \n
                         "_active = scriptNull;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Removed">*/
                                class Removed
                                {
                                        itemno = 17;
                                        priority = 3.000000;
                                        to="Terminate";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"(" \n
                                         "	alive _unit" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_incapacitated"", false])" \n
                                         ")" \n
                                         "||	" \n
                                         "!(_unit getVariable [""EVO_revive_iconEnabled"", true])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dead">*/
                                class Dead
                                {
                                        itemno = 3;
                                        priority = 2.000000;
                                        to="Dead_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"_state != ""DEAD""" \n
                                         "&&" \n
                                         "!(alive _unit)" \n
                                         "&&" \n
                                         "!(_unit getVariable [""EVO_revive_incapacitated"", false])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Incapacitated">*/
                                class Incapacitated
                                {
                                        itemno = 1;
                                        priority = 1.000000;
                                        to="Show_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_downed)" \n
                                         "&&" \n
                                         "alive _unit" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Being_revived">*/
                                class Being_revived
                                {
                                        itemno = 7;
                                        priority = 0.000000;
                                        to="Pulse_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "{" \n
                                         "	_state != ""DEAD""" \n
                                         "	&&" \n
                                         "	{" \n
                                         "		!(isNull (_unit getVariable [""EVO_revive_helper"", objNull]))" \n
                                         "	}" \n
                                         "}"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dying">*/
                                class Dying
                                {
                                        itemno = 5;
                                        priority = 0.000000;
                                        to="Pulse_skull";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "!(_state in [""DEAD"", ""DYING""])" \n
                                         "&&" \n
                                         "(" \n
                                         "	_unit getVariable [""EVO_revive_forceRespawn"", false]" \n
                                         "	||" \n
                                         "	_unit getVariable [""EVO_revive_dying"", false]" \n
                                         ")"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Show_icon">*/
                class Show_icon
                {
                        name = "Show_icon";
                        itemno = 8;
                        init = /*%FSM<STATEINIT""">*/"// Register that the unit was downed" \n
                         "_downed = true;" \n
                         "_revive = false;" \n
                         "" \n
                         "// Execute effect" \n
                         "[""DOWN"", _unit] spawn EVO_fnc_reviveIconControl;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Removed">*/
                                class Removed
                                {
                                        itemno = 17;
                                        priority = 3.000000;
                                        to="Terminate";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"(" \n
                                         "	alive _unit" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_incapacitated"", false])" \n
                                         ")" \n
                                         "||	" \n
                                         "!(_unit getVariable [""EVO_revive_iconEnabled"", true])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dead">*/
                                class Dead
                                {
                                        itemno = 3;
                                        priority = 2.000000;
                                        to="Dead_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"_state != ""DEAD""" \n
                                         "&&" \n
                                         "!(alive _unit)" \n
                                         "&&" \n
                                         "!(_unit getVariable [""EVO_revive_incapacitated"", false])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Incapacitated">*/
                                class Incapacitated
                                {
                                        itemno = 1;
                                        priority = 1.000000;
                                        to="Show_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_downed)" \n
                                         "&&" \n
                                         "alive _unit" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Being_revived">*/
                                class Being_revived
                                {
                                        itemno = 7;
                                        priority = 0.000000;
                                        to="Pulse_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "{" \n
                                         "	_state != ""DEAD""" \n
                                         "	&&" \n
                                         "	{" \n
                                         "		!(isNull (_unit getVariable [""EVO_revive_helper"", objNull]))" \n
                                         "	}" \n
                                         "}"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dying">*/
                                class Dying
                                {
                                        itemno = 5;
                                        priority = 0.000000;
                                        to="Pulse_skull";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "!(_state in [""DEAD"", ""DYING""])" \n
                                         "&&" \n
                                         "(" \n
                                         "	_unit getVariable [""EVO_revive_forceRespawn"", false]" \n
                                         "	||" \n
                                         "	_unit getVariable [""EVO_revive_dying"", false]" \n
                                         ")"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Dead_icon">*/
                class Dead_icon
                {
                        name = "Dead_icon";
                        itemno = 9;
                        init = /*%FSM<STATEINIT""">*/"_state = ""DEAD"";" \n
                         "_revive = false;" \n
                         "" \n
                         "// Terminate existing effect script" \n
                         "terminate _active;" \n
                         "" \n
                         "// Execute effect" \n
                         "[""DEAD"", _unit] spawn EVO_fnc_reviveIconControl;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Removed">*/
                                class Removed
                                {
                                        itemno = 17;
                                        priority = 3.000000;
                                        to="Terminate";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"(" \n
                                         "	alive _unit" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_incapacitated"", false])" \n
                                         ")" \n
                                         "||	" \n
                                         "!(_unit getVariable [""EVO_revive_iconEnabled"", true])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Pulse_skull">*/
                class Pulse_skull
                {
                        name = "Pulse_skull";
                        itemno = 10;
                        init = /*%FSM<STATEINIT""">*/"_state = ""DYING"";" \n
                         "_revive = false;" \n
                         "" \n
                         "// Terminate existing effect script" \n
                         "terminate _active;" \n
                         "" \n
                         "// Execute effect" \n
                         "private [""_script""];" \n
                         "_script = [""DYING"", _unit] spawn EVO_fnc_reviveIconControl;" \n
                         "_active = _script;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Removed">*/
                                class Removed
                                {
                                        itemno = 17;
                                        priority = 3.000000;
                                        to="Terminate";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"(" \n
                                         "	alive _unit" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_incapacitated"", false])" \n
                                         ")" \n
                                         "||	" \n
                                         "!(_unit getVariable [""EVO_revive_iconEnabled"", true])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dead">*/
                                class Dead
                                {
                                        itemno = 3;
                                        priority = 2.000000;
                                        to="Dead_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"_state != ""DEAD""" \n
                                         "&&" \n
                                         "!(alive _unit)" \n
                                         "&&" \n
                                         "!(_unit getVariable [""EVO_revive_incapacitated"", false])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Incapacitated">*/
                                class Incapacitated
                                {
                                        itemno = 1;
                                        priority = 1.000000;
                                        to="Show_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_downed)" \n
                                         "&&" \n
                                         "alive _unit" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Being_revived">*/
                                class Being_revived
                                {
                                        itemno = 7;
                                        priority = 0.000000;
                                        to="Pulse_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "{" \n
                                         "	_state != ""DEAD""" \n
                                         "	&&" \n
                                         "	{" \n
                                         "		!(isNull (_unit getVariable [""EVO_revive_helper"", objNull]))" \n
                                         "	}" \n
                                         "}"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dying">*/
                                class Dying
                                {
                                        itemno = 5;
                                        priority = 0.000000;
                                        to="Pulse_skull";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "!(_state in [""DEAD"", ""DYING""])" \n
                                         "&&" \n
                                         "(" \n
                                         "	_unit getVariable [""EVO_revive_forceRespawn"", false]" \n
                                         "	||" \n
                                         "	_unit getVariable [""EVO_revive_dying"", false]" \n
                                         ")"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Not_dying">*/
                                class Not_dying
                                {
                                        itemno = 14;
                                        priority = 0.000000;
                                        to="Reset";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "(" \n
                                         "	!(_unit getVariable [""EVO_revive_forceRespawn"", false])" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_dying"", false])" \n
                                         ")" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Pulse_icon">*/
                class Pulse_icon
                {
                        name = "Pulse_icon";
                        itemno = 11;
                        init = /*%FSM<STATEINIT""">*/"_revive = true;" \n
                         "" \n
                         "// Terminate existing effect script" \n
                         "terminate _active;" \n
                         "" \n
                         "// Execute effect" \n
                         "private [""_script""];" \n
                         "_script = [""REVIVE"", _unit] spawn EVO_fnc_reviveIconControl;" \n
                         "_active = _script;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Removed">*/
                                class Removed
                                {
                                        itemno = 17;
                                        priority = 3.000000;
                                        to="Terminate";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"(" \n
                                         "	alive _unit" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_incapacitated"", false])" \n
                                         ")" \n
                                         "||	" \n
                                         "!(_unit getVariable [""EVO_revive_iconEnabled"", true])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dead">*/
                                class Dead
                                {
                                        itemno = 3;
                                        priority = 2.000000;
                                        to="Dead_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"_state != ""DEAD""" \n
                                         "&&" \n
                                         "!(alive _unit)" \n
                                         "&&" \n
                                         "!(_unit getVariable [""EVO_revive_incapacitated"", false])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Incapacitated">*/
                                class Incapacitated
                                {
                                        itemno = 1;
                                        priority = 1.000000;
                                        to="Show_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_downed)" \n
                                         "&&" \n
                                         "alive _unit" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Being_revived">*/
                                class Being_revived
                                {
                                        itemno = 7;
                                        priority = 0.000000;
                                        to="Pulse_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "{" \n
                                         "	_state != ""DEAD""" \n
                                         "	&&" \n
                                         "	{" \n
                                         "		!(isNull (_unit getVariable [""EVO_revive_helper"", objNull]))" \n
                                         "	}" \n
                                         "}"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dying">*/
                                class Dying
                                {
                                        itemno = 5;
                                        priority = 0.000000;
                                        to="Pulse_skull";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "!(_state in [""DEAD"", ""DYING""])" \n
                                         "&&" \n
                                         "(" \n
                                         "	_unit getVariable [""EVO_revive_forceRespawn"", false]" \n
                                         "	||" \n
                                         "	_unit getVariable [""EVO_revive_dying"", false]" \n
                                         ")"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Not_dying">*/
                                class Not_dying
                                {
                                        itemno = 14;
                                        priority = 0.000000;
                                        to="Reset";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "(" \n
                                         "	!(_unit getVariable [""EVO_revive_forceRespawn"", false])" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_dying"", false])" \n
                                         ")" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Not_reviving">*/
                                class Not_reviving
                                {
                                        itemno = 15;
                                        priority = 0.000000;
                                        to="Reset";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"isNull (_unit getVariable [""EVO_revive_helper"", objNull])" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Terminate">*/
                class Terminate
                {
                        name = "Terminate";
                        itemno = 18;
                        init = /*%FSM<STATEINIT""">*/"terminate _active;" \n
                         "[[""REMOVE"", _unit], ""EVO_fnc_reviveIconControl""] call BIS_fnc_MP;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                        };
                };
                /*%FSM</STATE>*/
                /*%FSM<STATE "Reset">*/
                class Reset
                {
                        name = "Reset";
                        itemno = 19;
                        init = /*%FSM<STATEINIT""">*/"_state = """";" \n
                         "_revive = false;"/*%FSM</STATEINIT""">*/;
                        precondition = /*%FSM<STATEPRECONDITION""">*/""/*%FSM</STATEPRECONDITION""">*/;
                        class Links
                        {
                                /*%FSM<LINK "Removed">*/
                                class Removed
                                {
                                        itemno = 17;
                                        priority = 3.000000;
                                        to="Terminate";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"(" \n
                                         "	alive _unit" \n
                                         "	&&" \n
                                         "	!(_unit getVariable [""EVO_revive_incapacitated"", false])" \n
                                         ")" \n
                                         "||	" \n
                                         "!(_unit getVariable [""EVO_revive_iconEnabled"", true])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dead">*/
                                class Dead
                                {
                                        itemno = 3;
                                        priority = 2.000000;
                                        to="Dead_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"_state != ""DEAD""" \n
                                         "&&" \n
                                         "!(alive _unit)" \n
                                         "&&" \n
                                         "!(_unit getVariable [""EVO_revive_incapacitated"", false])"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Incapacitated">*/
                                class Incapacitated
                                {
                                        itemno = 1;
                                        priority = 1.000000;
                                        to="Show_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_downed)" \n
                                         "&&" \n
                                         "alive _unit" \n
                                         "&&" \n
                                         "_unit getVariable [""EVO_revive_incapacitated"", false]"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Being_revived">*/
                                class Being_revived
                                {
                                        itemno = 7;
                                        priority = 0.000000;
                                        to="Pulse_icon";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "{" \n
                                         "	_state != ""DEAD""" \n
                                         "	&&" \n
                                         "	{" \n
                                         "		!(isNull (_unit getVariable [""EVO_revive_helper"", objNull]))" \n
                                         "	}" \n
                                         "}"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                                /*%FSM<LINK "Dying">*/
                                class Dying
                                {
                                        itemno = 5;
                                        priority = 0.000000;
                                        to="Pulse_skull";
                                        precondition = /*%FSM<CONDPRECONDITION""">*/""/*%FSM</CONDPRECONDITION""">*/;
                                        condition=/*%FSM<CONDITION""">*/"!(_revive)" \n
                                         "&&" \n
                                         "!(_state in [""DEAD"", ""DYING""])" \n
                                         "&&" \n
                                         "(" \n
                                         "	_unit getVariable [""EVO_revive_forceRespawn"", false]" \n
                                         "	||" \n
                                         "	_unit getVariable [""EVO_revive_dying"", false]" \n
                                         ")"/*%FSM</CONDITION""">*/;
                                        action=/*%FSM<ACTION""">*/""/*%FSM</ACTION""">*/;
                                };
                                /*%FSM</LINK>*/
                        };
                };
                /*%FSM</STATE>*/
        };
        initState="Icon_Manager";
        finalStates[] =
        {
                "Terminate",
        };
};
/*%FSM</COMPILE>*/