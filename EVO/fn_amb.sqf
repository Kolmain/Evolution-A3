	private ["_explosions"];
	_explosions = [
		"BattlefieldExplosions1_3D",
		"BattlefieldExplosions2_3D",
		"BattlefieldExplosions3_3D",
		"BattlefieldExplosions4_3D",
		"BattlefieldExplosions5_3D"
	];

	private ["_fireFights"];
	_fireFights = [
		"BattlefieldFirefight1_3D",
		"BattlefieldFirefight2_3D",
		"BattlefieldFirefight3_3D",
		"BattlefieldFirefight4_3D"
	];

	{
		[_explosions, _fireFights] spawn {
			private ["_explosions", "_fireFights", "_helis"];
			_explosions = _this select 0;
			_fireFights = _this select 1;

			while {true} do {
				sleep (1 + random 59);

				private ["_sound"];
				_sound = if (random 1 < 0.5) then {
					// Explosions
					_explosions call BIS_fnc_selectRandom
				} else {
					// Firefights
					_fireFights call BIS_fnc_selectRandom
				};

				// Play ambient sound
				playSound _sound;
			};
		};
	} forEach [0,1,2];

	private ["_helis"];
	_helis = [
		"BattlefieldHeli1_3D",
		"BattlefieldHeli2_3D",
		"BattlefieldHeli3_3D",
		"BattlefieldJet1_3D",
		"BattlefieldJet2_3D",
		"BattlefieldJet3_3D"
	];

	_helis spawn {
		private ["_helis", "_used"];
		_helis = _this;
		_used = [];

		while {true} do {
			if (count _used == count _helis) then {_used = []};

			sleep (30 + random 90);

			// Choose random sound
			private ["_sound"];
			_sound = (_helis - _used) call BIS_fnc_selectRandom;
			_used = _used + [_sound];

			// Play ambient sound
			playSound _sound;
		};
	};