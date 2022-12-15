CREATE FUNCTION check_task_update()
    RETURNS TRIGGER AS
$check_update_trigger$
BEGIN
    IF (SELECT employee_login FROM employee WHERE (NEW.author_id = employee.employee_id)) != current_user THEN
        RAISE EXCEPTION 'Для изменения данных  полей необходимо быть автором';
    END IF;
    RETURN NEW;
END;
$check_update_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER check_task_update_trigger
    BEFORE UPDATE OF create_date, person_id, contract_id, serial_number, receipt_id, author_id, executor_id
    ON task
    FOR EACH ROW
EXECUTE FUNCTION check_task_update();
/* Изменять все поля в задаче может только автор  */

CREATE FUNCTION update_completion_date()
    RETURNS TRIGGER AS
$update_completion_date$
BEGIN
    IF NEW.status_id = 3 THEN
        UPDATE task SET completion_date = now() WHERE task_id = NEW.task_id;
    END IF;
    RETURN NEW;
END;
$update_completion_date$ LANGUAGE plpgsql;

CREATE TRIGGER update_completion_date
    AFTER UPDATE OF status_id
    ON task
    FOR EACH ROW
EXECUTE FUNCTION update_completion_date();
/* обновлении даты выолнения */

DROP FUNCTION delete_old_task() CASCADE;
CREATE FUNCTION delete_old_task()
    RETURNS TRIGGER AS
$delete_old_task_trigger$
BEGIN
    DELETE
    FROM task
    WHERE ((date_part('month', current_date) - date_part('month', OLD.completion_date)) +
           12 * (date_part('year', current_date) - date_part('year', OLD.completion_date))) > 12;
    RETURN null;
END;
$delete_old_task_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER delete_old_task_trigger
    AFTER INSERT
    ON task
    FOR EACH ROW
EXECUTE FUNCTION delete_old_task();
/* Задачи 12 месячной давности удаляются */


CREATE FUNCTION delete_role_employee()
    RETURNS TRIGGER AS
$delete_employee_trigger$
BEGIN
    EXECUTE format('DROP ROLE %R;', OLD.employee_login);
    RETURN NULL;
END;
$delete_employee_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER delete_employee_trigger
    AFTER DELETE
    ON employee
    FOR EACH ROW
EXECUTE FUNCTION delete_role_employee();
/* Удаление пользователя */


