SELECT
	row_to_json (collection)
	
FROM
	(
	SELECT
		'FeatureCollection' as type,
		array_to_json (array_agg (feature)) as features
	FROM
		(
		SELECT
			'Feature' as type,
			ST_AsGeoJson (self.geom)::json as geometry,
			(WITH data (name) AS (VALUES (name)) SELECT row_to_json (data) FROM data) as properties
		FROM
			(
			SELECT 
				*
			FROM
				boston_neighborhoods
			) as self
		) as feature
	) as collection
