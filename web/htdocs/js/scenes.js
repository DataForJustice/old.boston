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
	parseElement: function (element) {
	      var clear = $(element).data ("clear");
	      if (clear) {
		      var layers = clear.split(',');
		      for (var l in layers) {
			      this.quantify (layers [l.trim()]);
		      }
	      }
	      var quantify = $(element).data ("quantify");
	      var quantifier = $(element).data ("quantifier");
	      var qArgs = $(element).data ("quantifier_args")
		      if (quantify && quantifier) {
			      this.quantify (quantify, {fn: quantifier, ar: qArgs});
		      }
	      var zoomTo = $(element).data ("zoom_to");
	      var zoomLevel = $(element).data ("zoom_level"); 
	      var zoomTo = $(element).data("zoom_to"); 
	      var zoomLevel = $(element).data ("zoom_level");
	      if (zoomTo) {
		      this.map.zoomTo ("#" + zoomTo, zoomLevel);
	      }
	},
	scrollLeave: function (element) {
		this.currentElement = null; 
	},
	scrollProgress: function (element) {
		if (element.id == this.currentElement) {
		}
	},
	scrollEnter: function (element) {
		$(element.parentNode).children ().removeClass ("highlight");
		$(element).addClass ("highlight");
		this.parseElement (element);
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

		var lbl = labeler ? {fn: labeler.fn, context: this, args: labeler.ar} : null;
		var qn = quantifier ? {fn: q, context: this, args: quantifier.ar} : null;
		if (!this.map.topologies[layer]) throw "No layer: "+layer;
		this.map.topologies [layer].redraw (this.setFeatureId (l), qn, lbl);
		this.map.reZoom ();
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
		$("form[data-control]").change({me: this},
			function (a) {
				var args = {};
				$.each ($(this).find (":input").serializeArray (), function (_, kv) { if (kv.value != "IGNORE") { args [kv.name] = kv.value; } });
				$(this).data ("quantifier_args", args);
				a.data.me.parseElement.apply (a.data.me, [this]);
			}
		);
		$("select[data-control]").change ({me: this},
			function (a) {
				a.data.me.parseElement.apply (a.data.me, [$(this).children (":selected")]);
			}
		)
		$("a[data-control]").click ({me: this}, 
			function (a) { 
				var x = a.data.me;
				x.parseElement.apply (x, [this]);
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
			var hook = 0.2;
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
		if (ev.type == "progress") {
			var elm = ev.target.triggerElement ();
			this.trigger ("scene_progress", [elm]);
		}
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
			counties: {
				type: d3.json, 
				url: "/data/ma_counties.json", 
				id: "counties",
				key: "stdin",
				enumerator: "geometries",
				idProperty: "id"
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
			fios: {
				type: d3.csv,
				url: "data/fios_by_neighborhood.csv",
				id: "fios",
			},
			neighborhoods: {
				type: d3.json,
				url: "/data/neighborhoods.json",
				id: "neighborhoods",
				key: "stdin",
				idProperty: function (d) { return d.properties.name.replace ('/', ' ').replace(' ', '_').toLowerCase (); },
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
			/*
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
			*/
		},
		map: {
			layers: [ "counties", "blockgroups", "neighborhoods" ],
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
			},
			fios: function (args) {
				var n = d3.nest ();
				n = n.key (function (r) {  return r.neighborhood.toLowerCase ().replace (' ', '_').replace ('/', '_'); });
				if (args) {
					var keys = [];
					for (x in args) {
						keys [keys.length] = x;
					}
					keys.forEach (function (key) {
						n = n.key (function (r) {  return r [key]; }); 
					});
				}
				var counts  = [];
				n = n.rollup (function (l) { var t = d3.sum (l, function (r) { return r.count }); counts.push (t); return t;});
				n = n.map (this.data.fios);
				this.data.fios_nest = n;
				this.data.fios_nest.total = d3.sum (counts);
				this.data.fios_nest.mean = d3.mean (counts);
				this.data.fios_nest.min = d3.min (counts);
				this.data.fios_nest.max = d3.max (counts);

			}
		},
		quantifiers: {
			counties: function (a) { return "county"; },
			incidents: function (a, args) {
				var x = a.properties;
				if  (this.data.incidents.filtered [args.desc]) { 
					var data = this.data.incidents.filtered [args.desc] [x.gid];
					var d = null;
					if (x.white > x.black && x.white > x.poc) d = "white";
					if (x.black > x.white && x.black > x.poc) d = "black";
					if (x.poc > x.black && x.poc > x.white) d = "poc";
					var total = x.white + x.black + x.poc;
					var qr = d3.scale.quantize ().domain ([0, 100]).range (d3.range (4).map (function (i) { return i; }));
					if (this.data.incidents.filtered [args.desc] [x.gid]) {
						if (data.length > 0) {
							var q = d3.scale.quantile ().domain ([0, 4]).range (d3.range (3).map (function (i) { return i; }));
							var ranks = [];
							data.forEach (function (d) { ranks [ranks.length] = d.rank; });
							//var r = d + " q" + qr ((x [d] * 100) / total) + "-4 dq" + q (d3.mean (ranks)) + "-3"; 
							var r = d + " aq" + q (d3.mean (ranks)) + "-4";
							return {"class": r, "text": Math.ceil (d3.mean (ranks)) + "σx̅"};
						}
					}
					return {"class": d + " border"};
				}
			},
			fios: function (nb, args) {
				var x = nb.properties;
				var name = x.name.toLowerCase ().replace (' ', '_').replace ('/', '_');
				if (this.data.fios_nest [name]) {
					console.log (this.data.fios_nest);
					var qr = d3.scale.quantize ().domain ([this.data.fios_nest.min, this.data.fios_nest.max]).range (d3.range (4).map (function (i) { return i; }));
					if (args) {
						//TODO: make this dynamic so I dont have to write every case... 
						if (args.year && args.race) {
							var cnt = this.data.fios_nest [name] [args.year] [args.race];
							return {"class": "aq" + qr (cnt) + "-4", "text": cnt};
						}
						if (args.year) {
							var inc = this.data.fios_nest [name] [args.year] > this.data.fios_nest [name] [args.year - 1];
							var cnt = this.data.fios_nest [name] [args.year];
							return {"class": (inc ? "increase" : "decrease") + " aq" + qr (cnt) + "-4", "text": cnt};

						}
						if (args.race) {
							var cnt = this.data.fios_nest [name] [args.race];
							return {"class": "aq" + qr (cnt) + "-4", "text": cnt};
						}
					}
					var cnt = this.data.fios_nest [name];
					return {"class": "aq" + qr (cnt) + "-4", "text": cnt};
				};
			},
			arrests: function (a, crime) { 
				var x = a.properties;
				if (this.data.arrests.blockgroups [x.gid]) {
					var total = x.white + x.black + x.poc;
					var d = null;
					if (x.white > x.black && x.white > x.poc) d = "white";
					if (x.black > x.white && x.black > x.poc) d = "black";
					if (x.poc > x.black && x.poc > x.white) d = "poc";
					var total = x.white + x.black + x.poc;
					var cnt = this.data.arrests.blockgroups [x.gid] [crime] ? this.data.arrests.blockgroups [x.gid] [crime] : 0;
					var qr = d3.scale.quantize ().domain ([0, 100]).range (d3.range (4).map (function (i) { return i; }));
					var q = d3.scale.quantile ().domain ([0, 1]).range (d3.range (3).map (function (i) { return i; }));

					return d + " q" + qr ((x[d] / total) * 100) + "-4 q" + q((cnt /total) * 100) + "-3 border"; 
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

					return {"class": d + " q" + q ((x [d] * 100) / total) + "-4 border"};
				}
			},
			race: function (a, r) {
				var race = r.race;
				var x = a.properties;
				var total = x.white + x.black + x.poc;
				var q = d3.scale.quantize ().domain ([0, 100]).range (d3.range (4).map (function (i) { return i; }));

				var pct = (x [race] * 100) / total;
				return { "class": race + " q" + q (pct)+ "-4 border", "text": Math.round (pct,1) + "%" };
			}
		}
	};

	var coord = new Coordinator (conf);

});
