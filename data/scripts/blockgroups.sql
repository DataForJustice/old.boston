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
			(WITH DATA (gid, white, black, poc) AS ( VALUES (gid, nh_white, nh_black + h_black, h_white + nh_other + h_other)) SELECT row_to_json (data) FROM data) as properties
		FROM

			(SELECT 
				distinct 
				blockgroups.gid,
				("P0020005") as nh_white, 
				("P0020006") as nh_black, 
				(("P0020007" + "P0020008" + "P0020009" + "P0020010" + "P0020011")) as nh_other, 
				(("P0010003" - "P0020005")) as h_white, 
				(("P0010004" - "P0020006")) as h_black, 
				((("P0010005" + "P0010006" + "P0010007" + "P0010008" + "P0010009") - ("P0020007" + "P0020008" + "P0020009" + "P0020010" + "P0020011"))) as h_other,
				blockgroups.geom as geom
			FROM  
				ma_census_blockgroups blockgroups 
				JOIN ma_census_blocks blocks -- we only join this to get the 'realtown = Boston' match
					ON blocks.tractce10 = blockgroups.tractce10 
				JOIN "Blkgrps_P1" p1
					ON blockgroups.logpl94171 = p1."LOGRECNO"
				JOIN "Blkgrps_P2" p2
					ON blockgroups.logpl94171 = p2."LOGRECNO"
			WHERE
				blocks.realtown = 'Boston'
			) as self
		) as feature
	) as collection
