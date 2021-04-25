--Дана таблица с городами, которые написаны с несколькими пробелами в конце.
--Для каждого города посчитать:
-- -количество гласных букв в написании города
-- -минимальное количество пробелов
-- -максимальное количество пробелов
--Упорядочить названия городов в алфавитном порядке.

create table cities(name varchar2(100));
insert into cities(name) values('Москва   ');
insert into cities(name) values('Москва');
insert into cities(name) values('Москва ');
insert into cities(name) values('Тверь    ');
insert into cities(name) values('Тверь     ');
insert into cities(name) values('Севастополь  '); 


select name, vowels, min(space), max(space) 
from(
select regexp_count(name, 'а|е|ё|и|о|у|ы|э|ю|я', 1, 'i') vowels,
replace(name, ' ') name,
regexp_count(name, ' ') space
from cities
)
group by name, vowels 
order by name;

