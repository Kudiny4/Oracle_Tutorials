/*Результаты первого тура выборов

Дана таблица со списком из 4 кандидатов и их результатов на выборах - процентов с точностью до 2 знаков после запятой:

Дана таблица для вставки в неё результатов первого тура выборов.

Написать процедуру, которая должна сделать следующее:

1)
Заполнить таблицу candidates случайными именами кандидатов из 10 символов и случайными их результатами на выборах в процентах проголосовавших.
В сумме все результаты должны дать 100 процентов (с точностью до ошибок округления, т.е. может выйти 99.99 или 100.01 процентов в сумме).
Например, так:
FfKIAVVGhW	66,21
tNLwfMnKsq	24,83
RSzeaZYFNw	6,90
IdfyXFhWAT	2,07

2)
Затем заполнить таблицу vote_results результатов первого тура выборов.
Либо будет один победитель, набравший более 50 процентов голосов.
Тогда is_finished=1 и вставляем одну строку. Например,
FfKIAVVGhW 55.13 1

Либо будет два кандидата, набравших наибольшее количество голосов, вышедших во второй тур.
Тогда is_finished=0 и вставляем две строки. Например:
FfKIAVVGhW 44.92 0
tNLwfMnKsq 29.53 0
или так:
FfKIAVVGhW 43.01 0
tNLwfMnKsq 43.01 0        */

CREATE TABLE candidates (
    name  VARCHAR2(100),
    prc   NUMBER(5, 2)
);
--drop table candidates;

CREATE TABLE vote_results (
    name         VARCHAR2(100),
    prc          NUMBER(5, 2),
    is_finished  INTEGER
);
--drop table vote_results;


CREATE OR REPLACE PROCEDURE candidates_and_results IS
    coef NUMBER(5, 4);
BEGIN
    FOR z IN 1..4 LOOP
        INSERT INTO candidates (
            name,
            prc
        ) VALUES (
            ( dbms_random.string('a', 10) ),
            round((dbms_random.value * 100), 2)
        );

    END LOOP;

    SELECT
        ( 100 / SUM(prc) )
    INTO coef
    FROM
        candidates;

    UPDATE candidates
    SET
        prc = prc * coef;

    FOR i IN (
        SELECT
            name,
            prc
        FROM
            (
                SELECT
                    name,
                    prc,
                    ROW_NUMBER()
                    OVER(
                        ORDER BY prc DESC
                    ) row_num
                FROM
                    candidates
            )
        WHERE
            row_num < 3
        ORDER BY
            prc DESC
    ) LOOP
        IF i.prc > 50 THEN
            INSERT INTO vote_results (
                name,
                prc,
                is_finished
            ) VALUES (
                i.name,
                i.prc,
                1
            );

            EXIT;
        ELSE
            INSERT INTO vote_results (
                name,
                prc,
                is_finished
            ) VALUES (
                i.name,
                i.prc,
                0
            );

        END IF;
    END LOOP;

END candidates_and_results;


--Проверка

begin candidates_and_results; end;

select * from candidates;

select * from vote_results;



