#include "colors_include.hpp"
/*=================================================================================================================
  Simple Text Control by Jacmac

  Version History:
  A - Initial Release 3/16/2013
  B - Altered parameters and order for stc_DisplayShow, stc_DiplayHide, and stc_DisplayWrite. Use of 
  	cutRsc layer now. 10/13/2013

  Requirements:
  stc_include.hpp in description.ext

  Features:
  -Allows other scripts to use friendly calls for formatted text in a display control
  -Structured text helper functions for building strings

  Functions:

  stc_DisplayShow: Turns on the display control defined in stc_include.hpp 
  Accepts parameters:
  0: _layer: The cutRsc layer number (keep different controls on different layers for simultaneous display) 
  1: _display_name: The display control name in stc_include.hpp
  2: _control_number: The display control IDC number
  3: _background: Optional background color in ARRAY color format
  4: _font: Optional font name
  5: _x: 0 to 1 Absolute x position or safeZoneX relative x position of the display control (recommend using safeZoneX + 0 to 1)
  6: _y: 0 to 1 Absolute y position or safeZoneY relative y position of the display control (recommend using safeZoneY + 0 to 1)
  7: _h: 0 to 1 Absolute height of the display control
  8: _w: 0 to 1 Absolute width of the display control

  Example:
  [safeZoneX + 0.1,safeZoneY + 0.5,0.4,0.4] call stc_DisplayShow;
  will display the dialog on the left side half way down as a square box. The box will be blank until

  Use in init.sqf:
  call compile preProcessFile "simple_text_control.sqf";

=================================================================================================================*/


//_this = Array of parameters:
//0: The cutRsc layer number
//1: The display control name in stc_include.hpp
//2: The display control IDC number
//3: Optional background color
//4: Optional font name
//5: Optional control x screen location
//6: Optional control y screen location
//7: Optional control height
//8: Optional control width
stc_DisplayShow =
{
    private["_layer", "_x", "_y", "_h", "_w", "_pos", "_control", "_disp","_display_name","_control_number","_background","_font"];
    
    if (count _this > 0) then
    {
    	_display_name = _this select 1;
    	_control_number = _this select 2;
		_layer = _this select 0;
    	_layer cutRsc [_display_name,"PLAIN",0];
        _disp = uiNamespace getVariable ("d_" + _display_name);
        _control = _disp displayCtrl _control_number;
        _background = if (count _this > 3) then {_this select 3} else {[-1]};
        _x = if (count _this > 4) then {_this select 4} else {-1};
        _y = if (count _this > 5) then {_this select 5} else {-1};
        _h = if (count _this > 6) then {_this select 6} else {-1};
        _w = if (count _this > 7) then {_this select 7} else {-1};
        _font = if (count _this > 8) then {_this select 8} else {"-1"};
        if ((_background select 0) != -1) then {_control ctrlSetBackgroundColor _background};
        if (_font != "-1") then {_control ctrlSetFont _font};   
        _pos = ctrlPosition _control;
        if (_x != -1) then {_pos set [0,_x]};
        if (_y != -1) then {_pos set [1,_y]};
        if (_w != -1) then {_pos set [2,_w]};
        if (_h != -1) then {_pos set [3,_h]};
        _control ctrlSetPosition _pos;
        _control ctrlCommit 0;
        waitUntil {ctrlCommitted _control};
    };
};

//_this = The display control name in stc_include.hpp
stc_DisplayHide =
{
    private["_layer"];
	_layer = _this select 0;
    _layer cutRsc ["UC_Empty","PLAIN"];
};

//_this = Array of parameters:
//0: The display control name in stc_include.hpp
//1: The display control IDC number
//2: The structured text to display
stc_DisplayWrite =
{
	private["_disp","_control","_structured_text"];

	if (count _this > 0) then
    {
	    _display_name = _this select 0;
    	_control_number = _this select 1;
    	_structured_text = if (count _this > 2) then {_this select 2} else {" "};
	    _disp = uiNamespace getVariable ("d_" + _display_name);
	    _control = _disp displayCtrl _control_number;
	    _control ctrlSetStructuredText parseText _structured_text;
	    _control ctrlCommit 0;
	    waituntil {ctrlCommitted _control};
	};
};

//All text formatting helper functions use the same type of parameters
//_this = Array of parameters:
//0: Text segment to format
//1: RGB color for the text segment
stc_LineLeft =
{
    private["_msg"];
    _msg = format ["<t color=%2 align=left>%1</t><br />",_this select 0, _this select 1];
    _msg
};

stc_PartLeft =
{
    private["_msg"];
    _msg = format ["<t color=%2 align=left>%1</t>",_this select 0, _this select 1];
    _msg
};


stc_LineRight =
{
    private["_msg"];
    _msg = format ["<t color=%2 align=right>%1</t><br />",_this select 0, _this select 1];
    _msg
};

stc_LineCenter =
{
    private["_msg"];
    _msg = format ["<t color=%2 align=center>%1</t><br />",_this select 0, _this select 1];
    _msg
};

stc_LineBreak =
{
    private["_msg"];
    _msg = "<br />";
    _msg
};

stc_PartCenter =
{
    private["_msg"];
    _msg = format ["<t color=%2 align=center>%1</t>",_this select 0, _this select 1];
    _msg
};

stc_Title =
{
    private["_msg"];
    _msg =  format ["<t size='1.5' color=%2 align=center>%1</t><br />",_this select 0, _this select 1];
    _msg
};


