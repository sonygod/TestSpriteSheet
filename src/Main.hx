package ;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.Entity;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.TaskVO;
import flambe.System;
import flambe.script.TaskScript;
/**
 * ...
 * @author sonygod
 */
class Main 
{
	var xx:TaskScript;
    private static function onSuccess (pack :AssetPack) 
    {
		
		var taskE:Entity = new Entity();
		taskE.add(new Script());
		System.root.addChild(taskE);
		
		var task:TaskScript = new TaskScript();
		
		
		var f = function():Bool { trace("hello?"); return true; };
		var f2 = function():Bool { trace("rightNOw?"); return false; };
		var f3 = function():Bool{ trace("urgent0000rightNOw?"); return false; };
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
