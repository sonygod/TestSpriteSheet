package map;

import flambe.math.Point;
/**
 * ...
 * @author ...
 */
class IsoUtils
{
    public static  var Y_CORRECT:Float = Math.cos( -Math.PI / 6) * Math.sqrt(2);
	
	public static function isoToScreen(pos:Point3D):Point
{
		var screenX:Float = pos.x - pos.z;
		var screenY:Float = pos.y * Y_CORRECT + (pos.x + pos.z) *0.5;
		return new Point(screenX, screenY);
}
	
	
	public static function screenToIso(point:Point):Point3D
{
		var xpos:Float = point.y + point.x * 0.5;
		var ypos:Float = 0;
		var zpos:Float = point.y - point.x * 0.5;
		return new Point3D(xpos, ypos, zpos);
}
}