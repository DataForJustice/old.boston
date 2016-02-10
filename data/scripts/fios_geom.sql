DROP TABLE IF EXISTS boston_fios_geom;
SELECT	
*
INTO
	boston_fios_geom
FROM 
	(SELECT 
		a.*,
		(SELECT gid FROM tiger.edges e ORDER BY a.geom <#> e.the_geom LIMIT 1) as street_segment, 
		(SELECT gid FROM public.boston_neighborhoods n WHERE ST_Contains (n.geom, a.geom) LIMIT 1) as neighborhood,
		(SELECT gid FROM public.boston_precincts p WHERE ST_Contains (p.geom, a.geom) LIMIT 1) as precinct, 
		(SELECT gid FROM public.ma_census_blockgroups b WHERE ST_Contains (b.geom, a.geom) LIMIT 1) as blockgroup
		FROM
			(SELECT * FROM boston_police_fio fio JOIN addys ad ON fio."LOCATION" = ad.original WHERE ad.rating < 100) as a
	) as x;
CREATE INDEX ON boston_fios_geom (street_segment);
CREATE INDEX ON boston_fios_geom (neighborhood);
CREATE INDEX ON boston_fios_geom (precinct);
CREATE INDEX ON boston_fios_geom (blockgroup);

