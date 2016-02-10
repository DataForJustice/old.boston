COPY (
	SELECT 
		n.name, 
		"RACE_ID" as race,
		seizures,
		count
	FROM (
		SELECT 
			distinct neighborhood, 
			"RACE_ID",
			count (*) as count, 
			(SELECT 
				count (*) 
			FROM 
				boston_fios_geom b 
			WHERE 
				b.neighborhood = f.neighborhood 
				AND b."RACE_ID" = f."RACE_ID"
				AND b."OUTCOME" IN ('S', 'SO', 'SF', 'SFO') 
			) as seizures 
		FROM 
			boston_fios_geom f 
		GROUP BY 
			f.neighborhood,
			f."RACE_ID"
		ORDER BY 
			f.neighborhood
	) as a JOIN boston_neighborhoods n ON a.neighborhood = n.gid
) TO STDOUT CSV HEADER
