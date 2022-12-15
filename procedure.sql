CREATE PROCEDURE create_employee(n_full_name text, n_email varchar(320), n_phone_number varchar(12), n_position_num int,
                                 n_employee_login text, n_password text)
AS
$$
BEGIN
    IF (SELECT count(*) FROM pg_roles WHERE rolname = n_employee_login)
    THEN
        RAISE EXCEPTION 'Такой сотрудник уже сущесвует';
    ELSE

    INSERT INTO employee(employee_login, password, full_name, email, phone_number, position_id) VALUES (n_employee_login, crypt(n_password, gen_salt('md5')), n_full_name, n_email, n_phone_number, n_position_num);
        EXECUTE format('CREATE ROLE %s WITH LOGIN PASSWORD %L;', n_employee_login, n_password);
        EXECUTE format('GRANT %s TO %s;', (SELECT position_name
                                           FROM employees_position
                                           WHERE n_position_num = employees_position.position_id), n_employee_login);
        COMMIT;
    END IF;
END;
$$ LANGUAGE plpgsql;
/* Создание сотрудника  */