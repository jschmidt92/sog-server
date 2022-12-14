/*
	From Database to Arma 3 Unit
*/

"extDB3" callExtension format["0:SQL:UPDATE vehicles SET vehicleDamage = 0 WHERE mission_FK = '%1' AND vehicleDamage < 0.1 LIMIT 150", sog_mission_fk];

_sql_res = "extDB3" callExtension format["0:SQL:SELECT vehicleType, vehiclePos, vehicleDir, id, vehicleFuel, vehicleDamage, vehicleCrew FROM vehicles WHERE mission_FK = '%1' LIMIT 150", sog_mission_fk];
_sql_res = _sql_res splitString "[, ]";

if (count _sql_res > 2) then {
	{
		_vehicleType = typeOf _x;
		_parentVehicleType = (_x call BIS_fnc_objectType) select 1;
		_vehicleClass = getText (configFile >> "CfgVehicles" >> _vehicleType >> "vehicleClass");
		_disableFlag = _x getVariable "disable_pdb";

		if (_parentVehicleType in sog_allowed_veh && isNil "_disableFlag") then {
			deleteVehicle _x;
		};
	} forEach (vehicles);

	sleep 3;

	for "_i" from 0 to ((count _sql_res)-9) step 9 do{
		sleep 0.5;
		_vehicleType = (_sql_res select (_i+1));
		_vehiclePosX = call compile (_sql_res select (_i+2));
		_vehiclePosY = call compile (_sql_res select (_i+3));
		_vehiclePosZ = call compile (_sql_res select (_i+4));

		_vehicleDir = call compile (_sql_res select (_i+5));
		_vehicleUID = (_sql_res select (_i+6));
		_vehicleFuel = call compile (_sql_res select (_i+7));
		_vehicleDamage = call compile (_sql_res select (_i+8));
		_vehicleCrew = call compile (_sql_res select (_i+9));

		_veh = _vehicleType createVehicle [0, 0, 300];
		_veh setVelocity [0, 0, 0];
		_veh enableSimulation false;
		_veh allowDamage false;
		_veh setDir _vehicleDir;
		_veh setPosWorld [_vehiclePosX, _vehiclePosY, _vehiclePosZ];
		_veh setDir _vehicleDir;
		_veh enableSimulation true;

		if (_vehicleDamage < 0.4) then {
			_veh setDamage 0;
		} else {
			_veh setDamage _vehicleDamage;
		};

		_veh setVariable["vehicleuid", [_vehicleUID], true];
		_veh setFuel _vehicleFuel;
		_veh addEventHandler ["GetOut", {
			[_this select 0, _this select 2, _this select 1] execVM "\SOG_Server\SOG_Functions_F\Vehicle\Server\scripts\setSingleVehicle.sqf";
		}];

		_vehFinal = [_veh, _vehicleUID] execVM "\SOG_Server\SOG_Functions_F\Vehicle\Server\scripts\getVehicleInventory.sqf";
		waitUntil{
			scriptDone _vehFinal
		};

		if (_vehicleCrew == 1) then {
			createVehicleCrew _veh;
		};
	};

	sleep 20;

	{
		_x allowDamage true;
		_vehicleType = typeOf _x;
		_parentVehicleType = (_x call BIS_fnc_objectType) select 1;
		_vehicleClass = getText (configFile >> "CfgVehicles" >> _vehicleType >> "vehicleClass");

		if (_vehicleClass in sog_allowed_veh) then {
			_vehicleUID = _x getVariable "vehicleuid";
			_vehDamage = [_x, _vehicleUID] execVM "\SOG_Server\SOG_Functions_F\Vehicle\Server\scripts\getVehicleHitpointDamage.sqf";
			waitUntil{
				scriptDone _vehDamage
			};
		};
	} forEach (vehicles);
};