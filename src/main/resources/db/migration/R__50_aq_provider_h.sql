CREATE OR REPLACE PACKAGE aq_provider IS
 
  PROCEDURE create_queues(p_queues_configuration IN aq_common.t_aq_configs);
  
  PROCEDURE create_queues;

  PROCEDURE drop_queues(p_queues_configuration IN aq_common.t_aq_configs);

  PROCEDURE stop_queues(p_queues_configuration IN aq_common.t_aq_configs);

  PROCEDURE start_queues(p_queues_configuration IN aq_common.t_aq_configs);

  PROCEDURE add_task_to_queue (
    p_queue_name   IN   VARCHAR2,
    p_task_id      IN   tasks.id%TYPE
  );

END aq_provider;