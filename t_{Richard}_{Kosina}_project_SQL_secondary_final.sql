SELECT
e.country, e.`year`, round(e.GDP) AS GDP, e.gini, e.population, round(round(e.GDP)/e.population) AS GDP_per_person
FROM economies e 
LEFT JOIN countries c 
	ON e.country = c.country
WHERE c.continent = 'Europe' AND e.`year` > 2016 AND c.capital_city != 'Praha';