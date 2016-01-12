COPY 
(SELECT 
	gid, ucr, ncode, description, incidents,
	round (avg, 2) as avg, max, min, round (stddev_pop, 2) as stddev_pop, round (stddev, 2) as stddev, 
	round ((incidents - avg) / stddev_pop, 2)  as rank_pop, round ((incidents - avg) / stddev, 2)  as rank 
FROM
	(WITH x AS (
		SELECT 
			gid, 
			-- INSERT DEMOGRAPHIC DATA (white, black, poc) HERE SO WE CAN SEE IF THE RANK RELATES TO RACE AND SOME CRIME TYPES
			upper (trim (both ' ' from ucrpart)) as ucr, 
			upper (trim (both ' ' from naturecode)) as ncode, 
			upper (trim (both ' ' from incident_type_description)) as description, 
			a.geom,
			count (*) as cnt 
		FROM 
			boston_police_incidents b 
			JOIN ma_census_blockgroups a 
				ON ST_Contains (a.geom, b.geom)
		WHERE 
			naturecode IN (
				SELECT 
					ncode
				FROM
					(
					WITH d AS (
						SELECT 
							upper (trim (both ' ' from naturecode)) as ncode, count (*) as count
						FROM
							boston_police_incidents
						GROUP BY
							ncode
						ORDER BY 
							count DESC
					) SELECT 
						a.ncode,
						(a.count - avg (b.count)) / stddev_pop (b.count) as rank
					FROM 
						d as a,
						d as b
					GROUP BY 
						a.ncode, a.count
					) as x
				WHERE
					rank > 1
				ORDER BY
					rank DESC
			) 
		GROUP BY 
			gid, ncode, description, ucr, a.geom
		ORDER BY 
			gid, ncode, description, ucr, cnt DESC
	) SELECT 
		a.gid, a.ucr, a.ncode, a.description, a.cnt as incidents, 
		avg (b.cnt) as avg, min (b.cnt) as min, max (b.cnt) as max, stddev_pop (b.cnt) as stddev_pop, stddev (b.cnt) as stddev
	FROM
		x as a 
		JOIN x as b
			ON ST_Touches (a.geom, b.geom)
				AND a.ncode = b.ncode 
	WHERE
		b.cnt > 0
	GROUP BY
		a.gid, a.ncode, a.description, a.ucr, a.cnt
	) as a
WHERE
	stddev_pop > 0
ORDER BY
	rank DESC
) TO STDOUT DELIMITER ',' CSV HEADER
