$(document).ready (function () {
	var conf = {
		data: {
			counties: {
				type: d3.json, 
				url: "/data/ma_counties.json", 
				id: "counties",
				key: "stdin",
				enumerator: "geometries",
				idProperty: "id"
			},
			neighborhoods: {
				type: d3.json,
				url: "/data/neighborhoods.json",
				id: "neighborhoods",
				key: "stdin",
				idProperty: function (d) { return d.properties.name.replace ('/', ' ').replace(' ', '_').toLowerCase (); },
				enumerator: "geometries"
			},
			boston_grid: { 
				type: d3.json,
				url: "/data/boston_grid.json",
				id: "boston_grid",
				key: "stdin",
				idProperty: "id",
				enumerator: "geometries",
				plot: "points"
			},
			blockgroups: {
				type: d3.json, 
				url: "/data/boston_blockgroups.json", 
				id: "blockgroups", 
				key: "stdin",
				idProperty: "gid",
				enumerator: "geometries"
			}, 
			wod: {
				type: d3.csv,
				url: "/data/wod.csv",
				id: "wod",
				processor: function (rows) { 
					this.data ["wod_nested"] = new Nestify (rows, ["grid", "d_year"], ["count"]).data;
					var d = new Nestify (rows, ["grid"], ["count"]).data;
					this.data ["wod_nested"].extent = d.extent (function (a) { return a.values.count; });
				}
			}
		},
		prequantifiers: {
			race: function (args) { 
				var data = this.data ["blockgroups"].objects.stdin.geometries;
				if (data) { 
					var keys = ["gid"];
					var d = new Nestify (data, keys, ["white", "black", "poc"], "properties").data;
					//var extent= d.extent (function (a) { return (a.values [args.race] * 100) / (a.values.white + a.values.black + a.values.poc) });
					var extent = [0, 100]
					return {data: d, scale: d3.scale.quantize ().domain (extent).range ([0, 1, 2, 3])};
				}
			},
			wod: function (args) { 
				var keys = ["grid"];
				for (var x in args) { keys.push (x); }
				var data = new Nestify (this.data.wod, keys, ["count"]).data;
				var r = data.values;
				 
				var extent = data.minmean (
					// TODO this will be substituted once Nestify supports key:values
					function (d) { 
						if (args.d_year) { // nested by year 
							return d.values.sum (function (a) { if (args.d_year == a.key) {  return a.values.sum (function (z) { if (args.ncode.indexOf (z.key) !== -1) { return z.values.count; } }); } }); 
						}
						return d.values.sum (function (a) { if (args.ncode.indexOf (a.key) !== -1) { return a.values.count; } });
					}
				);
				var scale = d3.scale.sqrt ().domain (extent);
				//var scale = d3.scale.pow ().exponent (.5).domain (extent);
				return {data: data, scale: scale};
			},
			year: function (args) { 
				var data = this.data.wod_nested;
				var e = data [args.grid].extent (function (a) { return a.values.count; })
				return { data: data [args.grid], scale: d3.scale.linear ().domain ([0, data.extent [1]]) }
			}
		},
		quantifiers: {
			maps: {
				wod: function (a, args, d) {
					var id = a.properties.id;
					var data = d.data [id];
					var qn = d3.scale.quantize ().domain (d.scale.domain ()).range (["blue", "yellow", "orange", "red"]);
					if (data) { 
						//d.scale.range ([2, 4, 8, 10]);
						d.scale.range ([2, 4, 8, 16]);
						if (args.d_year && data [args.d_year]) { 
							data = data [args.d_year];
						}
						var cnt = data.sum (function (a) { if (args.ncode.indexOf (a.key) !== -1) { return a.values.count; } });
						// this array gets passed to the parser and each element gets parsed too each time the element is hovered or clicked 
						var parse = [
							{control_chart: "yearly_chart_arrests", "quantify": "wod", "quantifier": "year", "quantifier_args": {grid: id}},
							/* the following highlights all the circles with the same color :) */
							{control_chart: "a_map", highlight: "." + qn (cnt)},
							{control_chart: "b_map", highlight: "." + qn (cnt)},
							{control_chart: "a_map", highlight: ".grid_" + id}, 
							{control_chart: "b_map", highlight: ".grid_" + id}, 
						];
						var data = {control_chart: "yearly_chart", "quantify": "wod", "quantifier": "year", "quantifier_args": {grid: id}, "parse": parse};

						return {"class": qn (cnt) + " grid_" + id, "r": d.scale (cnt), "data": data};
					}
				},
				race: function (a, args, d) { 
					var id = a.properties.gid;
					var data = d.data [id];
					if (data) { 
						var sum = 0;
						for (var i in args.race) { sum += data [args.race [i]]; }
						var pct = (sum * 100) / (data.white + data.black + data.poc);
						return {"class": "qg" + d.scale (pct) + "-4"};
					}

				}
			},
			bars: {
				year: function (a, args, d) { 
					return {"height": d.scale (a.values.count)};
				}
			}
		} 
	};
	var coord = new Ant (conf);
});
