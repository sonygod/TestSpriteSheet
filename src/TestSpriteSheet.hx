
import flambe.display.camera.Camera2D;
import flambe.display.Sprite;

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
           sprite.x._ = Math.random() * (System.stage.width - sprite.getNaturalWidth());
           sprite.y._ = Math.random() * (System.stage.height - sprite.getNaturalHeight());
           arr.push(sprite);
  
		   sprite.getLocalMatrix().translate(10, 0);
		   
		   
            container.addChild(tentacle);
			
		
			
        }
		 System.pointer.down.connect(function (event) {
            
			 var arr:Array < Sprite>=[];
		 var child :Entity= container.firstChild;
      while (child != null) {
      var next = child.next; // Store in case the child is removed in process()
	  if(Std.is(child.firstComponent,Sprite)){
       arr.push(cast child.firstComponent);
      child = next;
	  }}
			 
			
	 
			 for (com in arr) {
			     
				com.getLocalMatrix().translate(20, 0);
				 
			 }
			 

			  
        });

		
		
		 var font = new Font(pack, "tinyfont");
        System.root.addChild(new Entity()
            .add(new TextSprite(font))
            .add(new FpsDisplay()));
    }
}
