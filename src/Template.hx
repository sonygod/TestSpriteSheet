package;



import flambe.Component;
import flambe.input.Key;
import flambe.input.Keyboard;
import flambe.input.KeyboardEvent;
import flambe.math.FMath;
import flambe.math.Point;
import flambe.System;
import flash.events.TouchEvent;
import nape.space.Space;
import nape.space.Broadphase;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.util.Debug;
import nape.util.BitmapDebug;
import nape.util.ShapeDebug;
import nape.constraint.PivotJoint;
import flambe.input.PointerEvent;
import flambe.display.camera.GCamera;
typedef TemplateParams = {
    ?gravity : Vec2,
    ?shapeDebug : Bool,
    ?broadphase : Broadphase,
    ?noSpace : Bool,
    ?noHand : Bool,
    ?staticClick : Vec2->Void,
    ?generator : Vec2->Void,
    ?variableStep : Bool,
    ?noReset : Bool,
    ?velIterations : Int,
    ?posIterations : Int,
    ?customDraw : Bool
};

class Template  extends Component {

    public var space:Space;
  
    var hand:PivotJoint;

    var variableStep:Bool;
    var prevTime:Int;

    var smoothFps:Float = -1;
  
    var baseMemory:Float;

    var velIterations:Int = 10;
    var posIterations:Int = 10;
    var customDraw:Bool = false;

    var params:TemplateParams;
    var useHand:Bool;
	public var cam:GCamera;
    function new(params:TemplateParams) {
      
        

        if (params.velIterations != null) {
            velIterations = params.velIterations;
        }
        if (params.posIterations != null) {
            posIterations = params.posIterations;
        }
        if (params.customDraw != null) {
            customDraw = params.customDraw;
        }

        this.params = params;
        
		start(null);
    }

    function start(ev) {
       

        if (params.noSpace == null || !params.noSpace) {
            space = new Space(params.gravity, params.broadphase);

            if (useHand = (params.noHand == null || !params.noHand)) {
                hand = new PivotJoint(space.world, null, Vec2.weak(), Vec2.weak());
                hand.active = false;
                hand.stiff = false;
                hand.maxForce = 1e5;
                hand.space = space;
               // stage.addEventListener(MouseEvent.MOUSE_UP, handMouseUp);
            }
        
		
			  System.pointer.up.connect(handMouseUp);
			  System.pointer.down.connect(mouseDown);
		
        }

        if (params.noReset == null || !params.noReset) {
			
			if(System.keyboard.supported){
          //  stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
           // stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		   System.keyboard.down.connect(keyDown);
		   System.keyboard.up.connect(keyUp);
			}
        }

      

        init2();

       
    }

    function random() return Math.random();

    function createBorder() {
		
		var stage = System.stage;
        var border = new Body(BodyType.STATIC);
        border.shapes.add(new Polygon(Polygon.rect(0, 0, -2, stage.height)));
        border.shapes.add(new Polygon(Polygon.rect(0, 0, stage.width, -2)));
        border.shapes.add(new Polygon(Polygon.rect(stage.width, 0, 2, stage.height)));
        border.shapes.add(new Polygon(Polygon.rect(0, stage.height, stage.width, 2)));
        border.space = space;
        border.debugDraw = false;
        return border;
    }

    // to be overriden
    function init2() {}


    var resetted = false;
    function keyUp(ev:KeyboardEvent) {
        // 'r'
        if (ev.key == Key.R) {
            resetted = false;
        }
    }
    function keyDown(ev:KeyboardEvent) {
        // 'r'
        if (ev.key == Key.R && !resetted) {
            resetted = true;
            if (space != null) {
                space.clear();
                if (hand != null) {
                    hand.active = false;
                    hand.space = space;
                }
            }
           // System.pauseForGCIfCollectionImminent(0);
            init2();
        }
    }

    var bodyList:BodyList = null;
    function mouseDown(evt:PointerEvent) {
		//to camera veiw point;
		
		var p:Point=cam.toPoint(new Point(evt.viewX, evt.viewY), true);
        var mp = Vec2.get(p.x, p.y);
        if (useHand) {
            // re-use the same list each time.
            bodyList = space.bodiesUnderPoint(mp, null, bodyList);

            for (body in bodyList) {
                if (body.isDynamic()) {
                    hand.body2 = body;
                    hand.anchor2 = body.worldPointToLocal(mp, true);
                    hand.active = true;
                    break;
                }
            }

            if (bodyList.empty()) {
                if (params.generator != null) {
                    params.generator(mp);
				
                }
            }
            else if (!hand.active) {
                if (params.staticClick != null) {
                    params.staticClick(mp);
                }
            }

            // recycle nodes.
            bodyList.clear();
        }
        else {
            if (params.generator != null) {
                params.generator(mp);
            }
        }
        mp.dispose();
    }

    function handMouseUp(_:PointerEvent) {
        hand.active = false;
    }

	override public function onUpdate (dt :Float)
    {
	
		if (hand != null && hand.active) {
			
			if (cam != null) {
				var p:Point = cam.toPoint(new Point(System.mouse.x, System.mouse.y), true);
            hand.anchor1.setxy(p.x,p.y);
            hand.body2.angularVel *= 0.9;
			}
        }
		
    }
   
}
