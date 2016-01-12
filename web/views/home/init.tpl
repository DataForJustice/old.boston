<div id="a_container" style="width: 80% !important; position: fixed !important; top: 0; left: 0; height: 100%; z-index: 90;" class="large-6 columns">
	<div id="map" style="100%; position: relative;"></div>
</div>
<div class="text_container" style="width: 50% !important; position: fixed !important; top: 2%; left: 5%; z-index: 95;">
			<h1 class="section_name"></h1>
</div>
<!--
<div id="footnotes" class="text_container" style="width: 35% !important; position: fixed !important; top: 70%; left: 15%; z-index: 95; height: 100%;">
	<div data-section="intro"></div>
	<div data-section="racial"></div>
	<div data-section="whiteness" class="blockgroups_whitest"></div>
	<div data-section="blackness" class="blockgroups_blackest"></div>
	<div data-section="poc"></div>
	<div data-section="boundaries_white"></div>
	<div data-section="drugs"></div>
	<div data-section="vandalism"></div>
	<div data-section="invper"></div>
</div>
-->
<div id="ctrls" style="width: 10% !important; height: 20%; position: fixed !important; top: 10%; left: 2%; z-index: 99;">
	<select data-control>
		<option value="">- select neighborhood-</option>
		<option data-control="" data-zoom_to="counties_25025" data-zoom_level="110">All Boston</option>
		<option data-control="" data-zoom_to="neighborhoods_roxbury" data-zoom_level="70">Roxbury</option>
		<option data-control data-zoom_to="neighborhoods_east_boston" data-zoom_level="70">East Boston</option>
		<option data-control data-zoom_to="neighborhoods_charlestown" data-zoom_level="70">Charlestown</option>
		<option data-control data-zoom_to="neighborhoods_fenway_kenmore" data-zoom_level="70">Fenway/Kenmore</option>
		<option data-control data-zoom_to="neighborhoods_roxbury" data-zoom_level="70">Roxbury</option>
		<option data-control data-zoom_to="neighborhoods_dorchester" data-zoom_level="70">Dorchester</option>
		<option data-control data-zoom_to="neighborhoods_south_boston" data-zoom_level="70">South Boston</option>
		<option data-control data-zoom_to="neighborhoods_south_end" data-zoom_level="70">South End</option>
		<option data-control data-zoom_to="neighborhoods_bay_village" data-zoom_level="70">Bay Village</option>
		<option data-control data-zoom_to="neighborhoods_allston_brighton" data-zoom_level="70">Allston/Brighton</option>
		<option data-control data-zoom_to="neighborhoods_jamaica_plain" data-zoom_level="70">Jamaica Plain</option>
		<option data-control data-zoom_to="neighborhoods_mattapan" data-zoom_level="70">Mattapan</option>
		<option data-control data-zoom_to="neighborhoods_roslindale" data-zoom_level="70">Roslindale</option>
		<option data-control data-zoom_to="neighborhoods_west_roxbury" data-zoom_level="70">West Roxbury</option>
		<option data-control data-zoom_to="neighborhoods_back_bay" data-zoom_level="70">Back Bay</option>
		<option data-control data-zoom_to="neighborhoods_financial_district_downtown" data-zoom_level="70">Financial District/Downtown</option>
		<option data-control data-zoom_to="neighborhoods_hyde_park" data-zoom_level="70">Hyde Park</option>
		<option data-control data-zoom_to="neighborhoods_harbor_islands" data-zoom_level="70">Harbor Islands</option>
		<option data-control data-zoom_to="neighborhoods_north_end" data-zoom_level="70">North End</option>
		<option data-control data-zoom_to="neighborhoods_west_end" data-zoom_level="70">West End</option>
		<option data-control data-zoom_to="neighborhoods_government_center_faneuil_hall" data-zoom_level="70">Government Center/Faneuil Hall</option>
		<option data-control data-zoom_to="neighborhoods_beacon_hill" data-zoom_level="70">Beacon Hill</option>
		<option data-control data-zoom_to="neighborhoods_mission_hill" data-zoom_level="70">Mission Hill</option>
	</select>
</div>
{include file="home/includes/movie.tpl"}
