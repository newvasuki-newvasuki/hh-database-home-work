-- формируем временную таблицу с интересующими нас данными
(WITH tmp_table AS (
  SELECT
    extract(YEAR from create_date_time::date)  AS on_year,
    to_char(create_date_time,'MONTH')          AS on_month,
    COUNT(*)                                   AS value_of_vacancies
  FROM vacancies
  GROUP BY on_year,on_month
)
SELECT 
  on_year             AS year_of_max_value, 
  on_month            AS month_of_max_value, 
  value_of_vacancies  AS max_value
FROM tmp_table
-- из временной таблицы выбираем год и месяц, которые соответствуют максимальному значению 
WHERE tmp_table.value_of_vacancies = (SELECT MAX(value_of_vacancies) FROM tmp_table))
UNION
-- для таблицы с резюме поступаем точно также
(WITH yet_tmp_table AS (
  SELECT
    extract(YEAR from create_date_time::date)  AS on_year,
    to_char(create_date_time,'MONTH')          AS on_month,
    COUNT(*)                                   AS value_of_resumes
  FROM resumes
  GROUP BY on_year,on_month
)
SELECT
  on_year             AS year_of_max_value, 
  on_month            AS month_of_max_value, 
  value_of_resumes    AS max_value
FROM yet_tmp_table
WHERE yet_tmp_table.value_of_resumes = (SELECT MAX(value_of_resumes) FROM yet_tmp_table));