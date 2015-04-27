// convoyDefend_init.sqf
// © APRIL 2013 - norrin
private ["_vcl","_markerArray","_convoyArray","_restartConvoy"]; 
if !(isnil ("NORRN_convoyDefend_init")) exitWith {};
NORRN_convoyDefend_init = true;
// define fncs
Norrn_convoyGetIn 	 	= Compile PreprocessFile "convoyDefend\getIn.sqf";
Norrn_convoyMaxSpeed 	= Compile PreprocessFile "convoyDefend\convoyMaxSpeed.sqf";
Norrn_convoyAmbush		= Compile PreprocessFile "convoyDefend\convoyAmbush.sqf";
Norrn_convoyMove		= Compile PreprocessFile "convoyDefend\convoyMove.sqf";
Norrn_convoyRestart		= Compile PreprocessFile "convoyDefend\convoyRestart.sqf";
// Passed vars
_markerArray 		 	= _this select 0;
_convoyArray 		 	= _this select 1;
_restartConvoy			= _this select 2;
// Start the convoy moving
[_markerArray,_convoyArray,_restartConvoy] spawn Norrn_convoyMove;


