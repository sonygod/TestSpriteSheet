import flambe.geom.Transform;
import flambe.display.Sprite;
import flambe.geom.Matrix;
import flambe.tileSheet.AnimTextureSheet;
import flambe.tileSheet.TileSheetHelper;
import flambe.tileSheet.AnimSprite;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.System;

class DraggingMain {
    private static function main() {
        System.init();

        trace("Update");
        System.hidden.changed.connect(function(hidden, wasHidden) {
            trace("Hidden is now " + hidden);
        });
//Manifest.build("bootstrap")

        var manifest = new Manifest();
        manifest.add("remiWalk.png", "assets/bootstrap/remiWalk.png?292929292");
        manifest.add("remiWalk.json", "assets/bootstrap/remiWalk.json?292929292");
        var loader = System.loadAssetPack(manifest);
// Add listeners
        loader.success.connect(onSuccess);
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

       var ts:TileSheetHelper=new TileSheetHelper();
        var ats:AnimTextureSheet= ts.prepareAnimTexture(pack.loadFile("remiWalk.json",true)) ;

        for (ii in 0...1) {
            var tentacle = new Entity() ;
          //  .add(new AnimSprite(pack.loadTexture("remiWalk.png")));

        var as:AnimSprite=  new AnimSprite(pack.loadTexture("remiWalk.png"));

        as.initialize(ats);
            as.addSequence("all",[0,1,2,3,4,5,6,7,8,9,10,11],24);
            as.play("all");
            as.centerAnchor();
            tentacle.add(as);
           /* .add(new Draggable());*/
            var sprite:Sprite = tentacle.get(AnimSprite);
          //  sprite.x._ = Math.random() * (System.stage.width - sprite.getNaturalWidth());
          //  sprite.y._ = Math.random() * (System.stage.height - sprite.getNaturalHeight());
            var myMatrix:Matrix = new Matrix();
            myMatrix.a = 1;
            myMatrix.d = 1;
            myMatrix.tx = 100;
            myMatrix.ty = 200;




            myMatrix.scale(0.5,2);
            myMatrix.rotate(45);
            var rectangleTrans:Transform = new Transform(sprite);

            sprite.transform.matrix=myMatrix;

            System.root.addChild(tentacle);
        }
    }
}
