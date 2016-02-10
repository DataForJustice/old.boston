<div style="height: 100%; position: fixed; top: 0vh; left: 0; width: 100%; z-index: 10;">
	<div class="row" style="height: 100%;">
		<div data-chart="map" data-map_layers="counties,neighborhoods,boston_grid" id="b_map" data-zoom_to="counties_25025" data-zoom_level="130" data-map_center_lat="42.319834" data-map_center_lon="-71.087294" class="col-md-6" style="height:100%;">
		</div>
		<div data-chart="map" data-map_layers="counties,neighborhoods,boston_grid" id="a_map" data-zoom_to="counties_25025" data-zoom_level="130" data-map_center_lat="42.319834" data-map_center_lon="-71.087294" class="col-md-6" style="height:100%;">
		</div>
	</div>
	<div data-chart="map" data-map_layers="counties,neighborhoods,boston_grid" id="mini_map" data-zoom_to="counties_25025" data-zoom_level="100" data-map_center_lat="42.319834" data-map_center_lon="-71.087294" style="position: absolute; top: 80%; left: 80%; width: 20%; height:20%; background-color: white;"></div>
	<h1 style="position: absolute; top: 85%; left: 10%">Drug Investigations</h1>
	<h1 style="position: absolute; top: 85%; left: 60%">Drug Arrests</h1>
</div>
<div style="position: relative; z-index: 100; border: 1px solid green; height: 0;">
	<section data-slide="main" id="header">
		<div class="scene_separator">
		</div>
	</section>
	<section id="maps" style="height: 0px;">
		<div id="movie">
			<div class="scene">
				<div data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"ncode": ["ARREST"]}{/literal}'></div>
				<div data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring"> 
					<div class="scene_content">
						<h1>2012 - 2015</h1>
					</div>
				</div>
			</div>
			<div class="scene">
				<div data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2012, "ncode": ["ARREST"]}{/literal}'></div>
				<div data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2012, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2012</h1>
					</div>
				</div>
			</div>
			<div class="scene">
				<div data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2013, "ncode": ["ARREST"]}{/literal}'></div>
				<div data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2013, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2013</h1>
					</div>
				</div>

			</div>
			<div class="scene">
				<div data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2014, "ncode": ["ARREST"]}{/literal}'></div>
				<div data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2014, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2014</h1>
					</div>
				</div>
			</div>
			<div class="scene">
				<div data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2015, "ncode": ["ARREST"]}{/literal}'></div>
				<div data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2015, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2015</h1>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>
