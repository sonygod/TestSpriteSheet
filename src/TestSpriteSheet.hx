

import flambe.display.camera.GCamera;
import flambe.display.Sprite;
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
		container.addChild( new Entity()
		              .add(new ImageSprite(pack.getTexture("bg"))));
       
		container.addChild(new Entity().add(new YSort()));
		 
			var bird:AnimSprite = addAmination("bird", [ 1, 2, 3, 4, 5, 6], 6, new Point(100, 500), new Point(1600, 100), 10, 1.5);		
			bird.scaleX._ = -1;
		
		addAmination("weiyang", [1, 2, 3, 4, 5,7,8,9,10,11,12,13,14,15,16,17,18,19,20], 10, new Point(100, 450), new Point(1500, 450),5,1.5);
		addAmination("guanyu", [ 1, 2, 3, 4, 5], 10, new Point(100, 400), new Point(1600, 400), 11,1.5);
	   
addAmination("sheet", [ 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 16, new Point(800, 470), new Point(900, 470), 20, 1);
	var car:AnimSprite=addAmination("car", [ 0,1, 2], 16, new Point(1500, 350), new Point(100, 450), 20,1.5);		 
		
	  var camera:GCamera = new GCamera(container, new Rectangle(0, 0, 2001, 568));
	   
	   
		 var font = new Font(pack, "tinyfont");
        System.root.addChild(new Entity()
            .add(new TextSprite(font))
            .add(new FpsDisplay()));
		
			var cam:Entity=new Entity()
                .add(camera)
				.add(new Script());
			System.root.addChild(cam);
		
			//camera.to(1500, 100, 1, 12);
			
		
			
		/*	cam.get(Script).run(new Repeat(new Sequence([
			  new CameraMove(camera, 1500, 100, 1, 12),
			  new CameraMove(camera,100,100,1,12)
			
			])));*/
			
			cam.get(Script).run(
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
					}),
			   new CameraMove(camera, 0, 100, 1, 5),
			   new Delay(2),
			   new CallFunction(function () { trace("finish camera!"); } ),
			
			])));
			
			
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
			
    }
	
	public static function addAmination(name:String, frames:Array<Int>,fps:Int,fromPoint:Point,toPoint:Point,speed:Int,scale:Float):AnimSprite {
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
		   
		   
		   sprite.y.animateTo(toPoint.y,speed);
            container.addChild(tentacle);
			return  sprite;
	}
	
	
	
}
