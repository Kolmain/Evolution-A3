// Desc: Mission Selection Dialog
// Features: Mission preview and selection
// By: Dr Eyeball
// File purpose: Script & functions for dialog control
// Version: 1.0 (Apr 2007)
//-----------------------------------------------------------------------------
// The following variables should match their equivalents for the dialog (from description.ext or included file)
MSD8_MissionSelectionDialogIDD = 384;
//-----------------------------------------------------------------------------

MSD8_color_white = [1.0, 1.0, 1.0, 1.0];
MSD8_color_black = [0.0, 0.0, 0.0, 1.0];
MSD8_color_maroon = [0.5, 0.0, 0.2, 1.0];
MSD8_color_red = [1.0, 0.0, 0.0, 1.0];
MSD8_color_green = [0.0, 1.0, 0.0, 1.0];
MSD8_color_blue = [0.0, 0.0, 1.0, 1.0];
MSD8_color_orange = [0.8, 0.2, 0.1, 1.0];
MSD8_color_yellow = [.85, .85, 0.0, 1.0];
MSD8_color_ltPurple = [0.7, 0.7, 1.0, 1.0];
MSD8_color_paleYellow = [.35, .35, 0.0, 1];
MSD8_color_paleGreen = [0.33, 0.73, 0.49, 0.5];
MSD8_color_paleBlue = [0.3, 0.3, 0.7, 0.5];
MSD8_color_paleBlue2 = [0, 0.4, 0.7, 1];
MSD8_color_paleRed = [0.7, 0.3, 0.3, 0.7];
MSD8_color_Gray_10 = [0.1, 0.1, 0.1, 1];
MSD8_color_Gray_20 = [0.2, 0.2, 0.2, 1];
MSD8_color_Gray_30 = [0.3, 0.3, 0.3, 1];
MSD8_color_Gray_40 = [0.4, 0.4, 0.4, 1];
MSD8_color_Gray_50 = [0.5, 0.5, 0.5, 1];

MSD8_color_default = [-1.0, -1.0, -1.0, -1.0];
MSD8_color_textFG = MSD8_color_white;
MSD8_color_groupBG = MSD8_color_paleBlue2;
MSD8_color_playerBG = MSD8_color_paleyellow;
MSD8_color_cellABG = MSD8_color_Gray_20;
MSD8_color_cellBBG = MSD8_color_Gray_30;
MSD8_color_voidBG = MSD8_color_Gray_10;

MSD8_MissionListIDC = 891;
MSD8_MissionMapIDC = 895;
MSD8_MissionDescriptionIDC = 892;
MSD8_MissionPictureIDC = 893;
MSD8_StatsIDC = 894;
MSD8_bonus = "";
MSD8_type = 0;
//-----------------------------------------------------------------------------
//---- Control functions
//-----------------------------------------------------------------------------
MSD8_SetCtrlColors =
{
  _idc2 = _this select 0;
  _fg2 = _this select 1;
  _bg2 = _this select 2;

  _control = MSD8_display displayCtrl _idc2;

  _control ctrlSetTextColor _fg2;
  _control ctrlSetBackgroundColor _bg2;
};
//----------------------
MSD8_SetText =
{
  _idc2 = _this select 0;
  _txt2 = _this select 1;

  _control = MSD8_display displayCtrl _idc2;

  ctrlSetText [_idc2, _txt2];
  //_control ctrlSetTooltip _txt2; // doesn't do anything for text ctrl types

  //_this call MSD8_SetCtrlColors;
};
//----------------------
MSD8_SetCombo =
{
  _idc2 = _this select 0;
  _txtArray2 = _this select 1;

  _control = MSD8_display displayCtrl _idc2;

  //ctrlSetText [_idc2, Format["%1", _txtArray2]];
  //_control ctrlSetTooltip Format["%1", _txtArray2];

  lbClear _idc2;
  {
    _index = lbAdd [_idc2, _x];
    lbSetData [_idc2, _index, _x];
  } forEach _txtArray2;

  lbSetCurSel [_idc2, 0];

  //_this call MSD8_SetCtrlColors;
};
//-----------------------------------------------------------------------------
//---- Mission Selection functions
//-----------------------------------------------------------------------------

//----------------------
MSD8_ViewMission =
{
  _selection = _this select 0;

  _control = _selection select 0;
  _selectedIndex = (_selection select 1)+1;

  // get briefing description html file name
  _briefFile = "";
  _imageFile = "";
  _objPos = getmarkerpos "missions";
  _basePos = getmarkerpos "missions";



_sco = score player;
//hint format ["%1 %2",_sco,rank5];
if(_sco < rank2) then
{
  switch (_selectedIndex) do
  {
    case 01: { _briefFile = "AMBU_1"; MSD8_type = 1; MSD8_bonus = 10; _objPos = getmarkerpos "missions"; _imageFile = "sabotage.paa" };
    case 02: { _briefFile = "WPAT_1"; MSD8_type = 3; MSD8_bonus = 10; _objPos = getmarkerpos "missions"; _imageFile = "offensive.paa" };
    case 03: { _briefFile = "DSTR_1"; MSD8_type = 4; MSD8_bonus = 10; _objPos = getmarkerpos "missions"; _imageFile = "sabotage.paa" };
    case 04: { _briefFile = "CSAR_1"; MSD8_type = 6; MSD8_bonus = 10; _objPos = getmarkerpos "missions"; _imageFile = "defend.paa" };
    default { hint "Invalid mission index" };
  };
};
if(_sco >= rank2 and _sco < rank5) then
{
  switch (_selectedIndex) do
  {
    case 01: { _briefFile = "LPAT_2"; MSD8_type = 2; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "offensive.paa" };
    case 02: { _briefFile = "AMBU_2"; MSD8_type = 1; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "sabotage.paa" };
    case 03: { _briefFile = "DSTR_2"; MSD8_type = 4; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "sabotage.paa" };
    case 04: { _briefFile = "CSAR_2"; MSD8_type = 5; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "defend.paa" };
    case 05: { _briefFile = "DEFN_1"; MSD8_type = 7; MSD8_bonus = 30; _objPos = getmarkerpos "missions"; _imageFile = "defend.paa" };
    default { hint "Invalid mission index" };
  };
};
if(_sco >= rank5) then
{
  switch (_selectedIndex) do
  {
    case 01: { _briefFile = "LPAT_2"; MSD8_type = 2; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "offensive.paa" };
    case 02: { _briefFile = "AMBU_2"; MSD8_type = 1; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "sabotage.paa" };
    case 03: { _briefFile = "DSTR_2"; MSD8_type = 4; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "sabotage.paa" };
    case 04: { _briefFile = "CSAR_2"; MSD8_type = 5; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "defend.paa" };
    case 05: { _briefFile = "DEFN_1"; MSD8_type = 7; MSD8_bonus = 30; _objPos = getmarkerpos "missions"; _imageFile = "defend.paa" };
    case 06: { _briefFile = "MCAP_1"; MSD8_type = 9; MSD8_bonus = 20; _objPos = getmarkerpos "missions"; _imageFile = "offensive.paa" };
    default { hint "Invalid mission index" };
   };
};



  _language = localize "LANGUAGE";
  if (_language == "") then { _language = "English" };

  // show briefing description
  _PathName = format["missions\briefings\%1\%2.html", _language, _briefFile];
  _control = MSD8_display displayCtrl MSD8_MissionDescriptionIDC;
  _control htmlLoad _PathName;
  //hint format["Missio pathname=%1", _PathName]; // debug

  // show image
  _PathName = format["img\%1", _imageFile];
  ctrlSetText [MSD8_MissionPictureIDC, _PathName ];

  // show bonus points
 ctrlSetText [MSD8_StatsIDC, format["Points: %1", MSD8_bonus]];
  /*
  //---- show map location
  _ctrl = MSD8_display displayctrl MSD8_MissionMapIDC;
  ctrlMapAnimClear _ctrl; // reset while scrolling list

  _ctrl ctrlmapanimadd [0, 0.30, _basePos]; // show home base
  ctrlmapanimcommit _ctrl;

  _ctrl ctrlmapanimadd [1.2, 0.90, _objPos]; // show mission location
  ctrlmapanimcommit _ctrl;
  //Waituntil {ctrlMapAnimDone _ctrl};

  _ctrl ctrlmapanimadd [0.2, 0.20, _objPos]; // zoom mission location
  ctrlmapanimcommit _ctrl;
  //Waituntil {ctrlMapAnimDone _ctrl};
  */
};
//----------------------
MSD8_AcceptMission =
{
  _selectedIndex = lbCurSel MSD8_MissionListIDC;

  //hint format["Mission selected: %1 '%2'", _selectedIndex, lbData [MSD8_MissionListIDC, _selectedIndex] ];
  if (onmission) then {hint localize "EVO_001"};
  if (not onmission) then {_launch = [MSD8_type,MSD8_bonus] execVM "missions\cselectmis.sqf";onmission = true};
};
//----------------------

MSD8_Start =
{
  [MSD8_MissionListIDC,
    [
    "Ambush (10)",
    "Water Patrol (10)",
    "mil_destroy (10)",
    "Combat Search & Rescue (10)"
    ]
  ] call MSD8_SetCombo;
};

MSD8_StartB =
{
  [MSD8_MissionListIDC,
    [
    "Land Patrol (20)",
    "Ambush (20)",
    "mil_destroy (20)",
    "Combat Search & Rescue (20)",
    "Defence (30)"
    ]
  ] call MSD8_SetCombo;
};

MSD8_StartC =
{
  [MSD8_MissionListIDC,
    [
    "Land Patrol (20)",
    "Ambush (20)",
    "mil_destroy (20)",
    "Combat Search & Rescue (20)",
    "Defence (30)",
    "Combat Air Patrol (20)"
    ]
  ] call MSD8_SetCombo;
};
/*
MSD8_Start =
{
  [MSD8_MissionListIDC,
    [
    "Water Patrol (10)",
    "Ambush (10)",
    "mil_destroy (10)",
    "Combat Search & Rescue (10)",

    "Ambush (20)",
    "Land Patrol (20)",
    "mil_destroy (20)",
    "Combat Search & Rescue (20)",
    ]
  ] call MSD8_SetCombo;
};
*/
//-----------------------------------------------------------------------------
//---- Init
//-----------------------------------------------------------------------------

/*
_Caller = _this select 1;
if (_Caller != player) exitWith { };
*/

_ok = createDialog "MSD8_MissionSelectionDialog";
if !(_ok) then { hint "createDialog failed" };

MSD8_display = findDisplay MSD8_MissionSelectionDialogIDD;

_sco = score player;
if(_sco < rank2) then
{
	[] call MSD8_Start;
};
if(_sco >= rank2 and _sco < rank5) then
{
	[] call MSD8_StartB
};
if(_sco >= rank5) then
{
	[] call MSD8_StartC
};