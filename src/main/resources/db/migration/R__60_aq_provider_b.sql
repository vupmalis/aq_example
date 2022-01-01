CREATE OR REPLACE PACKAGE BODY aq_provider AS

  PROCEDURE create_queue_table (
    p_queue_table          IN   VARCHAR2,
    p_queue_payload_type   IN   VARCHAR2
  ) IS
    --ORA-24001: cannot create QUEUE_TABLE, <table> already exists
    e_queue_table_exists EXCEPTION;
    PRAGMA exception_init ( e_queue_table_exists, -24001 );
  BEGIN
    dbms_aqadm.create_queue_table(queue_table => p_queue_table, queue_payload_type => p_queue_payload_type, storage_clause => 'TABLESPACE tbs_aq'
    , sort_list => 'PRIORITY,ENQ_TIME');
  EXCEPTION
    WHEN e_queue_table_exists THEN
      NULL;
  END;

  PROCEDURE create_queue (
    p_queue_table          IN   VARCHAR2,
    p_queue_payload_type   IN   VARCHAR2,
    p_queue_name           IN   VARCHAR2
  ) IS
    --ORA-24006: cannot create QUEUE, <queue name> already exists
    e_queue_exists EXCEPTION;
    PRAGMA exception_init ( e_queue_exists, -24006 );
  BEGIN
    create_queue_table(p_queue_table => p_queue_table, p_queue_payload_type => p_queue_payload_type);
    dbms_aqadm.create_queue(queue_name => p_queue_table, queue_table => p_queue_table);
  EXCEPTION
    WHEN e_queue_exists THEN
      NULL;
  END;

  PROCEDURE stop_queue (
    p_queue_name IN VARCHAR2
  ) IS
    -- ORA-24010: QUEUE <queue> does not exist
    e_queue_does_not_exists EXCEPTION;
    PRAGMA exception_init ( e_queue_does_not_exists, -24010 );
  BEGIN
    dbms_aqadm.stop_queue(queue_name => p_queue_name);
  EXCEPTION
    WHEN e_queue_does_not_exists THEN
      NULL;
  END;

  PROCEDURE start_queue (
    p_queue_name IN VARCHAR2
  ) IS
    -- ORA-24010: QUEUE <queue> does not exist
    e_queue_does_not_exists EXCEPTION;
    PRAGMA exception_init ( e_queue_does_not_exists, -24010 );
  BEGIN
    dbms_aqadm.start_queue(queue_name => p_queue_name);
  EXCEPTION
    WHEN e_queue_does_not_exists THEN
      NULL;
  END;

  PROCEDURE drop_queue (
    p_queue_table   IN   VARCHAR2,
    p_queue_name    IN   VARCHAR2
  ) IS
    -- ORA-24010: QUEUE <queue> does not exist

    e_queue_does_not_exists EXCEPTION;
    PRAGMA exception_init ( e_queue_does_not_exists, -24010 );    

    --ORA-24002: QUEUE_TABLE <table> does not exist
    e_queue_table_not_exists EXCEPTION;
    PRAGMA exception_init ( e_queue_table_not_exists, -24002 );
  BEGIN
    BEGIN
      stop_queue(p_queue_name => p_queue_name);
      dbms_aqadm.drop_queue(queue_name => p_queue_name);
    EXCEPTION
      WHEN e_queue_does_not_exists THEN
        NULL;
    END;

    BEGIN
      dbms_aqadm.drop_queue_table(queue_table => p_queue_table);
    EXCEPTION
      WHEN e_queue_table_not_exists THEN
        NULL;
    END;

  END;

  PROCEDURE create_queues IS
  BEGIN
    create_queue(p_queue_table => c_aq_changed_tasks_table, p_queue_payload_type => c_aq_changed_tasks_payload_type, p_queue_name
    => c_aq_changed_tasks);
  END;

  PROCEDURE drop_queues IS
  BEGIN
    drop_queue(p_queue_table => c_aq_changed_tasks_table, p_queue_name => c_aq_changed_tasks_full_name);
  END;

  PROCEDURE stop_queues IS
  BEGIN
    stop_queue(p_queue_name => c_aq_changed_tasks_full_name);
  END;

  PROCEDURE start_queues IS
  BEGIN
    start_queue(p_queue_name => c_aq_changed_tasks_full_name);
  END;

  PROCEDURE add_task_to_queue (
    p_queue_name   IN   VARCHAR2,
    p_task_id      IN   tasks.id%TYPE
  ) IS

    v_task                 t_task := t_task(p_task_id);
    v_enqueue_options      dbms_aq.enqueue_options_t;
    v_message_properties   dbms_aq.message_properties_t;
    v_msg_id               RAW(16);
  BEGIN
    dbms_aq.enqueue(queue_name => p_queue_name, enqueue_options => v_enqueue_options, message_properties => v_message_properties,
    payload => v_task, msgid => v_msg_id);
  END;

END aq_provider;