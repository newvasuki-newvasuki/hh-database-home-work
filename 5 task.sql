-- создаём вспомагательную таблицу с подсчётом откликов в первую неделю
WITH count_of_responses_in_first_week AS (
  SELECT 
    vacancy_id           AS  id_of_vacancy,  
	title                AS  title_of_vacancy,
    COUNT(responses.id)  AS  value_of_resposes 
  FROM vacancies
  INNER JOIN responses ON responses.vacancy_id = vacancies.id
  WHERE extract(DAY FROM (responses.response_date_time - vacancies.create_date_time)) <= 7
  GROUP BY id_of_vacancy, title_of_vacancy
)
-- и выбираем вакансии с откликами в первую неделю более 5
SELECT id_of_vacancy, title_of_vacancy, value_of_resposes
FROM count_of_responses_in_first_week
WHERE value_of_resposes >5;