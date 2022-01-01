CREATE OR REPLACE PACKAGE aq_provider AS
  c_aq_changed_tasks CONSTANT VARCHAR2(32) := 'changed_tasks';
  c_aq_changed_tasks_full_name CONSTANT VARCHAR2(32) := user || 'changed_tasks';
  c_aq_changed_tasks_table CONSTANT VARCHAR2(32) := 'aq_changed_tasks';
  c_aq_changed_tasks_tablespace CONSTANT VARCHAR2(32) := 'T_TASK';
  c_aq_changed_tasks_e CONSTANT VARCHAR2(32) := 'aq$_'
                                                || c_aq_changed_tasks_table
                                                || '_e';
  c_aq_changed_tasks_payload_type CONSTANT VARCHAR2(32) := 'T_TASK';
  
  PROCEDURE create_queues;

  PROCEDURE drop_queues;

  PROCEDURE stop_queues;

  PROCEDURE start_queues;

  PROCEDURE add_task_to_queue (
    p_queue_name   IN   VARCHAR2,
    p_task_id      IN   tasks.id%TYPE
  );

END aq_provider;