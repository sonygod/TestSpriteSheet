package ;

import nape.geom.Vec2;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.TaskVO;
import flambe.System;
import flambe.script.TaskScript;
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
		var bd:BitmapDebug = new BitmapDebug(System.stage.width, System.stage.height);
		var im:ImageSprite=new ImageSprite(pack.getTexture("bird"));
		var taskE:Entity = new Entity();
		
		taskE.add(new ImageSprite(bd.getTexture()));
		//taskE.add(new ImageSprite(pack.getTexture("bird")));
		taskE.add(new Script());
		System.root.addChild(taskE);
		
		var task:TaskScript = new TaskScript();
		
		
		var f = function():Bool { trace("hello?"); return true; };
		var f2 = function():Bool { trace("rightNOw?"); return false; };
		var f3 = function():Bool { trace("urgent0000rightNOw?"); return false; };
		var f4 = function():Bool{ trace("4urgent0000rightNOw?"); return false; };
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
		task.addUrgentInstantTask(new TaskObj(f4, []));
		
		
		
		bd.drawCircle(new Vec2(100, 100), 10, 0xFFFF66);
		
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
