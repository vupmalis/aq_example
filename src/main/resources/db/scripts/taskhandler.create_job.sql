DECLARE 
  v_job_name VARCHAR2(32) := 'HANDLE_TASKS';

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => v_job_name,
            job_type => 'STORED_PROCEDURE',
            job_action => 'task_handler_job',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Test job execution');

    
    DBMS_SCHEDULER.enable(
             name => v_job_name);
    
    FOR i in 1..5 loop          
      SYS.dbms_scheduler.run_job (v_job_name, false); 
     END LOOP;
END;


DECLARE 
  v_job_name VARCHAR2(32) := 'HANDLE_TASKS';
BEGIN
  delete from debug_logs;
  commit;
  
  FOR i in 1..15 loop          
    dbms_scheduler.run_job (v_job_name, false); 
    commit;
  END LOOP;

END;

DECLARE
  v_jobno pls_integer;
BEGIN
  delete from debug_logs;
  
  FOR i in 1..15 loop
    dbms_job.submit(v_jobno, 'begin task_handler_job; end;' );
    commit;
  END LOOP;
  
  commit;
END;

SELECT *
from user_jobs;