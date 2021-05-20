/*Дана таблица классификации существ:

create table classification(unit varchar2(30), name varchar2(200));
insert into classification(unit, name) values('1', 'животные');
insert into classification(unit, name) values('1.1', 'принадлежащие Императору');
insert into classification(unit, name) values('1.1.1', 'конь Буцефал');
insert into classification(unit, name) values('1.1.2', 'левретка Земира');
insert into classification(unit, name) values('1.2', 'набальзамированные');
insert into classification(unit, name) values('1.2.1', 'кошки');
insert into classification(unit, name) values('1.2.1.1', 'мумия египетской кошки');
insert into classification(unit, name) values('1.3', 'прирученные');
insert into classification(unit, name) values('1.3.1', 'Лис');
insert into classification(unit, name) values('1.4', 'молочные поросята');
insert into classification(unit, name) values('1.4.1', 'Борька');
insert into classification(unit, name) values('1.4.2', 'Зорька');
insert into classification(unit, name) values('1.5', 'сирены');
insert into classification(unit, name) values('1.5.1', 'дюгоневые');
insert into classification(unit, name) values('1.5.1.1', 'морская корова');
insert into classification(unit, name) values('1.5.2', 'ламантиновые');
insert into classification(unit, name) values('1.5.2.1', 'Амазонский ламантин');
insert into classification(unit, name) values('1.5.2.2', 'карликовый ламантин');
insert into classification(unit, name) values('1.6', 'сказочные');
insert into classification(unit, name) values('1.6.1', 'змеи');
insert into classification(unit, name) values('1.6.1.1', 'одноголовые');
insert into classification(unit, name) values('1.6.1.2', 'трёхголовые');
insert into classification(unit, name) values('1.6.1.2.1', 'Горыныч');
insert into classification(unit, name) values('1.7', 'бродячие собаки');
insert into classification(unit, name) values('1.7.1', 'Шарик');
insert into classification(unit, name) values('1.8', 'включённые в эту классификацию');
insert into classification(unit, name) values('1.9', 'бегающие как сумасшедшие');
insert into classification(unit, name) values('1.9.1', 'курочка Ряба');
insert into classification(unit, name) values('1.10', 'бесчисленные');
insert into classification(unit, name) values('1.10.1', 'комары');
insert into classification(unit, name) values('1.11', 'нарисованные тончайшей кистью из верблюжьей шерсти');
insert into classification(unit, name) values('1.12', 'прочие');
insert into classification(unit, name) values('1.12.1', 'муха цеце');
insert into classification(unit, name) values('1.13', 'разбившие цветочную вазу');
insert into classification(unit, name) values('1.13.1', 'свинка Пеппа');
insert into classification(unit, name) values('1.13.2', 'Дональд Дак');
insert into classification(unit, name) values('1.14', 'похожие издали на мух');
insert into classification(unit, name) values('1.14.1', 'шерстистые');
insert into classification(unit, name) values('1.14.1.1', 'шерстистый носорог');
insert into classification(unit, name) values('1.14.1.2', 'мамонт');
insert into classification(unit, name) values('2', 'растения');
insert into classification(unit, name) values('2.1', 'астра');
insert into classification(unit, name) values('2.2', 'альстромерия');

Написать запрос, который развернёт по каждому существу полный путь от вершины классификации до конечного элемента.*/

SELECT
    ( unit
      || ' '
      || regexp_replace(sys_connect_by_path(name, '>'), '^>') ) AS result
FROM
    (
        SELECT
            unit,
            CASE
                WHEN instr(unit, '.') > 0 THEN
                    regexp_replace(unit, '[.][[:digit:]]+$')
            END parent_unit,
            name
        FROM
            classification
    )
START WITH
    parent_unit IS NULL
CONNECT BY
    PRIOR unit = parent_unit;