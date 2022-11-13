CREATE FUNCTION save_tasks_to_json(path text)
    RETURNS VOID
AS $$
BEGIN
    EXECUTE format('COPY
    (SELECT
          json_agg(tasks) :: text
    FROM
        (SELECT
             t.task_id,
             (SELECT full_name FROM contact_person cp WHERE t.person_id = cp.person_id),
             (SELECT receipt_name FROM task_receipt_type tr WHERE t.receipt_id = tr.receipt_id),
             (SELECT full_name FROM employee e WHERE t.author_id = e.employee_id) AS author_name,
             (SELECT full_name FROM employee e WHERE t.executor_id = e.employee_id) AS executor_name,
             (SELECT status_name FROM task_status ts WHERE t.status_id = ts.status_id),
             t.priority_id,
             t.contract_id,
             t.serial_number,
             t.create_date,
             t.execution_period,
             t.completion_date
         FROM task t) AS tasks) TO ''%s\tasks.json'';', path);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION save_tasks_to_json(path text);

SELECT save_tasks_to_json('C:\Users\basc1\Desktop\test_data')