package ;

import flambe.display.Shape;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import nape.geom.Vec2;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.TaskVO;
import flambe.System;
import flambe.script.TaskScript;



import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.BitmapDebug;

/**
 * ...
 * @author sonygod
 */
class BasicSimulationFlambe
{
 static var space:Space;
  static var shape:Shape;
	public function new() 
	{
		
	}
	private static function onSuccess (pack :AssetPack) 
    {
		var gravity = Vec2.weak(0, 600);
        space = new Space(gravity);
		
		var shape = new Shape();
		
		shape.space = space;
		System.root.addChild(new Entity().add(shape));
		
		System.keyboard.up.connect(keyDownHandler);
		
		setUp();
	}
	
	static function keyDownHandler(ev:KeyboardEvent):Void {
		if (ev.key == Key.R) {
			 space.clear();

            setUp();
		}
	}
	static  function setUp() {
        var w = System.stage.width;// stage.stageWidth;
        var h = System.stage.height;// stage.stageHeight;

        // Create the floor for the simulation.
        //   We use a STATIC type object, and give it a single
        //   Polygon with vertices defined by Polygon.rect utility
        //   whose arguments are (x, y) of top-left corner and the
        //   width and height.
        //
        //   A static object does not rotate, so we don't need to
        //   care that the origin of the Body (0, 0) is not in the
        //   centre of the Body's shapes.
        var floor = new Body(BodyType.STATIC);
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
        for (i in 0...1) {
            var box = new Body(BodyType.DYNAMIC);
            box.shapes.add(new Polygon(Polygon.box(16, 32)));
            box.position.setxy((w / 2), ((h - 50) - 32 * (i + 0.5)));
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
        var ball = new Body(BodyType.DYNAMIC);
        ball.shapes.add(new Circle(50));
        ball.position.setxy(50, h / 2);
        ball.angularVel = 10;
        ball.space = space;

        // In each case we have used for adding a Shape to a Body
        //    body.shapes.add(shape);
        // We can also use:
        //    shape.body = body;
        //
        // And for adding the Body to a Space:
        //    body.space = space;
        // We can also use:
        //    space.bodies.add(body);
    }

	 private static function main () 
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("test");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }
	
}