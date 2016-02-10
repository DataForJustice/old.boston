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
			wod: {
				type: d3.csv,
				url: "/data/wod.csv",
				id: "wod"
			}
		},
		prequantifiers: {
			wod: function (args) { 
				var keys = ["grid"];
				for (var x in args) { keys.push (x); }
				var data = new Nestify (this.data.wod, keys, ["count"]).data;
				var r = data.values;
				 
				var extent = data.minmean (
				function (d) { 
					if (args.d_year) { 
						return d.values.sum (function (a) { if (args.d_year == a.key) {  return a.values.sum (function (z) { if (args.ncode.indexOf (z.key) !== -1) { return z.values.count; } }); } }); 
					}
					return d.values.sum (function (a) { if (args.ncode.indexOf (a.key) !== -1) { return a.values.count; } });
				});
				var scale = d3.scale.sqrt (.5).domain (extent);
				//var scale = d3.scale.linear ().domain (extent);
				return {data: data, scale: scale};
			}
		},
		quantifiers: {
			maps: {
				wod: function (a, args, d) {
					var id = a.properties.id;
					var data = d.data [id];
					var qn = d3.scale.quantize ().domain (d.scale.domain ()).range (["blue", "yellow", "orange", "red"]);
					if (data) { 
						d.scale.range ([2, 4, 8, 10]);
						if (args.d_year && data [args.d_year]) { 
							data = data [args.d_year];
						}
						var cnt = data.sum (function (a) { if (args.ncode.indexOf (a.key) !== -1) { return a.values.count; } });

						return {"class": qn (cnt), "r": d.scale (cnt)};
					}
				}
			}
		} 
	};
	var coord = new Ant (conf);
});
