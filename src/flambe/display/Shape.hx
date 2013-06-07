package flambe.display;
import flambe.display.Graphics;
import flambe.platform.flash.Stage3DTexture;
import flambe.System;
import flash.display.BitmapData;
import nape.phys.Body;
import nape.space.Space;
import nape.util.BitmapDebug;
import flash.display.Bitmap;
/**
 * ... only for flash
 * @author sonygod
 */
class Shape extends ImageSprite {

    public var graphics:BitmapDebug;
    private var t:Stage3DTexture;
    private var bit:BitmapData;
    public var space:Space;

    public function new(w:Float,h:Float) {
        t = cast System.createTexture(Std.int(w), Std.int(h));
        graphics = new BitmapDebug(Std.int(w), Std.int(h), 0, true);
        var bm:Bitmap = cast graphics.display;
        bit = bm.bitmapData;
		sort = false;
        super(t);
    }

    override public function draw(g:Graphics):Void {


        super.draw(g);

    }

    override public function onUpdate(dt:Float):Void {
        super.onUpdate(dt);

        if (space != null) {
            space.step(dt);
            graphics.clear();
          graphics.draw(space);

        }
        graphics.flush();
        t.uploadBitmapData(bit);
    }

    private function fix(_body:Body):Void {
       
    }

}