﻿/*
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
package de.polygonal.core.log.handler;

import de.polygonal.core.log.LogHandler;
import de.polygonal.core.log.LogLevel;
import de.polygonal.core.math.Mathematics;

using de.polygonal.ds.BitFlags;

#if !js
'The ConsoleHandler class is only available for js'
#end

/**
 * <p>Writes logging messages using the browser console API.</p> 
 */
class ConsoleHandler extends LogHandler
{
	#if js
	public static function log(x)
	{
		untyped console.log(x);
	}
	#end
	
	public function new()
	{
		super();
	}
	
	override function output(message:String):Void
	{
		var levelName = LogLevel.getName(M.min(_message.outputLevel, LogLevel.ERROR)).toLowerCase();
		
		#if js
		untyped if (console[levelName] != null) console[levelName](message); else console.log(message);
		#elseif flash
		if (flash.external.ExternalInterface.available)
			flash.external.ExternalInterface.call('console.' + levelName, message);
		#end
	}
}