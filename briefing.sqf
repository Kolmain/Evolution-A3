//TODO fix rank vehicles display to add prank and crank as needed
_index = player createDiarySubject ["OPREP","OPREP"];
player createDiaryRecord ["OPREP", ["Situation", "CSAT forces have established a foothold in Altis alongside the AAF. Fighting has erupted all over the island. NATO expeditionary forces have established a staging area on the southeast corner of the island."]];
player createDiaryRecord ["OPREP", ["Enemy Forces", "OPFOR infantry companies have secured the villages and cities of Altis, and are dug in expecting assault. Additional OPFOR support assets have been spotted throughout the island. Expect OPFOR CAS and indirect fire support. Forward recon elements also discovered a significant AAA network covering the island, and have marked the known air coverage locations."]];
player createDiaryRecord ["OPREP", ["Friendly Forces", "NATO has deployed an expeditionary platoon and established a staging base on the southeast corner of the island. While primarily an infantry fighting unit, the force will have auxiliary support assets available. Prioritization will be to the highest ranking requestors."]];
player createDiaryRecord ["OPREP", ["Mission", "Eradicated CSAT prescence on the island of Altis and systematically secure each village and city throughout the island."]];
player createDiaryRecord ["OPREP", ["Execution", "NATO high command has issued orders to retake the island via a systematic approach. We will be receiving intel from our forward recon teams and leaders will be receiving new orders as we receive them. Infantry movement will be supported by light armor and air cover as we move towards the island."]];
_index = player createDiarySubject ["Gamemode","Gamemode"];
_rankString = "You are awarded field promotions based on your score:";
_rankString = _rankString + format ["<br/><img image='img\pvt.paa' width='32' height='32'/> %1 points   = PRIVATE<br/>
<img image='img\corp.paa' width='32' height='32'/> %2 points  = CORPORAL<br/>
<img image='img\sgt.paa' width='32' height='32'/> %3 points  = SERGEANT<br/>
<img image='img\ltn.paa' width='32' height='32'/> %4 points  = LIEUTENANT<br/>
<img image='img\cpt.paa' width='32' height='32'/> %5 points = CAPTAIN<br/>
<img image='img\mjr.paa' width='32' height='32'/> %6 points = MAJOR<br/>
<img image='img\col.paa' width='32' height='32'/> %7 points = COLONEL<br/><br/>", 0, rank1, rank2, rank3, rank4, rank5, rank6];
player createDiaryRecord ["Gamemode", ["Player Ranks", _rankString]];


_assetString = "Each rank unlocks new vehicles for you to utilize:";
_assetString = _assetString + "<br/><img image='img\pvt.paa' width='32' height='32'/><br/> PRIVATE <br/><br/>";
{
	_displayName = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach srank0vehicles;
_assetString = _assetString + "<br/><img image='img\corp.paa' width='32' height='32'/><br/> CORPORAL <br/><br/>";
{
	_displayName = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach srank1vehicles;
_assetString = _assetString + "<br/><img image='img\sgt.paa' width='32' height='32'/><br/> SERGEANT <br/><br/>";
{
	_displayName = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach srank2vehicles;
_assetString = _assetString + "<br/><img image='img\ltn.paa' width='32' height='32'><br/> LIEUTENANT <br/><br/>";
{
	_displayName = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach srank3vehicles;
_assetString = _assetString + "<br/><img image='img\cpt.paa' width='32' height='32'/><br/> CAPTAIN <br/><br/>";
{
	_displayName = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach srank4vehicles;
_assetString = _assetString + "<br/><img image='img\mjr.paa' width='32' height='32'><br/> MAJOR <br/><br/>";
{
	_displayName = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach srank5vehicles;
_assetString = _assetString + "<br/><img image='img\col.paa' width='32' height='32'/><br/> COLONEL <br/><br/>";
{
	_displayName = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach srank6vehicles;
player createDiaryRecord ["Gamemode", ["Assets", _assetString]];


_assetString = "Each rank unlocks new weapons for you to use:";
_assetString = _assetString + "<br/><img image='img\pvt.paa' width='32' height='32'/><br/> PRIVATE <br/><br/>";
{
	_displayName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach sorank0weap;
_assetString = _assetString + "<br/><img image='img\corp.paa' width='32' height='32'/><br/> CORPORAL <br/><br/>";
{
	_displayName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach sorank0weap;
_assetString = _assetString + "<br/><img image='img\sgt.paa' width='32' height='32'/><br/> SERGEANT <br/><br/>";
{
	_displayName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach sorank0weap;
_assetString = _assetString + "<br/><img image='img\ltn.paa' width='32' height='32'/><br/> LIEUTENANT <br/><br/>";
{
	_displayName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach sorank0weap;
_assetString = _assetString + "<br/><img image='img\cpt.paa' width='32' height='32'><br/> CAPTAIN <br/><br/>";
{
	_displayName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach sorank0weap;
_assetString = _assetString + "<br/><img image='img\mjr.paa' width='32' height='32'/><br/> MAJOR <br/><br/>";
{
	_displayName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach sorank0weap;
_assetString = _assetString + "<br/><img image='img\col.paa' width='32' height='32'/><br/> COLONEL <br/><br/>";
{
	_displayName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	_assetString = _assetString + _displayName + "<br/>";
} forEach sorank0weap;
player createDiaryRecord ["Gamemode", ["Weapons", _assetString]];




player createDiaryRecord ["Gamemode", ["Hints", "You can Request a HALO drop from the staging base spawn area. It's free until you are a Corporal, after which will cost you 3 points.
<br/>
<br/>
The Radio Towers can only be destroyed with explosives set by infantry.
<br/>
<br/>
If you kill an unarmed enemy you will be fined 8 points.
<br/>
<br/>
You can join or create squads at the spawn area in the staging base, or by pressing 'U' at anytime.
<br/>
<br/>
As a commander you have many support assets available to you.
<br/>
<br/>
You can recruit AI squadmates at the staging base spawn area, or in the field via the communication menu.
<br/>
<br/>
You can choose a side mission for your platoon to take on at the spawn area in the staging base. Only one sidemission is active at a time.
<br/>
<br/>
If you disconnect and reconnect your score and rank will be retained, and you will be moved to the last location with the loadout you had at the time.
<br/>
<br/>
You can earn points by transporting friendly players.
<br/>
<br/>
If you are in command of a vehicle, stop at the airbase, a FARP or a dock to be fully serviced.
<br/>
<br/>
If you are a medic you can set up a MASH (Mobile Army Surgical Hospital). When players heal (enemy inflicted wounds) you get points. As a medic your priority must be healing.
<br/>
<br/>
If you are an engineer you can set up a FARP (Forward Arming and Refueling Point) when you are near a repair vehicle. If you fully repair a marked vehicle at your farp you will earn points, As an engineer your priority must be repairing damaged vehicles.
<br/>
<br/>
You can set your terrain detail (grass), View distance and Air view distance (How far you see in a plane or chopper) in the spawn area at the staging base.
<br/>
<br/>
Each town contains a radio tower, If you destroy it you will receive 10 points, It also stops any further reinforcements being sent to the town under siege. Careful, there may be some on the way already.
<br/>
<br/>
When each town falls, remaining troops drop their guns and can be captured and returned to base for 5 points. Never shoot unarmed soldiers as they may be someones prisoner.
<br/>
<br/>
In each town is an officer, If you capture him and return him to base it is worth 20 points, To capture him you must first identify him (default right click) then choose the option capture. Never shoot the officer, he is always unarmed."]];
