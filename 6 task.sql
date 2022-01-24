-- внутренняя обработка данных в базе как правило происходит по полю id
-- поэтому это поле должно всегда индексироваться, внешние же запросы к 
-- базе данных используют текстовые поля, несущие смысловую нагрузку,
-- поэтому их следует также проиндексировать для каждой таблицы.
-- Если же внешние запросы могут идти сразу по нескольким текстовым смысловым полям
-- для одной таблицы, то для совокупности полей также следует создать
-- индекс.
-- Буду считать, что совбодно места для базы данных достаточно, поэтому создам 
-- индексы для каждой таблицы

-- страны - индекс для первичного ключа
CREATE INDEX index_countries_id ON countries(id);
-- для поиска по текстовому полю для стран
CREATE INDEX index_countries_title ON countries(title);
-- области - индекс для первичного ключа
CREATE INDEX index_regions_id ON regions(id);
-- для поиска по текстовому полю для областей
CREATE INDEX index_regions_title ON regions(title);
-- города - индекс для первичного ключа
CREATE INDEX index_areas_id ON areas(id);
-- для поиска по текстовому полю для городов
CREATE INDEX index_areas_title ON areas(title);
-- отрасли - индекс для первичного ключа
CREATE INDEX index_industries_id ON industries(id);
-- для поиска по текстовому полю для отраслей
CREATE INDEX index_industries_title ON industries(title);
-- специализации - индекс для первичного ключа
CREATE INDEX index_specializations_id ON specializations(id);
-- для поиска по текстовому полю для специализаций
CREATE INDEX index_specializations_title ON specializations(title);

-- вакансий - индекс для первичного ключа
CREATE INDEX index_vacancies_id ON vacancies(id);
-- для поиска по текстовому полю для вакансий
CREATE INDEX index_vacancies_title ON vacancies(title);
-- для поиска по дате создания для вакансий
CREATE INDEX index_vacancies_date ON vacancies(create_date_time);

-- работадателей - индекс для первичного ключа
CREATE INDEX index_employers_id ON employers(id);
-- для поиска по текстовому полю для работадателей
CREATE INDEX index_employers_title ON employers(title);

-- резюме - индекс для первичного ключа
-- CREATE INDEX index_resumes_id ON resumes(id);     --был создан при заполнении
-- для поиска по дате создания для резюме
CREATE INDEX index_resumes_date ON resumes(create_date_time);

-- откликов на вакансии - индекс для первичного ключа
CREATE INDEX index_responses_id ON responses(id);
-- для поиска по дате отклика для откликов на вакансии
CREATE INDEX index_responses_date ON responses(response_date_time);






















