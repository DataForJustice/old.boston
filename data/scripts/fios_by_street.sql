COPY (
	SELECT 
		street_segment as street, 
		"RACE_ID" as race,
		count (*)
	FROM
		boston_fios_geom
	GROUP BY 
		street, race
		
) TO STDOUT CSV HEADER;
