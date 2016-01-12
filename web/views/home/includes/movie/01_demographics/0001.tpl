<div id="blockgroups_poc" data-zoom_to="counties_25025" data-zoom_level="110" data-section="poc" data-quantifier="race" data-quantify="blockgroups" data-quantifier_args='{literal}{"race": "white"}{/literal}'>
	<h2>White people map</h2>
	<p>
		This map shows, in purple color, the percentage of white people (non-hispanic) living in each neighborhood / census block group.
	</p>
</div>
<div id="blockgroups_poc" data-section="poc" data-quantifier="race" data-quantify="blockgroups" data-quantifier_args='{literal}{"race": "black"}{/literal}'>
	<h2>Black people map</h2>
	<p>
		This map shows, in blue color, the percentage of black people living in each neighborhood / census block group.
	</p>
</div>
<div id="blockgroups_poc" data-section="poc" data-quantifier="race" data-quantify="blockgroups" data-quantifier_args='{literal}{"race": "poc"}{/literal}'>
	<h2>Other people of Color map</h2>
	<p>
		This map shows, in green color, the percentage of other people of color (non-black), including white hispanics, living in each neighborhood / census block group.
	</p>
</div>
<div id="blockgrops_racial" data-quantifier="racial" data-quantify="blockgroups" data-clear="neighborhoods">
	<h2>The racial composition</h2>
	<p>
		This map shows which race is predominant in each neighborhood / census block group<br/>
		Uses the same colors as the previous maps: purple for white people (non-hispanic), blue for black people, green for other people of color (non-black), including white hispanics.
	</p>
</div>
<div id="fios_neighborhoods" data-clear="blockgroups" data-quantifier="fios" data-quantify="neighborhoods">
	<h2>FIOs</h2>
	<form id="fio_search" name="fio_search" data-control data-quantifier="fios" data-quantify="neighborhoods">
		<select name="year" id="year">
			<option value="IGNORE">-select year-</option>
			<option value="IGNORE">2011 - 2015</option>
			<option value="2011">2011</option>
			<option value="2012">2012</option>
			<option value="2013">2013</option>
			<option value="2014">2014</option>
			<option value="2015">2015</option>
		</select>
		<h3>Race</h3>
		<input type="radio" name="race" value="4"> White<br/>
		<input type="radio" name="race" value="2"> Black<br/>
		<input type="radio" name="race" value="3"> Hispanic<br/>
		<input type="radio" name="race" value="6"> Middle Eastern or Eastern Indian<br/>
		<input type="radio" name="race" value="5"> American Indian or Alaskan Native<br/>
		<input type="radio" name="race" value="1"> Asian or Pacific Islander<br/>
		<input type="radio" name="race" value="9999"> UNKNOWN<br/>
		<input type="radio" name="race" value="0"> NO DATA ENTERED<br/>
	</form>
</div>
