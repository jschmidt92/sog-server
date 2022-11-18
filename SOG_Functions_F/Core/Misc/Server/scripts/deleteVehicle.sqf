_sog_veh_del_marker_pos = getMarkerPos "sog_delete_vehicle";
_vehicle_check = nearestObjects[_sog_veh_del_marker_pos, [], 50];
_parentVehicleType = (_x call BIS_fnc_objectType) select 1;

if (!isnil "_vehicle_check" && _parentVehicleType in sog_allowed_veh) then {
	{
		deleteVehicle _x;
		sleep 1;
	} forEach _vehicle_check
};