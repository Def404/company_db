CREATE ROLE worker;
CREATE ROLE manager;

GRANT SELECT ON
    connection_interface_type,
    contact_person,
    contract,
    contract_classifier,
    drive_type,
    hard_drive,
    organization,
    organization_type,
    priority_task,
    task,
    task_receipt_type,
    task_status
TO worker, manager;

GRANT SELECT ON
   employee
TO worker, manager;

GRANT INSERT ON
    contact_person,
    organization,
    contract,
    task
TO manager;

GRANT UPDATE
    (executor_id)
ON task
TO manager;
/* Менеджер  может изменять  исполнителя */

ALTER TABLE
    task
ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_of_task ON task
    FOR SELECT
    TO manager, worker
    USING
    (
        (SELECT employee_login
        FROM employee
        WHERE task.author_id = employee.employee_id) = current_user OR
        (SELECT employee_login
        FROM employee
        WHERE task.executor_id = employee.employee_id) = current_user
    );
/* Просматривать задание может лиюо автор, либо исполнитель */

CREATE POLICY update_task_status ON task
    FOR UPDATE
    TO manager, worker
    USING (true)
    WITH CHECK
    (
        (task.status_id != 3) AND
        (
            (SELECT employee_login
             FROM employee
             WHERE (task.author_id = employee.employee_id)) = current_user OR
            (SELECT employee_login
             FROM employee
             WHERE (task.executor_id = employee.employee_id)) = current_user
        )
    );
/* Изменять задание как выполненое может только автор или исполнитель (выполененое задание изменять нельзя) */



CREATE ROLE smirnov WITH LOGIN PASSWORD '_te_53#df10';
GRANT worker TO smirnov;

CREATE ROLE mikheev WITH LOGIN PASSWORD '_saf#4324';
GRANT manager TO mikheev;

CREATE ROLE ershova WITH LOGIN PASSWORD '9_sdfS_4';
GRANT worker TO ershova;

CREATE ROLE kuznetsova WITH LOGIN PASSWORD '_2144_sdad_54';
GRANT manager TO kuznetsova;




/* ЭТО НАДО УДАЛИТЬ */
GRANT UPDATE
    (execution_period, completion_date, priority_id, status_id)
ON task
TO manager, worker;
/* Дату выполения,  период,  приоритет, статутс может изменять manager и worker */

REVOKE UPDATE (execution_period, completion_date, priority_id, status_id)
ON task
FROM manager, worker;



/* НАДО УДАЛИТЬ */
CREATE POLICY update_task  ON task
    FOR UPDATE
    TO manager, worker
    USING (true)
    WITH CHECK
    (
        (SELECT employee_login
        FROM employee
        WHERE task.author_id = employee.employee_id) = current_user
    );
/* Автор может менять поля задачи */
DROP POLICY update_task ON task;

(SELECT COUNT(*) FROM pg_roles WHERE rolname='s');
