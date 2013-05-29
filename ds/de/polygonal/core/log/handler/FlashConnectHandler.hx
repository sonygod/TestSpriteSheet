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

import de.polygonal.core.event.IObservable;
import de.polygonal.core.log.LogHandler;
import de.polygonal.core.log.LogLevel;
import de.polygonal.core.time.Timebase;
import de.polygonal.core.time.TimebaseEvent;
import de.polygonal.ds.ArrayedQueue;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.Lib;
import flash.net.XMLSocket;

using de.polygonal.ds.BitFlags;

#if !flash
'The FlashConnectHandler class is only available for flash'
#end

class FlashConnectHandler extends LogHandler
{
	inline public static var MESSAGE_LIMIT        = 1000;
	inline public static var DISPATCH_INTERVAL_MS = 50;
	inline public static var HOST                 = 'localhost';
	inline public static var PORT                 = 1978;
	
	var _socket:XMLSocket;
	var _isConnected:Bool;
	var _buffer:ArrayedQueue<String>;
	var _time:Int;
	
	public function new()
	{
		super();
	}
	
	override function init():Void
	{
		super.init();
		
		_socket = new XMLSocket();
		_socket.addEventListener(Event.CONNECT, onConnect);
		_socket.addEventListener(DataEvent.DATA, function (e:DataEvent) {});
		_socket.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent) {});
		_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:SecurityErrorEvent) {});
		_socket.connect(HOST, PORT);
		_isConnected = false;
		_buffer = new ArrayedQueue(MESSAGE_LIMIT);
	}
	
	override public function update(type:Int, source:IObservable, userData:Dynamic):Void
	{
		super.update(type, source, userData);
		if (type == TimebaseEvent.TICK)
		{
			if (Lib.getTimer() - _time > 50)
			{
				_time = Lib.getTimer();
				dispatch();
			}
		}
	}
	
	override function output(message:String):Void
	{
		var level = _message.outputLevel;
		var flashConnectLevel = 0;
		switch (level)
		{
			case LogLevel.DEBUG:
				flashConnectLevel = 1;
				
			case LogLevel.WARN:
				flashConnectLevel = 2;
				
			case LogLevel.ERROR:
				flashConnectLevel = 3;
		}
		
		if (_buffer.size() == MESSAGE_LIMIT)
			_buffer.dequeue();
		_buffer.enqueue(getMessage(message, flashConnectLevel));
	}
	
	function dispatch():Void
	{
		if (_buffer.isEmpty()) return;
		
		var i = 0;
		var s = '<flashconnect>';
		while (!_buffer.isEmpty())
		{
			i++;
			if (i > MESSAGE_LIMIT)
			{
				Timebase.detach(this);
				s += getMessage('FlashConnect aborted. You have reached the limit of maximum messages.', 3);
			}
			s += _buffer.dequeue();
		}
		s += '</flashconnect>';
		_socket.send(s);
	}
	
	function getMessage(message:String, level:Int):String
	{
		return '<message cmd=\'trace\' state=\'' + level + '\'>' + untyped __global__['encodeURI'](message) + '</message>';
	}
	
	function onConnect(event:Event)
	{
		_isConnected = true;
		dispatch();
		Timebase.attach(this, TimebaseEvent.TICK);
		_time = Lib.getTimer();
	}
}