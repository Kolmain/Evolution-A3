if(debug) exitwith {};
enableradio false;

_camera = "camera" CamCreate [9530.36,10112.63,18.97];
_camera cameraEffect ["internal","back"];
_camera camCommand "inertia on";

_camera camPrepareTarget [90913.70,-20587.53,49496.60];

_camera camPreparePos [9530.36,10112.63,18.97];

_camera camPrepareFOV 0.700;

_camera camCommitPrepared 0;

WaitUntil {camCommitted _camera};
titleCut["", "BLACK in",2];
sleep 1.0;

//TitleRsc["Evo","PLAIN"];
playsound "Recall";



_camera camPrepareTarget [101585.70,-24613.33,-17727.94];

_camera camPreparePos [9530.36,10112.63,18.97];

_camera camPrepareFOV 0.700;

_camera camCommitPrepared 5;

waitUntil {camCommitted _camera};

player cameraEffect ["terminate","back"];

enableradio true;

camdestroy _camera;