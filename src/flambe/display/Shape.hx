package flambe.display;
import flambe.display.Graphics;
import flambe.platform.flash.Stage3DTexture;
import flambe.System;
import flash.display.BitmapData;
import nape.util.BitmapDebug;
import flash.display.Bitmap;
/**
 * ... only for flash
 * @author sonygod
 */
class Shape extends ImageSprite
{
    
    public var graphics:BitmapDebug;
	private var t:Stage3DTexture;
	private var bit:BitmapData;
	public function new() 
	{
		t= cast  System.createTexture(System.stage.width, System.stage.height);
		bd = new BitmapDebug(System.stage.width, System.stage.height, 0, true);
		var bm:Bitmap =cast  bd.display;
		bit = bm.bitmapData;
		super(t);
	}
	override public function draw(g:Graphics):Void
	{
		
		bd.flush();
		t.uploadBitmapData(bit);
		super.draw(g);
		
	}
	
}