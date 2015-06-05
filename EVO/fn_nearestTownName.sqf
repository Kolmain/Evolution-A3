private ["_closesttown","_town_name","_town_pos"];
_closesttown = (nearestLocations [(_this select 0),["NameCityCapital","NameCity","NameVillage"],10000]) select 0;

_town_name = text _closesttown;
_town_pos = position _closesttown;

[_town_name, _town_pos];
