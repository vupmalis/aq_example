CREATE TABLESPACE tbs_task_handler
   DATAFILE 'tbs_task_handler.dbf' 
   SIZE 1m;

/* use double-quotes so flyway can create migration table*/
CREATE user "taskhandler" identified by taskhandler default TABLESPACE tbs_task_handler;
grant create session, resource to "taskhandler";
GRANT UNLIMITED TABLESPACE TO "taskhandler";
 
grant AQ_ADMINISTRATOR_ROLE to "taskhandler"; 
grant execute on DBMS_AQADM to "taskhandler";
grant execute on DBMS_AQ to "taskhandler";