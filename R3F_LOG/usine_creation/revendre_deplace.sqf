/**
 * Revendre l'objet d�plac� par le joueur � une usine
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_verrou) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	private ["_objet", "_usine"];
	
	_objet = R3F_LOG_joueur_deplace_objet;
	_usine = [_objet, 5] call R3F_LOG_FNCT_3D_cursorTarget_virtuel;
	
	if (!isNull _usine && {
		!(_usine getVariable ["R3F_LOG_CF_disabled", true]) && alive _usine && (vectorMagnitude velocity _usine < 6) &&
		(abs ((getPosASL _usine select 2) - (getPosASL player select 2)) < 2.5)
	}) then
	{
		if (isNull (_objet getVariable ["R3F_LOG_remorque", objNull])) then
		{
			if (count (_objet getVariable ["R3F_LOG_objets_charges", []]) == 0) then
			{
				_objet setVariable ["R3F_LOG_est_transporte_par", _usine, true];
				
				// Faire relacher l'objet au joueur
				R3F_LOG_joueur_deplace_objet = objNull;
				waitUntil {_objet getVariable "R3F_LOG_est_deplace_par" != player};
				
				// Suppression de l'�quipage IA dans le cas d'un drone
				if (getNumber (configFile >> "CfgVehicles" >> (typeOf _objet) >> "isUav") == 1) then
				{
					{if (!isPlayer _x) then {_objet deleteVehicleCrew _x;};} forEach crew _objet;
				};
				
				deleteVehicle _objet;
				
				// Si l'usine n'a pas de cr�dits illimit� et que le taux d'occasion n'est pas nul
				if (_usine getVariable "R3F_LOG_CF_credits" != -1 && R3F_LOG_CFG_CF_sell_back_bargain_rate > 0) then
				{
					private ["_cout_neuf", "_valeur_occasion"];
					
					_cout_neuf = [typeOf _objet] call R3F_LOG_FNCT_determiner_cout_creation;
					_valeur_occasion = ceil (R3F_LOG_CFG_CF_sell_back_bargain_rate * (1 - damage _objet) * _cout_neuf);
					
					// Ajout de la valeur d'occasion de l'objet dans les cr�dits de l'usine
					_usine setVariable ["R3F_LOG_CF_credits", (_usine getVariable "R3F_LOG_CF_credits") + _valeur_occasion, true];
					
					systemChat format [STR_R3F_LOG_action_revendre_fait + " (+%2 credits)",
						getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName"), [_valeur_occasion] call R3F_LOG_FNCT_formater_nombre_entier_milliers];
				}
				else
				{
					systemChat format [STR_R3F_LOG_action_revendre_fait,
						getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
				};
			}
			else
			{
				hintC STR_R3F_LOG_action_revendre_decharger_avant;
			};
		}
		else
		{
			hintC format [STR_R3F_LOG_objet_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};