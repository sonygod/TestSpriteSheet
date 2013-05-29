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
package de.polygonal.core.log.handler;

import de.polygonal.core.log.LogHandler;
import de.polygonal.ds.ArrayedQueue;

using de.polygonal.ds.BitFlags;

#if (nme && cpp)
#elseif flash
#else
'The TextFieldHandler class is only available for flash or nme/cpp'
#end

class TextFieldHandler extends LogHandler
{
	public var tf(default, null):flash.text.TextField;
	
	var _buffer:ArrayedQueue<String>;
	var _counter:Int;
	var _numLines:Int;
	
	public function new(numLines = 32, ?tf:flash.text.TextField, ?parent:flash.display.DisplayObjectContainer)
	{
		super();
		
		_numLines = numLines;
		if (tf != null)
			this.tf = tf;
		else
		{
			this.tf = tf = new flash.text.TextField();
			tf.defaultTextFormat = new flash.text.TextFormat('Arial');
			tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
			flash.Lib.current.addChild(tf);
		}
		
		tf.name = 'loghandler';
		tf.selectable = false;
		flash.Lib.current.addEventListener(flash.events.Event.ADDED, onAdded);
		_buffer = new ArrayedQueue<String>(_numLines, false);
	}
	
	override function output(message:String):Void
	{
		_buffer.enqueue(_counter + message);
		_counter++;
		if (_buffer.size() > _numLines)
			_buffer.dequeue();
		tf.text = '';
		for (i in 0..._buffer.size())
			tf.appendText(_buffer.get(i) + '\n');
		tf.scrollV = tf.maxScrollV;
	}
	
	function onAdded(_):Void
	{
		if (tf.parent != null)
		{
			if (tf.parent.numChildren > 1)
			{
				var topmost = tf.parent.getChildAt(tf.parent.numChildren - 1);
				if (tf.parent.getChildIndex(tf) < tf.parent.getChildIndex(topmost))
					tf.parent.swapChildren(tf, topmost);
			}
		}
	}
}