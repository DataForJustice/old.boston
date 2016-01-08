SELECT 
	row_to_json (collection)
FROM
	(SELECT
		'FeatureCollection' as type,
		array_to_json (array_agg (feature)) as features
	FROM
		(SELECT
			'Feature' as type,
			ST_AsGeoJson (a.geom)::json as geometry,
			(WITH data (name, id) AS (VALUES (a.county, a.fips_id)) SELECT row_to_json (data) FROM data) as properties
		FROM
			(SELECT
				county, fips_id, geom
			FROM 
				ma_counties
			) as a
		) as feature
	) as collection
