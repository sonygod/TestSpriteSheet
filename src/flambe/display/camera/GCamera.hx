package flambe.display.camera;

import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.input.Pointer;
import flambe.math.Rectangle;
import flambe.System;
import flambe.math.Point;


/**
 * camera for game 
 * @author sonygod
 */
class GCamera extends Component
{
     private var canvas:Entity;
     private var _bound:Rectangle;
     private var _lastX:Float;
     private var _lastY:Float;
	 private var _lastZoomAmount:Float;
	 private var tgtx:Float;
	 private var tgty:Float;
	 private var duration:Float;
	 private var readyToX:Float;
	 private var readyToY:Float;
	 
	
	/**
	 * initialize the camera for game 
	 * @param	canvas  the main container of game 
	 * @param	bound    the viewport of the game 
	 */ 
	public function new(canvas:Entity,bound:Rectangle) 
	{
		this.canvas = canvas;
		this._bound = bound;
		
		
		tgtx = 0;
		tgty = 0;
		_lastX = 0;
		_lastY = 0;
		
		
	}
	/**
	 * moving your camera to destination location 
	 * @param	toX  destination x
	 * @param	toY   destination y
	 * @param	zoomAmount  destination zoom
	 * @param	duration  same as tweenlite's duration
	 */
	 public  function to(toX:Float, toY:Float, zoomAmount:Float, duration:Float):Void{
        var xx:Float = (toX * zoomAmount);
        var yy:Float = (toY * zoomAmount);
        var hx:Float = (System.stage.width / 2);
        var hy:Float = (System.stage.height / 2);
        if ((xx - (getBoundLeft(_bound) * zoomAmount)) < hx){
            xx = ((getBoundLeft(_bound) * zoomAmount) + hx);
        } else {
            if (((getBoundRight(_bound) * zoomAmount) - xx) < hx){
                xx = ((getBoundRight(_bound) * zoomAmount) - hx);
            };
        };
        if ((yy - (getBoundTop(_bound)* zoomAmount)) < hy){
            yy = ((getBoundTop(_bound) * zoomAmount) + hy);
        } else {
            if (((getBoundBottom(_bound) * zoomAmount) - yy) < hy){
                yy = ((getBoundBottom(_bound)  * zoomAmount) - hy);
            };
        };
        tgtx= ((System.stage.width * 0.5) - xx);
        tgty = ((System.stage.height * 0.5) - yy);
		
		
		
		 var child :Sprite =cast  canvas.componentList.head.val;
		 
		 if (child!=null) {
			 child.x.animateTo(tgtx,duration);
			 child.y.animateTo(tgty, duration);
			 child.scaleX.animateTo(zoomAmount, duration);
			 child.scaleY.animateTo(zoomAmount, duration);
		 }
  
		
		this._lastX = toX;
        this._lastY = toY;
        this._lastZoomAmount = zoomAmount;
     }
	 
	 
	
	 private function getBoundLeft(r:Rectangle):Float {
		 return r.x;
	 }
	 private function getBoundRight(r:Rectangle):Float {
		 return r.x + r.width;
	 }
	 private function getBoundTop(r:Rectangle):Float {
		 return r.y;
	 }
	  private function getBoundBottom(r:Rectangle):Float {
		 return r.y + r.height;
	 }
	 public function onScreen(target:Sprite):Bool {
		 
		 var child :Sprite =cast  canvas.componentList.head.val;
		 
		 if (child != null) {
			 
			 return child.x._ +tgtx<=target.x._||child.x._+tgtx+System.stage.width>=target.x._;
		 }
		 
		 return false;
		 
	 }
	 
	
	 public function toPoint(p:Pointer,?toCamara:Bool=true):Point{
		 
		 var child :Sprite =cast  canvas.componentList.head.val;
		 
		 if (child != null) {
			 
			 if (toCamara) {
				 
				 return new Point(child.x._ +tgtx + p.x,child.y._+tgty+p.y);
				 
			 }else {
				
				  return new Point(p.x-child.x._ -tgtx ,p.y-child.y._-tgty);
			 }
		 }
		 
		 return null;
	 }
	 
	 
}