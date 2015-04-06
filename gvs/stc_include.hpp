/*=================================================================================================================
  STC Include by Jacmac

  Version History:
  A - Initial Release 3/22/2013
  B - Adjusted documentation, no script alterations 3/26/2013
  C - Altered classes, UC_Empty takes the place of the previously overly complex hide control 10/2/2013

  Requirements:
  colors_include.hpp
  control_include.hpp (or your own control includes, these are standard)

  Features:
  Display and dialog classes to be included in simple_text_control.sqf

  Use in description.ext:
  #include "stc_include.hpp"

=================================================================================================================*/

#include "colors_include.hpp"
#include "control_include.hpp"

#define DISPLAY_SMALL_BACKGROUND_COLOR  COLOR_HALF_GREY

class UC_Display_Small {
    idc = -1;
    type = CT_STRUCTURED_TEXT;
    style = ST_LEFT;
    colorBackground[] = DISPLAY_SMALL_BACKGROUND_COLOR;
    x=0.3;
    y=safeZoneY;
    w=0.4;
    h=0.2;
    size = 0.024;
    text = "";
    fixedWidth = 1;
    class Attributes{
        font = "TahomaB";
        color = HTMLCOLOR_WHITE;
        align = "left";
        valign = "top";
        shadow = true;
        shadowColor = HTMLCOLOR_BLACK;
        underline = false;
        size = "1";
    };
};

class RscTitles
{
    titles[]={};
    
    class UC_Empty 
    {
		idd = -1;
		duration = 0;
		class controls {};
	};
	
    class UC_ShowText_small
    {
        idd=-1;
        movingEnable=0;
        duration=10e30;
        fadein = 0;
        name="UC_ShowText1";
        onLoad = "uiNamespace setVariable ['d_UC_ShowText_small', _this select 0]";
        controls[]={"textUC_Show1"};
        class textUC_Show1 : UC_Display_small
        {
            idc = 301;
        };
    };
};
