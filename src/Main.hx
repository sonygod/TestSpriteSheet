package ;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Shape;
import flambe.Entity;
import flambe.platform.flash.Stage3DTexture;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.TaskVO;
import flambe.System;
import flambe.script.TaskScript;
import flash.display.Bitmap;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.util.BitmapDebug;
/**
 * ...
 * @author sonygod
 */
class Main 
{
	var xx:TaskScript;
    private static function onSuccess (pack :AssetPack) 
    {
		var child = new FillSprite(0xfff666, 100, 100);
		var taskE:Entity = new Entity();
		taskE.add(new Script());
		System.root.addChild(taskE);
		
		var t :Stage3DTexture=cast  System.createTexture(System.stage.width, System.stage.height);
		
	   
        
		var child2 :Shape= new Shape();
		
		var task:TaskScript = new TaskScript();
		
		taskE.add(child2);
		var f = function():Bool { trace("hello?"); return true; };
		var f2 = function():Bool { trace("rightNOw?"); return false; };
		var f3 = function():Bool { trace("urgent0000rightNOw?"); return false; };
		
		
		var bd:BitmapDebug = child2.graphics;
		
		bd.drawCircle(new Vec2(100, 100), 100, 0xfff666);
		
		bd.drawAABB(new AABB(300, 300, 300, 300), 0xff0000);

	/*
	fun:Dynamic,
	args:Array<Dynamic>,
	ignoreCycle:Bool,
	?instant:Bool
	*/
		task.addTask( new TaskObj(f,[]) );
	   
		
		taskE.get(Script).run(new Repeat(task));
		
		task.addTask(new TaskObj(new Delay(10),[]));
		task.addInstantTask(new TaskObj(f2, []));
		task.addUrgentInstantTask(new TaskObj(f3, []));
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
