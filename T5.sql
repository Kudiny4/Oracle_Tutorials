------------------Отключаемый триггер------------------

--Имеется таблица заказов:
--create table sbermarket_order(id integer, price number(10,2));

--Для автоинкрементного поля id этой таблицы создана последовательность:
--create sequence sq_sbermarket_order;

--Дана таблица журнала принятых заказов c указанием момента принятия заказа в поле dt:
--create table sbermarket_order_journal(id integer, price number(10,2), dt date);

--Дана переменная в заголовке пакета, отвечающая за включение/отключение режима журналирования:
--create or replace package pck_journal_mode as
  --journal_mode boolean := true;
--end;

--Создать триггер before insert на таблицу sbermarket_order, который обеспечивает автозаполнение поля id из сиквенса.
--Создать триггер after insert на таблицу sbermarket_order, который записывает принятые заказы в таблицу журнала, если только установлен режим журналирования pck_journal_mode.journal_mode = true

create table sbermarket_order(id integer, price number(10,2));
--drop table sbermarket_order;

create sequence sq_sbermarket_order;
--drop sequence sq_sbermarket_order;

create table sbermarket_order_journal(id integer, price number(10,2), dt date);
--drop table sbermarket_order_journal;

create or replace package pck_journal_mode as
  journal_mode boolean := true;
end;

create or replace trigger t5_trig_bi_sbermarket_order
before insert on sbermarket_order
for each row
begin
if :new.id is null then 
select sq_sbermarket_order.nextval into :new.id from dual;
end if;
end t5_trig_bi_sbermarket_order;

create or replace trigger t5_trig_ai_sbermarket_order
after insert on sbermarket_order
for each row
begin
if pck_journal_mode.journal_mode = TRUE then
insert into sbermarket_order_journal
(id, price, dt)
values
(:new.id, :new.price, sysdate); 
end if;
end t5_trig_ai_sbermarket_order;

-----------------------------Проверка-----------------------------

begin
  pck_journal_mode.journal_mode := true;
end;

insert into sbermarket_order(price) values(1556.89);
select * from sbermarket_order;
select * from sbermarket_order_journal;

begin
  pck_journal_mode.journal_mode := false;
end;

insert into sbermarket_order(price) values(2151.43);
select * from sbermarket_order;
select * from sbermarket_order_journal;


