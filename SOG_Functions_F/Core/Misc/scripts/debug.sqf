_val = format ["%1", _this select 0];
"extDB3" callExtension format["0:SQL:INSERT INTO test SET val = '%1'", _val];