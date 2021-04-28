                --ФИНАНСОВОЕ ПОЛОЖЕНИЕ КЛИЕНТОВ
--Есть таблица клиентов банка, есть таблица депозитов, есть таблица кредитов.
--Составить отчёт:
--Клиент, количество депозитов, сумма депозитов, количество кредитов, сумма кредитов.
--Упорядочить по имени клиента.

create table bank_clients(client_name varchar2(100));
insert into bank_clients(client_name) values('Хвостиков');
insert into bank_clients(client_name) values('Усатый');
insert into bank_clients(client_name) values('Мордарейкин');
insert into bank_clients(client_name) values('Пушной');
insert into bank_clients(client_name) values('Шерстнёв');


create table bank_deposits(client_name varchar2(100), deposit_id integer, deposit_amount number(18,2));
insert into bank_deposits(client_name, deposit_id, deposit_amount) values('Хвостиков', 1, 88489.32);
insert into bank_deposits(client_name, deposit_id, deposit_amount) values('Хвостиков', 2, 7456.25);
insert into bank_deposits(client_name, deposit_id, deposit_amount) values('Мордарейкин', 3, 456990.15);
insert into bank_deposits(client_name, deposit_id, deposit_amount) values('Мордарейкин', 4, 748856.00);
insert into bank_deposits(client_name, deposit_id, deposit_amount) values('Шерстнёв', 5, 123.45);


create table bank_credits(client_name varchar2(100), credit_id integer, credit_amount number(18,2));
insert into bank_credits(client_name, credit_id, credit_amount) values('Хвостиков', 1, 67.32);
insert into bank_credits(client_name, credit_id, credit_amount) values('Усатый', 2, 742256.25);
insert into bank_credits(client_name, credit_id, credit_amount) values('Усатый', 3, 46990.15);
insert into bank_credits(client_name, credit_id, credit_amount) values('Шерстнёв', 4, 56.00);
insert into bank_credits(client_name, credit_id, credit_amount) values('Шерстнёв', 5, 99123.45);


SELECT
    a.client_name,
    nvl(d.num_deposits, 0) as num_deposits,
    nvl(d.sum_deposits, 0) as sum_deposits,
    nvl(c.num_credits, 0)  as num_credits,
    nvl(c.sum_credits, 0)  as sum_credits
FROM
    bank_clients  a,
    (
        SELECT
            client_name,
            COUNT(deposit_id)       AS num_deposits,
            SUM(deposit_amount)     AS sum_deposits
        FROM
            bank_deposits
        GROUP BY
            client_name
    )             d,
    (
        SELECT
            client_name,
            COUNT(credit_id)       AS num_credits,
            SUM(credit_amount)     AS sum_credits
        FROM
            bank_credits
        GROUP BY
            client_name
    )             c
WHERE
        a.client_name = d.client_name (+)
    AND a.client_name = c.client_name (+)
ORDER BY
    a.client_name

