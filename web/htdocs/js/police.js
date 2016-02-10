$(document).ready (function () { 
	var conf = {
		data: { 
			fios_rate: {
				type: d3.csv,
				url: "/data/fios_rate_neighborhoods.csv",
				id: "fios_rate",
				processor: function (rows) {
				}
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
			fios_grid: {
				type: d3.csv,
				url: "/data/fios_grid.csv",
				id: "fios_grid"
			},
			fios: {
				type: d3.csv,
				url: "/data/fios_by_neighborhood.csv",
				id: "fios"
			},
			incidents: {
				type: d3.csv,
				url: "/data/incidents_by_neighborhood.csv",
				id: "incidents"
			},
			blockgroups: {
				type: d3.json, 
				url: "/data/boston_blockgroups.json", 
				id: "blockgroups", 
				key: "stdin",
				idProperty: "gid",
				processor: function (rows) {
					var d = {};
					if (!this.data ["demographics"]) this.data ["demographics"] = {};
					if (!this.data ["demographics"] ["blockgroups"]) this.data ["demographics"] ["blockgroups"] = {}; 
					if (rows && rows.objects && rows.objects.stdin && rows.objects.stdin.geometries) {
						var w = rows.objects.stdin.geometries;
						w.forEach (function (r) { 
							var prop = r.properties;
							if (!d [prop.gid]) {
								d [prop.gid] = prop;
							}
						});
					}
					this.data ["demographics"]["blockgroups"] = d;
				},
				enumerator: "geometries"
			}, 
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
		},
		prequantifiers: {
			accuracy: function (args, a) {
				var data = new Nestify (this.data.fios_rate, ["name"], ["count", "seizures"]).data;
				var scale = d3.scale.linear ().domain (data.extent (function (a) { return (a.values.seizures / a.values.count) * 100; }));

				return {data: data, scale: scale};
			},
			accuracy_race: function (args, a) { 
				var data = new Nestify (this.data.fios_rate,  ["race", "name"], ["count", "seizures"]).data;
				//var z = data.extent(function (a) { return (a.values.seizures / a.values.count) * 100; })
				var scale = d3.scale.linear ();

				return {data: data, scale: scale};
			},
			fios_streets: function (args, a) {
				var data = new Nestify (this.data.fios_grid, ["grid"], ["count"]).data;
				var mean = data.mean (function (a) { return a.values.count});
				var extent = data.extent (function (a) { return a.values.count });
				var min = extent [0];
				var max = extent [1];
				//var scale = d3.scale.sqrt ().domain ([min, mean]);
				//var scale = d3.scale.sqrt ().domain ([min, mean, (max - mean) / 2]);
				var scale = d3.scale.sqrt ().domain ([min, (mean - min) / 2, mean, (max - mean) / 2]);
				var scale = d3.scale.linear ().domain ([min, (mean - min) / 2, mean, (max - mean) / 2]);

				return {data: data, scale: scale};
			},
			fios_race: function (args, a) {
				var data = new Nestify (this.data.fios_rate, ["race"], ["count"]).data;
				var scale = d3.scale.linear ().domain ([0, data.sum (function (a) { return a.values.count; })]);
				return {data: data, scale: scale} 
			}
		},
		quantifiers: {
			maps: { 
				accuracy: function (a, args, d) {
					var k = a.properties.name;
					var scale = d.scale
					var qr = d3.scale.quantize ().domain (scale.domain ()).range (d3.range (4).map (function (i) { return 3-i; }));
					if (d.data [k]) {
						var seizures = d.data [k].seizures;
						var stops = d.data [k].count;
						var acc = (seizures / stops) * 100;

						return {"class": "aq" + qr (acc) +"-4"}
					}
				},
				fios_streets: function (a, args, d) {
					var k = a.properties.id;
					var data = d.data;
					var scale = d.scale.copy ();
					var sizes = [0, 2, 5, 6];
					var sc = d3.scale.threshold ().domain (scale.domain ()).range (sizes);
					var colors = ['none', 'yellow', 'orange', 'red'];
					var qr = sc.copy ().range (colors);
					if (d.data [k]) {
						//return {"r": sc (d.data [k].count), "class": "fio ", "fill": qr (d.data [k].count), "filter":"url(#blur-effect-2)" }
						return {"r": sc (d.data [k].count), "class": "fio " + qr (d.data [k].count)}
					}
					return {"r": 0}

					//return {"r": 3, "class": "fio", "fill": "red", "filter":"url(#blur-effect-2)" }
					
				}
			},
			bars: {
				accuracy: function (a, args, d) { 
					var k = a.key;
					var scale = d.scale
					var qr = d3.scale.quantize ().domain (scale.domain ()).range (d3.range (4).map (function (i) { return 3-i; }));
					if (d.data [k]) {
						var seizures = d.data [k].seizures;
						var stops = d.data [k].count;
						var acc = (seizures / stops) * 100;
						return {"class": "aq" + qr (acc) +"-4", "height": scale (acc)}
					}
				}
			},
			lines: {
				accuracy_race: function (race, a, args, d) { 
					if (d.data [race] && d.data [race] [a.key]) {
						var scale = d.scale.domain (d.data [race].extent (function (d) { return (d.values.seizures / d.values.count) * 100  }));
						var seizures = d.data [race] [a.key].seizures;
						var stops = d.data [race] [a.key].count;
						var acc = (seizures / stops) * 100;

						return {"y": scale (acc), "class": "accuracy_line accuracy_" + race};
					}
				}
			},
			pie: { 
				fios_race: function (race, a, args, d) { 
					var ret = d.scale (d.data [race].count); // by now, the scale's range is 0 to 365
					console.log (ret + " " + d.data [race].count + " " + d.scale.domain ());
					return {"degrees": ret};
					// Why should I be called for? Maybe class setting... 
				}
			}
		},
		callbacks: {
			incidents: function () {
			}
		}
	};
	var coord = new Ant (conf);
	coord.parseElement ($("#intro_carousel .item.active") [0])
	// TODO: integrate carousel and others to the coordinator... :)
	$("#intro_carousel").bind ("slide.bs.carousel", function (e) { 
		coord.parseElement (e.relatedTarget);
	});
});
