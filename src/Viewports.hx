package;
 
 
 
import flambe.display.camera.GCamera;
import flambe.System;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.util.Debug;
using Reflect;
using Lambda;
 
// Template class is used so that this sample may
// be as concise as possible in showing Nape features without
// any of the boilerplate that makes up the sample interfaces.
import Template;
 
import flash.display.DisplayObject;
 
class Viewports extends Template {
 public    function new(cam:GCamera) {
	 this.cam = cam;
        super({
            // We're going to draw things in a non-standard way
            // so tell Template not to auto-draw Space.
            customDraw: true,
			gravity: Vec2.get(0, 600)
        });
		
		
    }
 
	
    var viewports:Compound;
    var viewableObjects:Array<Body>;
	var cellPool:StringMap<Body>;
    var startIndex:Int;
	
    override function init2() {
       
		var w = System.stage.width;
		var h = System.stage.height;
		cellPool = new StringMap<Body>();
		startIndex = 1;
		
 
        createBorder();
 
        // Super high drag.
      //  space.worldLinearDrag = 5;
      //  space.worldAngularDrag = 5;
 
        // and strength default hand joint settings.
        hand.maxForce = Math.POSITIVE_INFINITY;
        hand.frequency = 100;
 
        // Set up callback logic for viewport interactions.
        // We shove all viewport bodies into a single Compound
        // over which we listen for begin/end sensor events.
        //
        // like this we get a single begin/end when an object
        // leaves or enters the union of all viewport areas.
        var viewportType = new CbType();
        var viewableType = new CbType();
 
        viewports = new Compound();
        viewports.cbTypes.add(viewportType);
        viewports.space = space;
 
        space.listeners.add(new InteractionListener(
           CbEvent.BEGIN, InteractionType.SENSOR,
           viewportType,
           viewableType,
           enterViewportHandler
        ));
        space.listeners.add(new InteractionListener(
            CbEvent.END, InteractionType.SENSOR,
            viewportType,
            viewableType,
            exitViewportHandler
        ));
 
        // Create a couple of viewports
        var viewport = new Body();
        viewport.position.setxy(100,300);
        viewport.compound = viewports;
 
        var viewportShape:Shape = new Polygon(Polygon.box(150, 150));
        viewportShape.sensorEnabled = true;
        viewportShape.body = viewport;
 
        // Aaaand another.
        viewport = new Body();
        viewport.position.setxy(400, 300);
       // viewport.compound = viewports;
	   viewport.space = space;
 
        viewportShape = new Circle(30);
        viewportShape.sensorEnabled = true;
        viewportShape.body = viewport;
 
        // Generate some random objects with graphics.
 
        
 
        viewableObjects = []; 
		
		
		
		
		var r:Int = 20;
		for (i in 0...1) {
		   for (j in 0...1) {
			   var  sixPolygon :Body = new Body();
			   sixPolygon.allowMovement = false;
			   sixPolygon.allowRotation = false;
         sixPolygon.cbTypes.add(viewableType);
            viewableObjects.push(sixPolygon);
			 var po :Polygon = new Polygon(Polygon.regular(r, r, 6, 90 * Math.PI / 180, false));
			po.sensorEnabled = true;
           sixPolygon.shapes.add( po);
		   var fx:Int = j % 2 == 0?r*3:0;
		 
		   sixPolygon.position = Vec2.get(i * r * 2 + fx + 100, j * (r * 2 - 2) + 100);
		   
		   
	
      
		 sixPolygon.userData.xy = Vec2.get(i, j);
		
	     sixPolygon.space = space; 
		 cellPool.set(i+""+j, sixPolygon);
		   } 
		}
		
		
		 var floor:Body = new Body(BodyType.STATIC);
            floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
            floor.space = space;

            // Create a tower of boxes.
            //   We use a DYNAMIC type object, and give it a single
            //   Polygon with vertices defined by Polygon.box utility
            //   whose arguments are the width and height of box.
            //
            //   Polygon.box(w, h) === Polygon.rect((-w / 2), (-h / 2), w, h)
            //   which means we get a box whose centre is the body origin (0, 0)
            //   and that when this object rotates about its centre it will
            //   act as expected.
            for (i in 0...50) {
                var box:Body = new Body(BodyType.DYNAMIC);
                box.shapes.add(new Polygon(Polygon.box(16, 32)));
                box.position.setxy((w / 2), 100+i*0.1);
                box.space = space;
            }

            // Create the rolling ball.
            //   We use a DYNAMIC type object, and give it a single
            //   Circle with radius 50px. Unless specified otherwise
            //   in the second optional argument, the circle is always
            //   centered at the origin.
            //
            //   we give it an angular velocity so when it touched
            //   the floor it will begin rolling towards the tower.
            var ball:Body = new Body(BodyType.DYNAMIC);
            ball.shapes.add(new Circle(50));
            ball.position.setxy(50, h / 2);
            ball.angularVel = 10;
            ball.space = space;
    }
 
	private var lastDrawBodys:Array<Body>;
	private var lastBody:Body;
	
	override private function mouseDown(_)
	{
		
		super.mouseDown(_);
		
		var body :Body = hand.body2;
		
		
		if (lastBody != null && body != lastBody) {
			startIndex = 1;
			
		}
		if (body == null) {
			return;
		}
		lastBody = body;
		if (lastDrawBodys != null && lastDrawBodys.length != 0) {
		    for ( oldItem in lastDrawBodys) {
			   var v2:Vec2 = oldItem.userData.xy;
				var cell2:Body = cellPool.get(v2.x + "" + v2.y);
				
				if(cell2!=null){
				   //var graphic2:DisplayObject = cell2.userData.graphic;
        //graphic2.alpha = 0.25;
				}
			}
		}
		
		if (body.userData.hasField("xy")) {
		     
			
			var arr:Array<Vec2> = getRound(body.userData.xy);
			
			
			//rotation( start:Int,gap:Int, m:Bool, nums:Int,?line:Bool=false):Array<Int>
			
			
			var arrIndex:Array<Int>=rotatCell(startIndex, 1, false, 4);
			
			startIndex++;
			startIndex = startIndex > 6?startIndex % 6:startIndex;
			
			
			var temp:Array<Vec2> = [];
			
			for (i in arrIndex) {
			temp.push(arr[i]);	
			}
			
			
			lastDrawBodys = [];
			for ( item in temp) {
			    
				var cell:Body = cellPool.get(item.x + "" + item.y);
				
				if(cell!=null){
				  
		lastDrawBodys.push(cell);
				}
			}
		}
		
	}
    
 
   
     function enterViewportHandler(cb:InteractionCallback) {
        // We only assigned viewableType to Bodys, so this
        // is always safe.
        var viewableBody = cb.int2.castBody;
 
       // var graphic:DisplayObject = viewableBody.userData.graphic;
       // graphic.alpha = 1.0;
    }
 
    function exitViewportHandler(cb:InteractionCallback) {
        // We only assigned viewableType to Bodys, so this
        // is always safe.
        var viewableBody = cb.int2.castBody;
 
       // var graphic:DisplayObject = viewableBody.userData.graphic;
       // graphic.alpha = 0.25;
    }
 
	
	
   
	
	/**
	 * 
	 * @param	start  start index
	 * @param	gap    gap between index , 1,3,5 is 2
	 * @param	m      need middle point ?
	 * @param	nums     total number
	 * @param	?line     is line?
	 * @return
	 */
	function rotatCell( start:Int,gap:Int, m:Bool, nums:Int,?line:Bool=false):Array<Int> {
	    
		var arr:Array<Int> = [];
		
		start = start > 6?start % 6:start;
		
		
		if (line) {
		 
			var end:Int;
			
			end = start + 3;
			
			end = end > 6?end % 6:end;
			
   
			return  [0,start,end];
		}
		
		arr.push(start);
		for (i in 0...nums-1) {
			
			
			start = start + gap;
			
		      start = start > 6?start % 6:start;
			  
			  arr.push(start);
			
		}
		if (m) {
		arr.push(0);	
		}
		return arr;
		
	}
	/**
	 * 
	 * @param	m middle point 
	 * @return
	 */
	function getRound(m:Vec2):Array<Vec2> {
		 
		var M:Vec2 = m;
		var arr:Array<Vec2> = new Array<Vec2>();
		var NE:Vec2;
		var E:Vec2;
		var SE:Vec2;
		var SW:Vec2;
		var W:Vec2;
		var NW:Vec2;
		var x:Float = m.x;
		var y:Float = m.y;
		if (M.y % 2 == 0) {
			
			NE = Vec2.get(m.x + 2, m.y - 1);
			E = Vec2.get(x + 1, y);
			SE = Vec2.get(x + 2, y + 1);
			SW = Vec2.get(x + 1, y + 1);
			W = Vec2.get(x - 1, y);
			NW = Vec2.get(x + 1, y - 1);
			
		}else {
		   	NE = Vec2.get(m.x -1, m.y - 1);
			E = Vec2.get(x + 1, y);
			SE = Vec2.get(x -1, y + 1);
			SW = Vec2.get(x -2, y + 1);
			W = Vec2.get(x - 1, y);
			NW = Vec2.get(x - 2, y - 1);
		}
		
		arr = [M, NE, E, SE, SW, W, NW];
		
		return arr;
	}
}