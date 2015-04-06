 //[punit,pmis,prew] execVM missionsselectmis.sqf
 
 _punit = _this select 0;
 _pmis = _this select 1;
 _prew = _this select 2;
 pmis = 0;

if (not (local server) and not (local punit)) exitWith {};

 
 switch (_pmis) do //heavy wep
 {
    	 case 1:
    	{
    		_run = [_punit,_prew] execVM "missions\Mass.sqf"
    	};
    	 case 2:
    	{
    		_run = [_punit,_prew] execVM "missions\Mlpat.sqf"
    	}; 
    	 case 3:
    	{
    		_run = [_punit,_prew] execVM "missions\Mwpat.sqf"
    	};
    	 case 4:
    	{
    		_run = [_punit,_prew] execVM "missions\Mdst.sqf"
    	};
    	 case 5:
    	{
    		_run = [_punit,_prew] execVM "missions\Mcsar.sqf"	
    	};
    	 case 6:
    	{
    		_run = [_punit,_prew] execVM "missions\Mcsarb.sqf"
    	};  
    	 case 7:
    	{
    		_run = [_punit,_prew] execVM "missions\Mdefn.sqf"
    	};
    	 case 8:
    	{
    		_run = [_punit,_prew] execVM "missions\Msaad.sqf"
    	};  
    	 case 9:
    	{
    		_run = [_punit,_prew] execVM "missions\Mapat.sqf"
    	};     	
};