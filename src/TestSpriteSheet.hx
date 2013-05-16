
import flambe.display.camera.Camera2D;
import flambe.display.Sprite;
import flambe.math.Point;
import flambe.math.Rectangle;

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
using Lambda;
import flambe.Component;


class TestSpriteSheet {
	var ddd:Camera2D;
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
		
		

		var container:Entity = new Entity();
		 System.root.addChild(container);
       var ts:TileSheetHelper=new TileSheetHelper();
        var ats:AnimTextureSheet= ts.prepareAnimTexture(pack.getFile("remiWalk.json",true)) ;
        var arr:Array<Sprite> = [];
		var target:Sprite=null;
        for (ii in 0...10) {
            var tentacle:Entity = new Entity() ;
          //  .add(new AnimSprite(pack.loadTexture("remiWalk.png")));

        var as:AnimSprite=  new AnimSprite(pack.getTexture("remiWalk"));

        as.initialize(ats);
            as.addSequence("all",[0,1,2,3,4,5,6,7,8,9,10,11],24);
            as.play("all");
            as.centerAnchor();
            tentacle.add(as);
           /* .add(new Draggable());*/
            var sprite:Sprite = tentacle.get(AnimSprite);
			if (target==null) {
			target = sprite;	
			}
           sprite.x._ =  sprite.getNaturalWidth()*(ii+1);
           sprite.y._ =  200;//sprite.getNaturalHeight()*(ii+1);
           arr.push(sprite);
  
		   
		   
		   
            container.addChild(tentacle);
			
		
			
        }
		

		var camera:Camera2D = new Camera2D(container, new Point(1000,600));
		camera.target = target;
		 var font = new Font(pack, "tinyfont");
        System.root.addChild(new Entity()
            .add(new TextSprite(font))
            .add(new FpsDisplay()));
		
			 System.root.addChild(new Entity()
                .add(camera));
    }
}
