CREATE FUNCTION save_to_svg(eml_log text, date_left  date, date_right date,  file_path text)
    RETURNS VOID
AS $$
DECLARE
    all_tasks_cnt int; /* общее количество заданий для данного сотрудника в указанный период */
    tasks_cmplt_on_time_cnt int; /* количество заданий завершено вовремя */
    tasks_cmplt_out_time_cnt int; /* количество заданий завершено с нарушением срока исполнения */
    tasks_not_cmplt_out_time_cnt int; /* количество заданий с истекшим сроком исполнения не завершено */
    tasks_not_cmplt_on_time_cnt int; /* количество не завершенных заданий, срок исполнения которых не истек */
BEGIN
    all_tasks_cnt := (SELECT
                        count(*)
                    FROM
                        task
                    WHERE
                        (SELECT
                             employee_login
                         FROM employee
                         WHERE employee_id = task.executor_id) = eml_log AND
                        (task.create_date > date_left AND task.create_date < date_right));

    tasks_cmplt_on_time_cnt := (SELECT
                        count(*)
                    FROM
                        task
                    WHERE
                        (SELECT
                             employee_login
                         FROM employee
                         WHERE employee_id = task.executor_id) = eml_log AND
                        (date(task.create_date + task.execution_period) >= date(task.completion_date)) AND
                        (task.status_id = 3) AND
                        (task.create_date > date_left AND task.create_date < date_right));

    tasks_cmplt_out_time_cnt := (SELECT
                        count(*)
                    FROM
                        task
                    WHERE
                        (SELECT
                             employee_login
                         FROM employee
                         WHERE employee_id = task.executor_id) = eml_log AND
                        (date(task.create_date + task.execution_period) < date(task.completion_date)) AND
                        (task.status_id = 3) AND
                        (task.create_date > date_left AND task.create_date < date_right));

    tasks_not_cmplt_out_time_cnt := (SELECT
                        count(*)
                    FROM
                        task
                    WHERE
                        (SELECT
                             employee_login
                         FROM employee
                         WHERE employee_id = task.executor_id) = eml_log AND
                        (date(task.create_date + task.execution_period) < date(task.completion_date)) AND
                        (task.status_id != 3) AND
                        (task.create_date > date_left AND task.create_date < date_right));

    tasks_not_cmplt_on_time_cnt := (SELECT
                        count(*)
                    FROM
                        task
                    WHERE
                        (SELECT
                             employee_login
                         FROM employee
                         WHERE employee_id = task.executor_id) = eml_log AND
                        (date(task.create_date + task.execution_period) >= date(task.completion_date)) AND
                        (task.status_id != 3) AND
                        (task.create_date > date_left AND task.create_date < date_right));


    EXECUTE format('COPY (SELECT %s AS all_tasks_cnt,
        %s AS tasks_cmplt_on_time_cnt,
        %s AS tasks_cmplt_out_time_cnt,
        %s AS tasks_not_cmplt_out_time_cnt,
        %s AS tasks_not_cmplt_on_time_cnt)
    TO ''%s\%s_task_info_%s-%s.csv'' CSV HEADER;',
        all_tasks_cnt,
        tasks_cmplt_on_time_cnt,
        tasks_cmplt_out_time_cnt,
        tasks_not_cmplt_out_time_cnt,
        tasks_not_cmplt_on_time_cnt,
        file_path,
        eml_log,
        date_left,
        date_right);
END
$$ LANGUAGE plpgsql;

SELECT save_to_svg('smirnov', '25.09.2022', '24.10.2022', 'C:\Users\basc1\Desktop\test_data');