class CfgPatches {
	class SOG_Functions_F {
		addonRootClass = "SOG_Server";
		units[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F"};
	};
};

class CfgFunctions {
	class SOG_Server {
		class Misc {
			class debug {
				file = "\SOG_Server\SOG_Functions_F\Core\Misc\scripts\debug.sqf";
			};
			class Server_cleanupDB {
				file = "\SOG_Server\SOG_Functions_F\Core\Misc\Server\scripts\cleanupDB.sqf";
			};
			class Server_deleteVehicle {
				file = "\SOG_Server\SOG_Functions_F\Core\Misc\Server\scripts\deleteVehicle.sqf";
			};
		};

		class Object {
			class Server_getObjectInventory {
				file = "\SOG_Server\SOG_Functions_F\Core\Object\Server\scripts\getObjectInventory.sqf";
			};
			class Server_getObjects {
				file = "\SOG_Server\SOG_Functions_F\Core\Object\Server\scripts\getObjects.sqf";
			};
			class Server_setObjectInventory {
				file = "\SOG_Server\SOG_Functions_F\Core\Object\Server\scripts\setObjectInventory.sqf";
			};
			class Server_setObjects {
				file = "\SOG_Server\SOG_Functions_F\Core\Object\Server\scripts\setObjects.sqf";
			};
		};

		class Unit {
			class Client_getUnit {
				file = "\SOG_Server\SOG_Functions_F\Core\Unit\Client\scripts\getUnit.sqf";
			};
			class Server_getUnit {
				file = "\SOG_Server\SOG_Functions_F\Core\Unit\Server\scripts\getUnit.sqf";
			};
			class Server_setUnit {
				file = "\SOG_Server\SOG_Functions_F\Core\Unit\Server\scripts\setUnit.sqf";
			};
		};

		class Vehicle {
			class Client_getVehicle {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Client\scripts\getVehicle.sqf";
			};
			class Client_setVehicle {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Client\scripts\setVehicle.sqf";
			};
			class Server_getVehicle {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\getVehicle.sqf";
			};
			class Server_getVehicleHitpointDamage {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\getVehicleHitpointDamage.sqf";
			};
			class Server_getVehicleInventory {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\getVehicleInventory.sqf";
			};
			class Server_setSingleVehicle {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\setSingleVehicle.sqf";
			};
			class Server_setVehicle {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\setVehicle.sqf";
			};
			class Server_setVehicleInventory {
				file = "\SOG_Server\SOG_Functions_F\Core\Vehicle\Server\scripts\setVehicleInventory.sqf";
			};
		};
	};
};