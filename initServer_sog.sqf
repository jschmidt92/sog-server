if (isNil {
	uiNamespace getVariable "sog_init"
}) then {
	call compile ("extDB3" callExtension "9:ADD_DATABASE:SOG_DB");
	call compile ("extDB3" callExtension "9:ADD_DATABASE_PROTOCOL:SOG_DB:SQL:SQL");
	uiNamespace setVariable ["sog_init", true];
};

sog_map = format["%1", worldName];
sog_mission = format["%1", missionName];
sog_allowed_Obj = [ "Structures_Fences", "Jonzie_Objects", "Structures_Military", "ARP_Objects", "ARP_objects", "ACE_Logistics_Items", "Tents", "Ammo", "Misc", "Garbage", "Fortifications", "Container", "Flag", "Furniture", "Objects_Airport", "Cargo", "Dead_bodies", "Small_items", "Lamps", "Military", "Signs", "signs", "Objects_Sports", "Training"];

sog_blacklist_Obj = [ "Land_Shoot_House_Wall_F", "Land_Shoot_House_Wall_Prone_F", "Land_Shoot_House_Wall_Crouch_F", "Land_Shoot_House_Wall_Long_F", "Land_Shoot_House_Wall_Long_Stand_F", "Land_Shoot_House_Wall_Long_Prone_F", "Line_short_F", "VR_Area_01_circle_4_yellow_F"];

sog_allowed_veh = [ "Car", "Helicopter", "Motorcycle", "Plane", "Ship", "StaticWeapon", "Submarine", "TrackedAPC", "Tank", "WheeledAPC"];

{
	_vehicleType = typeOf _x;
	_vehicleClass = getText (configFile >> "CfgVehicles" >> _vehicleType >> "vehicleClass");
	_parentVehicleType = (_x call BIS_fnc_objectType) select 1;

	if (_parentVehicleType in sog_allowed_veh) then {
		clearItemCargoGlobal _x;
		clearBackpackCargoGlobal _x;
		clearMagazineCargoGlobal _x;
		clearWeaponCargoGlobal _x;
	};
} forEach (vehicles);

_sql_res = "extDB3" callExtension format["0:SQL:SELECT * FROM mission WHERE missionMap = '%1' AND missionName = '%2'", sog_map, sog_mission];
_sql_res = _sql_res splitString "[, ]";

if (count _sql_res < 2) then {
	"extDB3" callExtension format["0:SQL:INSERT INTO mission SET missionMap = '%1', missionName = '%2', missionLoaded = NOW()", sog_map, sog_mission];
	_sql_res = "extDB3" callExtension format["0:SQL:SELECT * FROM mission WHERE missionMap = '%1' AND missionName = '%2'", sog_map, sog_mission];
	_sql_res = _sql_res splitString "[, ]";
	sog_mission_fk = (_sql_res select 1);
	publicVariable "sog_mission_fk";

	_setVeh = [] execVM "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\setVehicle.sqf";
	waitUntil {
		scriptDone _setVeh
	};

	_setObj = [] execVM "\SOG_Server\SOG_Functions_F\Core\Object\Server\scripts\setObjects.sqf";
	waitUntil {
		scriptDone _setObj
	};
} else {
	sog_mission_fk = (_sql_res select 1);
	publicVariable "sog_mission_fk";
	"extDB3" callExtension format["0:SQL:UPDATE mission SET missionLoaded = NOW() WHERE id = '%1'", sog_mission_fk];

	_getVeh = [] execVM "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\getVehicle.sqf";
	waitUntil {
		scriptDone _getVeh
	};

	_getObj = [] execVM "\SOG_Server\SOG_Functions_F\Core\Object\Server\scripts\getObjects.sqf";
	waitUntil {
		scriptDone _getObj
	};
};

sog_cnt = 59;
publicVariable "sog_cnt";

while { true } do {
	sog_cnt = sog_cnt + 1;

	sleep 1;
	_setVehicle = [] execVM "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\setVehicle.sqf";

	{
		_setUnit = [_x] execVM "\SOG_Server\SOG_Functions_F\Core\Unit\Server\scripts\setUnit.sqf";
		waitUntil {
			scriptDone _setUnit
		};
	} forEach allPlayers;

	sleep 59;

	if (sog_cnt >= 60) then {
		_setObj = [] execVM "\SOG_Server\SOG_Functions_F\Core\Object\Server\scripts\setObjects.sqf";
		waitUntil {
			scriptDone _setObj
		};
		
		[] execVM "\SOG_Server\SOG_Functions_F\Core\Misc\Server\scripts\cleanupDB.sqf";
		sog_cnt = 0;
	};
};