{assign var=basedir value='../views/home/includes/movie/'}
{assign var=dirs value=$basedir|scandir }
<div id="movie" style="position: absolute; top: 0; left: 70%; width: 30%; z-index: 95;">
{foreach from=$dirs item=dir}
	{if is_dir ("$basedir/$dir") && $dir != "." && $dir != ".."}
		{$dir}<br>
		{assign var=tpls value="$basedir/$dir"|scandir}
		{foreach from=$tpls item=tpl}
			{assign var=info value="$basedir/$dir/$tpl"|pathinfo}
			{if !is_dir ("$basedir/$dir/$tpl") && $info.extension == "tpl"}
				{include file="home/includes/movie/$dir/$tpl"}
			{/if}
		{/foreach}
	{/if}
{/foreach}
	<!--
	<div id="drugs" data-section="drugs" data-quantifier="drugs" data-quantify="blockgroups">&nbsp;</div>
	<div id="vandalism" data-section="vandalism" data-quantifier="vandalism" data-quantify="blockgroups">&nbsp;</div>
	<div id="invper" data-section="invper" data-quantifier="invper" data-quantify="blockgroups">&nbsp;</div>
	-->
</div>
