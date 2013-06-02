package flambe.display;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.math.FMath;
import flambe.System;

/**
 * ...
 * @author sonygod
 */
class Joystick extends Sprite
{
     
	private var shaft:ImageSprite;
	private var knob:ImageSprite;
	private var ring:ImageSprite;
	private var _drag:Bool;
	private var _initX:Float;
	private var _initY:Float;
	private var decay:Float;
	private var xSpeed:Float;
	private var tension:Float;
	public function new(xx:Float,yy:Float,pack:AssetPack) 
	{
		
		super();
		_drag = false;
		
		decay = 0.5;
		xSpeed = 0;
		tension = 0.5;
		sort = false;
		x._ = xx;
		y._ = yy;
		initChild(pack);
	}
	
	
	private function initChild(pack:AssetPack):Void {
		
		
		
		knob = new ImageSprite(pack.getTexture("knob"));
	    ring = new ImageSprite(pack.getTexture("ring"));
		knob.userName = "knob";
		knob.sort = false;
		ring.sort = false;
		ring.userName = "ring";
		knob.centerAnchor();
		ring.centerAnchor();
		ring.namex = "ringx";
		
		
		
		
		_initX = this.x._;
		_initY = this.y._;
		

		
	}
	
	
	override  public function onAdded ():Void
    {
		
		this.pointerMove.connect(onPointMove);
		//var owner:Entity=cast this.owner 
		
		
		var e2 = new Entity();
		e2.add(ring);
		var e = new Entity();
		e.add(knob);
		
		owner.addChild(e2);
	owner.addChild(e);
	knob.namex = "knob";
		knob.pointerDown.connect(onPointDown);
		
		System.pointer.up.connect(onUp);
    }
	
	private function onPointDown(e:PointerEvent):Void {
		_drag = true;
		
	}
	
	
	private function onUp(e:PointerEvent):Void {
		_drag = false;
		
	}
	
	
	override public function onUpdate(dt:Float):Void 
	{
		super.onUpdate(dt);
		
		if (!_drag&&knob!=null) {
				xSpeed = -knob.x._*tension+(xSpeed*decay);
					knob.x._ += xSpeed;
		}
	}
	
	private function onPointMove(e:PointerEvent):Void {
		
		if (_drag) {
			var angel = FMath.toDegrees(Math.atan2(System.pointer.y - _initY, System.pointer.x - _initX));
		     
		   var rotation= angel;
			
		   knob.rotation._ = -angel;
		   knob.x._ = e.viewX;
		  
			}
	}
	
	
}