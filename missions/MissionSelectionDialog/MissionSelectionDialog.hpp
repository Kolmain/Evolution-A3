// Desc: Mission Selection Dialog
// Features: Mission preview and selection
// By: Dr Eyeball
// Purpose: Class descriptions for dialog control
// Version: 1.0 (Apr 2007)
//-----------------------------------------------------------------------------
// MSD8_ is the unique prefix associated with all unique classes for this dialog.

#define MSD8_MissionSelectionDialogIDD 384

#define MSD8_FontM "TahomaB"
#define MSD8_FontHTML "TahomaB"
//"CourierNewB64" "TahomaB" "Bitstream" "Zeppelin32"

#define MSD8_ST_HPOS       0x0F
#define MSD8_ST_LEFT       0
#define MSD8_ST_RIGHT      1
#define MSD8_ST_CENTER     2
#define MSD8_ST_FRAME      64

#define MSD8_CT_STATIC     0
#define MSD8_CT_BUTTON	    1
#define MSD8_CT_EDIT       2
#define MSD8_CT_SLIDER	    3
#define MSD8_CT_COMBO      4
#define MSD8_CT_LISTBOX    5
#define MSD8_CT_HTML        9
#define MSD8_CT_ACTIVETEXT 11
#define MSD8_CT_3DSTATIC     20
#define MSD8_CT_3DACTIVETEXT 21
#define MSD8_CT_3DLISTBOX    22
#define MSD8_CT_3DHTML       23
#define MSD8_CT_3DSLIDER     24
#define MSD8_CT_3DEDIT       25
#define MSD8_CT_OBJECT	           80
#define MSD8_CT_OBJECT_ZOOM       81
#define MSD8_CT_OBJECT_CONTAINER  82
#define MSD8_CT_OBJECT_CONT_ANIM  83

#define MSD8_color_Clear {0, 0, 0, 0}
#define MSD8_color_Black {0, 0, 0, 1}
#define MSD8_color_White {1, 1, 1, 1}
#define MSD8_color_White20 {1, 1, 1, 0.2}
#define MSD8_color_White50 {1, 1, 1, 0.5}
#define MSD8_color_Red {1, 0, 0, 1}
#define MSD8_color_paleBlue {0.41, 0.33, 0.39, 0.5}
#define MSD8_color_paleRed {0.7, 0.3, 0.3, 0.7}
#define MSD8_color_Aqua10 {0, 0, 0, 0.1}
#define MSD8_color_Yellow40 {0, 0, 0, 0.4}
#define MSD8_color_Red10 {1, 0, 0, 0.1}
#define MSD8_color_Pink20 {0, 0, 0, 0.2}

#define MSD8_color_Gray_10 {0.1, 0.1, 0.1, 0.5}
#define MSD8_color_Gray_20 {0.2, 0.2, 0.2, 0.5}
#define MSD8_color_Gray_30 {0.3, 0.3, 0.3, 0.5}
#define MSD8_color_Gray_40 {0.4, 0.4, 0.4, 0.5}
#define MSD8_color_Gray_50 {0.5, 0.5, 0.5, 0.5}
#define MSD8_color_Gray_40_75 {0.4, 0.4, 0.4, 0.75}

#define MSD8_ROWS 36

#define MSD8_ROWHGT ((100/(MSD8_ROWS+1))/100) // +1 reserves bottom row
#define MSD8_FIRSTROW (1*MSD8_ROWHGT)

#define MSD8_ROWHGT_MOD 1.0
#define MSD8_TEXTHGT_MOD 1.3

//-----------------------------------------------------------------
// Define map attr's
#define K_Back	    {0.95, 0.95, 0.95, 1.00}	// background color of the map
#define K_B	    0.004			// thickness of the map border
#define K_B_Color   {0.00, 0.00, 0.00, 0.20}	// color     of the map border

//-----------------------------------------------------------------
class MSD8_RscText
{
  type = MSD8_CT_STATIC;
  idc = -1;
  style = MSD8_ST_LEFT;
  colorBackground[] = MSD8_color_Black;
  colorText[] = MSD8_color_White;
  font = MSD8_FontM;
  sizeEx = MSD8_ROWHGT/MSD8_TEXTHGT_MOD;
  h = MSD8_ROWHGT/MSD8_ROWHGT_MOD;
  text = "";
};

class MSD8_RscActiveText
{
  type = MSD8_CT_ACTIVETEXT;
  idc = -1;
  style = MSD8_ST_LEFT;
  color[] = MSD8_color_White;
  colorActive[] = MSD8_color_Red;
  font = MSD8_FontM;
  sizeEx = 0.04/3;
  soundEnter[] = {"ui\ui_over", 0.2, 1};
  soundPush[] = {, 0.2, 1};
  soundClick[] = {"ui\ui_ok", 0.2, 1};
  soundEscape[] = {"ui\ui_cc", 0.2, 1};
  default = false;
};

class MSD8_RscButton
{
  type = MSD8_CT_BUTTON;
  idc = -1;
  style = MSD8_ST_CENTER;

  colorText[] = MSD8_color_White;
  colorDisabled[] = MSD8_color_Aqua10; // added
  colorBackground[] = MSD8_color_Gray_20; // added
  colorBackgroundActive[] = MSD8_color_Yellow40; // added
  colorBackgroundDisabled[] = MSD8_color_Red10; // added
  colorFocused[] = MSD8_color_Black; // added
  colorShadow[] = MSD8_color_Pink20; // added
  colorBorder[] = MSD8_color_White20; // added

  offsetX = 0;
  offsetY = 0;
  offsetPressedX = 0;
  offsetPressedY = 0;
  borderSize = 0.001;
  soundEnter[] = {"ui\ui_ok", 0.2, 1};

  font = MSD8_FontHTML;
  sizeEx = MSD8_ROWHGT/MSD8_TEXTHGT_MOD;
  soundPush[] = {, 0.2, 1};
  soundClick[] = {"ui\ui_ok", 0.2, 1};
  soundEscape[] = {"ui\ui_cc", 0.2, 1};
  default = false;
  text = "";
  action = "";
};

class MSD8_RscEdit
{
 type = MSD8_CT_EDIT;
 idc = -1;
 style = MSD8_ST_LEFT;
 font = MSD8_FontHTML;
 sizeEx = 0.02/3;
 colorText[] = MSD8_color_Black;
 colorSelection[] = MSD8_color_Gray_50;
 autocomplete = false;
 text = "";
};

class MSD8_RscLB_C
{
  style = MSD8_ST_LEFT;
  idc = -1;

  colorText[] = MSD8_color_White;
  colorBackground[] = MSD8_color_Gray_40;
  colorSelect[] = MSD8_color_White;
  colorSelect2[] = MSD8_color_White;
  colorSelectBackground[] = MSD8_color_paleRed;
  colorSelectBackground2[] = MSD8_color_paleRed;
  colorScrollbar[] = MSD8_color_White;
  color[] = MSD8_color_White;

  font = MSD8_FontHTML;
  sizeEx = MSD8_ROWHGT/MSD8_TEXTHGT_MOD;
  h = MSD8_ROWHGT/MSD8_ROWHGT_MOD; // added
  rowHeight = MSD8_ROWHGT/MSD8_ROWHGT_MOD;

  soundSelect[] = {"ui\ui_cc", 0.2, 1}; // added
  soundExpand[] = {"ui\ui_cc", 0.2, 1}; // added
  soundCollapse[] = {"ui\ui_cc", 0.2, 1}; // added
};

class MSD8_RscListBox : MSD8_RscLB_C
{
  type = MSD8_CT_LISTBOX;
};

class MSD8_RscCombo : MSD8_RscLB_C
{
  type = MSD8_CT_COMBO;
  wholeHeight = 0.3;
};

class MSD8_RscObject
{
	type = MSD8_CT_OBJECT;
	scale = 1.0;
	direction[] = {0, 0, 1};
	up[] = {0, 1, 0};
};

class MSD8_Rsc3DStatic
{
	type = MSD8_CT_3DSTATIC;
	font = MSD8_FontHTML;
	style = MSD8_ST_LEFT;
	selection = "display";
	angle = 0;
	size = 0.04;
	color[] = MSD8_color_Black;
};

class MSD8_RscPicture
{
	type = MSD8_CT_STATIC;
	idc = -1;
	style = ST_PICTURE;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {1, 1, 1, 1};
	font = Zeppelin32;
	sizeEx = 0;
};

// not sure if this is a suitable definition for html?
class MSD8_RscHTML //: RscHTML
{
  type = MSD8_CT_HTML;
  idc = -1;
  style = 0;

	colorText[] = {1, 1, 1, 1};
	colorLink[] = {0.05, 0.2, 0.05, 1};
	colorBold[] = {0, 0, 0, 1};
	colorBackground[] = {0, 0, 0, 0.5};
	colorLinkActive[] = {0, 0, 0.2, 1};
	colorPicture[] = {0, 0, 0, 1};
	colorPictureLink[] = {0, 0, 0, 1};
	colorPictureSelected[] = {0, 0, 0, 1};
	colorPictureBorder[] = {0, 0, 0, 1};
	prevPage = "\ca\ui\data\arrow_left_ca.paa";
	nextPage = "\ca\ui\data\arrow_right_ca.paa";
	filename = "";

	class H1 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.02474;
	};

	class H2 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.0286458;
	};

	class H3 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.0286458;
	};

	class H4 {
		font = "Zeppelin33Italic";
		fontBold = "Zeppelin33";
		sizeEx = 0.0208333;
	};

	class H5 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.0208333;
	};

	class H6 {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.0208333;
	};

	class P {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = 0.0208333;
	};
};

//------------------------------------------------
class MSD8_CELLButton: MSD8_RscButton
{
  x = 0.01;
  y = 0.98;
  w = 0.15;
  h = MSD8_ROWHGT/MSD8_ROWHGT_MOD;
};

class MSD8_MainButton: MSD8_CELLButton
{
  y = 1.0-(MSD8_ROWHGT/MSD8_ROWHGT_MOD);
};

//------------------------------------------------
class MSD8_MissionSelectionDialog
{
  idd = MSD8_MissionSelectionDialogIDD;

  movingEnable = true;
  controlsBackground[] = { MY_BACKGROUND, MY_FRAME };

  //---------------------------------------------
  class MY_BACKGROUND : MSD8_RscText
  {
    idc = -1;
    colorBackground[] = MSD8_color_Gray_10;
    text = ;
    x = 0.0;
    y = 0.0;
    w = 1.0;
    h = 1.0;
  };
  class MY_FRAME : MSD8_RscText
  {
    idc = -1;
    style = MSD8_ST_FRAME;
    colorText[] = MSD8_color_White;
    text = " Mission Selection ";
    font = MSD8_FontHTML;
    sizeEx = MSD8_ROWHGT/MSD8_TEXTHGT_MOD;
    x = 0.0;
    y = 0.0;
    w = 1.0;
    h = 1.0;
  };
  //---------
  objects[] =
  {
  };
  controls[] =
  {
    MSD8_MissionListCaption,
    MSD8_MissionList,

    MSD8_MissionDescriptionCaption,
    MSD8_MissionDescription,

    MSD8_MissionPictureCaption,
    MSD8_MissionPicture,

    MSD8_MissionMapCaption,
    MSD8_MissionMap,

    MSD8_StatsCaption,
    MSD8_Stats,

    MSD8_CloseButton,
    MSD8_AcceptMissionButton
  };
  //---------------------------------------------
  // captions
  class MSD8_MissionListCaption : MSD8_RscText
  {
    x = 0.01;
    y = 0.03;
    w = 0.51;
    text = "Mission List";
  };
  class MSD8_MissionMapCaption : MSD8_RscText
  {
    x = 0.01;
    y = 0.42;
    w = 0.51;
    text = "Location Map";
  };
  class MSD8_MissionDescriptionCaption : MSD8_RscText
  {
    x = 0.54;
    y = 0.03;
    w	= 0.45;
    text = "Description";
  };
  class MSD8_MissionPictureCaption : MSD8_RscText
  {
  	x	= 0.54;
  	y	= 0.68;
    w = 0.18;
    text = "";
  };
  class MSD8_StatsCaption : MSD8_RscText
  {
  	x	= 0.74;
    y = 0.68;
    w = 0.25;
    text = "Bonus";
  };
  //---------------------------------------------
  // Controls
  class MSD8_MissionList : MSD8_RscListBox
  {
    idc = 891;
    x = 0.01;
    y = 0.07;
    w = 0.51;
    h = 0.3;
    //text = "";

    onLBSelChanged = "[_this] call MSD8_ViewMission";
    //onLBDblClick = "[_this] call MSD8_AcceptMission";
  };
  class MSD8_MissionMap: RscMapControl
  {
    idc = 895;
  	colorBackground[] = K_Back;
    x = 0.01;
    y = 0.46;
  	w	= 0.51;
  	h	= 0.5;
  };
  class MSD8_MissionDescription : MSD8_RscHTML // MSD8_RscListBox
  {
    idc = 892;
    x = 0.54;
    y = 0.07;
    w	= 0.45;
    h = 0.57;
    //text = "";
  };
  class MSD8_MissionPicture : MSD8_RscPicture
  {
    idc = 893;
    //style = MSD8_ST_CENTER;
  	x	= 0.54;
  	y	= 0.72;
    w = 0.18;
    h = 0.24;
    text = "";
    sizeEx = 0.04;
    style=48;
  };
  class MSD8_Stats : MSD8_RscText
  {
    idc = 894;
    colorBackground[] = MSD8_color_Clear;
  	x	= 0.74;
    y = 0.72;
    w = 0.25;
    text = "Points: 99, Distance: 9000m";
  };
  //---------------------------------------------
  // buttons
  class MSD8_AcceptMissionButton : MSD8_MainButton
  {
  	idc = -1;
  	x = 0.1;
  	text = "Accept Mission";
  	action = "[] call MSD8_AcceptMission";
  };
  //---------
  class MSD8_CloseButton : MSD8_MainButton
  {
  	idc = -1;
  	x = 0.3;
  	text = "Exit";
  	action = "closeDialog 0";
  };
  //---------------------------------------------
};
