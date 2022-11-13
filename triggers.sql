CREATE FUNCTION check_task_update()
    RETURNS TRIGGER AS  $check_update_trigger$
    BEGIN
        IF (SELECT employee_login FROM employee WHERE (OLD.author_id = employee.employee_id) != current_user) THEN
            RAISE EXCEPTION 'Для изменения данных  полей необходимо быть автором';
        END IF;
        RETURN NEW;
    END;
$check_update_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER check_task_update_trigger
    BEFORE UPDATE OF create_date, person_id, contract_id, serial_number, receipt_id, author_id, executor_id ON task
    FOR EACH ROW
EXECUTE FUNCTION check_task_update();
/* Изменять все поля в задаче может только автор  */

CREATE FUNCTION delete_old_task()
    RETURNS TRIGGER AS $delete_old_task_trigger$
    BEGIN
       DELETE FROM task WHERE ((date_part('month', current_date) - date_part('month', completion_date)) +
                               12 * (date_part('year', current_date) - date_part('year', completion_date))) > 12;
       RETURN NEW;
    END;
$delete_old_task_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER delete_old_task_trigger
    BEFORE INSERT ON task
    FOR EACH ROW
EXECUTE FUNCTION delete_old_task();
/* Задачи 12 месячной давности удаляются */

CREATE PROCEDURE create_employee(full_name text, email varchar(320), phone_number varchar(12), position_num int, employee_login text, password text)
AS $$
BEGIN
    IF (SELECT count(*) FROM pg_roles  WHERE rolname = employee_login)
        THEN RAISE EXCEPTION 'Такой сотрудник уже сущесвует';
    ELSE
        EXECUTE format('INSERT INTO employee(employee_login, password, full_name, email, phone_number, position_id) VALUES (%F, %F, %F, %F, %F, %F);', employee_login, crypt(password, gen_salt('md5')), full_name, email, phone_number, position_num);
        EXECUTE format('CREATE ROLE %R WITH LOGIN PASSWORD %R;', employee_login, password);
        EXECUTE format('GRANT %G TO %G;', (SELECT position_name FROM employees_position WHERE position_num = employees_position.position_id), employee_login);
        COMMIT;
    END IF;
END;
$$ LANGUAGE plpgsql;
/* Создание сотрудника  */

CREATE FUNCTION delete_role_employee()
    RETURNS TRIGGER AS $delete_employee_trigger$
    BEGIN
        EXECUTE format('DROP ROLE %R;', OLD.employee_login);
        RETURN NULL;
    END;
$delete_employee_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER delete_employee_trigger
    AFTER DELETE ON employee
    FOR EACH ROW
EXECUTE FUNCTION delete_role_employee();
/* Удаление пользователя */


