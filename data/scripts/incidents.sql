COPY (
	SELECT 
		nb.name as neighborhood,
		upper (trim (both ' ' from ucrpart)) as ucr, 
		upper (trim (both ' ' from naturecode)) as ncode, 
		upper (trim (both ' ' from incident_type_description)) as description, 
		year,
		count (*) as cnt 
	FROM 
		boston_police_incidents inc 
			JOIN boston_neighborhoods nb ON ST_Contains (nb.geom, inc.geom)
	GROUP BY 
		neighborhood, ucr, ncode, description, year 
) TO STDOUT DELIMITER ',' CSV HEADER
