# База данных для ПР company_db

## ТЗ 
Компания, поставляющая оборудование, в рамках обеспечения своей коммерческой деятельности нуждается в системе управления контактами со своей клиентурой. Клиенты делятся на два вида: текущие – те, с которыми у компании заключены договора в текущий момент или ранее, и потенциальные.

Система управления контактами находится в распоряжении всех работников компании. Система поддерживает функции "постоянного контакта" с наличной и потенциальной клиентской базой, так, чтобы откликаться на ее нужды, получать новые контракты, обеспечивать выполнение старых. Система позволяет сотрудникам планировать задания, которые необходимо провести в отношении контактных лиц. 

Система хранит имена, номера телефонов, почтовые и электронные адреса и т.д. организаций и контактных лиц в этих организациях.

Каждое задание связано с каким-либо контактным лицом. Примерами заданий являются телефонный звонок, визит, отправка электронного сообщения, проведение презентации и т. д. Некоторые задания связаны с выполнением контракта, например, отправка оборудования, поставка, установка, гарантийный и послегарантийный ремонт. В таких заданиях указывается необходимая информация: номер контракта, серийный номер ремонтируемого оборудования. Каждое задание имеет дату создания – время внесения ее в систему. Некоторые задания имеют срок исполнения – период времени от начальной даты до финальной, другие являются бессрочными. Дата создания задания не может изменяться, а срок исполнения – может. По исполнении задания дата и время его завершения фиксируются.

Каждое задание имеет автора – сотрудника, который его создал. Исполнителем задания может быть сотрудник, не являющийся автором. Рядовые сотрудники не могут назначать задания. Менеджеры назначают задания себе или кому-либо из рядовых сотрудников. Менеджер в ходе выполнения созданного им задания может поменять исполнителя.

Просматривать задание, автором которого является менеджер, может либо автор, либо исполнитель задания. Должен быть реализован приоритет каждого задания (низкий, средний, высокий). Каждый менеджер может помимо своих задача просматривать задачи рядовых сотрудников. Помечать задание как выполненное и указывать дату завершения может либо автор, либо исполнитель задания. Вносить какие-либо другие изменения в задание может только автор. После завершения задания внесение в него изменений не допускается. По прошествии 12 месяцев после даты завершения задания сведения о нем удаляются из системы.

Администратор системы управляет доступом сотрудников: выдает логины и пароли пользователям, формирует две группы пользователей: менеджеров и рядовых сотрудников. Он также имеет доступ к специальным функциям, например, может изменить автора задания или внести изменения в завершенное задание.

Система имеет возможности для поиска в базе клиентов и контактных лиц по их атрибутам (названию, городу, имени контактного лица). Система генерирует отчет по исполнению заданий каким-либо сотрудником в течение периода времени, указываемого в параметре отчета. В отчете указывается: общее количество заданий для данного сотрудника в указанный период, сколько заданий завершено вовремя, сколько заданий завершено с нарушением срока исполнения, сколько заданий с истекшим сроком исполнения не завершено, и сколько не завершенных заданий, срок исполнения которых не истек. 

Генерация отчета должна происходить посредством выгрузки из базы данных в формат данных Excel (например, в xls) и json.

### Практическая работа разбита на 4 части, где:
1) Работа с ER-диаграммой и структурой базы данных
2) Заполнение базы данных, создание ролей, назначение привилегий
3) Автоматизация функционала
4) Реализация индексов, работа с выгрузкой данных

## ER-диаграама
![image](https://user-images.githubusercontent.com/71017226/201528851-c5dd024e-9f5f-41c9-87a8-27f9ffb4ab85.png)

## Описание таблиц
### organization
![image](https://user-images.githubusercontent.com/71017226/201528923-264a797b-999a-4dec-bae6-14f915575c7a.png)

### organization_type
![image](https://user-images.githubusercontent.com/71017226/201529078-b0ad7c37-b5ae-4af0-a862-adc70fbae4dc.png)
#### Значения:
- текущая
- потенциальная

### contact_person			
![image](https://user-images.githubusercontent.com/71017226/201529264-322804d2-3555-4b5a-815f-b316ee4e030e.png)

### contract		
![image](https://user-images.githubusercontent.com/71017226/201529286-d36a5dda-e6f7-4acd-bc73-6a005480537e.png)

### contract_classifier    
![image](https://user-images.githubusercontent.com/71017226/201529321-efa00c78-f295-467d-8122-3b8ab511e389.png)
#### Значения:
- отправка оборудования
- поставка оборудования
- установка оборудования
- гарантийный ремонт
- послегарантийный ремонт

### task		
![image](https://user-images.githubusercontent.com/71017226/201529436-e5911c2f-e8ba-4d94-89b2-986333752886.png)

### priority_task	 				
![image](https://user-images.githubusercontent.com/71017226/201529502-b4127a67-3f4f-4dec-989a-50500335ec96.png)
#### Значения:
- низкий
- средний
- высокий

### task_status	 				
![image](https://user-images.githubusercontent.com/71017226/201529539-e158f0d1-2879-46f8-9ec3-1b71fb554ba8.png)
#### Значения:
- не выполнено
- в процессе
- выполнено

### task_receipt_type 				
![image](https://user-images.githubusercontent.com/71017226/201529577-30c1c13a-8986-4baa-84f6-15ebe3ac4062.png)
#### Значения:
- телефонный звонок
- электронное письмо
- визит котакного  лица
- проведение презентации

### employee		
![image](https://user-images.githubusercontent.com/71017226/201529614-2fda8402-6f18-4900-9452-1e891654c392.png)

### employees_position 				
![image](https://user-images.githubusercontent.com/71017226/201529763-6dc7c143-d828-475e-8e4a-bbdd9d7962bb.png)
#### Значения:
- worker
- manager

### hard_drive
![image](https://user-images.githubusercontent.com/71017226/201529828-9921d789-4ad0-476d-8231-bce046ffd549.png)

### drive_type			
![image](https://user-images.githubusercontent.com/71017226/201529915-1035ff81-3c4c-4a41-b9f1-2f36fe48bb40.png)

### connection_interface_type	
![image](https://user-images.githubusercontent.com/71017226/201529943-efec5f5f-e96d-4078-b1c5-8d4f0bb4a00b.png)

## Роли
1) worker 
2) manager

## Политика доступа
1) select_of_task - Просматривать задание может лиюо автор, либо исполнитель 
2) update_task_status - Изменять задание как выполненое может только автор или исполнитель (выполененое задание изменять нельзя)

## Тригерры
1) check_task_update_trigger - проверяет, что изменять все поля задачи может только автор
2) delete_old_task_trigger - для удаления задач 12 месячной давности
3) delete_employee_trigger - при удлании сотрудника удаляет роль

## Функции и процедуры 
1) create_employee - создание сотрудника 
2) save_to_svg - созранение отчета в svg
3) save_tasks_to_json - выгрузка задач в json
