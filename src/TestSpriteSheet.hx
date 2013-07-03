

import flambe.display.atom.Avatar;
import flambe.display.camera.GCamera;
//import flambe.display.Joystick;
import flambe.display.Shape;
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
import nape.geom.AABB;

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
import flambe.input.PointerEvent;
import nape.CollideMagic;
import flambe.display.atom.AvatarNape;


class TestSpriteSheet {
	
	private static var container:Entity;
	private static var pack:AssetPack;
	//private var joy:Joystick;
	private var viewPort:Viewports;
	
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
	 
		
	  var camera:GCamera = new GCamera(container, new Rectangle(0, 0, 1800, 470));
	   
	   
	
		 var font = new Font(pack, "tinyfont");
        System.root.addChild(new Entity()
            .add(new TextSprite(font))
            .add(new FpsDisplay()));
		
			var cam:Entity=new Entity()
                .add(camera)
				.add(new Script());
			System.root.addChild(cam);
			
			
			
			
			
	
			camera.drag = true;
		
			
			
		
			
			
			
			
			
			var view:Viewports = new Viewports(camera);
			view.cam = camera;
			 System.root.addChild(new Entity().add(view));
			 var shape:Shape = new Shape(camera,view.space);
	  System.root.addChild(new Entity().add(shape));
		
			
			  
			
		
			
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
