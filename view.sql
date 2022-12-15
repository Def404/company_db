DROP VIEW select_statistic;

CREATE VIEW select_statistic AS
SELECT (SELECT count(*)
        FROM task
        WHERE (SELECT employee_login
               FROM employee
               WHERE employee_id = task.executor_id) = current_user) AS all_tasks_cnt,

       (SELECT count(*)
        FROM task
        WHERE (SELECT employee_login
               FROM employee
               WHERE employee_id = task.executor_id) = current_user
          AND (date(task.create_date + task.execution_period) >= date(task.completion_date))
          AND (task.status_id = 3))                               AS tasks_cmplt_on_time_cnt,

       (SELECT count(*)
        FROM task
        WHERE (SELECT employee_login
               FROM employee
               WHERE employee_id = task.executor_id) = current_user
          AND (date(task.create_date + task.execution_period) < date(task.completion_date))
          AND (task.status_id = 3))                               AS tasks_cmplt_out_time_cnt,


       (SELECT count(*)
        FROM task
        WHERE (SELECT employee_login
               FROM employee
               WHERE employee_id = task.executor_id) = current_user
          AND (date(task.create_date + task.execution_period) < date(task.completion_date))
          AND (task.status_id != 3))                              AS tasks_not_cmplt_out_time_cnt,


       (SELECT count(*)
        FROM task
        WHERE (SELECT employee_login
               FROM employee
               WHERE employee_id = task.executor_id) = current_user
          AND (date(task.create_date + task.execution_period) >= date(task.completion_date))
          AND (task.status_id != 3))                              AS tasks_not_cmplt_on_time_cnt;

GRANT SELECT ON select_statistic TO manager, worker;

