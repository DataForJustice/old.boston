<!doctype html>
<!--[if IE 9]><html class="lt-ie10" lang="en" > <![endif]-->
<html class="no-js" lang="en" data-useragent="Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)">
	<head>
		<meta charset="utf-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		<title>{$title} | Data for Justice</title>
		<link href='https://fonts.googleapis.com/css?family=Special+Elite|Open+Sans+Condensed:300|Roboto:300italic,900' rel='stylesheet' type='text/css'>
		<link rel="stylesheet" href="/css/foundation.css"/>
		<script src="/js/vendor/modernizr.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js" charset="utf-8"></script>
		<script src="http://d3js.org/queue.v1.min.js"></script>
		<script src="/js/topojson/topojson.js"></script>
		<script src="/js/vendor/jquery.js"></script>
		<script src="/js/foundation.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/ScrollMagic.min.js"></script>
		<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/1.17.0/TweenMax.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/plugins/debug.addIndicators.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/plugins/animation.gsap.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-backstretch/2.0.4/jquery.backstretch.min.js" charset="utf-8"></script>
		<script src="/js/home.map.js"></script>
		<script src="/js/scenes.js"></script>
		<link rel="stylesheet" href="/css/style.css"/>
	</head>
	<body>
		<div id="a_container" style="width: 80% !important; position: fixed !important; top: 0; left: 0; height: 100%; z-index: 90;" class="large-6 columns">
			<div id="map" style="100%; position: relative;"></div>
		</div>
		<div class="text_container" style="width: 50% !important; position: fixed !important; top: 2%; left: 5%; z-index: 95;">
			<h1 class="section_name"></h1>
		</div>
		<div id="main_text" class="text_container" style="width: 35% !important; position: fixed !important; top: 0; left: 65%; z-index: 95; height: 100%;">
			<div data-section="intro">
				<h1>Intro</h1>
				<p>Lorem ipsum dolor sit amet, ius saperet dolores elaboraret ne, mel ex euismod deterruisset necessitatibus. Vim eu elitr conceptam voluptaria. Id odio fugit quaeque his. Posse feugait an sed. Ad quo odio suas malis.</p><p>No pri choro definiebas, nam ad inani deleniti efficiendi. An duo wisi dolore. Usu constituto delicatissimi et, tantas consul dignissim mel ea. Brute veniam eligendi est ad. Odio meliore nam ea. Delenit maiorum copiosae at sed.</p><p>An viris ornatus ius. Eu enim omnesque salutandi mea. Zril utinam eum ei, alterum senserit intellegebat his ut. In amet debitis pro. Quis erroribus disputando in eum, nonumy eruditi quo eu, eu mutat appetere sed. Ea his explicari deseruisse definitionem, cum volumus officiis repudiare te.</p><p>Mea autem partem quaestio an, ut mel vero adipiscing. His ad justo postea iriure, usu eius tacimates consetetur ex. At dolor populo percipit eos, ne dico soleat aliquip quo. Ut legendos consetetur qui. Harum timeam temporibus vel ea, pri postea tamquam perpetua te.</p><p>Est eu wisi reprehendunt. Laoreet legendos appellantur in qui. Eu stet habemus definitionem cum. Munere iudicabit torquatos per te.</p>
			</div>
			<div data-section="boundaries_white">
				<h1>White boundary</h1>
				<p>Lorem ipsum dolor sit amet, ius saperet dolores elaboraret ne, mel ex euismod deterruisset necessitatibus. Vim eu elitr conceptam voluptaria. Id odio fugit quaeque his. Posse feugait an sed. Ad quo odio suas malis.</p><p>Mea autem partem quaestio an, ut mel vero adipiscing. His ad justo postea iriure, usu eius tacimates consetetur ex. At dolor populo percipit eos, ne dico soleat aliquip quo. Ut legendos consetetur qui. Harum timeam temporibus vel ea, pri postea tamquam perpetua te.</p><p>Est eu wisi reprehendunt. Laoreet legendos appellantur in qui. Eu stet habemus definitionem cum. Munere iudicabit torquatos per te.</p><p>No pri choro definiebas, nam ad inani deleniti efficiendi. An duo wisi dolore. Usu constituto delicatissimi et, tantas consul dignissim mel ea. Brute veniam eligendi est ad. Odio meliore nam ea. Delenit maiorum copiosae at sed.</p><p>An viris ornatus ius. Eu enim omnesque salutandi mea. Zril utinam eum ei, alterum senserit intellegebat his ut. In amet debitis pro. Quis erroribus disputando in eum, nonumy eruditi quo eu, eu mutat appetere sed. Ea his explicari deseruisse definitionem, cum volumus officiis repudiare te.</p>
			</div>
			<div data-section="whiteness" class="wards_whitest">
				<h1>Whiteness</h1>
				<p>Lorem ipsum dolor sit amet, ius saperet dolores elaboraret ne, mel ex euismod deterruisset necessitatibus. Vim eu elitr conceptam voluptaria. Id odio fugit quaeque his. Posse feugait an sed. Ad quo odio suas malis.</p><p>Mea autem partem quaestio an, ut mel vero adipiscing. His ad justo postea iriure, usu eius tacimates consetetur ex. At dolor populo percipit eos, ne dico soleat aliquip quo. Ut legendos consetetur qui. Harum timeam temporibus vel ea, pri postea tamquam perpetua te.</p><p>Est eu wisi reprehendunt. Laoreet legendos appellantur in qui. Eu stet habemus definitionem cum. Munere iudicabit torquatos per te.</p><p>No pri choro definiebas, nam ad inani deleniti efficiendi. An duo wisi dolore. Usu constituto delicatissimi et, tantas consul dignissim mel ea. Brute veniam eligendi est ad. Odio meliore nam ea. Delenit maiorum copiosae at sed.</p><p>An viris ornatus ius. Eu enim omnesque salutandi mea. Zril utinam eum ei, alterum senserit intellegebat his ut. In amet debitis pro. Quis erroribus disputando in eum, nonumy eruditi quo eu, eu mutat appetere sed. Ea his explicari deseruisse definitionem, cum volumus officiis repudiare te.</p>
			</div>
			<div data-section="blackness" class="wards_blackest">
				<h1>Blackness</h1>
				<p>Lorem ipsum dolor sit amet, ius saperet dolores elaboraret ne, mel ex euismod deterruisset necessitatibus. Vim eu elitr conceptam voluptaria. Id odio fugit quaeque his. Posse feugait an sed. Ad quo odio suas malis.</p><p>Mea autem partem quaestio an, ut mel vero adipiscing. His ad justo postea iriure, usu eius tacimates consetetur ex. At dolor populo percipit eos, ne dico soleat aliquip quo. Ut legendos consetetur qui. Harum timeam temporibus vel ea, pri postea tamquam perpetua te.</p><p>Est eu wisi reprehendunt. Laoreet legendos appellantur in qui. Eu stet habemus definitionem cum. Munere iudicabit torquatos per te.</p><p>No pri choro definiebas, nam ad inani deleniti efficiendi. An duo wisi dolore. Usu constituto delicatissimi et, tantas consul dignissim mel ea. Brute veniam eligendi est ad. Odio meliore nam ea. Delenit maiorum copiosae at sed.</p><p>An viris ornatus ius. Eu enim omnesque salutandi mea. Zril utinam eum ei, alterum senserit intellegebat his ut. In amet debitis pro. Quis erroribus disputando in eum, nonumy eruditi quo eu, eu mutat appetere sed. Ea his explicari deseruisse definitionem, cum volumus officiis repudiare te.</p>
			</div>
		</div>
		<div id="chapters" style="width: 10% !important; height: 50%; position: fixed !important; top: 50%; left: 2%; z-index: 99;">
			<div>
				<h3>Chapter 1</h3>
				<ol>
					<li data-section="intro">Introduction</li>
					<li data-section="boundaries_white">Racial boundary: white</li>
					<li data-section="whiteness">How white?</li>
					<li data-section="blackness">How black?</li>
				</ol>
			</div>
			<div>
				<h3>Demographics</h3>
				<ol>
					<li>The density</li>
					<li>How white?</li>
					<li>How black?</li>
					<li>How hispanic?</li>
				</ol>
			</div>
			<div>
				<h3>Policing</h3>
			</div>
			<div>
				<h3>Public services</h3>
			</div>
			<div>
				<h3>Access to</h3>
			</div>
			<div>
				<h3>Hey..</h3>
			</div>
		</div>
		<div id="movie">
			<div data-zoom_to="counties_25025" data-zoom_level="120">
				<div class="pin">&nbsp;</div>
				<div id="intro" data-section="intro" data-clear="wards,boundaries">&nbsp;</div>
				<div id="boundaries_white" data-section="boundaries_white" data-quantifier="delta_white" data-quantify="boundaries">&nbsp;</div>
				<div id="wards_white" data-section="whiteness" data-quantifier="whiteness" data-quantify="wards">&nbsp;</div>
				<div id="wards_black" data-section="blackness" data-quantifier="blackness" data-quantify="wards">*</div>
			</div>
			<div data-zoom_to="counties_25025" data-zoom_level="120">
				<div class="pin">
				</div>
				<div></div>
			</div>
		</div>
	</body>
</html>
<html>
	<head>
		<title>{$title}</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	</head>
	<body>
		<div id="main">
			{include 'navigation.tpl'}
			<div id="content">
				<div class="container">
					{$content}
				</div>
			</div>
			<div class="footer">
				{include 'footer.tpl'}
			</div>
		</div>
	</body>
</html>

