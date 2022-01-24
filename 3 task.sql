SELECT 
  round(AVG(compensation_from::numeric::int))    AS avarage_from, 
  round(AVG(compensation_to::numeric::int))      AS avarage_to,
  round(AVG((compensation_from::numeric::int + 
             compensation_to::numeric::int)/2))  AS avarage,
  areas.title                                    AS city
FROM vacancies
INNER JOIN areas ON vacancies.area_id = areas.id
GROUP BY areas.title;