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
package de.polygonal.core.math;

/**
 * <p>A 4x4 matrix.</p>
 * <p> Matrix operations are applied on the left. E.g. given a matrix M and vector V, matrix*vector is M*V, where V is treated as a column vector.</p>
 */
class Mat44
{
	static var _sharedSineCosine:Vec2 = null;
	
	/**
	 * @return <code>c</code> = <code>a</code>*<code>b</code>.
	 */
	inline public static function matrixProduct(a:Mat44, b:Mat44, c:Mat44):Mat44
	{
		var b11 = b.m11; var b12 = b.m12; var b13 = b.m13; var b14 = b.m14;
		var b21 = b.m21; var b22 = b.m22; var b23 = b.m23; var b24 = b.m24;
		var b31 = b.m31; var b32 = b.m32; var b33 = b.m33; var b34 = b.m34;
		var b41 = b.m41; var b42 = b.m42; var b43 = b.m43; var b44 = b.m44;
		var t1, t2, t3, t4;
		t1 = a.m11;
		t2 = a.m12;
		t3 = a.m13;
		t4 = a.m14;
		c.m11 = t1 * b11 + t2 * b21 + t3 * b31 + t4 * b41;
		c.m12 = t1 * b12 + t2 * b22 + t3 * b32 + t4 * b42;
		c.m13 = t1 * b13 + t2 * b23 + t3 * b33 + t4 * b43;
		c.m14 = t1 * b14 + t2 * b24 + t3 * b34 + t4 * b44;
		t1 = a.m21;
		t2 = a.m22;
		t3 = a.m23;
		t4 = a.m24;
		c.m21 = t1 * b11 + t2 * b21 + t3 * b31 + t4 * b41;
		c.m22 = t1 * b12 + t2 * b22 + t3 * b32 + t4 * b42;
		c.m23 = t1 * b13 + t2 * b23 + t3 * b33 + t4 * b43;
		c.m24 = t1 * b14 + t2 * b24 + t3 * b34 + t4 * b44;
		t1 = a.m31;
		t2 = a.m32;
		t3 = a.m33;
		t4 = a.m34;
		c.m31 = t1 * b11 + t2 * b21 + t3 * b31 + t4 * b41;
		c.m32 = t1 * b12 + t2 * b22 + t3 * b32 + t4 * b42;
		c.m33 = t1 * b13 + t2 * b23 + t3 * b33 + t4 * b43;
		c.m34 = t1 * b14 + t2 * b24 + t3 * b34 + t4 * b44;
		t1 = a.m41;
		t2 = a.m42;
		t3 = a.m43;
		t4 = a.m44;
		c.m41 = t1 * b11 + t2 * b21 + t3 * b31 + t4 * b41;
		c.m42 = t1 * b12 + t2 * b22 + t3 * b32 + t4 * b42;
		c.m43 = t1 * b13 + t2 * b23 + t3 * b33 + t4 * b43;
		c.m44 = t1 * b14 + t2 * b24 + t3 * b34 + t4 * b44;
		return c;
	}
	
	/**
	 * @return <code>result</code> = <code>matrix</code>*<code>scale</code>.
	 */
	inline public static function catMatrixAndScale(matrix:Mat44, scale:Mat44, result:Mat44):Mat44
	{
		var t;
		t = scale.m11;
		result.m11 = matrix.m11 * t;
		result.m21 = matrix.m21 * t;
		result.m31 = matrix.m31 * t;
		result.m41 = matrix.m41 * t;
		t = scale.m22;
		result.m12 = matrix.m12 * t;
		result.m22 = matrix.m22 * t;
		result.m32 = matrix.m32 * t;
		result.m42 = matrix.m42 * t;
		t = scale.m33;
		result.m13 = matrix.m13 * t;
		result.m23 = matrix.m23 * t;
		result.m33 = matrix.m33 * t;
		result.m43 = matrix.m43 * t;
		t = scale.m44;
		result.m14 = matrix.m14 * t;
		result.m24 = matrix.m24 * t;
		result.m34 = matrix.m34 * t;
		result.m44 = matrix.m44 * t;
		return result;
	}
	
	/**
	 * @return <code>result</code> = <code>scale</code>*<code>matrix</code>.
	 */
	inline public static function catScaleAndMatrix(scale:Mat44, matrix:Mat44, result:Mat44):Mat44
	{
		var t;
		t = scale.m11;
		result.m11 = t * matrix.m11;
		result.m12 = t * matrix.m12;
		result.m13 = t * matrix.m13;
		result.m14 = t * matrix.m14;
		t = scale.m22;
		result.m21 = t * matrix.m21;
		result.m22 = t * matrix.m22;
		result.m23 = t * matrix.m23;
		result.m24 = t * matrix.m24;
		t = scale.m33;
		result.m31 = t * matrix.m31;
		result.m32 = t * matrix.m32;
		result.m33 = t * matrix.m33;
		result.m34 = t * matrix.m34;
		t = scale.m44;
		result.m41 = t * matrix.m41;
		result.m42 = t * matrix.m42;
		result.m43 = t * matrix.m43;
		result.m44 = t * matrix.m44;
		return result;
	}
	
	public var m11:Float; public var m12:Float; public var m13:Float; public var m14:Float;
	public var m21:Float; public var m22:Float; public var m23:Float; public var m24:Float;
	public var m31:Float; public var m32:Float; public var m33:Float; public var m34:Float;
	public var m41:Float; public var m42:Float; public var m43:Float; public var m44:Float;
	
	public var sx(get_sx, set_sx):Float;
	inline function get_sx():Float
	{
		return m11;
	}
	inline function set_sx(value:Float):Float
	{
		return m11 = value;
	}
	
	public var sy(get_sy, set_sy):Float;
	inline function get_sy():Float
	{
		return m22;
	}
	inline function set_sy(value:Float):Float
	{
		return m22 = value;
	}
	
	public var sz(get_sz, set_sz):Float;
	inline function get_sz():Float
	{
		return m33;
	}
	inline function set_sz(value:Float):Float
	{
		return m33 = value;
	}
	
	public var tx(get_tx, set_tx):Float;
	inline function get_tx():Float
	{
		return m14;
	}
	inline function set_tx(value:Float):Float
	{
		return m14 = value;
	}
	
	public var ty(get_ty, set_ty):Float;
	inline function get_ty():Float
	{
		return m24;
	}
	inline function set_ty(value:Float):Float
	{
		return m24 = value;
	}
	
	public var tz(get_tz, set_tz):Float;
	inline function get_tz():Float
	{
		return m34;
	}
	inline function set_tz(value:Float):Float
	{
		return m34 = value;
	}
	
	var _sineCosine:Vec2;
	
	/** Creates a 4x4 identity matrix. */
	public function new()
	{
		setIdentity();
		if (_sharedSineCosine == null) _sharedSineCosine = new Vec2();
		_sineCosine = _sharedSineCosine;
	}

	/** Assigns the values of <code>other</code> to this. */
	inline public function set(other:Mat44):Mat44
	{
		m11 = other.m11; m12 = other.m12; m13 = other.m13; m14 = other.m14;
		m21 = other.m21; m22 = other.m22; m23 = other.m23; m24 = other.m24;
		m31 = other.m31; m32 = other.m32; m33 = other.m33; m34 = other.m34;
		m41 = other.m41; m42 = other.m42; m43 = other.m43; m44 = other.m44;
		return this;
	}
	
	/** Copy all elements of <code>other</code> to this. */
	inline public function set33(other:Mat33):Mat44
	{
		m11 = other.m11; m12 = other.m12; m13 = other.m13;
		m21 = other.m21; m22 = other.m22; m23 = other.m23;
		m31 = other.m31; m32 = other.m32; m33 = other.m33;
		return this;
	}
	
	/** Set to identity matrix. */
	inline public function setIdentity():Mat44
	{
		m11 = 1; m12 = 0; m13 = 0; m14 = 0;
		m21 = 0; m22 = 1; m23 = 0; m24 = 0;
		m31 = 0; m32 = 0; m33 = 1; m34 = 0;
		m41 = 0; m42 = 0; m43 = 0; m44 = 1;
		return this;
	}
	
	/** Set as scaling matrix, scaling by <code>x</code>, <code>y</code>, <code>z</code>. */
	inline public function setScale(x:Float, y:Float, z:Float):Mat44
	{
		m11 = x; m12 = 0; m13 = 0; m14 = 0;
		m21 = 0; m22 = y; m23 = 0; m24 = 0;
		m31 = 0; m32 = 0; m33 = z; m34 = 0;
		m41 = 0; m42 = 0; m43 = 0; m44 = 1;
		return this;
	}
	
	/** Set as translation matrix, translating by <code>x</code>, <code>y</code>, <code>z</code>. */
	inline public function setTranslate(x:Float, y:Float, z:Float):Mat44
	{
		m11 = 1; m12 = 0; m13 = 0; m14 = x;
		m21 = 0; m22 = 1; m23 = 0; m24 = y;
		m31 = 0; m32 = 0; m33 = 1; m34 = z;
		m41 = 0; m42 = 0; m43 = 0; m44 = 1;
		return this;
	}
	
	/**
	 * Set as rotation matrix, rotating by <code>angle</code> radians around x-axis.<br/>
	 * The (x,y,z) coordinate system is assumed to be right-handed, so <code>angle</code> > 0 indicates a counterclockwise rotation in the yz-plane.
	 */
	inline public function setRotateX(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		m11 = 1; m12 = 0; m13 = 0; m14 = 0;
		m21 = 0; m22 = c; m23 =-s; m24 = 0;
		m31 = 0; m32 = s; m33 = c; m34 = 0;
		m41 = 0; m42 = 0; m43 = 0; m44 = 1;
		return this;
	}
	
	/**
	 * Set as rotation matrix, rotating by <code>angle</code> radians around y-axis.<br/>
	 * The (x,y,z) coordinate system is assumed to be right-handed, so <code>angle</code> > 0 indicates a counterclockwise rotation in the zx-plane.
	 */
	inline public function setRotateY(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		m11 = c; m12 = 0; m13 = s; m14 = 0;
		m21 = 0; m22 = 1; m23 = 0; m24 = 0;
		m31 =-s; m32 = 0; m33 = c; m34 = 0;
		m41 = 0; m42 = 0; m43 = 0; m44 = 1;
		return this;
	}
	
	/**
	 * Set as rotation matrix, rotating by <code>angle</code> radians around z-axis.<br/>
	 * The (x,y,z) coordinate system is assumed to be right-handed, so <code>angle</code> > 0 indicates a counterclockwise rotation in the xy-plane.
	 */
	inline public function setRotateZ(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		m11 = c; m12 =-s; m13 = 0; m14 = 0;
		m21 = s; m22 = c; m23 = 0; m24 = 0;
		m31 = 0; m32 = 0; m33 = 1; m34 = 0;
		m41 = 0; m42 = 0; m43 = 0; m44 = 1;
		return this;
	}
	
	/** Sets the matrix to a rotation matrix by euler angles. */
	public function setRotationEulerAngles(zAngle:Float, yAngle:Float, xAngle:Float)
	{
		_fastTrig(xAngle);
		var sx = _sineCosine.x;
		var cx = _sineCosine.y;
		_fastTrig(yAngle);
		var sy = _sineCosine.x;
		var cy = _sineCosine.y;
		_fastTrig(zAngle);
		var sz = _sineCosine.x;
		var cz = _sineCosine.y;
		m11 = (cy * cz);
		m12 =-(cy * sz);
		m13 = sy;
		m14 = 0;
		m21 =  (sx * sy * cz) + (cx * sz);
		m22 = -(sx * sy * sz) + (cx * cz);
		m23 = -(sx * cy);
		m24 = 0;
		m31 = -(cx * sy * cz) + (sx * sz);
		m32 =  (cx * sy * sz) + (sx * cz);
		m33 =  (cx * cy);
		m34 = 0;
		m41 = 0;
		m42 = 0;
		m43 = 0;
		m44 = 1;
		return this;
	}
	
	/**
	 * Defines a parallel projection, same as <i>glOrtho()</i>.<br/>
	 * @see http://publib.boulder.ibm.com/infocenter/pseries/v5r3/index.jsp?topic=/com.ibm.aix.opengl/doc/openglrf/glOrtho.htm
	 * @param l coordinates for the left clipping plane.
	 * @param r coordinates for the right clipping plane.
	 * @param b coordinates for the bottom clipping plane.
	 * @param t coordinates for the top clipping plane.
	 * @param n coordinates for the near clipping plane.
	 * @param f coordinates for the far clipping plane.
	 */
	public function setOrtho(l:Float, r:Float, b:Float, t:Float, n:Float, f:Float):Mat44
	{
		var w = r - l;
		var h = t - b;
		var d = f - n;
		m11 = 2 / w; m12 = 0;     m13 = 0;      m14 = -(r + l) / w;
		m21 = 0;     m22 = 2 / h; m23 = 0;      m24 = -(t + b) / h;
		m31 = 0;     m32 = 0;     m33 = -2 / d; m34 = -(f + n) / d;
		m41 = 0;     m42 = 0;     m43 = 0;      m44 = 1;
		return this;
	}
	
	/**
	 * Defines a parallel projection.<br/>
	 * Simplied version of <em>setOrtho6()</em> using 4 parameters instead of 6 for a symmetrical viewing volume.
	 * @param width width of field of view
	 * @param height height of field of view
	 * @param near near clipping plane
	 * @param far far clipping plane
	 */
	public function setOrthoSimple(width:Float, height:Float, near:Float, far:Float):Mat44
	{
		return setOrtho(0, width, 0, height, near, far);
	}
	
	/**
	 * Defines a perspective projection, same as <i>glFrustum()</i>.<br/>
	 * @see http://publib.boulder.ibm.com/infocenter/pseries/v5r3/index.jsp?topic=/com.ibm.aix.opengl/doc/openglrf/glFrustum.htm
	 */
	public function setFrustum(l:Float, r:Float, b:Float, t:Float, n:Float, f:Float):Mat44
	{
		var w = r - l;
		var h = t - b;
		var d = f - n;
		m11 = (2 * n) / w; m12 = 0;           m13 = (r + l) / w; m14 = 0;
		m21 = 0;           m22 = (2 * n) / h; m23 = (t + b) / h; m24 = 0;
		m31 = 0;           m32 = 0;           m33 =-(f + n) / d; m34 = -(2 * f * n) / d;
		m41 = 0;           m42 = 0;           m43 =-1;           m44 = 0;
		return this;
	}
	
	/** Post-concatenate a x-axis rotation matrix, rotating by <code>angle</code> radians around x-axis. */
	inline public function catRotateX(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		var t = m21;
		var u = m31;
		m21 = c * t - s * u;
		m31 = s * t + c * u;
		m41 = u;
		t = m22;
		u = m32;
		m22 = c * t - s * u;
		m32 = s * t + c * u;
		m42 = u;
		t = m23;
		u = m33;
		m23 = c * t - s * u;
		m33 = s * t + c * u;
		m43 = u;
		t = m24;
		u = m34;
		m24 = c * t - s * u;
		m34 = s * t + c * u;
		return this;
	}
	
	/** Pre-concatenate a x-axis rotation matrix, rotating by <code>angle</code> radians around x-axis. */
	inline public function precatRotateX(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		var t = m12, u = m13;
		m12 = t * c + u * s;
		m13 = t *-s + u * c;
		t = m22;
		u = m23;
		m22 = t * c + u * s;
		m23 = t *-s + u * c;
		t = m32;
		u = m33;
		m32 = t * c + u * s;
		m33 = t *-s + u * c;
		m42 = t * c + u * s;
		m43 = t *-s + u * c;
		return this;
	}
	
	/** Post-concatenate a y-axis rotation matrix, rotating by <code>angle</code> radians around y-axis. */
	inline public function catRotateY(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		var t = m11;
		var u = m31;
		m11 = c * t + s * u;
		m31 =-s * t + c * u;
		m41 = u;
		t = m12;
		u = m32;
		m12 = c * t + s * u;
		m32 =-s * t + c * u;
		m42 = u;
		t = m13;
		u = m33;
		m13 = c * t + s * u;
		m33 =-s * t + c * u;
		m43 = u;
		t = m14;
		u = m34;
		m14 = c * t + s * u;
		m34 =-s * t + c * u;
		return this;
	}
	
	/** Pre-concatenate a y-axis rotation matrix, rotating by <code>angle</code> radians around y-axis. */
	inline public function precatRotateY(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		var t = m11;
		var u = m13;
		m11 = t * c + u *-s;
		m13 = t * s + u * c;
		var t = m21;
		var u = m23;
		m21 = t * c + u *-s;
		m23 = t * s + u * c;
		var t = m31;
		var u = m33;
		m31 = t * c + u *-s;
		m33 = t * s + u * c;
		m41 = t * c + u *-s;
		m43 = t * s + u * c;
		return this;
	}
	
	/** Post-concatenate a z-axis rotation matrix, rotating by <code>angle</code> radians around z-axis. */
	inline public function catRotateZ(angle:Float):Mat44
	{
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		var t = m11;
		var u = m21;
		m11 = c * t - s * u;
		m21 = s * t + c * u;
		t = m12;
		u = m22;
		m12 = c * t - s * u;
		m22 = s * t + c * u;
		t = m13;
		u = m32;
		m13 = c * t - s * u;
		m23 = s * t + c * u;
		t = m14;
		u = m24;
		m14 = c * t - s * u + t;
		m24 = s * t + c * u + u;
		m34 = m34 + m34;
		return this;
	}
	
	/** Pre-concatenate a z-axis rotation matrix, rotating by <code>angle</code> radians around z-axis. */
	inline public function precatRotateZ(angle:Float):Mat44
	{
		var t11 = m11; var t12 = m12; var t13 = m13; var t14 = m14;
		var t21 = m21; var t22 = m22; var t23 = m23; var t24 = m24;
		var t31 = m31; var t32 = m32; var t33 = m33; var t34 = m34;
		_fastTrig(angle);
		var s = _sineCosine.x;
		var c = _sineCosine.y;
		m11 = t11 *   c + t12 * s;
		m12 = t11 *  -s + t12 * c;
		m14 = t11 * t14 + t12 * t24 + t13 * t34;
		m21 = t21 *   c + t22 * s;
		m22 = t21 *  -s + t22 * c;
		m24 = t21 * t14 + t22 * t24 + t23 * t34;
		m31 = t31 *   c + t32 * s;
		m32 = t31 *  -s + t32 * c;
		m34 = t31 * t14 + t32 * t24 + t33 * t34;
		return this;
	}
	
	/** Post-concatenates <code>lhs</code>: this = <code>lhs</code>*this. */
	inline public function cat(lhs:Mat44):Mat44
	{
		var c11 = m11; var c12 = m12; var c13 = m13; var c14 = m14;
		var c21 = m21; var c22 = m22; var c23 = m23; var c24 = m24;
		var c31 = m31; var c32 = m32; var c33 = m33; var c34 = m34;
		var c41 = m41; var c42 = m42; var c43 = m43; var c44 = m44;
		var t1, t2, t3, t4;
		t1 = lhs.m11;
		t2 = lhs.m12;
		t3 = lhs.m13;
		t4 = lhs.m14;
		m11 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m12 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m13 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m14 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		t1 = lhs.m21;
		t2 = lhs.m22;
		t3 = lhs.m23;
		t4 = lhs.m24;
		m21 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m22 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m23 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m24 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		t1 = lhs.m31;
		t2 = lhs.m32;
		t3 = lhs.m33;
		t4 = lhs.m34;
		m31 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m32 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m33 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m34 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		t1 = lhs.m41;
		t2 = lhs.m42;
		t3 = lhs.m43;
		t4 = lhs.m44;
		m41 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m42 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m43 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m44 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		return this;
	}
	
	/** Pre-concatenates <code>rhs</code>: this = this*<code>rhs</code>. */
	inline public function precat(rhs:Mat44):Mat44
	{
		var c11 = rhs.m11; var c12 = rhs.m12; var c13 = rhs.m13; var c14 = rhs.m14;
		var c21 = rhs.m21; var c22 = rhs.m22; var c23 = rhs.m23; var c24 = rhs.m24;
		var c31 = rhs.m31; var c32 = rhs.m32; var c33 = rhs.m33; var c34 = rhs.m34;
		var c41 = rhs.m41; var c42 = rhs.m42; var c43 = rhs.m43; var c44 = rhs.m44;
		var t1, t2, t3, t4;
		t1 = m11;
		t2 = m12;
		t3 = m13;
		t4 = m14;
		m11 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m12 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m13 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m14 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		t1 = m21;
		t2 = m22;
		t3 = m23;
		t4 = m24;
		m21 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m22 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m23 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m24 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		t1 = m31;
		t2 = m32;
		t3 = m33;
		t4 = m34;
		m31 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m32 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m33 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m34 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		t1 = m41;
		t2 = m42;
		t3 = m43;
		t4 = m44;
		m41 = t1 * c11 + t2 * c21 + t3 * c31 + t4 * c41;
		m42 = t1 * c12 + t2 * c22 + t3 * c32 + t4 * c42;
		m43 = t1 * c13 + t2 * c23 + t3 * c33 + t4 * c43;
		m44 = t1 * c14 + t2 * c24 + t3 * c34 + t4 * c44;
		return this;
	}
	
	/**
	 * Post-concatenates a scaling matrix and returns this matrix.
	 * @param x x-axis scale (<em>m11</em>).
	 * @param y y-axis scale (<em>m22</em>).
	 * @param z z-axis scale (<em>m33</em>).
	 */
	inline public function catScale(x:Float, y:Float, z:Float):Mat44
	{
		//|x 0 0 0| |m11 m12 m13 tx|
		//|0 y 0 0| |m21 m22 m23 ty|
		//|0 0 z 0| |m31 m32 m33 tz|
		//|0 0 0 1| |  0   0   0  1|
		m11 *= x;
		m21 *= x;
		m31 *= x;
		m41 *= x;
		m12 *= y;
		m22 *= y;
		m32 *= y;
		m42 *= y;
		m13 *= z;
		m23 *= z;
		m33 *= z;
		m43 *= z;
		return this;
	}
	
	/**
	 * Pre-concatenates a scaling matrix and returns this matrix.
	 * @param x x-axis scale (<em>m11</em>).
	 * @param y y-axis scale (<em>m22</em>).
	 * @param z z-axis scale (<em>m33</em>).
	 */
	inline public function precatScale(x:Float, y:Float, z:Float):Mat44
	{
		//|m11 m12 m13 tx| |x 0 0 0|
		//|m21 m22 m23 ty| |0 y 0 0|
		//|m31 m32 m33 tz| |0 0 z 0|
		//|  0   0   0  1| |0 0 0 1|
		m11 *= x;
		m12 *= x;
		m13 *= x;
		m14 *= x;
		m21 *= y;
		m22 *= y;
		m23 *= y;
		m24 *= y;
		m31 *= z;
		m32 *= z;
		m33 *= z;
		m34 *= z;
		return this;
	}
	
	/**
	 * Post-concatenates a translation matrix and returns this matrix.
	 * @param x x-axis translation (<code>m14</code>).
	 * @param y y-axis translation (<code>m24</code>).
	 * @param z z-axis translation (<code>m34</code>).
	 */
	inline public function catTranslate(x:Float, y:Float, z:Float):Mat44
	{
		//|1 0 0 tx| |m11 m12 m13 m14|
		//|0 1 0 ty| |m21 m22 m23 m24|
		//|0 0 1 tz| |m31 m32 m33 m34|
		//|0 0 0  1| |  0   0   0   1|
		m14 += x;
		m24 += y;
		m34 += z;
		return this;
	}
	
	/**
	 * Pre-concatenates a translation matrix and returns this matrix.
	 * @param x x-axis translation (<em>m14</em>).
	 * @param y y-axis translation (<em>m24</em>).
	 * @param z z-axis translation (<em>m34</em>).
	 */
	inline public function precatTranslation(x:Float, y:Float, z:Float):Mat44
	{
		//|m11 m12 m13 m14| |1 0 0 tx|
		//|m21 m22 m23 m24| |0 1 0 ty|
		//|m31 m32 m33 m34| |0 0 1 tz|
		//|  0   0   0   1| |0 0 0 t1|
		m14 = m11 * x + m12 * y + m13 * z + m14;
		m24 = m21 * x + m22 * y + m23 * z + m24;
		m34 = m31 * x + m32 * y + m33 * z + m34;
		return this;
	}
	
	/** Matrix - column vector multiplication: <code>rhs</code>' = this*<code>rhs</code>. */
	inline public function timesVector(rhs:Vec3):Vec3
	{
		var x = rhs.x;
		var y = rhs.y;
		var z = rhs.z;
		var w = rhs.w;
		rhs.x = m11 * x + m12 * y + m13 * z + m14 * w;
		rhs.y = m21 * x + m22 * y + m23 * z + m24 * w;
		rhs.z = m31 * x + m32 * y + m33 * z + m34 * w;
		rhs.w = m41 * x + m42 * y + m43 * z + m44 * w;
		return rhs;
	}
	
	/**
	 * Same as <em>timesVector()</em>, but without modifying <code>rhs</code>.
	 * @param output stores the result.
	 */
	inline public function timesVectorConst(rhs:Vec3, output:Vec3):Vec3
	{
		var x = rhs.x;
		var y = rhs.y;
		var z = rhs.z;
		var w = rhs.w;
		output.x = m11 * x + m12 * y + m13 * z + m14 * w;
		output.y = m21 * x + m22 * y + m23 * z + m24 * w;
		output.z = m31 * x + m32 * y + m33 * z + m34 * w;
		output.w = m41 * x + m42 * y + m43 * z + m44 * w;
		return output;
	}
	
	/** Computes the matrix transpose and returns this matrix. */
	inline public function transpose():Mat44
	{
		var t;
		t = m21; m21 = m12; m12 = t;
		t = m31; m31 = m13; m13 = t;
		t = m32; m32 = m23; m23 = t;
		t = m41; m41 = m14; m14 = t;
		t = m42; m42 = m24; m24 = t;
		t = m43; m43 = m34; m34 = t;
		return this;
	}
	
	/** Creates and returns a copy of this object. */
	public function copy():Mat44
	{
		var x = new Mat44();
		x.m11 = m11; x.m12 = m12; x.m13 = m13; x.m14 = m14;
		x.m21 = m21; x.m22 = m22; x.m23 = m23; x.m24 = m24;
		x.m31 = m31; x.m32 = m32; x.m33 = m33; x.m34 = m34;
		x.m41 = m41; x.m42 = m42; x.m43 = m43; x.m44 = m44;
		return x;
	}
	
	/**
	 * Copies all 16 matrix elements from the array <code>x</code>.
	 * @param columnMajor if true, 4 consecutive vector elements are interpreted as colums of the matrix, otherwise as the rows of the matrix.
	 */
	public function ofArray(x:Array<Float>, columnMajor = false):Mat44
	{
		if (columnMajor)
		{
			m11 = x[ 0]; m12 = x[ 4]; m13 = x[ 8]; m14 = x[12];
			m21 = x[ 1]; m22 = x[ 5]; m23 = x[ 9]; m24 = x[13];
			m31 = x[ 2]; m32 = x[ 6]; m33 = x[10]; m34 = x[14];
			m41 = x[ 3]; m42 = x[ 7]; m43 = x[11]; m44 = x[15];
		}
		else
		{
			m11 = x[ 0]; m12 = x[ 1]; m13 = x[ 2]; m14 = x[ 3];
			m21 = x[ 4]; m22 = x[ 5]; m23 = x[ 6]; m24 = x[ 7];
			m31 = x[ 8]; m32 = x[ 9]; m33 = x[10]; m34 = x[11];
			m41 = x[12]; m42 = x[13]; m43 = x[14]; m44 = x[15];
		}
		return this;
	}
	
	/**
	 * Writes all 16 matrix elements to the array <code>x</code>.
	 * @param columnMajor if true, elements will be stored in column-major format, otherwise in row-major format.
	 */
	public function toArray(x:Array<Float>, offset = -1, columnMajor = false):Array<Float>
	{
		if (offset == -1)
		{
			if (columnMajor)
			{
				x[ 0] = m11; x[ 4] = m12; x[ 8] = m13; x[12] = m14;
				x[ 1] = m21; x[ 5] = m22; x[ 9] = m23; x[13] = m24;
				x[ 2] = m31; x[ 6] = m32; x[10] = m33; x[14] = m34;
				x[ 3] = m41; x[ 7] = m42; x[11] = m43; x[15] = m44;
			}
			else
			{
				x[ 0] = m11; x[ 1] = m12; x[ 2] = m13; x[ 3] = m14;
				x[ 4] = m21; x[ 5] = m22; x[ 6] = m23; x[ 7] = m24;
				x[ 8] = m31; x[ 9] = m32; x[10] = m33; x[11] = m34;
				x[12] = m41; x[13] = m42; x[14] = m43; x[15] = m44;
			}
		}
		else
		{
			if (columnMajor)
			{
				x[offset + 0] = m11; x[offset + 4] = m12; x[offset +  8] = m13; x[offset + 12] = m14;
				x[offset + 1] = m21; x[offset + 5] = m22; x[offset +  9] = m23; x[offset + 13] = m24;
				x[offset + 2] = m31; x[offset + 6] = m32; x[offset + 10] = m33; x[offset + 14] = m34;
				x[offset + 3] = m41; x[offset + 7] = m42; x[offset + 11] = m43; x[offset + 15] = m44;
			}
			else
			{
				x[offset +  0] = m11; x[offset +  1] = m12; x[offset +  2] = m13; x[offset +  3] = m14;
				x[offset +  4] = m21; x[offset +  5] = m22; x[offset +  6] = m23; x[offset +  7] = m24;
				x[offset +  8] = m31; x[offset +  9] = m32; x[offset + 10] = m33; x[offset + 11] = m34;
				x[offset + 12] = m41; x[offset + 13] = m42; x[offset + 14] = m43; x[offset + 15] = m44;
			}
		}
		return x;
	}
	
	#if flash10
	var _scratchVector:flash.Vector<Float>;
	
	/**
	 * Writes all 16 matrix elements to the vector <code>x</code>.
	 * @param columnMajor if true, elements will be stored in column-major format, otherwise in row-major format.
	 */
	public function toVector(x:flash.Vector<Float>, offset = -1, columnMajor = false):flash.Vector<Float>
	{
		if (offset == -1)
		{
			if (columnMajor)
			{
				x[ 0] = m11; x[ 4] = m12; x[ 8] = m13; x[12] = m14;
				x[ 1] = m21; x[ 5] = m22; x[ 9] = m23; x[13] = m24;
				x[ 2] = m31; x[ 6] = m32; x[10] = m33; x[14] = m34;
				x[ 3] = m41; x[ 7] = m42; x[11] = m43; x[15] = m44;
			}
			else
			{
				x[ 0] = m11; x[ 1] = m12; x[ 2] = m13; x[ 3] = m14;
				x[ 4] = m21; x[ 5] = m22; x[ 6] = m23; x[ 7] = m24;
				x[ 8] = m31; x[ 9] = m32; x[10] = m33; x[11] = m34;
				x[12] = m41; x[13] = m42; x[14] = m43; x[15] = m44;
			}
		}
		else
		{
			if (columnMajor)
			{
				x[offset + 0] = m11; x[offset + 4] = m12; x[offset +  8] = m13; x[offset + 12] = m14;
				x[offset + 1] = m21; x[offset + 5] = m22; x[offset +  9] = m23; x[offset + 13] = m24;
				x[offset + 2] = m31; x[offset + 6] = m32; x[offset + 10] = m33; x[offset + 14] = m34;
				x[offset + 3] = m41; x[offset + 7] = m42; x[offset + 11] = m43; x[offset + 15] = m44;
			}
			else
			{
				x[offset +  0] = m11; x[offset +  1] = m12; x[offset +  2] = m13; x[offset +  3] = m14;
				x[offset +  4] = m21; x[offset +  5] = m22; x[offset +  6] = m23; x[offset +  7] = m24;
				x[offset +  8] = m31; x[offset +  9] = m32; x[offset + 10] = m33; x[offset + 11] = m34;
				x[offset + 12] = m41; x[offset + 13] = m42; x[offset + 14] = m43; x[offset + 15] = m44;
			}
		}
		return x;
	}
	
	/**
	 * Copies all 16 matrix elements from this matrix to the given matrix <code>x</code>.<br/>
	 * If <code>x</code> is omitted, a new Matrix3D object is created on the fly.
	 */
	public function toMatrix3D(x:flash.geom.Matrix3D = null):flash.geom.Matrix3D
	{
		if (x == null) x = new flash.geom.Matrix3D();
		if (_scratchVector == null)
			_scratchVector = new flash.Vector<Float>(16, true);
		x.rawData = toVector(_scratchVector);
		return x;
	}
	
	/**
	 * Copies all 16 matrix elements from the given matrix <code>x</code> into this matrix.<br/>
	 * if <code>x</code> is omitted, a new Matrix3D object is created on the fly.
	 */
	public function ofMatrix3D(x:flash.geom.Matrix3D = null):Mat44
	{
		if (x == null) x = new flash.geom.Matrix3D();
		var t = x.rawData;
		m11 = t[ 0]; m12 = t[ 1]; m13 = t[ 2]; m14 = t[ 3];
		m21 = t[ 4]; m22 = t[ 5]; m23 = t[ 6]; m24 = t[ 7];
		m31 = t[ 8]; m32 = t[ 9]; m33 = t[10]; m34 = t[11];
		m41 = t[12]; m42 = t[13]; m43 = t[14]; m44 = t[15];
		return this;
	}
	
	/**
	 * Copies all 16 matrix elements from the vector <code>x</code>.
	 * @param columnMajor if true, 4 consecutive vector elements are interpreted as colums of the matrix, otherwise as the rows of the matrix.
	 */
	public function ofVector(x:flash.Vector<Float>, columnMajor = false):Mat44
	{
		if (columnMajor)
		{
			m11 = x[ 0]; m12 = x[ 4]; m13 = x[ 8]; m14 = x[12];
			m21 = x[ 1]; m22 = x[ 5]; m23 = x[ 9]; m24 = x[13];
			m31 = x[ 2]; m32 = x[ 6]; m33 = x[10]; m34 = x[14];
			m41 = x[ 3]; m42 = x[ 7]; m43 = x[11]; m44 = x[15];
		}
		else
		{
			m11 = x[ 0]; m12 = x[ 1]; m13 = x[ 2]; m14 = x[ 3];
			m21 = x[ 4]; m22 = x[ 5]; m23 = x[ 6]; m24 = x[ 7];
			m31 = x[ 8]; m32 = x[ 9]; m33 = x[10]; m34 = x[11];
			m41 = x[12]; m42 = x[13]; m43 = x[14]; m44 = x[15];
		}
		return this;
	}
	#end
	
	/**
	 * Returns the string form of the value that this object represents.
	 */
	public function toString():String
	{
		var format = '\nMat44\n' +
			'%-+10.4f %-+10.4f %-+10.4f %-+10.4f\n' +
			'%-+10.4f %-+10.4f %-+10.4f %-+10.4f\n' +
			'%-+10.4f %-+10.4f %-+10.4f %-+10.4f\n' +
			'%-+10.4f %-+10.4f %-+10.4f %-+10.4f\n';
		return de.polygonal.core.fmt.Sprintf.format(format, [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44]);
	}
	
	inline function _fastTrig(angle:Float)
	{
		TrigApprox.sinCos(angle, _sineCosine);
	}
}