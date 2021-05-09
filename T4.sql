--Во всех таблицах и вьюшках текущей схемы найти первые по алфавиту столбцы среди столбцов, 
--имеющих типы данных не BLOB и не CLOB.
--Найти минимальное значение, хранящееся в таком первом по алфавиту столбце каждой таблицы или вьюшки, 
--привести его к строковому типу данных (в формате по умолчанию).
--Вывести в dbms_output отчёт о таблицах, их первых по алфавиту столбцах и минимальных значениях в этих столбцах.
--Не использовать вспомогательных таблиц.


SET SERVEROUTPUT ON

DECLARE
    table_name      VARCHAR2(100);
    column_name     VARCHAR2(100);
    column_content  VARCHAR2(100);
BEGIN
    dbms_output.enable;
    FOR z IN (
        SELECT
            table_name,
            MIN(column_name) AS "COLUMN_NAME"
        FROM
            user_tab_columns
        WHERE
                data_type != 'BLOB'
            AND data_type != 'CLOB'
        GROUP BY
            table_name
        ORDER BY
            table_name
    ) LOOP
        table_name := z.table_name;
        column_name := z.column_name;
        EXECUTE IMMEDIATE 'select min('
                          || column_name
                          || ') from '
                          || table_name
                          || ''
        INTO column_content;
        CONTINUE WHEN column_content IS NULL;
        dbms_output.put_line(to_char(rpad('table_name = ' || table_name, 31))
                             || to_char(rpad('column_name = ' || column_name, 31))
                             || to_char(rpad('min_value = ' || column_content, 31)));

    END LOOP;

END;