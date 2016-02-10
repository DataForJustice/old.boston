COPY (SELECT
	grid, ncode, d_year, d_month, count(*)	
FROM
	(SELECT 
		*,
		to_char (fromdate::timestamp, 'YYYY') as d_year, to_char (fromdate::timestamp, 'MM') as d_month, 
		(SELECT id FROM boston_grid grid ORDER BY grid.geom <-> point LIMIT 1) as grid
	FROM
		(
		SELECT 
			*, 
			trim (both ' ' from naturecode) as ncode,
			ST_FlipCoordinates (ST_SetSRID (ST_GeomFromText ('POINT' || replace(inc.location, ',', '')), 4326)) as point
		FROM 
			boston_police_incidents inc
		WHERE
			x <> y
			AND incident_type_description = 'DRUG CHARGES'
		) c
	WHERE
		c.ncode IN ('ARREST', 'IVDRUG', 'IVPREM', 'IVPER', 'INVEST', 'IVMV')
	) a	
GROUP BY
	grid, ncode, d_year, d_month
ORDER BY 
	d_year, d_month, grid 
) TO STDOUT CSV HEADER;
