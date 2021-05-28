/*
Создать таблицу с результатами розыгрыша лотереи.
create table lotery_results(val integer);
С помощью анонимного блока случайным образом заполнить таблицу lotery_results шестью целыми несовпадающими значениями от 1 до 46, например,
2
10
22
25
31
37

Создать таблицу с заполненными лотерейными билетами участников лотереи.
create table lotery_guess(vallist varchar2(100));
Участники заполняют по 6 номеров через запятую.
С помощью анонимного блока случайным образом заполнить таблицу lotery_guess 10000 строками с лотерейными билетами, которые заполнили участники лотереи.
Участники лотереи отмечают на билете шесть целых несовпадающих значений от 1 до 46.
Анонимный блок должен вставить в таблицу lotery_guess, например, такие 10000 строк:
4,42,5,21,37,20
2,26,35,32,25,20
28,40,3,33,43,36
11,15,37,46,19,12
1,39,33,43,42,19
...

Затем написать запрос, который для каждой строки из таблицы lotery_guess укажет,
сколько номеров угадал участник лотереи из числа выигрышных номеров, содержащихся в lotery_results.
Запрос должен выдать 2 столбца: столбец lotery_guess.vallist и столбец num_rigth_answers с числом верно угаданных ответов.
Например,
28,35,29,13,32,3 1
7,14,39,38,31,37 4
22,41,2,34,29,44 0
29,15,12,46,32,26 1
13,40,24,8,31,26 2
33,26,12,39,10,35 3
...
*/


create table lotery_results(val integer);
create table lotery_guess(vallist varchar2(100));

/* Заполняем данными таблицу lotery_results */
declare 
row_num integer := 0; 
rand_val integer;
doubles integer;
begin
while row_num < 6
loop
rand_val := round(dbms_random.value * 100);
select count(val) into doubles from lotery_results where val = rand_val;
if rand_val > 46 or rand_val = 0 or doubles > 0
then 
continue;
else
insert into lotery_results (val) values (rand_val);
select max(rownum) into row_num from lotery_results;
end if;
end loop;
end;
commit;

--select * from lotery_results order by val;

/* Заполняем данными таблицу lotery_guess */

declare 
value varchar2(100);
count_iter integer := 0;
length integer;
begin
loop
with 
a as (select round(dbms_random.value * 100) val from dual),
b as (select distinct val from a
connect by level <= 20),
c as (select val from b where val <= 46 and val > 0 and rownum <= 6),
d as (select ltrim(sys_connect_by_path(val, ','), ',') as vals, level
          from (select val, lag(val) over(order by val) as prev_val
                  from c)
         start with prev_val is null
        connect by prev_val = prior val
         order by level desc)
select vals into value from d where rownum = 1;
select regexp_count (value, ',') into length from dual;
if length < 5 then
continue;
else 
insert into lotery_guess values(value);
count_iter := count_iter + 1;
end if;
exit when count_iter = 10000;
end loop;
end;
commit;

--select * from lotery_results order by val;
--select * from lotery_guess;
--truncate table lotery_results;
--truncate table lotery_guess;

/* Подсчёт количества совпадений значений в таблице lotery_guess со значениями в таблице lotery_results */

select vallist, sum(decode(to_char(val), client_val, 1, 0)) num_rigth_answers from lotery_results
full join
(select rn, vallist, regexp_substr(vallist, '[^,]+', 1, column_value) as client_val
  from (select row_number() over (order by vallist) rn, vallist from lotery_guess),
       table(cast(multiset
                  (select level
                     from dual
                   connect by regexp_instr(vallist, '[^,]+', 1, level) > 0) as
                  sys.odcinumberlist))) 
on to_char(val)=client_val
group by rn, vallist;