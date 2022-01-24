DROP TABLE IF EXISTS work_places;
DROP TABLE IF EXISTS responses;
DROP TABLE IF EXISTS resumes;
DROP TABLE IF EXISTS vacancies;
DROP TABLE IF EXISTS specializations;
DROP TABLE IF EXISTS specialization_groups;
DROP TABLE IF EXISTS employers;
DROP TABLE IF EXISTS industries;
DROP TABLE IF EXISTS industry_groups;
DROP TABLE IF EXISTS areas;
DROP TABLE IF EXISTS regions;
DROP TABLE IF EXISTS countries;

-- страны 
CREATE TABLE countries(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  title                       CHARACTER VARYING(128)  NOT NULL
);

-- области
CREATE TABLE regions(
  id                          INTEGER                 NOT NULL  PRIMARY KEY,
  country_id                  INTEGER                 NOT NULL  REFERENCES  countries(id),
  title                       CHARACTER VARYING(128)  NOT NULL
);

-- города
CREATE TABLE areas(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  region_id                     INTEGER               NOT NULL  REFERENCES  regions(id),
  title                       CHARACTER VARYING(128)  NOT NULL
);

-- группы отраслей - взяты с hh.ru
CREATE TABLE industry_groups(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  title                       CHARACTER VARYING(128)  NOT NULL
);

-- группы специальностей - взяты с hh.ru
CREATE TABLE specialization_groups(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  title                       CHARACTER VARYING(128)  NOT NULL
); 

-- сами отрасли
CREATE TABLE industries(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  title                       CHARACTER VARYING(256)  NOT NULL,	
  industry_group_id           INTEGER                 NOT NULL  REFERENCES  industry_groups(id)
);

-- работадатели
CREATE TABLE employers(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  title	                      CHARACTER VARYING(128)  NOT NULL,	
  industry_id                 INTEGER                 NOT NULL  REFERENCES  industries(id),
  area_id			          INTEGER                 NOT NULL  REFERENCES  areas(id),
  description                 TEXT                    NOT NULL
);

-- сами специальности
CREATE TABLE specializations(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  title                       CHARACTER VARYING(128)  NOT NULL,	
  specialization_group_id     INTEGER                 NOT NULL  REFERENCES  specialization_groups(id)
);

CREATE TABLE vacancies(
  id				          SERIAL	              NOT NULL  PRIMARY KEY	,
  title					      CHARACTER VARYING(128)  NOT NULL,	
  employer_id				  INTEGER	              NOT NULL  REFERENCES  employers(id),
  specialization_id		      INTEGER                 NOT NULL  REFERENCES  specializations(id),
  area_id					  INTEGER                 NOT NULL  REFERENCES  areas(id),
  compensation_from		      MONEY,
  compensation_to			  MONEY,
  create_date_time            TIMESTAMP               NOT NULL,
  description                 TEXT                    NOT NULL,
  contact_person_description  TEXT                    -- инфорамация о контактном лице
);

CREATE TABLE resumes(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  specialization_id           INTEGER                 NOT NULL  REFERENCES  specializations(id),
  area_id                     INTEGER                 NOT NULL  REFERENCES  areas(id),
  desired_compensation        MONEY,                  -- ожидаемое вознаграждение
  description                 TEXT,
  first_name                  CHARACTER VARYING(128)  NOT NULL,
  second_name                 CHARACTER VARYING(128)  NOT NULL,
  third_name                  CHARACTER VARYING(128),
  birth_date                  DATE,
  create_date_time            TIMESTAMP               NOT NULL
);

-- предыдущие места работы
CREATE TABLE work_places(
  id	                      SERIAL                  NOT NULL  PRIMARY KEY,
  resume_id	                  INTEGER                 NOT NULL  REFERENCES  resumes(id),
  title                       CHARACTER VARYING(128)  NOT NULL,
  employer_title              CHARACTER VARYING(128)  NOT NULL,
  area_id				      INTEGER                 NOT NULL  REFERENCES  areas(id),
  start_date                  DATE                    NOT NULL,
  end_date                    DATE,
  description                 TEXT
);

CREATE TABLE responses(
  id                          SERIAL                  NOT NULL  PRIMARY KEY,
  vacancy_id                  INTEGER                 NOT NULL  REFERENCES  vacancies(id),
  resume_id                   INTEGER                 NOT NULL  REFERENCES  resumes(id),	
  response_state              BOOL                    NOT NULL,	-- получен отказ или приглашение
  response_date_time          TIMESTAMP               NOT NULL,
  description                 TEXT                    -- описание дальнейших действий                 
);
