COPY (SELECT
	grid, race, outcome, to_char (date, 'YYYY') as year, to_char (date, 'MM') as month, count (*)
FROM 
	(SELECT
		"OUTCOME" as outcome,
		"RACE_ID" as race,
		"FIO_DATE_CORRECTED"::timestamp as date,
		(SELECT id FROM boston_grid grid ORDER BY grid.geom <-> fios.geom LIMIT 1) as grid
	FROM
		boston_fios_geom fios
	WHERE
		rating < 25 
	) a
GROUP BY
	outcome, race, date, grid
) TO STDOUT CSV HEADER;
