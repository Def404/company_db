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

GRANT DELETE ON
    task
    TO manager;


REVOKE UPDATE (executor_id) ON task FROM manager;
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
    USING ((task.status_id <= 3) AND (

            (SELECT employee_login
             FROM employee
             WHERE (task.author_id = employee.employee_id)) = current_user OR
            (SELECT employee_login
             FROM employee
             WHERE (task.executor_id = employee.employee_id)) = current_user
        ));



/* Изменять задание как выполненое может только автор или исполнитель (выполененое задание изменять нельзя) */
CREATE POLICY insert_task ON task
    FOR INSERT
    TO manager
    WITH CHECK (true);

CREATE POLICY delete_task ON task
FOR  DELETE
TO manager, worker
USING (true);

CREATE ROLE smirnov WITH LOGIN PASSWORD '_Te_53#df10';
GRANT manager TO smirnov;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO worker;
GRANT USAGE, SELECT ON ALl SEQUENCES IN SCHEMA public TO company_auth_role;

CREATE ROLE mikheev WITH LOGIN PASSWORD '_saf#4324';
GRANT manager TO mikheev;

CREATE ROLE ershova WITH LOGIN PASSWORD '9_sdfS_4';
GRANT worker TO ershova;

CREATE ROLE kuznetsova WITH LOGIN PASSWORD '_2144_sdad_54';
GRANT manager TO kuznetsova;

