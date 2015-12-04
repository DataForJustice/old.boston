$(document).ready (function () { 
	//$(this).foundation ();	
	var conf = {
		data: { 
			counties: {
				type: d3.json, 
				url: "/data/shapes/counties.json", 
				id: "counties",
				key: "ma_counties",
				enumerator: "geometries",
				idProperty: "FIPS_ID"
			},
			wards: {
				type: d3.json, 
				url: "/data/shapes/boston_wards.json", 
				id: "wards", 
				key: "wards",
				idProperty: "ward",
				processor: function (rows) {
					var d = {};
					if (!this.data ["demographics"]) this.data ["demographics"] = {};
					if (!this.data ["demographics"] ["wards"]) this.data ["demographics"] ["wards"] = {}; 
					if (rows.objects && rows.objects.wards && rows.objects.wards && rows.objects.wards.geometries) {
						var w = rows.objects.wards.geometries;
						w.forEach (function (r) { 
							var prop = r.properties;
							if (!d [prop.ward]) {
								d [prop.ward] = prop;
							}
						});
					}
					this.data ["demographics"]["wards"] = d;
				},
				enumerator: "geometries"
			}, 
			boundaries: {
				type: d3.json, 
				url: "/data/shapes/boston_wards_boundaries.json", 
				id: "boundaries",
				key: "stdin",
				enumerator: "geometries",
				idProperty: function (x) { return x.properties.a + "_" + x.properties.b; },
			},
			incidents: {
				type: d3.csv,
				id: "incidents",
				processor: function (rows) { 
					var d = { wards: {}, max: {}, min: {} }; 
					var dm = this.data.demographics.wards;
					rows.forEach (function (r) {
						var x = dm [r.ward];
						var total = x.nh_white + x.nh_black + x.nh_other + x.h_white + x.h_black + x.h_other;
						var cnt = (r.count / total) * 10000;
						//cnt = r.count;
						if (!d.wards [r.ward]) d.wards [r.ward] = {};
						if (!d.max [r.charge]) d.max [r.charge] = 0;
						if (!d.min [r.charge]) d.min [r.charge] = 0;
						d.wards [r.ward] [r.charge] = cnt;
						if (cnt > d.max [r.charge]) d.max [r.charge] = cnt;
						if (cnt < d.min [r.charge]) d.min [r.charge] = cnt ? cnt : 0;
					}); 

					return d;
				},
				url: "/data/incidents.csv"
			}
		},
		map: {
			layers: [ "counties", "wards", "boundaries" ],
			center: {lat:42.319834, lon:-71.087294}
		},
		quantifiers: {
			drugs: function (a) {
				var x = a.properties;	
				if (this.data.incidents.wards [x.ward]) {
					var count = this.data.incidents.wards [x.ward]["DRUG CHARGES"] ? this.data.incidents.wards [x.ward]["DRUG CHARGES"] : 0;
					var max = this.data.incidents.max ["DRUG CHARGES"];
					var min = this.data.incidents.min ["DRUG CHARGES"];
					var q = d3.scale.quantile ().domain ([min, (max-min)/2, max]).range (d3.range (9).map (function (i) { return i; }));

					return "q" + q (count) + "-9";
				}
			},
			invper: function (a) {
				var x = a.properties;	
				if (this.data.incidents.wards [x.ward]) {
					var count = this.data.incidents.wards [x.ward]["InvPer"] ? this.data.incidents.wards [x.ward]["InvPer"] : 0;
					var max = this.data.incidents.max ["InvPer"];
					var min = this.data.incidents.min ["InvPer"];
					var q = d3.scale.quantile ().domain ([min, (max-min)/2, max]).range (d3.range (9).map (function (i) { return i; }));

					return "q" + q (count) + "-9";
				}
			},
			vandalism: function (a) {
				var x = a.properties;	
				if (this.data.incidents.wards [x.ward]) {
					var count = this.data.incidents.wards [x.ward]["VANDALISM"] ? this.data.incidents.wards [x.ward]["VANDALISM"] : 0;
					var max = this.data.incidents.max ["VANDALISM"];
					var min = this.data.incidents.min ["VANDALISM"];
					var q = d3.scale.quantile ().domain ([min, (max-min)/2, max]).range (d3.range (9).map (function (i) { return i; }));

					return "q" + q (count) + "-9";
				}
			},
			delta_white: function (a) { 
				var x = a.properties;
				var d = (x.a_w - x.b_w) * 100;
				if (d > 0) {
					//return "l13-4";
					var q = d3.scale.quantile ().domain ([0, 15, 30]).range (d3.range (4).map (function (i) { return i; }));
					return "l1" + q(d) + "-4";
				}
			},
			whiteness: function (a) {
				var x = a.properties;
				var total = x.nh_white + x.nh_black + x.nh_other + x.h_white + x.h_black + x.h_other;
				var q = d3.scale.quantize ().domain ([0, 100]).range (d3.range (9).map (function (i) { return i; }));
				return "q" + q (((x.nh_white + x.h_white) * 100 ) / total) + "-9"; 
			},
			blackness: function (a) {
				var x = a.properties;
				var total = x.nh_white + x.nh_black + x.nh_other + x.h_white + x.h_black + x.h_other;
				var q = d3.scale.quantize ().domain ([0, 100]).range (d3.range (9).map (function (i) { return i; }));
				return "q" + q (((x.nh_black + x.h_black) * 100 ) / total) + "-9"; 
			}
		}, 
		labelers: {
			whiteness: {
				layer: "wards", 
				labeler: function (a) { 
					var x = a.properties; 
					var total = x.nh_white + x.nh_black + x.nh_other + x.h_white + x.h_black + x.h_other;
					return Math.floor (((x.nh_white + x.h_white) * 100) / total) + "%"; 
				} 
			}, 
			blackness: {
				layer: "wards", 
				labeler: function (a) { 
					var x = a.properties; 
					var total = x.nh_white + x.nh_black + x.nh_other + x.h_white + x.h_black + x.h_other;
					return Math.floor (((x.nh_black + x.h_black) * 100) / total) + "%"; 
				} 
			},
			invper: {
				layer: "wards", 
				labeler: function (a) { 
					var x = a.properties;	
					if (this.data.incidents.wards [x.ward]) {
						var count = this.data.incidents.wards [x.ward]["InvPer"] ? this.data.incidents.wards [x.ward]["InvPer"] : 0;
						return Math.round (count, 2).toFixed (1);
				       }
				}
			},
			drugs: {
				layer: "wards",
				labeler: function (a) { 
					var x = a.properties;
					if (this.data.incidents.wards [x.ward]) {
						var count = this.data.incidents.wards [x.ward]["DRUG CHARGES"] ? this.data.incidents.wards [x.ward]["DRUG CHARGES"] : 0;
						return Math.round (count, 2).toFixed (1);
					}
				}
			}
		},
	};

	var coord = new Coordinator (conf);

});
