/*
*	From Arma 3 Object to Database
*/

sog_debug_obj = "initializing saving..";
publicVariable "sog_debug_obj";

_objCntNew = 0;
_objCntUpd = 0;
_objCnt = count (allMissionObjects "All");
_cnt = 0;
{
	_cnt = _cnt + 1;
	_disableFlag = _x getVariable "disable_pdb";
	_objType = typeOf _x;
	_objClass = getText (configFile >> "CfgVehicles" >> _objType >> "vehicleClass");
	_objName = getText (configFile >> "CfgVehicles" >> _objType >> "displayName");
	_objPos = format ["%1", (getPosWorld _x)];
	_objDir = format ["%1", (round getDir _x)];
	_objDamage = (damage _x);
	_objInit = format["%1", _x getVariable "sog_init"];

	if (isNil "_objInit") then {
		_objInit = "NULL";
	};

	if (_objDamage < 0.1) then {
		_objDamage = "0";
	};

	if (isNil "_disableFlag") then {
		if (_objClass in sog_allowed_Obj && !(_objType in sog_blacklist_Obj)) then {
			_objUID = _x getVariable "sog_objectUID";
			if (isNil "_objUID") then {
				"extDB3" callExtension format["0:SQL:INSERT INTO objects SET objName = '%1', objClass = '%2', objPos = '%3', objDir = '%4', objDamage = '%5', mission_FK = '%6', objRecDate = NOW(), objCategory = '%7', objInit = '%8'", _objName, _objType, _objPos, _objDir, _objDamage, sog_mission_fk, _objClass, _objInit];

				_sql_res = "extDB3" callExtension "0:SQL:SELECT id FROM objects ORDER BY id DESC LIMIT 0, 1";
				_sql_res = _sql_res splitString "[, ]";
				_objUID = _sql_res select 1;
				_x setVariable ["sog_objectUID", _objUID, true];

				_save_inv = [_x, _objUID] execVM "\SOG_Server\SOG_Functions_F\Object\Server\scripts\setObjectInventory.sqf";
				waitUntil {
					scriptDone _save_inv
				};

				sog_debug_obj = format["saving objects | (new) %1 / %2 -> %3", _cnt, _objCnt, _objType];
				publicVariable "sog_debug_obj";

				_objCntNew = _objCntNew + 1;
			} else {
				"extDB3" callExtension format["0:SQL:UPDATE objects SET objPos = '%1', objDir = '%2', objDamage = '%3', objRecDate = NOW() WHERE id = '%4'", _objPos, _objDir, _objDamage, _objUID];
				_save_inv = [_x, _objUID] execVM "\SOG_Server\SOG_Functions_F\Object\Server\scripts\setObjectInventory.sqf";
				waitUntil {
					scriptDone _save_inv
				};
				sog_debug_obj = format["saving objects | (update) %1 / %2 -> %3", _cnt, _objCnt, _objType];
				publicVariable "sog_debug_obj";
				_objCntUpd = _objCntUpd + 1;
			};
		};
	};
} forEach allMissionObjects "All";

sog_debug_obj = format["saving done | new: %1 | updated: %2", _objCntNew, _objCntUpd];
publicVariable "sog_debug_obj";