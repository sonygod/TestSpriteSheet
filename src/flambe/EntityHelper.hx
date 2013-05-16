package flambe;
import flambe.Entity;
import flambe.math.Matrix;
import flambe.display.Sprite;
using Reflect;
/**
 * ...
 * @author ...
 */
class EntityHelper
{

	public  static function applychildsProperty(owner:Entity, filed:String, value:Dynamic) {
			
		var child :Entity= owner.firstChild;
      while (child != null) {
      var next = child.next; // Store in case the child is removed in process()
	 
     child.firstComponent.setField(filed, value);
      child = next;
	  }
		
		}
		
		public static  function applychildsMatrix(owner:Entity,m:Matrix) {
			
		var child :Entity= owner.firstChild;
      while (child != null) {
		  var next = child.next;
      if(Std.is(child.firstComponent,Sprite)){
       // untyped(child.firstComponent).
	   var target:Sprite = cast child.firstComponent;
	   target.getLocalMatrix().set(m.m00, m.m10, m.m01, m.m11, m.m02, m.m12);
        child = next;
	  }
	  }
		
		}
	
}