COPY (
	SELECT 
		nb.name as neighborhood,
		date_part ('year', "FIO_DATE_CORRECTED"::timestamp) as year, 
		"RACE_ID" as race,
		count (*) 
	FROM 
		boston_police_fio fio 
			JOIN addys ad 
				ON fio."LOCATION" = ad.original
			JOIN boston_neighborhoods nb ON ST_Contains (nb.geom, ad.geom)
	GROUP BY 
		neighborhood, year, race
) TO STDOUT DELIMITER ',' CSV HEADER
