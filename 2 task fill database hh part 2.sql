-- скрипт выполняется 2 минуты
DO $$
DECLARE
  number_of_employers                   int = 10000;
  number_of_vacancies                   int = 10000;
  number_of_resumes                     int = 100000 ;
  number_of_industries                  int = COUNT(*)FROM industries;
  number_of_specializations             int = COUNT(*)FROM specializations;
  number_of_areas                       int = COUNT(*)FROM areas;
  base_compensation                     int = 20000;  -- содержит минимальную оплату труда
  interval_of_compensation_from         int = 50000;  -- три интервала, в которых плавают зарплаты
  interval_of_compensation_to           int = 30000; 
  interval_of_compensation_desired      int = 70000; 
  hours_in_past                         int = 24000;  -- глубина в прошлое даты для вакансий и резюме
  eighteen_years_in_hours               int = 157000; -- 18 лет в часах
  work_life_in_hours                    int = 350000; -- рабочая жизнь в часах
  random_number_resumes_to_one_vacancy  int = 100;    -- интевал выбора количества откликов для вакансии
  random_value_of_resumes               int = 0;      -- вспомагательные переменные
  vacancy                               record;              
  resume                                record;
BEGIN

-- генерируем и вставляем случайные данные для работадателей
WITH tmp_random_table AS (
  SELECT 
    generate_series(1,number_of_employers)   AS tmp_id,
    1 + random()*(number_of_industries - 1)  AS tmp_industry_id,
    md5(random()::text)                      AS tmp_title,
    md5(random()::text)                      AS tmp_description,
	1 + random()*(number_of_areas - 1)       AS tmp_area_id
) 
INSERT INTO employers(
  id,
  industry_id,
  title,
  area_id,
  description
)
SELECT 
  tmp_id,
  tmp_industry_id,
  tmp_title,
  tmp_area_id,
  tmp_description
FROM tmp_random_table;

-- генерируем и вставляем случайные данные для вакансий
WITH tmp_random_table AS (
  SELECT 
    generate_series(1,number_of_vacancies)                   AS tmp_id,
    1 + random()*(number_of_employers - 1)                   AS tmp_employer_id,
    1 + random()*(number_of_specializations - 1)             AS tmp_specialization_id,	
    md5(random()::text)                                      AS tmp_title,
    1 + random()*(number_of_areas - 1)                       AS tmp_area_id,

	base_compensation + 
    round((random()*interval_of_compensation_from)::int,-4)  AS tmp_compensation_from,
    now() - 
	
	interval '1 hour' * (random()*hours_in_past)::int        AS tmp_create_date_time,
	md5(random()::text)                                      AS tmp_description,
    md5(random()::text)                                      AS tmp_contact_person_description
) 
INSERT INTO vacancies(
  id,
  employer_id,
  specialization_id,
  title,
  area_id,
  compensation_from,
  compensation_to,
  create_date_time,
  description,
  contact_person_description
)
SELECT 
  tmp_id,
  tmp_employer_id,
  tmp_specialization_id,
  tmp_title,
  tmp_area_id,
  tmp_compensation_from,
  tmp_compensation_from + 
  round((random()*interval_of_compensation_to)::int,-4),
  tmp_create_date_time,
  tmp_description,
  tmp_contact_person_description
FROM tmp_random_table;

-- генерируем и вставляем случайные данные для резюме
WITH tmp_random_table AS (
  SELECT 
    generate_series(1,number_of_resumes)                    AS tmp_id,
    1 + random()*(number_of_specializations - 1)            AS tmp_specializaton_id,	
    1 + random()*(number_of_specializations - 1)            AS tmp_area_id,
	
    base_compensation + round((random()*
    interval_of_compensation_desired)::int,-4)              AS tmp_desired_compensation,
    md5(random()::text)                                     AS tmp_description,
    md5(random()::text)                                     AS tmp_first_name,
    md5(random()::text)                                     AS tmp_second_name,
    md5(random()::text)                                     AS tmp_third_name,

    now() - interval '1 hour' * (eighteen_years_in_hours + 
    (random()*work_life_in_hours)::int)                     AS tmp_birth_date,
	
    now() - interval '1 hour' * 
    (random()*hours_in_past)::int                           AS tmp_create_date_time
) 
INSERT INTO resumes(
  id,
  specialization_id,
  area_id,
  desired_compensation,
  description,
  first_name,
  second_name,
  third_name,
  birth_date,
  create_date_time
)
SELECT 
  tmp_id,
  tmp_specializaton_id,	
  tmp_area_id,
  tmp_desired_compensation,
  tmp_description,
  tmp_first_name,
  tmp_second_name,
  tmp_third_name,
  tmp_birth_date,
  tmp_create_date_time
FROM tmp_random_table;

-- в цикле перебираем каждую вакансию и формируем для неё случаный набор
-- случайного количества откликов в диапазоне от 1 до 100
-- для более быстрого осуществления выборки случайного списка резюмме
-- создадим индекс в полю resumes.id
CREATE INDEX pk_resumes_id_index ON resumes(id);

FOR vacancy IN SELECT * FROM vacancies
  LOOP
    random_value_of_resumes = trunc(random()*random_number_resumes_to_one_vacancy)::int;
                  -- запрос на формирование случайного списка резюме
    FOR resume IN SELECT * FROM ( SELECT DISTINCT 1 + trunc(random() * (number_of_resumes - 1))::int AS id
                                  FROM generate_series (1,random_value_of_resumes)
								) AS generate_random_id
                  INNER JOIN resumes USING (id)
                  LIMIT random_value_of_resumes
    LOOP 
      INSERT INTO responses(response_date_time,vacancy_id,response_state,resume_id,description) VALUES(
        -- формируем случайную дату для отклика в диапазоне от сейчас до ближайшей даты создания
		CASE WHEN vacancy.create_date_time > resume.create_date_time 
             THEN vacancy.create_date_time + random()*(now() - vacancy.create_date_time)
             ELSE resume.create_date_time  + random()*(now() - resume.create_date_time)
        END,
        vacancy.id,
        -- случайно выбираем результат отклика: отказ или приглашение
		CASE WHEN trunc(random()*2)= 1 
		     THEN true
             ELSE false
        END,
        resume.id,
        md5(random()::text) 
      );
    END LOOP;
END LOOP;
END $$;



