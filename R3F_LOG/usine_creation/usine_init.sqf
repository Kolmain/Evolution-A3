/**
 * Initialise et configure une usine de cr�ation
 * 
 * @param 0 l'usine
 * @param 1 (optionnel) son cr�dit de cr�ation, -1 pour un cr�dit infinie (d�faut : -1)
 * @param 2 (optionnel) side pour laquelle autoriser l'acc�s (d�faut : acc�s pour toutes les sides)
 * @param 3 (optionnel) liste des noms de classes des cat�gories autoris�s (white list)
 *                     si non renseign�, toutes les cat�gories non pr�sentes l'�ventuelle black list saisie dans config_creation_factory.sqf
 *                     si cha�ne de caract�res "FULL", utilisation de la liste R3F_LOG_CFG_CF_whitelist_full_categories (config_creation_factory.sqf)
 *                     si cha�ne de caract�res "MEDIUM", utilisation de la liste R3F_LOG_CFG_CF_whitelist_medium_categories (config_creation_factory.sqf)
 *                     si cha�ne de caract�res "LIGHT", utilisation de la liste R3F_LOG_CFG_CF_whitelist_light_categories (config_creation_factory.sqf)
 *                     si tableau de noms de classes du CfgVehicleClasses (ex : ["Furniture", "Fortifications"]), utilisation de la liste fournie
 */

private ["_usine", "_credits_usine", "_num_side", "_param3", "_blackwhitelist_categories_toLower"];

_usine = _this select 0;

// R�cup�ration du param�tre optionnel de cr�dits
if (count _this > 1 && {!isNil {_this select 1}}) then
{
	if (typeName (_this select 1) != "SCALAR") then
	{
		systemChat "ERROR : credits parameter passed to ""init creation factory"" is not a number.";
		diag_log text "ERROR : credits parameter passed to ""init creation factory"" is not a number.";
		_this set [1, -1];
	};
	
	_credits_usine = _this select 1;
}
else {_credits_usine = -1};

// Si une side est sp�cifi�e, on l'autorise, ainsi que les sides civil et neutre
if (count _this > 2 && {!isNil {_this select 2}}) then
{
	if (typeName (_this select 2) != "SIDE") then
	{
		systemChat "ERROR : side parameter passed to ""init creation factory"" is not a side.";
		diag_log text "ERROR : side parameter passed to ""init creation factory"" is not a side.";
		_this set [2, civilian];
	};
	
	_num_side = switch (_this select 2) do
	{
		case east: {0};
		case west: {1};
		case independent: {2};
		case civilian: {3};
		default {4};
	};
	
	_usine setVariable ["R3F_LOG_CF_num_sides", [_num_side, 3, 4], false];
	_usine setVariable ["R3F_LOG_CF_side_addAction", _this select 2, false];
}
// Par d�faut, toutes les sides sont autoris�es
else
{
	_usine setVariable ["R3F_LOG_CF_num_sides", [0, 1, 2, 3, 4], false];
	// R3F_LOG_CF_side_addAction reste nil
};

/** Cr�dits de cr�ation, -1 pour un cr�dit infinie */
if (isNil {_usine getVariable "R3F_LOG_CF_credits"}) then
{
	_usine setVariable ["R3F_LOG_CF_credits", _credits_usine, false];
};

if (isNil {_usine getVariable "R3F_LOG_CF_disabled"}) then
{
	_usine setVariable ["R3F_LOG_CF_disabled", false, false];
};

// Gestion de la configuration black/white liste des cat�gories accessibles
if (isNil {_usine getVariable "R3F_LOG_CF_blackwhitelist_categories"}) then
{
	if (count _this > 3 && {!isNil {_this select 3}}) then
	{
		_param3 = _this select 3;
		
		_usine setVariable ["R3F_LOG_CF_blackwhitelist_mode", "white", false];
		
		// Param 3 parmi "FULL" ou "LIGHT" : utilisation de la white list correspondante dans le config_creation_factory.sqf
		if (typeName _param3 == "STRING") then
		{
			_usine setVariable ["R3F_LOG_CF_blackwhitelist_categories", switch (_param3) do {
					case "LIGHT": {R3F_LOG_CFG_CF_whitelist_light_categories};
					case "MEDIUM": {R3F_LOG_CFG_CF_whitelist_medium_categories};
					case "FULL": {R3F_LOG_CFG_CF_whitelist_full_categories};
					default {R3F_LOG_CFG_CF_whitelist_full_categories};
			}];
		}
		else
		{
			// White list personnalis�e en param 3
			if (typeName _param3 == "ARRAY") then
			{
				_usine setVariable ["R3F_LOG_CF_blackwhitelist_categories", _param3, false];
			};
		};
	}
	else
	{
		// Par d�faut, autoriser tout sauf la black list du config_creation_factory.sqf
		_usine setVariable ["R3F_LOG_CF_blackwhitelist_mode", "black", false];
		_usine setVariable ["R3F_LOG_CF_blackwhitelist_categories", R3F_LOG_CFG_CF_blacklist_categories, false];
	};
	
	// Conversion des cat�gories en lettres minuscules
	_blackwhitelist_categories_toLower = [];
	{
		_blackwhitelist_categories_toLower pushBack toLower _x;
	} forEach (_usine getVariable "R3F_LOG_CF_blackwhitelist_categories");
	_usine setVariable ["R3F_LOG_CF_blackwhitelist_categories", _blackwhitelist_categories_toLower, false];
};

// Initialisation des variables m�morisant les valeurs saisies dans l'interface entre deux ouvertures
_usine setVariable ["R3F_LOG_CF_mem_idx_categorie", 0];
_usine setVariable ["R3F_LOG_CF_mem_idx_objet", 0];

/** Tableau contenant toutes les usines cr��es */
R3F_LOG_CF_liste_usines pushBack _usine;

_usine addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_ouvrir_usine + "</t>"), {_this call R3F_LOG_FNCT_usine_ouvrir_usine}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_ouvrir_usine_valide"];

_usine addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_revendre_usine_deplace + "</t>"), {_this call R3F_LOG_FNCT_usine_revendre_deplace}, nil, 7, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_revendre_usine_deplace_valide"];

_usine addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_revendre_usine_selection + "</t>"), {_this call R3F_LOG_FNCT_usine_revendre_selection}, nil, 6, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_revendre_usine_selection_valide"];