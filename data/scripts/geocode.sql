/*WITH geocoded AS 
	(SELECT addys.original, geo.* FROM addys, geocode (original || ', Boston MA', 1) as geo WHERE addys.rating IS NULL) 
UPDATE addys SET addy = geocoded.addy, geom = ST_SetSRID (geocoded.geomout, 4326), rating = geocoded.rating FROM geocoded WHERE addys.original = geocoded.original ;
*/
\set ON_ERROR_ROLLBACK
DO
$$
DECLARE
	m RECORD;
	i RECORD;
	k RECORD;
BEGIN
	FOR m IN	
		(SELECT
			x.*,
			(addy).*
			--(geocode_intersection (a::text, b::text, 'MA', 'Boston', (addy).zip, 1)).*
		FROM
			(
			SELECT 
				addys.original, 
				(addys.addy) as addy,
				addys.rating,
				trim (both ' ' from regexp_replace (regexp_replace (regexp_replace (regexp_replace (replace (expl [1], ' AV', ' AVE'), '\#\w+', ''), 'N\/A', ''), '\-', ''), '^[0-9]+', '')) as a, 
				trim (both ' ' from regexp_replace (regexp_replace (regexp_replace (regexp_replace (replace (expl [2], ' AV', ' AVE'), '\#\w+', ''), 'N\/A', ''), '\-', ''), '^[0-9]+', '')) as b 
			FROM 
				addys,
				regexp_split_to_array (upper (addys.original), ' AT ') as expl
			WHERE
				addys.original ILIKE '% AT %'
				AND (addys.addy).zip is not null AND addys.rating > 21 
			) as x
		ORDER BY random()
		--ORDER BY rating  
		LIMIT 100
		)
	LOOP
		RAISE NOTICE 'ORIGINAL: %', m;
		FOR i IN
			(SELECT * FROM geocode_intersection (m.a, m.b, 'MA', 'Boston') as ad ORDER BY rating LIMIT 1)
		LOOP
			RAISE NOTICE '%, %', m.original, i;

			UPDATE 
				addys 
			SET 
				addy = i.addy, 
				geom = ST_SetSRID (i.geomout, 4326), 
				rating = i.rating 

			WHERE 
				addys.original = m.original
			RETURNING * INTO k;
			RAISE NOTICE '%', k;
		END LOOP;
	END LOOP;
END;
$$
