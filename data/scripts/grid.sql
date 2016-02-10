DROP TABLE IF EXISTS boston_grid;
CREATE TABLE boston_grid AS 
(SELECT	
	row_number () OVER () as id,
	geom
FROM
	(SELECT 
		distinct ST_SnapToGrid (geom, 0.0015) as geom 
	FROM 
		boston_fios_geom 
	) as a 
); 
SELECT 
	row_to_json (collection)
FROM
	(SELECT
		'FeatureCollection' as type,
		array_to_json (array_agg (feature)) as features
	FROM
		(SELECT 
			'Feature' as type,
			ST_AsGeoJson (self.geom)::json as geometry,
			(WITH data (id) AS (VALUES (id)) SELECT row_to_json (data) FROM data) as properties
		FROM
			(SELECT 
				id,
				geom
			FROM
				boston_grid
			) as self
		) as feature
	) as collection
