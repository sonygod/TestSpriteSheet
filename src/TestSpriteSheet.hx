

import flambe.display.camera.GCamera;
import flambe.display.Joystick;
import flambe.display.Sprite;
import flambe.input.MouseEvent;
import flambe.math.FMath;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.script.CameraMove;
import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import haxe.Timer;

import flambe.display.tileSheet.AnimTextureSheet;
import flambe.display.tileSheet.TileSheetHelper;
import flambe.display.tileSheet.AnimSprite;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.System;
import flambe.debug.FpsDisplay;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.math.Matrix;
import flambe.script.CallFunction;
using Lambda;
using flambe.YSort;
import flambe.Component;


class TestSpriteSheet {
	
	private static var container:Entity;
	private static var pack:AssetPack;
	private var joy:Joystick;
    private static function main() {
        System.init();

        trace("Update");
        System.hidden.changed.connect(function(hidden, wasHidden) {
            trace("Hidden is now " + hidden);
        });
//Manifest.build("bootstrap")

        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
        loader.error.connect(function(message) {
            trace("Load error: " + message);
        });
        loader.progressChanged.connect(function() {
            trace("Loading progress....... " + loader.progress + " of " + loader.total);
        });
    }

    private static function onSuccess(pack:AssetPack) {
       
			
		
			
			
			
			 trace("Loading complete!");

// Add a filled background color
        System.root.addChild(new Entity()
        .add(new FillSprite(0x303030, System.stage.width, System.stage.height)));
		
		TestSpriteSheet.pack = pack;

		  container= new Entity();
		 System.root.addChild(container);
       
		container.add(new Sprite());
		
		
		
		//container.addChild( new Entity()
		              //.add(new ImageSprite(pack.getTexture("bg"))));
                       //  .add(bgwater));
		container.addChild(new Entity().add(new YSort()));
	  var water:AnimSprite=addAmination("bgwater", [ 0,1, 2, 3, 4, 5,6], 12, new Point(1640/4, 480), new Point(1640/4, 480), 9, 2);
		water.sort = false;
		water.scaleX._ = 3.8;
		water.scaleY._ = 2.5;
	  var bird:AnimSprite = addAmination("bird", [ 1, 2, 3, 4, 5, 6], 6, new Point(100, 500), new Point(1600, 100), 10, 1.5);		
			bird.scaleX._ = -1;
		addAmination("mj1", [ 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 12, new Point(0, 470), new Point(1500, 470), 9, 1.5);
		addAmination("weiyang", [1, 2, 3, 4, 5,7,8,9,10,11,12,13,14,15,16,17,18,19,20], 10, new Point(100, 450), new Point(1500, 450),5,1.5);
		addAmination("guanyu", [ 1, 2, 3, 4, 5], 10, new Point(100, 400), new Point(1600, 400), 11,1.5);
	  var man= addAmination("mus3", [ 1, 2, 3, 4, 5, 7], 12, new Point(1500, 450), new Point(100, 450), 12, 1.5);
man.scaleX._ = -1.5;
	var car:AnimSprite=addAmination("car", [ 0,1, 2], 8, new Point(1500, 350), new Point(100, 450), 20,1.5);		 
		
	  var camera:GCamera = new GCamera(container, new Rectangle(0, 0, 1800, 470));
	   
	   
	    var man2= addAmination("monster2", [ 1, 2, 3, 4, 5, 7,8,9,10,11,12,13,14,15], 8, new Point(1800, 450), new Point(1800, 450), 60, 2);
man2.scaleX._ = -2;
		 var font = new Font(pack, "tinyfont");
        System.root.addChild(new Entity()
            .add(new TextSprite(font))
            .add(new FpsDisplay()));
		
			var cam:Entity=new Entity()
                .add(camera)
				.add(new Script());
			System.root.addChild(cam);
			
			
			
			
			
	
			camera.drag = true;
		
			camera.to(1500, 100, 1, 12);
			
		
			
		/*	cam.get(Script).run(new Repeat(new Sequence([
			  new CameraMove(camera, 1500, 100, 1, 12),
			  new CameraMove(camera,100,100,1,12)
			
			])));*/
			
			/*cam.get(Script).run(
			new Repeat(
			new Sequence([
			 new CallFunction(function () {
				if (car.x._ > 900) {
					car.x.animateTo(0, 4);
				car.scaleX._ = 1.5;
				}
				 trace("ready start"); } ),
				
			  new Delay(2),
			  new CameraMove(camera, 800, 100, 1, 4),
			  new Delay(1),
			   new CameraMove(camera, 1500, 100, 1, 4),
			     new Delay(3),
				new CallFunction(function () {
					var guanyu2:AnimSprite=addAmination("monster", [ 1, 2, 3, 4, 5], 4, new Point(1600, 400+Math.random()*200), new Point(100, 400+Math.random()*200), 20,1);
				    guanyu2.scaleX._ = -1;
				car.x.animateTo(1000, 5);
				car.scaleX._ = -1.5;
				man.scaleX._ = 1.5;
				
					}),
			   new CameraMove(camera, 100, 100, 1.1, 5),
			   new Delay(2),
			   new CallFunction(function () { trace("finish camera!"); } ),
			
			])));*/
			
			
			/*cam.get(Script).run(
			
			new Repeat(
			new Sequence([
			  new CallFunction(function () { trace("repeat1"); } ),
			  new Delay(2),
			   new CallFunction(function () { trace("repeat2"); } ),
			   new Delay(2),
			
			])
			
			)
			);*/
			
		 System.root.addChild(new Entity()
			 .add(new Joystick(100,400,pack))
            );
			
    }
	
	public static function addAmination(name:String, frames:Array<Int>,fps:Int,fromPoint:Point,toPoint:Point,speed:Int,scale:Float,?otherContainer:Entity=null):AnimSprite {
		var tentacle:Entity = new Entity() ;
		var ts:TileSheetHelper=new TileSheetHelper();
        var ats:AnimTextureSheet= ts.prepareShoesAnimTexture(pack.getFile(name+".xml",true)) ;
        var arr:Array<Sprite> = [];
		var target:Sprite = null;
         

        var as:AnimSprite=  new AnimSprite(pack.getTexture(name));

        as.initialize(ats);
            as.addSequence("all",frames,fps);
            as.play("all");
            as.centerAnchor();
            tentacle.add(as);
			as.setScale(scale);
           /* .add(new Draggable());*/
            var sprite:AnimSprite = tentacle.get(AnimSprite);
			
			//trace( sprite.getNaturalWidth()*(ii+1),sprite.getNaturalHeight()*(ii+1));
           sprite.x._ = fromPoint.x;
           sprite.y._ = fromPoint.y;// sprite.getNaturalHeight() * (ii + 1);
           
  
		   sprite.x.animateTo(toPoint.x,speed);
		   
		   
		   sprite.y.animateTo(toPoint.y, speed);
		   if(otherContainer==null)
            container.addChild(tentacle);
			else
			otherContainer.addChild(tentacle);
			return  sprite;
	}
	
	
	
}
