WITH x as (
	SELECT 
		geocode (f."LOCATION" || ', Boston, MA, USA', 1) as x,
		"LOCATION" as orig
	FROM
		"FIO_2011_thru_April2015" as f
	LIMIT 10

) SELECT * FROM x;
