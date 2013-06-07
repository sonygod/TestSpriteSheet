package flambe.display.atom;
import flambe.display.tileSheet.AnimSprite;
import flambe.display.tileSheet.AnimTextureSheet;
import haxe.ds.StringMap;
import flambe.display.tileSheet.TileSheetHelper;
import flambe.asset.AssetPack;
import flambe.Entity;

class Avatar extends Entity {
    private var pack:AssetPack;
    private var animationMap:StringMap<AnimSprite>;
    public var lastAs(default,null):AnimSprite;


    public function new(pack:AssetPack) {

        animationMap = new StringMap<AnimSprite>();
    }

    public function appendAnimationSheet(name:String):AnimSprite {


        var ts:TileSheetHelper = new TileSheetHelper();
        var ats:AnimTextureSheet = ts.prepareShoesAnimTexture(pack.getFile(name + ".xml", true)) ;
        var as:AnimSprite = new AnimSprite(pack.getTexture(name));
        as.initialize(ats);
        as.centerAnchor();
        animationMap.set(name, as);
        return as

    }

    public function removeAnimationSheet(name:String):Void{
        var as:AnimSprite = animationMap.get(map);
         as.dispose();
         animationMap.remove(name);

    }
    public function definedFrames(map:String, frameName:String, frames:Array<Int>, fps:Int):Void {

        var as:AnimSprite = animationMap.get(map);

        as.addSequence(frameName, frames, fps);

    }

    public function play(frameName:String, map:String):AnimSprite{
        var as:AnimSprite = animationMap.get(map);
        if (lastAs != null) {
            remove(lastAs);
        }
        add(as);
        if (lastAs != null) {
            as.setXY(lastAs.x._, lastAs.y._);
            as.rotation = lastAs.rotation;
            as.setScaleXY(lastAs.scaleX._, lastAs.scaleY._);
            as.alpha = lastAs.alpha;
            as.blendMode = lastAs.blendMode;


        }
        lastAs = as;
        as.play(frameName);
        return lastAs;

    }

    public function stop():Void {
        lastAs.stop();
    }




}
