/*
 *                            _/                                                    _/
 *       _/_/_/      _/_/    _/  _/    _/    _/_/_/    _/_/    _/_/_/      _/_/_/  _/
 *      _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/
 *     _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/
 *    _/_/_/      _/_/    _/    _/_/_/    _/_/_/    _/_/    _/    _/    _/_/_/  _/
 *   _/                            _/        _/
 *  _/                        _/_/      _/_/
 *
 * POLYGONAL - A HAXE LIBRARY FOR GAME DEVELOPERS
 * Copyright (c) 2009 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package de.polygonal.core.sys;

import de.polygonal.core.event.IObservable;
import de.polygonal.core.sys.Entity;
import de.polygonal.core.time.Timebase;
import de.polygonal.core.time.TimebaseEvent;
import de.polygonal.core.time.Timeline;

class MainLoop extends Entity
{
	public var paused:Bool;
	
	public function new(run:Bool)
	{
		super();
		Timebase.attach(this);
		this.paused = run == false;
	}
	
	override function onFree():Void
	{
		Timebase.detach(this);
	}
	
	override public function update(type:Int, source:IObservable, userData:Dynamic):Void
	{
		switch (type)
		{
			case TimebaseEvent.TICK:
				#if (!no_traces && log)
				//identify tick step
				var log = de.polygonal.core.Root.log;
				if (log != null)
					for (handler in log.getLogHandler())
						handler.setPrefix(de.polygonal.core.fmt.Sprintf.format('t%03d', [Timebase.processedTicks % 1000]));
				#end
				
				if (paused) return;
				
				Timeline.get().advance();
				commit();
				var timeDelta:Float = userData;
				
				propagateTick(timeDelta, this);
				
				#if verbose
				var s = Entity.printTopologyStats();
				if (s != null) de.polygonal.core.Root.debug(s);
				#end
			
			case TimebaseEvent.RENDER:
				#if (!no_traces && log)
				//identify draw step
				var log = de.polygonal.core.Root.log;
				if (log != null)
					for (handler in log.getLogHandler())
						handler.setPrefix(de.polygonal.core.fmt.Sprintf.format('r%03d', [Timebase.processedFrames % 1000]));
				#end
				
				if (paused) return;
				
				var alpha:Float = userData;
				propagateDraw(alpha, this);
		}
	}
}