<div style="height: 90%; position: fixed; top: 10vh; left: 0; width: 100%; z-index: 10;">
	<div id="maps" class="row" style="height: 100%; visibility: hidden; position: relative;">
		<div data-chart="map" data-map_layers="counties,blockgroups,neighborhoods,boston_grid" id="b_map" data-zoom_to="counties_25025" data-zoom_level="130" data-map_center_lat="42.319834" data-map_center_lon="-71.087294" class="col-md-6 map" style="height:100%; margin: 0 !important; padding: 0;">
		</div>
		<div data-chart="map" data-map_layers="counties,blockgroups,neighborhoods,boston_grid" id="a_map" data-zoom_to="counties_25025" data-zoom_level="130" data-map_center_lat="42.319834" data-map_center_lon="-71.087294" class="col-md-6 map" style="height:100%; margin: 0 !important; padding: 0;">
		</div>
		<h1 style="position: absolute; top: 1%; left: 10%">Drug Investigations</h1>
		<h1 style="position: absolute; top: 1%; left: 60%">Drug Arrests</h1>
		<div id="yearly_chart" data-chart="bars" style="position:absolute; left: 79%; top: 85%; width: 20%; height: 10%; margin: 0; padding: 0;">&nbsp;</div>
		<div id="yearly_chart_arrests" data-chart="bars" style="position:absolute; left: 79%; top: 75%; width: 20%; height: 10%; margin: 0; padding: 0;">&nbsp;</div>
	</div>
	<div id="pop_map" class="row" style="height: 100%; position: absolute; top: 0; width: 100%;">
		<div id="num_pop" style="position: absolute; top: 5%; left: 20%; z-index: 1000; visibility: hidden;"><h1>Population: 617,594</h1></div>
		<div id="num_white" style="position: absolute; top: 5%; left: 70%; z-index: 1000; visibility: hidden;"><h1>47% white,<small><br/> excl. white hispanics</small></h1></div>
		<div id="num_black" style="position: absolute; top: 60%; left: 20%; z-index: 1000; visibility: hidden;"><h1>24% Black</h1></div>
		<div id="num_poc" style="position: absolute; top: 60%; left: 50%; z-index: 1000; visibility: hidden;"><h1>28.8% other P.O.C, <small><br/> incl. white hispanics</small></h1></div>
		<div data-chart="map" data-map_layers="counties,blockgroups,neighborhoods" id="p_map" data-zoom_to="counties_25025" data-zoom_level="110" data-map_center_lat="42.319834" data-map_center_lon="-71.087294" class="col-md-8 map col-md-offset-2" style="height: 80%; padding: 0;"></div>  
	</div>
<!--	<div id="race_comp" data-chart="pie" style="position: absolute; top: 79%; left: 1%; width: 20vh; height: 20vh; margin: 0; padding: 0; border: 1px solid black;"></div>
-->
	<div id="audio_container" style="position: absolute; top: 80%; left: 1%; width: 15%; height: 10%; background-color: red; display: none;">
		<audio data-media="audio" id="narration" preload="auto" autobuffer>
			<source src="/wod.mp3" type="audio/mp3"></source>	
		</audio>
		<span id="narration_1" data-subscribe_media="narration" data-subscribe_time="8" data-show="num_pop">&nbsp;</span>
		<span id="narration_1" data-subscribe_media="narration" data-subscribe_time="17" data-show="num_white">&nbsp;</span>
		<span id="narration_1" data-subscribe_media="narration" data-subscribe_time="21" data-show="num_black">&nbsp;</span>
		<span id="narration_1" data-subscribe_media="narration" data-subscribe_time="27" data-show="num_poc">&nbsp;</span>
		<span id="narration_a" data-subscribe_media="narration" data-subscribe_time="17" data-parse="p_lay_white">&nbsp;</span>
		<span id="narration_b" data-subscribe_media="narration" data-subscribe_time="21" data-parse="p_lay_black">&nbsp;</span>
		<span id="narration_c" data-subscribe_media="narration" data-subscribe_time="27" data-parse="p_lay_poc">&nbsp;</span>
		<span id="narration_d" data-subscribe_media="narration" data-subscribe_time="36" data-parse="p_lay_white">&nbsp;</span> 
		<span id="narration_e" data-subscribe_media="narration" data-subscribe_time="38" data-parse="p_lay_black">&nbsp;</span> 
		<span id="narration_f" data-subscribe_media="narration" data-subscribe_time="40" data-parse="p_lay_white">&nbsp;</span> 
		<span id="narration_g" data-subscribe_media="narration" data-subscribe_time="42" data-parse="p_lay_black">&nbsp;</span> 
		<span id="narration_h" data-subscribe_media="narration" data-subscribe_time="50" data-parse="p_lay_white">&nbsp;</span> 
		<span id="narration_i" data-subscribe_media="narration" data-subscribe_time="52" data-parse="p_lay_nonwhite">&nbsp;</span> 
		<span id="narration_j" data-subscribe_media="narration" data-subscribe_time="54" data-parse="p_lay_white">&nbsp;</span> 
		<span id="narration_k" data-subscribe_media="narration" data-subscribe_time="56" data-parse="p_lay_nonwhite">&nbsp;</span> 
		<span id="narration_l" data-subscribe_media="narration" data-subscribe_time="80" data-hide="pop_map" data-show="maps">&nbsp;</span> 
		<span id="narration_m" data-subscribe_media="narration" data-subscribe_time="90" data-parse="all_ctrl_b">&nbsp;</span> 
		<span id="narration_n" data-subscribe_media="narration" data-subscribe_time="95" data-parse="all_ctrl_a">&nbsp;</span> 
		<span id="narration_n" data-subscribe_media="narration" data-subscribe_time="122" data-parse="lay_white">&nbsp;</span>
		<span id="narration_o" data-subscribe_media="narration" data-subscribe_time="124" data-parse="lay_nonwhite">&nbsp;</span>
		<span id="narration_p" data-subscribe_media="narration" data-subscribe_time="125" data-parse="lay_white">&nbsp;</span>
		<span id="narration_q" data-subscribe_media="narration" data-subscribe_time="127" data-parse="lay_nonwhite">&nbsp;</span>
		<span id="narration_r" data-subscribe_media="narration" data-subscribe_time="129" data-show="y_2012">&nbsp;</span> 
		<span id="narration_r" data-subscribe_media="narration" data-subscribe_time="129" data-show="overlays">&nbsp;</span> 
		<a id="p_lay_white" data-control data-control_chart="p_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["white"]}{/literal}'>White</a>
		<a id="p_lay_nonwhite" data-control data-control_chart="p_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["black", "poc"]}{/literal}'>Non-white</a>
		<a id="p_lay_black" data-control data-control_chart="p_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["black"]}{/literal}'>Black</a>
		<a id="p_lay_poc" data-control data-control_chart="p_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["poc"]}{/literal}'>Other P.O.C.</a>
		<a id="all_ctrl_a" data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"ncode": ["ARREST"]}{/literal}'>1.</a>
		<a id="all_ctrl_b" data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'>2.</a>
	</div>
	<!--<div data-chart="map" data-map_layers="counties,neighborhoods,boston_grid" id="mini_map" data-zoom_to="counties_25025" data-zoom_level="100" data-map_center_lat="42.319834" data-map_center_lon="-71.087294" style="position: absolute; top: 79%; left: 40%; width: 20%; height:20%; background-color: white; margin: 0; padding: 0;"></div>-->
</div>
<div style="position: relative; z-index: 10; height: 0;">
	<section id="slide_intro" data-slide="main" data-show="intro">
		<!--<div class="scene_separator row">Hola</div>-->
	</section>
	<section data-slide="main" id="header" data-hide="intro">
		<div class="scene_separator row">
			<div class="col-md-7">
				<h1 style="text-align: left;">Drug charges in Boston</h1>
			</div>
			<div id="overlays" class="col-md-5" style="visibility: hidden">
				Population overlays: 
				<a id="lay_white" data-control data-control_chart="a_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["white"]}{/literal}' data-parse="lay_white_b"><b id="lay_white_b" data-control_chart="b_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["white"]}{/literal}'>White</b></a>,
				<a id="lay_nonwhite" data-control data-control_chart="a_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["black", "poc"]}{/literal}' data-parse="lay_nonwhite_b"><b  id="lay_nonwhite_b" data-control_chart="b_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["black", "poc"]}{/literal}'>Non-white</b></a>,
				<a id="lay_black" data-control data-control_chart="a_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["black"]}{/literal}' data-parse="lay_black_b"><b id="lay_black_b" data-control_chart="b_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["black"]}{/literal}'>Black</b></a>,
				<a id="lay_poc" data-control data-control_chart="a_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["poc"]}{/literal}' data-parse="lay_poc_b"><b id="lay_poc_b" data-control_chart="b_map" data-quantify="blockgroups" data-quantifier="race" data-quantifier_args='{literal}{"race": ["poc"]}{/literal}'>Other people of color</b></a>
			</div>
		</div>
	</section>
	<section id="slide_maps" style="height: 0px;">
		<div id="movie">
			<div class="scene" data-control_media="narration" data-media_play data-hide="maps" data-show="pop_map">
				<div class="hstring">
					<div class="scene_content">
						<h1>  </h1>
					</div>
				</div>
			</div>
			<!--
			<div class="scene" data-parse="all_ctrl_a,all_ctrl_b">
				<div id="all_ctrl_a" data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"ncode": ["ARREST"]}{/literal}'></div>
				<div id="all_ctrl_b" data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring"> 
					<div class="scene_content">
						<h1>2012 - 2015</h1>
					</div>
				</div>
			</div>
			-->
			<div id="y_2012" class="scene" data-parse="y_2012_bis,y_2012_overlays,2012_ctrl_a,2012_ctrl_b" style="visibility: hidden;" data-show="maps" data-hide="pop_map" data-control_media="narration" data-media_stop>
				<div id="y_2012_bis" data-show="y_2012"></div>
				<div id="y_2012_overlays" data-show="overlays"></div>
				<div id="2012_ctrl_a" data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2012, "ncode": ["ARREST"]}{/literal}'></div>
				<div id="2012_ctrl_b" data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2012, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2012</h1>
						<!--<div id="video_2012" data-video="youtube" data-video_url="http://www.youtube.com/watch?v=CxvgCLgwdNk" style="width: 230px; height: 150px; background-color: white;"></div>-->
						<!--<div id="video_2012_v" data-media="vimeo" data-media_url="https://vimeo.com/128869916" style="width: 100%; height: 150px; background-color: white;"></div>-->
					</div>
				</div>
			</div>
			<div class="scene" data-parse="2013_ctrl_a,2013_ctrl_b" data-control_media="video_2012_v" data-media_stop>
				<div id="2013_ctrl_a" data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2013, "ncode": ["ARREST"]}{/literal}'></div>
				<div id="2013_ctrl_b" data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2013, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2013</h1>
					</div>
				</div>

			</div>
			<div class="scene" data-parse="2014_ctrl_a,2014_ctrl_b">
				<div id="2014_ctrl_a" data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2014, "ncode": ["ARREST"]}{/literal}'></div>
				<div id="2014_ctrl_b" data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2014, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2014</h1>
					</div>
				</div>
			</div>
			<div class="scene" data-parse="2015_ctrl_a,2015_ctrl_b">
				<div id="2015_ctrl_a" data-control_chart="a_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2015, "ncode": ["ARREST"]}{/literal}'></div>
				<div id="2015_ctrl_b" data-control_chart="b_map" data-quantify="boston_grid" data-quantifier="wod" data-quantifier_args='{literal}{"d_year": 2015, "ncode": ["IVDRUG", "IVPER", "IVPREM", "INVEST", "IVMV"]}{/literal}'></div>
				<div class="hstring">
					<div class="scene_content">
						<h1>2015</h1>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>
