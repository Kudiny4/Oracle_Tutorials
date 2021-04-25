--Пакет с функцией и процедурой
--Имеется таблица планет
--create table planets(id integer, name varchar2(100));
--и сиквенс
--create sequence sq_planets;
--Написать пакет, в котором есть:
-- - процедура с параметрами num_rows и max_length, которая вставляет в эту таблицу num_rows строк:
--id из сиквенса, name – строка случайной длины от 1 до max_length со случайными символами.
-- - функция с параметром name_length, которая для заданной длины name_length выдаёт самую первую по алфавиту планету с названием такой длины (name без id).

CREATE TABLE planets (
    id    INTEGER,
    name  VARCHAR2(100)
);

CREATE SEQUENCE sq_planets;

CREATE OR REPLACE PACKAGE task_2_pkg IS
    PROCEDURE task_2_p (
        num_rows    IN  INTEGER,
        max_length  IN  INTEGER
    );

    FUNCTION task_2_f (
        name_length IN INTEGER
    ) RETURN VARCHAR2;

END task_2_pkg;

CREATE OR REPLACE PACKAGE BODY task_2_pkg IS

    PROCEDURE task_2_p (
        num_rows    IN  INTEGER,
        max_length  IN  INTEGER
    ) IS
        nm_ln INTEGER;
    BEGIN
        FOR i IN 1..num_rows LOOP
            nm_ln := trunc(dbms_random.value(1, max_length));
            INSERT INTO planets (
                id,
                name
            ) VALUES (
                sq_planets.NEXTVAL,
                dbms_random.string(1, nm_ln)
            );

        END LOOP;
    END task_2_p;

    FUNCTION task_2_f (
        name_length IN INTEGER
    ) RETURN VARCHAR2 IS
        res VARCHAR2(100);
    BEGIN
        SELECT
            name
        INTO res
        FROM
            (
                SELECT
                    name,
                    length(name) AS length
                FROM
                    planets
                ORDER BY
                    length,
                    name
            )
        WHERE
                length = name_length
            AND ROWNUM = 1;

        RETURN res;
    END task_2_f;

END task_2_pkg;

    
    
    
SET SERVEROUTPUT ON

BEGIN
    dbms_output.enable;
    task_2_pkg.task_2_p(10, 15);
END;

--select * from planets;

SELECT
    task_2_pkg.task_2_f(6)
FROM
    dual;
    
--DROP TABLE planets;
--drop sequence sq_planets;
