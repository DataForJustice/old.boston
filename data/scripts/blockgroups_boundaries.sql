SELECT
	row_to_json (collection)
FROM
	(SELECT
		'FeatureCollection' as type,
		array_to_json (array_agg (feature)) as features
	FROM
		(SELECT 
			'Feature' as type,
			ST_AsGeoJson (geom)::json as geometry,
			(WITH data 
				(a_gid, b_gid, a_nh_white, b_nh_white, a_h_white, b_h_white, a_nh_black, b_nh_black, a_h_black, b_h_black, a_nh_other, b_nh_other, a_h_other, b_h_other)
				AS (VALUES (a_gid, b_gid, a_nh_white, b_nh_white, a_h_white, b_h_white, a_nh_black, b_nh_black, a_h_black, b_h_black, a_nh_other, b_nh_other, a_h_other, b_h_other))
				SELECT row_to_json (data) FROM data
			) as properties

		FROM
			(WITH x AS 
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
				)
			SELECT 
				a.gid as a_gid, a.nh_white as a_nh_white, a.h_white as a_h_white, a.nh_black as a_nh_black, a.h_black as a_h_black, a.nh_other as a_nh_other, a.h_other as a_h_other,
				b.gid as b_gid, b.nh_white as b_nh_white, b.h_white as b_h_white, b.nh_black as b_nh_black, b.h_black as b_h_black, b.nh_other as b_nh_other, b.h_other as b_h_other,
				ST_LineMerge (ST_Intersection (a.geom, b.geom)) as geom
			FROM 
				x as a 
				JOIN x as b 
					ON ST_Touches (a.geom, b.geom)
			) as self 

		) as feature
	) as collection
