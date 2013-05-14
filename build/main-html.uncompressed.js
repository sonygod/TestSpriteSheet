(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var Lambda = function() { }
Lambda.__name__ = true;
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
var IMap = function() { }
IMap.__name__ = true;
var Reflect = function() { }
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	addSub: function(s,pos,len) {
		this.b += len == null?HxOverrides.substr(s,pos,null):HxOverrides.substr(s,pos,len);
	}
	,__class__: StringBuf
}
var TestSpriteSheet = function() { }
TestSpriteSheet.__name__ = true;
TestSpriteSheet.main = function() {
	flambe.System.init();
	flambe.System.hidden.get_changed().connect(function(hidden,wasHidden) {
		null;
	});
	var manifest = flambe.asset.Manifest.build("bootstrap");
	var loader = flambe.System._platform.loadAssetPack(manifest);
	loader.get(TestSpriteSheet.onSuccess);
	loader.error.connect(function(message) {
		null;
	});
	loader.progressChanged.connect(function() {
		null;
	});
}
TestSpriteSheet.onSuccess = function(pack) {
	flambe.System.root.addChild(new flambe.Entity().add(new flambe.display.FillSprite(3158064,flambe.System._platform.getStage().get_width(),flambe.System._platform.getStage().get_height())));
	var ts = new flambe.display.tileSheet.TileSheetHelper();
	var ats = ts.prepareAnimTexture(pack.getFile("remiWalk.json",true));
	var _g = 0;
	while(_g < 500) {
		var ii = _g++;
		var tentacle = new flambe.Entity();
		var $as = new flambe.display.tileSheet.AnimSprite(pack.getTexture("remiWalk"));
		$as.initialize(ats);
		$as.addSequence("all",[0,1,2,3,4,5,6,7,8,9,10,11],24);
		$as.play("all");
		$as.centerAnchor();
		tentacle.add($as);
		var sprite = tentacle._compMap.Sprite_1;
		sprite.x.set__(Math.random() * (flambe.System._platform.getStage().get_width() - sprite.getNaturalWidth()));
		sprite.y.set__(Math.random() * (flambe.System._platform.getStage().get_height() - sprite.getNaturalHeight()));
		flambe.System.root.addChild(tentacle);
	}
	var font = new flambe.display.Font(pack,"tinyfont");
	flambe.System.root.addChild(new flambe.Entity().add(new flambe.display.TextSprite(font)).add(new flambe.debug.FpsDisplay()));
}
var flambe = {}
flambe.util = {}
flambe.util.Disposable = function() { }
flambe.util.Disposable.__name__ = true;
flambe.Component = function() { }
flambe.Component.__name__ = true;
flambe.Component.__interfaces__ = [flambe.util.Disposable];
flambe.Component.prototype = {
	init: function(owner,next) {
		this.owner = owner;
		this.next = next;
	}
	,get_name: function() {
		return null;
	}
	,dispose: function() {
		if(this.owner != null) this.owner.remove(this);
	}
	,onUpdate: function(dt) {
	}
	,onRemoved: function() {
	}
	,onAdded: function() {
	}
	,__class__: flambe.Component
}
flambe.Entity = function() {
	this.firstComponent = null;
	this.next = null;
	this.firstChild = null;
	this.parent = null;
	this._compMap = { };
};
flambe.Entity.__name__ = true;
flambe.Entity.__interfaces__ = [flambe.util.Disposable];
flambe.Entity.prototype = {
	dispose: function() {
		if(this.parent != null) this.parent.removeChild(this);
		while(this.firstComponent != null) this.firstComponent.dispose();
		this.disposeChildren();
	}
	,disposeChildren: function() {
		while(this.firstChild != null) this.firstChild.dispose();
	}
	,removeChild: function(entity) {
		var prev = null, p = this.firstChild;
		while(p != null) {
			var next = p.next;
			if(p == entity) {
				if(prev == null) this.firstChild = next; else prev.next = next;
				p.parent = null;
				p.next = null;
				return;
			}
			prev = p;
			p = next;
		}
	}
	,addChild: function(entity,append) {
		if(append == null) append = true;
		if(entity.parent != null) entity.parent.removeChild(entity);
		entity.parent = this;
		if(append) {
			var tail = null, p = this.firstChild;
			while(p != null) {
				tail = p;
				p = p.next;
			}
			if(tail != null) tail.next = entity; else this.firstChild = entity;
		} else {
			entity.next = this.firstChild;
			this.firstChild = entity;
		}
		return this;
	}
	,remove: function(component) {
		var prev = null, p = this.firstComponent;
		while(p != null) {
			var next = p.next;
			if(p == component) {
				if(prev == null) this.firstComponent = next; else prev.init(this,next);
				delete(this._compMap[p.get_name()]);
				p.onRemoved();
				p.init(null,null);
				return;
			}
			prev = p;
			p = next;
		}
	}
	,add: function(component) {
		component.dispose();
		var name = component.get_name();
		var prev = this._compMap[name];
		if(prev != null) this.remove(prev);
		this._compMap[name] = component;
		var tail = null, p = this.firstComponent;
		while(p != null) {
			tail = p;
			p = p.next;
		}
		if(tail != null) tail.next = component; else this.firstComponent = component;
		component.init(this,null);
		component.onAdded();
		return this;
	}
	,__class__: flambe.Entity
}
flambe.platform = {}
flambe.platform.Platform = function() { }
flambe.platform.Platform.__name__ = true;
flambe.platform.Platform.prototype = {
	__class__: flambe.platform.Platform
}
flambe.platform.html = {}
flambe.platform.html.HtmlPlatform = function() {
};
flambe.platform.html.HtmlPlatform.__name__ = true;
flambe.platform.html.HtmlPlatform.__interfaces__ = [flambe.platform.Platform];
flambe.platform.html.HtmlPlatform.prototype = {
	createRenderer: function(canvas) {
		return new flambe.platform.html.CanvasRenderer(canvas);
	}
	,getY: function(event,bounds) {
		return this._stage.scaleFactor * (event.clientY - bounds.top);
	}
	,getX: function(event,bounds) {
		return this._stage.scaleFactor * (event.clientX - bounds.left);
	}
	,getRenderer: function() {
		return this._renderer;
	}
	,update: function(now) {
		var dt = (now - this._lastUpdate) / 1000;
		this._lastUpdate = now;
		if(this._skipFrame) {
			this._skipFrame = false;
			return;
		}
		this.mainLoop.update(dt);
		this.mainLoop.render(this._renderer);
	}
	,getStage: function() {
		return this._stage;
	}
	,loadAssetPack: function(manifest) {
		return new flambe.platform.html.HtmlAssetPackLoader(this,manifest).promise;
	}
	,init: function() {
		var _g = this;
		var canvas = null;
		try {
			canvas = js.Browser.window.flambe.canvas;
		} catch( error ) {
		}
		canvas.setAttribute("tabindex","0");
		canvas.style.outlineStyle = "none";
		canvas.setAttribute("moz-opaque","true");
		this._stage = new flambe.platform.html.HtmlStage(canvas);
		this._pointer = new flambe.platform.BasicPointer();
		this._mouse = new flambe.platform.html.HtmlMouse(this._pointer,canvas);
		this._keyboard = new flambe.platform.BasicKeyboard();
		this._renderer = this.createRenderer(canvas);
		flambe.System.hasGPU.set__(true);
		this.mainLoop = new flambe.platform.MainLoop();
		this._container = canvas.parentElement;
		this._container.style.overflow = "hidden";
		this._container.style.position = "relative";
		this._container.style.msTouchAction = "none";
		var lastTouchTime = 0;
		var onMouse = function(event) {
			if(event.timeStamp - lastTouchTime < 1000) return;
			var bounds = canvas.getBoundingClientRect();
			var x = _g.getX(event,bounds);
			var y = _g.getY(event,bounds);
			switch(event.type) {
			case "mousedown":
				if(event.target == canvas) {
					event.preventDefault();
					_g._mouse.submitDown(x,y,event.button);
					canvas.focus();
				}
				break;
			case "mousemove":
				_g._mouse.submitMove(x,y);
				break;
			case "mouseup":
				_g._mouse.submitUp(x,y,event.button);
				break;
			case "mousewheel":case "DOMMouseScroll":
				var velocity = event.type == "mousewheel"?event.wheelDelta / 40:-event.detail;
				if(_g._mouse.submitScroll(x,y,velocity)) event.preventDefault();
				break;
			}
		};
		js.Browser.window.addEventListener("mousedown",onMouse,false);
		js.Browser.window.addEventListener("mousemove",onMouse,false);
		js.Browser.window.addEventListener("mouseup",onMouse,false);
		canvas.addEventListener("mousewheel",onMouse,false);
		canvas.addEventListener("DOMMouseScroll",onMouse,false);
		var standardTouch = typeof(js.Browser.window.ontouchstart) != "undefined";
		var msTouch = 'msMaxTouchPoints' in window.navigator && (window.navigator.msMaxTouchPoints > 1);
		if(standardTouch || msTouch) {
			var basicTouch = new flambe.platform.BasicTouch(this._pointer,standardTouch?4:js.Browser.navigator.msMaxTouchPoints);
			this._touch = basicTouch;
			var onTouch = function(event) {
				var changedTouches = standardTouch?event.changedTouches:[event];
				var bounds = event.target.getBoundingClientRect();
				lastTouchTime = event.timeStamp;
				switch(event.type) {
				case "touchstart":case "MSPointerDown":
					event.preventDefault();
					if(flambe.platform.html.HtmlUtil.SHOULD_HIDE_MOBILE_BROWSER) flambe.platform.html.HtmlUtil.hideMobileBrowser();
					var _g1 = 0;
					while(_g1 < changedTouches.length) {
						var touch = changedTouches[_g1];
						++_g1;
						var x = _g.getX(touch,bounds);
						var y = _g.getY(touch,bounds);
						var id = (standardTouch?touch.identifier:touch.pointerId) | 0;
						basicTouch.submitDown(id,x,y);
					}
					break;
				case "touchmove":case "MSPointerMove":
					event.preventDefault();
					var _g1 = 0;
					while(_g1 < changedTouches.length) {
						var touch = changedTouches[_g1];
						++_g1;
						var x = _g.getX(touch,bounds);
						var y = _g.getY(touch,bounds);
						var id = (standardTouch?touch.identifier:touch.pointerId) | 0;
						basicTouch.submitMove(id,x,y);
					}
					break;
				case "touchend":case "touchcancel":case "MSPointerUp":
					var _g1 = 0;
					while(_g1 < changedTouches.length) {
						var touch = changedTouches[_g1];
						++_g1;
						var x = _g.getX(touch,bounds);
						var y = _g.getY(touch,bounds);
						var id = (standardTouch?touch.identifier:touch.pointerId) | 0;
						basicTouch.submitUp(id,x,y);
					}
					break;
				}
			};
			if(standardTouch) {
				canvas.addEventListener("touchstart",onTouch,false);
				canvas.addEventListener("touchmove",onTouch,false);
				canvas.addEventListener("touchend",onTouch,false);
				canvas.addEventListener("touchcancel",onTouch,false);
			} else {
				canvas.addEventListener("MSPointerDown",onTouch,false);
				canvas.addEventListener("MSPointerMove",onTouch,false);
				canvas.addEventListener("MSPointerUp",onTouch,false);
			}
		} else this._touch = new flambe.platform.DummyTouch();
		var onKey = function(event) {
			switch(event.type) {
			case "keydown":
				if(_g._keyboard.submitDown(event.keyCode)) event.preventDefault();
				break;
			case "keyup":
				_g._keyboard.submitUp(event.keyCode);
				break;
			}
		};
		canvas.addEventListener("keydown",onKey,false);
		canvas.addEventListener("keyup",onKey,false);
		var oldErrorHandler = js.Browser.window.onerror;
		js.Browser.window.onerror = function(message,url,line) {
			flambe.System.uncaughtError.emit1(message);
			return oldErrorHandler != null?oldErrorHandler(message,url,line):false;
		};
		var hiddenApi = flambe.platform.html.HtmlUtil.loadExtension("hidden",js.Browser.document);
		if(hiddenApi.value != null) {
			var onVisibilityChanged = function(_) {
				flambe.System.hidden.set__(Reflect.field(js.Browser.document,hiddenApi.field));
			};
			onVisibilityChanged(null);
			js.Browser.document.addEventListener(hiddenApi.prefix + "visibilitychange",onVisibilityChanged,false);
			flambe.System.hidden.get_changed().connect(function(hidden,_) {
				if(!hidden) _g._skipFrame = true;
			});
		}
		this._lastUpdate = Date.now();
		this._skipFrame = false;
		var requestAnimationFrame = flambe.platform.html.HtmlUtil.loadExtension("requestAnimationFrame").value;
		if(requestAnimationFrame != null) {
			var performance = js.Browser.window.performance;
			var hasPerfNow = performance != null && flambe.platform.html.HtmlUtil.polyfill("now",performance);
			if(hasPerfNow) this._lastUpdate = performance.now(); else null;
			var updateFrame = null;
			updateFrame = function(now) {
				_g.update(hasPerfNow?performance.now():now);
				requestAnimationFrame(updateFrame,canvas);
			};
			requestAnimationFrame(updateFrame,canvas);
		} else js.Browser.window.setInterval(function() {
			_g.update(Date.now());
		},16);
	}
	,__class__: flambe.platform.html.HtmlPlatform
}
flambe.util.Value = function(value,listener) {
	this._value = value;
	if(listener != null) this._changed = new flambe.util.Signal2(listener);
};
flambe.util.Value.__name__ = true;
flambe.util.Value.prototype = {
	get_changed: function() {
		if(this._changed == null) this._changed = new flambe.util.Signal2();
		return this._changed;
	}
	,set__: function(newValue) {
		var oldValue = this._value;
		if(newValue != oldValue) {
			this._value = newValue;
			if(this._changed != null) this._changed.emit2(newValue,oldValue);
		}
		return newValue;
	}
	,watch: function(listener) {
		listener(this._value,this._value);
		return this.get_changed().connect(listener);
	}
	,__class__: flambe.util.Value
}
flambe.util.SignalConnection = function(signal,listener) {
	this._next = null;
	this._signal = signal;
	this._listener = listener;
	this.stayInList = true;
};
flambe.util.SignalConnection.__name__ = true;
flambe.util.SignalConnection.__interfaces__ = [flambe.util.Disposable];
flambe.util.SignalConnection.prototype = {
	dispose: function() {
		if(this._signal != null) {
			this._signal.disconnect(this);
			this._signal = null;
		}
	}
	,once: function() {
		this.stayInList = false;
		return this;
	}
	,__class__: flambe.util.SignalConnection
}
flambe.util.SignalBase = function(listener) {
	this._head = listener != null?new flambe.util.SignalConnection(this,listener):null;
	this._deferredTasks = null;
};
flambe.util.SignalBase.__name__ = true;
flambe.util.SignalBase.prototype = {
	listRemove: function(conn) {
		var prev = null, p = this._head;
		while(p != null) {
			if(p == conn) {
				var next = p._next;
				if(prev == null) this._head = next; else prev._next = next;
				return;
			}
			prev = p;
			p = p._next;
		}
	}
	,listAdd: function(conn,prioritize) {
		if(prioritize) {
			conn._next = this._head;
			this._head = conn;
		} else {
			var tail = null, p = this._head;
			while(p != null) {
				tail = p;
				p = p._next;
			}
			if(tail != null) tail._next = conn; else this._head = conn;
		}
	}
	,didEmit: function(head) {
		this._head = head;
		while(this._deferredTasks != null) {
			this._deferredTasks.fn();
			this._deferredTasks = this._deferredTasks.next;
		}
	}
	,willEmit: function() {
		var snapshot = this._head;
		this._head = flambe.util.SignalBase.DISPATCHING_SENTINEL;
		return snapshot;
	}
	,defer: function(fn) {
		var tail = null, p = this._deferredTasks;
		while(p != null) {
			tail = p;
			p = p.next;
		}
		var task = new flambe.util._SignalBase.Task(fn);
		if(tail != null) tail.next = task; else this._deferredTasks = task;
	}
	,emit2: function(arg1,arg2) {
		var head = this.willEmit();
		var p = head;
		while(p != null) {
			p._listener(arg1,arg2);
			if(!p.stayInList) p.dispose();
			p = p._next;
		}
		this.didEmit(head);
	}
	,emit1: function(arg1) {
		var head = this.willEmit();
		var p = head;
		while(p != null) {
			p._listener(arg1);
			if(!p.stayInList) p.dispose();
			p = p._next;
		}
		this.didEmit(head);
	}
	,emit0: function() {
		var head = this.willEmit();
		var p = head;
		while(p != null) {
			p._listener();
			if(!p.stayInList) p.dispose();
			p = p._next;
		}
		this.didEmit(head);
	}
	,disconnect: function(conn) {
		var _g = this;
		if(this._head == flambe.util.SignalBase.DISPATCHING_SENTINEL) this.defer(function() {
			_g.listRemove(conn);
		}); else this.listRemove(conn);
	}
	,connectImpl: function(listener,prioritize) {
		var _g = this;
		var conn = new flambe.util.SignalConnection(this,listener);
		if(this._head == flambe.util.SignalBase.DISPATCHING_SENTINEL) this.defer(function() {
			_g.listAdd(conn,prioritize);
		}); else this.listAdd(conn,prioritize);
		return conn;
	}
	,__class__: flambe.util.SignalBase
}
flambe.util.Signal2 = function(listener) {
	flambe.util.SignalBase.call(this,listener);
};
flambe.util.Signal2.__name__ = true;
flambe.util.Signal2.__super__ = flambe.util.SignalBase;
flambe.util.Signal2.prototype = $extend(flambe.util.SignalBase.prototype,{
	connect: function(listener,prioritize) {
		if(prioritize == null) prioritize = false;
		return this.connectImpl(listener,prioritize);
	}
	,__class__: flambe.util.Signal2
});
flambe.util.Signal1 = function(listener) {
	flambe.util.SignalBase.call(this,listener);
};
flambe.util.Signal1.__name__ = true;
flambe.util.Signal1.__super__ = flambe.util.SignalBase;
flambe.util.Signal1.prototype = $extend(flambe.util.SignalBase.prototype,{
	connect: function(listener,prioritize) {
		if(prioritize == null) prioritize = false;
		return this.connectImpl(listener,prioritize);
	}
	,__class__: flambe.util.Signal1
});
flambe.animation = {}
flambe.animation.AnimatedFloat = function(value,listener) {
	flambe.util.Value.call(this,value,listener);
};
flambe.animation.AnimatedFloat.__name__ = true;
flambe.animation.AnimatedFloat.__super__ = flambe.util.Value;
flambe.animation.AnimatedFloat.prototype = $extend(flambe.util.Value.prototype,{
	update: function(dt) {
		if(this._behavior != null) {
			flambe.util.Value.prototype.set__.call(this,this._behavior.update(dt));
			if(this._behavior.isComplete()) this._behavior = null;
		}
	}
	,set__: function(value) {
		this._behavior = null;
		return flambe.util.Value.prototype.set__.call(this,value);
	}
	,__class__: flambe.animation.AnimatedFloat
});
flambe.System = function() { }
flambe.System.__name__ = true;
flambe.System.init = function() {
	if(!flambe.System._calledInit) {
		flambe.System._platform.init();
		flambe.System._calledInit = true;
	}
}
flambe.SpeedAdjuster = function() {
	this._realDt = 0;
};
flambe.SpeedAdjuster.__name__ = true;
flambe.SpeedAdjuster.__super__ = flambe.Component;
flambe.SpeedAdjuster.prototype = $extend(flambe.Component.prototype,{
	onUpdate: function(dt) {
		if(this._realDt > 0) {
			dt = this._realDt;
			this._realDt = 0;
		}
		this.scale.update(dt);
	}
	,get_name: function() {
		return "SpeedAdjuster_5";
	}
	,__class__: flambe.SpeedAdjuster
});
flambe.animation.Behavior = function() { }
flambe.animation.Behavior.__name__ = true;
flambe.animation.Behavior.prototype = {
	__class__: flambe.animation.Behavior
}
flambe.asset = {}
flambe.asset.AssetFormat = { __ename__ : true, __constructs__ : ["WEBP","JXR","PNG","JPG","GIF","MP3","M4A","OGG","WAV","Data"] }
flambe.asset.AssetFormat.WEBP = ["WEBP",0];
flambe.asset.AssetFormat.WEBP.toString = $estr;
flambe.asset.AssetFormat.WEBP.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.JXR = ["JXR",1];
flambe.asset.AssetFormat.JXR.toString = $estr;
flambe.asset.AssetFormat.JXR.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.PNG = ["PNG",2];
flambe.asset.AssetFormat.PNG.toString = $estr;
flambe.asset.AssetFormat.PNG.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.JPG = ["JPG",3];
flambe.asset.AssetFormat.JPG.toString = $estr;
flambe.asset.AssetFormat.JPG.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.GIF = ["GIF",4];
flambe.asset.AssetFormat.GIF.toString = $estr;
flambe.asset.AssetFormat.GIF.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.MP3 = ["MP3",5];
flambe.asset.AssetFormat.MP3.toString = $estr;
flambe.asset.AssetFormat.MP3.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.M4A = ["M4A",6];
flambe.asset.AssetFormat.M4A.toString = $estr;
flambe.asset.AssetFormat.M4A.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.OGG = ["OGG",7];
flambe.asset.AssetFormat.OGG.toString = $estr;
flambe.asset.AssetFormat.OGG.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.WAV = ["WAV",8];
flambe.asset.AssetFormat.WAV.toString = $estr;
flambe.asset.AssetFormat.WAV.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.Data = ["Data",9];
flambe.asset.AssetFormat.Data.toString = $estr;
flambe.asset.AssetFormat.Data.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetEntry = function(name,url,format,bytes) {
	this.name = name;
	this.url = url;
	this.format = format;
	this.bytes = bytes;
};
flambe.asset.AssetEntry.__name__ = true;
flambe.asset.AssetEntry.prototype = {
	__class__: flambe.asset.AssetEntry
}
flambe.asset.AssetPack = function() { }
flambe.asset.AssetPack.__name__ = true;
flambe.asset.AssetPack.prototype = {
	__class__: flambe.asset.AssetPack
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
flambe.util.Strings = function() { }
flambe.util.Strings.__name__ = true;
flambe.util.Strings.getFileExtension = function(fileName) {
	var dot = fileName.lastIndexOf(".");
	return dot > 0?HxOverrides.substr(fileName,dot + 1,null):null;
}
flambe.util.Strings.removeFileExtension = function(fileName) {
	var dot = fileName.lastIndexOf(".");
	return dot > 0?HxOverrides.substr(fileName,0,dot):fileName;
}
flambe.util.Strings.getUrlExtension = function(url) {
	var question = url.lastIndexOf("?");
	if(question >= 0) url = HxOverrides.substr(url,0,question);
	var slash = url.lastIndexOf("/");
	if(slash >= 0) url = HxOverrides.substr(url,slash + 1,null);
	return flambe.util.Strings.getFileExtension(url);
}
flambe.util.Strings.joinPath = function(base,relative) {
	if(base.charCodeAt(base.length - 1) != 47) base += "/";
	return base + relative;
}
flambe.util.Strings.withFields = function(message,fields) {
	var ll = fields.length;
	if(ll > 0) {
		message += message.length > 0?" [":"[";
		var ii = 0;
		while(ii < ll) {
			if(ii > 0) message += ", ";
			var name = fields[ii];
			var value = fields[ii + 1];
			if(js.Boot.__instanceof(value,Error)) {
				var stack = value.stack;
				if(stack != null) value = stack;
			}
			message += name + "=" + Std.string(value);
			ii += 2;
		}
		message += "]";
	}
	return message;
}
js.Browser = function() { }
js.Browser.__name__ = true;
flambe.asset.Manifest = function() {
	this._entries = [];
};
flambe.asset.Manifest.__name__ = true;
flambe.asset.Manifest.build = function(packName,required) {
	if(required == null) required = true;
	var manifest = flambe.asset.Manifest._buildManifest.get(packName);
	if(manifest == null) {
		if(required) throw flambe.util.Strings.withFields("Missing asset pack",["name",packName]);
		return null;
	}
	return manifest.clone();
}
flambe.asset.Manifest.inferFormat = function(url) {
	var extension = flambe.util.Strings.getUrlExtension(url);
	if(extension != null) {
		var _g = extension.toLowerCase();
		switch(_g) {
		case "gif":
			return flambe.asset.AssetFormat.GIF;
		case "jpg":case "jpeg":
			return flambe.asset.AssetFormat.JPG;
		case "jxr":
			return flambe.asset.AssetFormat.JXR;
		case "png":
			return flambe.asset.AssetFormat.PNG;
		case "webp":
			return flambe.asset.AssetFormat.WEBP;
		case "m4a":
			return flambe.asset.AssetFormat.M4A;
		case "mp3":
			return flambe.asset.AssetFormat.MP3;
		case "ogg":
			return flambe.asset.AssetFormat.OGG;
		case "wav":
			return flambe.asset.AssetFormat.WAV;
		}
	} else null;
	return flambe.asset.AssetFormat.Data;
}
flambe.asset.Manifest.createBuildManifests = function() {
	var macroData = new haxe.ds.StringMap();
	macroData.set("bootstrap",[{ name : "tinyfont.png", md5 : "32988b545c4243b364008800f359ea92", bytes : 16702},{ name : "tinyfont.fnt", md5 : "6b1f975607029ae74049de5a34e1c816", bytes : 22499},{ name : "remiWalk.png", md5 : "af5ddf9fb90ee12863e4e0b837ac284e", bytes : 30194},{ name : "remiWalk.json", md5 : "561f11a97e4672c424ed6ddb5dd7f8b8", bytes : 2528},{ name : "box.png", md5 : "3cc1b7e9fd3fea3e2b460eb6fbbba4ff", bytes : 7820},{ name : "ball.png", md5 : "025c34b8e67dbc2969adec7073614b22", bytes : 2964}]);
	var manifests = new haxe.ds.StringMap();
	var $it0 = macroData.keys();
	while( $it0.hasNext() ) {
		var packName = $it0.next();
		var manifest = new flambe.asset.Manifest();
		manifest.set_relativeBasePath("assets");
		var _g = 0, _g1 = macroData.get(packName);
		while(_g < _g1.length) {
			var asset = _g1[_g];
			++_g;
			var name = asset.name;
			var path = packName + "/" + name + "?v=" + Std.string(asset.md5);
			var format = flambe.asset.Manifest.inferFormat(name);
			if(format != flambe.asset.AssetFormat.Data) name = flambe.util.Strings.removeFileExtension(name);
			manifest.add(name,path,asset.bytes,format);
		}
		manifests.set(packName,manifest);
	}
	return manifests;
}
flambe.asset.Manifest.prototype = {
	set_externalBasePath: function(basePath) {
		this._externalBasePath = basePath;
		if(basePath != null) null;
		return basePath;
	}
	,get_externalBasePath: function() {
		return this._externalBasePath;
	}
	,set_relativeBasePath: function(basePath) {
		this._relativeBasePath = basePath;
		if(basePath != null) null;
		return basePath;
	}
	,get_relativeBasePath: function() {
		return this._relativeBasePath;
	}
	,getFullURL: function(entry) {
		var restricted = this.get_externalBasePath() != null && flambe.asset.Manifest._supportsCrossOrigin?this.get_externalBasePath():this.get_relativeBasePath();
		var unrestricted = this.get_externalBasePath() != null?this.get_externalBasePath():this.get_relativeBasePath();
		var base = unrestricted;
		if(entry.format == flambe.asset.AssetFormat.Data) base = restricted;
		return base != null?flambe.util.Strings.joinPath(base,entry.url):entry.url;
	}
	,clone: function() {
		var copy = new flambe.asset.Manifest();
		copy.set_relativeBasePath(this.get_relativeBasePath());
		copy.set_externalBasePath(this.get_externalBasePath());
		copy._entries = this._entries.slice();
		return copy;
	}
	,iterator: function() {
		return HxOverrides.iter(this._entries);
	}
	,add: function(name,url,bytes,format) {
		if(bytes == null) bytes = 0;
		if(format == null) format = flambe.asset.Manifest.inferFormat(url);
		var entry = new flambe.asset.AssetEntry(name,url,format,bytes);
		this._entries.push(entry);
		return entry;
	}
	,__class__: flambe.asset.Manifest
}
flambe.debug = {}
flambe.debug.FpsDisplay = function() {
	this.reset();
};
flambe.debug.FpsDisplay.__name__ = true;
flambe.debug.FpsDisplay.__super__ = flambe.Component;
flambe.debug.FpsDisplay.prototype = $extend(flambe.Component.prototype,{
	reset: function() {
		this._fpsTime = this._fpsFrames = 0;
	}
	,onUpdate: function(dt) {
		++this._fpsFrames;
		this._fpsTime += dt;
		if(this._fpsTime > 1) {
			var fps = this._fpsFrames / this._fpsTime;
			var text = "FPS: " + (fps * 100 | 0) / 100;
			var sprite = this.owner._compMap.Sprite_1;
			if(sprite != null) sprite.set_text(text); else null;
			this.reset();
		}
	}
	,get_name: function() {
		return "FpsDisplay_0";
	}
	,__class__: flambe.debug.FpsDisplay
});
flambe.display = {}
flambe.display.BlendMode = { __ename__ : true, __constructs__ : ["Normal","Add","CopyExperimental"] }
flambe.display.BlendMode.Normal = ["Normal",0];
flambe.display.BlendMode.Normal.toString = $estr;
flambe.display.BlendMode.Normal.__enum__ = flambe.display.BlendMode;
flambe.display.BlendMode.Add = ["Add",1];
flambe.display.BlendMode.Add.toString = $estr;
flambe.display.BlendMode.Add.__enum__ = flambe.display.BlendMode;
flambe.display.BlendMode.CopyExperimental = ["CopyExperimental",2];
flambe.display.BlendMode.CopyExperimental.toString = $estr;
flambe.display.BlendMode.CopyExperimental.__enum__ = flambe.display.BlendMode;
flambe.math = {}
flambe.math.Point = function(x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
};
flambe.math.Point.__name__ = true;
flambe.math.Point.prototype = {
	__class__: flambe.math.Point
}
flambe.display.Sprite = function() {
	this.scissor = null;
	this.blendMode = null;
	var _g = this;
	this._flags = 11;
	this._localMatrix = new flambe.math.Matrix();
	var dirtyMatrix = function(_,_1) {
		_g._flags = _g._flags | 12;
	};
	this.x = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.y = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.rotation = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.scaleX = new flambe.animation.AnimatedFloat(1,dirtyMatrix);
	this.scaleY = new flambe.animation.AnimatedFloat(1,dirtyMatrix);
	this.anchorX = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.anchorY = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.alpha = new flambe.animation.AnimatedFloat(1);
};
flambe.display.Sprite.__name__ = true;
flambe.display.Sprite.hitTest = function(entity,x,y) {
	var sprite = entity._compMap.Sprite_1;
	if(sprite != null) {
		if(!((sprite._flags & 3) == 3)) return null;
		if(sprite.getLocalMatrix().inverseTransform(x,y,flambe.display.Sprite._scratchPoint)) {
			x = flambe.display.Sprite._scratchPoint.x;
			y = flambe.display.Sprite._scratchPoint.y;
		}
		var scissor = sprite.scissor;
		if(scissor != null && !scissor.contains(x,y)) return null;
	}
	var result = flambe.display.Sprite.hitTestBackwards(entity.firstChild,x,y);
	if(result != null) return result;
	return sprite != null && sprite.containsLocal(x,y)?sprite:null;
}
flambe.display.Sprite.render = function(entity,g) {
	var sprite = entity._compMap.Sprite_1;
	if(sprite != null) {
		var alpha = sprite.alpha._value;
		if(!((sprite._flags & 1) != 0) || alpha <= 0) return;
		g.save();
		if(alpha < 1) g.multiplyAlpha(alpha);
		if(sprite.blendMode != null) g.setBlendMode(sprite.blendMode);
		var matrix = sprite.getLocalMatrix();
		g.transform(matrix.m00,matrix.m10,matrix.m01,matrix.m11,matrix.m02,matrix.m12);
		var scissor = sprite.scissor;
		if(scissor != null) g.applyScissor(scissor.x,scissor.y,scissor.width,scissor.height);
		sprite.draw(g);
	}
	var director = entity._compMap.Director_3;
	if(director != null) {
		var scenes = director.occludedScenes;
		var _g = 0;
		while(_g < scenes.length) {
			var scene = scenes[_g];
			++_g;
			flambe.display.Sprite.render(scene,g);
		}
	}
	var p = entity.firstChild;
	while(p != null) {
		var next = p.next;
		flambe.display.Sprite.render(p,g);
		p = next;
	}
	if(sprite != null) g.restore();
}
flambe.display.Sprite.hitTestBackwards = function(entity,x,y) {
	if(entity != null) {
		var result = flambe.display.Sprite.hitTestBackwards(entity.next,x,y);
		return result != null?result:flambe.display.Sprite.hitTest(entity,x,y);
	}
	return null;
}
flambe.display.Sprite.__super__ = flambe.Component;
flambe.display.Sprite.prototype = $extend(flambe.Component.prototype,{
	draw: function(g) {
	}
	,onUpdate: function(dt) {
		this.x.update(dt);
		this.y.update(dt);
		this.rotation.update(dt);
		this.scaleX.update(dt);
		this.scaleY.update(dt);
		this.alpha.update(dt);
		this.anchorX.update(dt);
		this.anchorY.update(dt);
	}
	,centerAnchor: function() {
		this.anchorX.set__(this.getNaturalWidth() / 2);
		this.anchorY.set__(this.getNaturalHeight() / 2);
		return this;
	}
	,getLocalMatrix: function() {
		if((this._flags & 4) != 0) {
			this._flags = this._flags & -5;
			this._localMatrix.compose(this.x._value,this.y._value,this.scaleX._value,this.scaleY._value,this.rotation._value * 3.141592653589793 / 180);
			this._localMatrix.translate(-this.anchorX._value,-this.anchorY._value);
		}
		return this._localMatrix;
	}
	,containsLocal: function(localX,localY) {
		return localX >= 0 && localX < this.getNaturalWidth() && localY >= 0 && localY < this.getNaturalHeight();
	}
	,getNaturalHeight: function() {
		return 0;
	}
	,getNaturalWidth: function() {
		return 0;
	}
	,get_name: function() {
		return "Sprite_1";
	}
	,__class__: flambe.display.Sprite
});
flambe.display.FillSprite = function(color,width,height) {
	flambe.display.Sprite.call(this);
	this.color = color;
	this.width = new flambe.animation.AnimatedFloat(width);
	this.height = new flambe.animation.AnimatedFloat(height);
};
flambe.display.FillSprite.__name__ = true;
flambe.display.FillSprite.__super__ = flambe.display.Sprite;
flambe.display.FillSprite.prototype = $extend(flambe.display.Sprite.prototype,{
	onUpdate: function(dt) {
		flambe.display.Sprite.prototype.onUpdate.call(this,dt);
		this.width.update(dt);
		this.height.update(dt);
	}
	,getNaturalHeight: function() {
		return this.height._value;
	}
	,getNaturalWidth: function() {
		return this.width._value;
	}
	,draw: function(g) {
		g.fillRect(this.color,0,0,this.width._value,this.height._value);
	}
	,__class__: flambe.display.FillSprite
});
flambe.display.Glyph = function(charCode) {
	this._kernings = null;
	this.xAdvance = 0;
	this.yOffset = 0;
	this.xOffset = 0;
	this.page = null;
	this.height = 0;
	this.width = 0;
	this.y = 0;
	this.x = 0;
	this.charCode = charCode;
};
flambe.display.Glyph.__name__ = true;
flambe.display.Glyph.prototype = {
	setKerning: function(nextCharCode,amount) {
		if(this._kernings == null) this._kernings = new haxe.ds.IntMap();
		this._kernings.set(nextCharCode,amount);
	}
	,getKerning: function(nextCharCode) {
		return this._kernings != null?this._kernings.get(nextCharCode) | 0:0;
	}
	,draw: function(g,destX,destY) {
		if(this.width > 0) g.drawSubImage(this.page,destX + this.xOffset,destY + this.yOffset,this.x,this.y,this.width,this.height);
	}
	,__class__: flambe.display.Glyph
}
flambe.display.Font = function(pack,name) {
	this.name = name;
	this._glyphs = new haxe.ds.IntMap();
	this._glyphs.set(flambe.display.Font.NEWLINE.charCode,flambe.display.Font.NEWLINE);
	var parser = new flambe.display._Font.ConfigParser(pack.getFile(name + ".fnt"));
	var pages = new haxe.ds.IntMap();
	var idx = name.lastIndexOf("/");
	var basePath = idx >= 0?HxOverrides.substr(name,0,idx + 1):"";
	var $it0 = parser.keywords();
	while( $it0.hasNext() ) {
		var keyword = $it0.next();
		switch(keyword) {
		case "info":
			var $it1 = parser.pairs();
			while( $it1.hasNext() ) {
				var pair = $it1.next();
				switch(pair.key) {
				case "size":
					this.size = pair.getInt();
					break;
				}
			}
			break;
		case "page":
			var pageId = 0;
			var file = null;
			var $it2 = parser.pairs();
			while( $it2.hasNext() ) {
				var pair = $it2.next();
				switch(pair.key) {
				case "id":
					pageId = pair.getInt();
					break;
				case "file":
					file = pair.getString();
					break;
				}
			}
			pages.set(pageId,pack.getTexture(basePath + flambe.util.Strings.removeFileExtension(file)));
			break;
		case "char":
			var glyph = null;
			var $it3 = parser.pairs();
			while( $it3.hasNext() ) {
				var pair = $it3.next();
				switch(pair.key) {
				case "id":
					glyph = new flambe.display.Glyph(pair.getInt());
					break;
				case "x":
					glyph.x = pair.getInt();
					break;
				case "y":
					glyph.y = pair.getInt();
					break;
				case "width":
					glyph.width = pair.getInt();
					break;
				case "height":
					glyph.height = pair.getInt();
					break;
				case "page":
					glyph.page = pages.get(pair.getInt());
					break;
				case "xoffset":
					glyph.xOffset = pair.getInt();
					break;
				case "yoffset":
					glyph.yOffset = pair.getInt();
					break;
				case "xadvance":
					glyph.xAdvance = pair.getInt();
					break;
				}
			}
			this._glyphs.set(glyph.charCode,glyph);
			break;
		case "kerning":
			var first = null;
			var second = -1;
			var $it4 = parser.pairs();
			while( $it4.hasNext() ) {
				var pair = $it4.next();
				switch(pair.key) {
				case "first":
					first = this._glyphs.get(pair.getInt());
					break;
				case "second":
					second = pair.getInt();
					break;
				case "amount":
					first.setKerning(second,pair.getInt());
					break;
				}
			}
			break;
		}
	}
};
flambe.display.Font.__name__ = true;
flambe.display.Font.prototype = {
	layoutText: function(text,align,wrapWidth) {
		if(wrapWidth == null) wrapWidth = 0;
		if(align == null) align = flambe.display.TextAlign.Left;
		return new flambe.display.TextLayout(this,text,align,wrapWidth);
	}
	,__class__: flambe.display.Font
}
flambe.display.TextAlign = { __ename__ : true, __constructs__ : ["Left","Center","Right"] }
flambe.display.TextAlign.Left = ["Left",0];
flambe.display.TextAlign.Left.toString = $estr;
flambe.display.TextAlign.Left.__enum__ = flambe.display.TextAlign;
flambe.display.TextAlign.Center = ["Center",1];
flambe.display.TextAlign.Center.toString = $estr;
flambe.display.TextAlign.Center.__enum__ = flambe.display.TextAlign;
flambe.display.TextAlign.Right = ["Right",2];
flambe.display.TextAlign.Right.toString = $estr;
flambe.display.TextAlign.Right.__enum__ = flambe.display.TextAlign;
flambe.display.TextLayout = function(font,text,align,wrapWidth) {
	this.lines = 0;
	var _g = this;
	this._font = font;
	this._glyphs = [];
	this._offsets = [];
	this.bounds = new flambe.math.Rectangle();
	var lineWidths = [];
	var ll = text.length;
	var _g1 = 0;
	while(_g1 < ll) {
		var ii = _g1++;
		var charCode = text.charCodeAt(ii);
		var glyph = font._glyphs.get(charCode);
		if(glyph != null) this._glyphs.push(glyph); else null;
	}
	var lastSpaceIdx = -1;
	var lineWidth = 0.0;
	var lineHeight = 0.0;
	var newline = font._glyphs.get(10);
	var addLine = function() {
		_g.bounds.width = flambe.math.FMath.max(_g.bounds.width,lineWidth);
		_g.bounds.height += lineHeight;
		lineWidths[_g.lines] = lineWidth;
		lineWidth = 0;
		lineHeight = 0;
		++_g.lines;
	};
	var ii = 0;
	while(ii < this._glyphs.length) {
		var glyph = this._glyphs[ii];
		this._offsets[ii] = lineWidth;
		var wordWrap = wrapWidth > 0 && lineWidth + glyph.width > wrapWidth;
		if(wordWrap || glyph == newline) {
			if(wordWrap) {
				if(lastSpaceIdx >= 0) {
					this._glyphs[lastSpaceIdx] = newline;
					lineWidth = this._offsets[lastSpaceIdx];
					ii = lastSpaceIdx;
				} else this._glyphs.splice(ii,0,newline);
			}
			lastSpaceIdx = -1;
			lineHeight = font.size;
			addLine();
		} else {
			if(glyph.charCode == 32) lastSpaceIdx = ii;
			lineWidth += glyph.xAdvance;
			lineHeight = flambe.math.FMath.max(lineHeight,glyph.height + glyph.yOffset);
			if(ii + 1 < this._glyphs.length) {
				var nextGlyph = this._glyphs[ii + 1];
				lineWidth += glyph.getKerning(nextGlyph.charCode);
			}
		}
		++ii;
	}
	addLine();
	var lineY = 0.0;
	var alignOffset = flambe.display.TextLayout.getAlignOffset(align,lineWidths[0],wrapWidth);
	var top = 1.79769313486231e+308;
	var bottom = -1.79769313486231e+308;
	var line = 0;
	var ii1 = 0;
	var ll1 = this._glyphs.length;
	while(ii1 < ll1) {
		var glyph = this._glyphs[ii1];
		if(glyph.charCode == 10) {
			lineY += font.size;
			++line;
			alignOffset = flambe.display.TextLayout.getAlignOffset(align,lineWidths[line],wrapWidth);
		}
		this._offsets[ii1] += alignOffset;
		var glyphY = lineY + glyph.yOffset;
		top = top < glyphY?top:glyphY;
		bottom = flambe.math.FMath.max(bottom,glyphY + glyph.height);
		++ii1;
	}
	this.bounds.x = flambe.display.TextLayout.getAlignOffset(align,this.bounds.width,wrapWidth);
	this.bounds.y = top;
	this.bounds.height = bottom - top;
};
flambe.display.TextLayout.__name__ = true;
flambe.display.TextLayout.getAlignOffset = function(align,lineWidth,totalWidth) {
	switch( (align)[1] ) {
	case 0:
		return 0;
	case 2:
		return totalWidth - lineWidth;
	case 1:
		return (totalWidth - lineWidth) / 2;
	}
}
flambe.display.TextLayout.prototype = {
	draw: function(g,align) {
		var y = 0.0;
		var ii = 0;
		var ll = this._glyphs.length;
		while(ii < ll) {
			var glyph = this._glyphs[ii];
			if(glyph.charCode == 10) y += this._font.size; else {
				var x = this._offsets[ii];
				glyph.draw(g,x,y);
			}
			++ii;
		}
	}
	,__class__: flambe.display.TextLayout
}
flambe.display._Font = {}
flambe.display._Font.ConfigParser = function(config) {
	this._configText = config;
	this._keywordPattern = new EReg("([a-z]+)(.*)","");
	this._pairPattern = new EReg("([a-z]+)=(\"[^\"]*\"|[^\\s]+)","");
};
flambe.display._Font.ConfigParser.__name__ = true;
flambe.display._Font.ConfigParser.advance = function(text,expr) {
	var m = expr.matchedPos();
	return HxOverrides.substr(text,m.pos + m.len,text.length);
}
flambe.display._Font.ConfigParser.prototype = {
	pairs: function() {
		var _g = this;
		var text = this._pairText;
		return { next : function() {
			text = flambe.display._Font.ConfigParser.advance(text,_g._pairPattern);
			return new flambe.display._Font.ConfigPair(_g._pairPattern.matched(1),_g._pairPattern.matched(2));
		}, hasNext : function() {
			return _g._pairPattern.match(text);
		}};
	}
	,keywords: function() {
		var _g = this;
		var text = this._configText;
		return { next : function() {
			text = flambe.display._Font.ConfigParser.advance(text,_g._keywordPattern);
			_g._pairText = _g._keywordPattern.matched(2);
			return _g._keywordPattern.matched(1);
		}, hasNext : function() {
			return _g._keywordPattern.match(text);
		}};
	}
	,__class__: flambe.display._Font.ConfigParser
}
flambe.display._Font.ConfigPair = function(key,value) {
	this.key = key;
	this._value = value;
};
flambe.display._Font.ConfigPair.__name__ = true;
flambe.display._Font.ConfigPair.prototype = {
	getString: function() {
		if(this._value.charCodeAt(0) != 34) return null;
		return HxOverrides.substr(this._value,1,this._value.length - 2);
	}
	,getInt: function() {
		return Std.parseInt(this._value);
	}
	,__class__: flambe.display._Font.ConfigPair
}
flambe.display.Graphics = function() { }
flambe.display.Graphics.__name__ = true;
flambe.display.Graphics.prototype = {
	__class__: flambe.display.Graphics
}
flambe.display.Orientation = { __ename__ : true, __constructs__ : ["Portrait","Landscape"] }
flambe.display.Orientation.Portrait = ["Portrait",0];
flambe.display.Orientation.Portrait.toString = $estr;
flambe.display.Orientation.Portrait.__enum__ = flambe.display.Orientation;
flambe.display.Orientation.Landscape = ["Landscape",1];
flambe.display.Orientation.Landscape.toString = $estr;
flambe.display.Orientation.Landscape.__enum__ = flambe.display.Orientation;
flambe.display.Stage = function() { }
flambe.display.Stage.__name__ = true;
flambe.display.Stage.prototype = {
	__class__: flambe.display.Stage
}
flambe.display.TextSprite = function(font,text) {
	if(text == null) text = "";
	this._layout = null;
	var _g = this;
	flambe.display.Sprite.call(this);
	this._font = font;
	this._text = text;
	this._align = flambe.display.TextAlign.Left;
	this._flags = this._flags | 32;
	this.wrapWidth = new flambe.animation.AnimatedFloat(0,function(_,_1) {
		_g._flags = _g._flags | 32;
	});
};
flambe.display.TextSprite.__name__ = true;
flambe.display.TextSprite.__super__ = flambe.display.Sprite;
flambe.display.TextSprite.prototype = $extend(flambe.display.Sprite.prototype,{
	onUpdate: function(dt) {
		flambe.display.Sprite.prototype.onUpdate.call(this,dt);
		this.wrapWidth.update(dt);
	}
	,updateLayout: function() {
		if((this._flags & 32) != 0) {
			this._flags = this._flags & -33;
			this._layout = this._font.layoutText(this._text,this._align,this.wrapWidth._value);
		}
	}
	,set_text: function(text) {
		this._text = text;
		this._flags = this._flags | 32;
		return text;
	}
	,containsLocal: function(localX,localY) {
		this.updateLayout();
		return this._layout.bounds.contains(localX,localY);
	}
	,getNaturalHeight: function() {
		this.updateLayout();
		return this._layout.lines * this._font.size;
	}
	,getNaturalWidth: function() {
		this.updateLayout();
		return this.wrapWidth._value > 0?this.wrapWidth._value:this._layout.bounds.width;
	}
	,draw: function(g) {
		this.updateLayout();
		this._layout.draw(g,this._align);
	}
	,__class__: flambe.display.TextSprite
});
flambe.display.Texture = function() { }
flambe.display.Texture.__name__ = true;
flambe.display.tileSheet = {}
flambe.display.tileSheet.AnimSeqData = function(name,frames,frameRate,looped) {
	if(looped == null) looped = true;
	if(frameRate == null) frameRate = 0;
	this.seqName = name;
	this.delay = 0;
	if(frameRate > 0) this.delay = 1.0 / frameRate;
	this.arFrames = frames;
	this.loop = looped;
};
flambe.display.tileSheet.AnimSeqData.__name__ = true;
flambe.display.tileSheet.AnimSeqData.prototype = {
	__class__: flambe.display.tileSheet.AnimSeqData
}
flambe.display.tileSheet.AnimSprite = function(texture) {
	flambe.display.Sprite.call(this);
	this.fakeElapsed = 0.0167;
	this.frameTimer = 0;
	this.mSequences = [];
	this.texture = texture;
};
flambe.display.tileSheet.AnimSprite.__name__ = true;
flambe.display.tileSheet.AnimSprite.__super__ = flambe.display.Sprite;
flambe.display.tileSheet.AnimSprite.prototype = $extend(flambe.display.Sprite.prototype,{
	getNaturalHeight: function() {
		return this.mAnimSheet.get_frameHeight(this.curIndex);
	}
	,getNaturalWidth: function() {
		return this.mAnimSheet.get_frameWidth(this.curIndex);
	}
	,draw: function(ctx) {
		var data = this.mAnimSheet.getFrameData(this.curIndex);
		ctx.drawSubImage(this.texture,data.offX,data.offY,data.x,data.y,data.w,data.h);
	}
	,drawFrameInternal: function() {
		this.dirty = false;
	}
	,advanceFrame: function() {
		if((this.curFrame | 0) == this.curAnim.arFrames.length - 1) {
			if(this.curAnim.loop) this.curFrame = 0; else this.donePlaying = true;
		} else ++this.curFrame;
		this.curIndex = this.curAnim.arFrames[this.curFrame];
		this.dirty = true;
	}
	,updateAnimation: function() {
		if(this.curAnim != null && this.curAnim.delay > 0 && !this.donePlaying) {
			this.frameTimer += this.fakeElapsed;
			while(this.frameTimer > this.curAnim.delay) {
				this.frameTimer = this.frameTimer - this.curAnim.delay;
				this.advanceFrame();
			}
		}
		if(this.dirty) this.drawFrameInternal();
	}
	,onUpdate: function(dt) {
		flambe.display.Sprite.prototype.onUpdate.call(this,dt);
		this.updateAnimation();
	}
	,drawFrame: function(force) {
		if(force == null) force = false;
		if(force || this.dirty) this.drawFrameInternal();
	}
	,play: function(name) {
		if(name == null) {
			this.donePlaying = false;
			this.dirty = true;
			this.frameTimer = 0;
			return;
		}
		this.curFrame = 0;
		this.curIndex = 0;
		this.frameTimer = 0;
		this.curAnim = this.findSequenceByName(name);
		if(this.curAnim == null) return;
		this.curIndex = this.curAnim.arFrames[0];
		this.donePlaying = false;
		this.dirty = true;
		if(this.curAnim.arFrames.length == 1) this.donePlaying = true;
	}
	,findSequenceByName: function(name) {
		var aSeq;
		var i = 0;
		while(i < this.mSequences.length) {
			aSeq = js.Boot.__cast(this.mSequences[i] , flambe.display.tileSheet.AnimSeqData);
			if(aSeq.seqName == name) return aSeq;
			i++;
		}
		return null;
	}
	,addSequence: function(name,frames,frameRate,looped) {
		if(looped == null) looped = true;
		if(frameRate == null) frameRate = 0;
		this.mSequences.push(new flambe.display.tileSheet.AnimSeqData(name,frames,frameRate,looped));
	}
	,set_frame: function(val) {
		this.curFrame = val;
		if(this.curAnim != null) this.curIndex = this.curAnim.arFrames[this.curFrame]; else this.curIndex = val;
		this.dirty = true;
		return val;
	}
	,initialize: function(sheet) {
		if(sheet == null) return;
		this.mAnimSheet = sheet;
		this.curAnim = null;
		this.set_frame(0);
		this.drawFrame(true);
	}
	,__class__: flambe.display.tileSheet.AnimSprite
});
flambe.display.tileSheet.AnimTextureSheet = function() {
	this.mTextureRegions = new Array();
	this.mFrameRect = new flambe.math.Rectangle();
	this.mFrameOffsets = new Array();
};
flambe.display.tileSheet.AnimTextureSheet.__name__ = true;
flambe.display.tileSheet.AnimTextureSheet.prototype = {
	getFrameData: function(frame) {
		return this.arFrameData[frame];
	}
	,init: function(arFrameData) {
		this.arFrameData = arFrameData;
		var rcFrame;
		var regPt;
		var i = 0;
		while(i < arFrameData.length) {
			rcFrame = new flambe.math.Rectangle();
			rcFrame.x = arFrameData[i].x;
			rcFrame.y = arFrameData[i].y;
			rcFrame.width = arFrameData[i].w;
			rcFrame.height = arFrameData[i].h;
			this.mTextureRegions.push(rcFrame);
			regPt = new flambe.math.Point();
			regPt.x = arFrameData[i].offX;
			regPt.y = arFrameData[i].offY;
			this.mFrameOffsets.push(regPt);
			this.mFrameRect.width = Math.max(this.mFrameRect.width,rcFrame.width + regPt.x);
			this.mFrameRect.height = Math.max(this.mFrameRect.height,rcFrame.height + regPt.y);
			i++;
		}
	}
	,get_frameHeight: function(fr) {
		return this.mTextureRegions[fr].height + this.mFrameOffsets[fr].y;
	}
	,get_frameWidth: function(fr) {
		return this.mTextureRegions[fr].width + this.mFrameOffsets[fr].x;
	}
	,__class__: flambe.display.tileSheet.AnimTextureSheet
}
flambe.display.tileSheet.TileSheetHelper = function() {
};
flambe.display.tileSheet.TileSheetHelper.__name__ = true;
flambe.display.tileSheet.TileSheetHelper.__super__ = flambe.Component;
flambe.display.tileSheet.TileSheetHelper.prototype = $extend(flambe.Component.prototype,{
	populateFrameArray: function(arDest,src) {
		var entry;
		var nameId;
		var item;
		var _g = 0, _g1 = Reflect.fields(src);
		while(_g < _g1.length) {
			var keyName = _g1[_g];
			++_g;
			nameId = keyName.substring(0,keyName.lastIndexOf(".png"));
			entry = Reflect.field(src,keyName);
			item = entry.frame;
			item.id = nameId;
			item.offX = 0;
			item.offY = 0;
			if(entry.trimmed) {
				item.offX = entry.spriteSourceSize.x;
				item.offY = entry.spriteSourceSize.y;
			}
			arDest.push(item);
		}
	}
	,onShort: function(ad,bd) {
		var a = ad.id.toLowerCase();
		var b = bd.id.toLowerCase();
		if(a < b) return -1;
		if(a > b) return 1;
		return 0;
	}
	,prepareAnimTexture: function(data) {
		var seqRaw = haxe.Json.parse(data);
		var animData = new Array();
		this.populateFrameArray(animData,seqRaw.frames);
		animData.sort($bind(this,this.onShort));
		var tileSheet = new flambe.display.tileSheet.AnimTextureSheet();
		tileSheet.init(animData);
		return tileSheet;
	}
	,get_name: function() {
		return "TileSheetHelper_2";
	}
	,__class__: flambe.display.tileSheet.TileSheetHelper
});
flambe.input = {}
flambe.input.Key = { __ename__ : true, __constructs__ : ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","Number0","Number1","Number2","Number3","Number4","Number5","Number6","Number7","Number8","Number9","Numpad0","Numpad1","Numpad2","Numpad3","Numpad4","Numpad5","Numpad6","Numpad7","Numpad8","Numpad9","NumpadAdd","NumpadDecimal","NumpadDivide","NumpadEnter","NumpadMultiply","NumpadSubtract","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","F13","F14","F15","Left","Up","Right","Down","Alt","Backquote","Backslash","Backspace","CapsLock","Comma","Command","Control","Delete","End","Enter","Equals","Escape","Home","Insert","LeftBracket","Minus","PageDown","PageUp","Period","Quote","RightBracket","Semicolon","Shift","Slash","Space","Tab","Menu","Search","Unknown"] }
flambe.input.Key.A = ["A",0];
flambe.input.Key.A.toString = $estr;
flambe.input.Key.A.__enum__ = flambe.input.Key;
flambe.input.Key.B = ["B",1];
flambe.input.Key.B.toString = $estr;
flambe.input.Key.B.__enum__ = flambe.input.Key;
flambe.input.Key.C = ["C",2];
flambe.input.Key.C.toString = $estr;
flambe.input.Key.C.__enum__ = flambe.input.Key;
flambe.input.Key.D = ["D",3];
flambe.input.Key.D.toString = $estr;
flambe.input.Key.D.__enum__ = flambe.input.Key;
flambe.input.Key.E = ["E",4];
flambe.input.Key.E.toString = $estr;
flambe.input.Key.E.__enum__ = flambe.input.Key;
flambe.input.Key.F = ["F",5];
flambe.input.Key.F.toString = $estr;
flambe.input.Key.F.__enum__ = flambe.input.Key;
flambe.input.Key.G = ["G",6];
flambe.input.Key.G.toString = $estr;
flambe.input.Key.G.__enum__ = flambe.input.Key;
flambe.input.Key.H = ["H",7];
flambe.input.Key.H.toString = $estr;
flambe.input.Key.H.__enum__ = flambe.input.Key;
flambe.input.Key.I = ["I",8];
flambe.input.Key.I.toString = $estr;
flambe.input.Key.I.__enum__ = flambe.input.Key;
flambe.input.Key.J = ["J",9];
flambe.input.Key.J.toString = $estr;
flambe.input.Key.J.__enum__ = flambe.input.Key;
flambe.input.Key.K = ["K",10];
flambe.input.Key.K.toString = $estr;
flambe.input.Key.K.__enum__ = flambe.input.Key;
flambe.input.Key.L = ["L",11];
flambe.input.Key.L.toString = $estr;
flambe.input.Key.L.__enum__ = flambe.input.Key;
flambe.input.Key.M = ["M",12];
flambe.input.Key.M.toString = $estr;
flambe.input.Key.M.__enum__ = flambe.input.Key;
flambe.input.Key.N = ["N",13];
flambe.input.Key.N.toString = $estr;
flambe.input.Key.N.__enum__ = flambe.input.Key;
flambe.input.Key.O = ["O",14];
flambe.input.Key.O.toString = $estr;
flambe.input.Key.O.__enum__ = flambe.input.Key;
flambe.input.Key.P = ["P",15];
flambe.input.Key.P.toString = $estr;
flambe.input.Key.P.__enum__ = flambe.input.Key;
flambe.input.Key.Q = ["Q",16];
flambe.input.Key.Q.toString = $estr;
flambe.input.Key.Q.__enum__ = flambe.input.Key;
flambe.input.Key.R = ["R",17];
flambe.input.Key.R.toString = $estr;
flambe.input.Key.R.__enum__ = flambe.input.Key;
flambe.input.Key.S = ["S",18];
flambe.input.Key.S.toString = $estr;
flambe.input.Key.S.__enum__ = flambe.input.Key;
flambe.input.Key.T = ["T",19];
flambe.input.Key.T.toString = $estr;
flambe.input.Key.T.__enum__ = flambe.input.Key;
flambe.input.Key.U = ["U",20];
flambe.input.Key.U.toString = $estr;
flambe.input.Key.U.__enum__ = flambe.input.Key;
flambe.input.Key.V = ["V",21];
flambe.input.Key.V.toString = $estr;
flambe.input.Key.V.__enum__ = flambe.input.Key;
flambe.input.Key.W = ["W",22];
flambe.input.Key.W.toString = $estr;
flambe.input.Key.W.__enum__ = flambe.input.Key;
flambe.input.Key.X = ["X",23];
flambe.input.Key.X.toString = $estr;
flambe.input.Key.X.__enum__ = flambe.input.Key;
flambe.input.Key.Y = ["Y",24];
flambe.input.Key.Y.toString = $estr;
flambe.input.Key.Y.__enum__ = flambe.input.Key;
flambe.input.Key.Z = ["Z",25];
flambe.input.Key.Z.toString = $estr;
flambe.input.Key.Z.__enum__ = flambe.input.Key;
flambe.input.Key.Number0 = ["Number0",26];
flambe.input.Key.Number0.toString = $estr;
flambe.input.Key.Number0.__enum__ = flambe.input.Key;
flambe.input.Key.Number1 = ["Number1",27];
flambe.input.Key.Number1.toString = $estr;
flambe.input.Key.Number1.__enum__ = flambe.input.Key;
flambe.input.Key.Number2 = ["Number2",28];
flambe.input.Key.Number2.toString = $estr;
flambe.input.Key.Number2.__enum__ = flambe.input.Key;
flambe.input.Key.Number3 = ["Number3",29];
flambe.input.Key.Number3.toString = $estr;
flambe.input.Key.Number3.__enum__ = flambe.input.Key;
flambe.input.Key.Number4 = ["Number4",30];
flambe.input.Key.Number4.toString = $estr;
flambe.input.Key.Number4.__enum__ = flambe.input.Key;
flambe.input.Key.Number5 = ["Number5",31];
flambe.input.Key.Number5.toString = $estr;
flambe.input.Key.Number5.__enum__ = flambe.input.Key;
flambe.input.Key.Number6 = ["Number6",32];
flambe.input.Key.Number6.toString = $estr;
flambe.input.Key.Number6.__enum__ = flambe.input.Key;
flambe.input.Key.Number7 = ["Number7",33];
flambe.input.Key.Number7.toString = $estr;
flambe.input.Key.Number7.__enum__ = flambe.input.Key;
flambe.input.Key.Number8 = ["Number8",34];
flambe.input.Key.Number8.toString = $estr;
flambe.input.Key.Number8.__enum__ = flambe.input.Key;
flambe.input.Key.Number9 = ["Number9",35];
flambe.input.Key.Number9.toString = $estr;
flambe.input.Key.Number9.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad0 = ["Numpad0",36];
flambe.input.Key.Numpad0.toString = $estr;
flambe.input.Key.Numpad0.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad1 = ["Numpad1",37];
flambe.input.Key.Numpad1.toString = $estr;
flambe.input.Key.Numpad1.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad2 = ["Numpad2",38];
flambe.input.Key.Numpad2.toString = $estr;
flambe.input.Key.Numpad2.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad3 = ["Numpad3",39];
flambe.input.Key.Numpad3.toString = $estr;
flambe.input.Key.Numpad3.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad4 = ["Numpad4",40];
flambe.input.Key.Numpad4.toString = $estr;
flambe.input.Key.Numpad4.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad5 = ["Numpad5",41];
flambe.input.Key.Numpad5.toString = $estr;
flambe.input.Key.Numpad5.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad6 = ["Numpad6",42];
flambe.input.Key.Numpad6.toString = $estr;
flambe.input.Key.Numpad6.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad7 = ["Numpad7",43];
flambe.input.Key.Numpad7.toString = $estr;
flambe.input.Key.Numpad7.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad8 = ["Numpad8",44];
flambe.input.Key.Numpad8.toString = $estr;
flambe.input.Key.Numpad8.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad9 = ["Numpad9",45];
flambe.input.Key.Numpad9.toString = $estr;
flambe.input.Key.Numpad9.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadAdd = ["NumpadAdd",46];
flambe.input.Key.NumpadAdd.toString = $estr;
flambe.input.Key.NumpadAdd.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadDecimal = ["NumpadDecimal",47];
flambe.input.Key.NumpadDecimal.toString = $estr;
flambe.input.Key.NumpadDecimal.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadDivide = ["NumpadDivide",48];
flambe.input.Key.NumpadDivide.toString = $estr;
flambe.input.Key.NumpadDivide.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadEnter = ["NumpadEnter",49];
flambe.input.Key.NumpadEnter.toString = $estr;
flambe.input.Key.NumpadEnter.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadMultiply = ["NumpadMultiply",50];
flambe.input.Key.NumpadMultiply.toString = $estr;
flambe.input.Key.NumpadMultiply.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadSubtract = ["NumpadSubtract",51];
flambe.input.Key.NumpadSubtract.toString = $estr;
flambe.input.Key.NumpadSubtract.__enum__ = flambe.input.Key;
flambe.input.Key.F1 = ["F1",52];
flambe.input.Key.F1.toString = $estr;
flambe.input.Key.F1.__enum__ = flambe.input.Key;
flambe.input.Key.F2 = ["F2",53];
flambe.input.Key.F2.toString = $estr;
flambe.input.Key.F2.__enum__ = flambe.input.Key;
flambe.input.Key.F3 = ["F3",54];
flambe.input.Key.F3.toString = $estr;
flambe.input.Key.F3.__enum__ = flambe.input.Key;
flambe.input.Key.F4 = ["F4",55];
flambe.input.Key.F4.toString = $estr;
flambe.input.Key.F4.__enum__ = flambe.input.Key;
flambe.input.Key.F5 = ["F5",56];
flambe.input.Key.F5.toString = $estr;
flambe.input.Key.F5.__enum__ = flambe.input.Key;
flambe.input.Key.F6 = ["F6",57];
flambe.input.Key.F6.toString = $estr;
flambe.input.Key.F6.__enum__ = flambe.input.Key;
flambe.input.Key.F7 = ["F7",58];
flambe.input.Key.F7.toString = $estr;
flambe.input.Key.F7.__enum__ = flambe.input.Key;
flambe.input.Key.F8 = ["F8",59];
flambe.input.Key.F8.toString = $estr;
flambe.input.Key.F8.__enum__ = flambe.input.Key;
flambe.input.Key.F9 = ["F9",60];
flambe.input.Key.F9.toString = $estr;
flambe.input.Key.F9.__enum__ = flambe.input.Key;
flambe.input.Key.F10 = ["F10",61];
flambe.input.Key.F10.toString = $estr;
flambe.input.Key.F10.__enum__ = flambe.input.Key;
flambe.input.Key.F11 = ["F11",62];
flambe.input.Key.F11.toString = $estr;
flambe.input.Key.F11.__enum__ = flambe.input.Key;
flambe.input.Key.F12 = ["F12",63];
flambe.input.Key.F12.toString = $estr;
flambe.input.Key.F12.__enum__ = flambe.input.Key;
flambe.input.Key.F13 = ["F13",64];
flambe.input.Key.F13.toString = $estr;
flambe.input.Key.F13.__enum__ = flambe.input.Key;
flambe.input.Key.F14 = ["F14",65];
flambe.input.Key.F14.toString = $estr;
flambe.input.Key.F14.__enum__ = flambe.input.Key;
flambe.input.Key.F15 = ["F15",66];
flambe.input.Key.F15.toString = $estr;
flambe.input.Key.F15.__enum__ = flambe.input.Key;
flambe.input.Key.Left = ["Left",67];
flambe.input.Key.Left.toString = $estr;
flambe.input.Key.Left.__enum__ = flambe.input.Key;
flambe.input.Key.Up = ["Up",68];
flambe.input.Key.Up.toString = $estr;
flambe.input.Key.Up.__enum__ = flambe.input.Key;
flambe.input.Key.Right = ["Right",69];
flambe.input.Key.Right.toString = $estr;
flambe.input.Key.Right.__enum__ = flambe.input.Key;
flambe.input.Key.Down = ["Down",70];
flambe.input.Key.Down.toString = $estr;
flambe.input.Key.Down.__enum__ = flambe.input.Key;
flambe.input.Key.Alt = ["Alt",71];
flambe.input.Key.Alt.toString = $estr;
flambe.input.Key.Alt.__enum__ = flambe.input.Key;
flambe.input.Key.Backquote = ["Backquote",72];
flambe.input.Key.Backquote.toString = $estr;
flambe.input.Key.Backquote.__enum__ = flambe.input.Key;
flambe.input.Key.Backslash = ["Backslash",73];
flambe.input.Key.Backslash.toString = $estr;
flambe.input.Key.Backslash.__enum__ = flambe.input.Key;
flambe.input.Key.Backspace = ["Backspace",74];
flambe.input.Key.Backspace.toString = $estr;
flambe.input.Key.Backspace.__enum__ = flambe.input.Key;
flambe.input.Key.CapsLock = ["CapsLock",75];
flambe.input.Key.CapsLock.toString = $estr;
flambe.input.Key.CapsLock.__enum__ = flambe.input.Key;
flambe.input.Key.Comma = ["Comma",76];
flambe.input.Key.Comma.toString = $estr;
flambe.input.Key.Comma.__enum__ = flambe.input.Key;
flambe.input.Key.Command = ["Command",77];
flambe.input.Key.Command.toString = $estr;
flambe.input.Key.Command.__enum__ = flambe.input.Key;
flambe.input.Key.Control = ["Control",78];
flambe.input.Key.Control.toString = $estr;
flambe.input.Key.Control.__enum__ = flambe.input.Key;
flambe.input.Key.Delete = ["Delete",79];
flambe.input.Key.Delete.toString = $estr;
flambe.input.Key.Delete.__enum__ = flambe.input.Key;
flambe.input.Key.End = ["End",80];
flambe.input.Key.End.toString = $estr;
flambe.input.Key.End.__enum__ = flambe.input.Key;
flambe.input.Key.Enter = ["Enter",81];
flambe.input.Key.Enter.toString = $estr;
flambe.input.Key.Enter.__enum__ = flambe.input.Key;
flambe.input.Key.Equals = ["Equals",82];
flambe.input.Key.Equals.toString = $estr;
flambe.input.Key.Equals.__enum__ = flambe.input.Key;
flambe.input.Key.Escape = ["Escape",83];
flambe.input.Key.Escape.toString = $estr;
flambe.input.Key.Escape.__enum__ = flambe.input.Key;
flambe.input.Key.Home = ["Home",84];
flambe.input.Key.Home.toString = $estr;
flambe.input.Key.Home.__enum__ = flambe.input.Key;
flambe.input.Key.Insert = ["Insert",85];
flambe.input.Key.Insert.toString = $estr;
flambe.input.Key.Insert.__enum__ = flambe.input.Key;
flambe.input.Key.LeftBracket = ["LeftBracket",86];
flambe.input.Key.LeftBracket.toString = $estr;
flambe.input.Key.LeftBracket.__enum__ = flambe.input.Key;
flambe.input.Key.Minus = ["Minus",87];
flambe.input.Key.Minus.toString = $estr;
flambe.input.Key.Minus.__enum__ = flambe.input.Key;
flambe.input.Key.PageDown = ["PageDown",88];
flambe.input.Key.PageDown.toString = $estr;
flambe.input.Key.PageDown.__enum__ = flambe.input.Key;
flambe.input.Key.PageUp = ["PageUp",89];
flambe.input.Key.PageUp.toString = $estr;
flambe.input.Key.PageUp.__enum__ = flambe.input.Key;
flambe.input.Key.Period = ["Period",90];
flambe.input.Key.Period.toString = $estr;
flambe.input.Key.Period.__enum__ = flambe.input.Key;
flambe.input.Key.Quote = ["Quote",91];
flambe.input.Key.Quote.toString = $estr;
flambe.input.Key.Quote.__enum__ = flambe.input.Key;
flambe.input.Key.RightBracket = ["RightBracket",92];
flambe.input.Key.RightBracket.toString = $estr;
flambe.input.Key.RightBracket.__enum__ = flambe.input.Key;
flambe.input.Key.Semicolon = ["Semicolon",93];
flambe.input.Key.Semicolon.toString = $estr;
flambe.input.Key.Semicolon.__enum__ = flambe.input.Key;
flambe.input.Key.Shift = ["Shift",94];
flambe.input.Key.Shift.toString = $estr;
flambe.input.Key.Shift.__enum__ = flambe.input.Key;
flambe.input.Key.Slash = ["Slash",95];
flambe.input.Key.Slash.toString = $estr;
flambe.input.Key.Slash.__enum__ = flambe.input.Key;
flambe.input.Key.Space = ["Space",96];
flambe.input.Key.Space.toString = $estr;
flambe.input.Key.Space.__enum__ = flambe.input.Key;
flambe.input.Key.Tab = ["Tab",97];
flambe.input.Key.Tab.toString = $estr;
flambe.input.Key.Tab.__enum__ = flambe.input.Key;
flambe.input.Key.Menu = ["Menu",98];
flambe.input.Key.Menu.toString = $estr;
flambe.input.Key.Menu.__enum__ = flambe.input.Key;
flambe.input.Key.Search = ["Search",99];
flambe.input.Key.Search.toString = $estr;
flambe.input.Key.Search.__enum__ = flambe.input.Key;
flambe.input.Key.Unknown = function(keyCode) { var $x = ["Unknown",100,keyCode]; $x.__enum__ = flambe.input.Key; $x.toString = $estr; return $x; }
flambe.input.Keyboard = function() { }
flambe.input.Keyboard.__name__ = true;
flambe.input.KeyboardEvent = function() {
	this.init(0,null);
};
flambe.input.KeyboardEvent.__name__ = true;
flambe.input.KeyboardEvent.prototype = {
	init: function(id,key) {
		this.id = id;
		this.key = key;
	}
	,__class__: flambe.input.KeyboardEvent
}
flambe.input.Mouse = function() { }
flambe.input.Mouse.__name__ = true;
flambe.input.MouseButton = { __ename__ : true, __constructs__ : ["Left","Middle","Right","Unknown"] }
flambe.input.MouseButton.Left = ["Left",0];
flambe.input.MouseButton.Left.toString = $estr;
flambe.input.MouseButton.Left.__enum__ = flambe.input.MouseButton;
flambe.input.MouseButton.Middle = ["Middle",1];
flambe.input.MouseButton.Middle.toString = $estr;
flambe.input.MouseButton.Middle.__enum__ = flambe.input.MouseButton;
flambe.input.MouseButton.Right = ["Right",2];
flambe.input.MouseButton.Right.toString = $estr;
flambe.input.MouseButton.Right.__enum__ = flambe.input.MouseButton;
flambe.input.MouseButton.Unknown = function(buttonCode) { var $x = ["Unknown",3,buttonCode]; $x.__enum__ = flambe.input.MouseButton; $x.toString = $estr; return $x; }
flambe.input.MouseCursor = { __ename__ : true, __constructs__ : ["Default","Button","None"] }
flambe.input.MouseCursor.Default = ["Default",0];
flambe.input.MouseCursor.Default.toString = $estr;
flambe.input.MouseCursor.Default.__enum__ = flambe.input.MouseCursor;
flambe.input.MouseCursor.Button = ["Button",1];
flambe.input.MouseCursor.Button.toString = $estr;
flambe.input.MouseCursor.Button.__enum__ = flambe.input.MouseCursor;
flambe.input.MouseCursor.None = ["None",2];
flambe.input.MouseCursor.None.toString = $estr;
flambe.input.MouseCursor.None.__enum__ = flambe.input.MouseCursor;
flambe.input.MouseEvent = function() {
	this.init(0,0,0,null);
};
flambe.input.MouseEvent.__name__ = true;
flambe.input.MouseEvent.prototype = {
	init: function(id,viewX,viewY,button) {
		this.id = id;
		this.viewX = viewX;
		this.viewY = viewY;
		this.button = button;
	}
	,__class__: flambe.input.MouseEvent
}
flambe.input.Pointer = function() { }
flambe.input.Pointer.__name__ = true;
flambe.input.EventSource = { __ename__ : true, __constructs__ : ["Mouse","Touch"] }
flambe.input.EventSource.Mouse = function(event) { var $x = ["Mouse",0,event]; $x.__enum__ = flambe.input.EventSource; $x.toString = $estr; return $x; }
flambe.input.EventSource.Touch = function(point) { var $x = ["Touch",1,point]; $x.__enum__ = flambe.input.EventSource; $x.toString = $estr; return $x; }
flambe.input.PointerEvent = function() {
	this.init(0,0,0,null,null);
};
flambe.input.PointerEvent.__name__ = true;
flambe.input.PointerEvent.prototype = {
	init: function(id,viewX,viewY,hit,source) {
		this.id = id;
		this.viewX = viewX;
		this.viewY = viewY;
		this.hit = hit;
		this.source = source;
		this._stopped = false;
	}
	,__class__: flambe.input.PointerEvent
}
flambe.input.Touch = function() { }
flambe.input.Touch.__name__ = true;
flambe.input.TouchPoint = function(id) {
	this.id = id;
	this._source = flambe.input.EventSource.Touch(this);
};
flambe.input.TouchPoint.__name__ = true;
flambe.input.TouchPoint.prototype = {
	init: function(viewX,viewY) {
		this.viewX = viewX;
		this.viewY = viewY;
	}
	,__class__: flambe.input.TouchPoint
}
flambe.math.FMath = function() { }
flambe.math.FMath.__name__ = true;
flambe.math.FMath.max = function(a,b) {
	return a > b?a:b;
}
flambe.math.Matrix = function() {
	this.identity();
};
flambe.math.Matrix.__name__ = true;
flambe.math.Matrix.prototype = {
	inverseTransform: function(x,y,result) {
		var det = this.determinant();
		if(det == 0) return false;
		x -= this.m02;
		y -= this.m12;
		result.x = (x * this.m11 - y * this.m01) / det;
		result.y = (y * this.m00 - x * this.m10) / det;
		return true;
	}
	,determinant: function() {
		return this.m00 * this.m11 - this.m01 * this.m10;
	}
	,translate: function(x,y) {
		this.m02 += this.m00 * x + this.m01 * y;
		this.m12 += this.m11 * y + this.m10 * x;
	}
	,compose: function(x,y,scaleX,scaleY,rotation) {
		var sin = Math.sin(rotation);
		var cos = Math.cos(rotation);
		this.set(cos * scaleX,sin * scaleX,-sin * scaleY,cos * scaleY,x,y);
	}
	,identity: function() {
		this.set(1,0,0,1,0,0);
	}
	,set: function(m00,m10,m01,m11,m02,m12) {
		this.m00 = m00;
		this.m01 = m01;
		this.m02 = m02;
		this.m10 = m10;
		this.m11 = m11;
		this.m12 = m12;
	}
	,__class__: flambe.math.Matrix
}
flambe.math.Rectangle = function(x,y,width,height) {
	if(height == null) height = 0;
	if(width == null) width = 0;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.set(x,y,width,height);
};
flambe.math.Rectangle.__name__ = true;
flambe.math.Rectangle.prototype = {
	contains: function(x,y) {
		x -= this.x;
		y -= this.y;
		return x >= 0 && y >= 0 && x <= this.width && y <= this.height;
	}
	,set: function(x,y,width,height) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	,__class__: flambe.math.Rectangle
}
flambe.platform.BasicAssetPackLoader = function(platform,manifest) {
	var _g = this;
	this._platform = platform;
	this.promise = new flambe.util.Promise();
	this._bytesLoaded = new haxe.ds.StringMap();
	this._pack = new flambe.platform._BasicAssetPackLoader.BasicAssetPack(manifest);
	var entries = Lambda.array(manifest);
	if(entries.length == 0) this.handleSuccess(); else {
		var groups = new haxe.ds.StringMap();
		var _g1 = 0;
		while(_g1 < entries.length) {
			var entry = entries[_g1];
			++_g1;
			var group = groups.get(entry.name);
			if(group == null) {
				group = [];
				groups.set(entry.name,group);
			}
			group.push(entry);
		}
		this._assetsRemaining = Lambda.count(groups);
		var $it0 = (((function() {
			return function(_e) {
				return (function() {
					return function() {
						return _e.iterator();
					};
				})();
			};
		})())(groups))();
		while( $it0.hasNext() ) {
			var group = $it0.next();
			var group1 = [group];
			this.pickBestEntry(group1[0],(function(group1) {
				return function(bestEntry) {
					if(bestEntry != null) {
						var url = manifest.getFullURL(bestEntry);
						try {
							_g.loadEntry(url,bestEntry);
						} catch( error ) {
							_g.handleError(bestEntry,"Unexpected error: " + Std.string(error));
						}
						var _g1 = _g.promise;
						_g1.set_total(_g1._total + bestEntry.bytes);
					} else {
						var badEntry = group1[0][0];
						if(flambe.platform.BasicAssetPackLoader.isAudio(badEntry.format)) _g.handleLoad(badEntry,flambe.platform.DummySound.getInstance()); else _g.handleError(badEntry,"Could not find a supported format to load");
					}
				};
			})(group1));
		}
	}
};
flambe.platform.BasicAssetPackLoader.__name__ = true;
flambe.platform.BasicAssetPackLoader.isAudio = function(format) {
	switch( (format)[1] ) {
	case 5:
	case 6:
	case 7:
	case 8:
		return true;
	default:
		return false;
	}
}
flambe.platform.BasicAssetPackLoader.prototype = {
	handleTextureError: function(entry) {
		this.handleError(entry,"Failed to create texture. Is the GPU context unavailable?");
	}
	,handleError: function(entry,message) {
		this.promise.error.emit1(flambe.util.Strings.withFields(message,["url",entry.url]));
	}
	,handleSuccess: function() {
		this.promise.set_result(this._pack);
	}
	,handleProgress: function(entry,bytesLoaded) {
		this._bytesLoaded.set(entry.name,bytesLoaded);
		var bytesTotal = 0;
		var $it0 = ((function(_e) {
			return function() {
				return _e.iterator();
			};
		})(this._bytesLoaded))();
		while( $it0.hasNext() ) {
			var bytes = $it0.next();
			bytesTotal += bytes;
		}
		this.promise.set_progress(bytesTotal);
	}
	,handleLoad: function(entry,asset) {
		this.handleProgress(entry,entry.bytes);
		var name = entry.name;
		switch( (entry.format)[1] ) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
			var value = asset;
			this._pack.textures.set(name,value);
			break;
		case 5:
		case 6:
		case 7:
		case 8:
			var value = asset;
			this._pack.sounds.set(name,value);
			break;
		case 9:
			var value = asset;
			this._pack.files.set(name,value);
			break;
		}
		this._assetsRemaining -= 1;
		if(this._assetsRemaining <= 0) this.handleSuccess();
	}
	,getAssetFormats: function(fn) {
		null;
	}
	,loadEntry: function(url,entry) {
		null;
	}
	,pickBestEntry: function(entries,fn) {
		var onFormatsAvailable = function(formats) {
			var _g = 0;
			while(_g < formats.length) {
				var format = formats[_g];
				++_g;
				var _g1 = 0;
				while(_g1 < entries.length) {
					var entry = entries[_g1];
					++_g1;
					if(entry.format == format) {
						fn(entry);
						return;
					}
				}
			}
			fn(null);
		};
		this.getAssetFormats(onFormatsAvailable);
	}
	,__class__: flambe.platform.BasicAssetPackLoader
}
flambe.platform._BasicAssetPackLoader = {}
flambe.platform._BasicAssetPackLoader.BasicAssetPack = function(manifest) {
	this._manifest = manifest;
	this.textures = new haxe.ds.StringMap();
	this.sounds = new haxe.ds.StringMap();
	this.files = new haxe.ds.StringMap();
};
flambe.platform._BasicAssetPackLoader.BasicAssetPack.__name__ = true;
flambe.platform._BasicAssetPackLoader.BasicAssetPack.__interfaces__ = [flambe.asset.AssetPack];
flambe.platform._BasicAssetPackLoader.BasicAssetPack.prototype = {
	getFile: function(name,required) {
		if(required == null) required = true;
		var file = this.files.get(name);
		if(file == null && required) throw flambe.util.Strings.withFields("Missing file",["name",name]);
		return file;
	}
	,getTexture: function(name,required) {
		if(required == null) required = true;
		var texture = this.textures.get(name);
		if(texture == null && required) throw flambe.util.Strings.withFields("Missing texture",["name",name]);
		return texture;
	}
	,__class__: flambe.platform._BasicAssetPackLoader.BasicAssetPack
}
flambe.platform.BasicKeyboard = function() {
	this.down = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
	this.backButton = new flambe.util.Signal0();
	this._keyStates = new haxe.ds.IntMap();
};
flambe.platform.BasicKeyboard.__name__ = true;
flambe.platform.BasicKeyboard.__interfaces__ = [flambe.input.Keyboard];
flambe.platform.BasicKeyboard.prototype = {
	submitUp: function(keyCode) {
		if(this._keyStates.exists(keyCode)) {
			this._keyStates.remove(keyCode);
			flambe.platform.BasicKeyboard._sharedEvent.init(flambe.platform.BasicKeyboard._sharedEvent.id + 1,flambe.platform.KeyCodes.toKey(keyCode));
			this.up.emit1(flambe.platform.BasicKeyboard._sharedEvent);
		}
	}
	,submitDown: function(keyCode) {
		if(keyCode == 16777238) {
			if(this.backButton._head != null) {
				this.backButton.emit0();
				return true;
			}
			return false;
		}
		if(!this._keyStates.exists(keyCode)) {
			this._keyStates.set(keyCode,true);
			flambe.platform.BasicKeyboard._sharedEvent.init(flambe.platform.BasicKeyboard._sharedEvent.id + 1,flambe.platform.KeyCodes.toKey(keyCode));
			this.down.emit1(flambe.platform.BasicKeyboard._sharedEvent);
		}
		return true;
	}
	,__class__: flambe.platform.BasicKeyboard
}
flambe.platform.BasicMouse = function(pointer) {
	this._pointer = pointer;
	this._source = flambe.input.EventSource.Mouse(flambe.platform.BasicMouse._sharedEvent);
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
	this.scroll = new flambe.util.Signal1();
	this._x = 0;
	this._y = 0;
	this._cursor = flambe.input.MouseCursor.Default;
	this._buttonStates = new haxe.ds.IntMap();
};
flambe.platform.BasicMouse.__name__ = true;
flambe.platform.BasicMouse.__interfaces__ = [flambe.input.Mouse];
flambe.platform.BasicMouse.prototype = {
	prepare: function(viewX,viewY,button) {
		this._x = viewX;
		this._y = viewY;
		flambe.platform.BasicMouse._sharedEvent.init(flambe.platform.BasicMouse._sharedEvent.id + 1,viewX,viewY,button);
	}
	,submitScroll: function(viewX,viewY,velocity) {
		this._x = viewX;
		this._y = viewY;
		if(!(this.scroll._head != null)) return false;
		this.scroll.emit1(velocity);
		return true;
	}
	,submitUp: function(viewX,viewY,buttonCode) {
		if(this._buttonStates.exists(buttonCode)) {
			this._buttonStates.remove(buttonCode);
			this.prepare(viewX,viewY,flambe.platform.MouseCodes.toButton(buttonCode));
			this._pointer.submitUp(viewX,viewY,this._source);
			this.up.emit1(flambe.platform.BasicMouse._sharedEvent);
		}
	}
	,submitMove: function(viewX,viewY) {
		this.prepare(viewX,viewY,null);
		this._pointer.submitMove(viewX,viewY,this._source);
		this.move.emit1(flambe.platform.BasicMouse._sharedEvent);
	}
	,submitDown: function(viewX,viewY,buttonCode) {
		if(!this._buttonStates.exists(buttonCode)) {
			this._buttonStates.set(buttonCode,true);
			this.prepare(viewX,viewY,flambe.platform.MouseCodes.toButton(buttonCode));
			this._pointer.submitDown(viewX,viewY,this._source);
			this.down.emit1(flambe.platform.BasicMouse._sharedEvent);
		}
	}
	,__class__: flambe.platform.BasicMouse
}
flambe.platform.BasicPointer = function(x,y,isDown) {
	if(isDown == null) isDown = false;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
	this._x = x;
	this._y = y;
	this._isDown = isDown;
};
flambe.platform.BasicPointer.__name__ = true;
flambe.platform.BasicPointer.__interfaces__ = [flambe.input.Pointer];
flambe.platform.BasicPointer.prototype = {
	prepare: function(viewX,viewY,hit,source) {
		this._x = viewX;
		this._y = viewY;
		flambe.platform.BasicPointer._sharedEvent.init(flambe.platform.BasicPointer._sharedEvent.id + 1,viewX,viewY,hit,source);
	}
	,submitUp: function(viewX,viewY,source) {
		if(!this._isDown) return;
		this._isDown = false;
		var chain = [];
		var hit = flambe.display.Sprite.hitTest(flambe.System.root,viewX,viewY);
		if(hit != null) {
			var entity = hit.owner;
			do {
				var sprite = entity._compMap.Sprite_1;
				if(sprite != null) chain.push(sprite);
				entity = entity.parent;
			} while(entity != null);
		}
		this.prepare(viewX,viewY,hit,source);
		var _g = 0;
		while(_g < chain.length) {
			var sprite = chain[_g];
			++_g;
			var signal = sprite._pointerUp;
			if(signal != null) {
				signal.emit1(flambe.platform.BasicPointer._sharedEvent);
				if(flambe.platform.BasicPointer._sharedEvent._stopped) return;
			}
		}
		this.up.emit1(flambe.platform.BasicPointer._sharedEvent);
	}
	,submitMove: function(viewX,viewY,source) {
		var chain = [];
		var hit = flambe.display.Sprite.hitTest(flambe.System.root,viewX,viewY);
		if(hit != null) {
			var entity = hit.owner;
			do {
				var sprite = entity._compMap.Sprite_1;
				if(sprite != null) chain.push(sprite);
				entity = entity.parent;
			} while(entity != null);
		}
		this.prepare(viewX,viewY,hit,source);
		var _g = 0;
		while(_g < chain.length) {
			var sprite = chain[_g];
			++_g;
			var signal = sprite._pointerMove;
			if(signal != null) {
				signal.emit1(flambe.platform.BasicPointer._sharedEvent);
				if(flambe.platform.BasicPointer._sharedEvent._stopped) return;
			}
		}
		this.move.emit1(flambe.platform.BasicPointer._sharedEvent);
	}
	,submitDown: function(viewX,viewY,source) {
		if(this._isDown) return;
		this._isDown = true;
		var chain = [];
		var hit = flambe.display.Sprite.hitTest(flambe.System.root,viewX,viewY);
		if(hit != null) {
			var entity = hit.owner;
			do {
				var sprite = entity._compMap.Sprite_1;
				if(sprite != null) chain.push(sprite);
				entity = entity.parent;
			} while(entity != null);
		}
		this.prepare(viewX,viewY,hit,source);
		var _g = 0;
		while(_g < chain.length) {
			var sprite = chain[_g];
			++_g;
			var signal = sprite._pointerDown;
			if(signal != null) {
				signal.emit1(flambe.platform.BasicPointer._sharedEvent);
				if(flambe.platform.BasicPointer._sharedEvent._stopped) return;
			}
		}
		this.down.emit1(flambe.platform.BasicPointer._sharedEvent);
	}
	,__class__: flambe.platform.BasicPointer
}
flambe.platform.BasicTouch = function(pointer,maxPoints) {
	if(maxPoints == null) maxPoints = 4;
	this._pointer = pointer;
	this._maxPoints = maxPoints;
	this._pointMap = new haxe.ds.IntMap();
	this._points = [];
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
};
flambe.platform.BasicTouch.__name__ = true;
flambe.platform.BasicTouch.__interfaces__ = [flambe.input.Touch];
flambe.platform.BasicTouch.prototype = {
	submitUp: function(id,viewX,viewY) {
		var point = this._pointMap.get(id);
		if(point != null) {
			point.init(viewX,viewY);
			this._pointMap.remove(id);
			HxOverrides.remove(this._points,point);
			if(this._pointerTouch == point) {
				this._pointerTouch = null;
				this._pointer.submitUp(viewX,viewY,point._source);
			}
			this.up.emit1(point);
		}
	}
	,submitMove: function(id,viewX,viewY) {
		var point = this._pointMap.get(id);
		if(point != null) {
			point.init(viewX,viewY);
			if(this._pointerTouch == point) this._pointer.submitMove(viewX,viewY,point._source);
			this.move.emit1(point);
		}
	}
	,submitDown: function(id,viewX,viewY) {
		if(!this._pointMap.exists(id)) {
			var point = new flambe.input.TouchPoint(id);
			point.init(viewX,viewY);
			this._pointMap.set(id,point);
			this._points.push(point);
			if(this._pointerTouch == null) {
				this._pointerTouch = point;
				this._pointer.submitDown(viewX,viewY,point._source);
			}
			this.down.emit1(point);
		}
	}
	,__class__: flambe.platform.BasicTouch
}
flambe.sound = {}
flambe.sound.Sound = function() { }
flambe.sound.Sound.__name__ = true;
flambe.platform.DummySound = function() {
	this._playback = new flambe.platform.DummyPlayback(this);
};
flambe.platform.DummySound.__name__ = true;
flambe.platform.DummySound.__interfaces__ = [flambe.sound.Sound];
flambe.platform.DummySound.getInstance = function() {
	if(flambe.platform.DummySound._instance == null) flambe.platform.DummySound._instance = new flambe.platform.DummySound();
	return flambe.platform.DummySound._instance;
}
flambe.platform.DummySound.prototype = {
	__class__: flambe.platform.DummySound
}
flambe.sound.Playback = function() { }
flambe.sound.Playback.__name__ = true;
flambe.sound.Playback.__interfaces__ = [flambe.util.Disposable];
flambe.platform.DummyPlayback = function(sound) {
	this._sound = sound;
	this.volume = new flambe.animation.AnimatedFloat(0);
};
flambe.platform.DummyPlayback.__name__ = true;
flambe.platform.DummyPlayback.__interfaces__ = [flambe.sound.Playback];
flambe.platform.DummyPlayback.prototype = {
	__class__: flambe.platform.DummyPlayback
}
flambe.platform.DummyTouch = function() {
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
};
flambe.platform.DummyTouch.__name__ = true;
flambe.platform.DummyTouch.__interfaces__ = [flambe.input.Touch];
flambe.platform.DummyTouch.prototype = {
	__class__: flambe.platform.DummyTouch
}
flambe.platform.EventGroup = function() {
	this._entries = [];
};
flambe.platform.EventGroup.__name__ = true;
flambe.platform.EventGroup.__interfaces__ = [flambe.util.Disposable];
flambe.platform.EventGroup.prototype = {
	dispose: function() {
		var _g = 0, _g1 = this._entries;
		while(_g < _g1.length) {
			var entry = _g1[_g];
			++_g;
			entry.dispatcher.removeEventListener(entry.type,entry.listener,false);
		}
		this._entries = [];
	}
	,addDisposingListener: function(dispatcher,type,listener) {
		var _g = this;
		this.addListener(dispatcher,type,function(event) {
			_g.dispose();
			listener(event);
		});
	}
	,addListener: function(dispatcher,type,listener) {
		dispatcher.addEventListener(type,listener,false);
		this._entries.push(new flambe.platform._EventGroup.Entry(dispatcher,type,listener));
	}
	,__class__: flambe.platform.EventGroup
}
flambe.platform._EventGroup = {}
flambe.platform._EventGroup.Entry = function(dispatcher,type,listener) {
	this.dispatcher = dispatcher;
	this.type = type;
	this.listener = listener;
};
flambe.platform._EventGroup.Entry.__name__ = true;
flambe.platform._EventGroup.Entry.prototype = {
	__class__: flambe.platform._EventGroup.Entry
}
flambe.platform.KeyCodes = function() { }
flambe.platform.KeyCodes.__name__ = true;
flambe.platform.KeyCodes.toKey = function(keyCode) {
	switch(keyCode) {
	case 65:
		return flambe.input.Key.A;
	case 66:
		return flambe.input.Key.B;
	case 67:
		return flambe.input.Key.C;
	case 68:
		return flambe.input.Key.D;
	case 69:
		return flambe.input.Key.E;
	case 70:
		return flambe.input.Key.F;
	case 71:
		return flambe.input.Key.G;
	case 72:
		return flambe.input.Key.H;
	case 73:
		return flambe.input.Key.I;
	case 74:
		return flambe.input.Key.J;
	case 75:
		return flambe.input.Key.K;
	case 76:
		return flambe.input.Key.L;
	case 77:
		return flambe.input.Key.M;
	case 78:
		return flambe.input.Key.N;
	case 79:
		return flambe.input.Key.O;
	case 80:
		return flambe.input.Key.P;
	case 81:
		return flambe.input.Key.Q;
	case 82:
		return flambe.input.Key.R;
	case 83:
		return flambe.input.Key.S;
	case 84:
		return flambe.input.Key.T;
	case 85:
		return flambe.input.Key.U;
	case 86:
		return flambe.input.Key.V;
	case 87:
		return flambe.input.Key.W;
	case 88:
		return flambe.input.Key.X;
	case 89:
		return flambe.input.Key.Y;
	case 90:
		return flambe.input.Key.Z;
	case 48:
		return flambe.input.Key.Number0;
	case 49:
		return flambe.input.Key.Number1;
	case 50:
		return flambe.input.Key.Number2;
	case 51:
		return flambe.input.Key.Number3;
	case 52:
		return flambe.input.Key.Number4;
	case 53:
		return flambe.input.Key.Number5;
	case 54:
		return flambe.input.Key.Number6;
	case 55:
		return flambe.input.Key.Number7;
	case 56:
		return flambe.input.Key.Number8;
	case 57:
		return flambe.input.Key.Number9;
	case 96:
		return flambe.input.Key.Numpad0;
	case 97:
		return flambe.input.Key.Numpad1;
	case 98:
		return flambe.input.Key.Numpad2;
	case 99:
		return flambe.input.Key.Numpad3;
	case 100:
		return flambe.input.Key.Numpad4;
	case 101:
		return flambe.input.Key.Numpad5;
	case 102:
		return flambe.input.Key.Numpad6;
	case 103:
		return flambe.input.Key.Numpad7;
	case 104:
		return flambe.input.Key.Numpad8;
	case 105:
		return flambe.input.Key.Numpad9;
	case 107:
		return flambe.input.Key.NumpadAdd;
	case 110:
		return flambe.input.Key.NumpadDecimal;
	case 111:
		return flambe.input.Key.NumpadDivide;
	case 108:
		return flambe.input.Key.NumpadEnter;
	case 106:
		return flambe.input.Key.NumpadMultiply;
	case 109:
		return flambe.input.Key.NumpadSubtract;
	case 112:
		return flambe.input.Key.F1;
	case 113:
		return flambe.input.Key.F2;
	case 114:
		return flambe.input.Key.F3;
	case 115:
		return flambe.input.Key.F4;
	case 116:
		return flambe.input.Key.F5;
	case 117:
		return flambe.input.Key.F6;
	case 118:
		return flambe.input.Key.F7;
	case 119:
		return flambe.input.Key.F8;
	case 120:
		return flambe.input.Key.F9;
	case 121:
		return flambe.input.Key.F10;
	case 122:
		return flambe.input.Key.F11;
	case 123:
		return flambe.input.Key.F12;
	case 37:
		return flambe.input.Key.Left;
	case 38:
		return flambe.input.Key.Up;
	case 39:
		return flambe.input.Key.Right;
	case 40:
		return flambe.input.Key.Down;
	case 18:
		return flambe.input.Key.Alt;
	case 192:
		return flambe.input.Key.Backquote;
	case 220:
		return flambe.input.Key.Backslash;
	case 8:
		return flambe.input.Key.Backspace;
	case 20:
		return flambe.input.Key.CapsLock;
	case 188:
		return flambe.input.Key.Comma;
	case 15:
		return flambe.input.Key.Command;
	case 17:
		return flambe.input.Key.Control;
	case 46:
		return flambe.input.Key.Delete;
	case 35:
		return flambe.input.Key.End;
	case 13:
		return flambe.input.Key.Enter;
	case 187:
		return flambe.input.Key.Equals;
	case 27:
		return flambe.input.Key.Escape;
	case 36:
		return flambe.input.Key.Home;
	case 45:
		return flambe.input.Key.Insert;
	case 219:
		return flambe.input.Key.LeftBracket;
	case 189:
		return flambe.input.Key.Minus;
	case 34:
		return flambe.input.Key.PageDown;
	case 33:
		return flambe.input.Key.PageUp;
	case 190:
		return flambe.input.Key.Period;
	case 222:
		return flambe.input.Key.Quote;
	case 221:
		return flambe.input.Key.RightBracket;
	case 186:
		return flambe.input.Key.Semicolon;
	case 16:
		return flambe.input.Key.Shift;
	case 191:
		return flambe.input.Key.Slash;
	case 32:
		return flambe.input.Key.Space;
	case 9:
		return flambe.input.Key.Tab;
	case 16777234:
		return flambe.input.Key.Menu;
	case 16777247:
		return flambe.input.Key.Search;
	}
	return flambe.input.Key.Unknown(keyCode);
}
flambe.platform.MainLoop = function() {
	this._tickables = [];
};
flambe.platform.MainLoop.__name__ = true;
flambe.platform.MainLoop.updateEntity = function(entity,dt) {
	var speed = entity._compMap.SpeedAdjuster_5;
	if(speed != null) {
		speed._realDt = dt;
		dt *= speed.scale._value;
		if(dt <= 0) {
			speed.onUpdate(dt);
			return;
		}
	}
	var p = entity.firstComponent;
	while(p != null) {
		var next = p.next;
		p.onUpdate(dt);
		p = next;
	}
	var p1 = entity.firstChild;
	while(p1 != null) {
		var next = p1.next;
		flambe.platform.MainLoop.updateEntity(p1,dt);
		p1 = next;
	}
}
flambe.platform.MainLoop.prototype = {
	render: function(renderer) {
		var graphics = renderer.willRender();
		if(graphics != null) {
			flambe.display.Sprite.render(flambe.System.root,graphics);
			renderer.didRender();
		}
	}
	,update: function(dt) {
		if(dt <= 0) return;
		if(dt > 1) dt = 1;
		var ii = 0;
		while(ii < this._tickables.length) {
			var t = this._tickables[ii];
			if(t == null || t.update(dt)) this._tickables.splice(ii,1); else ++ii;
		}
		flambe.System.volume.update(dt);
		flambe.platform.MainLoop.updateEntity(flambe.System.root,dt);
	}
	,__class__: flambe.platform.MainLoop
}
flambe.platform.MouseCodes = function() { }
flambe.platform.MouseCodes.__name__ = true;
flambe.platform.MouseCodes.toButton = function(buttonCode) {
	switch(buttonCode) {
	case 0:
		return flambe.input.MouseButton.Left;
	case 1:
		return flambe.input.MouseButton.Middle;
	case 2:
		return flambe.input.MouseButton.Right;
	}
	return flambe.input.MouseButton.Unknown(buttonCode);
}
flambe.platform.Renderer = function() { }
flambe.platform.Renderer.__name__ = true;
flambe.platform.Renderer.prototype = {
	__class__: flambe.platform.Renderer
}
flambe.platform.Tickable = function() { }
flambe.platform.Tickable.__name__ = true;
flambe.platform.Tickable.prototype = {
	__class__: flambe.platform.Tickable
}
flambe.platform.html.CanvasGraphics = function(canvas) {
	this._firstDraw = false;
	this._canvasCtx = canvas.getContext("2d");
};
flambe.platform.html.CanvasGraphics.__name__ = true;
flambe.platform.html.CanvasGraphics.__interfaces__ = [flambe.display.Graphics];
flambe.platform.html.CanvasGraphics.prototype = {
	willRender: function() {
		this._firstDraw = true;
	}
	,applyScissor: function(x,y,width,height) {
		this._canvasCtx.beginPath();
		this._canvasCtx.rect(x | 0,y | 0,width | 0,height | 0);
		this._canvasCtx.clip();
	}
	,setBlendMode: function(blendMode) {
		var op;
		switch( (blendMode)[1] ) {
		case 0:
			op = "source-over";
			break;
		case 1:
			op = "lighter";
			break;
		case 2:
			op = "source-over";
			break;
		}
		this._canvasCtx.globalCompositeOperation = op;
	}
	,multiplyAlpha: function(factor) {
		this._canvasCtx.globalAlpha *= factor;
	}
	,fillRect: function(color,x,y,width,height) {
		if(this._firstDraw) {
			this._firstDraw = false;
			this._canvasCtx.globalCompositeOperation = "copy";
			this.fillRect(color,x,y,width,height);
			this._canvasCtx.globalCompositeOperation = "source-over";
			return;
		}
		this._canvasCtx.fillStyle = "#" + ("00000" + color.toString(16)).slice(-6);
		this._canvasCtx.fillRect(x | 0,y | 0,width | 0,height | 0);
	}
	,drawSubImage: function(texture,destX,destY,sourceX,sourceY,sourceW,sourceH) {
		if(this._firstDraw) {
			this._firstDraw = false;
			this._canvasCtx.globalCompositeOperation = "copy";
			this.drawSubImage(texture,destX,destY,sourceX,sourceY,sourceW,sourceH);
			this._canvasCtx.globalCompositeOperation = "source-over";
			return;
		}
		var texture1 = texture;
		this._canvasCtx.drawImage(texture1.image,sourceX | 0,sourceY | 0,sourceW | 0,sourceH | 0,destX | 0,destY | 0,sourceW | 0,sourceH | 0);
	}
	,restore: function() {
		this._canvasCtx.restore();
	}
	,transform: function(m00,m10,m01,m11,m02,m12) {
		this._canvasCtx.transform(m00,m10,m01,m11,m02 | 0,m12 | 0);
	}
	,save: function() {
		this._canvasCtx.save();
	}
	,__class__: flambe.platform.html.CanvasGraphics
}
flambe.platform.html.CanvasRenderer = function(canvas) {
	this._graphics = new flambe.platform.html.CanvasGraphics(canvas);
};
flambe.platform.html.CanvasRenderer.__name__ = true;
flambe.platform.html.CanvasRenderer.__interfaces__ = [flambe.platform.Renderer];
flambe.platform.html.CanvasRenderer.prototype = {
	didRender: function() {
	}
	,willRender: function() {
		this._graphics.willRender();
		return this._graphics;
	}
	,createTexture: function(image) {
		return new flambe.platform.html.CanvasTexture(flambe.platform.html.CanvasRenderer.CANVAS_TEXTURES?flambe.platform.html.HtmlUtil.createCanvas(image):image);
	}
	,__class__: flambe.platform.html.CanvasRenderer
}
flambe.platform.html.CanvasTexture = function(image) {
	this.image = image;
};
flambe.platform.html.CanvasTexture.__name__ = true;
flambe.platform.html.CanvasTexture.__interfaces__ = [flambe.display.Texture];
flambe.platform.html.CanvasTexture.prototype = {
	__class__: flambe.platform.html.CanvasTexture
}
flambe.platform.html.HtmlAssetPackLoader = function(platform,manifest) {
	flambe.platform.BasicAssetPackLoader.call(this,platform,manifest);
};
flambe.platform.html.HtmlAssetPackLoader.__name__ = true;
flambe.platform.html.HtmlAssetPackLoader.detectImageFormats = function(fn) {
	var formats = [flambe.asset.AssetFormat.PNG,flambe.asset.AssetFormat.JPG,flambe.asset.AssetFormat.GIF];
	var formatTests = 2;
	var checkRemaining = function() {
		--formatTests;
		if(formatTests == 0) fn(formats);
	};
	var webp = js.Browser.document.createElement("img");
	webp.onload = webp.onerror = function(_) {
		if(webp.width == 1) formats.unshift(flambe.asset.AssetFormat.WEBP);
		checkRemaining();
	};
	webp.src = "data:image/webp;base64,UklGRhoAAABXRUJQVlA4TA0AAAAvAAAAEAcQERGIiP4HAA==";
	var jxr = js.Browser.document.createElement("img");
	jxr.onload = jxr.onerror = function(_) {
		if(jxr.width == 1) formats.unshift(flambe.asset.AssetFormat.JXR);
		checkRemaining();
	};
	jxr.src = "data:image/vnd.ms-photo;base64,SUm8AQgAAAAFAAG8AQAQAAAASgAAAIC8BAABAAAAAQAAAIG8BAABAAAAAQAAAMC8BAABAAAAWgAAAMG8BAABAAAAHwAAAAAAAAAkw91vA07+S7GFPXd2jckNV01QSE9UTwAZAYBxAAAAABP/gAAEb/8AAQAAAQAAAA==";
}
flambe.platform.html.HtmlAssetPackLoader.detectAudioFormats = function() {
	var audio = js.Browser.document.createElement("audio");
	if(audio == null || $bind(audio,audio.canPlayType) == null) return [];
	var blacklist = new EReg("\\b(iPhone|iPod|iPad|Android)\\b","");
	var userAgent = js.Browser.window.navigator.userAgent;
	if(!flambe.platform.html.WebAudioSound.get_supported() && blacklist.match(userAgent)) return [];
	var types = [{ format : flambe.asset.AssetFormat.M4A, mimeType : "audio/mp4; codecs=mp4a"},{ format : flambe.asset.AssetFormat.MP3, mimeType : "audio/mpeg"},{ format : flambe.asset.AssetFormat.OGG, mimeType : "audio/ogg; codecs=vorbis"},{ format : flambe.asset.AssetFormat.WAV, mimeType : "audio/wav"}];
	var result = [];
	var _g = 0;
	while(_g < types.length) {
		var type = types[_g];
		++_g;
		var canPlayType = "";
		try {
			canPlayType = audio.canPlayType(type.mimeType);
		} catch( _ ) {
		}
		if(canPlayType != "") result.push(type.format);
	}
	return result;
}
flambe.platform.html.HtmlAssetPackLoader.supportsBlob = function() {
	if(flambe.platform.html.HtmlAssetPackLoader._detectBlobSupport) {
		flambe.platform.html.HtmlAssetPackLoader._detectBlobSupport = false;
		var xhr = new XMLHttpRequest();
		xhr.open("GET",".",true);
		xhr.responseType = "blob";
		if(xhr.responseType != "blob") return false;
		flambe.platform.html.HtmlAssetPackLoader._URL = flambe.platform.html.HtmlUtil.loadExtension("URL").value;
	}
	return flambe.platform.html.HtmlAssetPackLoader._URL != null && flambe.platform.html.HtmlAssetPackLoader._URL.createObjectURL != null;
}
flambe.platform.html.HtmlAssetPackLoader.__super__ = flambe.platform.BasicAssetPackLoader;
flambe.platform.html.HtmlAssetPackLoader.prototype = $extend(flambe.platform.BasicAssetPackLoader.prototype,{
	sendRequest: function(url,entry,responseType,onLoad) {
		var _g = this;
		var xhr = new XMLHttpRequest();
		var lastActivity = 0.0;
		var start = function() {
			lastActivity = Date.now();
			xhr.open("GET",url,true);
			xhr.responseType = responseType;
			if(xhr.responseType == "") xhr.responseType = "arraybuffer";
			xhr.send();
		};
		var interval = 0;
		if(typeof(xhr.onprogress) != "undefined") {
			var attempts = 4;
			xhr.onprogress = function(event) {
				lastActivity = Date.now();
				_g.handleProgress(entry,event.loaded);
			};
			interval = js.Browser.window.setInterval(function() {
				if(xhr.readyState >= 1 && Date.now() - lastActivity > 5000) {
					xhr.abort();
					--attempts;
					if(attempts > 0) start(); else {
						js.Browser.window.clearInterval(interval);
						_g.handleError(entry,"Request timed out");
					}
				}
			},1000);
		}
		xhr.onload = function(_) {
			js.Browser.window.clearInterval(interval);
			var response = xhr.response;
			if(response == null) response = xhr.responseText; else if(responseType == "blob" && xhr.responseType == "arraybuffer") response = new Blob([xhr.response]);
			onLoad(response);
		};
		xhr.onerror = function(_) {
			js.Browser.window.clearInterval(interval);
			_g.handleError(entry,"Failed to load asset: error #" + xhr.status);
		};
		start();
		return xhr;
	}
	,getAssetFormats: function(fn) {
		if(flambe.platform.html.HtmlAssetPackLoader._supportedFormats == null) {
			flambe.platform.html.HtmlAssetPackLoader._supportedFormats = new flambe.util.Promise();
			flambe.platform.html.HtmlAssetPackLoader.detectImageFormats(function(imageFormats) {
				flambe.platform.html.HtmlAssetPackLoader._supportedFormats.set_result(imageFormats.concat(flambe.platform.html.HtmlAssetPackLoader.detectAudioFormats()).concat([flambe.asset.AssetFormat.Data]));
			});
		}
		flambe.platform.html.HtmlAssetPackLoader._supportedFormats.get(fn);
	}
	,loadEntry: function(url,entry) {
		var _g = this;
		switch( (entry.format)[1] ) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
			var image = js.Browser.document.createElement("img");
			var events = new flambe.platform.EventGroup();
			events.addDisposingListener(image,"load",function(_) {
				if(flambe.platform.html.HtmlAssetPackLoader.supportsBlob()) flambe.platform.html.HtmlAssetPackLoader._URL.revokeObjectURL(image.src);
				var texture = _g._platform.getRenderer().createTexture(image);
				if(texture != null) _g.handleLoad(entry,texture); else _g.handleTextureError(entry);
			});
			events.addDisposingListener(image,"error",function(_) {
				_g.handleError(entry,"Failed to load image");
			});
			if(flambe.platform.html.HtmlAssetPackLoader.supportsBlob()) this.sendRequest(url,entry,"blob",function(blob) {
				image.src = flambe.platform.html.HtmlAssetPackLoader._URL.createObjectURL(blob);
			}); else image.src = url;
			break;
		case 5:
		case 6:
		case 7:
		case 8:
			if(flambe.platform.html.WebAudioSound.get_supported()) this.sendRequest(url,entry,"arraybuffer",function(buffer) {
				flambe.platform.html.WebAudioSound.ctx.decodeAudioData(buffer,function(decoded) {
					_g.handleLoad(entry,new flambe.platform.html.WebAudioSound(decoded));
				},function() {
					_g.handleLoad(entry,flambe.platform.DummySound.getInstance());
				});
			}); else {
				var audio = js.Browser.document.createElement("audio");
				audio.preload = "auto";
				var ref = ++flambe.platform.html.HtmlAssetPackLoader._mediaRefCount;
				if(flambe.platform.html.HtmlAssetPackLoader._mediaElements == null) flambe.platform.html.HtmlAssetPackLoader._mediaElements = new haxe.ds.IntMap();
				flambe.platform.html.HtmlAssetPackLoader._mediaElements.set(ref,audio);
				var events = new flambe.platform.EventGroup();
				events.addDisposingListener(audio,"canplaythrough",function(_) {
					flambe.platform.html.HtmlAssetPackLoader._mediaElements.remove(ref);
					_g.handleLoad(entry,new flambe.platform.html.HtmlSound(audio));
				});
				events.addDisposingListener(audio,"error",function(_) {
					flambe.platform.html.HtmlAssetPackLoader._mediaElements.remove(ref);
					var code = audio.error.code;
					if(code == 3 || code == 4) _g.handleLoad(entry,flambe.platform.DummySound.getInstance()); else _g.handleError(entry,"Failed to load audio: " + audio.error.code);
				});
				events.addListener(audio,"progress",function(_) {
					if(audio.buffered.length > 0 && audio.duration > 0) {
						var progress = audio.buffered.end(0) / audio.duration;
						_g.handleProgress(entry,progress * entry.bytes | 0);
					}
				});
				audio.src = url;
				audio.load();
			}
			break;
		case 9:
			this.sendRequest(url,entry,"text",function(text) {
				_g.handleLoad(entry,text);
			});
			break;
		}
	}
	,__class__: flambe.platform.html.HtmlAssetPackLoader
});
flambe.platform.html.HtmlMouse = function(pointer,canvas) {
	flambe.platform.BasicMouse.call(this,pointer);
	this._canvas = canvas;
};
flambe.platform.html.HtmlMouse.__name__ = true;
flambe.platform.html.HtmlMouse.__super__ = flambe.platform.BasicMouse;
flambe.platform.html.HtmlMouse.prototype = $extend(flambe.platform.BasicMouse.prototype,{
	__class__: flambe.platform.html.HtmlMouse
});
flambe.platform.html.HtmlSound = function(audioElement) {
	this.audioElement = audioElement;
};
flambe.platform.html.HtmlSound.__name__ = true;
flambe.platform.html.HtmlSound.__interfaces__ = [flambe.sound.Sound];
flambe.platform.html.HtmlSound.prototype = {
	__class__: flambe.platform.html.HtmlSound
}
flambe.platform.html.HtmlStage = function(canvas) {
	var _g = this;
	this._canvas = canvas;
	this.resize = new flambe.util.Signal0();
	this.scaleFactor = flambe.platform.html.HtmlStage.computeScaleFactor();
	if(this.scaleFactor != 1) {
		flambe.platform.html.HtmlUtil.setVendorStyle(this._canvas,"transform-origin","top left");
		flambe.platform.html.HtmlUtil.setVendorStyle(this._canvas,"transform","scale(" + 1 / this.scaleFactor + ")");
	}
	if(flambe.platform.html.HtmlUtil.SHOULD_HIDE_MOBILE_BROWSER) {
		js.Browser.window.addEventListener("orientationchange",function(_) {
			flambe.platform.html.HtmlUtil.callLater($bind(_g,_g.hideMobileBrowser),200);
		},false);
		this.hideMobileBrowser();
	}
	js.Browser.window.addEventListener("resize",$bind(this,this.onWindowResize),false);
	this.onWindowResize(null);
	this.orientation = new flambe.util.Value(null);
	if(js.Browser.window.orientation != null) {
		js.Browser.window.addEventListener("orientationchange",$bind(this,this.onOrientationChange),false);
		this.onOrientationChange(null);
	}
	this.fullscreen = new flambe.util.Value(false);
	flambe.platform.html.HtmlUtil.addVendorListener(js.Browser.document,"fullscreenchange",function(_) {
		_g.updateFullscreen();
	},false);
	this.updateFullscreen();
};
flambe.platform.html.HtmlStage.__name__ = true;
flambe.platform.html.HtmlStage.__interfaces__ = [flambe.display.Stage];
flambe.platform.html.HtmlStage.computeScaleFactor = function() {
	var devicePixelRatio = js.Browser.window.devicePixelRatio;
	if(devicePixelRatio == null) devicePixelRatio = 1;
	var canvas = js.Browser.document.createElement("canvas");
	var ctx = canvas.getContext("2d");
	var backingStorePixelRatio = flambe.platform.html.HtmlUtil.loadExtension("backingStorePixelRatio",ctx).value;
	if(backingStorePixelRatio == null) backingStorePixelRatio = 1;
	var scale = devicePixelRatio / backingStorePixelRatio;
	var screenWidth = js.Browser.window.screen.width;
	var screenHeight = js.Browser.window.screen.height;
	if(scale * screenWidth > 1024 || scale * screenHeight > 1024) return 1;
	return scale;
}
flambe.platform.html.HtmlStage.prototype = {
	updateFullscreen: function() {
		var state = flambe.platform.html.HtmlUtil.loadFirstExtension(["fullscreen","fullScreen","isFullScreen"],js.Browser.document).value;
		this.fullscreen.set__(state == true);
	}
	,onOrientationChange: function(_) {
		var value = flambe.platform.html.HtmlUtil.orientation(js.Browser.window.orientation);
		this.orientation.set__(value);
	}
	,hideMobileBrowser: function() {
		var _g = this;
		var mobileAddressBar = 100;
		var htmlStyle = js.Browser.document.documentElement.style;
		htmlStyle.height = js.Browser.window.innerHeight + mobileAddressBar + "px";
		htmlStyle.width = js.Browser.window.innerWidth + "px";
		htmlStyle.overflow = "visible";
		flambe.platform.html.HtmlUtil.callLater(function() {
			flambe.platform.html.HtmlUtil.hideMobileBrowser();
			flambe.platform.html.HtmlUtil.callLater(function() {
				htmlStyle.height = js.Browser.window.innerHeight + "px";
				_g.onWindowResize(null);
			},100);
		});
	}
	,resizeCanvas: function(width,height) {
		var scaledWidth = this.scaleFactor * width;
		var scaledHeight = this.scaleFactor * height;
		if(this._canvas.width == scaledWidth && this._canvas.height == scaledHeight) return false;
		this._canvas.width = scaledWidth | 0;
		this._canvas.height = scaledHeight | 0;
		this.resize.emit0();
		return true;
	}
	,onWindowResize: function(_) {
		var container = this._canvas.parentElement;
		var rect = container.getBoundingClientRect();
		this.resizeCanvas(rect.width,rect.height);
	}
	,get_height: function() {
		return this._canvas.height;
	}
	,get_width: function() {
		return this._canvas.width;
	}
	,__class__: flambe.platform.html.HtmlStage
}
flambe.platform.html.HtmlUtil = function() { }
flambe.platform.html.HtmlUtil.__name__ = true;
flambe.platform.html.HtmlUtil.callLater = function(func,delay) {
	if(delay == null) delay = 0;
	js.Browser.window.setTimeout(func,delay);
}
flambe.platform.html.HtmlUtil.hideMobileBrowser = function() {
	js.Browser.window.scrollTo(1,0);
}
flambe.platform.html.HtmlUtil.loadExtension = function(name,obj) {
	if(obj == null) obj = js.Browser.window;
	var extension = Reflect.field(obj,name);
	if(extension != null) return { prefix : null, field : name, value : extension};
	var capitalized = name.charAt(0).toUpperCase() + HxOverrides.substr(name,1,null);
	var _g = 0, _g1 = flambe.platform.html.HtmlUtil.VENDOR_PREFIXES;
	while(_g < _g1.length) {
		var prefix = _g1[_g];
		++_g;
		var field = prefix + capitalized;
		var extension1 = Reflect.field(obj,field);
		if(extension1 != null) return { prefix : prefix, field : field, value : extension1};
	}
	return { prefix : null, field : null, value : null};
}
flambe.platform.html.HtmlUtil.loadFirstExtension = function(names,obj) {
	var _g = 0;
	while(_g < names.length) {
		var name = names[_g];
		++_g;
		var extension = flambe.platform.html.HtmlUtil.loadExtension(name,obj);
		if(extension.field != null) return extension;
	}
	return { prefix : null, field : null, value : null};
}
flambe.platform.html.HtmlUtil.polyfill = function(name,obj) {
	if(obj == null) obj = js.Browser.window;
	var value = flambe.platform.html.HtmlUtil.loadExtension(name,obj).value;
	if(value == null) return false;
	obj[name] = value;
	return true;
}
flambe.platform.html.HtmlUtil.setVendorStyle = function(element,name,value) {
	var style = element.style;
	var _g = 0, _g1 = flambe.platform.html.HtmlUtil.VENDOR_PREFIXES;
	while(_g < _g1.length) {
		var prefix = _g1[_g];
		++_g;
		style.setProperty("-" + prefix + "-" + name,value);
	}
	style.setProperty(name,value);
}
flambe.platform.html.HtmlUtil.addVendorListener = function(dispatcher,type,listener,useCapture) {
	var _g = 0, _g1 = flambe.platform.html.HtmlUtil.VENDOR_PREFIXES;
	while(_g < _g1.length) {
		var prefix = _g1[_g];
		++_g;
		dispatcher.addEventListener(prefix + type,listener,useCapture);
	}
	dispatcher.addEventListener(type,listener,useCapture);
}
flambe.platform.html.HtmlUtil.orientation = function(angle) {
	switch(angle) {
	case -90:case 90:
		return flambe.display.Orientation.Landscape;
	default:
		return flambe.display.Orientation.Portrait;
	}
}
flambe.platform.html.HtmlUtil.createEmptyCanvas = function(width,height) {
	var canvas = js.Browser.document.createElement("canvas");
	canvas.width = width;
	canvas.height = height;
	return canvas;
}
flambe.platform.html.HtmlUtil.createCanvas = function(source) {
	var canvas = flambe.platform.html.HtmlUtil.createEmptyCanvas(source.width,source.height);
	var ctx = canvas.getContext("2d");
	ctx.save();
	ctx.globalCompositeOperation = "copy";
	ctx.drawImage(source,0,0);
	ctx.restore();
	return canvas;
}
flambe.platform.html.WebAudioSound = function(buffer) {
	this.buffer = buffer;
};
flambe.platform.html.WebAudioSound.__name__ = true;
flambe.platform.html.WebAudioSound.__interfaces__ = [flambe.sound.Sound];
flambe.platform.html.WebAudioSound.get_supported = function() {
	if(flambe.platform.html.WebAudioSound._detectSupport) {
		flambe.platform.html.WebAudioSound._detectSupport = false;
		var AudioContext = flambe.platform.html.HtmlUtil.loadExtension("AudioContext").value;
		if(AudioContext != null) {
			flambe.platform.html.WebAudioSound.ctx = new AudioContext();
			flambe.platform.html.WebAudioSound.gain = flambe.platform.html.WebAudioSound.ctx.createGainNode();
			flambe.platform.html.WebAudioSound.gain.connect(flambe.platform.html.WebAudioSound.ctx.destination);
			flambe.System.volume.watch(function(volume,_) {
				flambe.platform.html.WebAudioSound.gain.gain.value = volume;
			});
		}
	}
	return flambe.platform.html.WebAudioSound.ctx != null;
}
flambe.platform.html.WebAudioSound.prototype = {
	__class__: flambe.platform.html.WebAudioSound
}
flambe.scene = {}
flambe.scene.Director = function() {
	this._transitor = null;
};
flambe.scene.Director.__name__ = true;
flambe.scene.Director.__super__ = flambe.Component;
flambe.scene.Director.prototype = $extend(flambe.Component.prototype,{
	completeTransition: function() {
		if(this._transitor != null) {
			this._transitor.complete();
			this._transitor = null;
			this.invalidateVisibility();
		}
	}
	,invalidateVisibility: function() {
		var ii = this.scenes.length;
		while(ii > 0) {
			var scene = this.scenes[--ii];
			var comp = scene._compMap.Scene_4;
			if(comp == null || comp.opaque) break;
		}
		this.occludedScenes = this.scenes.length > 0?this.scenes.slice(ii,this.scenes.length - 1):[];
		var scene = this.get_topScene();
		if(scene != null) this.show(scene);
	}
	,show: function(scene) {
		var events = scene._compMap.Scene_4;
		if(events != null) events.shown.emit0();
	}
	,get_topScene: function() {
		var ll = this.scenes.length;
		return ll > 0?this.scenes[ll - 1]:null;
	}
	,onUpdate: function(dt) {
		if(this._transitor != null && this._transitor.update(dt)) this.completeTransition();
	}
	,onRemoved: function() {
		this.completeTransition();
		var _g = 0, _g1 = this.scenes;
		while(_g < _g1.length) {
			var scene = _g1[_g];
			++_g;
			scene.dispose();
		}
		this.scenes = [];
		this.occludedScenes = [];
		this._root.dispose();
	}
	,onAdded: function() {
		this.owner.addChild(this._root);
	}
	,get_name: function() {
		return "Director_3";
	}
	,__class__: flambe.scene.Director
});
flambe.scene._Director = {}
flambe.scene._Director.Transitor = function() { }
flambe.scene._Director.Transitor.__name__ = true;
flambe.scene._Director.Transitor.prototype = {
	complete: function() {
		this._transition.complete();
		this._onComplete();
	}
	,update: function(dt) {
		return this._transition.update(dt);
	}
	,__class__: flambe.scene._Director.Transitor
}
flambe.scene.Scene = function() { }
flambe.scene.Scene.__name__ = true;
flambe.scene.Scene.__super__ = flambe.Component;
flambe.scene.Scene.prototype = $extend(flambe.Component.prototype,{
	get_name: function() {
		return "Scene_4";
	}
	,__class__: flambe.scene.Scene
});
flambe.scene.Transition = function() { }
flambe.scene.Transition.__name__ = true;
flambe.scene.Transition.prototype = {
	complete: function() {
	}
	,update: function(dt) {
		return true;
	}
	,__class__: flambe.scene.Transition
}
flambe.util.Promise = function() {
	this.success = new flambe.util.Signal1();
	this.error = new flambe.util.Signal1();
	this.progressChanged = new flambe.util.Signal0();
	this.hasResult = false;
	this._progress = 0;
	this._total = 0;
};
flambe.util.Promise.__name__ = true;
flambe.util.Promise.prototype = {
	set_total: function(total) {
		if(this._total != total) {
			this._total = total;
			this.progressChanged.emit0();
		}
		return total;
	}
	,set_progress: function(progress) {
		if(this._progress != progress) {
			this._progress = progress;
			this.progressChanged.emit0();
		}
		return progress;
	}
	,get: function(fn) {
		if(this.hasResult) {
			fn(this._result);
			return null;
		}
		return this.success.connect(fn).once();
	}
	,set_result: function(result) {
		if(this.hasResult) throw "Promise result already assigned";
		this._result = result;
		this.hasResult = true;
		this.success.emit1(result);
		return result;
	}
	,__class__: flambe.util.Promise
}
flambe.util.Signal0 = function(listener) {
	flambe.util.SignalBase.call(this,listener);
};
flambe.util.Signal0.__name__ = true;
flambe.util.Signal0.__super__ = flambe.util.SignalBase;
flambe.util.Signal0.prototype = $extend(flambe.util.SignalBase.prototype,{
	connect: function(listener,prioritize) {
		if(prioritize == null) prioritize = false;
		return this.connectImpl(listener,prioritize);
	}
	,__class__: flambe.util.Signal0
});
flambe.util._SignalBase = {}
flambe.util._SignalBase.Task = function(fn) {
	this.next = null;
	this.fn = fn;
};
flambe.util._SignalBase.Task.__name__ = true;
flambe.util._SignalBase.Task.prototype = {
	__class__: flambe.util._SignalBase.Task
}
var haxe = {}
haxe.Json = function() {
};
haxe.Json.__name__ = true;
haxe.Json.parse = function(text) {
	return new haxe.Json().doParse(text);
}
haxe.Json.prototype = {
	parseNumber: function(c) {
		var start = this.pos - 1;
		var minus = c == 45, digit = !minus, zero = c == 48;
		var point = false, e = false, pm = false, end = false;
		while(true) {
			c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 48:
				if(zero && !point) this.invalidNumber(start);
				if(minus) {
					minus = false;
					zero = true;
				}
				digit = true;
				break;
			case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:
				if(zero && !point) this.invalidNumber(start);
				if(minus) minus = false;
				digit = true;
				zero = false;
				break;
			case 46:
				if(minus || point) this.invalidNumber(start);
				digit = false;
				point = true;
				break;
			case 101:case 69:
				if(minus || zero || e) this.invalidNumber(start);
				digit = false;
				e = true;
				break;
			case 43:case 45:
				if(!e || pm) this.invalidNumber(start);
				digit = false;
				pm = true;
				break;
			default:
				if(!digit) this.invalidNumber(start);
				this.pos--;
				end = true;
			}
			if(end) break;
		}
		var f = Std.parseFloat(HxOverrides.substr(this.str,start,this.pos - start));
		var i = f | 0;
		return i == f?i:f;
	}
	,invalidNumber: function(start) {
		throw "Invalid number at position " + start + ": " + HxOverrides.substr(this.str,start,this.pos - start);
	}
	,parseString: function() {
		var start = this.pos;
		var buf = new StringBuf();
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			if(c == 34) break;
			if(c == 92) {
				buf.addSub(this.str,start,this.pos - start - 1);
				c = this.str.charCodeAt(this.pos++);
				switch(c) {
				case 114:
					buf.b += "\r";
					break;
				case 110:
					buf.b += "\n";
					break;
				case 116:
					buf.b += "\t";
					break;
				case 98:
					buf.b += "";
					break;
				case 102:
					buf.b += "";
					break;
				case 47:case 92:case 34:
					buf.b += String.fromCharCode(c);
					break;
				case 117:
					var uc = Std.parseInt("0x" + HxOverrides.substr(this.str,this.pos,4));
					this.pos += 4;
					buf.b += String.fromCharCode(uc);
					break;
				default:
					throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (this.pos - 1);
				}
				start = this.pos;
			} else if(c != c) throw "Unclosed string";
		}
		buf.addSub(this.str,start,this.pos - start - 1);
		return buf.b;
	}
	,parseRec: function() {
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 32:case 13:case 10:case 9:
				break;
			case 123:
				var obj = { }, field = null, comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 125:
						if(field != null || comma == false) this.invalidChar();
						return obj;
					case 58:
						if(field == null) this.invalidChar();
						obj[field] = this.parseRec();
						field = null;
						comma = true;
						break;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					case 34:
						if(comma) this.invalidChar();
						field = this.parseString();
						break;
					default:
						this.invalidChar();
					}
				}
				break;
			case 91:
				var arr = [], comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 93:
						if(comma == false) this.invalidChar();
						return arr;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					default:
						if(comma) this.invalidChar();
						this.pos--;
						arr.push(this.parseRec());
						comma = true;
					}
				}
				break;
			case 116:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 114 || this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return true;
			case 102:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 97 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 115 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return false;
			case 110:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 108) {
					this.pos = save;
					this.invalidChar();
				}
				return null;
			case 34:
				return this.parseString();
			case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:
				return this.parseNumber(c);
			default:
				this.invalidChar();
			}
		}
	}
	,invalidChar: function() {
		this.pos--;
		throw "Invalid char " + this.str.charCodeAt(this.pos) + " at position " + this.pos;
	}
	,doParse: function(str) {
		this.str = str;
		this.pos = 0;
		return this.parseRec();
	}
	,__class__: haxe.Json
}
haxe.ds = {}
haxe.ds.IntMap = function() {
	this.h = { };
};
haxe.ds.IntMap.__name__ = true;
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,__class__: haxe.ds.IntMap
}
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_, $fid = 0;
function $bind(o,m) { if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
if(typeof(JSON) != "undefined") haxe.Json = JSON;
flambe.platform.html.HtmlPlatform.instance = new flambe.platform.html.HtmlPlatform();
flambe.util.SignalBase.DISPATCHING_SENTINEL = new flambe.util.SignalConnection(null,null);
flambe.System.root = new flambe.Entity();
flambe.System.uncaughtError = new flambe.util.Signal1();
flambe.System.hidden = new flambe.util.Value(false);
flambe.System.hasGPU = new flambe.util.Value(false);
flambe.System.volume = new flambe.animation.AnimatedFloat(1);
flambe.System._platform = flambe.platform.html.HtmlPlatform.instance;
flambe.System._calledInit = false;
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
js.Browser.navigator = typeof window != "undefined" ? window.navigator : null;
flambe.asset.Manifest._buildManifest = flambe.asset.Manifest.createBuildManifests();
flambe.asset.Manifest._supportsCrossOrigin = (function() {
	var blacklist = new EReg("\\b(Android)\\b","");
	if(blacklist.match(js.Browser.window.navigator.userAgent)) return false;
	var xhr = new XMLHttpRequest();
	return xhr.withCredentials != null;
})();
flambe.display.Sprite._scratchPoint = new flambe.math.Point();
flambe.display.Font.NEWLINE = new flambe.display.Glyph(10);
flambe.platform.BasicKeyboard._sharedEvent = new flambe.input.KeyboardEvent();
flambe.platform.BasicMouse._sharedEvent = new flambe.input.MouseEvent();
flambe.platform.BasicPointer._sharedEvent = new flambe.input.PointerEvent();
flambe.platform.html.CanvasRenderer.CANVAS_TEXTURES = (function() {
	var pattern = new EReg("(iPhone|iPod|iPad)","");
	return pattern.match(js.Browser.window.navigator.userAgent);
})();
flambe.platform.html.HtmlAssetPackLoader._mediaRefCount = 0;
flambe.platform.html.HtmlAssetPackLoader._detectBlobSupport = true;
flambe.platform.html.HtmlUtil.VENDOR_PREFIXES = ["webkit","moz","ms","o","khtml"];
flambe.platform.html.HtmlUtil.SHOULD_HIDE_MOBILE_BROWSER = js.Browser.window.top == js.Browser.window && new EReg("Mobile(/.*)? Safari","").match(js.Browser.window.navigator.userAgent);
flambe.platform.html.WebAudioSound._detectSupport = true;
TestSpriteSheet.main();
})();
