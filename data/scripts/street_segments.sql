SELECT
	row_to_json (collection)
FROM
	(
	SELECT
		'FeatureCollection' as type,
		array_to_json(array_agg (feature)) as features
	FROM
		(
		SELECT
			'Feature' as type,
			ST_AsGeoJson (ST_Centroid (self.the_geom))::json as geometry,
			(WITH data (gid, name) AS (VALUES (gid, fullname)) SELECT row_to_json (data) FROM data) as properties
		FROM
			(
			SELECT
				distinct st.gid, st.fullname, st.the_geom 
			FROM
				boston_fios_geom f JOIN tiger.edges st 
					ON f.street_segment = st.gid
				/*
				tiger.edges st JOIN boston_neighborhoods n
					ON ST_Intersects (n.geom, ST_SetSRID (st.the_geom, 4326))
				*/
			WHERE
				statefp = '25'
				AND countyfp = '025'
			) as self
		) as feature
	) as collection
