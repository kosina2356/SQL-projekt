CREATE OR REPLACE VIEW ceny AS
	SELECT
	cpc.name AS nazev_potravina, 
	round(avg(cp.value)) AS cena_potravina, 
	cpc.price_value AS mnozstvi,
	cpc.price_unit AS jednotka,
	quarter(cp.date_from) AS ctvrtleti_cena, 
	year(cp.date_from) AS rok_cena
	FROM czechia_price cp 
	JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code
	GROUP BY cpc.name, year(cp.date_from), quarter(cp.date_from);

CREATE OR REPLACE VIEW platy AS
	SELECT 
	cp2.industry_branch_code AS kod_odvetvi, 
	cpib.name AS nazev_odvetvi, 
	cp2.payroll_year AS rok_plat, 
	cp2.payroll_quarter AS ctvrtleti_plat, 
	cp2.value AS prumerna_mzda_odvetvi, 
	round(e.GDP) AS HDP, 
	round(e.GDP/e.population) AS HDP_obyvatel, 
	e.population AS populace
	FROM czechia_payroll cp2 
	JOIN czechia_payroll_industry_branch cpib 
		ON cp2.industry_branch_code = cpib.code
	JOIN economies e 
		ON cp2.payroll_year = e.`year` 
	WHERE cp2.value_type_code = 5958 
		AND cp2.calculation_code = 200
		AND cp2.payroll_year > 2005
		AND cp2.payroll_year < 2019
		AND e.country = 'Czech Republic'
	GROUP BY cp2.industry_branch_code, cp2.payroll_year, cp2.payroll_quarter;


CREATE TABLE t_richard_kosina_project_SQL_primary_final AS
	SELECT 
	ceny.nazev_potravina, 
	ceny.cena_potravina, 
	ceny.mnozstvi,
	ceny.jednotka,
	ceny.rok_cena AS rok, 
	ceny.ctvrtleti_cena AS ctvrtleti,
	platy.kod_odvetvi, 
	platy.nazev_odvetvi, 
	platy.prumerna_mzda_odvetvi,
	platy.HDP,
	platy.HDP_obyvatel,
	platy.populace
	FROM ceny
	JOIN platy
		ON ceny.rok_cena = platy.rok_plat 
		AND ceny.ctvrtleti_cena = platy.ctvrtleti_plat
	GROUP BY ceny.rok_cena, ceny.ctvrtleti_cena, ceny.nazev_potravina, platy.kod_odvetvi;