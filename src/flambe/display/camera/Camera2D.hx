package flambe.display.camera;
import flambe.animation.AnimatedFloat;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.math.FMath;
import flambe.math.Rectangle;
import flambe.System;

import flambe.math.Matrix;
using flambe.EntityHelper;

/**
 * ...
 * @author sonygod
 */
class Camera2D
{

	@:isVar public var x(get, set) :AnimatedFloat ;
	@:isVar public var y(get, set) :AnimatedFloat ;
	@:isVar public var angle(get, set) :AnimatedFloat ;
	@:isVar public var zoom(get, set) :AnimatedFloat ;
	
	@:isVar public var viewportWidth(get, null) :Float ;
	@:isVar public var viewportHeight(get, null) :Float ;
	@:isVar public var rx(get, null) :Float ;
	@:isVar public var ry(get, null) :Float ;
	
	@:isVar public var radAngle(get, null) :Float ;
	private var canvas:Entity;
	private var viewPort:Rectangle;
	private var anchor:Anchor;
	private var locked:Bool;
	
	private var _x:AnimatedFloat;
	private var _y:AnimatedFloat;
	private var _angle:AnimatedFloat;
	private var _zoom:AnimatedFloat;
	
	
	private var unuse:Sprite;
	public function new(canvas:Entity,viewPort:Rectangle,?anchor:Anchor=null) 
	{
		this.canvas = canvas;
		if(anchor!=null)
		this.anchor = anchor; 
		else
		this.anchor = Anchor.center;
		if(viewPort!=null)
		this.viewPort = viewPort;
		else
		this.viewPort=new Rectangle(0, 0, System.stage.width, System.stage.height);
	locked = false;
		}
	
	public function lock():Void {
		locked = true;
	}
	public function unLock():Void {
		locked = false;
		fullUpdate();
	}
	
	private function get_x():AnimatedFloat {
		
		return _x;
	}
	
	private function set_x(v:AnimatedFloat):AnimatedFloat {
		_x = v;
		limitX();
		update();
		return _x;
	}
	
	private function get_y():AnimatedFloat {
		
		return _x;
	}
	
	private function set_y(v:AnimatedFloat):AnimatedFloat {
		_y = v;
		limitY();
		update();
		return _y;
	}
	
	private function get_zoom():AnimatedFloat {
		
		return _zoom;
	}
	
	private function set_zoom(v:AnimatedFloat):AnimatedFloat {
		_zoom = v;
		fullUpdate();
		return _zoom;
	}
	
	private function get_angle():AnimatedFloat {
		
		return _angle;
	}
	
	private function set_angle(v:AnimatedFloat):AnimatedFloat {
		_angle = v;
		
		update();
		return _x;
	}
	
	   private function limitX() : Void
		{
			// necessary
			canvas.applychildsProperty("scaleX", zoom);//canvas.scaleX = zoom;
			
			
	
			_x = new AnimatedFloat(FMath.clamp(x._,viewPort.width, rx));
		}
		
		private function limitY() : Void
		{
			// necessary
			canvas.applychildsProperty("scaleY", zoom);//canvas.scaleY = zoom;
			_y = new AnimatedFloat(FMath.clamp(y._, viewPort.height, ry));
		}
	
	  private function fullUpdate() : Void
		{
			limitX();
			limitY();
			update();
		}
		private function update() : Void
		{
			if (locked)
				return;
			
			var m:Matrix = new Matrix();
			
			m.translate(-x._,-y._);
			m.rotate(radAngle);
			m.scale(zoom._, zoom._);
			m.translate(rx * zoom._, ry * zoom._);

			//canvas.transform.matrix = m;
			canvas.applychildsMatrix(m);
		}
		private function get_radAngle() : Float
		{
			return FMath.toRadians(angle._);
		}
	
		private function get_viewportWidth() : Float
		{
			return viewPort.width / zoom._;
		}
		
		private function get_viewportHeight() : Float
		{
			return viewPort.height / zoom._;
		}
		
		private function get_rx() : Float
		{
			return viewportWidth * anchor.u;
		}
		
		private function get_ry() : Float
		{
			return viewportHeight * anchor.v;
		}
}