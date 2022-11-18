sleep 60;
_sql_res = "extDB3" callExtension format["0:SQL:DELETE FROM vehicles WHERE rec_date < NOW() - INTERVAL 120 MINUTE and mission_FK = '%1'", sog_mission_fk];
_sql_res = "extDB3" callExtension format["0:SQL:DELETE FROM objects WHERE objRecdate < NOW() - INTERVAL 120 MINUTE and mission_FK = '%1'", sog_mission_fk];