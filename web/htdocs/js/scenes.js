function Coordinator (conf) {
	this.conf = conf;
	this.map = null;
	this.scroll = null;
	this.currentScene = null;
	this.currentElement = null;
	this.dataOrder = [];

	this.data = {};

	this.init ();
	return this;
}
Coordinator.prototype = {
	constructor: Coordinator,
	init: function () {
		if (this.conf.data) {
			var q = queue ();
			for (c in this.conf.data) {
				var d = this.conf.data [c];
				q.defer (d.type, d.url)
				this.dataOrder.push (d.id);
			}
			q.await ($.proxy (this.dataCallback, this));
		}
	},
	dataCallback: function () {
		if (arguments.length > 0) {
			if (arguments [0]) throw arguments [0];
			for (var i = 1; i < arguments.length; i++) {
				var dataName = this.dataOrder [i-1];
				var conf = this.conf.data [dataName];
				if (conf) {
					var data = arguments [i];
					if (conf.processor) { 
						var ret = $.proxy (conf.processor, this) (arguments [i]);
						if (ret) { 
							data = ret;
						}
					}
					this.data [dataName] = data;
				}
			}
			this.initScroll ();
			this.initMap ();
			this.initText ();
			this.initControls ();
		}
	},
	scrollProgress: function (scene) {
		/*
		var zoomTo = $(scene).data ("zoom_to");
		var zoomLevel = $(scene).data ("zoom_level");
		if (zoomTo) {
			if (!zoomLevel) zoomLevel = 140;
			this.map.zoomTo ("#" + zoomTo, zoomLevel);
		}
		*/
	},
	scrollLeave: function (scene) {
	},
	scrollEnter: function (element) {
		$(element).siblings ().removeClass ("highlight");
		$(element).addClass ("highlight");
		if (element && element.id) {
			if (element.id != this.currentElement) {
				var clear = $(element).data ("clear");
				if (clear) {
					var layers = clear.split(',');
					for (var l in layers) {
						this.quantify (layers [l.trim()]);
					}
				}
				var section = $(element).data ("section");
				$(".text_container").children ("[data-section]").hide ();
				$("li[data-section]").removeClass ("highlight");
				var labeler;
				if (section) {
					$(".text_container").children ("[data-section='" + section + "']").show ();
					$("li[data-section='" + section + "']").addClass ("highlight");
					var txt = $("li[data-section='" + section + "']").first ().text ();
					$(".text_container .section_name").text (txt);
					if (this.conf.labelers && this.conf.labelers [section]) {
						labeler = this.conf.labelers [section];	
					}
				}
				var quantify = $(element).data ("quantify");
				var quantifier = $(element).data ("quantifier");
				var qArgs = $(element).data ("quantifier_args")
				if (quantify && quantifier) {
					if (labeler && quantify == labeler.layer) {
						this.quantify (quantify, {fn: quantifier, ar: qArgs}, {fn: labeler.labeler, ar: qArgs});
					} else if (labeler) {
						this.quantify (labeler.layer, {fn: quantifier, ar: qArgs}, {fn: labeler.labeler, ar: qArgs});
					} else {
						this.quantify (quantify, {fn: quantifier, ar: qArgs});
					}
				}
				var zoomTo = $(element).data ("zoom_to");
				var zoomLevel = $(element).data ("zoom_level"); 
				if (!zoomTo) {
					zoomTo = $(element).prev ().data ("zoom_to"); 
					zoomLevel = $(element).prev ().data ("zoom_level");
				}
				if (zoomTo) {
					this.map.zoomTo ("#" + zoomTo, zoomLevel);
				}

				this.currentElement = element.id;
			}
		}
	},
	quantify: function (layer, quantifier, labeler) {
		if (this.conf.prequantifiers) {
			var pq = quantifier ? this.conf.prequantifiers [quantifier.fn] : null;
			if (pq) { 
				pq.apply (this, [quantifier.ar]);
			}
		}
		if (this.conf.quantifiers) {
			var q = quantifier ? this.conf.quantifiers [quantifier.fn] : null;
		}
		var l = this.conf.data [layer];
		if (!q && quantifier) throw "No quantifier found: " + quantifier.fn;
		if (!l) throw "No data found: " + layer;
		var cb = function (fn) { return}

		var lbl = labeler ? {fn: labeler.fn, context: this, args: labeler.ar} : null;
		var qn = quantifier ? {fn: q, context: this, args: quantifier.ar} : null;
		this.map.topologies [layer].redraw (this.setFeatureId (l), qn, lbl);
	},
	setFeatureId: function (layer) {
		return function (x) { 
			var val = x.properties [layer.idProperty];
			if (typeof layer.idProperty === "function") {
				val = layer.idProperty (x); 
			}
			return layer.id + "_" + val;
		};
	},
	initControls: function () {
		$("a[data-control]").click ({me: this}, 
			function (a) { 
				var x = a.data.me;
				var zoomTo = $(this).data("zoom_to"); 
				var zoomLevel = $(this).data ("zoom_level");
				if (zoomTo) {
					x.map.zoomTo ("#" + zoomTo, zoomLevel);
				}
			}
		);
	},
	initMap: function () { 
		this.map = new home.map ("#map", $(window).width (), $(window).height ())
		this.map.setCenter (this.conf.map.center);
		for (var i in this.conf.map.layers) {
			var l = this.conf.data [this.conf.map.layers [i]];
			this.map.addFeatures (l.id, this.data [l.id], l.key); 
			this.map.topologies [l.id].redraw (this.setFeatureId (l));
		}
	},
	initScroll: function () {
		this.scroll = new Scenify ("#movie");
		this.scroll.on ("scene_progress", $.proxy (this.scrollProgress, this));
		this.scroll.on ("scene_enter", $.proxy (this.scrollEnter, this));
		this.scroll.on ("scene_leave", $.proxy (this.scrollLeave, this));
	},
	initText: function () {
		$("#text_container").children ().hide ();
	}
};
function Scenify (selector) {
	this.selector = selector;
	this.controller = new ScrollMagic.Controller ();
	this.callbacks = {
		scene: { progress: [], enter: [], leave: [] }
	};
	this.scenes = [];
	this.highlightedElements = {};
	this.init ();
	return this;
}
Scenify.prototype = {
	constructor: Scenify,
	init: function () {
		$(this.selector).children ().each ($.proxy (function (index, child) {
			var hook = 0.5;
			var sceneElement = $(child);
			var scene = new ScrollMagic.Scene ({triggerElement: child, tweenChanges: true, duration: "100%"})
					.triggerHook (hook)
					.addTo (this.controller);
			$(sceneElement).addClass ("scene");

			scene.on ("enter", $.proxy (this.enterCallback, this));
			scene.on ("leave", $.proxy (this.leaveCallback, this));
			scene.on ("progress", $.proxy (this.progressCallback, this));

			this.scenes.push (scene);
		}, this));
		return this;
	},
	progressCallback: function (ev) { 
		var elm = ev.target.triggerElement ();
		this.trigger ("scene_progress", [elm]);
	},
	enterCallback: function (ev) { 
		var elm = ev.target.triggerElement ();
		this.trigger ("scene_enter", [elm]);

	},
	leaveCallback: function (ev) {
		var elm = ev.target.triggerElement ();
		this.trigger ("scene_leave", [elm]);

	},
	trigger: function (eventName, args) {
		for (c in this.callbacks [eventName]) {
			var cb = this.callbacks [eventName] [c];
			cb.apply (this, args);
		}
	},
	on: function (eventName, callback) {
		if (!this.callbacks [eventName]) this.callbacks [eventName] = [];
		this.callbacks [eventName].push (callback);
		return this;
	}

};

$(document).ready (function () { 
	//$(this).foundation ();	
	var conf = {
		data: { 
			/*
			counties: {
				type: d3.json, 
				url: "/data/shapes/counties.json", 
				id: "counties",
				key: "ma_counties",
				enumerator: "geometries",
				idProperty: "FIPS_ID"
			},
			*/
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
			boundaries: {
				type: d3.json, 
				url: "/data/boston_blockgroups_boundaries.json", 
				id: "boundaries",
				key: "stdin",
				enumerator: "geometries",
				idProperty: function (x) { return x.properties.a_gid + "_" + x.properties.b_gid; },
			},
			incidents: {
				type: d3.csv,
				id: "incidents",
				url: "/data/incidents.csv",
				processor: function (rows) {
					var n = d3.nest ()
						.key (function (r) { return r.description; })
						.key (function (r) { return r.ncode; })
						.rollup (function (l) { return l; })
						.entries (rows);
					return n;
				}
			},
			arrests: {
				type: d3.csv,
				id: "arrests",
				processor: function (rows) {
					var d = { blockgroups: {} };
					rows.forEach (function (r) {
							r.cnt = parseInt (r.cnt);
							if (!d.blockgroups [r.gid]) d.blockgroups [r.gid] = {};
							if (!d.blockgroups [r.gid] [r.incident_type_description]) d.blockgroups [r.gid] [r.incident_type_description] = 0;
							d.blockgroups [r.gid] [r.incident_type_description] = r.cnt;
					});
					return d;
				},
				url: "/data/arrests.csv"
			}
		},
		map: {
			//layers: [ "counties", "blockgroups", "boundaries" ],
			layers: [ "blockgroups", "boundaries" ],
			center: {lat:42.319834, lon:-71.087294}
		},
		prequantifiers: {
			incidents: function (sArgs) {
				if (!this.data.incidents.filtered) this.data.incidents.filtered = {};
				var f = this.data.incidents.filter (function (d) { return sArgs.desc == d.key; });
				var data = {};
				if (sArgs.ncode && sArgs.ncode.length > 0) {
					f.forEach (function (a) { 
						var n = a.values.filter (function (d) { return sArgs.ncode.indexOf (d.key) !== -1; });
						n.forEach (function (d) { 
							if (d.values) {
								d.values.forEach (function (d) { 
									if (!data [d.description]) data [d.description] = {};
									if (!data [d.description] [d.gid]) data [d.description] [d.gid] = [];
									var idx = data [d.description] [d.gid].length; 
									if (d.rank > 0) {
										data [d.description] [d.gid] [idx] = d;
									}
								});
							}
						});

					});
					this.data.incidents.filtered = data;
				}
			}
		},
		quantifiers: {
			incidents: function (a, args) {
				var x = a.properties;
				console.log (args);
				if  (this.data.incidents.filtered [args.desc]) { 
					if (this.data.incidents.filtered [args.desc] [x.gid]) {
						var data = this.data.incidents.filtered [args.desc] [x.gid];
						if (data.length > 0) {
							var d = null;
							if (x.white > x.black && x.white > x.poc) d = "white";
							if (x.black > x.white && x.black > x.poc) d = "black";
							if (x.poc > x.black && x.poc > x.white) d = "poc";
							var q = d3.scale.quantile ().domain ([0, 3]).range (d3.range (4).map (function (i) { return i; }));
							var ranks = [];
							data.forEach (function (d) { ranks [ranks.length] = d.rank; });
							var r = d + " q" + q (d3.mean (ranks)) + "-4";	
							return r;
						}
					}
				}
			},
			arrests: function (a, crime) { 
				var x = a.properties;
				if (this.data.arrests.blockgroups [x.gid]) {
					var total = x.white + x.black + x.poc;
					var d = null;
					if (x.white > x.black && x.white > x.poc) d = "white";
					if (x.black > x.white && x.black > x.poc) d = "black";
					if (x.poc > x.black && x.poc > x.white) d = "poc";
					var cnt = this.data.arrests.blockgroups [x.gid] [crime] ? this.data.arrests.blockgroups [x.gid] [crime] : 0;
					var q = d3.scale.quantile ().domain ([0, 1]).range (d3.range (4).map (function (i) { return i; }));

					return d + " q" + q ((cnt / total) * 100) + "-4"; 
				}
			},
			delta_white: function (a) { 
				var x = a.properties;
				var d = (x.a_white - x.b_white) * 100;
				if (d > 0) {
					//return "l13-4";
					var q = d3.scale.quantile ().domain ([0, 15, 30]).range (d3.range (4).map (function (i) { return i; }));
					return "l1" + q(d) + "-4";
				}
			},
			racial: function (a) {
				var x = a.properties;
				var total = x.white + x.black + x.poc;
				var d = null;
				if (x.white > x.black && x.white > x.poc) d = "white";
				if (x.black > x.white && x.black > x.poc) d = "black";
				if (x.poc > x.black && x.poc > x.white) d = "poc";
				var q = d3.scale.quantize ().domain ([0, 100]).range (d3.range (4).map (function (i) { return i; }));
				if (d != null) {

					return d + " q" + q ((x [d] * 100) / total) + "-4";
				}
			},
			whiteness: function (a) {
				var x = a.properties;
				var total = x.white + x.black + x.poc;
				var q = d3.scale.quantize ().domain ([0, 100]).range (d3.range (4).map (function (i) { return i; }));
				return "white q" + q ((x.white * 100) / total) + "-4"; 
			},
			blackness: function (a) {
				var x = a.properties;
				var total = x.white + x.black + x.poc;
				var q = d3.scale.quantize ().domain ([0, 100]).range (d3.range (4).map (function (i) { return i; }));
				return "black q" + q ((x.black * 100) / total) + "-4"; 
			},
			poc: function (a) { 
				var x = a.properties;
				var total = x.white + x.black + x.poc;
				var q = d3.scale.quantize ().domain ([0, 100]).range (d3.range (4).map (function (i) { return i;}));
				return "poc q" + q ((x.poc * 100) / total) + "-4";
			}
		}, 
		labelers: {
			whiteness: {
				layer: "blockgroups", 
				labeler: function (a) { 
					var x = a.properties; 
					var total = x.white + x.black + x.poc;
					return Math.floor ((x.white * 100) / total) + "%"; 
				} 
			}, 
			blackness: {
				layer: "blockgroups", 
				labeler: function (a) { 
					var x = a.properties; 
					var total = x.white + x.black + x.poc;
					return Math.floor ((x.black * 100) / total) + "%"; 
				} 
			}
		},
	};

	var coord = new Coordinator (conf);

});
