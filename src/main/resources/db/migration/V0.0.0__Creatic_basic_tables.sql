CREATE TABLE debug_logs (
    id             NUMBER NOT NULL,
    log_type       VARCHAR2(32 CHAR) NOT NULL,
    message        VARCHAR2(2000 CHAR) NOT NULL,
    log_date       TIMESTAMP DEFAULT systimestamp NOT NULL,
    context        VARCHAR2(200 CHAR) NOT NULL,
    user_context   VARCHAR2(200 CHAR) NOT NULL,
    table_name     VARCHAR2(32 CHAR),
    record_id      NUMBER
);

ALTER TABLE debug_logs
    ADD CHECK ( log_type IN (
        'DEBUG',
        'ERROR',
        'INFO',
        'WARN'
    ) );

ALTER TABLE debug_logs ADD CONSTRAINT debug_logs_pk PRIMARY KEY ( id );

CREATE TABLE task_configurations (
    task_code        VARCHAR2(32 CHAR) NOT NULL,
    task_name        VARCHAR2(100 CHAR) NOT NULL,
    manual_task      VARCHAR2(1 CHAR) NOT NULL,
    task_due_days    NUMBER,
    next_task_code   VARCHAR2(32 CHAR),
    priority         NUMBER(3) NOT NULL
);

COMMENT ON COLUMN task_configurations.task_code IS
    'Task code';

COMMENT ON COLUMN task_configurations.task_name IS
    'Task name';

COMMENT ON COLUMN task_configurations.manual_task IS
    'Flag, if the task is manual(Y) or automatic (N)';

ALTER TABLE task_configurations
    ADD CONSTRAINT tcf_ck1 CHECK ( manual_task IN (
        'Y',
        'N'
    ) );

ALTER TABLE task_configurations ADD CONSTRAINT tcf_pk PRIMARY KEY ( task_code );

ALTER TABLE task_configurations ADD CONSTRAINT tcf_uk UNIQUE ( task_name );

CREATE TABLE tasks (
    id              NUMBER NOT NULL,
    task_code       VARCHAR2(32 CHAR) NOT NULL,
    description     VARCHAR2(500 CHAR),
    creation_date   TIMESTAMP NOT NULL,
    due_date        DATE,
    assigned_to     NUMBER NOT NULL,
    created_by      NUMBER NOT NULL,
    status          VARCHAR2(20 CHAR) NOT NULL
);

COMMENT ON COLUMN tasks.status IS
    'Task status';

ALTER TABLE tasks
    ADD CONSTRAINT tsk_ck1 CHECK ( status IN (
        'NEW',
        'ASSIGNED',
        'FAILED',
        'FINISHED',
        'ON_HOLD'
    ) );

ALTER TABLE tasks ADD CONSTRAINT tsk_pk PRIMARY KEY ( id );

CREATE TABLE workers (
    id     NUMBER NOT NULL,
    name   VARCHAR2(30 CHAR) NOT NULL
);

ALTER TABLE workers ADD CONSTRAINT wrk_pk PRIMARY KEY ( id );

ALTER TABLE workers ADD CONSTRAINT wrk_uk UNIQUE ( name );

ALTER TABLE tasks
    ADD CONSTRAINT tsk_tcf_fk FOREIGN KEY ( task_code )
        REFERENCES task_configurations ( task_code );

ALTER TABLE tasks
    ADD CONSTRAINT tsk_wrk_fk1 FOREIGN KEY ( assigned_to )
        REFERENCES workers ( id );

ALTER TABLE tasks
    ADD CONSTRAINT tsk_wrk_fk2 FOREIGN KEY ( created_by )
        REFERENCES workers ( id );
