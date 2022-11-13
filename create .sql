/* Удаление таблиц */

DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS hard_drive;
DROP TABLE IF EXISTS connection_interface_type;
DROP TABLE IF EXISTS contract;
DROP TABLE IF EXISTS contact_person;
DROP TABLE IF EXISTS contract_classifier;
DROP TABLE IF EXISTS drive_type;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS employees_position;
DROP TABLE IF EXISTS organization;
DROP TABLE IF EXISTS organization_type;
DROP TABLE IF EXISTS priority_task;
DROP TABLE IF EXISTS task_receipt_type;
DROP TABLE IF EXISTS task_status;


/* Создание таболиц */

CREATE TABLE connection_interface_type
(
	connection_interface_id serial NOT NULL,
	interface_name varchar(20) NOT NULL,
	transfer_rate int NOT NULL,
	PRIMARY KEY (connection_interface_id)
) WITHOUT OIDS;

CREATE TABLE contact_person
(
	person_id serial NOT NULL,
	full_name varchar(100) NOT NULL,
	phone_number varchar(12) NOT NULL,
	email varchar(320) NOT NULL,
	address text NOT NULL,
	postal_code varchar(6) NOT NULL,
	organization_id int NOT NULL,
	PRIMARY KEY (person_id)
) WITHOUT OIDS;

CREATE TABLE contract
(
	contract_id serial NOT NULL,
	info text,
	type_id int NOT NULL,
	person_id int NOT NULL,
	PRIMARY KEY (contract_id)
) WITHOUT OIDS;

CREATE TABLE contract_classifier
(
	type_id serial NOT NULL,
	type_name varchar(50) NOT NULL,
	PRIMARY KEY (type_id)
) WITHOUT OIDS;

CREATE TABLE drive_type
(
	drive_type_id serial NOT NULL,
	drive_type_name varchar(10) NOT NULL,
	PRIMARY KEY (drive_type_id)
) WITHOUT OIDS;

CREATE TABLE employee
(
	employee_id bigserial NOT NULL,
	employee_login text NOT NULL UNIQUE,
	password text NOT NULL,
	full_name text NOT NULL,
	email varchar(320) NOT NULL,
	phone_number varchar(12) NOT NULL,
	position_id int NOT NULL,
	PRIMARY KEY (employee_id)
) WITHOUT OIDS;

CREATE TABLE employees_position
(
	position_id serial NOT NULL,
	position_name varchar(15) NOT NULL,
	PRIMARY KEY (position_id)
) WITHOUT OIDS;

CREATE TABLE hard_drive
(
	serial_number bigserial NOT NULL,
	drive_name varchar(100) NOT NULL,
	drive_size int NOT NULL,
	drive_type_id int NOT NULL,
	connection_interface_id int NOT NULL,
	PRIMARY KEY (serial_number)
) WITHOUT OIDS;

CREATE TABLE organization
(
	organization_id serial NOT NULL,
	organization_name varchar(100) NOT NULL,
	phone_number varchar(12) NOT NULL,
	email varchar(320) NOT NULL,
	address text NOT NULL,
	postal_code varchar(6) NOT NULL,
	type_id int NOT NULL,
	PRIMARY KEY (organization_id)
) WITHOUT OIDS;

CREATE TABLE organization_type
(
	type_id serial NOT NULL,
	type_name varchar(13) NOT NULL,
	PRIMARY KEY (type_id)
) WITHOUT OIDS;

CREATE TABLE priority_task
(
	priority_id serial NOT NULL,
	priority_name varchar(7) NOT NULL,
	PRIMARY KEY (priority_id)
) WITHOUT OIDS;

CREATE TABLE task
(
	task_id serial NOT NULL,
	create_date timestamp with time zone NOT NULL,
	execution_period interval,
	completion_date timestamp with time zone,
	person_id int NOT NULL,
	contract_id int,
	serial_number bigint,
	priority_id int NOT NULL,
	receipt_id int NOT NULL,
	status_id int NOT NULL,
	author_id bigint NOT NULL,
	executor_id bigint,
	PRIMARY KEY (task_id)
) WITHOUT OIDS;

CREATE TABLE task_receipt_type
(
	receipt_id serial NOT NULL,
	receipt_name varchar(50) NOT NULL,
	PRIMARY KEY (receipt_id)
) WITHOUT OIDS;

CREATE TABLE task_status
(
	status_id serial NOT NULL,
	status_name varchar(12) NOT NULL,
	PRIMARY KEY (status_id)
) WITHOUT OIDS;


/* Добавление внешних ключей */

ALTER TABLE hard_drive
	ADD FOREIGN KEY (connection_interface_id)
	REFERENCES connection_interface_type (connection_interface_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE contract
	ADD FOREIGN KEY (person_id)
	REFERENCES contact_person (person_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (person_id)
	REFERENCES contact_person (person_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (contract_id)
	REFERENCES contract (contract_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE contract
	ADD FOREIGN KEY (type_id)
	REFERENCES contract_classifier (type_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE hard_drive
	ADD FOREIGN KEY (drive_type_id)
	REFERENCES drive_type (drive_type_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (author_id)
	REFERENCES employee (employee_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (executor_id)
	REFERENCES employee (employee_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE employee
	ADD FOREIGN KEY (position_id)
	REFERENCES employees_position (position_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (serial_number)
	REFERENCES hard_drive (serial_number)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE contact_person
	ADD FOREIGN KEY (organization_id)
	REFERENCES organization (organization_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE organization
	ADD FOREIGN KEY (type_id)
	REFERENCES organization_type (type_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (priority_id)
	REFERENCES priority_task (priority_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (receipt_id)
	REFERENCES task_receipt_type (receipt_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

ALTER TABLE task
	ADD FOREIGN KEY (status_id)
	REFERENCES task_status (status_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;