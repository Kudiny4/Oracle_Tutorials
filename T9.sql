/*
Равномерное распределение по группам

Создать таблицу количеств транзакций по дням месяца.
dt - дата транзакции
cnt - количество транзакции за дату dt
group_id - группа для параллельной обработки

--drop table trans;
create table trans(dt date, cnt integer, group_id number);

Заполнить таблицу случайными данными
dt - от 01.06.2021 до 30.06.2021
cnt - от 0 до 999999
group_id - пока не проставляем
  
Написать анонимный PL/SQL блок, который проставит в таблице trans значения поля group_id от 1 до num_groups=8.
Тем самым таблица trans будет разбита на num_groups=8 групп для параллельной обработки.
Нужно придумать алгоритм, который разобьёт данные максимально равномерно по группам, осуществив update-ы таблицы trans.
Т.е. стремимся к тому, чтобы сумма значений cnt в каждой группе group_id была максимально близка к средней сумме по группам.

Как проставились группы и какие суммы получились в каждой группе, можно смотреть запросом:

select dt, cnt, group_id, sum(cnt) over(partition by group_id) sum_cnt_in_group from trans;

Чем меньше возвращаемое нижеприведённым запросом суммарное отклонение групповых сумм от среднегрупповой суммы, тем ваш алгоритм лучше:

select sum(delta_with_avg) sum_delta_with_avg
  from (select abs(sum_cnt_in_group - avg(sum_cnt_in_group) over()) delta_with_avg
          from (select group_id, sum(cnt) sum_cnt_in_group
                  from trans
                 group by group_id));
*/

--drop table trans;
create table trans(dt date, cnt integer, group_id number);

insert into trans
  (dt, cnt)
  select to_date('31.05.2021', 'dd.mm.yyyy') + level dt,
         trunc(1000000 * dbms_random.value) cnt
    from dual
  connect by level <= 30;
commit;

declare 
max_cnt integer := 0;
min_group number;
max_date date;
begin
for z in 1..8 loop
select max(cnt) into max_cnt from trans where group_id is Null;
select max(dt) into max_date from trans where cnt = max_cnt;
update trans set group_id = z where dt = max_date;
end loop;
for z in 1..22 loop
select max(cnt) into max_cnt from trans where group_id is Null;
select max(dt) into max_date from trans where cnt = max_cnt;
with a as (select sum(cnt) cnt, 
                  group_id 
           from trans 
           where group_id is not Null 
           group by group_id 
           order by cnt),
b as (select row_number() over(order by cnt) min_row_num, 
             cnt, 
             group_id 
             from a)
select group_id into min_group from b where min_row_num = 1;
update trans set group_id = min_group 
    where cnt = max_cnt 
    and dt = max_date;
end loop;
end;
/
commit;