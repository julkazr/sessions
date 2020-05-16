-------------------------------------------------------------------------------------
-- Workshop: SQL Server for Application Developers
-- Module 3: Common Transact-SQL Tasks - Difference between two wide rows
-- Milos Radivojevic, Data Platform MVP, bwin, Austria
-- E: milos.radivojevic@chello.at
-- W: https://milossql.wordpress.com/
-------------------------------------------------------------------------------------

--------------------------------------------
-- Find difference between two rows
--------------------------------------------
USE tempdb;
GO
/*
Find out which settings are different 
for the master and model databases*/

SELECT * FROM sys.databases WHERE database_id = 1; --master
SELECT * FROM sys.databases WHERE database_id = 3; --model

/*Result:

column_name						column_value_master            column_value_model
------------------------------	------------------------------ ------------------------------
name							master                         model
database_id						1                              3
snapshot_isolation_state		1                              0
snapshot_isolation_state_desc	ON                             OFF
recovery_model					3                              1
recovery_model_desc				SIMPLE                         FULL
is_db_chaining_on				true                           false
target_recovery_time_in_seconds 0                              60
physical_database_name			master                         model
*/

--get number of columns in a row:
 SELECT COUNT(*) FROM sys.dm_exec_describe_first_result_set  
(N'SELECT * FROM sys.databases WHERE 1 = 0', NULL, 0); 
/*Result:
-----------
86
*/
----------------------------------
--Solution
----------------------------------
SELECT * FROM sys.databases WHERE database_id = 1 FOR JSON AUTO;
/*[{"name":"master","database_id":1,"owner_sid":"AQ==","create_date":"2003-04-08T09:13:36.390","compatibility_level":150,"collation_name":"Latin1_General_CI_AS","user_access":0,"user_access_desc":"MULTI_USER","is_read_only":false,"is_auto_close_on":false,"is_auto_shrink_on":false,"state":0,"state_desc":"ONLINE","is_in_standby":false,"is_cleanly_shutdown":false,"is_supplemental_logging_enabled":false,"snapshot_isolation_state":1,"snapshot_isolation_state_desc":"ON","is_read_committed_snapshot_on":false,"recovery_model":3,"recovery_model_desc":"SIMPLE","page_verify_option":2,"page_verify_option_desc":"CHECKSUM","is_auto_create_stats_on":true,"is_auto_create_stats_incremental_on":false,"is_auto_update_stats_on":true,"is_auto_update_stats_async_on":false,"is_ansi_null_default_on":false,"is_ansi_nulls_on":false,"is_ansi_padding_on":false,"is_ansi_warnings_on":false,"is_arithabort_on":false,"is_concat_null_yields_null_on":false,"is_numeric_roundabort_on":false,"is_quoted_identifier_on":false,"is_recursive_triggers_on":false,"is_cursor_close_on_commit_on":false,"is_local_cursor_default":false,"is_fulltext_enabled":false,"is_trustworthy_on":false,"is_db_chaining_on":true,"is_parameterization_forced":false,"is_master_key_encrypted_by_server":false,"is_query_store_on":false,"is_published":false,"is_subscribed":false,"is_merge_published":false,"is_distributor":false,"is_sync_with_backup":false,"service_broker_guid":"00000000-0000-0000-0000-000000000000","is_broker_enabled":false,"log_reuse_wait":0,"log_reuse_wait_desc":"NOTHING","is_date_correlation_on":false,"is_cdc_enabled":false,"is_encrypted":false,"is_honor_broker_priority_on":false,"containment":0,"containment_desc":"NONE","target_recovery_time_in_seconds":0,"delayed_durability":0,"delayed_durability_desc":"DISABLED","is_memory_optimized_elevate_to_snapshot_on":false,"is_federation_member":false,"is_remote_data_archive_enabled":false,"is_mixed_page_allocation_on":true,"is_temporal_history_retention_enabled":true,"catalog_collation_type":0,"catalog_collation_type_desc":"DATABASE_DEFAULT","physical_database_name":"master","is_result_set_caching_on":false,"is_accelerated_database_recovery_on":false,"is_tempdb_spill_to_remote_store":false,"is_stale_page_detection_on":false,"is_memory_optimized_enabled":true}]*/

SELECT * FROM sys.databases WHERE database_id = 1 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER;
/*{"name":"master","database_id":1,"owner_sid":"AQ==","create_date":"2003-04-08T09:13:36.390","compatibility_level":150,"collation_name":"Latin1_General_CI_AS","user_access":0,"user_access_desc":"MULTI_USER","is_read_only":false,"is_auto_close_on":false,"is_auto_shrink_on":false,"state":0,"state_desc":"ONLINE","is_in_standby":false,"is_cleanly_shutdown":false,"is_supplemental_logging_enabled":false,"snapshot_isolation_state":1,"snapshot_isolation_state_desc":"ON","is_read_committed_snapshot_on":false,"recovery_model":3,"recovery_model_desc":"SIMPLE","page_verify_option":2,"page_verify_option_desc":"CHECKSUM","is_auto_create_stats_on":true,"is_auto_create_stats_incremental_on":false,"is_auto_update_stats_on":true,"is_auto_update_stats_async_on":false,"is_ansi_null_default_on":false,"is_ansi_nulls_on":false,"is_ansi_padding_on":false,"is_ansi_warnings_on":false,"is_arithabort_on":false,"is_concat_null_yields_null_on":false,"is_numeric_roundabort_on":false,"is_quoted_identifier_on":false,"is_recursive_triggers_on":false,"is_cursor_close_on_commit_on":false,"is_local_cursor_default":false,"is_fulltext_enabled":false,"is_trustworthy_on":false,"is_db_chaining_on":true,"is_parameterization_forced":false,"is_master_key_encrypted_by_server":false,"is_query_store_on":false,"is_published":false,"is_subscribed":false,"is_merge_published":false,"is_distributor":false,"is_sync_with_backup":false,"service_broker_guid":"00000000-0000-0000-0000-000000000000","is_broker_enabled":false,"log_reuse_wait":0,"log_reuse_wait_desc":"NOTHING","is_date_correlation_on":false,"is_cdc_enabled":false,"is_encrypted":false,"is_honor_broker_priority_on":false,"containment":0,"containment_desc":"NONE","target_recovery_time_in_seconds":0,"delayed_durability":0,"delayed_durability_desc":"DISABLED","is_memory_optimized_elevate_to_snapshot_on":false,"is_federation_member":false,"is_remote_data_archive_enabled":false,"is_mixed_page_allocation_on":true,"is_temporal_history_retention_enabled":true,"catalog_collation_type":0,"catalog_collation_type_desc":"DATABASE_DEFAULT","physical_database_name":"master","is_result_set_caching_on":false,"is_accelerated_database_recovery_on":false,"is_tempdb_spill_to_remote_store":false,"is_stale_page_detection_on":false,"is_memory_optimized_enabled":true}*/

/*
JSON formatter: https://jsonformatter.curiousconcept.com/
*/
SELECT * FROM OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 1 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))
SELECT * FROM OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 3 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))

SELECT *  FROM
OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 1 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))
d1 INNER JOIN
OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 3 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))
d2 ON d1.[key] = d2.[key] 

SELECT *  FROM
OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 1 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))
d1 INNER JOIN
OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 3 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))
d2 ON d1.[key] = d2.[key] 
WHERE d1.[value] <> d2.[value] 


SELECT d1.[key], d1.[value] AS d1_value, d2.[value] AS d2_value  FROM
OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 1 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))
d1 INNER JOIN
OPENJSON ((SELECT * FROM sys.databases WHERE database_id = 3 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER))
d2 ON d1.[key] = d2.[key] 
WHERE d1.[value] <> d2.[value] 
/*
key                                                                                                                                                                                                                                                              value                                                                                                                                                                                                                                                            type key                                                                                                                                                                                                                                                              value                                                                                                                                                                                                                                                            type
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
name                                                                                                                                                                                                                                                             master                                                                                                                                                                                                                                                           1    name                                                                                                                                                                                                                                                             model                                                                                                                                                                                                                                                            1
database_id                                                                                                                                                                                                                                                      1                                                                                                                                                                                                                                                                2    database_id                                                                                                                                                                                                                                                      3                                                                                                                                                                                                                                                                2
snapshot_isolation_state                                                                                                                                                                                                                                         1                                                                                                                                                                                                                                                                2    snapshot_isolation_state                                                                                                                                                                                                                                         0                                                                                                                                                                                                                                                                2
snapshot_isolation_state_desc                                                                                                                                                                                                                                    ON                                                                                                                                                                                                                                                               1    snapshot_isolation_state_desc                                                                                                                                                                                                                                    OFF                                                                                                                                                                                                                                                              1
recovery_model                                                                                                                                                                                                                                                   3                                                                                                                                                                                                                                                                2    recovery_model                                                                                                                                                                                                                                                   1                                                                                                                                                                                                                                                                2
recovery_model_desc                                                                                                                                                                                                                                              SIMPLE                                                                                                                                                                                                                                                           1    recovery_model_desc                                                                                                                                                                                                                                              FULL                                                                                                                                                                                                                                                             1
is_db_chaining_on                                                                                                                                                                                                                                                true                                                                                                                                                                                                                                                             3    is_db_chaining_on                                                                                                                                                                                                                                                false                                                                                                                                                                                                                                                            3
target_recovery_time_in_seconds                                                                                                                                                                                                                                  0                                                                                                                                                                                                                                                                2    target_recovery_time_in_seconds                                                                                                                                                                                                                                  60                                                                                                                                                                                                                                                               2
physical_database_name                                                                                                                                                                                                                                           master                                                                                                                                                                                                                                                           1    physical_database_name                                                                                                                                                                                                                                           model                                                                                                                                                                                                                                                            1
*/
 