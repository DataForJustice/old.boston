export PGBIN=/usr/local/bin/
export PGPORT=5432
export PGHOST=localhost
export PGUSER=paw
export PGPASSWORD=""
export PGDATABASE=aclum
export TMPDIR=/tmp/
WGET = wget
GIT = git
BOWER = ./bowerphp
BOWER_URL = http://bowerphp.org/bowerphp.phar
ABSP = $(shell dirname .) 
WEB_DIR = web
HTDOCS_DIR = htdocs
DOCUMENT_ROOT = $(WEB_DIR)/$(HTDOCS_DIR)
PSQL=$(PGBIN)psql -q -t
repo_update:
	$(GIT) pull origin master
	$(GIT) submodule update --init --recursive .
	$(GIT) submodule foreach --recursive git pull origin master
	$(GIT) submodule update --recursive
links: rm_links 
	ln -s ../../repos/Core/PAWS-mvc/htdocs/index.php $(DOCUMENT_ROOT) 
	ln -s ../repos/Core/PAWS-mvc/config.php $(WEB_DIR)/
	ln -s ../../repos/Core/PAWS-mvc/libs/smarty/ $(WEB_DIR)/libs/
	ln -s ../repos/Core/PAWS-mvc/outputs $(WEB_DIR)/ 
	ln -s ../../../bower_components/jquery/dist/jquery.min.js $(DOCUMENT_ROOT)/js/
	ln -s ../../../bower_components/queue-async/queue.min.js $(DOCUMENT_ROOT)/js/
	ln -s ../../../bower_components/d3/d3.min.js $(DOCUMENT_ROOT)/js/ 
	ln -s ../../../bower_components/topojson/topojson.js $(DOCUMENT_ROOT)/js/ 
	ln -s ../../../bower_components/scrollmagic/scrollmagic/minified/ScrollMagic.min.js $(DOCUMENT_ROOT)/js/
	ln -s ../../../bower_components/scrollmagic/scrollmagic/minified/plugins/debug.addIndicators.min.js $(DOCUMENT_ROOT)/js/
	ln -s ../../../bower_components/scrollmagic/scrollmagic/minified/plugins/animation.gsap.min.js $(DOCUMENT_ROOT)/js/
	ln -s ../../../bower_components/gsap/src/minified/TweenMax.min.js $(DOCUMENT_ROOT)/js/
	ln -s ../../../bower_components/bootstrap/dist/js/bootstrap.min.js $(DOCUMENT_ROOT)/js/
	ln -s ../../../bower_components/bootstrap/dist/css/bootstrap.min.css $(DOCUMENT_ROOT)/css/
	ln -s ../../../bower_components/popcorn-complete/popcorn-complete.min.js $(DOCUMENT_ROOT)/js/ 

rm_links: 
	find . -type l | xargs rm -rf 
bower_init: 
	$(WGET) $(BOWER_URL)
	mv bowerphp.phar $(BOWER) 
	chmod +x $(BOWER)
	$(BOWER) install jquery
	$(BOWER) install d3
	$(BOWER) install queue-async 
	$(BOWER) install scrollmagic
	$(BOWER) install topojson
	$(BOWER) install gsap
	$(BOWER) install bootstrap
	$(BOWER) install popcorn-complete
bower_update:
	find . -name bower.json -exec dirname {} \; | xargs -I {} $(BOWER) -d={} update
#DATA INIT
data_dir: 
	if [ ! -d "web/libs" ]; then  mkdir web/libs; fi
	if [ ! -d "data/" ]; then  mkdir data; fi
	if [ ! -d "data/process/" ]; then mkdir data/process; fi
	if [ ! -d "data/raw" ]; then  mkdir data/raw; fi
	if [ ! -d "data/raw/ma_counties" ]; then  mkdir data/raw/ma_counties; fi
	if [ ! -d "data/raw/ma_census" ]; then  mkdir data/raw/ma_census; fi
	if [ ! -d "data/raw/boston_boundary" ]; then  mkdir data/raw/boston_boundary; fi
	if [ ! -d "data/raw/boston_osm" ]; then  mkdir data/raw/boston_osm; fi
	if [ ! -d "data/raw/boston_neighborhoods" ]; then  mkdir data/raw/boston_neighborhoods; fi
	if [ ! -d "data/raw/pl94-171" ]; then  mkdir data/raw/pl94-171; fi
	if [ ! -d "data/raw/zipcodes" ]; then  mkdir data/raw/zipcodes; fi
	if [ ! -d "data/raw/incidents" ]; then  mkdir data/raw/incidents; fi
	if [ ! -d "data/raw/fios" ]; then  mkdir data/raw/fios; fi
	if [ ! -d "web/htdocs/data/" ]; then  mkdir web/htdocs/data; fi
data_init_ma_counties: data_dir
	$(WGET) http://wsgw.mass.gov/data/gispub/shape/state/counties.zip -O data/raw/ma_counties.zip
	unzip data/raw/ma_counties.zip -d data/raw/ma_counties
data_init_ma_census: data_dir
	$(WGET) http://wsgw.mass.gov/data/gispub/shape/census2010/CENSUS2010_BLK_BG_TRCT_SHP.zip -O data/raw/ma_census.zip
	unzip data/raw/ma_census.zip -d data/raw/ma_census
data_init_ma_pl94171: data_dir
	$(WGET) http://wsgw.mass.gov/data/gispub/shape/census2010/PL_94-171_TABLES_MDB.zip -O data/raw/pl94-171.zip
	unzip data/raw/pl94-171.zip -d data/raw/pl94-171
data_init_boston_osm: data_dir
	$(WGET) https://s3.amazonaws.com/metro-extracts.mapzen.com/boston_massachusetts.imposm-shapefiles.zip -O data/raw/boston_osm.zip
	unzip data/raw/boston_osm.zip -d data/raw/boston_osm
data_init_boston_neighborhoods: data_dir
	$(WGET) "https://data.cityofboston.gov/api/geospatial/mcme-sgsz?method=export&format=Shapefile" -O data/raw/boston_neighborhoods.zip
	unzip data/raw/boston_neighborhoods.zip -d data/raw/boston_neighborhoods 
		
data_init_us_zipcodes: data_dir
	$(WGET) http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_zcta510_500k.zip -O data/raw/zipcodes.zip
	unzip data/raw/zipcodes.zip -d data/raw/zipcodes 
data_init_incidents: data_dir
	$(WGET) https://data.cityofboston.gov/api/views/7cdf-6fgx/rows.csv?accessType=DOWNLOAD -O data/raw/incidents/incidents.csv 
data_init_fios: data_dir
	$(WGET) https://data.cityofboston.gov/api/views/xmmk-i78r/rows.csv?accessType=DOWNLOAD -O data/raw/fios/fios.csv
#DATA PROCESSING
data_process_ma_census: 
	ogr2ogr -s_srs EPSG:26986 -t_srs EPSG:4326 data/process/ma_blocks.shp data/raw/ma_census/CENSUS2010BLOCKS_POLY.shp
	shp2pgsql -I -s 4326 -d data/process/ma_blocks.shp ma_census_blocks | $(PSQL)
	ogr2ogr -s_srs EPSG:26986 -t_srs EPSG:4326 data/process/ma_blockgroups.shp data/raw/ma_census/CENSUS2010BLOCKGROUPS_POLY.shp
	shp2pgsql -I -s 4326 -d data/process/ma_blockgroups.shp ma_census_blockgroups | $(PSQL) 
data_process_ma_counties:
	ogr2ogr -s_srs EPSG:26986 -t_srs EPSG:4326 data/process/ma_counties.shp data/raw/ma_counties/COUNTIES_POLYM.shp
	shp2pgsql -I -s 4326 -d data/process/ma_counties.shp public.ma_counties | $(PSQL)
data_process_ma_pl94171:
	data/scripts/access2pgsql.sh data/raw/pl94-171/PL94-171_tables_blocks.mdb data/process/pl94-171.blocks.schema.sql data/process/pl94-171.blocks.foreignkeys.sql data/process/pl94-171.blocks.data.sql 
	data/scripts/access2pgsql.sh data/raw/pl94-171/PL94-171_tables_blkgrps.mdb data/process/pl94-171.blkgrps.schema.sql data/process/pl94-171.blkgrps.foreignkeys.sql data/process/pl94-171.blkgrps.data.sql 
	$(PSQL) -f data/process/pl94-171.blocks.schema.sql
	$(PSQL) -f data/process/pl94-171.blocks.foreignkeys.sql
	$(PSQL) -f data/process/pl94-171.blocks.data.sql
	$(PSQL) -f data/process/pl94-171.blkgrps.schema.sql
	$(PSQL) -f data/process/pl94-171.blkgrps.foreignkeys.sql
	$(PSQL) -f data/process/pl94-171.blkgrps.data.sql
data_process_boston_osm: 
	shp2pgsql -I -s 4326 -d data/raw/boston_osm/boston_massachusetts_osm_roads.shp public.boston_roads | $(PSQL)	
data_process_boston_neighborhoods:
	for i in `ls data/raw/boston_neighborhoods/*.shp`; do shp2pgsql -I -s 4326 -d $$i boston_neighborhoods | $(PSQL); done; 
data_process_us_zipcodes:
	ogr2ogr -s_srs EPSG:4269 -t_srs EPSG:4326 data/process/zipcodes.shp data/raw/zipcodes/cb_2014_us_zcta510_500k.shp
	shp2pgsql -I -s 4326 -d data/process/zipcodes.shp us_zipcodes | $(PSQL)
clean_shapefiles:
	rm -rf data/process/*.shp

#downloads data and creates stored procedures, views and functions.
data_real_init: data_dir data_init_ma_counties data_init_ma_census data_init_ma_pl94171 data_init_boston_osm data_init_boston_neighborhoods data_init_us_zipcodes data_init 
data_init:
	$(PSQL) -c "CREATE EXTENSION IF NOT EXISTS postgis;"
	$(PSQL) -c "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;"
	$(PSQL) -c "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;"
	$(PSQL) -f data/scripts/population_in_polygon.sql
	$(PSQL) -c "SELECT loader_generate_nation_script('sh')" | sed 's/.$$//' | sed '/^$$/d' | sed -e's/[[:space:]]*$$//' | sed -e 's/\/gisdata/\$$\{TMPDIR\}/g' | sed '/.export/d' | sed '/.TMPDIR/d' | sed 's/^ *//;s/$$//' > data/scripts/tiger_nation.sh
	$(PSQL) -c "SELECT loader_generate_script(ARRAY['MA'], 'sh') AS result" | sed 's/.$$//' | sed '/^$$/d' | sed -e's/[[:space:]]*$$//' | sed -e 's/\/gisdata/\$$\{TMPDIR\}/g' | sed '/.export/d' | sed '/.TMPDIR/d' | sed 's/^ *//;s/$$//' > data/scripts/tiger_ma.sh 
	sh data/scripts/tiger_nation.sh
	sh data/scripts/tiger_ma.sh

#process data
data_insert: clean_shapefiles data_process_ma_counties data_process_ma_census data_process_ma_pl94171 data_process_boston_osm data_process_us_zipcodes
data_process:
	$(PSQL) -f data/scripts/blockgroups.sql | topojson -q 1e4 -p -o web/htdocs/data/boston_blockgroups.json
	$(PSQL) -f data/scripts/blockgroups_boundaries.sql | topojson -q 1e4 -p -o web/htdocs/data/boston_blockgroups_boundaries.json
	$(PSQL) -f data/scripts/counties.sql | topojson -q 1e4 -p -o web/htdocs/data/ma_counties.json
	$(PSQL) -f data/scripts/incidents.sql > web/htdocs/data/incidents.csv
	$(PSQL) -f data/scripts/fios_geom.sql 
	$(PSQL) -f data/scripts/street_segments.sql | topojson -q 1e4 -o web/htdocs/data/streets.json
	$(PSQL) -f data/scripts/grid.sql | topojson -q 1e4 -p -o web/htdocs/data/boston_grid.json
	$(PSQL) -f data/scripts/fios_grid.sql > web/htdocs/data/fios_grid.csv
data: data_real_init data_init data_insert data_process
update: repo_update bower_update links
install: bower_init update 
