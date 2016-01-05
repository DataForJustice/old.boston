CREATE OR REPLACE FUNCTION population_in_polygon(
	IN polygon geometry,
	OUT white integer,
	OUT black integer,
	OUT poc integer,
	/*
	OUT h_white integer,
	OUT nh_white integer,
	OUT h_black integer,
	OUT nh_black integer,
	OUT h_other integer,
	OUT nh_other integer,
	*/
	OUT total integer
) AS $$
DECLARE
	record RECORD;
BEGIN
	white := 0;
	black := 0;
	poc := 0;
	total := 0;
	FOR record IN 
			SELECT 
				distinct gid,
				("P0020005") as nh_white, 
				("P0020006") as nh_black, 
				(("P0020007" + "P0020008" + "P0020009" + "P0020010" + "P0020011")) as nh_other, 
				(("P0010003" - "P0020005")) as h_white, 
				(("P0010004" - "P0020006")) as h_black, 
				((("P0010005" + "P0010006" + "P0010007" + "P0010008" + "P0010009") - ("P0020007" + "P0020008" + "P0020009" + "P0020010" + "P0020011"))) as h_other
			FROM  
				ma_census_blocks blocks
				LEFT JOIN "Blocks_P1" p1
					ON blocks.logpl94171 = p1."LOGRECNO"
				LEFT JOIN "Blocks_P2" p2
					ON blocks.logpl94171 = p2."LOGRECNO"
			WHERE
				ST_Contains (polygon, blocks.geom)
	LOOP
		white := white + record.nh_white;
		black := black + record.nh_black + record.h_black;
		poc := poc + record.h_white + record.h_other + record.nh_other;
		total := white + black + poc;

	END LOOP;
	

END $$ LANGUAGE plpgsql;

--SELECT * FROM population_in_polygon((SELECT ST_Union (geom) as boston FROM ma_census_blocks WHERE realtown = 'Boston')) a; 
