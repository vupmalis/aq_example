CREATE OR REPLACE PACKAGE aq_common AS

  TYPE t_varchar2 IS TABLE OF VARCHAR2(2000); 

  TYPE t_aq_config IS RECORD (
     queue_name VARCHAR2(32)
    ,full_queue_name VARCHAR2(32)
    ,queue_table_name VARCHAR2(32)
    ,payload_type  VARCHAR2(32)
    ,table_space VARCHAR2(32)
    ,exception_queue_name VARCHAR2(32)
    ,retries NUMBER
    ,retry_delay NUMBER
    ,db_users_assigned t_varchar2 
  );
  
  TYPE t_aq_configs IS TABLE OF t_aq_config;   

  c_batch_tasks CONSTANT t_aq_config := t_aq_config(
     queue_name => 'BATCH'
    ,full_queue_name => user ||'.BATCH'
    ,queue_table_name =>'aq_db_tasks'
    ,table_space => 'T_TASK'
    ,payload_type => 'T_TASK'
    ,exception_queue_name => 'BATCH_E'
    ,retries => 0
    ,retry_delay => 0
    ,db_users_assigned => t_varchar2('taskprocessor')
  );  

  c_aq_changed_tasks CONSTANT VARCHAR2(32) := 'changed_tasks';
  c_aq_changed_tasks_full_name CONSTANT VARCHAR2(32) := user || 'changed_tasks';
  c_aq_changed_tasks_table CONSTANT VARCHAR2(32) := 'aq_changed_tasks';
  c_aq_changed_tasks_tablespace CONSTANT VARCHAR2(32) := 'T_TASK';
  c_aq_changed_tasks_e CONSTANT VARCHAR2(32) := 'aq$_'
                                                || c_aq_changed_tasks_table
                                                || '_e';
  c_aq_changed_tasks_payload_type CONSTANT VARCHAR2(32) := 'T_TASK';

  c_aq_configs CONSTANT t_aq_configs := t_aq_configs(c_batch_tasks); 
  
END aq_common;