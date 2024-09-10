SELECT
nazev_potravina, rok, ctvrtleti, round(avg(prumerna_mzda_odvetvi)/cena_potravina) AS cena_pomer_mzda
FROM t_richard_kosina_project_sql_primary_final
WHERE nazev_potravina IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový') AND
rok+ctvrtleti IN (2007,2022)
GROUP BY nazev_potravina, rok;
