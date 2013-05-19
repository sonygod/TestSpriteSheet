package flambe.display.camera;

import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.math.Rectangle;
import flambe.System;


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
        if ((xx - (this._bound.left * zoomAmount)) < hx){
            xx = ((this._bound.left * zoomAmount) + hx);
        } else {
            if (((this._bound.right * zoomAmount) - xx) < hx){
                xx = ((this._bound.right * zoomAmount) - hx);
            };
        };
        if ((yy - (this._bound.top * zoomAmount)) < hy){
            yy = ((this._bound.top * zoomAmount) + hy);
        } else {
            if (((this._bound.bottom * zoomAmount) - yy) < hy){
                yy = ((this._bound.bottom * zoomAmount) - hy);
            };
        };
        tgtx= ((System.stage.width * 0.5) - xx);
        tgty = ((System.stage.height * 0.5) - yy);
		
		
		
		 var child :Sprite =cast  canvas.firstComponent;
		 
		 if (child!=null) {
			 child.x.animateBy(tgtx,duration);
			 child.y.animateBy(tgty,duration);
		 }
  
		
		this._lastX = toX;
        this._lastY = toY;
        this._lastZoomAmount = zoomAmount;
     }
	 
	 
	
	 
	
	 
	
	 
	 
}