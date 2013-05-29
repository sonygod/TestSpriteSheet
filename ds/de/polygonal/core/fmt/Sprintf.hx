﻿
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
package de.polygonal.core.fmt;

import haxe.EnumFlags;
import haxe.ds.IntMap;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
#end

using de.polygonal.core.math.Mathematics;
using de.polygonal.core.fmt.ASCII;

/**
 * <p>A C sprintf implementation.</p>
 * <p>See <a href="http://www.cplusplus.com/reference/clibrary/cstdio/printf/" target="_blank">http://www.cplusplus.com/reference/clibrary/cstdio/printf/</a> for a complete reference.</p>
 *
 * <h1><b>New Features</b></h1>
 * <h1>Variable Number of Arguments</h1>
 *
 * <p>If there is more than one argument (or if the only argument passed is not an array), Sprintf will use the arguments as is.</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("This is %s", "acceptable");
 * Sprintf.format("This is also %s", ["acceptable"]);</pre></p>
 *
 * <h1>Numbered Parameters</h1>
 * <p>Arguments can now be accessed by number via the following format: `%[argnumber$][flags][width][.precision][length]specifier`</p>
 * <p><b>Note: The number 1 refers to the first argument, not 0</b></p>
 * <p><pre class="prettyprint">
 * Sprintf.format("%s is %d years old, and his name is %1$s", ["Joe", 32]);</pre></p>
 *
 * <h1>Named Parameters</h1>
 * <p>Arguments can now be specified as named properties of an object using the following format: `%(name)`. Named arguments will always refer to the first parameter.</p>
 * <p>Named Parameters can even be used in conjunction with other argument types:</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("%(name) is %(age), and wants to be a %2$s", {name:"Joe", age:32}, "Programmer");</pre></p>
 * 
 * <h1>Compile-Time Checks</h1>
 * <p>If the format string is inline, several checks can be done at compile time, and they can issue an error or warning during the compile.</p>
 * <h1>Format String Verification</h1>
 * <p>An incorrect format string will throw an error:</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("%m", 3); // Compile-time error: invalid format specifier</pre></p>
 *
 * <h1>Not Enough Arguments</h1>
 * <p>Compilation will fail if there are not enough arguments passed for the number of specifiers given</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("%s %s %s", "bob", "joe"); // Compile-time error: Not enough arguments</pre></p>
 *
 * <h1>Width and Precision</h1>
 * <p>Widths and precisions are checked at compile time when possible</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("Age/3 = %.*f", 10.1, 2); // Compile-time error: precision must be an integer
 * Sprintf.format("Age/3 = %*f", 10.1, 4); // Compile-time error: width must be an integer</pre></p>
 *
 * <h1>Number Types</h1>
 * <p>The value's type is checked whenever possible</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("%f", "5"); // Compile-time error: the value must be a number
 * Sprintf.format("%d", 4.1); // Complile-time error: the value must be an integer</pre></p>
 *
 * <h1>Flag Mis-matches (Warning)</h1>
 * <p>A compiler warning will be issued for flag combinations that don't make sense</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("% +f", 3.1);
 * // Compile-time warning: ` ' flag ignored with '+' flag in printf format</pre></p>
 *
 * <h1>Unused Arguments (Warning)</h1>
 * <p>If compiled with the verbose flag, a compiler warning will be issued for arguments that are left unused</p>
 * <p><pre class="prettyprint">
 * Sprintf.format("%s", "first", "second"); // Compile-time warning: Unused parameters</pre></p>
 */
class Sprintf
{
	var formatHash:IntMap< Dynamic >;
	
	static var dataTypeHash:IntMap<FormatDataType> = makeDataTypeHash();
	
	private static function makeDataTypeHash()
	{
		var hash:IntMap<FormatDataType> = new IntMap();
		hash.set("i".code, FmtInteger(ISignedDecimal));
		hash.set("d".code, FmtInteger(ISignedDecimal));
		hash.set("u".code, FmtInteger(IUnsignedDecimal));
		hash.set("c".code, FmtInteger(ICharacter));
		hash.set("x".code, FmtInteger(IHex));
		hash.set("X".code, FmtInteger(IHex));
		hash.set("o".code, FmtInteger(IOctal));
		hash.set("b".code, FmtInteger(IBin));
		
		hash.set("f".code, FmtFloat(FNormal));
		hash.set("e".code, FmtFloat(FScientific));
		hash.set("E".code, FmtFloat(FScientific));
		hash.set("g".code, FmtFloat(FNatural));
		hash.set("G".code, FmtFloat(FNatural));
		
		hash.set("s".code, FmtString);
		
		hash.set("p".code, FmtPointer);
		hash.set("n".code, FmtNothing);
		
		return hash;
	}
	
	static var _instance:Sprintf = null;
	
	var formatIntFuncHash:IntMap < Int->FormatArgs->String >;
	var formatFloatFuncHash:IntMap < Float->FormatArgs->String >;
	var formatStringFuncHash:IntMap < String->FormatArgs->String >;
	
	#if macro
	var formatIntFuncNameHash:IntMap < String>;
	var formatFloatFuncNameHash:IntMap < String >;
	var formatStringFuncNameHash:IntMap < String > ;
	
	function makeNameHashes()
	{
		formatIntFuncNameHash = new IntMap();
		formatFloatFuncNameHash = new IntMap();
		formatStringFuncNameHash = new IntMap();
		
		formatIntFuncNameHash.set(std.Type.enumIndex(ISignedDecimal), "formatSignedDecimal");
		formatIntFuncNameHash.set(std.Type.enumIndex(IUnsignedDecimal), "formatUnsignedDecimal");
		formatIntFuncNameHash.set(std.Type.enumIndex(ICharacter), "formatCharacter");
		formatIntFuncNameHash.set(std.Type.enumIndex(IHex), "formatHex");
		formatIntFuncNameHash.set(std.Type.enumIndex(IOctal), "formatOctal");
		formatIntFuncNameHash.set(std.Type.enumIndex(IBin), "formatBin");
		
		formatFloatFuncNameHash.set(std.Type.enumIndex(FNormal), "formatNormalFloat");
		formatFloatFuncNameHash.set(std.Type.enumIndex(FScientific), "formatScientific");
		formatFloatFuncNameHash.set(std.Type.enumIndex(FNatural), "formatNaturalFloat");
		
		formatStringFuncNameHash.set(std.Type.enumIndex(FmtString), "formatString");
	}
	#end
	
	function new()
	{
		formatIntFuncHash = new IntMap();
		formatFloatFuncHash = new IntMap();
		formatStringFuncHash = new IntMap();
		
		formatIntFuncHash.set(std.Type.enumIndex(ISignedDecimal), formatSignedDecimal);
		formatIntFuncHash.set(std.Type.enumIndex(IUnsignedDecimal), formatUnsignedDecimal);
		formatIntFuncHash.set(std.Type.enumIndex(ICharacter), formatCharacter);
		formatIntFuncHash.set(std.Type.enumIndex(IHex), formatHex);
		formatIntFuncHash.set(std.Type.enumIndex(IOctal), formatOctal);
		formatIntFuncHash.set(std.Type.enumIndex(IBin), formatBin);
		
		formatFloatFuncHash.set(std.Type.enumIndex(FNormal), formatNormalFloat);
		formatFloatFuncHash.set(std.Type.enumIndex(FScientific), formatScientific);
		formatFloatFuncHash.set(std.Type.enumIndex(FNatural), formatNaturalFloat);
		
		formatStringFuncHash.set(std.Type.enumIndex(FmtString), formatString);
		
		#if macro
		makeNameHashes();
		#end
	}
	
	/**
	 * Writes formatted data to a string.
	 * @param fmt the string that contains the formatted text.<br/>
	 * It can optionally contain embedded format tags that are substituted by the values specified in subsequent argument(s) and formatted as requested.<br/>
	 * The number of arguments following the format parameters should at least be as much as the number of format tags.<br/>
	 * The format tags follow this prototype: '%[flags][width][.precision][length]specifier'.
	 * @param arg depending on the format string, the function may expect a sequence of additional arguments, each containing one value to be inserted instead of each %-tag specified in the format parameter, if any.<br/>
	 * The argument array length should match the number of %-tags that expect a value.
	 * @return the formatted string.
	 */
	macro public static function format(_fmt:ExprOf<String>, _passedArgs:Array<Expr>):ExprOf<String>
	{
		var error = false;
		switch(Context.typeof(_fmt))
		{
		case TInst(t, _):
			error = t.get().name != "String";
		default:
			error = true;
		}
		
		if (error)
			Context.error("Format should be a string", _fmt.pos);
		
		var _args:ExprOf<Array<Dynamic>>;
		if (_passedArgs == null || _passedArgs.length == 0)
			_args = Context.makeExpr([], Context.currentPos());
		else
		{
			var makeArray = true;
			if(_passedArgs.length == 1)
				switch(Context.typeof({expr:ECheckType(_passedArgs[0],(macro : Array<Dynamic>)), pos:_passedArgs[0].pos}))
				{
				case TInst(t, _):
					if (t.get().name == "Array")
						makeArray = false;
				default:
					makeArray = true;
				};
			if (makeArray)
			{
				var min = Context.getPosInfos(_passedArgs[0].pos).min;
				var max = Context.getPosInfos(_passedArgs[_passedArgs.length - 1].pos).max;
				var file = Context.getPosInfos(Context.currentPos()).file;
				var pos = Context.makePosition( { min:min, max:max, file:file } );
				_args = { expr:EArrayDecl(_passedArgs), pos:pos };
			}
			else
				_args = _passedArgs[0];
		}
		
		// Force _args array to be typed as Array<Dynamic>
		var dynArrayType:ComplexType = macro : Array<Dynamic>;
		_args = { expr:ECheckType(_args, dynArrayType), pos:_args.pos };
		
		switch(Context.typeof(_args))
		{
		case TInst(t, _):
			error = t.get().name != "Array";
		default:
			error = true;
		}
		
		if (error)
			Context.error("Arguments should be an array", _args.pos);
		
		var fmt:String = null;
		var fmtArgs:Array<Expr> = null;
		
		switch(_fmt.expr) 
		{
		case EConst(const):
			switch(const)
			{
			case CString(valStr):
				fmt = valStr;
			default:
			}
		default:
		}
		
		switch(_args.expr)
		{
		case EArrayDecl(values):
			fmtArgs = values;
		default:
		}
		
		if(fmt == null)
			return macro de.polygonal.core.fmt.Sprintf._full_runtime_format($_fmt, $_args);
		
		var fmtTokens:Array<FormatToken> = null;
		
		try {
			fmtTokens = tokenize(fmt);
		}
		catch (e:Dynamic) {
			Context.error(Std.string(e), _fmt.pos);
		}
		
		var instanceExpr = { expr:EConst(CIdent("__sprintFInstance")), pos:Context.currentPos() };
		var outputArr:Array<Expr> = new Array();
		
		var knownArgs = fmtArgs != null;
		var argsIndex = 0;
		var usedArgs:Array<Bool> = new Array();
		if (knownArgs)
		{
			for (i in 0...fmtArgs.length)
			{
				usedArgs.push(false);
			}
		}
		
		if (_instance == null)
			_instance = new Sprintf();
		
		for (token in fmtTokens)
		{
			switch(token)
			{
			case Unknown(_, pos):
				var min = Context.getPosInfos(_fmt.pos).min + pos;
				var max = min + 1;
				var file = Context.getPosInfos(Context.currentPos()).file;
				Context.error("invalid format specifier", Context.makePosition( { min:min, max:max, file:file } ));
			case BareString(str):
				outputArr.push(Context.makeExpr(str, Context.currentPos()));
			case Property(name):
				var objExpr = (knownArgs)?
					fmtArgs[0]:
					{ expr:EArray(_args, Context.makeExpr(0, _args.pos)), pos:_args.pos };
					
				usedArgs[0] = true;
				
				var valueExpr:Expr = null;
				switch(objExpr.expr)
				{
				case EObjectDecl(fields):
					for (field in fields)
					{
						if (field.field == name)
						{
							valueExpr = field.expr;
							break;
						}
					}
				default:
				}
				if (valueExpr == null)
					valueExpr = { expr:EField(objExpr, name), pos:objExpr.pos };
				
				var outputExpr = macro Std.string($valueExpr);
				outputArr.push(outputExpr);
			case Tag(type, args):
				var widthExpr = Context.makeExpr(args.width, Context.currentPos());
				if (args.width == null)
				{
					usedArgs[argsIndex] = true;
					
					widthExpr = (knownArgs)?
						fmtArgs[argsIndex++]:
						{ expr:ECheckType( { expr:EArray(_args, Context.makeExpr(argsIndex++, _args.pos)), pos:_args.pos }, TPath( { sub:null, params:[], pack:[], name:"Int" } )), pos:Context.currentPos() };
					if (widthExpr == null)
						Context.error("Not enough arguments", _args.pos);
					var error = false;
					switch(widthExpr.expr)
					{
					case EConst(c):
						switch(c)
						{
						case CInt(value):
							args.width = Std.parseInt(value);
						case CIdent(_):
							switch(Context.typeof(widthExpr))
							{
							case TInst(type, _):
								error = type.get().name != "Int";
							default:
								error = true;
							}
						default:
							error = true;
						}
					default:
						switch(Context.typeof(widthExpr))
						{
						case TInst(type, _):
							error = type.get().name != "Int";
						default:
							error = true;
						}
					}
					if (error)
						Context.error("width must be an integer", widthExpr.pos);
				}
				var precisionExpr = Context.makeExpr(args.precision, Context.currentPos());
				if (args.precision == null)
				{
					usedArgs[argsIndex] = true;
					
					precisionExpr = (knownArgs)?
						fmtArgs[argsIndex++]:
						{ expr:ECheckType( { expr:EArray(_args, Context.makeExpr(argsIndex++, _args.pos)), pos:_args.pos }, TPath( { sub:null, params:[], pack:[], name:"Int" } )), pos:Context.currentPos() };
					if (precisionExpr == null)
						Context.error("Not enough arguments", _args.pos);
					var error = false;
					switch(precisionExpr.expr)
					{
					case EConst(c):
						switch(c)
						{
						case CInt(value):
							args.precision = Std.parseInt(value);
						case CIdent(_):
							switch(Context.typeof(precisionExpr))
							{
							case TInst(type, _):
								error = type.get().name != "Int";
							default:
								error = true;
							}
						default:
							error = true;
						}
					default:
						switch(Context.typeof(precisionExpr))
						{
						case TInst(type, _):
							error = type.get().name != "Int";
						default:
							error = true;
						}
					}
					if (error)
						Context.error("precision must be an integer", precisionExpr.pos);
				}
				
				var flagsIntExpr = Context.makeExpr(args.flags.toInt(), Context.currentPos());
				
				var argsExpr = { expr:EObjectDecl(
						[
							{field:"width", expr:widthExpr },
							{field:"precision", expr:precisionExpr },
							{field:"flags", expr:macro haxe.EnumFlags.ofInt($flagsIntExpr) },
							{field:"pos", expr:Context.makeExpr(args.pos, Context.currentPos()) }
						]), pos:Context.currentPos() };
				
				var valuePos = (args.pos > -1)?args.pos:argsIndex++;
				var valueExpr = (knownArgs)?
					fmtArgs[valuePos]:
					{ expr:EArray(_args, Context.makeExpr(valuePos, _args.pos)), pos:_args.pos };
				if (valueExpr == null)
					Context.error("Not enough arguments", _args.pos);
					
				usedArgs[valuePos] = true;
				
				var value:Dynamic;
				
				switch(valueExpr.expr)
				{
				case EConst(const):
					switch(const)
					{
					case CFloat(cValue):
						value = Std.parseFloat(cValue);
					case CInt(cValue):
						value = Std.parseInt(cValue);
					case CString(cValue):
						value = cValue;
					default:
						value = null;
					}
				default:
					value = null;
				}
				
				var preComputable = args.precision != null && args.width != null && value != null;
				
				var outputExpr:Expr;
				
				var typeName = function(e:Expr):String {
					switch(Context.typeof(e))
					{
					case TInst(t, _):
						return (t.get().name);
					default:
						return null;
					}
				};
				
				var formatFunction:Dynamic->FormatArgs->String;
				var formatFunctionName:String;
				
				switch(type)
				{
				case FmtFloat(floatType):
					if (preComputable && !Std.is(value, Float) && !Std.is(value, Int))
						Context.error("the value must be a number", valueExpr.pos);
					formatFunction = _instance.formatFloatFuncHash.get(std.Type.enumIndex(floatType));
					formatFunctionName = _instance.formatFloatFuncNameHash.get(std.Type.enumIndex(floatType));
				case FmtInteger(integerType):
					if (preComputable && !Std.is(value, Int))
						Context.error("the value must be an integer", valueExpr.pos);
					formatFunction = _instance.formatIntFuncHash.get(std.Type.enumIndex(integerType));
					formatFunctionName = _instance.formatIntFuncNameHash.get(std.Type.enumIndex(integerType));
				case FmtString:
					formatFunction = _instance.formatStringFuncHash.get(std.Type.enumIndex(FmtString));
					formatFunctionName = _instance.formatStringFuncNameHash.get(std.Type.enumIndex(FmtString));
					
					value = Std.string(value);
					valueExpr = macro Std.string($valueExpr);
				case FmtPointer:
					Context.error("specifier 'p' is not supported", _fmt.pos);
				case FmtNothing:
					Context.error("specifier 'n' is not supported", _fmt.pos);
				}
				
				if (preComputable)
				{
					var formatedValue = formatFunction(value, args);
					outputExpr = { expr:EConst(CString(formatedValue)), pos:valueExpr.pos };
				}
				else
				{
					outputExpr = { expr:ECall( { expr:EField(instanceExpr, formatFunctionName), pos:Context.currentPos() }, [valueExpr, argsExpr]), pos:Context.currentPos() };
				}
				
				outputArr.push(outputExpr);
			}
		}
		
		if(Context.defined("verbose") && knownArgs)
		{
			var lastUnused = false;
			var unusedIntervals:Array<{min:Int, max:Int, file:String}> = new Array();
			for (i in 0...usedArgs.length)
			{
				if (usedArgs[i] == false)
				{
					if (lastUnused)
						unusedIntervals[unusedIntervals.length - 1].max = Context.getPosInfos(fmtArgs[i].pos).max;
					else
						unusedIntervals.push(Context.getPosInfos(fmtArgs[i].pos));
					
					lastUnused = true;
				}
				else
				{
					lastUnused = false;
				}
			}
			for (interval in unusedIntervals)
			{
				Context.warning("Unused Parameters", Context.makePosition(interval));
			}
		}
		
		
		var returnStrExpr:Expr = outputArr[outputArr.length - 1];
		
		for (_i in 1...outputArr.length)
		{
			var i = outputArr.length -1 - _i;
			
			returnStrExpr = { expr:EBinop(OpAdd, outputArr[i], returnStrExpr), pos:Context.currentPos() };
		}
		
		var returnBlock:Expr = macro {
			if (untyped (de.polygonal.core.fmt.Sprintf._instance) == null)
				untyped de.polygonal.core.fmt.Sprintf._instance = new de.polygonal.core.fmt.Sprintf();
			var __sprintFInstance:de.polygonal.core.fmt.Sprintf = untyped de.polygonal.core.fmt.Sprintf._instance;
			$returnStrExpr;
		};
		
		return returnBlock;
	}
	
	
	public static function tokenize(fmt:String):Array<FormatToken>
	{
		var length = fmt.length;
		var lastStr = new StringBuf();
		var i = 0;
		var c = 0;
		var tokens:Array<FormatToken> = new Array();
		while (i < length)
		{
			var c = StringTools.fastCodeAt(fmt, i++);
			if (c == "%".code)
			{
				c = StringTools.fastCodeAt(fmt, i++);
				if (c == "%".code)
					lastStr.addChar(c);
				else
				{
					//{flush last string
					if (lastStr.toString().length > 0)
					{
						tokens.push(BareString(lastStr.toString()));
						lastStr = new StringBuf();
					}
					//}
					
					var token:FormatToken;
					
					//{named parameter
					if (c == "(".code)
					{
						var endPos = fmt.indexOf(")", i);
						if (endPos == -1)
						{
							token = Unknown("named param", i);
						}
						else
						{
							var paramName = fmt.substr(i, endPos - i);
							i = endPos + 1;
							token = Property(paramName);
						}
					}
					//}
					else
					{
						var params:FormatArgs = { flags:EnumFlags.ofInt(0), pos:-1, width:-1, precision:-1 };
						//{read flags: -+(space)#0
						while (c == "-".code || c == "+".code || c == "#".code
									|| c == "0".code || c == " ".code)
						{
							if (c == "-".code)
								params.flags.set(Minus);
							else if (c == "+".code)
								params.flags.set(Plus);
							else if (c == "#".code)
								params.flags.set(Sharp);
							else if (c == "0".code)
								params.flags.set(Zero);
							else if (c == " ".code)
								params.flags.set(Space);
								
							c = StringTools.fastCodeAt(fmt, i++);
						}
						//}
						
						//{Check for conflicting flags
						if (params.flags.has(Minus) && params.flags.has(Zero))
						{
							#if macro
							Context.warning("warning: `0' flag ignored with '-' flag in printf format", Context.currentPos());
							#end
							params.flags.unset(Zero);
						}
						if (params.flags.has(Space) && params.flags.has(Plus))
						{
							#if macro
							Context.warning("warning: ` ' flag ignored with '+' flag in printf format", Context.currentPos());
							#end
							params.flags.unset(Space);
						}
						//}
						
						//{read width: (number) or "*"
						if (c == "*".code)
						{
							params.width = null;
							c = StringTools.fastCodeAt(fmt, i++);
						}
						else if (c.isDigit())
						{
							params.width = 0;
							while (c.isDigit())
							{
								params.width = c - "0".code + params.width * 10;
								c = StringTools.fastCodeAt(fmt, i++);
							}
							// Check if number was a position, not a width
							if (c == "$".code)
							{
								params.pos = params.width - 1;
								params.width = -1;
								c = StringTools.fastCodeAt(fmt, i++);
								//re-check for width
								if (c == "*".code)
								{
									params.width = null;
									c = StringTools.fastCodeAt(fmt, i++);
								}
								else if (c.isDigit())
								{
									params.width = 0;
									while (c.isDigit())
									{
										params.width = c - "0".code + params.width * 10;
										c = StringTools.fastCodeAt(fmt, i++);
									}
								}
							}
						}
						//}
						
						//{read .precision: .(number) or ".*"
						if (c == ".".code)
						{
							c = StringTools.fastCodeAt(fmt, i++);
							if (c == "*".code)
							{
								params.precision = null;
								c = StringTools.fastCodeAt(fmt, i++);
							}
							else if (c.isDigit())
							{
								params.precision = 0;
								while (c.isDigit())
								{
									params.precision = c - "0".code + params.precision * 10;
									c = StringTools.fastCodeAt(fmt, i++);
								}
							}
							else
								params.precision = 0;
						}
						//}
						
						//{read length: hlL
						while (c == "h".code || c == "l".code || c == "L".code)
						{
							switch (c)
							{
							case "h".code:
								params.flags.set(LengthH);
							case "l".code:
								params.flags.set(Lengthl);
							case "L".code:
								params.flags.set(LengthL);
							}
							c = StringTools.fastCodeAt(fmt, i++);
						}
						//}
						
						//{read specifier: cdieEfgGosuxX
						if(c == "E".code || c == "G".code || c == "X".code)
							params.flags.set(UpperCase);
						
						var type = dataTypeHash.get(c);
						
						if (type == null)
							token = Unknown(String.fromCharCode(c), i);
						else
							token = Tag(type, params);
						//}
					}
					tokens.push(token);
				}
			}
			else
			{
				lastStr.addChar(c);
			}
		}
		if (lastStr.toString().length > 0)
		{
			tokens.push(BareString(lastStr.toString()));
		}
		return tokens;
	}
	
	#if doc
	public
	#elseif (!display && !doc)
	public
	#end
	static inline function _full_runtime_format(fmt:String, args:Array<Dynamic>):String
	{
		if (_instance == null)
			_instance = new Sprintf();
		return _instance._format(fmt, args);
	}
	
	function _format(fmt:String, args:Array<Dynamic>):String
	{
		var output = "";
		var argIndex = 0;
		var tokens = tokenize(fmt);
		for (token in tokens)
		{
			switch(token)
			{
			case Unknown(_, _):
				throw "invalid format specifier";
			case BareString(str):
				output += str;
			case Property(name):
				if (!Reflect.hasField(args[0], name))
					throw "no field named " + name;
				output += Std.string(Reflect.field(args[0], name));
			case Tag(type, tagArgs):
				tagArgs.width = (tagArgs.width != null)?tagArgs.width:cast(args[argIndex++], Int);
				tagArgs.precision = (tagArgs.precision != null)?tagArgs.precision:cast(args[argIndex++], Int);
				var value:Dynamic = args[argIndex++];
				
				var formatFunction:Dynamic->FormatArgs->String;
				
				switch(type)
				{
				case FmtFloat(floatType):
					formatFunction = formatFloatFuncHash.get(std.Type.enumIndex(floatType));
				case FmtInteger(integerType):
					formatFunction = formatIntFuncHash.get(std.Type.enumIndex(integerType));
				case FmtString:
					formatFunction = formatStringFuncHash.get(std.Type.enumIndex(FmtString));
				case FmtPointer:
					throw "specifier 'p' is not supported";
				case FmtNothing:
					throw "specifier 'n' is not supported";
				}
				
				output += formatFunction(value, tagArgs);
			}
		}
		return output;
	}
	
	public inline function formatBin(value:Int, args:FormatArgs):String
	{
		var output = "";
		if (args.precision == -1) args.precision = 1;
		
		if (args.precision == 0 && value == 0)
			output = "";
		else
		{
			if (args.flags.has(LengthH))
				value &= 0xffff;
			
			//toBin()
			var i = value;
			do
			{
				output = ((i & 1) > 0 ? '1' : '0') + output;
				i >>>= 1;
			}
			while (i > 0);
			
			if (args.precision > 1)
			{
				if (args.precision > output.length)
				{
					output = StringTools.lpad(output, "0", args.precision);
				}
				if (args.flags.has(Sharp)) output = "b" + output;
			}
		}
		return
		if (args.flags.has(Minus))
			(args.width > output.length) ? StringTools.rpad(output, " ", args.width) : output;
		else
			(args.width > output.length) ? StringTools.lpad(output, (args.flags.has(Zero)?"0":" ") , args.width) : output;
	}
	
	public inline function formatOctal(value:Int, args:FormatArgs):String
	{
		var output = "";
		if (args.precision == -1) args.precision = 1;
		
		if (args.precision == 0 && value == 0)
			output = "";
		else
		{
			if (args.flags.has(LengthH)) value &= 0xffff;
			
			//toOct()
			output = '';
			do
			{
				output = (value & 7) + output;
				value >>>= 3;
			}
			while (value > 0);
			
			if (args.flags.has(Sharp)) output = "0" + output;
			
			if (args.precision > 1 && output.length < args.precision)
			{
				output = StringTools.lpad(output, "0", args.precision);
			}
		}
		
		return
		if (args.flags.has(Minus))
			(args.width > output.length) ? StringTools.rpad(output, " ", args.width) : output;
		else
			(args.width > output.length) ? StringTools.lpad(output, (args.flags.has(Zero)?"0":" ") , args.width) : output;
	}
	
	public inline function formatHex(value:Int, args:FormatArgs):String
	{
		var output = "";
		if (args.precision == -1) args.precision = 1;
		
		if (args.precision == 0 && value == 0)
			output = "";
		else
		{
			if (args.flags.has(LengthH))
				value &= 0xffff;
			
			output = StringTools.hex(value);
			if (args.precision > 1 && output.length < args.precision)
			{
				output = StringTools.lpad(output, "0", args.precision);
			}
			
			if (args.flags.has(Sharp) && value != 0)
				output = "0x" + output;
			output = (args.flags.has(UpperCase)) ? output.toUpperCase() : output.toLowerCase();
		}
		
		return
		if (args.flags.has(Minus))
			(args.width > output.length) ? StringTools.rpad(output, " ", args.width) : output;
		else
			(args.width > output.length) ? StringTools.lpad(output, (args.flags.has(Zero))?"0":" " , args.width) : output;
	}
	
	public inline function formatUnsignedDecimal(value:Int, args:FormatArgs):String
	{
		var output = "";
		if (value >= 0)
			output = formatSignedDecimal(value, args);
		else
		{
			var x = haxe.Int64.make(0, value);
			
			output = haxe.Int64.toStr(x);
			
			if (args.precision > 1 && output.length < args.precision)
			{
				output = StringTools.lpad(output, "0", args.precision);
			}
			output = padNumber(output, value, args.flags, args.width);
		}
		
		return output;
	}
	
	public inline function formatNaturalFloat(value:Float, args:FormatArgs):String
	{
		// TODO: precompute lengths
		args.precision = 0;
		
		var formatedFloat = formatNormalFloat(value, args);
		var formatedScientific = formatScientific(value, args);
		
		if (args.flags.has(Sharp))
		{
			if (formatedFloat.indexOf(".") != -1)
			{
				var pos = formatedFloat.length -1;
				while (StringTools.fastCodeAt(formatedFloat, pos) == "0".code) pos--;
				formatedFloat = formatedFloat.substr(0, pos);
			}
		}
		
		return (formatedFloat.length <= formatedScientific.length) ? formatedFloat : formatedScientific;
	}
	
	public inline function formatScientific(value:Float, args:FormatArgs):String
	{
		var output = "";
		if (args.precision == -1) args.precision = 6;
		
		var sign:Int;
		var exponent:Int;
		
		if (value == 0)
		{
			sign = 0;
			exponent = 0;
			output += '0';
			if (args.precision > 0)
			{
				output += ".";
				for (i in 0...args.precision) output += '0';
			}
		}
		else
		{
			sign = value.fsgn();
			value = value.fabs();
			exponent = Math.floor(Math.log(value) / Mathematics.LN10);
			value = value / Math.pow(10, exponent);
			var p = Math.pow(0.1, args.precision);
			
			value = value.roundTo(p);
		}
		
		output += (sign < 0 ? "-" : args.flags.has(Plus) ? "+" : "");
		
		if (value != 0)
			output += StringTools.rpad(Std.string(value).substr(0, args.precision + 2), "0", args.precision + 2);
		output += args.flags.has(UpperCase) ? "E" : "e";
		output += exponent >= 0 ? "+" : "-";
		
		if (exponent < 10) output += "00";
		else
		if (exponent < 100) output += "0";
		
		output += Std.string(exponent.abs());
		return output;
	}
	
	public inline function formatSignedDecimal(value:Int, args:FormatArgs):String
	{
		var output:String = "";
		
		if (args.precision == 0 && value == 0)
			output = "";
		else
		{
			if (args.flags.has(LengthH))
				value &= 0xffff;
				
			output = Std.string(Mathematics.abs(value));
				
			if (args.precision > 1 && output.length < args.precision)
			{
				output = StringTools.lpad(output, "0", args.precision);
			}
			if (args.flags.has(Zero))
					output = StringTools.lpad(output, "0", (value<0)?args.width-1:args.width);
			if (value < 0)
				output = "-" + output;
		}
		if (value >= 0)
		{
			if (args.flags.has(Plus))
				output = "+" + output;
			else
			if (args.flags.has(Space))
				output = " " + output;
		}
		
		if (args.flags.has(Minus))
		{
			output = StringTools.rpad(output, " ", args.width);
		}
		else
		{
			output = StringTools.lpad(output, " ", args.width);
		}
		
		return output;
	}
	
	public inline function formatString(x:String, args:FormatArgs):String
	{
		var output = x;
		if (args.precision > 0)
			output = x.substr(0, args.precision);
		var k = output.length;
		if (args.width > 0 && k < args.width)
		{
			if (args.flags.has(Minus))
				output = StringTools.rpad(output, " ", args.width);
			else
				output = StringTools.lpad(output, " ", args.width);
		}
		return output;
	}
	
	public inline function formatNormalFloat(value:Float, args:FormatArgs):String
	{
		var output:String;
		//set default precision if not specified
		if (args.precision == -1) args.precision = 6;
		
		if (args.precision == 0)
		{
			output = Std.string(value.round().abs());
			//force decimal point?
			if (args.flags.has(Sharp)) output += ".";
		}
		else
		{
			//toFixed()
			value = value.roundTo(Math.pow(.1, args.precision));
			var decimalPlaces = args.precision;
			if (Math.isNaN(value))
				output = 'NaN';
			else
			{
				var t = M.exp(10, decimalPlaces);
				output = Std.string(Std.int(value * t) / t);
				var i = output.indexOf('.');
				if (i != -1)
				{
					for (i in output.substr(i + 1).length...decimalPlaces)
						output += '0';
				}
				else
				{
					output += '.';
					for (i in 0...decimalPlaces)
						output += '0';
				}
			}
		}
		
		if (args.flags.has(Plus) && value >= 0)
			output = "+" + output;
		else
		if (args.flags.has(Space) && value >= 0)
			output = " " + output;
		
		if (args.flags.has(Zero))
			output = StringTools.lpad(output, "0", (value < 0)?args.width - 1:args.width);
		
		if (value < 0)
			output = "-" + output;
		
		if (args.flags.has(Minus))
			output = StringTools.rpad(output, " ", args.width);
		else
			output = StringTools.lpad(output, " ", args.width);
		
		return output;
	}
	
	public inline function formatCharacter(x:Int, args:FormatArgs):String
	{
		var output = String.fromCharCode(x);
		if (args.width > 1)
		{
			//left-justify (right justification is the default)
			if (args.flags.has(Minus))
				output = StringTools.rpad(output, " ", args.width);
			else
				output = StringTools.lpad(output, " ", args.width);
		}
		
		return output;
	}
	
	inline function padNumber(x:String, n:Float, flags:EnumFlags<FormatFlags>, width:Int):String
	{
		var k = x.length;
		if (width > 0 && k < width)
		{
			//left-justify (right justification is the default)
			if (flags.has(Minus))
				x = StringTools.rpad(x, " ", width);
			else
			{
				if (n >= 0)
					x = StringTools.lpad(x, flags.has(Zero) ? "0" : " ", width);
				else
				{
					if (flags.has(Zero))
					{
						//shift minus sign to left-most position
						x = "-" + StringTools.lpad(x.substr(1), "0", width);
					}
					else
						x = StringTools.lpad(x, " ", width);
				}
			}
		}
		
		return x;
	}
}

private typedef FormatArgs =
{
	flags:haxe.EnumFlags<FormatFlags>,
	pos:Int,
	width:Null<Int>,
	precision:Null<Int>
}

private enum FormatFlags
{
	Minus;
	Plus;
	Space;
	Sharp;
	Zero;
	LengthH;
	LengthL;
	Lengthl;
	UpperCase;
}

private enum FormatToken
{
	BareString(str:String);
	Tag(type:FormatDataType, args:FormatArgs);
	Property(name:String);
	Unknown(str:String, pos:Int);
}

private enum FormatDataType
{
	FmtInteger(integerType:IntegerType);
	FmtFloat(floatType:FloatType);
	FmtString;
	FmtPointer;
	FmtNothing;
}

private enum IntegerType
{
	ICharacter;
	ISignedDecimal;
	IUnsignedDecimal;
	IOctal;
	IHex;
	IBin;
}

private enum FloatType
{
	FNormal;
	FScientific;
	FNatural;
}