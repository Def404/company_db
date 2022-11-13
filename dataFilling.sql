/* заполнение классификаторов */

INSERT INTO
    organization_type (type_name)
VALUES
    ('текущая'),
    ('потенциальная');

INSERT INTO
    contract_classifier (type_name)
VALUES
    ('отправка оборудования'),
    ('поставка оборудования'),
    ('установка оборудования'),
    ('гарантийный ремонт'),
    ('послегарантийный ремонт');

INSERT INTO
    priority_task (priority_name)
VALUES
    ('низкий'),
    ('средний'),
    ('высокий');

INSERT INTO
    task_receipt_type (receipt_name)
VALUES
    ('телефонный звонок'),
    ('электронное письмо'),
    ('визит котакного  лица'),
    ('проведение презентации');

INSERT INTO
    task_status (status_name)
VALUES
    ('не выполнено'),
    ('в процессе'),
    ('выполнено');

INSERT INTO
    employees_position (position_name)
VALUES
    ('worker'),
    ('manager');

INSERT INTO
    drive_type (drive_type_name)
VALUES
    ('HDD'),
    ('SSD');

INSERT INTO
    connection_interface_type (interface_name, transfer_rate)
VALUES
    ('ATA', 66),
    ('SATA', 150),
    ('FireWire', 160),
    ('SCSI', 320),
    ('SAS',  600),
    ('USB', 380);

/* заполнение остальных таблиц */

INSERT INTO
    organization (organization_name, phone_number, email, address, postal_code, type_id)
VALUES
    ('Big drive', '+74991551555', 'bigdrive@bd.com', 'г. Москва, ул. Главаная, дом 5', '144555', 1),
    ('Last Cloud', '+74998524565', 'lastcloud@lc.com', 'г. Москва, ул. Главаная, дом 55', '144555', 2),
    ('PC Help', '+74991758746', 'pchelp@ph.com', 'г. Москва, ул. Тупиковая, дом 35', '145321', 1);

INSERT INTO
    contact_person (full_name, phone_number, email, address, postal_code, organization_id)
VALUES
    ('Петров Сергей Сергеевич', '+79157854567', 'petrov_s_s@bd.com', 'г. Москва, ул. Осенняя, дом 5', '147123', 1),
    ('Александров Александр Александрович', '+79851235826', 'alexndrov_a_a@lc.com', 'г. Москва, ул. Ленина, дом 3', '147123', 2),
    ('Дуб Максим Петрович', '+79184526584', 'dub_m_p@ph.com', 'г. Москва, ул. Осенняя, дом 10', '147123', 3);


INSERT INTO
    employee (employee_login, password, full_name, email, phone_number, position_id)
VALUES
    ('smirnov', crypt('_te_53#df10', gen_salt('md5')), 'Смирнов Алексей Борисович', 'smirnov@company.com', '+79851234568', 1),
    ('mikheev', crypt('_saf#4324', gen_salt('md5')),'Михеев Михаил Алексеевич', 'smirnov@company.com', '+79851234568', 2),
    ('ershova', crypt('9_sdfS_4', gen_salt('md5')),'Ершова Вероника Данииловна', 'ershova@company.com', '+79857414569', 1),
    ('kuznetsova', crypt('_2144_sdad_54', gen_salt('md5')),'Кузнецова Майя Романовна', 'kuznetsova@company.com', '+79854417895', 2);


INSERT INTO
    hard_drive (drive_name, drive_size, drive_type_id, connection_interface_id)
VALUES
    ('SSD BLACK 64',  64, 2, 2),
    ('HDD White USB 128',  128, 1, 6),
    ('SSD GOLD 1024',  1024, 2, 5),
    ('SSD BLACK 32',  32, 2, 2),
    ('HDD Blue 256',  256, 1, 2);

INSERT INTO
    contract  (info, type_id, person_id)
VALUES
    ('Поставить в короткие строки', 2,1),
    ('Поченить жеский диск', 4, 2);

INSERT INTO
    task  (create_date, person_id, priority_id, receipt_id, status_id, author_id)
VALUES
    (now(), 3, 1, 1, 1, 1),
    (now(), 2, 2,2, 1, 2);

INSERT INTO
    task (create_date, execution_period, person_id, contract_id, serial_number, priority_id, receipt_id, status_id, author_id, executor_id)
VALUES
    (now(), INTERVAL '5 days', 1, 1, 4, 3, 3, 2, 2,  3),
    (now(), INTERVAL '10 days', 2, 2, 2, 3, 1, 2, 4,  1);


SELECT * FROM employee WHERE password = crypt('_te_53#df10', password);